// backend/controllers/representante.controller.js
import { RepresentanteModel } from "../models/representante.model.js";
import { UserModel } from "../models/user.model.js";
import { TeacherModel } from "../models/teacher.model.js";
import { db } from "../db/connection.database.js";
import { capitalizeWords } from "../utils/formatters.js";

export const RepresentanteController = {
  // Crear representante desde preinscripción (o agregar estudiantes a existente)
  createFromPreinscripcion: async (req, res) => {
    try {
      let {
        dni, first_name, last_name, phone, email,
        parentesco, parentesco_otro, direccion,
        estudiantes, // Array de estudiantes
        id_representante, // Si viene, es un representante existente
        id_usuario_docente, // Si viene, es un docente vinculándose
        password // 🔐 RECIBIR CONTRASEÑA DEL FRONTEND
      } = req.body;

      first_name = capitalizeWords(first_name);
      last_name = capitalizeWords(last_name);

      console.log("📝 Recibida preinscripción:", {
        dni, email, parentesco, estudiantesCount: estudiantes?.length,
        esExistente: !!id_representante,
        id_usuario_docente: !!id_usuario_docente,
        tienePassword: !!password
      });

      // Validaciones básicas
      if (!dni || !first_name || !last_name || !email || !parentesco) {
        return res.status(400).json({
          ok: false,
          msg: "Faltan datos obligatorios del representante"
        });
      }

      let representante;
      let esNuevoRepresentante = false;

      // CASO 1: Buscar si ya existe por cédula como representante
      const existing = await RepresentanteModel.findByCedula(dni);

      // Si no existe como representante, verificar si existe como docente / usuario en general
      let existingUser = null;
      if (!existing) {
        if (id_usuario_docente) {
          existingUser = await UserModel.findOneById(id_usuario_docente);
        }
        if (!existingUser) {
          existingUser = await UserModel.findByCedula(dni);
        }
        if (!existingUser && email) {
          existingUser = await UserModel.findOneByEmail(email);
        }
      }

      if (existing) {
        // Representante EXISTENTE - solo usamos sus datos
        console.log("✅ Representante existente encontrado:", existing.id_representante);
        representante = {
          id_representante: existing.id_representante,
          id_usuario: existing.id_usuario,
          dni: existing.dni,
          first_name: existing.first_name,
          last_name: existing.last_name,
          email: existing.email,
          phone: existing.phone
        };
        esNuevoRepresentante = false;
      } else if (existingUser) {
        // CASO 2: Usuario EXISTENTE (Docente) - vincular como representante
        console.log("🔗 Vinculando usuario existente como representante:", existingUser.id);
        representante = await RepresentanteModel.linkExistingUserAsRepresentante(existingUser.id, {
          parentesco,
          parentesco_otro,
          direccion
        });
        esNuevoRepresentante = false;
      } else {
        // CASO 3: Representante NUEVO - crear usuario + representante
        console.log("🆕 Creando nuevo representante...");

        // Validar que la contraseña exista para nuevos representantes
        if (!password) {
          return res.status(400).json({
            ok: false,
            msg: "La contraseña es obligatoria para nuevos representantes"
          });
        }

        if (password.length < 4) {
          return res.status(400).json({
            ok: false,
            msg: "La contraseña debe tener al menos 4 caracteres"
          });
        }

        representante = await RepresentanteModel.create({
          dni,
          first_name,
          last_name,
          phone,
          email,
          parentesco,
          parentesco_otro,
          direccion,
          password // ✅ AHORA SÍ SE ENVÍA LA CONTRASEÑA
        });
        esNuevoRepresentante = true;
        console.log("✅ Nuevo representante creado:", representante.id_representante);
      }

      // Crear estudiantes asociados (tanto para nuevo como existente)
      const estudiantesCreados = [];
      if (estudiantes && estudiantes.length > 0) {
        // Mapeo de grados de danza a Id_nivel_danza (según tabla Nivel_Danza)
        const nivelDanzaMap = {
          'Pre-Ballet': 25,
          'Preparatorio': 6,
          '1er Grado': 7,  '1er Año': 7,
          '2do Grado': 8,  '2do Año': 8,
          '3er Grado': 9,  '3er Año': 9,
          '4to Grado': 10, '4to Año': 10,
          '5to Grado': 11, '5to Año': 11,
          '6to Grado': 12, '6to Año': 12,
          '7mo Grado': 13, '7mo Año': 13,
          '8vo Grado': 14, '8vo Año': 14
        };

        for (const estudiante of estudiantes) {
          // Mapear grado a Id_nivel_danza
          let Id_nivel_danza = null;
          if (estudiante.gradeLevel) {
            Id_nivel_danza = nivelDanzaMap[estudiante.gradeLevel] || null;
            if (!Id_nivel_danza) {
              try {
                const ndRes = await db.query(
                  'SELECT "Id_nivel_danza" FROM "Nivel_Danza" WHERE LOWER("nivel_danza") = LOWER($1) OR LOWER("nivel_danza") LIKE LOWER($2) LIMIT 1',
                  [estudiante.gradeLevel, `${estudiante.gradeLevel.replace('Grado', 'Año')}%`]
                );
                if (ndRes.rows.length > 0) {
                  Id_nivel_danza = ndRes.rows[0].Id_nivel_danza;
                }
              } catch (e) {
                console.error("Error buscando nivel_danza:", e);
              }
            }
          }

          // Generar cédula única para el estudiante
          const cedulaEstudiante = `E${Date.now()}${Math.floor(Math.random() * 1000)}`;

          // Crear estudiante con el ID del representante
          const studentQuery = {
            text: `
              INSERT INTO "Estudiante" (
                "nombre", "apellido", "cedula", "fecha_nacimiento", "genero",
                "seguro_escolar", "Id_nivel", "Id_nivel_danza", "Id_representante"
              ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
              RETURNING 
                "Id_estudiante" as id,
                "nombre" as first_name,
                "apellido" as last_name,
                "cedula" as dni
            `,
            values: [
              capitalizeWords(estudiante.name),
              capitalizeWords(estudiante.lastName),
              cedulaEstudiante,
              estudiante.birthDate,
              estudiante.gender,
              true, // seguro_escolar por defecto
              null, // Id_nivel: tabla Nivel_Escolar vacía, se deja null
              Id_nivel_danza,
              representante.id_representante
            ]
          };

          const result = await db.query(studentQuery.text, studentQuery.values);

          estudiantesCreados.push({
            ...result.rows[0],
            gradeLevel: estudiante.gradeLevel
          });
        }
      }

      // Preparar respuesta
      const response = {
        ok: true,
        msg: esNuevoRepresentante
          ? "Representante y estudiantes registrados exitosamente"
          : (representante.isExistingDocente
              ? "Docente vinculado como representante y estudiantes registrados exitosamente"
              : "Estudiantes agregados al representante existente"),
        representante: {
          id_representante: representante.id_representante,
          id_usuario: representante.id_usuario,
          dni: representante.dni,
          first_name: representante.first_name,
          last_name: representante.last_name,
          email: representante.email,
          phone: representante.phone,
          parentesco: parentesco,
          parentesco_otro: parentesco_otro,
          isExistingDocente: !!representante.isExistingDocente
        },
        estudiantes: estudiantesCreados
      };

      // Solo incluir credenciales si es NUEVO representante
      if (esNuevoRepresentante && representante.plainPassword) {
        response.representante.credenciales = {
          email: representante.email,
          password: representante.plainPassword
        };
        response.msg = response.msg + " - Las credenciales se muestran una sola vez";
      } else if (representante.isExistingDocente) {
        response.msg = response.msg + " - Inicie sesión con su usuario y contraseña habitual de Docente";
      } else {
        response.msg = response.msg + " - Las credenciales existentes no han sido modificadas";
      }

      res.status(201).json(response);

    } catch (error) {
      console.error("❌ Error en createFromPreinscripcion:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al procesar la preinscripción",
        error: error.message
      });
    }
  },

  // Buscar representantes
  searchRepresentantes: async (req, res) => {
    try {
      const { term } = req.query;

      if (!term || term.length < 2) {
        return res.json({
          ok: true,
          representantes: []
        });
      }

      const representantes = await RepresentanteModel.search(term);

      res.json({
        ok: true,
        representantes
      });

    } catch (error) {
      console.error("Error en searchRepresentantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al buscar representantes",
        error: error.message
      });
    }
  },

  // Obtener representante con sus estudiantes
  getRepresentanteConEstudiantes: async (req, res) => {
    try {
      const { id } = req.params;

      const representante = await RepresentanteModel.findById(id);
      if (!representante) {
        return res.status(404).json({
          ok: false,
          msg: "Representante no encontrado"
        });
      }

      const estudiantes = await RepresentanteModel.getEstudiantes(id);

      res.json({
        ok: true,
        representante,
        estudiantes
      });

    } catch (error) {
      console.error("Error en getRepresentanteConEstudiantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al obtener datos",
        error: error.message
      });
    }
  },



  // Listar todos los representantes
  listRepresentantes: async (req, res) => {
    try {
      console.log("📋 Listando todos los representantes...");

      const representantes = await RepresentanteModel.list();
      console.log(`✅ Representantes encontrados: ${representantes.length}`);

      res.json({
        ok: true,
        representantes,
        total: representantes.length
      });

    } catch (error) {
      console.error("Error en listRepresentantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al listar representantes",
        error: error.message
      });
    }
  },

  // Listar catálogo de grados
  listGrades: async (req, res) => {
    try {
      const grades = await TeacherModel.getAllGrades();
      res.json({
        ok: true,
        grades
      });
    } catch (error) {
      console.error("❌ Error en RepresentanteController.listGrades:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al listar grados",
        error: error.message
      });
    }
  },
};
