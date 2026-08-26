// Archivo: backend/models/promocion.model.js

import { db } from "../db/connection.database.js";

// ============================================
// MODELO DE PROMOCIÓN ANTICIPADA Y ACTAS
// Gestiona la promoción al siguiente grado en el 1er Lapso
// por rendimiento sobresaliente, avalada mediante Acta Oficial.
// ============================================

// Auto-migración: crear tabla de Actas de Promoción si no existe
const initTable = async () => {
  try {
    await db.query(`
      CREATE TABLE IF NOT EXISTS "Acta_Promocion" (
        "Id_acta" SERIAL PRIMARY KEY,
        "numero_acta" VARCHAR(50) UNIQUE NOT NULL,
        "Id_estudiante" INTEGER NOT NULL,
        "Id_ano" INTEGER NOT NULL,
        "Id_grado_origen" INTEGER NOT NULL,
        "Id_grado_destino" INTEGER NOT NULL,
        "promedio_lapso1" DECIMAL(5,2) NOT NULL,
        "motivo" TEXT NOT NULL,
        "resolucion" TEXT DEFAULT NULL,
        "autoridades" JSONB DEFAULT NULL,
        "fecha_sesion" DATE DEFAULT CURRENT_DATE,
        "fecha_emision" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        "estado" VARCHAR(20) DEFAULT 'aprobada',
        "creado_por" INTEGER DEFAULT NULL,
        UNIQUE("Id_estudiante", "Id_ano")
      );
    `);
    console.log("✅ Tabla Acta_Promocion verificada/creada");
  } catch (error) {
    console.error("Error inicializando tabla Acta_Promocion:", error);
  }
};

// Ejecutar inicialización al importar módulo
initTable();

/**
 * Encuentra candidatos sobresalientes del 1er Lapso
 * @param {number} academicYearId
 * @param {number} minPromedio (default 18 pts)
 */
const findCandidates = async (academicYearId, minPromedio = 18.0) => {
  try {
    // 1. Obtener el primer lapso del año académico
    const lapso1Query = await db.query(
      `SELECT "Id_lapso", "nombre_lapso" 
       FROM "Lapso" 
       WHERE "Id_ano" = $1 
       ORDER BY "Id_lapso" ASC 
       LIMIT 1`,
      [academicYearId]
    );

    if (lapso1Query.rows.length === 0) {
      return [];
    }

    const lapso1Id = lapso1Query.rows[0].Id_lapso;

    // 2. Calcular promedio de cada estudiante en el 1er Lapso
    const query = {
      text: `
        WITH notas_lapso1 AS (
          SELECT 
            es."Id_estudiante",
            e."nombre" as first_name,
            e."apellido" as last_name,
            e."cedula" as dni,
            e."Id_nivel_danza" as dance_level_id,
            nd."nivel_danza" as dance_level_name,
            g."Id_grado" as current_grade_id,
            g."nombre_grado" as current_grade_name,
            AVG(cn."puntaje") as promedio_lapso1,
            COUNT(DISTINCT s."Id_materia") as total_materias_cursadas
          FROM "Estudiante_Seccion" es
          JOIN "Estudiante" e ON es."Id_estudiante" = e."Id_estudiante"
          LEFT JOIN "Nivel_Danza" nd ON e."Id_nivel_danza" = nd."Id_nivel_danza"
          JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
          JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
          JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
          JOIN "Estructura_Evaluacion" ee ON ee."Id_seccion" = s."Id_seccion"
          JOIN "Carga_Nota" cn ON cn."Id_estructura_evaluacion" = ee."Id_estructura_evaluacion" 
            AND cn."Id_estudiante" = es."Id_estudiante"
          WHERE s."Id_lapso" = $1
          GROUP BY 
            es."Id_estudiante", 
            e."nombre", 
            e."apellido", 
            e."cedula", 
            e."Id_nivel_danza", 
            nd."nivel_danza", 
            g."Id_grado", 
            g."nombre_grado"
          HAVING AVG(cn."puntaje") >= $2
        )
        SELECT 
          nl.*,
          ROUND(nl.promedio_lapso1, 2) as promedio_redondeado,
          ap."Id_acta" as ya_promovido_acta_id,
          ap."numero_acta" as acta_existente_numero
        FROM notas_lapso1 nl
        LEFT JOIN "Acta_Promocion" ap ON nl."Id_estudiante" = ap."Id_estudiante" 
          AND ap."Id_ano" = $3
        ORDER BY nl.promedio_lapso1 DESC, nl.last_name ASC
      `,
      values: [lapso1Id, minPromedio, academicYearId]
    };

    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findCandidates de promocion:", error);
    throw error;
  }
};

