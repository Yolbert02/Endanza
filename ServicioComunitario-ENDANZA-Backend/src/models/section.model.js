import { db } from "../db/connection.database.js";

// ============================================
// MODELO DE SECCIONES (NewEndanza)
// ============================================

const findAll = async (academicYearId = null) => {
  try {
    let query = {
      text: `
        SELECT 
          s.id_seccion as id,
          s.nombre_seccion as section_name,
          30 as capacity,
          COALESCE(m.id_materia, NULL) as subject_id,
          COALESCE(m.nombre_materia, 'General') as subject_name,
          s.id_ano as academic_year_id,
          a.nombre_ano as academic_year_name,
          s.id_nivel_danza as grade_id,
          COALESCE(nd.nivel_danza, 'General') as grade_name,
          nd.nivel_danza as nivel_academico,
          s.id_especialidad as specialty_id,
          esp.nombre_especialidad as specialty_name,
          COUNT(DISTINCT i.id_estudiante) as student_count
        FROM seccion s
        LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
        LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
        LEFT JOIN especialidad esp ON s.id_especialidad = esp.id_especialidad
        LEFT JOIN horario h ON s.id_seccion = h.id_seccion
        LEFT JOIN materia m ON h.id_materia = m.id_materia
        LEFT JOIN inscripcion i ON s.id_seccion = i.id_seccion AND i.estado_inscripcion = 'activo'
      `,
    };

    if (academicYearId) {
      query.text += ` WHERE s.id_ano = $1`;
      query.values = [academicYearId];
    }

    query.text += ` 
      GROUP BY 
        s.id_seccion, 
        s.nombre_seccion, 
        m.id_materia, 
        m.nombre_materia, 
        s.id_ano, 
        a.nombre_ano, 
        s.id_nivel_danza, 
        nd.nivel_danza, 
        s.id_especialidad, 
        esp.nombre_especialidad
      ORDER BY nd.nivel_danza, s.nombre_seccion
    `;

    const { rows } = await db.query(query.text, query.values || []);
    return rows;
  } catch (error) {
    console.error("Error en findAll sections:", error);
    throw error;
  }
};

