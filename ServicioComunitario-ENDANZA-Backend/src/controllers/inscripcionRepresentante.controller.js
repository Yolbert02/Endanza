import { db } from "../db/connection.database.js";
import { RepresentanteModel } from "../models/representante.model.js";
import { StudentModel } from "../models/student.model.js";
import { EspecialidadModel } from "../models/especialidad.model.js";
import { capitalizeWords } from "../utils/formatters.js";

const resolveRepresentanteFromReq = async (req) => {
  const userId = req.user?.userId || req.user?.id;
  const representanteId = req.user?.representanteId;

  let representante = null;
  if (representanteId) {
    representante = await RepresentanteModel.findById(representanteId);
  }
  if (!representante && userId) {
    representante = await RepresentanteModel.findByUserId(userId);
  }
  if (!representante && req.user?.cedula) {
    representante = await RepresentanteModel.findByCedula(req.user.cedula);
  }
  return representante;
};

const checkStudentOwnership = (student, representante, userId) => {
  if (!student || !representante) return false;
  const repId = parseInt(representante.id_representante || representante.id);
  const studentRepId = parseInt(student.representative_id);
  const studentRepUserId = parseInt(student.representative_user_id);
  return studentRepId === repId || (userId && studentRepUserId === parseInt(userId));
};

