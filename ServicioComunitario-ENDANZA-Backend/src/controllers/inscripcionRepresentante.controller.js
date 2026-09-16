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

      // 2. Verificar que el usuario es representante (soporte rol dual)
      const representante = await resolveRepresentanteFromReq(req);

      if (!representante) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permisos para realizar esta acción"
        });
      }

      // 3. Verificar que el estudiante pertenece al representante
      const student = await StudentModel.findById(id_estudiante);

      if (!student) {
        return res.status(404).json({
          ok: false,
          msg: "Estudiante no encontrado"
        });
      }

      if (!checkStudentOwnership(student, representante, userId)) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para inscribir este estudiante"
        });
      }

      // 3.1 Validación de inscripción única previa (antes de iniciar la transacción)
      const checkPreviaQuery = {
        text: `
          SELECT es."Id_estudiante_seccion", s."Id_seccion", s."nombre_seccion"
          FROM "Estudiante_Seccion" es
          JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
          WHERE es."Id_estudiante" = $1 AND s."Id_ano" = $2
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
            id_seccion: inscripcionPrevia.rows[0].Id_seccion,
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

        // 5. Crear historial médico
        const historialQuery = {
          text: `
            INSERT INTO "Historial_Medico" (
              peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia,
              dolores_frecuentes, tiene_cirugia, descripcion_cirugia,
              control_hormonal, descripcion_hormonal, tiene_alergias,
              descripcion_alergias, antecedentes_familiares, termino_nacimiento,
              tipo_sangre
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
            RETURNING "Id_historial" as id
          `,
          values: [
            peso,
            altura,
            datos.intolerancia === "Si",
            datos.textIntolerancia || null,
            false, // dolores_frecuentes (por defecto)
            datos.operaciones === "Si",
            datos.textOperaciones || null,
            datos.control_Hormonal === "Si",
            datos.textcontrolHormonal || null,
            datos.alergias === "Si",
            datos.textAlergia || null,
            datos.antecedentesFamiliares || null,
            datos.nacimiento || null,
            datos.tipo_sangre || null
          ]
        };

        const historialResult = await client.query(historialQuery.text, historialQuery.values);
        const id_historial = historialResult.rows[0].id;

        // 6. Actualizar estudiante con los campos adicionales
        await client.query(`
          ALTER TABLE "Estudiante" 
          ADD COLUMN IF NOT EXISTS "direccion" VARCHAR(255),
          ADD COLUMN IF NOT EXISTS "telefono" VARCHAR(12),
          ADD COLUMN IF NOT EXISTS "grado_escuela" VARCHAR(20),
          ADD COLUMN IF NOT EXISTS "nombre_seguro" VARCHAR(100)
        `);

        // Resolver escuela
        const id_escuela = datos.escuela ? await getOrCreateEscuela(datos.escuela, client) : null;
        const seguroEscolar = datos.Seguro_Escolar === "si" || datos.Seguro_Escolar === true;

        // Actualizar estudiante
        await client.query(
          `UPDATE "Estudiante" SET 
            "Id_historial" = $1,
            "direccion" = $2,
            "telefono" = $3,
            "Id_escuela" = $4,
            "grado_escuela" = $5,
            "seguro_escolar" = $6,
            "nombre_seguro" = $7
           WHERE "Id_estudiante" = $8`,
          [
            id_historial,
            datos.direccion_Habitacion || null,
            datos.Telefono_Celular || datos.telefono || null,
            id_escuela,
            datos.Grado_Escuela || null,
            seguroEscolar,
            datos.nombre_Seguro || null,
            id_estudiante
          ]
        );

        // 7. Guardar datos de los padres
        await guardarPadresEnTablaPadre(id_estudiante, datos, client);

        // 8. Verificar si ya está inscrito en el año actual
        const checkInscripcionQuery = {
          text: `
            SELECT es."Id_estudiante_seccion"
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            WHERE es."Id_estudiante" = $1 AND s."Id_ano" = $2
          `,
          values: [id_estudiante, id_ano_academico]
        };

        const inscripcionExistente = await client.query(checkInscripcionQuery.text, checkInscripcionQuery.values);

        if (inscripcionExistente.rows.length > 0) {
          await client.query('ROLLBACK');
          return res.status(400).json({
            ok: false,
            msg: "El estudiante ya está inscrito en este año académico"
          });
        }

        // 9. Determinar y vincular especialidad académica (requerida para 6to, 7mo u 8vo grado)
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

        if (idEspecialidad) {
          await client.query(
            'UPDATE "Estudiante" SET "Id_especialidad" = $1 WHERE "Id_estudiante" = $2',
            [idEspecialidad, id_estudiante]
          );
        }

        // 10. Buscar o crear sección para el grado y especialidad del estudiante
        await client.query(`
          ALTER TABLE "Seccion" 
          ADD COLUMN IF NOT EXISTS "nivel_academico" VARCHAR(50),
          ADD COLUMN IF NOT EXISTS "Id_especialidad" INTEGER
        `);
        const nivelAcademico = datos.grado || student.dance_level_name || student.grade_level_name || 'Preparatorio';
        const id_seccion = await obtenerOCrearSeccion(id_ano_academico, nivelAcademico, client, idEspecialidad);

        if (datos.grado) {
          try {
            const ndRes = await client.query(
              'SELECT "Id_nivel_danza" FROM "Nivel_Danza" WHERE LOWER("nivel_danza") = LOWER($1) OR LOWER("nivel_danza") LIKE LOWER($2) LIMIT 1',
              [datos.grado, `${datos.grado.replace('Grado', 'Año')}%`]
            );
            if (ndRes.rows.length > 0) {
              await client.query(
                'UPDATE "Estudiante" SET "Id_nivel_danza" = $1 WHERE "Id_estudiante" = $2',
                [ndRes.rows[0].Id_nivel_danza, id_estudiante]
              );
            }
          } catch (err) {
            console.error("Error actualizando Id_nivel_danza en inscripción:", err);
          }
        }

        // 11. Inscribir al estudiante en la sección con su especialidad correspondiente
        await client.query(`
          ALTER TABLE "Estudiante_Seccion" 
          ADD COLUMN IF NOT EXISTS "Id_especialidad" INTEGER
        `);

        const inscripcionQuery = {
          text: `
            INSERT INTO "Estudiante_Seccion" ("Id_estudiante", "Id_seccion", "Id_especialidad")
            VALUES ($1, $2, $3)
            RETURNING "Id_estudiante_seccion" as id
          `,
          values: [id_estudiante, id_seccion, idEspecialidad]
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

      // Verificar inscripción en el año escolar
      const query = {
        text: `
          SELECT es."Id_estudiante_seccion", s."Id_seccion", s."nombre_seccion"
          FROM "Estudiante_Seccion" es
          JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
          WHERE es."Id_estudiante" = $1 AND s."Id_ano" = $2
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
          id_seccion: estaInscrito ? result.rows[0].Id_seccion : null
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

      // 1. Verificar representante (soporte rol dual)
      const representante = await resolveRepresentanteFromReq(req);
      if (!representante) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permisos para realizar esta acción"
        });
      }

      // 2. Verificar estudiante
      const student = await StudentModel.findById(studentId);
      if (!student) {
        return res.status(404).json({
          ok: false,
          msg: "Estudiante no encontrado"
        });
      }

      if (!checkStudentOwnership(student, representante, userId)) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para consultar este estudiante"
        });
      }

      // 3. Obtener datos adicionales directos de la tabla Estudiante
      const extraRes = await db.query(`
        SELECT "direccion", "telefono", "grado_escuela", "nombre_seguro", "Id_historial"
        FROM "Estudiante"
        WHERE "Id_estudiante" = $1
      `, [studentId]);
      const extra = extraRes.rows[0] || {};

      // 4. Obtener historial médico completo si existe
      let historial = {};
      const histId = student.medical_history_id || extra.Id_historial;
      if (histId) {
        const histRes = await db.query(
          'SELECT * FROM "Historial_Medico" WHERE "Id_historial" = $1',
          [histId]
        );
        if (histRes.rows.length > 0) {
          historial = histRes.rows[0];
        }
      }

      // 5. Obtener padres asociados desde Estudiante_Padre -> Padre
      const padresRes = await db.query(`
        SELECT p.*
        FROM "Estudiante_Padre" ep
        JOIN "Padre" p ON ep."Id_padre" = p."Id_padre"
        WHERE ep."Id_estudiante" = $1
        ORDER BY ep."Id_padre" ASC
      `, [studentId]);

      const madre = padresRes.rows[0] || null;
      const padre = padresRes.rows[1] || null;

      // 6. Verificar si ya se encuentra inscrito en el año especificado
      let yaInscrito = false;
      let inscripcionData = null;
      if (ano) {
        const checkQuery = {
          text: `
            SELECT es."Id_estudiante_seccion", s."Id_seccion", s."nombre_seccion", s."Id_ano"
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            WHERE es."Id_estudiante" = $1 AND s."Id_ano" = $2
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
            direccion: extra.direccion || student.address || "",
            telefono: extra.telefono || "",
            grado_escuela: extra.grado_escuela || "",
            escuela: student.school_name || "",
            seguro_escolar: student.school_insurance || false,
            nombre_seguro: extra.nombre_seguro || student.insurance_name || "",
            dance_level_name: student.dance_level_name || "",
            grade_level_name: student.grade_level_name || "",
            especialidad: student.specialty_name || student.nombre_especialidad || student.especialidad || "",
            id_especialidad: student.specialty_id || student.Id_especialidad || null,
            especialidad_id: student.specialty_id || student.Id_especialidad || null
          },
          representante: {
            id: representante.id,
            nombres: student.representative_first_name || representante.nombre,
            apellidos: student.representative_last_name || representante.apellido,
            cedula: student.representative_dni || representante.cedula,
            telefono: student.representative_phone || "",
            correo: student.representative_email || representante.email,
            parentesco: student.representative_relationship || (student.representative_es_familiar ? "Madre" : "Otro"),
            profesion: student.representative_occupation || "",
            direccion_trabajo: student.representative_work_address || ""
          },
          madre: madre ? {
            nombre: madre.nombre,
            apellido: madre.apellido,
            cedula: madre.cedula,
            profesion: madre.profesion_padre,
            direccion_trabajo: madre.direccion_trabajo_padre,
            telefono: madre.telefono
          } : null,
          padre: padre ? {
            nombre: padre.nombre,
            apellido: padre.apellido,
            cedula: padre.cedula,
            profesion: padre.profesion_padre,
            direccion_trabajo: padre.direccion_trabajo_padre,
            telefono: padre.telefono
          } : null,
          historial_medico: {
            peso: historial.peso_kg ? parseFloat(historial.peso_kg).toString() : "",
            talla: historial.altura_m ? Math.round(parseFloat(historial.altura_m) * 100).toString() : "",
            tipo_sangre: historial.tipo_sangre || student.blood_type || "",
            intolerancia: historial.intolerancia_comida ? "Si" : "No",
            textIntolerancia: historial.descripcion_intolerancia || "",
            operaciones: historial.tiene_cirugia ? "Si" : "No",
            textOperaciones: historial.descripcion_cirugia || "",
            control_hormonal: historial.control_hormonal ? "Si" : "No",
            textcontrolHormonal: historial.descripcion_hormonal || "",
            alergias: historial.tiene_alergias ? "Si" : "No",
            textAlergia: historial.descripcion_alergias || "",
            termino_nacimiento: historial.termino_nacimiento || "",
            antecedentes_familiares: historial.antecedentes_familiares || ""
          },
          inscripcion_actual: {
            ya_inscrito: yaInscrito,
            seccion: inscripcionData ? inscripcionData.nombre_seccion : null,
            id_seccion: inscripcionData ? inscripcionData.Id_seccion : null
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
 * Guarda los datos de la madre y el padre en la tabla Padre
 */
async function guardarPadresEnTablaPadre(id_estudiante, datos, client = db) {
  try {
    console.log("👪 Guardando padres para estudiante:", id_estudiante);

    // 1. Insertar MADRE
    let id_madre = null;
    if (datos.nombre_Madre && datos.apellido_Madre) {
      const nombreMadre = capitalizeWords(datos.nombre_Madre);
      const apellidoMadre = capitalizeWords(datos.apellido_Madre);
      console.log("📝 Insertando madre:", nombreMadre, apellidoMadre);

      const madreQuery = {
        text: `
          INSERT INTO "Padre" (
            nombre, apellido, cedula, profesion_padre, direccion_trabajo_padre, telefono
          ) VALUES ($1, $2, $3, $4, $5, $6)
          RETURNING "Id_padre" as id
        `,
        values: [
          nombreMadre,
          apellidoMadre,
          datos.cedula_Madre || null,
          datos.ocupacion_Madre || null,
          datos.direccion_Trabajo_Madre || null,
          datos.telefono_Madre || null
        ]
      };
      const madreResult = await client.query(madreQuery.text, madreQuery.values);
      id_madre = madreResult.rows[0].id;
      console.log("✅ Madre insertada con ID:", id_madre);
    }

    // 2. Insertar PADRE
    let id_padre = null;
    if (datos.nombre_Padre && datos.apellido_Padre) {
      const nombrePadre = capitalizeWords(datos.nombre_Padre);
      const apellidoPadre = capitalizeWords(datos.apellido_Padre);
      console.log("📝 Insertando padre:", nombrePadre, apellidoPadre);

      const padreQuery = {
        text: `
          INSERT INTO "Padre" (
            nombre, apellido, cedula, profesion_padre, direccion_trabajo_padre, telefono
          ) VALUES ($1, $2, $3, $4, $5, $6)
          RETURNING "Id_padre" as id
        `,
        values: [
          nombrePadre,
          apellidoPadre,
          datos.cedula_Padre || null,
          datos.ocupacion_Padre || null,
          datos.direccion_Trabajo_Padre || null,
          datos.telefono_Padre || null
        ]
      };
      const padreResult = await client.query(padreQuery.text, padreQuery.values);
      id_padre = padreResult.rows[0].id;
      console.log("✅ Padre insertado con ID:", id_padre);
    }

    // 3. Eliminar relaciones existentes en Estudiante_Padre
    await client.query(
      'DELETE FROM "Estudiante_Padre" WHERE "Id_estudiante" = $1',
      [id_estudiante]
    );
    console.log("🗑️ Relaciones anteriores eliminadas");

    // 4. Crear nuevas relaciones
    if (id_madre) {
      await client.query(
        'INSERT INTO "Estudiante_Padre" ("Id_estudiante", "Id_padre") VALUES ($1, $2)',
        [id_estudiante, id_madre]
      );
      console.log("🔗 Relación madre-estudiante creada");
    }

    if (id_padre) {
      await client.query(
        'INSERT INTO "Estudiante_Padre" ("Id_estudiante", "Id_padre") VALUES ($1, $2)',
        [id_estudiante, id_padre]
      );
      console.log("🔗 Relación padre-estudiante creada");
    }

    console.log(`✅ Padres guardados exitosamente: Madre=${id_madre || 'no'}, Padre=${id_padre || 'no'}`);

  } catch (error) {
    console.error("❌ Error en guardarPadresEnTablaPadre:", error);
    throw error;
  }
}

/**
 * Obtiene o crea una escuela regular
 */
async function getOrCreateEscuela(nombreEscuela, client = db) {
  if (!nombreEscuela) return null;

  try {
    const query = {
      text: `SELECT "Id_escuela" FROM "Escuela_Regular" WHERE "nombre_escuela" = $1`,
      values: [nombreEscuela]
    };
    const result = await client.query(query.text, query.values);

    if (result.rows.length > 0) {
      return result.rows[0].Id_escuela;
    }

    const insertQuery = {
      text: `INSERT INTO "Escuela_Regular" ("nombre_escuela") VALUES ($1) RETURNING "Id_escuela"`,
      values: [nombreEscuela]
    };
    const insertResult = await client.query(insertQuery.text, insertQuery.values);
    return insertResult.rows[0].Id_escuela;
  } catch (error) {
    console.error("Error en getOrCreateEscuela:", error);
    return null;
  }
}

/**
 * Obtiene o crea una sección para el estudiante (incluyendo especialidad si aplica)
 */
async function obtenerOCrearSeccion(id_ano_academico, nivelAcademico, client = db, idEspecialidad = null) {
  // Buscar sección disponible que coincida en año, nivel académico y especialidad
  const seccionQuery = {
    text: `
      SELECT s."Id_seccion"
      FROM "Seccion" s
      WHERE s."Id_ano" = $1 
        AND (
          LOWER(TRIM(s.nivel_academico)) = LOWER(TRIM($2))
          OR s.nivel_academico = $2
          OR $2 IS NULL
        )
        AND (
          ($3::INTEGER IS NULL AND s."Id_especialidad" IS NULL)
          OR s."Id_especialidad" = $3::INTEGER
        )
        AND s."capacidad" > (
          SELECT COUNT(es."Id_estudiante_seccion")
          FROM "Estudiante_Seccion" es
          WHERE es."Id_seccion" = s."Id_seccion"
        )
      ORDER BY s."nombre_seccion" ASC
      LIMIT 1
    `,
    values: [id_ano_academico, nivelAcademico || 'Sin materia', idEspecialidad]
  };

  const seccionResult = await client.query(seccionQuery.text, seccionQuery.values);

  if (seccionResult.rows.length > 0) {
    return seccionResult.rows[0].Id_seccion;
  }

  // Buscar lapso para este año académico
  let lapsoResult = await client.query(
    'SELECT "Id_lapso" FROM "Lapso" WHERE "Id_ano" = $1 ORDER BY "Id_lapso" ASC LIMIT 1',
    [id_ano_academico]
  );

  // Si no hay lapsos configurados para este año académico, crearlos automáticamente
  if (lapsoResult.rows.length === 0) {
    console.log(`⚠️ No se encontraron lapsos para el año ${id_ano_academico}. Creando lapsos por defecto...`);
    try {
      const anoRes = await client.query(
        'SELECT "inicio_ano", "fin_ano" FROM "Ano_Academico" WHERE "Id_ano" = $1',
        [id_ano_academico]
      );

      let startYear = new Date().getFullYear();
      let endYear = startYear + 1;

      if (anoRes.rows.length > 0 && anoRes.rows[0].inicio_ano) {
        startYear = new Date(anoRes.rows[0].inicio_ano).getFullYear();
        endYear = anoRes.rows[0].fin_ano ? new Date(anoRes.rows[0].fin_ano).getFullYear() : startYear + 1;
      }

      await client.query(`
        INSERT INTO "Lapso" ("nombre_lapso", "inicio_lapso", "fin_lapso", "Id_ano")
        VALUES 
          ('I LAPSO', $1, $2, $3),
          ('II LAPSO', $4, $5, $3),
          ('III LAPSO', $6, $7, $3)
      `, [
        `${startYear}-09-15`, `${startYear}-12-15`, id_ano_academico,
        `${endYear}-01-10`, `${endYear}-04-05`,
        `${endYear}-04-15`, `${endYear}-07-15`
      ]);

      lapsoResult = await client.query(
        'SELECT "Id_lapso" FROM "Lapso" WHERE "Id_ano" = $1 ORDER BY "Id_lapso" ASC LIMIT 1',
        [id_ano_academico]
      );
    } catch (lapErr) {
      console.warn("⚠️ No se pudieron crear los lapsos automáticamente:", lapErr.message);
    }
  }

  const lapsoId = lapsoResult.rows[0]?.Id_lapso || null;

  const crearSeccionQuery = {
    text: `
      INSERT INTO "Seccion" (
        "nombre_seccion", "capacidad", "Id_lapso", "Id_ano", "nivel_academico", "Id_especialidad"
      ) VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING "Id_seccion"
    `,
    values: [
      'A',
      30,
      lapsoId,
      id_ano_academico,
      nivelAcademico || 'Sin materia',
      idEspecialidad
    ]
  };

  const nuevaSeccion = await client.query(crearSeccionQuery.text, crearSeccionQuery.values);
  return nuevaSeccion.rows[0].Id_seccion;
}