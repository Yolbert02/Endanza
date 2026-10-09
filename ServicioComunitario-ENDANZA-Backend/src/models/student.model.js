import { db } from "../db/connection.database.js";
import { RevisionModel } from "./revision.model.js";
import { EspecialidadModel } from "./especialidad.model.js";
import { capitalizeWords } from "../utils/formatters.js";

// ============================================
// MODELO DE ESTUDIANTES
// ============================================

/**
 * Obtiene todos los estudiantes con sus relaciones
 * @param {Object} filters - Filtros opcionales (academicYearId, sectionId)
 * @returns {Promise<Array>}
 */
const findAll = async (filters = {}) => {
  try {
    let query = {
      text: `
        SELECT 
          e.id_estudiante as id,
          p.nombre as first_name,
          p.segundo_nombre as middle_name,
          p.segundo_nombre as segundo_nombre,
          p.apellido as last_name,
          p.segundo_apellido as second_last_name,
          p.segundo_apellido as segundo_apellido,
          p.cedula as dni,
          p.fecha_nacimiento as birth_date,
          p.genero as gender,
          e.seguro_escolar as school_insurance,
          e.id_nivel as grade_level_id,
          nl.nivel as grade_level_name,
          e.id_nivel_danza as dance_level_id,
          nd.nivel_danza as dance_level_name,
          e.id_especialidad as specialty_id,
          e.id_especialidad as especialidad_id,
          e.id_especialidad as id_especialidad,
          esp.nombre_especialidad as specialty_name,
          esp.nombre_especialidad as especialidad,
          esp.nombre_especialidad as nombre_especialidad,
          e.id_escuela as school_id,
          er.nombre_escuela as school_name,
          e.id_seguro as insurance_id,
          s.tipo_seguro as insurance_name,
          e.id_representante as representative_id,
          r.id_usuario as representative_user_id,
          p_r.nombre as representative_first_name,
          p_r.segundo_nombre as representative_second_name,
          p_r.apellido as representative_last_name,
          p_r.segundo_apellido as representative_second_last_name,
          p_r.cedula as representative_dni,
          p_r.numero_telefono as representative_phone,
          p_r.email as representative_email,
          p_r.genero as representative_gender,
          r.profesion as representative_occupation,
          r.lugar_trabajo as representative_workplace,
          r.direccion_trabajo as representative_work_address,
          r.telefono_trabajo as representative_work_phone,
          r.lugar_trabajo,
          r.direccion_trabajo,
          r.telefono_trabajo,
          ef.parentesco as representative_relationship,
          ef.parentesco as parentesco,
          e.id_historia as medical_history_id,
          COALESCE(
            (
              SELECT jsonb_agg(
                jsonb_build_object(
                  'id', i.id_inscripcion,
                  'section_id', sec.id_seccion,
                  'section_name', sec.nombre_seccion,
                  'academic_year', a.nombre_ano
                )
              )
              FROM inscripcion i
              JOIN seccion sec ON i.id_seccion = sec.id_seccion
              JOIN ano_academico a ON i.id_ano = a.id_ano
              WHERE i.id_estudiante = e.id_estudiante
            ),
            '[]'::jsonb
          ) as sections
        FROM estudiante e
        JOIN persona p ON e.id_persona = p.id_persona
        LEFT JOIN nivel_escolar nl ON e.id_nivel = nl.id_nivel
        LEFT JOIN nivel_danza nd ON e.id_nivel_danza = nd.id_nivel_danza
        LEFT JOIN especialidad esp ON e.id_especialidad = esp.id_especialidad
        LEFT JOIN escuela_regular er ON e.id_escuela = er.id_escuela
        LEFT JOIN seguro_medico s ON e.id_seguro = s.id_seguro
        LEFT JOIN representante r ON e.id_representante = r.id_representante
        LEFT JOIN persona p_r ON r.id_persona = p_r.id_persona
        LEFT JOIN estudiante_familiar ef ON ef.id_estudiante = e.id_estudiante AND ef.id_persona = r.id_persona
        WHERE 1=1
      `
    };

    const values = [];
    let paramIndex = 1;

    // Filtro por año académico (a través de las inscripciones)
    if (filters.academicYearId) {
      query.text += ` AND EXISTS (
        SELECT 1 FROM inscripcion i
        WHERE i.id_estudiante = e.id_estudiante
        AND i.id_ano = $${paramIndex}
      )`;
      values.push(filters.academicYearId);
      paramIndex++;
    }

    // Filtro por sección específica
    if (filters.sectionId) {
      query.text += ` AND EXISTS (
        SELECT 1 FROM inscripcion i
        WHERE i.id_estudiante = e.id_estudiante
        AND i.id_seccion = $${paramIndex}
      )`;
      values.push(filters.sectionId);
      paramIndex++;
    }

    query.text += ` ORDER BY p.apellido, p.nombre`;
    query.values = values;

    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findAll students:", error);
    throw error;
  }
};

/**
 * Obtiene un estudiante por ID
 * @param {number} id - ID del estudiante
 * @returns {Promise<Object|null>}
 */
