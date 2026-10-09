// models/schedule.model.js - VERSIÓN COMPLETA CORREGIDA CON NIVEL ACADÉMICO
import { db } from "../db/connection.database.js";

// ============================================
// SECCIONES - CON NIVEL ACADÉMICO
// ============================================

const findAllSections = async (academicYearId = null) => {
    try {
        let query;

        if (academicYearId) {
            query = {
                text: `
                    SELECT 
                        s.id_seccion as id,
                        s.nombre_seccion as section_name,
                        COALESCE(nd.nivel_danza, 'General') as grade_level,
                        s.id_nivel_danza as grade_id,
                        COALESCE(nd.nivel_danza, 'General') as grade_name,
                        30 as capacity,
                        COALESCE(h.id_materia, NULL) as subject_id,
                        NULL as period_id,
                        s.id_ano as academic_year_id,
                        COALESCE(mat.nombre_materia, 'Sin materia') as subject_name,
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
                                LEFT JOIN materia hor_mat ON hor.id_materia = hor_mat.id_materia
                                WHERE hor.id_seccion = s.id_seccion
                            ),
                            '[]'::json
                        ) as schedules,
                        0 as total_hours
                    FROM seccion s
                    LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
                    LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
                    LEFT JOIN horario h ON s.id_seccion = h.id_seccion
                    LEFT JOIN materia mat ON h.id_materia = mat.id_materia
                    WHERE s.id_ano = $1
                    GROUP BY s.id_seccion, s.nombre_seccion, nd.nivel_danza, s.id_nivel_danza, h.id_materia, s.id_ano, mat.nombre_materia, a.nombre_ano
                    ORDER BY nd.nivel_danza, s.id_seccion DESC
                `,
                values: [academicYearId]
            };
        } else {
            query = {
                text: `
                    SELECT 
                        s.id_seccion as id,
                        s.nombre_seccion as section_name,
                        COALESCE(nd.nivel_danza, 'General') as grade_level,
                        s.id_nivel_danza as grade_id,
                        COALESCE(nd.nivel_danza, 'General') as grade_name,
                        30 as capacity,
                        COALESCE(h.id_materia, NULL) as subject_id,
                        NULL as period_id,
                        s.id_ano as academic_year_id,
                        COALESCE(mat.nombre_materia, 'Sin materia') as subject_name,
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
                                LEFT JOIN materia hor_mat ON hor.id_materia = hor_mat.id_materia
                                WHERE hor.id_seccion = s.id_seccion
                            ),
                            '[]'::json
                        ) as schedules,
                        0 as total_hours
                    FROM seccion s
                    LEFT JOIN ano_academico a ON s.id_ano = a.id_ano
                    LEFT JOIN nivel_danza nd ON s.id_nivel_danza = nd.id_nivel_danza
                    LEFT JOIN horario h ON s.id_seccion = h.id_seccion
                    LEFT JOIN materia mat ON h.id_materia = mat.id_materia
                    GROUP BY s.id_seccion, s.nombre_seccion, nd.nivel_danza, s.id_nivel_danza, h.id_materia, s.id_ano, mat.nombre_materia, a.nombre_ano
                    ORDER BY nd.nivel_danza, s.id_seccion DESC
                `
            };
        }

        const { rows } = await db.query(query.text, query.values || []);
        console.log(`📋 Encontradas ${rows.length} secciones para año ${academicYearId || 'todos'}`);
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
                    s."Id_seccion" as id,
                    s."nombre_seccion" as section_name,
                    'General' as grade_level,
                    s."capacidad" as capacity,
                    s."Id_materia" as subject_id,
                    s."Id_lapso" as period_id,
                    s."Id_ano" as academic_year_id,
                    COALESCE(m."nombre_materia", 'Sin materia') as subject_name,
                    COALESCE(l."nombre_lapso", 'Período 1') as period_name,
                    a."nombre_ano" as academic_year_name,
                    -- Horarios de la sección CON MATERIAS
                    COALESCE(
                        (
                            SELECT json_agg(
                                json_build_object(
                                    'id', h."Id_horario",
                                    'day_id', h."Id_dia",
                                    'day_name', d."nombre_dia",
                                    'block_id', h."Id_bloque",
                                    'block_name', b."nombre_bloque",
                                    'start_time', b."inicio_bloque",
                                    'end_time', b."fin_bloque",
                                    'classroom_id', h."Id_aula",
                                    'classroom_name', au."nombre_aula",
                                    'teacher_id', h."Id_profesor",
                                    'teacher_name', CONCAT(u."nombre", ' ', u."apellido"),
                                    'teacher_user_id', u."Id_usuario",
                                    'subject_id', COALESCE(h."Id_materia", s."Id_materia"),
                                    'subject_name', COALESCE(mat."nombre_materia", m."nombre_materia", 'Sin materia')
                                )
                                ORDER BY d."Id_dia", b."inicio_bloque"
                            )
                            FROM "Horario" h
                            LEFT JOIN "Dia" d ON h."Id_dia" = d."Id_dia"
                            LEFT JOIN "Bloque_Horario" b ON h."Id_bloque" = b."Id_bloque"
                            LEFT JOIN "Aula" au ON h."Id_aula" = au."Id_aula"
                            LEFT JOIN "Profesor" p ON h."Id_profesor" = p."Id_profesor"
                            LEFT JOIN "Usuario" u ON p."Id_usuario" = u."Id_usuario"
                            LEFT JOIN "Materia" mat ON h."Id_materia" = mat."Id_materia"
                            WHERE h."Id_seccion" = s."Id_seccion"
                        ),
                        '[]'::json
                    ) as schedules,
                    -- Calcular horas totales
                    COALESCE(
                        (
                            SELECT SUM(EXTRACT(EPOCH FROM (b."fin_bloque" - b."inicio_bloque")) / 3600)
                            FROM "Horario" h
                            JOIN "Bloque_Horario" b ON h."Id_bloque" = b."Id_bloque"
                            WHERE h."Id_seccion" = s."Id_seccion"
                        ),
                        0
                    ) as total_hours
                FROM "Seccion" s
                LEFT JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
                LEFT JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
                LEFT JOIN "Ano_Academico" a ON s."Id_ano" = a."Id_ano"
                WHERE s."Id_seccion" = $1
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

// ============================================
// CREAR SECCIÓN - CON NIVEL ACADÉMICO
// ============================================
// En models/schedule.model.js - createSection
const createSection = async (sectionData) => {
    try {
        const { section_name, grade_level, capacity, subject_id, academic_year_id } = sectionData;

        console.log('📥 MODEL - Datos recibidos en modelo:', {
            section_name,
            grade_level,  // ← DEBE APARECER AQUÍ
            capacity,
            subject_id,
            academic_year_id
        });

        let finalYearId = academic_year_id;

        if (!finalYearId) {
            console.log('⚠️ No se recibió academic_year_id, buscando año activo...');
            const yearResult = await db.query(
                'SELECT "Id_ano" FROM "Ano_Academico" WHERE "activo" = true LIMIT 1'
            );
            finalYearId = yearResult.rows[0]?.Id_ano;
        }

        if (!finalYearId) {
            throw new Error('No se pudo determinar un año académico válido');
        }

        console.log('✅ Año determinado:', finalYearId);

        const lapsoResult = await db.query(
            'SELECT "Id_lapso" FROM "Lapso" WHERE "Id_ano" = $1 LIMIT 1',
            [finalYearId]
        );
        const lapsoId = lapsoResult.rows[0]?.Id_lapso || null;

        console.log('📅 Lapso asociado:', lapsoId);

        const query = {
            text: `
                INSERT INTO "Seccion" (
                    "nombre_seccion", 
                    "capacidad", 
                    "Id_materia", 
                    "Id_lapso",
                    "Id_ano"
                ) VALUES ($1, $2, $3, $4, $5)
                RETURNING 
                    "Id_seccion" as id,
                    "nombre_seccion" as section_name,
                    "capacidad" as capacity,
                    "Id_materia" as subject_id,
                    "Id_lapso" as period_id,
                    "Id_ano" as academic_year_id
            `,
            values: [
                section_name,
                capacity || 30,
                subject_id,
                lapsoId,
                finalYearId
            ]
        };

        const { rows } = await db.query(query.text, query.values);
        console.log('✅ Sección creada con ID:', rows[0].id, 'nivel:', rows[0].grade_level);
        return rows[0];

    } catch (error) {
        console.error("❌ Error en schedule.createSection:", error);
        throw error;
    }
};

const updateSection = async (id, sectionData) => {
    try {
        const { section_name, grade_level, capacity, subject_id } = sectionData;

        const query = {
            text: `
                UPDATE "Seccion"
                SET 
                    "nombre_seccion" = COALESCE($1, "nombre_seccion"),
                    "capacidad" = COALESCE($2, "capacidad"),
                    "Id_materia" = COALESCE($3, "Id_materia")
                WHERE "Id_seccion" = $4
                RETURNING 
                    "Id_seccion" as id,
                    "nombre_seccion" as section_name,
                    "capacidad" as capacity,
                    "Id_materia" as subject_id,
                    "Id_lapso" as period_id,
                    "Id_ano" as academic_year_id
            `,
            values: [section_name, capacity, subject_id, id]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.updateSection:", error);
        throw error;
    }
};

// ============================================
// ELIMINAR SECCIÓN
// ============================================
const deleteSection = async (id) => {
    try {
        console.log(`🗑️ Eliminando sección ${id} y todas sus relaciones...`);

        const studentCheck = await db.query(
            'SELECT COUNT(*) as count FROM "Estudiante_Seccion" WHERE "Id_seccion" = $1',
            [id]
        );

        if (studentCheck.rows[0].count > 0) {
            throw new Error(`La sección tiene ${studentCheck.rows[0].count} estudiantes asociados. No se puede eliminar.`);
        }

        await db.query('BEGIN');

        try {
            await db.query('DELETE FROM "Horario" WHERE "Id_seccion" = $1', [id]);
            await db.query('DELETE FROM "Asistencia" WHERE "Id_seccion" = $1', [id]);
            await db.query('DELETE FROM "Boleta_Notas" WHERE "Id_seccion" = $1', [id]);
            await db.query('DELETE FROM "Estructura_Evaluacion" WHERE "Id_seccion" = $1', [id]);

            const query = {
                text: 'DELETE FROM "Seccion" WHERE "Id_seccion" = $1 RETURNING "Id_seccion" as id',
                values: [id]
            };

            const { rows } = await db.query(query.text, query.values);

            await db.query('COMMIT');

            console.log(`✅ Sección ${id} eliminada exitosamente`);
            return rows[0];

        } catch (error) {
            await db.query('ROLLBACK');
            throw error;
        }

    } catch (error) {
        console.error("❌ Error en schedule.deleteSection:", error);

        if (error.code === '23503') {
            throw new Error('No se puede eliminar la sección porque tiene estudiantes u otras relaciones asociadas.');
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
                h."Id_horario" as id,
                h."Id_seccion" as section_id,
                s."nombre_seccion" as section_name,
                h."Id_aula" as classroom_id,
                a."nombre_aula" as classroom_name,
                h."Id_profesor" as teacher_id,
                CONCAT(u."nombre", ' ', u."apellido") as teacher_name,
                u."Id_usuario" as teacher_user_id,
                h."Id_bloque" as block_id,
                b."nombre_bloque" as block_name,
                b."inicio_bloque" as start_time,
                b."fin_bloque" as end_time,
                h."Id_dia" as day_id,
                d."nombre_dia" as day_name,
                h."Id_materia" as subject_id,
                m."nombre_materia" as subject_name,
                s."Id_ano" as academic_year_id,
                an."nombre_ano" as academic_year_name
            FROM "Horario" h
            LEFT JOIN "Seccion" s ON h."Id_seccion" = s."Id_seccion"
            LEFT JOIN "Aula" a ON h."Id_aula" = a."Id_aula"
            LEFT JOIN "Profesor" p ON h."Id_profesor" = p."Id_profesor"
            LEFT JOIN "Usuario" u ON p."Id_usuario" = u."Id_usuario"
            LEFT JOIN "Bloque_Horario" b ON h."Id_bloque" = b."Id_bloque"
            LEFT JOIN "Dia" d ON h."Id_dia" = d."Id_dia"
            LEFT JOIN "Materia" m ON h."Id_materia" = m."Id_materia"
            LEFT JOIN "Ano_Academico" an ON s."Id_ano" = an."Id_ano"
            WHERE 1=1
        `;

        const values = [];
        let paramIndex = 1;

        if (filters.academicYearId) {
            queryText += ` AND s."Id_ano" = $${paramIndex}`;
            values.push(filters.academicYearId);
            paramIndex++;
        }

        if (filters.sectionId) {
            queryText += ` AND h."Id_seccion" = $${paramIndex}`;
            values.push(filters.sectionId);
            paramIndex++;
        }

        if (filters.teacherId) {
            queryText += ` AND h."Id_profesor" = $${paramIndex}`;
            values.push(filters.teacherId);
            paramIndex++;
        }

        if (filters.dayId) {
            queryText += ` AND h."Id_dia" = $${paramIndex}`;
            values.push(filters.dayId);
            paramIndex++;
        }

        queryText += ` ORDER BY d."Id_dia", b."inicio_bloque"`;

        const { rows } = await db.query(queryText, values);
        return rows;
    } catch (error) {
        console.error("❌ Error en schedule.findAllSchedules:", error);
        throw error;
    }
};

// ============================================
// CREAR HORARIO - VERSIÓN CORREGIDA CON MATERIA
// ============================================
const createSchedule = async (scheduleData) => {
    try {
        const { section_id, classroom_id, teacher_id, block_id, day_id, subject_id } = scheduleData;

        console.log('📥 MODEL createSchedule - Datos recibidos:', {
            section_id,
            classroom_id,
            teacher_id,
            block_id,
            day_id,
            subject_id
        });

        // PASO 1: Verificar que la sección existe
        const sectionCheck = await db.query(
            'SELECT "Id_seccion", "Id_ano" FROM "Seccion" WHERE "Id_seccion" = $1',
            [section_id]
        );

        if (sectionCheck.rows.length === 0) {
            throw new Error(`La sección ${section_id} no existe`);
        }

        const academicYearId = sectionCheck.rows[0].Id_ano;

        // PASO 2: Obtener el Id_profesor a partir del Id_usuario o Id_profesor
        let profesorId = null;
        const profesorQuery = await db.query(
            `SELECT "Id_profesor" 
             FROM "Profesor" 
             WHERE "Id_usuario" = $1 OR "Id_profesor" = $1
             LIMIT 1`,
            [teacher_id]
        );

        if (profesorQuery.rows.length > 0) {
            profesorId = profesorQuery.rows[0].Id_profesor;
        } else {
            throw new Error(`El usuario o profesor ${teacher_id} no tiene un registro activo en la tabla Profesor.`);
        }

        // PASO 2B: Resolver Id_materia exacto según el catálogo de la BD
        const subjectName = scheduleData.subject_name || (isNaN(Number(subject_id)) ? subject_id : null);
        let resolvedSubjectId = null;

        if (subjectName) {
            const matByName = await db.query(
                `SELECT "Id_materia" FROM "Materia" WHERE TRIM(LOWER("nombre_materia")) = TRIM(LOWER($1)) LIMIT 1`,
                [String(subjectName).trim()]
            );
            if (matByName.rows.length > 0) {
                resolvedSubjectId = matByName.rows[0].Id_materia;
            }
        }

        if (!resolvedSubjectId && subject_id && !isNaN(Number(subject_id))) {
            const matById = await db.query(
                `SELECT "Id_materia" FROM "Materia" WHERE "Id_materia" = $1 LIMIT 1`,
                [Number(subject_id)]
            );
            if (matById.rows.length > 0) {
                resolvedSubjectId = matById.rows[0].Id_materia;
            }
        }

        console.log(`✅ Datos procesados: Profesor ID ${profesorId}, Materia: "${subjectName || ''}" → ID en BD: ${resolvedSubjectId}`);

        // PASO 3: Verificar disponibilidad con el profesorId correcto
        const isAvailable = await checkAvailability({
            academicYearId: academicYearId,
            dayId: day_id,
            blockId: block_id,
            classroomId: classroom_id,
            teacherId: profesorId,
            excludeScheduleId: null,
            excludeSectionId: section_id
        });

        if (!isAvailable.available) {
            throw new Error(isAvailable.message || 'Conflicto de horario');
        }

        // PASO 4: Insertar el horario CON LA MATERIA
        const query = {
            text: `
                INSERT INTO "Horario" (
                    "Id_seccion", 
                    "Id_aula", 
                    "Id_profesor", 
                    "Id_bloque", 
                    "Id_dia",
                    "Id_materia"
                ) VALUES ($1, $2, $3, $4, $5, $6)
                RETURNING 
                    "Id_horario" as id,
                    "Id_seccion" as section_id,
                    "Id_aula" as classroom_id,
                    "Id_profesor" as teacher_id,
                    "Id_bloque" as block_id,
                    "Id_dia" as day_id,
                    "Id_materia" as subject_id
            `,
            values: [section_id, classroom_id, profesorId, block_id, day_id, resolvedSubjectId || null]
        };

        const { rows } = await db.query(query.text, query.values);
        console.log('✅ Horario creado:', rows[0]);
        return rows[0];

    } catch (error) {
        console.error("❌ Error en schedule.createSchedule:", error);
        if (error.code === '23505' || error.constraint === 'uq_disponibilidad_profesor') {
            throw new Error('El profesor ya tiene una clase asignada en este bloque y día');
        }
        if (error.code === '23505' || error.constraint === 'uq_ocupacion_aula') {
            throw new Error('El aula seleccionada se encuentra ocupada en este bloque y día');
        }
        throw error;
    }
};

const updateSchedule = async (id, scheduleData) => {
    try {
        const { classroom_id, teacher_id, block_id, day_id, subject_id } = scheduleData;

        const currentSchedule = await db.query(
            `SELECT h.*, s."Id_ano" as academic_year_id
             FROM "Horario" h
             LEFT JOIN "Seccion" s ON h."Id_seccion" = s."Id_seccion"
             WHERE h."Id_horario" = $1`,
            [id]
        );

        if (currentSchedule.rows.length === 0) {
            throw new Error('Horario no encontrado');
        }

        // Resolver teacherId
        let resolvedProfesorId = teacher_id;
        if (teacher_id) {
            const profRes = await db.query(
                `SELECT "Id_profesor" FROM "Profesor" WHERE "Id_profesor" = $1 OR "Id_usuario" = $1 LIMIT 1`,
                [teacher_id]
            );
            if (profRes.rows.length > 0) {
                resolvedProfesorId = profRes.rows[0].Id_profesor;
            }
        }

        const isAvailable = await checkAvailability({
            academicYearId: currentSchedule.rows[0].academic_year_id,
            dayId: day_id,
            blockId: block_id,
            classroomId: classroom_id,
            teacherId: resolvedProfesorId,
            excludeScheduleId: id
        });

        if (!isAvailable.available) {
            throw new Error(isAvailable.message || 'Conflicto de horario');
        }

        // Resolver materia
        const subjectName = scheduleData.subject_name || (isNaN(Number(subject_id)) ? subject_id : null);
        let resolvedSubjectId = subject_id !== undefined ? subject_id : null;

        if (subjectName) {
            const matByName = await db.query(
                `SELECT "Id_materia" FROM "Materia" WHERE TRIM(LOWER("nombre_materia")) = TRIM(LOWER($1)) LIMIT 1`,
                [String(subjectName).trim()]
            );
            if (matByName.rows.length > 0) {
                resolvedSubjectId = matByName.rows[0].Id_materia;
            }
        }

        const query = {
            text: `
                UPDATE "Horario"
                SET 
                    "Id_aula" = COALESCE($1, "Id_aula"),
                    "Id_profesor" = COALESCE($2, "Id_profesor"),
                    "Id_bloque" = COALESCE($3, "Id_bloque"),
                    "Id_dia" = COALESCE($4, "Id_dia"),
                    "Id_materia" = COALESCE($5, "Id_materia")
                WHERE "Id_horario" = $6
                RETURNING 
                    "Id_horario" as id,
                    "Id_seccion" as section_id,
                    "Id_aula" as classroom_id,
                    "Id_profesor" as teacher_id,
                    "Id_bloque" as block_id,
                    "Id_dia" as day_id,
                    "Id_materia" as subject_id
            `,
            values: [classroom_id, resolvedProfesorId, block_id, day_id, resolvedSubjectId, id]
        };

        const { rows } = await db.query(query.text, query.values);
        return rows[0];
    } catch (error) {
        console.error("❌ Error en schedule.updateSchedule:", error);
        if (error.code === '23505' || error.constraint === 'uq_disponibilidad_profesor') {
            throw new Error('El profesor ya tiene una clase asignada en este bloque y día');
        }
        if (error.code === '23505' || error.constraint === 'uq_ocupacion_aula') {
            throw new Error('El aula seleccionada se encuentra ocupada en este bloque y día');
        }
        throw error;
    }
};

const deleteSchedule = async (id) => {
    try {
        const query = {
            text: 'DELETE FROM "Horario" WHERE "Id_horario" = $1 RETURNING "Id_horario" as id',
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
const checkAvailability = async ({
    academicYearId,
    dayId,
    blockId,
    classroomId,
    teacherId,
    excludeScheduleId = null,
    excludeSectionId = null // 👈 1. ACEPTAR EXCLUDE SECTION ID
}) => {
    try {
        console.log('🔍 Verificando disponibilidad:', {
            academicYearId,
            dayId,
            blockId,
            classroomId,
            teacherId,
            excludeScheduleId,
            excludeSectionId
        });

        let resolvedTeacherId = teacherId;
        if (teacherId) {
            const profCheck = await db.query(
                `SELECT "Id_profesor" FROM "Profesor" WHERE "Id_profesor" = $1 OR "Id_usuario" = $1 LIMIT 1`,
                [teacherId]
            );
            if (profCheck.rows.length > 0) {
                resolvedTeacherId = profCheck.rows[0].Id_profesor;
            }
        }

        // 1. Verificar disponibilidad del aula (cruzada en BD)
        let classroomQuery = `
            SELECT 
                h."Id_horario", 
                s."nombre_seccion", 
                CONCAT(u."nombre", ' ', u."apellido") as teacher_name
            FROM "Horario" h
            LEFT JOIN "Seccion" s ON h."Id_seccion" = s."Id_seccion"
            LEFT JOIN "Profesor" p ON h."Id_profesor" = p."Id_profesor"
            LEFT JOIN "Usuario" u ON p."Id_usuario" = u."Id_usuario"
            WHERE h."Id_aula" = $1 
              AND h."Id_dia" = $2 
              AND h."Id_bloque" = $3
        `;

        const classroomValues = [classroomId, dayId, blockId];
        let classroomParamIdx = 4;

        if (academicYearId) {
            classroomQuery += ` AND s."Id_ano" = $${classroomParamIdx}`;
            classroomValues.push(academicYearId);
            classroomParamIdx++;
        }

        if (excludeScheduleId) {
            classroomQuery += ` AND h."Id_horario" != $${classroomParamIdx}`;
            classroomValues.push(excludeScheduleId);
            classroomParamIdx++;
        }

        const classroomConflict = await db.query(classroomQuery, classroomValues);

        if (classroomConflict.rows.length > 0) {
            return {
                available: false,
                message: `El aula seleccionada se encuentra ocupada por ${classroomConflict.rows[0].teacher_name || 'otro docente'} en la sección ${classroomConflict.rows[0].nombre_seccion || ''}`,
                conflict: {
                    type: 'classroom',
                    section: classroomConflict.rows[0].nombre_seccion,
                    teacher: classroomConflict.rows[0].teacher_name
                }
            };
        }

        // 2. Verificar disponibilidad del profesor (no tenga otra clase en simultáneo)
        let teacherQuery = `
            SELECT 
                h."Id_horario", 
                s."nombre_seccion", 
                a."nombre_aula" as classroom_name
            FROM "Horario" h
            LEFT JOIN "Seccion" s ON h."Id_seccion" = s."Id_seccion"
            LEFT JOIN "Aula" a ON h."Id_aula" = a."Id_aula"
            WHERE h."Id_profesor" = $1 
              AND h."Id_dia" = $2 
              AND h."Id_bloque" = $3
        `;

        const teacherValues = [resolvedTeacherId, dayId, blockId];
        let teacherParamIdx = 4;

        if (academicYearId) {
            teacherQuery += ` AND s."Id_ano" = $${teacherParamIdx}`;
            teacherValues.push(academicYearId);
            teacherParamIdx++;
        }

        if (excludeScheduleId) {
            teacherQuery += ` AND h."Id_horario" != $${teacherParamIdx}`;
            teacherValues.push(excludeScheduleId);
            teacherParamIdx++;
        }

        const teacherConflict = await db.query(teacherQuery, teacherValues);

        if (teacherConflict.rows.length > 0) {
            return {
                available: false,
                message: `El profesor ya tiene una clase asignada en este bloque y día (en el aula ${teacherConflict.rows[0].classroom_name || ''}, sección ${teacherConflict.rows[0].nombre_seccion || ''})`,
                conflict: {
                    type: 'teacher',
                    section: teacherConflict.rows[0].nombre_seccion,
                    classroom: teacherConflict.rows[0].classroom_name
                }
            };
        }

        console.log('✅ Disponibilidad confirmada');
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
                    "Id_aula" as id,
                    "nombre_aula" as name,
                    "Id_tipo_clase" as type_id
                FROM "Aula"
                ORDER BY "nombre_aula"
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
                    "Id_dia" as id,
                    "nombre_dia" as name
                FROM "Dia"
                ORDER BY "Id_dia"
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
                    "Id_bloque" as id,
                    "nombre_bloque" as name,
                    "inicio_bloque" as start_time,
                    "fin_bloque" as end_time
                FROM "Bloque_Horario"
                ORDER BY "inicio_bloque"
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
    // Secciones
    findAllSections,
    findSectionById,
    createSection,
    updateSection,
    deleteSection,

    // Horarios
    findAllSchedules,
    createSchedule,
    updateSchedule,
    deleteSchedule,

    // Validación
    checkAvailability,

    // Catálogos
    getAllClassrooms,
    getAllDays,
    getAllBlocks
};