export const InscripcionRepresentanteController = {

  /**
   * Completa la inscripción de un estudiante (solo para representantes, soporta rol dual)
   */
  completarInscripcion: async (req, res) => {
    try {
      const userId = req.user?.userId || req.user?.id;
      const {
        id_estudiante,
        id_ano_academico,
        datos_completos
      } = req.body;

      console.log("📝 Recibiendo inscripción completa:", {
        userId,
        id_estudiante,
        id_ano_academico
      });

      // 1. Validaciones básicas
      if (!id_estudiante) {
        return res.status(400).json({
          ok: false,
          msg: "El ID del estudiante es requerido"
        });
      }

      if (!id_ano_academico) {
        return res.status(400).json({
          ok: false,
          msg: "El año académico es requerido"
        });
      }

      // 2. Verificar que el usuario es representante (soporte rol dual o admin)
      const isAdmin = req.user?.roles?.includes('admin') || req.user?.roles?.includes('administrador') || req.user?.role === 'admin' || req.user?.Id_rol === 1 || req.user?.id_rol === 1;

      let representante = null;
      if (!isAdmin) {
        representante = await resolveRepresentanteFromReq(req);

        if (!representante) {
          return res.status(403).json({
            ok: false,
            msg: "No tienes permisos para realizar esta acción"
          });
        }
      }

      // 3. Verificar que el estudiante pertenece al representante
      const student = await StudentModel.findById(id_estudiante);

      if (!student) {
        return res.status(404).json({
          ok: false,
          msg: "Estudiante no encontrado"
        });
      }

      if (!isAdmin && !checkStudentOwnership(student, representante, userId)) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para inscribir este estudiante"
        });
      }

      if (!representante && student.representative_id) {
        representante = await RepresentanteModel.findById(student.representative_id);
      }

      // 3.1 Validación de inscripción única previa (antes de iniciar la transacción)
      const checkPreviaQuery = {
        text: `
          SELECT i.id_inscripcion, s.id_seccion, s.nombre_seccion
          FROM inscripcion i
          JOIN seccion s ON i.id_seccion = s.id_seccion
          WHERE i.id_estudiante = $1 AND i.id_ano = $2
          LIMIT 1
        `,
        values: [id_estudiante, id_ano_academico]
      };

      const inscripcionPrevia = await db.query(checkPreviaQuery.text, checkPreviaQuery.values);

      if (inscripcionPrevia.rows.length > 0) {
        return res.status(400).json({
          ok: false,
          msg: `El estudiante ya se encuentra inscrito en este período escolar (Sección: ${inscripcionPrevia.rows[0].nombre_seccion || 'Asignada'}).`,
          yaInscrito: true,
          data: {
            id_seccion: inscripcionPrevia.rows[0].id_seccion,
            nombre_seccion: inscripcionPrevia.rows[0].nombre_seccion
          }
        });
      }

      const datos = datos_completos || {};

      // 4. Iniciar transacción con cliente dedicado del pool
      const client = await db.pool.connect();

      try {
        await client.query('BEGIN');

        // Parsear talla y peso de forma segura
        let altura = null;
        if (datos.talla) {
          const valTalla = parseFloat(datos.talla);
          if (!isNaN(valTalla)) {
            altura = valTalla > 3 ? +(valTalla / 100).toFixed(2) : +valTalla.toFixed(2);
          }
        }

        const peso = datos.peso && !isNaN(parseFloat(datos.peso)) ? parseFloat(datos.peso) : null;

        // Mapear termino_nacimiento al enum válido
        let terminoNac = null;
        if (datos.nacimiento) {
          const nacLower = datos.nacimiento.toLowerCase().trim();
          if (nacLower === 'a_termino' || nacLower === 'a termino' || nacLower === 'a término') {
            terminoNac = 'a_termino';
          } else if (nacLower === 'prematuro') {
            terminoNac = 'prematuro';
          }
        }

        // 5. Crear historial médico (tabla: historial_medico en NewEndanza)
        const historialQuery = {
          text: `
            INSERT INTO historial_medico (
              peso_kg, altura_m, intolerancia_alimentos, descripcion_intolerancia,
              dolores_frecuentes, constipacion_frecuente, tiene_cirugia, descripcion_cirugia,
              control_hormonal, descripcion_control_hormonal, tiene_alergias,
              descripcion_alergias, historial_familiar_desc, termino_nacimiento
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
            RETURNING id_historia
          `,
          values: [
            peso,
            altura,
            datos.intolerancia === "Si",
            datos.textIntolerancia || null,
            false, // dolores_frecuentes (por defecto)
            false, // constipacion_frecuente (por defecto)
            datos.operaciones === "Si",
            datos.textOperaciones || null,
            datos.control_Hormonal === "Si",
            datos.textcontrolHormonal || null,
            datos.alergias === "Si",
            datos.textAlergia || null,
            datos.antecedentesFamiliares || null,
            terminoNac
          ]
        };

        const historialResult = await client.query(historialQuery.text, historialQuery.values);
        const id_historial = historialResult.rows[0].id_historia;
        console.log("✅ Historial médico creado con ID:", id_historial);

        // 6. Resolver escuela regular
        const id_escuela = datos.escuela ? await getOrCreateEscuela(datos.escuela, client) : null;

        // 7. Resolver seguro médico
        const id_seguro = datos.nombre_Seguro ? await getOrCreateSeguro(datos.nombre_Seguro, client) : null;

        // 8. Resolver nivel escolar desde la tabla nivel_escolar
        let id_nivel_escolar = null;
        if (datos.Grado_Escuela) {
          const nivelRes = await client.query(
            'SELECT id_nivel FROM nivel_escolar WHERE LOWER(nivel) = LOWER($1) LIMIT 1',
            [datos.Grado_Escuela.trim()]
          );
          if (nivelRes.rows.length > 0) {
            id_nivel_escolar = nivelRes.rows[0].id_nivel;
          }
        }

        // 9. Resolver nivel de danza desde la tabla nivel_danza
        let id_nivel_danza = null;
        if (datos.grado) {
          // Mapear el value del frontend al nombre en la BD (en ENDANZA son Grados, no Años)
          const gradoMap = {
            'pre_ballet': 'Pre-Ballet',
            'preparatorio': 'Preparatorio',
            '1er_grado': '1er Grado',
            '2do_grado': '2do Grado',
            '3er_grado': '3er Grado',
            '4to_grado': '4to Grado',
            '5to_grado': '5to Grado',
            '6to_grado': '6to Grado',
            '7mo_grado': '7mo Grado',
            '8vo_grado': '8vo Grado'
          };

          const baseGrado = gradoMap[datos.grado] || datos.grado;
          let gradoBuscar = baseGrado;

          // Si tiene especialidad, buscar primero con el sufijo de especialidad
          if (datos.especialidad && ['5to_grado', '6to_grado', '7mo_grado', '8vo_grado'].includes(datos.grado)) {
            gradoBuscar = `${baseGrado} - ${datos.especialidad}`;
          }

          // 1) Búsqueda exacta (con o sin especialidad)
          let ndRes = await client.query(
            'SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) LIMIT 1',
            [gradoBuscar]
          );

          // 2) Si no encontró y buscaba con especialidad, intentar con grado base
          if (ndRes.rows.length === 0 && gradoBuscar !== baseGrado) {
            ndRes = await client.query(
              'SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) LIMIT 1',
              [baseGrado]
            );
          }

          // 3) Búsqueda parcial si aún no se encuentra
          if (ndRes.rows.length === 0) {
            ndRes = await client.query(
              'SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) LIKE LOWER($1) LIMIT 1',
              [`%${baseGrado}%`]
            );
          }

          if (ndRes.rows.length > 0) {
            id_nivel_danza = ndRes.rows[0].id_nivel_danza;
          }
        }

        // 10. Resolver especialidad
        let idEspecialidad = datos.id_especialidad || datos.especialidad_id || datos.Id_especialidad || null;
        if (!idEspecialidad && datos.especialidad) {
          const espFound = await EspecialidadModel.findByName(datos.especialidad);
          if (espFound) {
            idEspecialidad = espFound.id;
          }
        }
        if (!idEspecialidad && (student.specialty_id || student.Id_especialidad)) {
          idEspecialidad = student.specialty_id || student.Id_especialidad;
        }

        const seguroEscolar = datos.Seguro_Escolar === "si" || datos.Seguro_Escolar === true;

        // 11. Actualizar tabla estudiante
        await client.query(
          `UPDATE estudiante SET 
            id_historia = $1,
            id_escuela = $2,
            id_seguro = $3,
            id_nivel = $4,
            id_nivel_danza = $5,
            id_especialidad = $6,
            seguro_escolar = $7
           WHERE id_estudiante = $8`,
          [
            id_historial,
            id_escuela,
            id_seguro,
            id_nivel_escolar,
            id_nivel_danza,
            idEspecialidad,
            seguroEscolar,
            id_estudiante
          ]
        );
        console.log("✅ Estudiante actualizado");

        // 12. Guardar datos de los padres (madre y padre) usando estudiante_familiar + persona
        await guardarFamiliares(id_estudiante, datos, client);

        // 13. Actualizar datos del representante según quién es
        await actualizarDatosRepresentante(representante, datos, client);

        // 14. Buscar o crear sección y crear inscripción
        const id_seccion = await obtenerOCrearSeccion(id_ano_academico, id_nivel_danza, client, idEspecialidad);

        // 15. Insertar inscripción en la tabla inscripcion
        const inscripcionQuery = {
          text: `
            INSERT INTO inscripcion (id_estudiante, id_ano, id_seccion, estado_inscripcion, fecha_inscripcion)
            VALUES ($1, $2, $3, 'activo', NOW())
            RETURNING id_inscripcion
          `,
          values: [id_estudiante, id_ano_academico, id_seccion]
        };

        await client.query(inscripcionQuery.text, inscripcionQuery.values);

        await client.query('COMMIT');

        // Generar código de inscripción
        const codigoInscripcion = `INS-${id_ano_academico}-${id_estudiante}-${Date.now().toString().slice(-6)}`;

        return res.status(201).json({
          ok: true,
          msg: "Inscripción completada exitosamente",
          data: {
            codigo: codigoInscripcion,
            id_estudiante,
            id_ano_academico,
            id_seccion
          }
        });

      } catch (error) {
        await client.query('ROLLBACK');
        throw error;
      } finally {
        client.release();
      }

    } catch (error) {
      console.error("❌ Error en completarInscripcion:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al completar la inscripción",
        error: error.message
      });
    }
  },

  /**
   * Verifica si un estudiante ya está inscrito en el año actual
   */
  verificarInscripcion: async (req, res) => {
    try {
      const userId = req.user?.userId;
      const { studentId } = req.params;
      const { ano } = req.query;

      if (!studentId || !ano) {
        return res.status(400).json({
          ok: false,
          msg: "Se requiere ID de estudiante y año académico"
        });
      }

      // Verificar que el usuario es representante (soporte rol dual)
      const representante = await resolveRepresentanteFromReq(req);

      if (!representante) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permisos"
        });
      }

      // Verificar que el estudiante pertenece al representante
      const student = await StudentModel.findById(studentId);

      if (!student || !checkStudentOwnership(student, representante, userId)) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para ver este estudiante"
        });
      }

      // Verificar inscripción en el año escolar (tabla: inscripcion + seccion)
      const query = {
        text: `
          SELECT i.id_inscripcion, s.id_seccion, s.nombre_seccion
          FROM inscripcion i
          JOIN seccion s ON i.id_seccion = s.id_seccion
          WHERE i.id_estudiante = $1 AND i.id_ano = $2
          LIMIT 1
        `,
        values: [studentId, ano]
      };

      const result = await db.query(query.text, query.values);
      const estaInscrito = result.rows.length > 0;

      return res.json({
        ok: true,
        data: {
          inscrito: estaInscrito,
          seccion: estaInscrito ? result.rows[0].nombre_seccion : null,
          id_seccion: estaInscrito ? result.rows[0].id_seccion : null
        }
      });

    } catch (error) {
      console.error("Error verificando inscripción:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al verificar inscripción",
        error: error.message
      });
    }
  },

  /**
   * Obtiene todos los datos precargados del estudiante y su representante para el formulario
   */
  obtenerDatosPrecarga: async (req, res) => {
    try {
      const userId = req.user?.userId;
      const { studentId } = req.params;
      const { ano } = req.query;

      if (!studentId) {
        return res.status(400).json({
          ok: false,
          msg: "El ID del estudiante es requerido"
        });
      }

      // 1. Verificar representante (soporte rol dual o admin)
      const isAdmin = req.user?.roles?.includes('admin') || req.user?.roles?.includes('administrador') || req.user?.role === 'admin' || req.user?.Id_rol === 1 || req.user?.id_rol === 1;

      let representante = null;
      if (!isAdmin) {
        representante = await resolveRepresentanteFromReq(req);
        if (!representante) {
          return res.status(403).json({
            ok: false,
            msg: "No tienes permisos para realizar esta acción"
          });
        }
      }

      // 2. Verificar estudiante (usa StudentModel que ya trabaja con NewEndanza)
      const student = await StudentModel.findById(studentId);
      if (!student) {
        return res.status(404).json({
          ok: false,
          msg: "Estudiante no encontrado"
        });
      }

      if (!isAdmin && !checkStudentOwnership(student, representante, userId)) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para consultar este estudiante"
        });
      }

      if (!representante && student.representative_id) {
        representante = await RepresentanteModel.findById(student.representative_id);
      }

      // 3. Obtener historial médico completo si existe (tabla: historial_medico)
      let historial = {};
      const histId = student.medical_history_id;
      if (histId) {
        const histRes = await db.query(
          'SELECT * FROM historial_medico WHERE id_historia = $1',
          [histId]
        );
        if (histRes.rows.length > 0) {
          historial = histRes.rows[0];
        }
      }

      // 4. Obtener familiares asociados desde estudiante_familiar + persona
      const familiaresRes = await db.query(`
        SELECT ef.parentesco, ef.es_representante_legal, ef.vive_con_estudiante,
               p.nombre, p.apellido, p.cedula, p.numero_telefono, p.email, p.genero
        FROM estudiante_familiar ef
        JOIN persona p ON ef.id_persona = p.id_persona
        WHERE ef.id_estudiante = $1
        ORDER BY ef.id_estudiante_familiar ASC
      `, [studentId]);

      // Identificar madre y padre por parentesco
      const madre = familiaresRes.rows.find(r => r.parentesco === 'Madre') || null;
      const padre = familiaresRes.rows.find(r => r.parentesco === 'Padre') || null;

      // 5. Verificar si ya se encuentra inscrito en el año especificado (tabla: inscripcion)
      let yaInscrito = false;
      let inscripcionData = null;
      if (ano) {
        const checkQuery = {
          text: `
            SELECT i.id_inscripcion, s.id_seccion, s.nombre_seccion, i.id_ano
            FROM inscripcion i
            JOIN seccion s ON i.id_seccion = s.id_seccion
            WHERE i.id_estudiante = $1 AND i.id_ano = $2
            LIMIT 1
          `,
          values: [studentId, ano]
        };
        const checkRes = await db.query(checkQuery.text, checkQuery.values);
        if (checkRes.rows.length > 0) {
          yaInscrito = true;
          inscripcionData = checkRes.rows[0];
        }
      }

      // 6. Obtener dirección del usuario representante
      const repPersonaId = representante ? (representante.id_persona || null) : null;
      let direccionHab = student.address || "";

      return res.json({
        ok: true,
        data: {
          estudiante: {
            id: student.id,
            nombres: student.first_name,
            apellidos: student.last_name,
            cedula: student.dni,
            fecha_nacimiento: student.birth_date,
            genero: student.gender,
            direccion: direccionHab,
            telefono: "",
            grado_escuela: student.grade_level_name || "",
            escuela: student.school_name || "",
            seguro_escolar: student.school_insurance || false,
            nombre_seguro: student.insurance_name || "",
            dance_level_name: student.dance_level_name || "",
            grade_level_name: student.grade_level_name || "",
            especialidad: student.specialty_name || student.nombre_especialidad || student.especialidad || "",
            id_especialidad: student.specialty_id || student.Id_especialidad || null,
            especialidad_id: student.specialty_id || student.Id_especialidad || null
          },
          representante: representante ? {
            id: representante.id_representante || representante.id,
            nombres: student.representative_first_name || representante.nombre || representante.first_name,
            apellidos: student.representative_last_name || representante.apellido || representante.last_name,
            cedula: student.representative_dni || representante.cedula || representante.dni,
            telefono: student.representative_phone || "",
            correo: student.representative_email || representante.email,
            parentesco: student.representative_relationship || "Madre",
            profesion: student.representative_occupation || representante.profesion_rep || "",
            direccion_trabajo: representante.direccion || "",
            genero: student.representative_gender || ""
          } : {
            id: null,
            nombres: student.representative_first_name || "",
            apellidos: student.representative_last_name || "",
            cedula: student.representative_dni || "",
            telefono: student.representative_phone || "",
            correo: student.representative_email || "",
            parentesco: student.representative_relationship || "Madre",
            profesion: "",
            direccion_trabajo: "",
            genero: student.representative_gender || ""
          },
          quien_es_representante: (() => {
            const relFromModel = student.representative_relationship;
            if (relFromModel && relFromModel !== 'Madre') return relFromModel;
            const genero = (student.representative_gender || '').toLowerCase();
            if (genero.startsWith('m') && genero !== 'masculino') {
              // 'm' could be masculino too, check more carefully
            }
            if (genero === 'masculino' || genero === 'male') {
              return 'Padre';
            }
            return relFromModel || 'Madre';
          })(),
          madre: madre ? {
            nombre: madre.nombre,
            apellido: madre.apellido,
            cedula: madre.cedula,
            profesion: "",
            direccion_trabajo: "",
            telefono: madre.numero_telefono || ""
          } : null,
          padre: padre ? {
            nombre: padre.nombre,
            apellido: padre.apellido,
            cedula: padre.cedula,
            profesion: "",
            direccion_trabajo: "",
            telefono: padre.numero_telefono || ""
          } : null,
          historial_medico: {
            peso: historial.peso_kg ? parseFloat(historial.peso_kg).toString() : "",
            talla: historial.altura_m ? Math.round(parseFloat(historial.altura_m) * 100).toString() : "",
            tipo_sangre: student.blood_type || "",
            intolerancia: historial.intolerancia_alimentos ? "Si" : "No",
            textIntolerancia: historial.descripcion_intolerancia || "",
            operaciones: historial.tiene_cirugia ? "Si" : "No",
            textOperaciones: historial.descripcion_cirugia || "",
            control_hormonal: historial.control_hormonal ? "Si" : "No",
            textcontrolHormonal: historial.descripcion_control_hormonal || "",
            alergias: historial.tiene_alergias ? "Si" : "No",
            textAlergia: historial.descripcion_alergias || "",
            termino_nacimiento: historial.termino_nacimiento || "",
            antecedentes_familiares: historial.historial_familiar_desc || ""
          },
          inscripcion_actual: {
            ya_inscrito: yaInscrito,
            seccion: inscripcionData ? inscripcionData.nombre_seccion : null,
            id_seccion: inscripcionData ? inscripcionData.id_seccion : null
          }
        }
      });

    } catch (error) {
      console.error("❌ Error en obtenerDatosPrecarga:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al precargar datos de inscripción",
        error: error.message
      });
    }
  }
};