const findById = async (id) => {
  try {
    const query = {
      text: `
        SELECT 
          e.id_estudiante as id,
          p.nombre as first_name,
          p.segundo_nombre as middle_name,
          p.segundo_nombre as segundo_nombre,
          p.segundo_nombre as second_name,
          p.apellido as last_name,
          p.segundo_apellido as second_last_name,
          p.segundo_apellido as segundo_apellido,
          p.cedula as dni,
          TO_CHAR(p.fecha_nacimiento, 'YYYY-MM-DD') as birth_date,
          p.genero as gender,
          COALESCE(hm.tipo_sangre, 'O+') as blood_type,
          COALESCE(hm.tipo_sangre, 'O+') as tipo_sangre,
          COALESCE(hm.tipo_sangre, 'O+') as "TipoSangre",
          e.id_nivel as grade_level_id,
          nl.nivel as grade_level_name,
          e.id_nivel_danza as dance_level_id,
          nd.nivel_danza as dance_level_name,
          e.id_especialidad as specialty_id,
          e.id_especialidad as especialidad_id,
          e.id_especialidad as id_especialidad,
          esp.nombre_especialidad as specialty_name,
          esp.nombre_especialidad as especialidad,
          esp.nombre_especialidad as nombre_especialidad,
          e.id_escuela as school_id,
          er.nombre_escuela as school_name,
          e.id_seguro as insurance_id,
          s.tipo_seguro as insurance_name,
          e.id_representante as representative_id,
          r.id_usuario as representative_user_id,
          p_r.nombre as representative_first_name,
          p_r.segundo_nombre as representative_second_name,
          p_r.segundo_nombre as representative_segundo_nombre,
          p_r.apellido as representative_last_name,
          p_r.segundo_apellido as representative_second_last_name,
          p_r.segundo_apellido as representative_segundo_apellido,
          p_r.cedula as representative_dni,
          p_r.numero_telefono as representative_phone,
          p_r.email as representative_email,
          p_r.genero as representative_gender,
          true as representative_es_familiar,
          r.profesion as representative_occupation,
          r.lugar_trabajo as representative_workplace,
          r.direccion_trabajo as representative_work_address,
          r.telefono_trabajo as representative_work_phone,
          r.lugar_trabajo,
          r.direccion_trabajo,
          r.telefono_trabajo,
          COALESCE(ef.parentesco, 'Madre') as representative_relationship,
          COALESCE(dir.direccion, r.direccion_trabajo, '') as address,
          'San Cristóbal' as city,
          'Táchira' as state,
          e.id_historia as medical_history_id,
          hm.peso_kg,
          hm.altura_m,
          hm.tiene_alergias,
          hm.descripcion_alergias,
          hm.tiene_cirugia,
          hm.descripcion_cirugia,
          hm.intolerancia_alimentos,
          hm.descripcion_intolerancia
        FROM estudiante e
        JOIN persona p ON e.id_persona = p.id_persona
        LEFT JOIN nivel_escolar nl ON e.id_nivel = nl.id_nivel
        LEFT JOIN nivel_danza nd ON e.id_nivel_danza = nd.id_nivel_danza
        LEFT JOIN especialidad esp ON e.id_especialidad = esp.id_especialidad
        LEFT JOIN escuela_regular er ON e.id_escuela = er.id_escuela
        LEFT JOIN seguro_medico s ON e.id_seguro = s.id_seguro
        LEFT JOIN representante r ON e.id_representante = r.id_representante
        LEFT JOIN persona p_r ON r.id_persona = p_r.id_persona
        LEFT JOIN usuario u_r ON r.id_usuario = u_r.id_usuario
        LEFT JOIN direccion dir ON u_r.id_direccion = dir.id_direccion
        LEFT JOIN estudiante_familiar ef ON ef.id_estudiante = e.id_estudiante AND ef.id_persona = r.id_persona
        LEFT JOIN historial_medico hm ON e.id_historia = hm.id_historia
        WHERE e.id_estudiante = $1
      `,
      values: [id]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("Error en findById student:", error);
    throw error;
  }
};

/**
 * Obtiene las secciones de un estudiante
 * @param {number} studentId - ID del estudiante
 * @returns {Promise<Array>}
 */
const findSectionsByStudentId = async (studentId) => {
  try {
    const query = {
      text: `
        SELECT 
          i.id_inscripcion as id,
          i.id_seccion as section_id,
          s.nombre_seccion as section_name,
          i.id_ano as academic_year_id,
          a.nombre_ano as academic_year_name,
          'Año Completo' as period_name
        FROM inscripcion i
        JOIN seccion s ON i.id_seccion = s.id_seccion
        JOIN ano_academico a ON i.id_ano = a.id_ano
        WHERE i.id_estudiante = $1
        ORDER BY a.nombre_ano DESC
      `,
      values: [studentId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findSectionsByStudentId:", error);
    throw error;
  }
};

/**
 * Crea un nuevo estudiante
 * @param {Object} studentData - Datos del estudiante
 * @returns {Promise<Object>}
 */
const create = async (studentData) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    const {
      nombre,
      apellido,
      cedula,
      fecha_nacimiento,
      genero,
      seguro_escolar,
      Id_nivel,
      Id_nivel_danza,
      Id_escuela,
      Id_seguro,
      Id_representante,
      Id_historial
    } = studentData;

    let Id_especialidad = studentData.Id_especialidad ?? studentData.especialidad_id ?? studentData.id_especialidad ?? studentData.specialty_id ?? null;
    if (!Id_especialidad && studentData.especialidad) {
      const esp = await EspecialidadModel.findByName(studentData.especialidad);
      if (esp) Id_especialidad = esp.id;
    }

    const formattedNombre = capitalizeWords(nombre);
    const formattedApellido = capitalizeWords(apellido);

    const query = {
      text: `
        INSERT INTO "Estudiante" (
          "nombre", "apellido", "cedula", "fecha_nacimiento", "genero",
          "seguro_escolar", "Id_nivel", "Id_nivel_danza", "Id_escuela",
          "Id_seguro", "Id_representante", "Id_historial", "Id_especialidad"
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING 
          "Id_estudiante" as id, 
          "nombre" as first_name,
          "apellido" as last_name,
          "cedula" as dni
      `,
      values: [
        formattedNombre, formattedApellido, cedula, fecha_nacimiento, genero,
        seguro_escolar || false, Id_nivel, Id_nivel_danza, Id_escuela,
        Id_seguro, Id_representante, Id_historial, Id_especialidad
      ]
    };

    const { rows } = await client.query(query.text, query.values);

    await client.query('COMMIT');
    return rows[0];
  } catch (error) {
    await client.query('ROLLBACK');
    console.error("Error en create student:", error);
    throw error;
  } finally {
    client.release();
  }
};

/**
 * Actualiza un estudiante existente
 * @param {number} id - ID del estudiante
 * @param {Object} studentData - Datos a actualizar
 * @returns {Promise<Object>}
 */
const update = async (id, studentData) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    // 1. Obtener datos actuales del estudiante
    const estRes = await client.query(`
      SELECT 
        e.id_estudiante,
        e.id_persona,
        e.id_representante,
        e.id_nivel_danza,
        e.id_nivel,
        e.id_especialidad,
        e.seguro_escolar,
        r.id_persona as id_persona_rep,
        r.id_usuario as id_usuario_rep
      FROM estudiante e
      LEFT JOIN representante r ON e.id_representante = r.id_representante
      WHERE e.id_estudiante = $1
    `, [id]);

    if (estRes.rows.length === 0) {
      await client.query('ROLLBACK');
      throw new Error(`Estudiante con ID ${id} no encontrado`);
    }

    const currentStudent = estRes.rows[0];
    const studentPersonaId = currentStudent.id_persona;

    // 2. Extraer y formatear datos personales del estudiante
    const p1Nombre = studentData.EstudiantePrimerNombre ? capitalizeWords(studentData.EstudiantePrimerNombre.trim()) : undefined;
    const p2Nombre = studentData.EstudianteSegundoNombre !== undefined ? capitalizeWords(studentData.EstudianteSegundoNombre.trim()) : undefined;
    const p1Apellido = studentData.EstudiantePrimerApellido ? capitalizeWords(studentData.EstudiantePrimerApellido.trim()) : undefined;
    const p2Apellido = studentData.EstudianteSegundoApellido !== undefined ? capitalizeWords(studentData.EstudianteSegundoApellido.trim()) : undefined;

    let rawNombre = p1Nombre || (studentData.nombre ? capitalizeWords(studentData.nombre.trim()) : undefined) || (studentData.first_name ? capitalizeWords(studentData.first_name.trim()) : undefined);
    let finalSegundoNombre = p2Nombre;
    if (!finalSegundoNombre && rawNombre && rawNombre.includes(' ')) {
      const parts = rawNombre.split(/\s+/).filter(Boolean);
      rawNombre = parts[0];
      finalSegundoNombre = parts.slice(1).join(' ');
    }

    let rawApellido = p1Apellido || (studentData.apellido ? capitalizeWords(studentData.apellido.trim()) : undefined) || (studentData.last_name ? capitalizeWords(studentData.last_name.trim()) : undefined);
    let finalSegundoApellido = p2Apellido;
    if (!finalSegundoApellido && rawApellido && rawApellido.includes(' ')) {
      const parts = rawApellido.split(/\s+/).filter(Boolean);
      rawApellido = parts[0];
      finalSegundoApellido = parts.slice(1).join(' ');
    }

    const normalizeGenero = (val) => {
      if (!val) return null;
      const str = String(val).trim().toLowerCase();
      if (str.startsWith('m')) return 'masculino';
      if (str.startsWith('f')) return 'femenino';
      return null;
    };

    const cedula = studentData.cedula ?? studentData.dni ?? studentData.Cedula;
    const fechaNac = studentData.fecha_nacimiento ?? studentData.birth_date ?? studentData.FechaNacimiento;
    const rawGenero = studentData.genero ?? studentData.gender ?? studentData.Sexo;
    const normalizedGenero = normalizeGenero(rawGenero);

    // Actualizar persona del estudiante
    if (studentPersonaId) {
      const studentTel = studentData.Telefono ?? studentData.telefono ?? studentData.phone;
      const studentEmail = studentData.Email ?? studentData.email;

      await client.query(`
        UPDATE persona
        SET
          nombre = COALESCE($1, nombre),
          segundo_nombre = COALESCE($2, segundo_nombre),
          apellido = COALESCE($3, apellido),
          segundo_apellido = COALESCE($4, segundo_apellido),
          cedula = COALESCE($5, cedula),
          fecha_nacimiento = COALESCE($6, fecha_nacimiento),
          genero = COALESCE($7, genero),
          numero_telefono = CASE WHEN $8 THEN $9 ELSE numero_telefono END,
          email = CASE WHEN $10 THEN $11 ELSE email END
        WHERE id_persona = $12
      `, [
        rawNombre || null,
        p2Nombre !== undefined ? (p2Nombre || null) : null,
        rawApellido || null,
        p2Apellido !== undefined ? (p2Apellido || null) : null,
        cedula || null,
        fechaNac || null,
        normalizedGenero || null,
        studentTel !== undefined,
        studentTel || null,
        studentEmail !== undefined,
        studentEmail || null,
        studentPersonaId
      ]);
    }

    // 3. Resolver nivel de danza de ENDANZA
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
    const rawGrado = (studentData.Grado || studentData.grado || studentData.dance_level || studentData.dance_level_name || '').trim();
    const gradoStr = gradoMap[rawGrado.toLowerCase()] || rawGrado;
    let danceLevelId = null;

    if (gradoStr) {
      const ndRes = await client.query(
        'SELECT id_nivel_danza FROM nivel_danza WHERE LOWER(nivel_danza) = LOWER($1) OR LOWER(nivel_danza) LIKE LOWER($2) ORDER BY CASE WHEN LOWER(nivel_danza) = LOWER($1) THEN 1 ELSE 2 END, id_nivel_danza LIMIT 1',
        [gradoStr, `%${gradoStr}%`]
      );
      if (ndRes.rows.length > 0) {
        danceLevelId = ndRes.rows[0].id_nivel_danza;
      }
    }

    if (!danceLevelId) {
      danceLevelId = studentData.Id_nivel_danza ?? studentData.dance_level_id ?? null;
    }

    // Especialidad si aplica
    let espId = studentData.Id_especialidad ?? studentData.especialidad_id ?? studentData.id_especialidad ?? studentData.specialty_id;
    if (!espId && gradoStr.includes(' - ')) {
      const espName = gradoStr.split(' - ')[1].trim();
      const espRes = await client.query(
        'SELECT id_especialidad FROM especialidad WHERE LOWER(nombre_especialidad) = LOWER($1) LIMIT 1',
        [espName]
      );
      if (espRes.rows.length > 0) espId = espRes.rows[0].id_especialidad;
    }

    const seguroEscolar = studentData.seguro_escolar ?? studentData.school_insurance;

    // Actualizar tabla estudiante
    await client.query(`
      UPDATE estudiante
      SET
        id_nivel_danza = COALESCE($1, id_nivel_danza),
        id_especialidad = COALESCE($2, id_especialidad),
        seguro_escolar = COALESCE($3, seguro_escolar)
      WHERE id_estudiante = $4
    `, [
      danceLevelId || null,
      espId || null,
      seguroEscolar !== undefined ? seguroEscolar : null,
      id
    ]);

    // 4. Si se envió Sección, actualizar inscripción
    const seccionName = (studentData.Seccion || studentData.seccion || '').trim();
    if (seccionName) {
      let targetSectionQuery = `SELECT id_seccion FROM seccion WHERE LOWER(nombre_seccion) = LOWER($1)`;
      const queryParams = [seccionName];
      if (danceLevelId || currentStudent.id_nivel_danza) {
        targetSectionQuery += ` AND id_nivel_danza = $2`;
        queryParams.push(danceLevelId || currentStudent.id_nivel_danza);
      }
      targetSectionQuery += ` LIMIT 1`;
      let secMatch = await client.query(targetSectionQuery, queryParams);
      if (secMatch.rows.length === 0) {
        secMatch = await client.query('SELECT id_seccion FROM seccion WHERE LOWER(nombre_seccion) = LOWER($1) LIMIT 1', [seccionName]);
      }

      if (secMatch.rows.length > 0) {
        const targetSectionId = secMatch.rows[0].id_seccion;
        await client.query(`
          UPDATE inscripcion
          SET id_seccion = $1
          WHERE id_inscripcion = (
            SELECT id_inscripcion FROM inscripcion WHERE id_estudiante = $2 ORDER BY id_inscripcion DESC LIMIT 1
          )
        `, [targetSectionId, id]);
      }
    }

    // 5. Actualizar representante y usuario del representante
    const repP1Nombre = studentData.RepresentantePrimerNombre ? capitalizeWords(studentData.RepresentantePrimerNombre.trim()) : undefined;
    const repP2Nombre = studentData.RepresentanteSegundoNombre !== undefined ? capitalizeWords(studentData.RepresentanteSegundoNombre.trim()) : undefined;
    const repP1Apellido = studentData.RepresentantePrimerApellido ? capitalizeWords(studentData.RepresentantePrimerApellido.trim()) : undefined;
    const repP2Apellido = studentData.RepresentanteSegundoApellido !== undefined ? capitalizeWords(studentData.RepresentanteSegundoApellido.trim()) : undefined;
    const repDni = studentData.RepresentanteCedula || studentData.representative_dni;
    let repPhone = studentData.RepresentanteTelefono !== undefined ? studentData.RepresentanteTelefono : studentData.representative_phone;
    let repEmail = studentData.RepresentanteEmail !== undefined ? studentData.RepresentanteEmail : studentData.representative_email;
    let repOcupacion = studentData.RepresentanteOcupacion !== undefined ? studentData.RepresentanteOcupacion : studentData.representative_occupation;
    if (studentData.RepresentanteParentesco === 'Madre' || currentStudent.representative_relationship === 'Madre') {
      if (repOcupacion === undefined || repOcupacion === null || repOcupacion === '') {
        repOcupacion = studentData.MadreOcupacion;
      }
      if (repEmail === undefined || repEmail === null || repEmail === '') {
        repEmail = studentData.MadreEmail;
      }
      if (repPhone === undefined || repPhone === null || repPhone === '') {
        repPhone = studentData.MadreTelefono;
      }
    } else if (studentData.RepresentanteParentesco === 'Padre' || currentStudent.representative_relationship === 'Padre') {
      if (repOcupacion === undefined || repOcupacion === null || repOcupacion === '') {
        repOcupacion = studentData.PadreOcupacion;
      }
      if (repEmail === undefined || repEmail === null || repEmail === '') {
        repEmail = studentData.PadreEmail;
      }
      if (repPhone === undefined || repPhone === null || repPhone === '') {
        repPhone = studentData.PadreTelefono;
      }
    }

    if (currentStudent.id_persona_rep) {
      await client.query(`
        UPDATE persona
        SET
          nombre = COALESCE($1, nombre),
          segundo_nombre = COALESCE($2, segundo_nombre),
          apellido = COALESCE($3, apellido),
          segundo_apellido = COALESCE($4, segundo_apellido),
          cedula = COALESCE($5, cedula),
          numero_telefono = CASE WHEN $6 THEN $7 ELSE numero_telefono END,
          email = CASE WHEN $8 THEN $9 ELSE email END
        WHERE id_persona = $10
      `, [
        repP1Nombre || (studentData.representative_first_name ? capitalizeWords(studentData.representative_first_name) : null),
        repP2Nombre !== undefined ? (repP2Nombre || null) : null,
        repP1Apellido || (studentData.representative_last_name ? capitalizeWords(studentData.representative_last_name) : null),
        repP2Apellido !== undefined ? (repP2Apellido || null) : null,
        repDni || null,
        repPhone !== undefined,
        repPhone || null,
        repEmail !== undefined,
        repEmail || null,
        currentStudent.id_persona_rep
      ]);
    }

    const repLugarTrabajo = studentData.RepresentanteLugarTrabajo ?? studentData.trabajo_Rep ?? studentData.representative_workplace;
    const repDirTrabajo = studentData.RepresentanteDireccionTrabajo ?? studentData.direccion_Trabajo_Rep ?? studentData.representative_work_address ?? studentData.direccion_trabajo;
    const repTelTrabajo = studentData.RepresentanteTelefonoTrabajo ?? studentData.telefono_trabajo_Rep ?? studentData.representative_work_phone ?? studentData.telefono_trabajo;

    if (currentStudent.id_representante) {
      await client.query(`
        UPDATE representante
        SET
          profesion = CASE WHEN $1 THEN $2 ELSE profesion END,
          lugar_trabajo = CASE WHEN $3 THEN $4 ELSE lugar_trabajo END,
          direccion_trabajo = CASE WHEN $5 THEN $6 ELSE direccion_trabajo END,
          telefono_trabajo = CASE WHEN $7 THEN $8 ELSE telefono_trabajo END
        WHERE id_representante = $9
      `, [
        repOcupacion !== undefined, repOcupacion || null,
        repLugarTrabajo !== undefined, repLugarTrabajo || null,
        repDirTrabajo !== undefined, repDirTrabajo || null,
        repTelTrabajo !== undefined, repTelTrabajo || null,
        currentStudent.id_representante
      ]);
    }

    // 6. Dirección de habitación
    const dirVal = (studentData.Direccion || studentData.address || studentData.direccion || '').trim();
    if (dirVal && currentStudent.id_usuario_rep) {
      const uRes = await client.query('SELECT id_direccion FROM usuario WHERE id_usuario = $1', [currentStudent.id_usuario_rep]);
      const currentDirId = uRes.rows[0]?.id_direccion;
      if (currentDirId) {
        await client.query('UPDATE direccion SET direccion = $1 WHERE id_direccion = $2', [dirVal, currentDirId]);
      } else {
        const insDir = await client.query('INSERT INTO direccion (direccion) VALUES ($1) RETURNING id_direccion', [dirVal]);
        await client.query('UPDATE usuario SET id_direccion = $1 WHERE id_usuario = $2', [insDir.rows[0].id_direccion, currentStudent.id_usuario_rep]);
      }
    }

    // 7. Familiares (Madre y Padre) en estudiante_familiar + persona
    const updateOrCreateFamiliar = async (parentesco, data) => {
      const { primerNombre, segundoNombre, primerApellido, segundoApellido, cedula, telefono, email, ocupacion, lugarTrabajo, direccionTrabajo, telefonoTrabajo } = data;
      const fn = primerNombre ? capitalizeWords(primerNombre.trim()) : '';
      const ln = primerApellido ? capitalizeWords(primerApellido.trim()) : '';
      if (!fn && !ln && !cedula && !telefono && !email && ocupacion === undefined && lugarTrabajo === undefined && direccionTrabajo === undefined && telefonoTrabajo === undefined) return;

      const famCheck = await client.query(`
        SELECT ef.id_estudiante_familiar, ef.id_persona
        FROM estudiante_familiar ef
        WHERE ef.id_estudiante = $1 AND ef.parentesco = $2
        LIMIT 1
      `, [id, parentesco]);

      if (famCheck.rows.length > 0) {
        const famRow = famCheck.rows[0];
        const personaFamId = famRow.id_persona;
        if (personaFamId) {
          await client.query(`
            UPDATE persona
            SET
              nombre = COALESCE($1, nombre),
              segundo_nombre = COALESCE($2, segundo_nombre),
              apellido = COALESCE($3, apellido),
              segundo_apellido = COALESCE($4, segundo_apellido),
              cedula = COALESCE($5, cedula),
              numero_telefono = CASE WHEN $6 THEN $7 ELSE numero_telefono END,
              email = CASE WHEN $8 THEN $9 ELSE email END,
              ocupacion = CASE WHEN $10 THEN $11 ELSE ocupacion END
            WHERE id_persona = $12
          `, [
            fn || null,
            segundoNombre ? capitalizeWords(segundoNombre.trim()) : null,
            ln || null,
            segundoApellido ? capitalizeWords(segundoApellido.trim()) : null,
            cedula || null,
            telefono !== undefined,
            telefono || null,
            email !== undefined,
            email || null,
            ocupacion !== undefined,
            ocupacion || null,
            personaFamId
          ]);
        }
        
        await client.query(`
          UPDATE estudiante_familiar
          SET
            ocupacion = CASE WHEN $1 THEN $2 ELSE ocupacion END,
            lugar_trabajo = CASE WHEN $3 THEN $4 ELSE lugar_trabajo END,
            direccion_trabajo = CASE WHEN $5 THEN $6 ELSE direccion_trabajo END,
            telefono_trabajo = CASE WHEN $7 THEN $8 ELSE telefono_trabajo END
          WHERE id_estudiante_familiar = $9
        `, [
          ocupacion !== undefined, ocupacion || null,
          lugarTrabajo !== undefined, lugarTrabajo || null,
          direccionTrabajo !== undefined, direccionTrabajo || null,
          telefonoTrabajo !== undefined, telefonoTrabajo || null,
          famRow.id_estudiante_familiar
        ]);
      } else if (fn || ln || cedula || telefono || email || ocupacion || lugarTrabajo || direccionTrabajo || telefonoTrabajo) {
        const insPersona = await client.query(`
          INSERT INTO persona (nombre, segundo_nombre, apellido, segundo_apellido, cedula, numero_telefono, email, genero, ocupacion)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
          RETURNING id_persona
        `, [
          fn || parentesco,
          segundoNombre ? capitalizeWords(segundoNombre.trim()) : null,
          ln || '',
          segundoApellido ? capitalizeWords(segundoApellido.trim()) : null,
          cedula || null,
          telefono || null,
          email || null,
          parentesco === 'Madre' ? 'femenino' : 'masculino',
          ocupacion || null
        ]);

        await client.query(`
          INSERT INTO estudiante_familiar (id_estudiante, id_persona, parentesco, es_representante_legal, vive_con_estudiante, ocupacion, lugar_trabajo, direccion_trabajo, telefono_trabajo)
          VALUES ($1, $2, $3, false, true, $4, $5, $6, $7)
        `, [
          id,
          insPersona.rows[0].id_persona,
          parentesco,
          ocupacion || null,
          lugarTrabajo || null,
          direccionTrabajo || null,
          telefonoTrabajo || null
        ]);
      }
    };

    if (studentData.MadrePrimerNombre || studentData.MadrePrimerApellido || studentData.MadreCedula || studentData.MadreTelefono !== undefined || studentData.MadreEmail !== undefined || studentData.MadreOcupacion !== undefined || studentData.MadreLugarTrabajo !== undefined || studentData.trabajo_Madre !== undefined || studentData.MadreDireccionTrabajo !== undefined || studentData.direccion_Trabajo_Madre !== undefined || studentData.MadreTelefonoTrabajo !== undefined || studentData.telefono_trabajo_Madre !== undefined) {
      await updateOrCreateFamiliar('Madre', {
        primerNombre: studentData.MadrePrimerNombre,
        segundoNombre: studentData.MadreSegundoNombre,
        primerApellido: studentData.MadrePrimerApellido,
        segundoApellido: studentData.MadreSegundoApellido,
        cedula: studentData.MadreCedula,
        telefono: studentData.MadreTelefono,
        email: studentData.MadreEmail,
        ocupacion: studentData.MadreOcupacion,
        lugarTrabajo: studentData.MadreLugarTrabajo ?? studentData.trabajo_Madre,
        direccionTrabajo: studentData.MadreDireccionTrabajo ?? studentData.direccion_Trabajo_Madre,
        telefonoTrabajo: studentData.MadreTelefonoTrabajo ?? studentData.telefono_trabajo_Madre
      });
    }

    if (studentData.PadrePrimerNombre || studentData.PadrePrimerApellido || studentData.PadreCedula || studentData.PadreTelefono !== undefined || studentData.PadreEmail !== undefined || studentData.PadreOcupacion !== undefined || studentData.PadreLugarTrabajo !== undefined || studentData.trabajo_Padre !== undefined || studentData.PadreDireccionTrabajo !== undefined || studentData.direccion_Trabajo_Padre !== undefined || studentData.PadreTelefonoTrabajo !== undefined || studentData.telefono_trabajo_Padre !== undefined) {
      await updateOrCreateFamiliar('Padre', {
        primerNombre: studentData.PadrePrimerNombre,
        segundoNombre: studentData.PadreSegundoNombre,
        primerApellido: studentData.PadrePrimerApellido,
        segundoApellido: studentData.PadreSegundoApellido,
        cedula: studentData.PadreCedula,
        telefono: studentData.PadreTelefono,
        email: studentData.PadreEmail,
        ocupacion: studentData.PadreOcupacion,
        lugarTrabajo: studentData.PadreLugarTrabajo ?? studentData.trabajo_Padre,
        direccionTrabajo: studentData.PadreDireccionTrabajo ?? studentData.direccion_Trabajo_Padre,
        telefonoTrabajo: studentData.PadreTelefonoTrabajo ?? studentData.telefono_trabajo_Padre
      });
    }

    // 8. Actualizar tipo de sangre en historial_medico
    const bloodTypeVal = studentData.TipoSangre ?? studentData.tipo_sangre ?? studentData.blood_type;
    if (bloodTypeVal) {
      if (currentStudent.id_historia) {
        await client.query(
          'UPDATE historial_medico SET tipo_sangre = $1 WHERE id_historia = $2',
          [bloodTypeVal, currentStudent.id_historia]
        );
      } else {
        const insHm = await client.query(
          'INSERT INTO historial_medico (tipo_sangre) VALUES ($1) RETURNING id_historia',
          [bloodTypeVal]
        );
        await client.query('UPDATE estudiante SET id_historia = $1 WHERE id_estudiante = $2', [insHm.rows[0].id_historia, id]);
        currentStudent.id_historia = insHm.rows[0].id_historia;
      }
    }

    await client.query('COMMIT');
    return await findById(id);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error("Error en update student:", error);
    throw error;
  } finally {
    client.release();
  }
};

