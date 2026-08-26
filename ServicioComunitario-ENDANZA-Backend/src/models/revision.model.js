// Archivo: backend/models/revision.model.js

import { db } from "../db/connection.database.js";

// ============================================
// MODELO DE REVISIÓN DE MATERIA
// Gestiona las revisiones (reparaciones) de materias
// teóricas reprobadas en la definitiva general
// ============================================

// Auto-migración: crear tabla si no existe
const initTable = async () => {
  try {
    await db.query(`
      CREATE TABLE IF NOT EXISTS "Revision_Materia" (
        "Id_revision" SERIAL PRIMARY KEY,
        "Id_estudiante" INTEGER NOT NULL,
        "Id_materia" INTEGER NOT NULL,
        "Id_ano" INTEGER NOT NULL,
        "nota_definitiva" DECIMAL(5,2) NOT NULL,
        "nota_revision" DECIMAL(5,2) DEFAULT NULL,
        "estado" VARCHAR(20) DEFAULT 'pendiente',
        "observacion" TEXT DEFAULT NULL,
        "fecha_creacion" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        "fecha_revision" TIMESTAMP DEFAULT NULL,
        "creado_por" INTEGER DEFAULT NULL,
        UNIQUE("Id_estudiante", "Id_materia", "Id_ano")
      );
    `);
    console.log("✅ Tabla Revision_Materia verificada/creada");
  } catch (error) {
    console.error("Error inicializando tabla Revision_Materia:", error);
  }
};

// Ejecutar inicialización al cargar el módulo
initTable();

// ============================================
// FUNCIONES CRUD
// ============================================

/**
 * Obtener revisiones por año académico
 */