/**
 * Obtener lista de todas las actas de promoción emitidas
 */
const findAll = async (academicYearId = null) => {
  try {
    let query = {
      text: `
        SELECT 
          ap."Id_acta" as id,
          ap."numero_acta" as act_number,
          ap."Id_estudiante" as student_id,
          e."nombre" || ' ' || e."apellido" as student_name,
          e."cedula" as student_dni,
          ap."Id_grado_origen" as origin_grade_id,
          go."nombre_grado" as origin_grade_name,
          ap."Id_grado_destino" as target_grade_id,
          gd."nombre_grado" as target_grade_name,
          ap."promedio_lapso1" as average_lapso1,
          ap."motivo" as reason,
          ap."resolucion" as resolution,
          ap."autoridades" as authorities,
          ap."fecha_sesion" as session_date,
          ap."fecha_emision" as issue_date,
          ap."estado" as status,
          a."nombre_ano" as academic_year_name
        FROM "Acta_Promocion" ap
        JOIN "Estudiante" e ON ap."Id_estudiante" = e."Id_estudiante"
        JOIN "Grado" go ON ap."Id_grado_origen" = go."Id_grado"
        JOIN "Grado" gd ON ap."Id_grado_destino" = gd."Id_grado"
        JOIN "Ano_Academico" a ON ap."Id_ano" = a."Id_ano"
      `,
      values: []
    };

    if (academicYearId) {
      query.text += ` WHERE ap."Id_ano" = $1`;
      query.values.push(academicYearId);
    }

    query.text += ` ORDER BY ap."fecha_emision" DESC, ap."Id_acta" DESC`;

    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findAll actas de promocion:", error);
    throw error;
  }
};

/**
 * Obtener detalle completo de un acta por ID
 */