/**
 * Elimina un estudiante
 * @param {number} id - ID del estudiante
 * @returns {Promise<Object>}
 */
const remove = async (id) => {
  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    // Eliminar relaciones en Estudiante_Seccion
    await client.query(
      'DELETE FROM "Estudiante_Seccion" WHERE "Id_estudiante" = $1',
      [id]
    );

    // Eliminar el estudiante
    const query = {
      text: 'DELETE FROM "Estudiante" WHERE "Id_estudiante" = $1 RETURNING "Id_estudiante" as id',
      values: [id]
    };
    const { rows } = await client.query(query.text, query.values);

    await client.query('COMMIT');
    return rows[0];
  } catch (error) {
    await client.query('ROLLBACK');
    console.error("Error en remove student:", error);
    throw error;
  } finally {
    client.release();
  }
};

/**
 * Inscribe un estudiante en una sección
 * @param {number} studentId - ID del estudiante
 * @param {number} sectionId - ID de la sección
 * @returns {Promise<Object>}
 */
const enrollInSection = async (studentId, sectionId) => {
  try {
    // Verificar que la sección tenga capacidad disponible
    const checkQuery = {
      text: `
        SELECT s."capacidad", COUNT(es."Id_estudiante_seccion") as enrolled
        FROM "Seccion" s
        LEFT JOIN "Estudiante_Seccion" es ON s."Id_seccion" = es."Id_seccion"
        WHERE s."Id_seccion" = $1
        GROUP BY s."Id_seccion"
      `,
      values: [sectionId]
    };
    const { rows } = await db.query(checkQuery.text, checkQuery.values);

    if (rows.length > 0) {
      const { capacidad, enrolled } = rows[0];
      if (enrolled >= capacidad) {
        throw new Error("La sección ha alcanzado su capacidad máxima");
      }
    }

    // Inscribir estudiante
    const query = {
      text: `
        INSERT INTO "Estudiante_Seccion" ("Id_estudiante", "Id_seccion")
        VALUES ($1, $2)
        RETURNING 
          "Id_estudiante_seccion" as id,
          "Id_estudiante" as student_id,
          "Id_seccion" as section_id
      `,
      values: [studentId, sectionId]
    };
    const result = await db.query(query.text, query.values);
    return result.rows[0];
  } catch (error) {
    console.error("Error en enrollInSection:", error);
    throw error;
  }
};