// ============================================
// FUNCIONES AUXILIARES (CON SOPORTE TRANSACCIONAL)
// ============================================

/**
 * Guarda los datos de la madre y el padre usando la tabla persona + estudiante_familiar.
 * Busca o crea persona por cédula, luego vincula con estudiante_familiar.
 */
async function guardarFamiliares(id_estudiante, datos, client = db) {
  try {
    console.log("👪 Guardando familiares para estudiante:", id_estudiante);

    // Guardar MADRE
    if (datos.nombre_Madre && datos.apellido_Madre) {
      const nombreMadre = capitalizeWords(datos.nombre_Madre);
      const apellidoMadre = capitalizeWords(datos.apellido_Madre);
      const cedulaMadre = datos.cedula_Madre || null;
      const ocupacionMadre = datos.ocupacion_Madre || null;
      const trabajoMadre = datos.trabajo_Madre || datos.lugar_trabajo_Madre || null;
      const dirTrabajoMadre = datos.direccion_Trabajo_Madre || datos.direccion_trabajo_Madre || null;
      const telTrabajoMadre = datos.telefono_trabajo_Madre || null;

      console.log("📝 Procesando madre:", nombreMadre, apellidoMadre);

      let personaIdMadre;

      // Buscar persona existente por cédula
      if (cedulaMadre) {
        const existRes = await client.query(
          'SELECT id_persona FROM persona WHERE cedula = $1',
          [cedulaMadre]
        );
        if (existRes.rows.length > 0) {
          personaIdMadre = existRes.rows[0].id_persona;
          // Actualizar datos
          await client.query(
            `UPDATE persona SET nombre = $1, apellido = $2, genero = 'femenino',
             numero_telefono = COALESCE($3, numero_telefono),
             ocupacion = COALESCE($4, ocupacion)
             WHERE id_persona = $5`,
            [nombreMadre, apellidoMadre, datos.telefono_Madre || null, ocupacionMadre, personaIdMadre]
          );
        }
      }

      if (!personaIdMadre) {
        // Crear nueva persona
        const insertRes = await client.query(
          `INSERT INTO persona (nombre, apellido, cedula, numero_telefono, genero, ocupacion)
           VALUES ($1, $2, $3, $4, 'femenino', $5)
           RETURNING id_persona`,
          [nombreMadre, apellidoMadre, cedulaMadre, datos.telefono_Madre || null, ocupacionMadre]
        );
        personaIdMadre = insertRes.rows[0].id_persona;
      }

      // Verificar si ya existe vínculo en estudiante_familiar
      const vincExist = await client.query(
        'SELECT id_estudiante_familiar FROM estudiante_familiar WHERE id_estudiante = $1 AND id_persona = $2',
        [id_estudiante, personaIdMadre]
      );

      if (vincExist.rows.length === 0) {
        await client.query(
          `INSERT INTO estudiante_familiar (id_estudiante, id_persona, parentesco, es_representante_legal, vive_con_estudiante, ocupacion, lugar_trabajo, direccion_trabajo, telefono_trabajo)
           VALUES ($1, $2, 'Madre', false, true, $3, $4, $5, $6)`,
          [id_estudiante, personaIdMadre, ocupacionMadre, trabajoMadre, dirTrabajoMadre, telTrabajoMadre]
        );
      } else {
        await client.query(
          `UPDATE estudiante_familiar 
           SET parentesco = 'Madre',
               ocupacion = COALESCE($1, ocupacion),
               lugar_trabajo = COALESCE($2, lugar_trabajo),
               direccion_trabajo = COALESCE($3, direccion_trabajo),
               telefono_trabajo = COALESCE($4, telefono_trabajo)
           WHERE id_estudiante = $5 AND id_persona = $6`,
          [ocupacionMadre, trabajoMadre, dirTrabajoMadre, telTrabajoMadre, id_estudiante, personaIdMadre]
        );
      }

      console.log("✅ Madre vinculada con ID persona:", personaIdMadre);
    }

    // Guardar PADRE
    if (datos.nombre_Padre && datos.apellido_Padre) {
      const nombrePadre = capitalizeWords(datos.nombre_Padre);
      const apellidoPadre = capitalizeWords(datos.apellido_Padre);
      const cedulaPadre = datos.cedula_Padre || null;
      const ocupacionPadre = datos.ocupacion_Padre || null;
      const trabajoPadre = datos.trabajo_Padre || datos.lugar_trabajo_Padre || null;
      const dirTrabajoPadre = datos.direccion_Trabajo_Padre || datos.direccion_trabajo_Padre || null;
      const telTrabajoPadre = datos.telefono_trabajo_Padre || null;

      console.log("📝 Procesando padre:", nombrePadre, apellidoPadre);

      let personaIdPadre;

      // Buscar persona existente por cédula
      if (cedulaPadre) {
        const existRes = await client.query(
          'SELECT id_persona FROM persona WHERE cedula = $1',
          [cedulaPadre]
        );
        if (existRes.rows.length > 0) {
          personaIdPadre = existRes.rows[0].id_persona;
          // Actualizar datos
          await client.query(
            `UPDATE persona SET nombre = $1, apellido = $2, genero = 'masculino',
             numero_telefono = COALESCE($3, numero_telefono),
             ocupacion = COALESCE($4, ocupacion)
             WHERE id_persona = $5`,
            [nombrePadre, apellidoPadre, datos.telefono_Padre || null, ocupacionPadre, personaIdPadre]
          );
        }
      }

      if (!personaIdPadre) {
        // Crear nueva persona
        const insertRes = await client.query(
          `INSERT INTO persona (nombre, apellido, cedula, numero_telefono, genero, ocupacion)
           VALUES ($1, $2, $3, $4, 'masculino', $5)
           RETURNING id_persona`,
          [nombrePadre, apellidoPadre, cedulaPadre, datos.telefono_Padre || null, ocupacionPadre]
        );
        personaIdPadre = insertRes.rows[0].id_persona;
      }

      // Verificar si ya existe vínculo en estudiante_familiar
      const vincExist = await client.query(
        'SELECT id_estudiante_familiar FROM estudiante_familiar WHERE id_estudiante = $1 AND id_persona = $2',
        [id_estudiante, personaIdPadre]
      );

      if (vincExist.rows.length === 0) {
        await client.query(
          `INSERT INTO estudiante_familiar (id_estudiante, id_persona, parentesco, es_representante_legal, vive_con_estudiante, ocupacion, lugar_trabajo, direccion_trabajo, telefono_trabajo)
           VALUES ($1, $2, 'Padre', false, true, $3, $4, $5, $6)`,
          [id_estudiante, personaIdPadre, ocupacionPadre, trabajoPadre, dirTrabajoPadre, telTrabajoPadre]
        );
      } else {
        await client.query(
          `UPDATE estudiante_familiar 
           SET parentesco = 'Padre',
               ocupacion = COALESCE($1, ocupacion),
               lugar_trabajo = COALESCE($2, lugar_trabajo),
               direccion_trabajo = COALESCE($3, direccion_trabajo),
               telefono_trabajo = COALESCE($4, telefono_trabajo)
           WHERE id_estudiante = $5 AND id_persona = $6`,
          [ocupacionPadre, trabajoPadre, dirTrabajoPadre, telTrabajoPadre, id_estudiante, personaIdPadre]
        );
      }

      console.log("✅ Padre vinculado con ID persona:", personaIdPadre);
    }

    console.log("✅ Familiares guardados exitosamente");

  } catch (error) {
    console.error("❌ Error en guardarFamiliares:", error);
    throw error;
  }
}