const findByAcademicYear = async (academicYearId) => {
  try {
    const query = {
      text: `
        SELECT 
          rm."Id_revision" as id,
          rm."Id_estudiante" as student_id,
          e."nombre" || ' ' || e."apellido" as student_name,
          e."cedula" as student_dni,
          rm."Id_materia" as subject_id,
          m."nombre_materia" as subject_name,
          m."tipo_materia" as subject_type,
          g."nombre_grado" as grade_name,
          rm."nota_definitiva" as nota_definitiva,
          rm."nota_revision" as nota_revision,
          rm."estado" as estado,
          rm."observacion" as observacion,
          rm."fecha_creacion" as fecha_creacion,
          rm."fecha_revision" as fecha_revision
        FROM "Revision_Materia" rm
        JOIN "Estudiante" e ON rm."Id_estudiante" = e."Id_estudiante"
        JOIN "Materia" m ON rm."Id_materia" = m."Id_materia"
        LEFT JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
        WHERE rm."Id_ano" = $1
        ORDER BY rm."estado" ASC, e."apellido", e."nombre", m."nombre_materia"
      `,
      values: [academicYearId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findByAcademicYear revisiones:", error);
    throw error;
  }
};

/**
 * Obtener revisiones de un estudiante específico
 */
const findByStudent = async (studentId, academicYearId = null) => {
  try {
    let query = {
      text: `
        SELECT 
          rm."Id_revision" as id,
          rm."Id_materia" as subject_id,
          m."nombre_materia" as subject_name,
          m."tipo_materia" as subject_type,
          g."nombre_grado" as grade_name,
          rm."nota_definitiva" as nota_definitiva,
          rm."nota_revision" as nota_revision,
          rm."estado" as estado,
          rm."observacion" as observacion,
          rm."fecha_creacion" as fecha_creacion,
          rm."fecha_revision" as fecha_revision,
          rm."Id_ano" as academic_year_id,
          a."nombre_ano" as academic_year_name
        FROM "Revision_Materia" rm
        JOIN "Materia" m ON rm."Id_materia" = m."Id_materia"
        LEFT JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
        JOIN "Ano_Academico" a ON rm."Id_ano" = a."Id_ano"
        WHERE rm."Id_estudiante" = $1
      `,
      values: [studentId]
    };

    if (academicYearId) {
      query.text += ` AND rm."Id_ano" = $2`;
      query.values.push(academicYearId);
    }

    query.text += ` ORDER BY a."nombre_ano" DESC, m."nombre_materia"`;

    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findByStudent revisiones:", error);
    throw error;
  }
};

/**
 * Crear una revisión manualmente
 */
const create = async ({ studentId, subjectId, academicYearId, notaDefinitiva, creadoPor = null }) => {
  try {
    const query = {
      text: `
        INSERT INTO "Revision_Materia" 
          ("Id_estudiante", "Id_materia", "Id_ano", "nota_definitiva", "estado", "creado_por")
        VALUES ($1, $2, $3, $4, 'pendiente', $5)
        ON CONFLICT ("Id_estudiante", "Id_materia", "Id_ano") 
        DO UPDATE SET 
          "nota_definitiva" = EXCLUDED."nota_definitiva",
          "fecha_creacion" = CURRENT_TIMESTAMP
        RETURNING "Id_revision" as id, "estado"
      `,
      values: [studentId, subjectId, academicYearId, notaDefinitiva, creadoPor]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en create revisión:", error);
    throw error;
  }
};

/**
 * Actualizar la nota de revisión
 */
const updateNotaRevision = async (revisionId, notaRevision, observacion = null) => {
  try {
    const estado = parseFloat(notaRevision) >= 10 ? 'aprobado' : 'reprobado';
    
    const query = {
      text: `
        UPDATE "Revision_Materia"
        SET 
          "nota_revision" = $1,
          "estado" = $2,
          "observacion" = $3,
          "fecha_revision" = CURRENT_TIMESTAMP
        WHERE "Id_revision" = $4
        RETURNING 
          "Id_revision" as id, 
          "nota_revision", 
          "estado",
          "observacion"
      `,
      values: [notaRevision, estado, observacion, revisionId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en updateNotaRevision:", error);
    throw error;
  }
};

/**
 * Auto-detectar estudiantes que necesitan revisión en un año académico.
 * Busca materias TEÓRICAS donde la definitiva general (promedio de los 3 lapsos) < 10.
 */
const autoDetect = async (academicYearId, creadoPor = null) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    // Paso 1: Calcular la definitiva general por estudiante por materia
    // La definitiva general es el promedio de las notas de todos los lapsos de esa materia
    const detectQuery = {
      text: `
        WITH notas_por_lapso AS (
          -- Obtener la nota promedio por estudiante, por materia, por lapso
          SELECT 
            es."Id_estudiante",
            m."Id_materia",
            l."Id_lapso",
            l."Id_ano",
            m."tipo_materia",
            -- Promedio de las evaluaciones dentro de cada lapso
            AVG(cn."puntaje") as nota_lapso
          FROM "Estudiante_Seccion" es
          JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
          JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
          JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
          JOIN "Estructura_Evaluacion" ee ON ee."Id_seccion" = s."Id_seccion"
          JOIN "Carga_Nota" cn ON cn."Id_estructura_evaluacion" = ee."Id_estructura_evaluacion"
            AND cn."Id_estudiante" = es."Id_estudiante"
          WHERE l."Id_ano" = $1
            AND LOWER(COALESCE(m."tipo_materia", '')) = 'teorica'
          GROUP BY es."Id_estudiante", m."Id_materia", l."Id_lapso", l."Id_ano", m."tipo_materia"
        ),
        definitiva_general AS (
          -- Promedio de todos los lapsos = definitiva general
          SELECT 
            "Id_estudiante",
            "Id_materia",
            "Id_ano",
            "tipo_materia",
            AVG(nota_lapso) as nota_definitiva,
            COUNT(DISTINCT "Id_lapso") as lapsos_cursados
          FROM notas_por_lapso
          GROUP BY "Id_estudiante", "Id_materia", "Id_ano", "tipo_materia"
        )
        -- Solo los que tienen definitiva < 10
        SELECT 
          "Id_estudiante",
          "Id_materia",
          "Id_ano",
          ROUND(nota_definitiva, 2) as nota_definitiva
        FROM definitiva_general
        WHERE nota_definitiva < 10
      `,
      values: [academicYearId]
    };

    const { rows: reprobados } = await client.query(detectQuery.text, detectQuery.values);

    let creados = 0;
    let actualizados = 0;

    for (const rep of reprobados) {
      // Insertar o actualizar revisión
      const upsert = await client.query(
        `INSERT INTO "Revision_Materia" 
          ("Id_estudiante", "Id_materia", "Id_ano", "nota_definitiva", "estado", "creado_por")
        VALUES ($1, $2, $3, $4, 'pendiente', $5)
        ON CONFLICT ("Id_estudiante", "Id_materia", "Id_ano") 
        DO UPDATE SET 
          "nota_definitiva" = EXCLUDED."nota_definitiva"
        RETURNING (xmax = 0) as is_new`,
        [rep.Id_estudiante, rep.Id_materia, rep.Id_ano, rep.nota_definitiva, creadoPor]
      );

      if (upsert.rows[0]?.is_new) {
        creados++;
      } else {
        actualizados++;
      }
    }

    await client.query('COMMIT');
    return { 
      total_detectados: reprobados.length, 
      creados, 
      actualizados 
    };
  } catch (error) {
    await client.query('ROLLBACK');
    console.error("Error en autoDetect revisiones:", error);
    throw error;
  } finally {
    client.release();
  }
};

/**
 * Eliminar una revisión
 */
const remove = async (revisionId) => {
  try {
    const query = {
      text: `DELETE FROM "Revision_Materia" WHERE "Id_revision" = $1 RETURNING "Id_revision" as id`,
      values: [revisionId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en remove revisión:", error);
    throw error;
  }
};

/**
 * Obtener revisiones de un estudiante para un año específico (para el boletín)
 * Retorna un mapa: { subjectId: { nota_revision, estado } }
 */
const getRevisionMapByStudent = async (studentId, academicYearId) => {
  try {
    const query = {
      text: `
        SELECT 
          "Id_materia" as subject_id,
          "nota_definitiva",
          "nota_revision",
          "estado"
        FROM "Revision_Materia"
        WHERE "Id_estudiante" = $1 AND "Id_ano" = $2
      `,
      values: [studentId, academicYearId]
    };
    const { rows } = await db.query(query.text, query.values);
    
    const map = {};
    rows.forEach(r => {
      map[r.subject_id] = {
        nota_definitiva: r.nota_definitiva,
        nota_revision: r.nota_revision,
        estado: r.estado
      };
    });
    return map;
  } catch (error) {
    console.error("Error en getRevisionMapByStudent:", error);
    throw error;
  }
};

export const RevisionModel = {
  findByAcademicYear,
  findByStudent,
  create,
  updateNotaRevision,
  autoDetect,
  remove,
  getRevisionMapByStudent
};
