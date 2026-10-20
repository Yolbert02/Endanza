// models/schedule.model.js
import { db } from "../db/connection.database.js";

// ============================================
// SECCIONES
// ============================================

const findAllSections = async (academicYearId = null) => {
    try {
        let query;
        if (academicYearId) {
            query = {
                text: `
                    SELECT 
                        s.id_seccion as id,
                        s.nombre_seccion as section_letter,
                        CASE 
                            WHEN s.nombre_seccion IS NULL OR s.nombre_seccion = '' OR s.nombre_seccion = 'Única' THEN 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '')
                            WHEN LENGTH(s.nombre_seccion) <= 2 THEN 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                            WHEN POSITION(REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') IN s.nombre_seccion) > 0 THEN 
                                s.nombre_seccion
                            ELSE 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                        END as section_name,
                        COALESCE(nd.nivel_danza, 'General') as grade_level,
                        s.id_nivel_danza as grade_id,
                        COALESCE(nd.nivel_danza, 'General') as grade_name,
                        s.id_especialidad as specialty_id,
                        COALESCE(esp.nombre_especialidad, '') as specialty_name,
                        30 as capacity,
                        NULL::integer as subject_id,
                        NULL as period_id,
                        s.id_ano as academic_year_id,
                        'General'::text as subject_name,
                        'Período 1' as period_name,
                        a.nombre_ano as academic_year_name,
                        COALESCE(
                            (
                                SELECT json_agg(
                                    json_build_object(
                                        'id', hor.id_horario,
                                        'day_id', hor_d.id_dia,
                                        'day_name', hor_d.nombre_dia,
                                        'block_id', hor_b.id_bloque,
                                        'block_name', hor_b.nombre_bloque,
                                        'start_time', hor_b.inicio_bloque,
                                        'end_time', hor_b.fin_bloque,
                                        'classroom_id', hor.id_aula,
                                        'classroom_name', hor_au.nombre_aula,
                                        'teacher_id', hor.id_docente,
                                        'teacher_name', CONCAT(p_doc.nombre, ' ', p_doc.apellido),
                                        'teacher_user_id', u_doc.id_usuario,
                                        'auxiliary_teacher_id', hor.id_docente_auxiliar,
                                        'auxiliary_teacher_name', CASE WHEN p_doc_aux.nombre IS NOT NULL THEN CONCAT(p_doc_aux.nombre, ' ', p_doc_aux.apellido) ELSE NULL END,
                                        'auxiliary_teacher_user_id', u_doc_aux.id_usuario,
                                        'subject_id', hor.id_materia,
                                        'subject_name', COALESCE(hor_mat.nombre_materia, 'Sin materia')
                                    )
                                    ORDER BY hor_d.id_dia, hor_b.inicio_bloque
                                )
                                FROM horario hor
                                LEFT JOIN tiempo_bloque hor_b ON hor.id_bloque = hor_b.id_bloque
                                LEFT JOIN dia hor_d ON hor_b.id_dia = hor_d.id_dia
                                LEFT JOIN aula hor_au ON hor.id_aula = hor_au.id_aula
                                LEFT JOIN docente hor_doc ON hor.id_docente = hor_doc.id_docente
                                LEFT JOIN usuario u_doc ON hor_doc.id_usuario = u_doc.id_usuario
                                LEFT JOIN persona p_doc ON u_doc.id_persona = p_doc.id_persona
                                LEFT JOIN docente hor_doc_aux ON hor.id_docente_auxiliar = hor_doc_aux.id_docente
                                LEFT JOIN usuario u_doc_aux ON hor_doc_aux.id_usuario = u_doc_aux.id_usuario
                                LEFT JOIN persona p_doc_aux ON u_doc_aux.id_persona = p_doc_aux.id_persona
                                LEFT JOIN materia hor_mat ON hor.id_materia = hor_mat.id_materia
                                WHERE hor.id_seccion = s.id_seccion
                            ),
                            '[]'::json
                        ) as schedules,
                        0 as total_hours
                    FROM seccion s
                    LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
                    LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
                    LEFT JOIN especialidad esp ON s.id_especialidad = esp.id_especialidad
                    WHERE s.id_ano = $1
                    GROUP BY s.id_seccion, s.nombre_seccion, nd.nivel_danza, s.id_nivel_danza, s.id_especialidad, esp.nombre_especialidad, s.id_ano, a.nombre_ano
                    ORDER BY nd.nivel_danza, s.id_seccion DESC
                `,
                values: [academicYearId]
            };
        } else {
            query = {
                text: `
                    SELECT 
                        s.id_seccion as id,
                        s.nombre_seccion as section_letter,
                        CASE 
                            WHEN s.nombre_seccion IS NULL OR s.nombre_seccion = '' OR s.nombre_seccion = 'Única' THEN 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '')
                            WHEN LENGTH(s.nombre_seccion) <= 2 THEN 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                            WHEN POSITION(REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') IN s.nombre_seccion) > 0 THEN 
                                s.nombre_seccion
                            ELSE 
                                REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                        END as section_name,
                        COALESCE(nd.nivel_danza, 'General') as grade_level,
                        s.id_nivel_danza as grade_id,
                        COALESCE(nd.nivel_danza, 'General') as grade_name,
                        s.id_especialidad as specialty_id,
                        COALESCE(esp.nombre_especialidad, '') as specialty_name,
                        30 as capacity,
                        NULL::integer as subject_id,
                        NULL as period_id,
                        s.id_ano as academic_year_id,
                        'General'::text as subject_name,
                        'Período 1' as period_name,
                        a.nombre_ano as academic_year_name,
                        COALESCE(
                            (
                                SELECT json_agg(
                                    json_build_object(
                                        'id', hor.id_horario,
                                        'day_id', hor_d.id_dia,
                                        'day_name', hor_d.nombre_dia,
                                        'block_id', hor_b.id_bloque,
                                        'block_name', hor_b.nombre_bloque,
                                        'start_time', hor_b.inicio_bloque,
                                        'end_time', hor_b.fin_bloque,
                                        'classroom_id', hor.id_aula,
                                        'classroom_name', hor_au.nombre_aula,
                                        'teacher_id', hor.id_docente,
                                        'teacher_name', CONCAT(p_doc.nombre, ' ', p_doc.apellido),
                                        'teacher_user_id', u_doc.id_usuario,
                                        'auxiliary_teacher_id', hor.id_docente_auxiliar,
                                        'auxiliary_teacher_name', CASE WHEN p_doc_aux.nombre IS NOT NULL THEN CONCAT(p_doc_aux.nombre, ' ', p_doc_aux.apellido) ELSE NULL END,
                                        'auxiliary_teacher_user_id', u_doc_aux.id_usuario,
                                        'subject_id', hor.id_materia,
                                        'subject_name', COALESCE(hor_mat.nombre_materia, 'Sin materia')
                                    )
                                    ORDER BY hor_d.id_dia, hor_b.inicio_bloque
                                )
                                FROM horario hor
                                LEFT JOIN tiempo_bloque hor_b ON hor.id_bloque = hor_b.id_bloque
                                LEFT JOIN dia hor_d ON hor_b.id_dia = hor_d.id_dia
                                LEFT JOIN aula hor_au ON hor.id_aula = hor_au.id_aula
                                LEFT JOIN docente hor_doc ON hor.id_docente = hor_doc.id_docente
                                LEFT JOIN usuario u_doc ON hor_doc.id_usuario = u_doc.id_usuario
                                LEFT JOIN persona p_doc ON u_doc.id_persona = p_doc.id_persona
                                LEFT JOIN docente hor_doc_aux ON hor.id_docente_auxiliar = hor_doc_aux.id_docente
                                LEFT JOIN usuario u_doc_aux ON hor_doc_aux.id_usuario = u_doc_aux.id_usuario
                                LEFT JOIN persona p_doc_aux ON u_doc_aux.id_persona = p_doc_aux.id_persona
                                LEFT JOIN materia hor_mat ON hor.id_materia = hor_mat.id_materia
                                WHERE hor.id_seccion = s.id_seccion
                            ),
                            '[]'::json
                        ) as schedules,
                        0 as total_hours
                    FROM seccion s
                    LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
                    LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
                    LEFT JOIN especialidad esp ON s.id_especialidad = esp.id_especialidad
                    GROUP BY s.id_seccion, s.nombre_seccion, nd.nivel_danza, s.id_nivel_danza, s.id_especialidad, esp.nombre_especialidad, s.id_ano, a.nombre_ano
                    ORDER BY nd.nivel_danza, s.id_seccion DESC
                `
            };
        }

        const { rows } = await db.query(query.text, query.values || []);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.findAllSections:", error);
        throw error;
    }
};

