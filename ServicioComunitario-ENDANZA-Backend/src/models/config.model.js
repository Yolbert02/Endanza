// Archivo: backend/models/config.model.js

import { db } from "../db/connection.database.js";

// ============================================
// MODELO DE CONFIGURACIÓN - Años Académicos y Periodos (NewEndanza)
// ============================================

// ============================================
// AÑOS ACADÉMICOS
// ============================================

const findAllAcademicYears = async () => {
  try {
    const query = {
      text: `
        SELECT 
          id_ano as id,
          nombre_ano as name,
          estado_ano as status,
          inicio_ano as start_date,
          fin_ano as end_date,
          (estado_ano = 'en_curso') as active
        FROM ano_academico
        ORDER BY nombre_ano DESC
      `,
    };
    const { rows } = await db.query(query.text);
    return rows;
  } catch (error) {
    console.error("Error en findAllAcademicYears:", error);
    throw error;
  }
};

const findActiveAcademicYear = async () => {
  try {
    const query = {
      text: `
        SELECT 
          id_ano as id,
          nombre_ano as name
        FROM ano_academico
        WHERE estado_ano = 'en_curso'
        LIMIT 1
      `,
    };
    const { rows } = await db.query(query.text);
    return rows[0] || null;
  } catch (error) {
    console.error("Error en findActiveAcademicYear:", error);
    throw error;
  }
};

const createAcademicYear = async (name, startDate, endDate) => {
  try {
    await db.query("BEGIN");

    try {
      // 1. Si hay un año en curso, pasarlo a finalizado
      await db.query(`
        UPDATE ano_academico 
        SET estado_ano = 'finalizado' 
        WHERE estado_ano = 'en_curso'
      `);

      // 2. Crear el nuevo año académico
      const insertQuery = {
        text: `
          INSERT INTO ano_academico 
            (nombre_ano, estado_ano, inicio_ano, fin_ano)
          VALUES ($1, 'en_curso', $2, $3)
          RETURNING 
            id_ano as id,
            nombre_ano as name
        `,
        values: [name, startDate, endDate],
      };

      const { rows } = await db.query(insertQuery.text, insertQuery.values);
      const newYear = rows[0];

      // 3. Crear los 3 lapsos académicos por defecto en la tabla periodo
      const startYear = new Date(startDate).getFullYear();
      const endYear = new Date(endDate).getFullYear();
      await db.query(
        `
        INSERT INTO periodo (nombre_periodo, inicio_periodo, fin_periodo, id_ano)
        VALUES 
          ('I LAPSO', $1, $2, $3),
          ('II LAPSO', $4, $5, $3),
          ('III LAPSO', $6, $7, $3)
      `,
        [
          `${startYear}-09-15`,
          `${startYear}-12-15`,
          newYear.id,
          `${endYear}-01-10`,
          `${endYear}-04-05`,
          `${endYear}-04-15`,
          `${endYear}-07-15`,
        ]
      );

      await db.query("COMMIT");
      return newYear;
    } catch (error) {
      await db.query("ROLLBACK");
      throw error;
    }
  } catch (error) {
    console.error("Error en createAcademicYear:", error);
    throw error;
  }
};

// ============================================
// PERÍODO DE INSCRIPCIÓN
// ============================================

const findEnrollmentPeriodByYearId = async (yearId) => {
  try {
    return {
      fechaInicio: null,
      fechaFin: null,
      activo: true,
    };
  } catch (error) {
    console.error("Error en findEnrollmentPeriodByYearId:", error);
    throw error;
  }
};

const updateEnrollmentPeriod = async (
  yearId,
  { fechaInicio, fechaFin, activo }
) => {
  try {
    return {
      fechaInicio,
      fechaFin,
      activo,
    };
  } catch (error) {
    console.error("Error en updateEnrollmentPeriod:", error);
    throw error;
  }
};

// ============================================
// LAPSOS (periodo en NewEndanza)
// ============================================

const findLapsosByYearId = async (yearId) => {
  try {
    const query = {
      text: `
        SELECT 
          id_periodo as id,
          nombre_periodo as name,
          inicio_periodo as start_date,
          fin_periodo as end_date,
          id_ano as year_id
        FROM periodo
        WHERE id_ano = $1
        ORDER BY id_periodo
      `,
      values: [yearId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findLapsosByYearId:", error);
    throw error;
  }
};

const createLapso = async (name, startDate, endDate, yearId) => {
  try {
    const query = {
      text: `
        INSERT INTO periodo (nombre_periodo, inicio_periodo, fin_periodo, id_ano)
        VALUES ($1, $2, $3, $4)
        RETURNING 
          id_periodo as id,
          nombre_periodo as name,
          inicio_periodo as start_date,
          fin_periodo as end_date,
          id_ano as year_id
      `,
      values: [name, startDate, endDate, yearId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en createLapso:", error);
    throw error;
  }
};

const updateLapso = async (id, name, startDate, endDate) => {
  try {
    const query = {
      text: `
        UPDATE periodo
        SET 
          nombre_periodo = COALESCE($1, nombre_periodo),
          inicio_periodo = COALESCE($2, inicio_periodo),
          fin_periodo = COALESCE($3, fin_periodo)
        WHERE id_periodo = $4
        RETURNING 
          id_periodo as id,
          nombre_periodo as name,
          inicio_periodo as start_date,
          fin_periodo as end_date,
          id_ano as year_id
      `,
      values: [name, startDate, endDate, id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en updateLapso:", error);
    throw error;
  }
};

const deleteLapso = async (id) => {
  try {
    const query = {
      text: `DELETE FROM periodo WHERE id_periodo = $1 RETURNING id_periodo as id`,
      values: [id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en deleteLapso:", error);
    throw error;
  }
};

// ============================================
// PERÍODO DE SUBIDA DE NOTAS
// ============================================

const findGradesPeriodByYearId = async (yearId) => {
  try {
    return {
      fechaInicio: null,
      fechaFin: null,
      activo: true,
    };
  } catch (error) {
    console.error("Error en findGradesPeriodByYearId:", error);
    throw error;
  }
};

const updateGradesPeriod = async (
  yearId,
  { fechaInicio, fechaFin, activo }
) => {
  try {
    return {
      fechaInicio,
      fechaFin,
      activo,
    };
  } catch (error) {
    console.error("Error en updateGradesPeriod:", error);
    throw error;
  }
};

// ============================================
// EXPORTAR MODELO
// ============================================
export const ConfigModel = {
  // Años académicos
  findAllAcademicYears,
  findActiveAcademicYear,
  createAcademicYear,

  // Período de inscripción
  findEnrollmentPeriodByYearId,
  updateEnrollmentPeriod,

  // Lapsos
  findLapsosByYearId,
  createLapso,
  updateLapso,
  deleteLapso,

  // Período de subida de notas
  findGradesPeriodByYearId,
  updateGradesPeriod,
};