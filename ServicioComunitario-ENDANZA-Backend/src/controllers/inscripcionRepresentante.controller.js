import { db } from "../db/connection.database.js";
import { RepresentanteModel } from "../models/representante.model.js";
import { StudentModel } from "../models/student.model.js";
import { capitalizeWords } from "../utils/formatters.js";

export const InscripcionRepresentanteController = {

  /**
   * Completa la inscripción de un estudiante (solo para representantes)
   */
  completarInscripcion: async (req, res) => {
    try {
      const userId = req.user?.userId;
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

      // 2. Verificar que el usuario es representante
      const representante = await RepresentanteModel.findByUserId(userId);

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

      if (student.representative_id !== representante.id) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para inscribir este estudiante"
        });
      }

      // 4. Iniciar transacción
      await db.query('BEGIN');

      try {
        // 5. Crear historial médico
        const historialQuery = {
          text: `
            INSERT INTO "Historial_Medico" (
              peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia,
              dolores_frecuentes, tiene_cirugia, descripcion_cirugia,
              control_hormonal, descripcion_hormonal, tiene_alergias,
              descripcion_alergias, antecedentes_familiares, termino_nacimiento
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            RETURNING "Id_historial" as id
          `,
          values: [
            datos_completos.peso ? parseFloat(datos_completos.peso) : null,
            datos_completos.talla ? parseFloat(datos_completos.talla) / 100 : null,
            datos_completos.intolerancia === "Si",
            datos_completos.textIntolerancia || null,
            false, // dolores_frecuentes (por defecto)
            datos_completos.operaciones === "Si",
            datos_completos.textOperaciones || null,
            datos_completos.control_Hormonal === "Si",
            datos_completos.textcontrolHormonal || null,
            datos_completos.alergias === "Si",
            datos_completos.textAlergia || null,
            datos_completos.antecedentesFamiliares || null,
            datos_completos.nacimiento || null
          ]
        };

        const historialResult = await db.query(historialQuery.text, historialQuery.values);
        const id_historial = historialResult.rows[0].id;

        // 6. Actualizar estudiante con los campos adicionales
        // Primero, agregar los campos necesarios a la tabla Estudiante (si no existen)
        await db.query(`
          ALTER TABLE "Estudiante" 
          ADD COLUMN IF NOT EXISTS "direccion" VARCHAR(255),
          ADD COLUMN IF NOT EXISTS "telefono" VARCHAR(12),
          ADD COLUMN IF NOT EXISTS "grado_escuela" VARCHAR(20),
          ADD COLUMN IF NOT EXISTS "nombre_seguro" VARCHAR(100)
        `);

        // Actualizar estudiante
        await db.query(
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
            datos_completos.direccion_Habitacion || null,
            datos_completos.Telefono_Celular || null,
            datos_completos.escuela ? await getOrCreateEscuela(datos_completos.escuela) : null,
            datos_completos.Grado_Escuela || null,
            datos_completos.Seguro_Escolar === "si",
            datos_completos.nombre_Seguro || null,
            id_estudiante
          ]
        );

        // 7. Guardar datos de los padres
        await guardarPadresEnTablaPadre(id_estudiante, datos_completos);

        // 8. Verificar si ya está inscrito en el año actual
        const checkInscripcionQuery = {
          text: `
            SELECT es."Id_estudiante_seccion"
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
            WHERE es."Id_estudiante" = $1 AND l."Id_ano" = $2
          `,
          values: [id_estudiante, id_ano_academico]
        };

        const inscripcionExistente = await db.query(checkInscripcionQuery.text, checkInscripcionQuery.values);

        if (inscripcionExistente.rows.length > 0) {
          await db.query('ROLLBACK');
          return res.status(400).json({
            ok: false,
            msg: "El estudiante ya está inscrito en este año académico"
          });
        }

        // 9. Buscar o crear sección para el grado del estudiante
        await db.query(`
          ALTER TABLE "Seccion" 
          ADD COLUMN IF NOT EXISTS "nivel_academico" VARCHAR(50)
        `);
        const nivelAcademico = datos_completos.grado || student.dance_level_name || student.grade_level_name || 'Preparatorio';
        const id_seccion = await obtenerOCrearSeccion(id_ano_academico, nivelAcademico);

        if (datos_completos.grado) {
          try {
            const ndRes = await db.query(
              'SELECT "Id_nivel_danza" FROM "Nivel_Danza" WHERE LOWER("nivel_danza") = LOWER($1) OR LOWER("nivel_danza") LIKE LOWER($2) LIMIT 1',
              [datos_completos.grado, `${datos_completos.grado.replace('Grado', 'Año')}%`]
            );
            if (ndRes.rows.length > 0) {
              await db.query(
                'UPDATE "Estudiante" SET "Id_nivel_danza" = $1 WHERE "Id_estudiante" = $2',
                [ndRes.rows[0].Id_nivel_danza, id_estudiante]
              );
            }
          } catch (err) {
            console.error("Error actualizando Id_nivel_danza en inscripción:", err);
          }
        }

        // 10. Inscribir al estudiante en la sección
        const inscripcionQuery = {
          text: `
            INSERT INTO "Estudiante_Seccion" ("Id_estudiante", "Id_seccion")
            VALUES ($1, $2)
            RETURNING "Id_estudiante_seccion" as id
          `,
          values: [id_estudiante, id_seccion]
        };

        await db.query(inscripcionQuery.text, inscripcionQuery.values);

        await db.query('COMMIT');

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
        await db.query('ROLLBACK');
        throw error;
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

      // Verificar que el usuario es representante
      const representante = await RepresentanteModel.findByUserId(userId);

      if (!representante) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permisos"
        });
      }

      // Verificar que el estudiante pertenece al representante
      const student = await StudentModel.findById(studentId);

      if (!student || student.representative_id !== representante.id) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para ver este estudiante"
        });
      }

      // Verificar inscripción
      const query = {
        text: `
          SELECT COUNT(*) as inscrito
          FROM "Estudiante_Seccion" es
          JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
          JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
          WHERE es."Id_estudiante" = $1 AND l."Id_ano" = $2
        `,
        values: [studentId, ano]
      };

      const result = await db.query(query.text, query.values);

      return res.json({
        ok: true,
        data: {
          inscrito: parseInt(result.rows[0].inscrito) > 0
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
  }
};

// ============================================
// FUNCIONES AUXILIARES (AHORA USAN db.query)
// ============================================

/**
 * Guarda los datos de la madre y el padre en la tabla Padre
 */
async function guardarPadresEnTablaPadre(id_estudiante, datos) {
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
      const madreResult = await db.query(madreQuery.text, madreQuery.values);
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
      const padreResult = await db.query(padreQuery.text, padreQuery.values);
      id_padre = padreResult.rows[0].id;
      console.log("✅ Padre insertado con ID:", id_padre);
    }

    // 3. Eliminar relaciones existentes en Estudiante_Padre
    await db.query(
      'DELETE FROM "Estudiante_Padre" WHERE "Id_estudiante" = $1',
      [id_estudiante]
    );
    console.log("🗑️ Relaciones anteriores eliminadas");

    // 4. Crear nuevas relaciones
    if (id_madre) {
      await db.query(
        'INSERT INTO "Estudiante_Padre" ("Id_estudiante", "Id_padre") VALUES ($1, $2)',
        [id_estudiante, id_madre]
      );
      console.log("🔗 Relación madre-estudiante creada");
    }

    if (id_padre) {
      await db.query(
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
async function getOrCreateEscuela(nombreEscuela) {
  if (!nombreEscuela) return null;

  try {
    // Buscar si existe
    const query = {
      text: `SELECT "Id_escuela" FROM "Escuela_Regular" WHERE "nombre_escuela" = $1`,
      values: [nombreEscuela]
    };
    const result = await db.query(query.text, query.values);

    if (result.rows.length > 0) {
      return result.rows[0].Id_escuela;
    }

    // Crear nueva escuela
    const insertQuery = {
      text: `INSERT INTO "Escuela_Regular" ("nombre_escuela") VALUES ($1) RETURNING "Id_escuela"`,
      values: [nombreEscuela]
    };
    const insertResult = await db.query(insertQuery.text, insertQuery.values);
    return insertResult.rows[0].Id_escuela;
  } catch (error) {
    console.error("Error en getOrCreateEscuela:", error);
    return null;
  }
}

/**
 * Obtiene o crea una sección para el estudiante
 */
async function obtenerOCrearSeccion(id_ano_academico, nivelAcademico) {
  // Buscar sección disponible
  const seccionQuery = {
    text: `
      SELECT s."Id_seccion"
      FROM "Seccion" s
      WHERE s."Id_ano" = $1 
        AND s.nivel_academico = $2
        AND s."capacidad" > (
          SELECT COUNT(es."Id_estudiante_seccion")
          FROM "Estudiante_Seccion" es
          WHERE es."Id_seccion" = s."Id_seccion"
        )
      LIMIT 1
    `,
    values: [id_ano_academico, nivelAcademico || 'Sin materia']
  };

  const seccionResult = await db.query(seccionQuery.text, seccionQuery.values);

  if (seccionResult.rows.length > 0) {
    return seccionResult.rows[0].Id_seccion;
  }

  // Si no hay sección, crear una nueva
  const lapsoQuery = {
    text: `SELECT "Id_lapso" FROM "Lapso" WHERE "Id_ano" = $1 LIMIT 1`,
    values: [id_ano_academico]
  };
  const lapsoResult = await db.query(lapsoQuery.text, lapsoQuery.values);

  if (lapsoResult.rows.length === 0) {
    throw new Error("No hay lapsos configurados para este año académico");
  }

  const crearSeccionQuery = {
    text: `
      INSERT INTO "Seccion" (
        "nombre_seccion", "capacidad", "Id_lapso", "Id_ano", "nivel_academico"
      ) VALUES ($1, $2, $3, $4, $5)
      RETURNING "Id_seccion"
    `,
    values: [
      'A',
      30,
      lapsoResult.rows[0].Id_lapso,
      id_ano_academico,
      nivelAcademico || 'Sin materia'
    ]
  };

  const nuevaSeccion = await db.query(crearSeccionQuery.text, crearSeccionQuery.values);
  return nuevaSeccion.rows[0].Id_seccion;
}