const findSectionById = async (id) => {
    try {
        const query = {
            text: `
                SELECT 
                    s.id_seccion as id,
                    s.nombre_seccion as section_letter,
                    CASE 
                        WHEN s.nombre_seccion IS NULL OR s.nombre_seccion = '' OR s.nombre_seccion = 'Única' THEN 
                            REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '')
                        WHEN LENGTH(s.nombre_seccion) <= 2 THEN 
                            REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                        WHEN POSITION(REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') IN s.nombre_seccion) > 0 THEN 
                            s.nombre_seccion
                        ELSE 
                            REGEXP_REPLACE(COALESCE(nd.nivel_danza, 'General'), ' - .*$', '') || ' ' || s.nombre_seccion
                    END as section_name,
                    COALESCE(nd.nivel_danza, 'General') as grade_level,
                    s.id_nivel_danza as grade_id,
                    COALESCE(nd.nivel_danza, 'General') as grade_name,
                    s.id_especialidad as specialty_id,
                    COALESCE(esp.nombre_especialidad, '') as specialty_name,
                    30 as capacity,
                    s.id_ano as academic_year_id,
                    a.nombre_ano as academic_year_name,
                    COALESCE(
                        (
                            SELECT json_agg(
                                json_build_object(
                                    'id', hor.id_horario,
                                    'day_id', hor_d.id_dia,
                                    'day_name', hor_d.nombre_dia,
                                    'block_id', hor_b.id_bloque,
                                    'block_name', hor_b.nombre_bloque,
                                    'start_time', hor_b.inicio_bloque,
                                    'end_time', hor_b.fin_bloque,
                                    'classroom_id', hor.id_aula,
                                    'classroom_name', hor_au.nombre_aula,
                                    'teacher_id', hor.id_docente,
                                    'teacher_name', CONCAT(p_doc.nombre, ' ', p_doc.apellido),
                                    'teacher_user_id', u_doc.id_usuario,
                                    'auxiliary_teacher_id', hor.id_docente_auxiliar,
                                    'auxiliary_teacher_name', CASE WHEN p_doc_aux.nombre IS NOT NULL THEN CONCAT(p_doc_aux.nombre, ' ', p_doc_aux.apellido) ELSE NULL END,
                                    'auxiliary_teacher_user_id', u_doc_aux.id_usuario,
                                    'subject_id', hor.id_materia,
                                    'subject_name', COALESCE(hor_mat.nombre_materia, 'Sin materia')
                                )
                                ORDER BY hor_d.id_dia, hor_b.inicio_bloque
                            )
                            FROM horario hor
                            LEFT JOIN tiempo_bloque hor_b ON hor.id_bloque = hor_b.id_bloque
                            LEFT JOIN dia hor_d ON hor_b.id_dia = hor_d.id_dia
                            LEFT JOIN aula hor_au ON hor.id_aula = hor_au.id_aula
                            LEFT JOIN docente hor_doc ON hor.id_docente = hor_doc.id_docente
                            LEFT JOIN usuario u_doc ON hor_doc.id_usuario = u_doc.id_usuario
                            LEFT JOIN persona p_doc ON u_doc.id_persona = p_doc.id_persona
                            LEFT JOIN docente hor_doc_aux ON hor.id_docente_auxiliar = hor_doc_aux.id_docente
                            LEFT JOIN usuario u_doc_aux ON hor_doc_aux.id_usuario = u_doc_aux.id_usuario
                            LEFT JOIN persona p_doc_aux ON u_doc_aux.id_persona = p_doc_aux.id_persona
                            LEFT JOIN materia hor_mat ON hor.id_materia = hor_mat.id_materia
                            WHERE hor.id_seccion = s.id_seccion
                        ),
                        '[]'::json
                    ) as schedules,
                    COALESCE(
                        (
                            SELECT SUM(EXTRACT(EPOCH FROM (hor_b.fin_bloque - hor_b.inicio_bloque)) / 3600)
                            FROM horario hor
                            JOIN tiempo_bloque hor_b ON hor.id_bloque = hor_b.id_bloque
                            WHERE hor.id_seccion = s.id_seccion
                        ),
                        0
                    ) as total_hours
                FROM seccion s
                LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
                LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
                LEFT JOIN especialidad esp ON s.id_especialidad = esp.id_especialidad
                WHERE s.id_seccion = $1
            `,
            values: [id]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.findSectionById:", error);
        throw error;
    }
};

const createSection = async (sectionData) => {
    try {
        const { section_name, grade_level, academic_year_id } = sectionData;

        let finalYearId = academic_year_id;
        if (!finalYearId) {
            const yearResult = await db.query(
                `SELECT id_ano FROM ano_academico WHERE estado_ano = 'en_curso' LIMIT 1`
            );
            finalYearId = yearResult.rows[0]?.id_ano;
        }
        if (!finalYearId) {
            const lastYear = await db.query(`SELECT id_ano FROM ano_academico ORDER BY id_ano DESC LIMIT 1`);
            finalYearId = lastYear.rows[0]?.id_ano;
        }
        if (!finalYearId) {
            throw new Error('No se pudo determinar un año académico válido');
        }

        // Resolver id_nivel_danza
        let nivelDanzaId = null;
        if (grade_level) {
            if (!isNaN(Number(grade_level))) {
                nivelDanzaId = Number(grade_level);
            } else {
                const nivelRes = await db.query(
                    `SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) LIMIT 1`,
                    [String(grade_level).trim()]
                );
                if (nivelRes.rows.length > 0) {
                    nivelDanzaId = nivelRes.rows[0].id_nivel_danza;
                }
            }
        }
        if (!nivelDanzaId) {
            const defaultNivel = await db.query(`SELECT id_nivel_danza FROM nivel_danza LIMIT 1`);
            nivelDanzaId = defaultNivel.rows[0]?.id_nivel_danza || null;
        }

        const query = {
            text: `
                INSERT INTO seccion (nombre_seccion, id_ano, id_nivel_danza)
                VALUES ($1, $2, $3)
                RETURNING 
                    id_seccion as id,
                    nombre_seccion as section_name,
                    id_ano as academic_year_id,
                    id_nivel_danza as grade_id
            `,
            values: [section_name, finalYearId, nivelDanzaId]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.createSection:", error);
        throw error;
    }
};

const updateSection = async (id, sectionData) => {
    try {
        const { section_name, grade_level } = sectionData;

        let nivelDanzaId = null;
        if (grade_level) {
            if (!isNaN(Number(grade_level))) {
                nivelDanzaId = Number(grade_level);
            } else {
                const nivelRes = await db.query(
                    `SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) LIMIT 1`,
                    [String(grade_level).trim()]
                );
                if (nivelRes.rows.length > 0) {
                    nivelDanzaId = nivelRes.rows[0].id_nivel_danza;
                }
            }
        }

        const query = {
            text: `
                UPDATE seccion
                SET 
                    nombre_seccion = COALESCE($1, nombre_seccion),
                    id_nivel_danza = COALESCE($2, id_nivel_danza)
                WHERE id_seccion = $3
                RETURNING 
                    id_seccion as id,
                    nombre_seccion as section_name,
                    id_ano as academic_year_id,
                    id_nivel_danza as grade_id
            `,
            values: [section_name, nivelDanzaId, id]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.updateSection:", error);
        throw error;
    }
};

const deleteSection = async (id) => {
    try {
        const studentCheck = await db.query(
            'SELECT COUNT(*) as count FROM inscripcion WHERE id_seccion = $1',
            [id]
        );

        if (Number(studentCheck.rows[0].count) > 0) {
            throw new Error(`La sección tiene ${studentCheck.rows[0].count} estudiantes inscritos. No se puede eliminar.`);
        }

        await db.query('BEGIN');
        try {
            await db.query(
                `DELETE FROM asistencia WHERE id_horario IN (SELECT id_horario FROM horario WHERE id_seccion = $1)`,
                [id]
            );
            await db.query('DELETE FROM estructura_evaluacion WHERE id_seccion = $1', [id]);
            await db.query('DELETE FROM horario WHERE id_seccion = $1', [id]);

            const query = {
                text: 'DELETE FROM seccion WHERE id_seccion = $1 RETURNING id_seccion as id',
                values: [id]
            };
            const { rows } = await db.query(query.text, query.values);
            await db.query('COMMIT');
            return rows[0];
        } catch (error) {
            await db.query('ROLLBACK');
            throw error;
        }
    } catch (error) {
        console.error("❌ Error en schedule.deleteSection:", error);
        if (error.code === '23503') {
            throw new Error('No se puede eliminar la sección porque tiene relaciones activas.');
        }
        throw error;
    }
};

// ============================================
// HORARIOS
// ============================================

const findAllSchedules = async (filters = {}) => {
    try {
        let queryText = `
            SELECT 
                h.id_horario as id,
                h.id_seccion as section_id,
                s.nombre_seccion as section_name,
                h.id_aula as classroom_id,
                a.nombre_aula as classroom_name,
                h.id_docente as teacher_id,
                CONCAT(p.nombre, ' ', p.apellido) as teacher_name,
                u.id_usuario as teacher_user_id,
                h.id_bloque as block_id,
                b.nombre_bloque as block_name,
                b.inicio_bloque as start_time,
                b.fin_bloque as end_time,
                b.id_dia as day_id,
                d.nombre_dia as day_name,
                h.id_materia as subject_id,
                m.nombre_materia as subject_name,
                s.id_ano as academic_year_id,
                an.nombre_ano as academic_year_name
            FROM horario h
            LEFT JOIN seccion s ON h.id_seccion = s.id_seccion
            LEFT JOIN aula a ON h.id_aula = a.id_aula
            LEFT JOIN docente doc ON h.id_docente = doc.id_docente
            LEFT JOIN usuario u ON doc.id_usuario = u.id_usuario
            LEFT JOIN persona p ON u.id_persona = p.id_persona
            LEFT JOIN tiempo_bloque b ON h.id_bloque = b.id_bloque
            LEFT JOIN dia d ON b.id_dia = d.id_dia
            LEFT JOIN materia m ON h.id_materia = m.id_materia
            LEFT JOIN ano_academico an ON s.id_ano = an.id_ano
            WHERE 1=1
        `;

        const values = [];
        let paramIndex = 1;

        if (filters.academicYearId) {
            queryText += ` AND s.id_ano = $${paramIndex}`;
            values.push(filters.academicYearId);
            paramIndex++;
        }

        if (filters.sectionId) {
            queryText += ` AND h.id_seccion = $${paramIndex}`;
            values.push(filters.sectionId);
            paramIndex++;
        }

        if (filters.teacherId) {
            queryText += ` AND h.id_docente = $${paramIndex}`;
            values.push(filters.teacherId);
            paramIndex++;
        }

        if (filters.dayId) {
            queryText += ` AND b.id_dia = $${paramIndex}`;
            values.push(filters.dayId);
            paramIndex++;
        }

        queryText += ` ORDER BY b.id_dia, b.inicio_bloque`;

        const { rows } = await db.query(queryText, values);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.findAllSchedules:", error);
        throw error;
    }
};

const createSchedule = async (scheduleData) => {
    try {
        const { section_id, classroom_id, teacher_id, block_id, day_id, subject_id } = scheduleData;

        // Verificar sección
        const sectionCheck = await db.query(
            'SELECT id_seccion, id_ano FROM seccion WHERE id_seccion = $1',
            [section_id]
        );
        if (sectionCheck.rows.length === 0) {
            throw new Error(`La sección ${section_id} no existe`);
        }
        const academicYearId = sectionCheck.rows[0].id_ano;

        // Resolver id_docente
        let resolvedDocenteId = null;
        const docQuery = await db.query(
            `SELECT id_docente FROM docente WHERE id_usuario = $1 OR id_docente = $1 LIMIT 1`,
            [teacher_id]
        );
        if (docQuery.rows.length > 0) {
            resolvedDocenteId = docQuery.rows[0].id_docente;
        } else {
            throw new Error(`El usuario o docente ${teacher_id} no tiene registro en la tabla docente.`);
        }

        // Resolver bloque y día
        let finalBlockId = block_id;
        if (!finalBlockId && day_id) {
            const blockRes = await db.query(`SELECT id_bloque FROM tiempo_bloque WHERE id_dia = $1 LIMIT 1`, [day_id]);
            finalBlockId = blockRes.rows[0]?.id_bloque;
        }

        // Resolver materia
        const subjectName = scheduleData.subject_name || (isNaN(Number(subject_id)) ? subject_id : null);
        let resolvedSubjectId = null;
        if (subjectName) {
            const matByName = await db.query(
                `SELECT id_materia FROM materia WHERE TRIM(LOWER(nombre_materia)) = TRIM(LOWER($1)) LIMIT 1`,
                [String(subjectName).trim()]
            );
            if (matByName.rows.length > 0) {
                resolvedSubjectId = matByName.rows[0].id_materia;
            } else {
                const newMat = await db.query(
                    `INSERT INTO materia (nombre_materia, tipo_materia) VALUES ($1, 'practica') RETURNING id_materia`,
                    [String(subjectName).trim()]
                );
                resolvedSubjectId = newMat.rows[0].id_materia;
            }
        }
        if (!resolvedSubjectId && subject_id && !isNaN(Number(subject_id))) {
            const matById = await db.query(
                `SELECT id_materia FROM materia WHERE id_materia = $1 LIMIT 1`,
                [Number(subject_id)]
            );
            if (matById.rows.length > 0) {
                resolvedSubjectId = matById.rows[0].id_materia;
            }
        }

        // Validar disponibilidad
        const isAvailable = await checkAvailability({
            sectionId: section_id,
            academicYearId,
            blockId: finalBlockId,
            classroomId: classroom_id,
            teacherId: resolvedDocenteId,
            excludeScheduleId: null
        });

        if (!isAvailable.available) {
            throw new Error(isAvailable.message || 'Conflicto de horario');
        }

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
            values: [section_id, classroom_id, resolvedDocenteId, finalBlockId, resolvedSubjectId]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.createSchedule:", error);
        if (error.code === '23505') {
            throw new Error('Conflicto: Horario ya asignado para ese bloque o aula');
        }
        throw error;
    }
};

const updateSchedule = async (id, scheduleData) => {
    try {
        const { classroom_id, teacher_id, block_id, subject_id } = scheduleData;

        const currentSchedule = await db.query(
            `SELECT h.*, s.id_ano as academic_year_id
             FROM horario h
             LEFT JOIN seccion s ON h.id_seccion = s.id_seccion
             WHERE h.id_horario = $1`,
            [id]
        );

        if (currentSchedule.rows.length === 0) {
            throw new Error('Horario no encontrado');
        }

        let resolvedDocenteId = teacher_id;
        if (teacher_id) {
            const docRes = await db.query(
                `SELECT id_docente FROM docente WHERE id_docente = $1 OR id_usuario = $1 LIMIT 1`,
                [teacher_id]
            );
            if (docRes.rows.length > 0) {
                resolvedDocenteId = docRes.rows[0].id_docente;
            }
        }

        const targetBlockId = block_id || currentSchedule.rows[0].id_bloque;
        const targetClassroomId = classroom_id || currentSchedule.rows[0].id_aula;

        const isAvailable = await checkAvailability({
            sectionId: currentSchedule.rows[0].id_seccion,
            academicYearId: currentSchedule.rows[0].academic_year_id,
            blockId: targetBlockId,
            classroomId: targetClassroomId,
            teacherId: resolvedDocenteId || currentSchedule.rows[0].id_docente,
            excludeScheduleId: id
        });

        if (!isAvailable.available) {
            throw new Error(isAvailable.message || 'Conflicto de horario');
        }

        let resolvedSubjectId = subject_id !== undefined ? subject_id : null;
        if (scheduleData.subject_name) {
            const matByName = await db.query(
                `SELECT id_materia FROM materia WHERE TRIM(LOWER(nombre_materia)) = TRIM(LOWER($1)) LIMIT 1`,
                [String(scheduleData.subject_name).trim()]
            );
            if (matByName.rows.length > 0) {
                resolvedSubjectId = matByName.rows[0].id_materia;
            } else {
                const newMat = await db.query(
                    `INSERT INTO materia (nombre_materia, tipo_materia) VALUES ($1, 'practica') RETURNING id_materia`,
                    [String(scheduleData.subject_name).trim()]
                );
                resolvedSubjectId = newMat.rows[0].id_materia;
            }
        }

        const query = {
            text: `
                UPDATE horario
                SET 
                    id_aula = COALESCE($1, id_aula),
                    id_docente = COALESCE($2, id_docente),
                    id_bloque = COALESCE($3, id_bloque),
                    id_materia = COALESCE($4, id_materia)
                WHERE id_horario = $5
                RETURNING 
                    id_horario as id,
                    id_seccion as section_id,
                    id_aula as classroom_id,
                    id_docente as teacher_id,
                    id_bloque as block_id,
                    id_materia as subject_id
            `,
            values: [classroom_id, resolvedDocenteId, block_id, resolvedSubjectId, id]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.updateSchedule:", error);
        throw error;
    }
};

const deleteSchedule = async (id) => {
    try {
        await db.query('DELETE FROM asistencia WHERE id_horario = $1', [id]);
        const query = {
            text: 'DELETE FROM horario WHERE id_horario = $1 RETURNING id_horario as id',
            values: [id]
        };
        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.deleteSchedule:", error);
        throw error;
    }
};

// ============================================
// VALIDACIÓN DE DISPONIBILIDAD
// ============================================

const checkAvailability = async (params = {}) => {
    try {
        const academicYearId = params.academicYearId || params.academic_year_id;
        const blockId = params.blockId || params.block_id;
        const classroomId = params.classroomId || params.classroom_id;
        const teacherId = params.teacherId || params.teacher_id;
        const sectionId = params.sectionId || params.section_id;
        const excludeScheduleId = params.excludeScheduleId || params.exclude_schedule_id;

        let resolvedTeacherId = teacherId;
        if (teacherId) {
            const docCheck = await db.query(
                `SELECT id_docente FROM docente WHERE id_docente = $1 OR id_usuario = $1 LIMIT 1`,
                [teacherId]
            );
            if (docCheck.rows.length > 0) {
                resolvedTeacherId = docCheck.rows[0].id_docente;
            }
        }

        // 1. Disponibilidad de la sección: una misma sección no puede tener dos clases al mismo tiempo
        if (sectionId && blockId) {
            let sectionQuery = `
                SELECT 
                    h.id_horario, 
                    s.nombre_seccion, 
                    a.nombre_aula as classroom_name,
                    CONCAT(p.nombre, ' ', p.apellido) as teacher_name
                FROM horario h
                LEFT JOIN seccion s ON h.id_seccion = s.id_seccion
                LEFT JOIN aula a ON h.id_aula = a.id_aula
                LEFT JOIN docente doc ON h.id_docente = doc.id_docente
                LEFT JOIN usuario u ON doc.id_usuario = u.id_usuario
                LEFT JOIN persona p ON u.id_persona = p.id_persona
                WHERE h.id_seccion = $1 
                  AND h.id_bloque = $2
            `;
            const sectionValues = [sectionId, blockId];
            let sIdx = 3;

            if (excludeScheduleId) {
                sectionQuery += ` AND h.id_horario != $${sIdx}`;
                sectionValues.push(excludeScheduleId);
                sIdx++;
            }

            const sectionConflict = await db.query(sectionQuery, sectionValues);

            if (sectionConflict.rows.length > 0) {
                return {
                    available: false,
                    message: `La sección ${sectionConflict.rows[0].nombre_seccion || ''} ya tiene una clase asignada en este bloque con ${sectionConflict.rows[0].teacher_name || 'otro docente'} en ${sectionConflict.rows[0].classroom_name || 'otra aula'}`,
                    conflict: {
                        type: 'section',
                        section: sectionConflict.rows[0].nombre_seccion,
                        classroom: sectionConflict.rows[0].classroom_name,
                        teacher: sectionConflict.rows[0].teacher_name
                    }
                };
            }
        }

        // 2. Disponibilidad del aula:
        // Si el aula está ocupada en este bloque, se PERMITE si es el MISMO docente (secciones/grados unidos).
        // Se RECHAZA solo si es con OTRO docente diferente.
        if (classroomId && blockId) {
            let classroomQuery = `
                SELECT 
                    h.id_horario, 
                    s.nombre_seccion, 
                    CONCAT(p.nombre, ' ', p.apellido) as teacher_name
                FROM horario h
                LEFT JOIN seccion s ON h.id_seccion = s.id_seccion
                LEFT JOIN docente doc ON h.id_docente = doc.id_docente
                LEFT JOIN usuario u ON doc.id_usuario = u.id_usuario
                LEFT JOIN persona p ON u.id_persona = p.id_persona
                WHERE h.id_aula = $1 
                  AND h.id_bloque = $2
            `;
            const classroomValues = [classroomId, blockId];
            let classroomParamIdx = 3;

            // Si se conoce el docente, solo es conflicto si es OTRO docente diferente
            if (resolvedTeacherId) {
                classroomQuery += ` AND h.id_docente != $${classroomParamIdx}`;
                classroomValues.push(resolvedTeacherId);
                classroomParamIdx++;
            }

            if (academicYearId) {
                classroomQuery += ` AND s.id_ano = $${classroomParamIdx}`;
                classroomValues.push(academicYearId);
                classroomParamIdx++;
            }

            if (excludeScheduleId) {
                classroomQuery += ` AND h.id_horario != $${classroomParamIdx}`;
                classroomValues.push(excludeScheduleId);
                classroomParamIdx++;
            }

            const classroomConflict = await db.query(classroomQuery, classroomValues);

            if (classroomConflict.rows.length > 0) {
                return {
                    available: false,
                    message: `El aula seleccionada ya está ocupada por ${classroomConflict.rows[0].teacher_name || 'otro docente'} en la sección ${classroomConflict.rows[0].nombre_seccion || ''}`,
                    conflict: {
                        type: 'classroom',
                        section: classroomConflict.rows[0].nombre_seccion,
                        teacher: classroomConflict.rows[0].teacher_name
                    }
                };
            }
        }

        // 3. Disponibilidad del profesor:
        // Si el docente ya tiene una clase en este bloque, se PERMITE si es en la MISMA aula (secciones fusionadas).
        // Se RECHAZA solo si es en OTRA aula diferente.
        if (resolvedTeacherId && blockId) {
            let teacherQuery = `
                SELECT 
                    h.id_horario, 
                    s.nombre_seccion, 
                    a.nombre_aula as classroom_name
                FROM horario h
                LEFT JOIN seccion s ON h.id_seccion = s.id_seccion
                LEFT JOIN aula a ON h.id_aula = a.id_aula
                WHERE h.id_docente = $1 
                  AND h.id_bloque = $2
            `;
            const teacherValues = [resolvedTeacherId, blockId];
            let teacherParamIdx = 3;

            // Si se conoce el aula, solo es conflicto si está en OTRA aula diferente
            if (classroomId) {
                teacherQuery += ` AND h.id_aula != $${teacherParamIdx}`;
                teacherValues.push(classroomId);
                teacherParamIdx++;
            }

            if (academicYearId) {
                teacherQuery += ` AND s.id_ano = $${teacherParamIdx}`;
                teacherValues.push(academicYearId);
                teacherParamIdx++;
            }

            if (excludeScheduleId) {
                teacherQuery += ` AND h.id_horario != $${teacherParamIdx}`;
                teacherValues.push(excludeScheduleId);
                teacherParamIdx++;
            }

            const teacherConflict = await db.query(teacherQuery, teacherValues);

            if (teacherConflict.rows.length > 0) {
                return {
                    available: false,
                    message: `El docente ya tiene una clase asignada en este bloque en otra aula (${teacherConflict.rows[0].classroom_name || ''}, sección ${teacherConflict.rows[0].nombre_seccion || ''})`,
                    conflict: {
                        type: 'teacher',
                        section: teacherConflict.rows[0].nombre_seccion,
                        classroom: teacherConflict.rows[0].classroom_name
                    }
                };
            }
        }

        return { available: true };
    } catch (error) {
        console.error("❌ Error en schedule.checkAvailability:", error);
        throw error;
    }
};

// ============================================
// CATÁLOGOS
// ============================================

const getAllClassrooms = async () => {
    try {
        const query = {
            text: `
                SELECT 
                    id_aula as id,
                    nombre_aula as name,
                    id_tipo_aula as type_id
                FROM aula
                ORDER BY nombre_aula
            `
        };
        const { rows } = await db.query(query.text);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.getAllClassrooms:", error);
        throw error;
    }
};

const getAllDays = async () => {
    try {
        const query = {
            text: `
                SELECT 
                    id_dia as id,
                    nombre_dia as name
                FROM dia
                ORDER BY id_dia
            `
        };
        const { rows } = await db.query(query.text);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.getAllDays:", error);
        throw error;
    }
};

const getAllBlocks = async () => {
    try {
        const query = {
            text: `
                SELECT 
                    b.id_bloque as id,
                    b.nombre_bloque as name,
                    b.inicio_bloque as start_time,
                    b.fin_bloque as end_time,
                    b.id_dia as day_id,
                    d.nombre_dia as day_name
                FROM tiempo_bloque b
                LEFT JOIN dia d ON b.id_dia = d.id_dia
                ORDER BY b.id_dia, b.inicio_bloque
            `
        };
        const { rows } = await db.query(query.text);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.getAllBlocks:", error);
        throw error;
    }
};

// ============================================
// EXPORTAR MODELO
// ============================================

export const ScheduleModel = {
    findAllSections,
    findSectionById,
    createSection,
    updateSection,
    deleteSection,
    findAllSchedules,
    createSchedule,
    updateSchedule,
    deleteSchedule,
    checkAvailability,
    getAllClassrooms,
    getAllDays,
    getAllBlocks
};