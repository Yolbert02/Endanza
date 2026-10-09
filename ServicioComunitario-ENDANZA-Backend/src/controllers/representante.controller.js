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
        dni,
        first_name,
        last_name,
        phone,
        email,
        parentesco,
        parentesco_otro,
        direccion,
        estudiantes, // Array de estudiantes
        id_representante, // Si viene, es un representante existente
        id_usuario_docente, // Si viene, es un docente vinculándose
        password, // 🔐 RECIBIR CONTRASEÑA DEL FRONTEND
      } = req.body;

      first_name = capitalizeWords(first_name);
      last_name = capitalizeWords(last_name);

      console.log("📝 Recibida preinscripción:", {
        dni,
        email,
        parentesco,
        estudiantesCount: estudiantes?.length,
        esExistente: !!id_representante,
        id_usuario_docente: !!id_usuario_docente,
        tienePassword: !!password,
      });

      // Validaciones básicas
      if (!dni || !first_name || !last_name || !email || !parentesco) {
        return res.status(400).json({
          ok: false,
          msg: "Faltan datos obligatorios del representante",
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
          id_persona: existing.id_persona,
          dni: existing.dni,
          first_name: existing.first_name,
          last_name: existing.last_name,
          email: existing.email,
          phone: existing.phone,
        };
        esNuevoRepresentante = false;
      } else if (existingUser) {
        // CASO 2: Usuario EXISTENTE (Docente) - vincular como representante
        console.log("🔗 Vinculando usuario existente como representante:", existingUser.id);
        representante = await RepresentanteModel.linkExistingUserAsRepresentante(
          existingUser.id,
          {
            parentesco,
            parentesco_otro,
            direccion,
          }
        );
        esNuevoRepresentante = false;
      } else {
        // CASO 3: Representante NUEVO - crear persona + usuario + representante
        console.log("🆕 Creando nuevo representante en NewEndanza...");

        if (!password) {
          return res.status(400).json({
            ok: false,
            msg: "La contraseña es obligatoria para nuevos representantes",
          });
        }

        if (password.length < 4) {
          return res.status(400).json({
            ok: false,
            msg: "La contraseña debe tener al menos 4 caracteres",
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
          password,
        });
        esNuevoRepresentante = true;
        console.log("✅ Nuevo representante creado:", representante.id_representante);
      }

      // Crear estudiantes asociados (tanto para nuevo como existente)
      const estudiantesCreados = [];
      if (estudiantes && estudiantes.length > 0) {
        let defaultEspecialidadId = 1;
        try {
          const espRes = await db.query(
            "SELECT id_especialidad FROM especialidad WHERE nombre_especialidad ILIKE '%Clásica%' OR activo = true ORDER BY id_especialidad LIMIT 1"
          );
          if (espRes.rows.length > 0) {
            defaultEspecialidadId = espRes.rows[0].id_especialidad;
          }
        } catch (e) {
          console.error("Error buscando especialidad:", e);
        }

        for (const estudiante of estudiantes) {
          let id_nivel_danza = null;
          if (estudiante.gradeLevel) {
            try {
              const ndRes = await db.query(
                "SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) OR LOWER(nivel_danza) LIKE LOWER($2) LIMIT 1",
                [estudiante.gradeLevel, `${estudiante.gradeLevel.replace("Grado", "Año")}%`]
              );
              if (ndRes.rows.length > 0) {
                id_nivel_danza = ndRes.rows[0].id_nivel_danza;
              }
            } catch (e) {
              console.error("Error buscando nivel_danza:", e);
            }
          }

          const cedulaEstudiante =
            estudiante.cedula && estudiante.cedula.trim() !== ""
              ? estudiante.cedula.trim()
              : null;

          let generoEnum = null;
          if (estudiante.gender) {
            const gLower = estudiante.gender.toLowerCase();
            if (gLower.startsWith("m")) generoEnum = "masculino";
            else if (gLower.startsWith("f")) generoEnum = "femenino";
          }

          const fnTokens = String(estudiante.name || '').trim().split(/\s+/).filter(Boolean);
          const lnTokens = String(estudiante.lastName || '').trim().split(/\s+/).filter(Boolean);
          const p1Nombre = capitalizeWords(fnTokens[0] || '');
          const p2Nombre = fnTokens.length > 1 ? capitalizeWords(fnTokens.slice(1).join(' ')) : null;
          const p1Apellido = capitalizeWords(lnTokens[0] || '');
          const p2Apellido = lnTokens.length > 1 ? capitalizeWords(lnTokens.slice(1).join(' ')) : null;

          // 1. Insertar persona del estudiante
          let studentPersonaId;
          if (cedulaEstudiante) {
            const checkP = await db.query(
              "SELECT id_persona FROM persona WHERE cedula = $1",
              [cedulaEstudiante]
            );
            if (checkP.rows.length > 0) {
              studentPersonaId = checkP.rows[0].id_persona;
            }
          }

          if (!studentPersonaId) {
            const pRes = await db.query(
              `INSERT INTO persona (nombre, segundo_nombre, apellido, segundo_apellido, cedula, fecha_nacimiento, genero)
               VALUES ($1, $2, $3, $4, $5, $6, $7)
               RETURNING id_persona`,
              [
                p1Nombre,
                p2Nombre,
                p1Apellido,
                p2Apellido,
                cedulaEstudiante,
                estudiante.birthDate || null,
                generoEnum,
              ]
            );
            studentPersonaId = pRes.rows[0].id_persona;
          }

          // 2. Insertar en tabla estudiante
          const studentRes = await db.query(
            `INSERT INTO estudiante (
               seguro_escolar, id_persona, id_representante, id_nivel_danza, id_especialidad
             ) VALUES (true, $1, $2, $3, $4)
             RETURNING id_estudiante as id`,
            [
              studentPersonaId,
              representante.id_representante,
              id_nivel_danza,
              defaultEspecialidadId,
            ]
          );

          const newStudentId = studentRes.rows[0].id;

          // 3. Vincular en tabla estudiante_familiar
          if (representante.id_persona) {
            const relParentesco =
              parentesco === "Otro" && parentesco_otro && parentesco_otro.trim()
                ? parentesco_otro.trim()
                : (parentesco || "Familiar");

            await db.query(
              `INSERT INTO estudiante_familiar (
                 id_estudiante, id_persona, parentesco, es_representante_legal, vive_con_estudiante
               ) VALUES ($1, $2, $3, true, true)`,
              [newStudentId, representante.id_persona, relParentesco]
            );
          }

          estudiantesCreados.push({
            id: newStudentId,
            first_name: studentFirstName,
            last_name: studentLastName,
            dni: cedulaEstudiante,
            gradeLevel: estudiante.gradeLevel,
          });
        }
      }

      // Preparar respuesta
      const response = {
        ok: true,
        msg: esNuevoRepresentante
          ? "Representante y estudiantes registrados exitosamente"
          : representante.isExistingDocente
          ? "Docente vinculado como representante y estudiantes registrados exitosamente"
          : "Estudiantes agregados al representante existente",
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
          isExistingDocente: !!representante.isExistingDocente,
        },
        estudiantes: estudiantesCreados,
      };

      if (esNuevoRepresentante && representante.plainPassword) {
        response.representante.credenciales = {
          email: representante.email,
          password: representante.plainPassword,
        };
        response.msg = response.msg + " - Las credenciales se muestran una sola vez";
      } else if (representante.isExistingDocente) {
        response.msg =
          response.msg + " - Inicie sesión con su usuario y contraseña habitual de Docente";
      } else {
        response.msg = response.msg + " - Las credenciales existentes no han sido modificadas";
      }

      res.status(201).json(response);
    } catch (error) {
      console.error("❌ Error en createFromPreinscripcion:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al procesar la preinscripción",
        error: error.message,
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
          representantes: [],
        });
      }

      const representantes = await RepresentanteModel.search(term);

      res.json({
        ok: true,
        representantes,
      });
    } catch (error) {
      console.error("Error en searchRepresentantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al buscar representantes",
        error: error.message,
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
          msg: "Representante no encontrado",
        });
      }

      const estudiantes = await RepresentanteModel.getEstudiantes(id);

      res.json({
        ok: true,
        representante,
        estudiantes,
      });
    } catch (error) {
      console.error("Error en getRepresentanteConEstudiantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al obtener datos",
        error: error.message,
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
        total: representantes.length,
      });
    } catch (error) {
      console.error("Error en listRepresentantes:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al listar representantes",
        error: error.message,
      });
    }
  },

  // Listar catálogo de grados
  listGrades: async (req, res) => {
    try {
      const grades = await TeacherModel.getAllGrades();
      res.json({
        ok: true,
        grades,
      });
    } catch (error) {
      console.error("❌ Error en RepresentanteController.listGrades:", error);
      res.status(500).json({
        ok: false,
        msg: "Error al listar grados",
        error: error.message,
      });
    }
  },
};