/**
 * Actualiza los datos del representante (profesión, dirección de trabajo)
 * según quién fue seleccionado como representante (Madre, Padre u Otro).
 */
async function actualizarDatosRepresentante(representante, datos, client = db) {
  try {
    const repId = representante.id_representante || representante.id;
    const quienEsRep = datos.quien_es_representante || 'Madre';

    console.log(`📋 Actualizando representante ID=${repId}, tipo=${quienEsRep}`);

    let profesion = null;
    let lugarTrabajo = null;
    let direccionTrabajo = null;
    let telefonoTrabajo = null;

    if (quienEsRep === 'Madre') {
      profesion = datos.ocupacion_Madre || null;
      lugarTrabajo = datos.trabajo_Madre || datos.lugar_trabajo_Madre || null;
      direccionTrabajo = datos.direccion_Trabajo_Madre || datos.direccion_trabajo_Madre || null;
      telefonoTrabajo = datos.telefono_trabajo_Madre || null;
    } else if (quienEsRep === 'Padre') {
      profesion = datos.ocupacion_Padre || null;
      lugarTrabajo = datos.trabajo_Padre || datos.lugar_trabajo_Padre || null;
      direccionTrabajo = datos.direccion_Trabajo_Padre || datos.direccion_trabajo_Padre || null;
      telefonoTrabajo = datos.telefono_trabajo_Padre || null;
    } else {
      // Otro representante
      profesion = datos.profesion_Rep || null;
      lugarTrabajo = datos.trabajo_Rep || null;
      direccionTrabajo = datos.direccion_Trabajo_Rep || null;
      telefonoTrabajo = datos.telefono_trabajo_Rep || null;
    }

    // Actualizar campos del representante (tabla: representante en NewEndanza)
    await client.query(`
      UPDATE representante SET
        profesion = COALESCE($1, profesion),
        lugar_trabajo = COALESCE($2, lugar_trabajo),
        direccion_trabajo = COALESCE($3, direccion_trabajo),
        telefono_trabajo = COALESCE($4, telefono_trabajo)
      WHERE id_representante = $5
    `, [profesion, lugarTrabajo, direccionTrabajo, telefonoTrabajo, repId]);

    // Actualizar el parentesco en estudiante_familiar si existe el vínculo
    const repPersonaId = representante.id_persona;
    if (repPersonaId) {
      // Buscar todos los estudiantes de este representante
      const estudiantesRes = await client.query(
        'SELECT id_estudiante FROM estudiante WHERE id_representante = $1',
        [repId]
      );

      for (const est of estudiantesRes.rows) {
        // Verificar o crear vínculo en estudiante_familiar
        const vincExist = await client.query(
          'SELECT id_estudiante_familiar FROM estudiante_familiar WHERE id_estudiante = $1 AND id_persona = $2',
          [est.id_estudiante, repPersonaId]
        );

        if (vincExist.rows.length > 0) {
          await client.query(
            `UPDATE estudiante_familiar 
             SET parentesco = $1, 
                 es_representante_legal = true,
                 ocupacion = COALESCE($4, ocupacion),
                 lugar_trabajo = COALESCE($5, lugar_trabajo),
                 direccion_trabajo = COALESCE($6, direccion_trabajo),
                 telefono_trabajo = COALESCE($7, telefono_trabajo)
             WHERE id_estudiante = $2 AND id_persona = $3`,
            [quienEsRep, est.id_estudiante, repPersonaId, profesion, lugarTrabajo, direccionTrabajo, telefonoTrabajo]
          );
        } else {
          await client.query(
            `INSERT INTO estudiante_familiar (id_estudiante, id_persona, parentesco, es_representante_legal, vive_con_estudiante, ocupacion, lugar_trabajo, direccion_trabajo, telefono_trabajo)
             VALUES ($1, $2, $3, true, true, $4, $5, $6, $7)`,
            [est.id_estudiante, repPersonaId, quienEsRep, profesion, lugarTrabajo, direccionTrabajo, telefonoTrabajo]
          );
        }
      }
    }

    console.log(`✅ Representante actualizado: profesion=${profesion}, lugar_trabajo=${lugarTrabajo}`);

  } catch (error) {
    console.error("⚠️ Error actualizando representante (no crítico):", error.message);
    // No lanzar error - no es crítico para la inscripción
  }
}