const findById = async (actaId) => {
  try {
    const query = {
      text: `
        SELECT 
          ap."Id_acta" as id,
          ap."numero_acta" as act_number,
          ap."Id_estudiante" as student_id,
          e."nombre" as student_first_name,
          e."apellido" as student_last_name,
          e."nombre" || ' ' || e."apellido" as student_name,
          e."cedula" as student_dni,
          TO_CHAR(e."fecha_nacimiento", 'DD/MM/YYYY') as student_birthdate,
          ap."Id_ano" as academic_year_id,
          a."nombre_ano" as academic_year_name,
          ap."Id_grado_origen" as origin_grade_id,
          go."nombre_grado" as origin_grade_name,
          ap."Id_grado_destino" as target_grade_id,
          gd."nombre_grado" as target_grade_name,
          ap."promedio_lapso1" as average_lapso1,
          ap."motivo" as reason,
          ap."resolucion" as resolution,
          ap."autoridades" as authorities,
          TO_CHAR(ap."fecha_sesion", 'DD/MM/YYYY') as session_date_formatted,
          ap."fecha_sesion" as session_date,
          ap."fecha_emision" as issue_date,
          ap."estado" as status
        FROM "Acta_Promocion" ap
        JOIN "Estudiante" e ON ap."Id_estudiante" = e."Id_estudiante"
        JOIN "Grado" go ON ap."Id_grado_origen" = go."Id_grado"
        JOIN "Grado" gd ON ap."Id_grado_destino" = gd."Id_grado"
        JOIN "Ano_Academico" a ON ap."Id_ano" = a."Id_ano"
        WHERE ap."Id_acta" = $1
      `,
      values: [actaId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("Error en findById acta de promocion:", error);
    throw error;
  }
};

/**
 * Emitir Acta Oficial y Promover al Estudiante de Grado
 */
const createActaAndPromote = async (data) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    const {
      numeroActa,
      studentId,
      academicYearId,
      originGradeId,
      targetGradeId,
      promedioLapso1,
      motivo,
      resolucion,
      autoridades,
      fechaSesion,
      creadoPor = null
    } = data;

    // 1. Generar número de acta automático si no viene provisto
    let actNum = numeroActa;
    if (!actNum) {
      const countRes = await client.query(
        `SELECT COUNT(*) as total FROM "Acta_Promocion" WHERE "Id_ano" = $1`,
        [academicYearId]
      );
      const nextNum = parseInt(countRes.rows[0].total) + 1;
      actNum = `ACTA-PROM-${new Date().getFullYear()}-${String(nextNum).padStart(3, '0')}`;
    }

    // 2. Insertar el Acta Oficial en la base de datos
    const insertActaQuery = {
      text: `
        INSERT INTO "Acta_Promocion" (
          "numero_acta", 
          "Id_estudiante", 
          "Id_ano", 
          "Id_grado_origen", 
          "Id_grado_destino", 
          "promedio_lapso1", 
          "motivo", 
          "resolucion", 
          "autoridades", 
          "fecha_sesion", 
          "estado", 
          "creado_por"
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, 'aprobada', $11)
        RETURNING "Id_acta" as id, "numero_acta"
      `,
      values: [
        actNum,
        studentId,
        academicYearId,
        originGradeId,
        targetGradeId,
        promedioLapso1,
        motivo,
        resolucion || `Promoción anticipada formalizada por Consejo Directivo según Acta N° ${actNum}`,
        autoridades ? JSON.stringify(autoridades) : JSON.stringify([
          { cargo: "Dirección General", nombre: "Dirección ENDANZA" },
          { cargo: "Coordinación Académica", nombre: "Coordinación de Danza" },
          { cargo: "Control de Estudios", nombre: "Secretaría General" }
        ]),
        fechaSesion || new Date().toISOString().split('T')[0],
        creadoPor
      ]
    };

    const actaResult = await client.query(insertActaQuery.text, insertActaQuery.values);
    const nuevaActa = actaResult.rows[0];

    // 3. Actualizar el grado del estudiante (en tabla Estudiante nivel_danza si coincide o nivel)
    const targetGradeQuery = await client.query(
      `SELECT "nombre_grado" FROM "Grado" WHERE "Id_grado" = $1`,
      [targetGradeId]
    );

    if (targetGradeQuery.rows.length > 0) {
      const gradeName = targetGradeQuery.rows[0].nombre_grado;
      
      // Actualizar Id_nivel_danza si existe relación por nombre
      await client.query(
        `UPDATE "Estudiante" 
         SET "Id_nivel_danza" = COALESCE(
           (SELECT "Id_nivel_danza" FROM "Nivel_Danza" WHERE "nivel_danza" ILIKE $1 LIMIT 1),
           "Id_nivel_danza"
         )
         WHERE "Id_estudiante" = $2`,
        [`%${gradeName}%`, studentId]
      );
    }

    // 4. TRANSFERENCIA DE SECCIONES PARA LOS LAPSOS 2 Y 3:
    // Identificar los lapsos del año académico (el 1er lapso se mantiene como constancia de origen)
    const lapsosRes = await client.query(
      `SELECT "Id_lapso" 
       FROM "Lapso" 
       WHERE "Id_ano" = $1 
       ORDER BY "Id_lapso" ASC`,
      [academicYearId]
    );

    if (lapsosRes.rows.length > 1) {
      const lapso1Id = lapsosRes.rows[0].Id_lapso;

      // a) Desvincular al estudiante de las secciones del grado de origen en lapsos 2 y 3
      await client.query(
        `DELETE FROM "Estudiante_Seccion" 
         WHERE "Id_estudiante" = $1 
           AND "Id_seccion" IN (
             SELECT s."Id_seccion" 
             FROM "Seccion" s
             JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
             WHERE m."ano_materia" = $2 
               AND s."Id_ano" = $3
               AND s."Id_lapso" != $4
           )`,
        [studentId, originGradeId, academicYearId, lapso1Id]
      );

      // b) Inscribir al estudiante en las secciones del grado destino para lapsos 2 y 3
      const targetSectionsRes = await client.query(
        `SELECT s."Id_seccion"
         FROM "Seccion" s
         JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
         WHERE m."ano_materia" = $1 
           AND s."Id_ano" = $2
           AND s."Id_lapso" != $3`,
        [targetGradeId, academicYearId, lapso1Id]
      );

      for (const targetSec of targetSectionsRes.rows) {
        await client.query(
          `INSERT INTO "Estudiante_Seccion" ("Id_estudiante", "Id_seccion")
           SELECT $1, $2
           WHERE NOT EXISTS (
             SELECT 1 FROM "Estudiante_Seccion" 
             WHERE "Id_estudiante" = $1 AND "Id_seccion" = $2
           )`,
          [studentId, targetSec.Id_seccion]
        );
      }
      console.log(`✅ Estudiante ${studentId} promovido e inscrito en ${targetSectionsRes.rows.length} secciones del grado destino para lapsos posteriores`);
    }

    await client.query('COMMIT');
    return nuevaActa;
  } catch (error) {
    await client.query('ROLLBACK');
    console.error("Error en createActaAndPromote:", error);
    throw error;
  } finally {
    client.release();
  }
};