const findById = async (id) => {
  try {
    const query = {
      text: `
        SELECT 
          s.id_seccion as id,
          s.nombre_seccion as section_name,
          30 as capacity,
          s.id_ano as academic_year_id,
          a.nombre_ano as academic_year_name,
          s.id_nivel_danza as grade_id,
          nd.nivel_danza as grade_name,
          s.id_especialidad as specialty_id,
          s.id_especialidad as especialidad_id,
          s.id_especialidad as id_especialidad,
          esp.nombre_especialidad as specialty_name,
          esp.nombre_especialidad as especialidad
        FROM seccion s
        LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
        LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
        LEFT JOIN especialidad esp ON s.id_especialidad = esp.id_especialidad
        WHERE s.id_seccion = $1
      `,
      values: [id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("Error en findById section:", error);
    throw error;
  }
};

const create = async (sectionData) => {
  try {
    const {
      nombre_seccion,
      Id_ano,
      academic_year_id,
      Id_especialidad,
      especialidad_id,
      Id_nivel_danza,
      id_nivel_danza,
      grade_id,
    } = sectionData;
    const specialtyId = Id_especialidad ?? especialidad_id ?? null;
    let danceLevelId = Id_nivel_danza ?? id_nivel_danza ?? grade_id ?? null;
    let yearId = Id_ano ?? academic_year_id ?? null;

    if (!danceLevelId && sectionData.nivel_academico) {
      const ndRes = await db.query(
        "SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) OR LOWER(nivel_danza) LIKE LOWER($2) LIMIT 1",
        [sectionData.nivel_academico.trim(), `%${sectionData.nivel_academico.trim()}%`]
      );
      if (ndRes.rows.length > 0) {
        danceLevelId = ndRes.rows[0].id_nivel_danza;
      }
    }

    if (!yearId) {
      const activeYearRes = await db.query(
        "SELECT id_ano FROM ano_academico WHERE estado_ano = 'en_curso' LIMIT 1"
      );
      yearId = activeYearRes.rows[0]?.id_ano || 1;
    }

    const query = {
      text: `
        INSERT INTO seccion (nombre_seccion, id_ano, id_nivel_danza, id_especialidad)
        VALUES ($1, $2, $3, $4)
        RETURNING 
          id_seccion as id,
          nombre_seccion as section_name,
          30 as capacity,
          id_ano as academic_year_id,
          id_nivel_danza as grade_id,
          id_especialidad as specialty_id
      `,
      values: [nombre_seccion, yearId, danceLevelId, specialtyId],
    };

    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en create section:", error);
    throw error;
  }
};

const update = async (id, sectionData) => {
  try {
    const {
      nombre_seccion,
      Id_ano,
      academic_year_id,
      Id_especialidad,
      especialidad_id,
      Id_nivel_danza,
      id_nivel_danza,
      grade_id,
    } = sectionData;
    const specialtyId = Id_especialidad ?? especialidad_id;
    const danceLevelId = Id_nivel_danza ?? id_nivel_danza ?? grade_id;
    const yearId = Id_ano ?? academic_year_id;

    const query = {
      text: `
        UPDATE seccion
        SET 
          nombre_seccion = COALESCE($1, nombre_seccion),
          id_especialidad = COALESCE($2, id_especialidad),
          id_nivel_danza = COALESCE($3, id_nivel_danza),
          id_ano = COALESCE($4, id_ano)
        WHERE id_seccion = $5
        RETURNING 
          id_seccion as id,
          nombre_seccion as section_name,
          30 as capacity,
          id_ano as academic_year_id,
          id_nivel_danza as grade_id,
          id_especialidad as specialty_id
      `,
      values: [nombre_seccion, specialtyId, danceLevelId, yearId, id],
    };

    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en update section:", error);
    throw error;
  }
};

const remove = async (id) => {
  try {
    const query = {
      text: `DELETE FROM seccion WHERE id_seccion = $1 RETURNING id_seccion as id`,
      values: [id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en remove section:", error);
    throw error;
  }
};

// ============================================
// HORARIOS (SCHEDULES)
// ============================================

const findSchedulesBySectionId = async (sectionId) => {
  try {
    const query = {
      text: `
        SELECT 
          h.id_horario as id,
          h.id_seccion as section_id,
          h.id_aula as classroom_id,
          a.nombre_aula as classroom_name,
          h.id_docente as teacher_id,
          u.id_usuario as user_id,
          p.nombre as teacher_name,
          p.apellido as teacher_lastname,
          h.id_bloque as block_id,
          b.nombre_bloque as block_name,
          b.inicio_bloque as start_time,
          b.fin_bloque as end_time,
          d.id_dia as day_id,
          d.nombre_dia as day_name,
          h.id_materia as subject_id,
          COALESCE(mat.nombre_materia, 'Sin materia') as subject_name
        FROM horario h
        LEFT JOIN aula a ON h.id_aula = a.id_aula
        LEFT JOIN docente doc ON h.id_docente = doc.id_docente
        LEFT JOIN usuario u ON doc.id_usuario = u.id_usuario
        LEFT JOIN persona p ON u.id_persona = p.id_persona
        LEFT JOIN tiempo_bloque b ON h.id_bloque = b.id_bloque
        LEFT JOIN dia d ON b.id_dia = d.id_dia
        LEFT JOIN materia mat ON h.id_materia = mat.id_materia
        WHERE h.id_seccion = $1
        ORDER BY d.id_dia, b.inicio_bloque
      `,
      values: [sectionId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findSchedulesBySectionId:", error);
    throw error;
  }
};

export const addSchedule = async (scheduleData) => {
  try {
    const { sectionId, aula, prof, bloque, materia } = scheduleData;
    const query = {
      text: `
        INSERT INTO horario (id_seccion, id_aula, id_docente, id_bloque, id_materia)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING 
          id_horario as id,
          id_seccion as section_id,
          id_aula as classroom_id,
          id_docente as teacher_id,
          id_bloque as block_id,
          id_materia as subject_id
      `,
      values: [sectionId, aula, prof, bloque, materia],
    };

    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en addSchedule:", error);
    throw error;
  }
};

const removeSchedule = async (scheduleId) => {
  try {
    const query = {
      text: `DELETE FROM horario WHERE id_horario = $1 RETURNING id_horario as id`,
      values: [scheduleId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en removeSchedule:", error);
    throw error;
  }
};

// ============================================
// VERIFICAR DISPONIBILIDAD DE AULA
// ============================================

const checkClassroomAvailability = async ({
  academicYearId,
  day,
  startTime,
  endTime,
  classroom,
  excludeSectionId,
}) => {
  try {
    const dayMap = {
      LUNES: 1,
      MARTES: 2,
      MIÉRCOLES: 3,
      MIERCOLES: 3,
      JUEVES: 4,
      VIERNES: 5,
      SÁBADO: 6,
      SABADO: 6,
    };
    const dayId = dayMap[day?.toUpperCase()];

    if (!dayId) {
      return { available: false, error: "Día inválido" };
    }

    const blocksQuery = {
      text: `
        SELECT id_bloque as id
        FROM tiempo_bloque
        WHERE id_dia = $1 AND ($2::time, $3::time) OVERLAPS (inicio_bloque, fin_bloque)
      `,
      values: [dayId, startTime, endTime],
    };
    const blocks = await db.query(blocksQuery.text, blocksQuery.values);
    const blockIds = blocks.rows.map((b) => b.id);

    if (blockIds.length === 0) {
      return { available: true };
    }

    let conflictQuery = {
      text: `
        SELECT 
          h.id_horario as id,
          s.nombre_seccion as section_name,
          b.nombre_bloque as block_name,
          b.inicio_bloque as start_time,
          b.fin_bloque as end_time,
          d.nombre_dia as day_name
        FROM horario h
        JOIN seccion s ON h.id_seccion = s.id_seccion
        JOIN tiempo_bloque b ON h.id_bloque = b.id_bloque
        JOIN dia d ON b.id_dia = d.id_dia
        WHERE h.id_aula = (SELECT id_aula FROM aula WHERE nombre_aula = $1 LIMIT 1)
          AND b.id_dia = $2
          AND h.id_bloque = ANY($3::int[])
      `,
      values: [classroom, dayId, blockIds],
    };

    if (excludeSectionId) {
      conflictQuery.text += ` AND h.id_seccion != $4`;
      conflictQuery.values.push(excludeSectionId);
    }

    const conflicts = await db.query(conflictQuery.text, conflictQuery.values);

    if (conflicts.rows.length > 0) {
      const conflict = conflicts.rows[0];
      return {
        available: false,
        conflict: {
          sectionName: conflict.section_name,
          startTime: conflict.start_time,
          endTime: conflict.end_time,
        },
      };
    }

    return { available: true };
  } catch (error) {
    console.error("Error en checkClassroomAvailability:", error);
    throw error;
  }
};

const getStudentsBySection = async (sectionId) => {
  try {
    const query = {
      text: `
        SELECT 
          e.id_estudiante as id,
          p.nombre as first_name,
          p.apellido as last_name,
          p.cedula as dni,
          p.fecha_nacimiento as birth_date,
          p.genero as gender,
          CONCAT(p_rep.nombre, ' ', p_rep.apellido) as representative_name,
          p_rep.numero_telefono as representative_phone,
          p_rep.email as representative_email
        FROM inscripcion i
        JOIN estudiante e ON i.id_estudiante = e.id_estudiante
        JOIN persona p ON e.id_persona = p.id_persona
        LEFT JOIN representante r ON e.id_representante = r.id_representante
        LEFT JOIN persona p_rep ON r.id_persona = p_rep.id_persona
        WHERE i.id_seccion = $1 AND i.estado_inscripcion = 'activo'
        ORDER BY p.apellido, p.nombre
      `,
      values: [sectionId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en getStudentsBySection:", error);
    throw error;
  }
};

const getEvaluationStructure = async (sectionId) => {
  try {
    const query = {
      text: `
        SELECT 
          ee.id_estructura_evaluacion as id,
          ee.numero_evaluacion as numero,
          ee.porcentaje as peso,
          te.nombre_evaluacion as tipo
        FROM estructura_evaluacion ee
        LEFT JOIN tipo_evaluacion te ON ee.id_tipo_evaluacion = te.id_tipo_evaluacion
        WHERE ee.id_seccion = $1
        ORDER BY ee.numero_evaluacion
      `,
      values: [sectionId],
    };
    const { rows } = await db.query(query.text, query.values);
    if (rows.length === 0) return null;
    return rows;
  } catch (error) {
    console.error("Error en getEvaluationStructure:", error);
    throw error;
  }
};

export const SectionModel = {
  findAll,
  findById,
  create,
  update,
  remove,
  findSchedulesBySectionId,
  addSchedule,
  removeSchedule,
  checkClassroomAvailability,
  getStudentsBySection,
  getEvaluationStructure,
};