/**
 * Obtiene o crea una escuela regular (tabla: escuela_regular)
 */
async function getOrCreateEscuela(nombreEscuela, client = db) {
  if (!nombreEscuela) return null;

  try {
    const result = await client.query(
      'SELECT id_escuela FROM escuela_regular WHERE LOWER(nombre_escuela) = LOWER($1)',
      [nombreEscuela]
    );

    if (result.rows.length > 0) {
      return result.rows[0].id_escuela;
    }

    const insertResult = await client.query(
      'INSERT INTO escuela_regular (nombre_escuela) VALUES ($1) RETURNING id_escuela',
      [nombreEscuela]
    );
    return insertResult.rows[0].id_escuela;
  } catch (error) {
    console.error("Error en getOrCreateEscuela:", error);
    return null;
  }
}

/**
 * Obtiene o crea un seguro médico (tabla: seguro_medico)
 */
async function getOrCreateSeguro(tipoSeguro, client = db) {
  if (!tipoSeguro) return null;

  try {
    const result = await client.query(
      'SELECT id_seguro FROM seguro_medico WHERE LOWER(tipo_seguro) = LOWER($1)',
      [tipoSeguro]
    );

    if (result.rows.length > 0) {
      return result.rows[0].id_seguro;
    }

    const insertResult = await client.query(
      'INSERT INTO seguro_medico (tipo_seguro) VALUES ($1) RETURNING id_seguro',
      [tipoSeguro]
    );
    return insertResult.rows[0].id_seguro;
  } catch (error) {
    console.error("Error en getOrCreateSeguro:", error);
    return null;
  }
}