/**
 * Obtener acta de promoción activa de un estudiante
 */
const findByStudent = async (studentId, academicYearId = null) => {
  try {
    let query = {
      text: `
        SELECT 
          ap."Id_acta" as id,
          ap."numero_acta" as act_number,
          ap."Id_estudiante" as student_id,
          ap."Id_grado_origen" as origin_grade_id,
          go."nombre_grado" as origin_grade_name,
          ap."Id_grado_destino" as target_grade_id,
          gd."nombre_grado" as target_grade_name,
          ap."promedio_lapso1" as average_lapso1,
          ap."motivo" as reason,
          ap."resolucion" as resolution,
          ap."fecha_sesion" as session_date,
          ap."fecha_emision" as issue_date,
          ap."estado" as status
        FROM "Acta_Promocion" ap
        JOIN "Grado" go ON ap."Id_grado_origen" = go."Id_grado"
        JOIN "Grado" gd ON ap."Id_grado_destino" = gd."Id_grado"
        WHERE ap."Id_estudiante" = $1 AND ap."estado" = 'aprobada'
      `,
      values: [studentId]
    };
    if (academicYearId) {
      query.text += ` AND ap."Id_ano" = $2`;
      query.values.push(academicYearId);
    }
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("Error en findByStudent promocion:", error);
    return null;
  }
};

/**
 * Anular un acta de promoción
 */
const anularActa = async (actaId) => {
  try {
    const query = {
      text: `
        UPDATE "Acta_Promocion"
        SET "estado" = 'anulada'
        WHERE "Id_acta" = $1
        RETURNING "Id_acta" as id, "estado"
      `,
      values: [actaId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en anularActa:", error);
    throw error;
  }
};

export const PromocionModel = {
  findCandidates,
  findAll,
  findById,
  findByStudent,
  createActaAndPromote,
  anularActa
};