/**
 * Elimina la inscripción de un estudiante de una sección
 * @param {number} studentId - ID del estudiante
 * @param {number} sectionId - ID de la sección
 * @returns {Promise<Object>}
 */
const removeFromSection = async (studentId, sectionId) => {
  try {
    const query = {
      text: `
        DELETE FROM "Estudiante_Seccion"
        WHERE "Id_estudiante" = $1 AND "Id_seccion" = $2
        RETURNING "Id_estudiante_seccion" as id
      `,
      values: [studentId, sectionId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error en removeFromSection:", error);
    throw error;
  }
};

/**
 * Busca estudiantes por criterios (nombre, apellido, cédula)
 * @param {string} searchTerm - Término de búsqueda
 * @returns {Promise<Array>}
 */
const search = async (searchTerm) => {
  try {
    const query = {
      text: `
        SELECT 
          e.id_estudiante as id,
          p.nombre as first_name,
          p.apellido as last_name,
          p.cedula as dni,
          p.fecha_nacimiento as birth_date,
          p.genero as gender
        FROM estudiante e
        JOIN persona p ON e.id_persona = p.id_persona
        WHERE p.nombre ILIKE $1
           OR p.apellido ILIKE $1
           OR p.cedula ILIKE $1
        ORDER BY p.apellido, p.nombre
        LIMIT 50
      `,
      values: [`%${searchTerm}%`]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en search students:", error);
    throw error;
  }
};

/**
 * Verifica si una cédula ya está registrada
 * @param {string} cedula - Cédula a verificar
 * @param {number} excludeId - ID a excluir (para actualizaciones)
 * @returns {Promise<boolean>}
 */
const existsByCedula = async (cedula, excludeId = null) => {
  try {
    let query = {
      text: `
        SELECT e.id_estudiante as id 
        FROM estudiante e 
        JOIN persona p ON e.id_persona = p.id_persona 
        WHERE p.cedula = $1
      `,
      values: [cedula]
    };

    if (excludeId) {
      query.text += ' AND e.id_estudiante != $2';
      query.values.push(excludeId);
    }

    const { rows } = await db.query(query.text, query.values);
    return rows.length > 0;
  } catch (error) {
    console.error("Error en existsByCedula:", error);
    throw error;
  }
};

/**
 * Obtiene estudiantes por ID de representante
 * @param {number} representanteId - ID del representante
 * @returns {Promise<Array>}
 */
const findByRepresentante = async (representanteId) => {
  try {
    const repId = parseInt(representanteId);
    const query = {
      text: `
        SELECT 
          e.id_estudiante as id,
          p.nombre as first_name,
          p.segundo_nombre as middle_name,
          p.segundo_nombre as segundo_nombre,
          p.segundo_nombre as second_name,
          p.apellido as last_name,
          p.segundo_apellido as second_last_name,
          p.segundo_apellido as segundo_apellido,
          p.cedula as dni,
          TO_CHAR(p.fecha_nacimiento, 'YYYY-MM-DD') as birth_date,
          p.genero as gender,
          nl.nivel as grade_level,
          e.id_nivel_danza as dance_level_id,
          nd.nivel_danza as dance_level_name,
          nd.nivel_danza as dance_level,
          e.id_especialidad as specialty_id,
          e.id_especialidad as especialidad_id,
          esp.nombre_especialidad as specialty_name,
          esp.nombre_especialidad as especialidad,
          e.seguro_escolar as school_insurance,
          e.id_representante as representative_id,
          p_r.nombre as representative_first_name,
          p_r.segundo_nombre as representative_second_name,
          p_r.segundo_nombre as representative_segundo_nombre,
          p_r.apellido as representative_last_name,
          p_r.segundo_apellido as representative_second_last_name,
          p_r.segundo_apellido as representative_segundo_apellido,
          p_r.cedula as representative_dni,
          p_r.numero_telefono as representative_phone,
          p_r.email as representative_email,
          ef.parentesco as parentesco
        FROM estudiante e
        JOIN persona p ON e.id_persona = p.id_persona
        LEFT JOIN nivel_escolar nl ON e.id_nivel = nl.id_nivel
        LEFT JOIN nivel_danza nd ON e.id_nivel_danza = nd.id_nivel_danza
        LEFT JOIN especialidad esp ON e.id_especialidad = esp.id_especialidad
        LEFT JOIN representante r ON e.id_representante = r.id_representante
        LEFT JOIN persona p_r ON r.id_persona = p_r.id_persona
        LEFT JOIN estudiante_familiar ef ON ef.id_estudiante = e.id_estudiante AND ef.id_persona = r.id_persona
        WHERE e.id_representante = $1
           OR e.id_representante IN (
             SELECT r2.id_representante FROM representante r2 
             WHERE r2.id_usuario = (SELECT r3.id_usuario FROM representante r3 WHERE r3.id_representante = $1)
           )
           OR e.id_estudiante IN (
             SELECT ef2.id_estudiante FROM estudiante_familiar ef2
             WHERE ef2.id_persona = (SELECT r4.id_persona FROM representante r4 WHERE r4.id_representante = $1)
           )
        ORDER BY p.apellido, p.nombre
      `,
      values: [repId]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error en findByRepresentante:", error);
    throw error;
  }
};



/**
 * Obtiene los boletines de un estudiante por año académico
 * @param {number} studentId - ID del estudiante
 * @param {number} academicYearId - ID del año académico (opcional)
 * @returns {Promise<Array>}
 */
const getStudentBoletines = async (studentId, academicYearId = null) => {
  try {
    // 1. Verificar si el boletín está disponible para este estudiante y año
    let availabilityQuery = `
      SELECT "is_available", "downloads", "academic_year_id"
      FROM "Boletin_Estudiante"
      WHERE "student_id" = $1
    `;
    const availabilityValues = [studentId];

    if (academicYearId) {
      availabilityQuery += ` AND "academic_year_id" = $2`;
      availabilityValues.push(academicYearId);
    }

    const { rows: availabilityRows } = await db.query(availabilityQuery, availabilityValues);

    // Si no hay registro de boletín o ninguno está disponible, retornamos vacío (o manejamos según lógica de negocio)
    // PERO: Queremos mostrar las notas SI el admin ya generó el boletín (is_available = true)

    // Mapa de disponibilidad por año
    const availabilityMap = {};
    availabilityRows.forEach(row => {
      availabilityMap[row.academic_year_id] = {
        is_available: row.is_available,
        downloads: row.downloads
      };
    });

    // 2. Consulta principal para calcular las notas finales
    // Esta consulta obtiene todas las calificaciones cargadas, las pondera por el porcentaje de su evaluación,
    // y las suma para obtener la nota final por materia y lapso.
    let query = {
      text: `
        SELECT 
          l."Id_lapso" as period_id,
          l."nombre_lapso" as period_name,
          a."Id_ano" as academic_year_id,
          a."nombre_ano" as academic_year_name,
          m."Id_materia" as subject_id,
          m."nombre_materia" as subject_name,
          COALESCE(g."nombre_grado", 'General') as subject_year,
          m."tipo_materia" as subject_type,
          
          -- Cálculo de la nota final: SUMA(nota * porcentaje / 100)
          SUM(
            CASE 
              WHEN cn."puntaje" IS NOT NULL 
              THEN (cn."puntaje" * ee."porcentaje" / 100)
              ELSE 0 
            END
          ) as final_score,
          
          -- Contar evaluaciones totales esperadas vs cargadas para saber si está completo (opcional)
          COUNT(ee."Id_estructura_evaluacion") as total_evals,
          COUNT(cn."Id_carga_nota") as loaded_evals

        FROM "Estudiante_Seccion" es
        JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
        JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
        LEFT JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
        JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
        JOIN "Ano_Academico" a ON l."Id_ano" = a."Id_ano"
        
        -- Unir con estructura de evaluación (plan de evaluación)
        JOIN "Estructura_Evaluacion" ee ON s."Id_seccion" = ee."Id_seccion"
        
        -- Unir con las notas cargadas (LEFT JOIN para no perder materias sin notas, aunque el boletín debería tenerlas)
        LEFT JOIN "Carga_Nota" cn ON ee."Id_estructura_evaluacion" = cn."Id_estructura_evaluacion" 
                                  AND cn."Id_estudiante" = es."Id_estudiante"
        
        WHERE es."Id_estudiante" = $1
      `
    };

    const queryValues = [studentId];
    let paramIndex = 2;

    if (academicYearId) {
      query.text += ` AND a."Id_ano" = $${paramIndex}`;
      queryValues.push(academicYearId);
    }

    // Agrupar por Lapso y Materia
    query.text += ` 
      GROUP BY 
        l."Id_lapso", l."nombre_lapso", 
        a."Id_ano", a."nombre_ano", 
        m."Id_materia", m."nombre_materia", g."nombre_grado", m."tipo_materia"
      ORDER BY a."nombre_ano" DESC, l."nombre_lapso" ASC, m."nombre_materia" ASC
    `;
    query.values = queryValues;

    const { rows } = await db.query(query.text, query.values);

    // 3. Estructurar la respuesta
    const boletinesPorAno = {};

    rows.forEach(row => {
      const yearId = row.academic_year_id;

      // Solo mostrar si el boletín está disponible para este año (o si queremos mostrar parciales, quitamos este check)
      const yearAvailability = availabilityMap[yearId];
      if (!yearAvailability || !yearAvailability.is_available) {
        return; // Skip si no está "generado/disponible"
      }

      if (!boletinesPorAno[yearId]) {
        boletinesPorAno[yearId] = {
          academic_year_id: yearId,
          academic_year_name: row.academic_year_name,
          periods: []
        };
      }

      // Buscar si ya existe el período en el array
      let period = boletinesPorAno[yearId].periods.find(p => p.period_id === row.period_id);

      if (!period) {
        period = {
          period_id: row.period_id,
          period_name: row.period_name,
          subjects: []
        };
        boletinesPorAno[yearId].periods.push(period);
      }

      // Agregar la materia al período
      period.subjects.push({
        subject_id: row.subject_id,
        subject_name: row.subject_name,
        subject_year: (row.subject_year && row.subject_year !== 'General') ? row.subject_year : '',
        subject_type: row.subject_type || null,
        final_score: parseFloat(row.final_score).toFixed(2), // Formatear a 2 decimales
        issue_date: new Date().toISOString(), // Fecha actual como referencia
        downloads: yearAvailability.downloads,
        available: true
      });
    });

    // 4. Agregar datos de revisión y de promoción para cada año
    const result = Object.values(boletinesPorAno);

    for (const yearData of result) {
      // 4.1 Enriquecer con datos de revisión
      try {
        const revisionMap = await RevisionModel.getRevisionMapByStudent(studentId, yearData.academic_year_id);
        
        for (const period of yearData.periods) {
          for (const subject of period.subjects) {
            const revision = revisionMap[subject.subject_id];
            if (revision) {
              subject.revision = {
                nota_revision: revision.nota_revision,
                estado: revision.estado,
                nota_definitiva: revision.nota_definitiva
              };
            } else {
              subject.revision = null;
            }
          }
        }
      } catch (revError) {
        console.error("Error cargando revisiones para boletín:", revError);
      }

      // 4.2 Enriquecer con datos de Promoción Anticipada (si existe acta aprobada)
      try {
        const promoRes = await db.query(
          `SELECT 
             ap."Id_acta" as id,
             ap."numero_acta" as act_number,
             ap."promedio_lapso1" as average_lapso1,
             ap."motivo" as reason,
             ap."resolucion" as resolution,
             go."nombre_grado" as origin_grade_name,
             gd."nombre_grado" as target_grade_name
           FROM "Acta_Promocion" ap
           JOIN "Grado" go ON ap."Id_grado_origen" = go."Id_grado"
           JOIN "Grado" gd ON ap."Id_grado_destino" = gd."Id_grado"
           WHERE ap."Id_estudiante" = $1 
             AND ap."Id_ano" = $2 
             AND ap."estado" = 'aprobada'`,
          [studentId, yearData.academic_year_id]
        );

        if (promoRes.rows.length > 0) {
          const promo = promoRes.rows[0];
          yearData.promocion = {
            promovido: true,
            numeroActa: promo.act_number,
            gradoOrigen: promo.origin_grade_name,
            siguienteNivel: promo.target_grade_name,
            promedioLapso1: parseFloat(promo.average_lapso1),
            motivo: promo.reason,
            resolucion: promo.resolution
          };
        } else {
          yearData.promocion = {
            promovido: false,
            siguienteNivel: null
          };
        }
      } catch (promoErr) {
        console.error("Error cargando datos de promoción para boletín:", promoErr);
        yearData.promocion = { promovido: false, siguienteNivel: null };
      }
    }

    return result;

  } catch (error) {
    console.error("Error en getStudentBoletines:", error);
    throw error;
  }
};







export const StudentModel = {
  findAll,
  findById,
  findSectionsByStudentId,
  create,
  update,
  remove,
  enrollInSection,
  removeFromSection,
  search,
  existsByCedula,
  findByRepresentante, // 👈 NUEVO
  getStudentBoletines,
};