/**
 * Obtiene o crea una sección para el estudiante
 * Tabla: seccion (columnas: id_seccion, nombre_seccion, id_ano, id_nivel_danza, id_especialidad)
 */
async function obtenerOCrearSeccion(id_ano_academico, id_nivel_danza, client = db, idEspecialidad = null) {
  // Buscar sección disponible que coincida en año, nivel de danza y especialidad
  const seccionQuery = {
    text: `
      SELECT s.id_seccion
      FROM seccion s
      WHERE s.id_ano = $1 
        AND (
          ($2::INTEGER IS NULL AND s.id_nivel_danza IS NULL)
          OR s.id_nivel_danza = $2::INTEGER
        )
        AND (
          ($3::INTEGER IS NULL AND s.id_especialidad IS NULL)
          OR s.id_especialidad = $3::INTEGER
        )
      ORDER BY s.nombre_seccion ASC
      LIMIT 1
    `,
    values: [id_ano_academico, id_nivel_danza, idEspecialidad]
  };

  const seccionResult = await client.query(seccionQuery.text, seccionQuery.values);

  if (seccionResult.rows.length > 0) {
    return seccionResult.rows[0].id_seccion;
  }

  // Si no existe, crear nueva sección
  const crearSeccionQuery = {
    text: `
      INSERT INTO seccion (
        nombre_seccion, id_ano, id_nivel_danza, id_especialidad
      ) VALUES ($1, $2, $3, $4)
      RETURNING id_seccion
    `,
    values: [
      'A',
      id_ano_academico,
      id_nivel_danza,
      idEspecialidad
    ]
  };

  const nuevaSeccion = await client.query(crearSeccionQuery.text, crearSeccionQuery.values);
  console.log("✅ Nueva sección creada con ID:", nuevaSeccion.rows[0].id_seccion);
  return nuevaSeccion.rows[0].id_seccion;
}