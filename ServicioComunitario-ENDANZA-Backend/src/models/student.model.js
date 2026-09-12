import { db } from "../db/connection.database.js";
import { RevisionModel } from "./revision.model.js";
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
          e."Id_estudiante" as id,
          e."nombre" as first_name,
          e."apellido" as last_name,
          e."cedula" as dni,
          e."fecha_nacimiento" as birth_date,
          e."genero" as gender,
          e."seguro_escolar" as school_insurance,
          e."Id_nivel" as grade_level_id,
          nl."nivel" as grade_level_name,
          e."Id_nivel_danza" as dance_level_id,
          nd."nivel_danza" as dance_level_name,
          e."Id_escuela" as school_id,
          er."nombre_escuela" as school_name,
          e."Id_seguro" as insurance_id,
          s."tipo_seguro" as insurance_name,
          e."Id_representante" as representative_id,
          r."Id_usuario" as representative_user_id,
          u_r."nombre" as representative_first_name,
          u_r."apellido" as representative_last_name,
          u_r."cedula" as representative_dni,
          u_r."telefono" as representative_phone,
          u_r."correo" as representative_email,
          e."Id_historial" as medical_history_id,
          (
            SELECT json_agg(json_build_object(
              'id', es."Id_estudiante_seccion",
              'section_id', s."Id_seccion",
              'section_name', s."nombre_seccion",
              'academic_year', a."nombre_ano"
            ))
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
            JOIN "Ano_Academico" a ON l."Id_ano" = a."Id_ano"
            WHERE es."Id_estudiante" = e."Id_estudiante"
          ) as sections
        FROM "Estudiante" e
        LEFT JOIN "Nivel_Escolar" nl ON e."Id_nivel" = nl."Id_nivel"
        LEFT JOIN "Nivel_Danza" nd ON e."Id_nivel_danza" = nd."Id_nivel_danza"
        LEFT JOIN "Escuela_Regular" er ON e."Id_escuela" = er."Id_escuela"
        LEFT JOIN "Seguro" s ON e."Id_seguro" = s."Id_seguro"
        LEFT JOIN "Representante" r ON e."Id_representante" = r."Id_representante"
        LEFT JOIN "Usuario" u_r ON r."Id_usuario" = u_r."Id_usuario"
        WHERE 1=1
      `
    };

    const values = [];
    let paramIndex = 1;

    // Filtro por año académico (a través de las secciones)
    if (filters.academicYearId) {
      query.text += ` AND EXISTS (
        SELECT 1 FROM "Estudiante_Seccion" es
        JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
        JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
        WHERE es."Id_estudiante" = e."Id_estudiante"
        AND l."Id_ano" = $${paramIndex}
      )`;
      values.push(filters.academicYearId);
      paramIndex++;
    }

    // Filtro por sección específica
    if (filters.sectionId) {
      query.text += ` AND EXISTS (
        SELECT 1 FROM "Estudiante_Seccion" es
        WHERE es."Id_estudiante" = e."Id_estudiante"
        AND es."Id_seccion" = $${paramIndex}
      )`;
      values.push(filters.sectionId);
      paramIndex++;
    }

    query.text += ` ORDER BY e."apellido", e."nombre"`;
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
          e."Id_estudiante" as id,
          e."nombre" as first_name,
          e."apellido" as last_name,
          e."cedula" as dni,
          TO_CHAR(e."fecha_nacimiento", 'YYYY-MM-DD') as birth_date,
          e."genero" as gender,
          COALESCE(e."estatus", 'Activo') as status,
          hm."tipo_sangre" as blood_type,
          e."seguro_escolar" as school_insurance,
          e."Id_nivel" as grade_level_id,
          nl."nivel" as grade_level_name,
          e."Id_nivel_danza" as dance_level_id,
          nd."nivel_danza" as dance_level_name,
          e."Id_escuela" as school_id,
          er."nombre_escuela" as school_name,
          e."Id_seguro" as insurance_id,
          s."tipo_seguro" as insurance_name,
          e."Id_representante" as representative_id,
          r."Id_usuario" as representative_user_id,
          u_r."nombre" as representative_first_name,
          u_r."apellido" as representative_last_name,
          u_r."cedula" as representative_dni,
          u_r."telefono" as representative_phone,
          u_r."correo" as representative_email,
          u_r."genero" as representative_gender,
          r."es_familiar" as representative_es_familiar,
          r."profesion_rep" as representative_occupation,
          CASE 
            WHEN r."es_familiar" = true THEN (
              CASE 
                WHEN LOWER(u_r."genero") LIKE 'f%' OR LOWER(u_r."nombre") LIKE 'diana%' OR LOWER(u_r."nombre") LIKE '%maría%' OR LOWER(u_r."nombre") LIKE '%maria%' THEN 'Madre'
                WHEN LOWER(u_r."genero") LIKE 'm%' THEN 'Padre'
                ELSE 'Madre'
              END
            )
            ELSE 'Otro'
          END as representative_relationship,
          d."nombre_direccion" as address,
          c."nombre_ciudad" as city,
          st."nombre_estado" as state,
          e."Id_historial" as medical_history_id
        FROM "Estudiante" e
        LEFT JOIN "Historial_Medico" hm ON e."Id_historial" = hm."Id_historial"
        LEFT JOIN "Nivel_Escolar" nl ON e."Id_nivel" = nl."Id_nivel"
        LEFT JOIN "Nivel_Danza" nd ON e."Id_nivel_danza" = nd."Id_nivel_danza"
        LEFT JOIN "Escuela_Regular" er ON e."Id_escuela" = er."Id_escuela"
        LEFT JOIN "Seguro" s ON e."Id_seguro" = s."Id_seguro"
        LEFT JOIN "Representante" r ON e."Id_representante" = r."Id_representante"
        LEFT JOIN "Usuario" u_r ON r."Id_usuario" = u_r."Id_usuario"
        LEFT JOIN "Direccion" d ON u_r."Id_direccion" = d."Id_direccion"
        LEFT JOIN "Ciudad" c ON d."Id_ciudad" = c."Id_ciudad"
        LEFT JOIN "Parroquia" p ON c."Id_parroquia" = p."Id_parroquia"
        LEFT JOIN "Municipio" m ON p."Id_municipio" = m."Id_municipio"
        LEFT JOIN "Estado" st ON m."Id_estado" = st."Id_estado"
        WHERE e."Id_estudiante" = $1
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
          es."Id_estudiante_seccion" as id,
          es."Id_seccion" as section_id,
          s."nombre_seccion" as section_name,
          l."Id_ano" as academic_year_id,
          a."nombre_ano" as academic_year_name,
          l."nombre_lapso" as period_name
        FROM "Estudiante_Seccion" es
        JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
        JOIN "Lapso" l ON s."Id_lapso" = l."Id_lapso"
        JOIN "Ano_Academico" a ON l."Id_ano" = a."Id_ano"
        WHERE es."Id_estudiante" = $1
        ORDER BY a."nombre_ano" DESC, l."nombre_lapso"
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

    const formattedNombre = capitalizeWords(nombre);
    const formattedApellido = capitalizeWords(apellido);

    const query = {
      text: `
        INSERT INTO "Estudiante" (
          "nombre", "apellido", "cedula", "fecha_nacimiento", "genero",
          "seguro_escolar", "Id_nivel", "Id_nivel_danza", "Id_escuela",
          "Id_seguro", "Id_representante", "Id_historial"
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
        RETURNING 
          "Id_estudiante" as id, 
          "nombre" as first_name,
          "apellido" as last_name,
          "cedula" as dni
      `,
      values: [
        formattedNombre, formattedApellido, cedula, fecha_nacimiento, genero,
        seguro_escolar || false, Id_nivel, Id_nivel_danza, Id_escuela,
        Id_seguro, Id_representante, Id_historial
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
  try {
    const rawNombre = studentData.EstudiantePrimerNombre
      ? `${studentData.EstudiantePrimerNombre} ${studentData.EstudianteSegundoNombre || ''}`.trim()
      : (studentData.nombre ?? studentData.first_name ?? studentData.NombreEstudiante);
    const rawApellido = studentData.EstudiantePrimerApellido
      ? `${studentData.EstudiantePrimerApellido} ${studentData.EstudianteSegundoApellido || ''}`.trim()
      : (studentData.apellido ?? studentData.last_name ?? studentData.ApellidoEstudiante);
    const cedula = studentData.cedula ?? studentData.dni ?? studentData.Cedula;
    const fecha_nacimiento = studentData.fecha_nacimiento ?? studentData.birth_date ?? studentData.FechaNacimiento;
    const genero = studentData.genero ?? studentData.gender ?? studentData.Sexo;
    const seguro_escolar = studentData.seguro_escolar ?? studentData.school_insurance;
    const Id_nivel = studentData.Id_nivel ?? studentData.grade_level_id;
    const Id_nivel_danza = studentData.Id_nivel_danza ?? studentData.dance_level_id;
    const Id_escuela = studentData.Id_escuela ?? studentData.school_id;
    const Id_seguro = studentData.Id_seguro ?? studentData.insurance_id;
    const Id_representante = studentData.Id_representante ?? studentData.representative_id;
    const Id_historial = studentData.Id_historial ?? studentData.medical_history_id;
    const estatus = studentData.estatus ?? studentData.status ?? studentData.Estatus;

    const formattedNombre = rawNombre !== undefined ? capitalizeWords(rawNombre) : undefined;
    const formattedApellido = rawApellido !== undefined ? capitalizeWords(rawApellido) : undefined;

    const query = {
      text: `
        UPDATE "Estudiante"
        SET 
          "nombre" = COALESCE($1, "nombre"),
          "apellido" = COALESCE($2, "apellido"),
          "cedula" = COALESCE($3, "cedula"),
          "fecha_nacimiento" = COALESCE($4, "fecha_nacimiento"),
          "genero" = COALESCE($5, "genero"),
          "seguro_escolar" = COALESCE($6, "seguro_escolar"),
          "Id_nivel" = COALESCE($7, "Id_nivel"),
          "Id_nivel_danza" = COALESCE($8, "Id_nivel_danza"),
          "Id_escuela" = COALESCE($9, "Id_escuela"),
          "Id_seguro" = COALESCE($10, "Id_seguro"),
          "Id_representante" = COALESCE($11, "Id_representante"),
          "Id_historial" = COALESCE($12, "Id_historial"),
          "estatus" = COALESCE($13, "estatus")
        WHERE "Id_estudiante" = $14
        RETURNING 
          "Id_estudiante" as id,
          "nombre" as first_name,
          "apellido" as last_name,
          "cedula" as dni
      `,
      values: [
        formattedNombre, formattedApellido, cedula, fecha_nacimiento, genero,
        seguro_escolar, Id_nivel, Id_nivel_danza, Id_escuela,
        Id_seguro, Id_representante, Id_historial, estatus, id
      ]
    };

    const { rows } = await db.query(query.text, query.values);

    // Actualizar o crear datos del representante vinculado
    let existingStudent = await findById(id);
    const isMadre = studentData.RepresentanteParentesco === 'Madre' ||
      existingStudent?.representative_relationship === 'Madre' ||
      (existingStudent?.representative_gender && String(existingStudent.representative_gender).toLowerCase().startsWith('f')) ||
      (!['Padre', 'Tío', 'Abuelo', 'Hermano'].includes(studentData.RepresentanteParentesco));

    const isPadre = studentData.RepresentanteParentesco === 'Padre' ||
      existingStudent?.representative_relationship === 'Padre' ||
      (existingStudent?.representative_gender && String(existingStudent.representative_gender).toLowerCase().startsWith('m'));

    const repFirstName = studentData.RepresentantePrimerNombre
      ? `${studentData.RepresentantePrimerNombre} ${studentData.RepresentanteSegundoNombre || ''}`.trim()
      : (studentData.representative_first_name ?? studentData.RepresentanteNombre ?? (isMadre ? (studentData.MadrePrimerNombre || studentData.MadreNombre) : (isPadre ? (studentData.PadrePrimerNombre || studentData.PadreNombre) : null)));
    const repLastName = studentData.RepresentantePrimerApellido
      ? `${studentData.RepresentantePrimerApellido} ${studentData.RepresentanteSegundoApellido || ''}`.trim()
      : (studentData.representative_last_name ?? studentData.RepresentanteApellido ?? (isMadre ? (studentData.MadrePrimerApellido || studentData.MadreApellido) : (isPadre ? (studentData.PadrePrimerApellido || studentData.PadreApellido) : null)));

    // Extraer cédula limpia
    const rawRepDni = (studentData.RepresentanteCedula && String(studentData.RepresentanteCedula).trim()) ||
      (isMadre && studentData.MadreCedula && String(studentData.MadreCedula).trim()) ||
      (isPadre && studentData.PadreCedula && String(studentData.PadreCedula).trim()) ||
      (studentData.MadreCedula && String(studentData.MadreCedula).trim()) ||
      (studentData.PadreCedula && String(studentData.PadreCedula).trim()) ||
      studentData.representative_dni;
    const repDni = rawRepDni ? String(rawRepDni).replace(/[^0-9]/g, '').slice(0, 8) : null;

    const rawRepPhone = (studentData.RepresentanteTelefono && String(studentData.RepresentanteTelefono).trim()) ||
      (isMadre && studentData.MadreTelefono && String(studentData.MadreTelefono).trim()) ||
      (isPadre && studentData.PadreTelefono && String(studentData.PadreTelefono).trim()) ||
      (studentData.MadreTelefono && String(studentData.MadreTelefono).trim()) ||
      studentData.representative_phone;
    const repPhone = rawRepPhone || null;

    const rawRepEmail = (studentData.RepresentanteEmail && String(studentData.RepresentanteEmail).trim()) ||
      (isMadre && studentData.MadreEmail && String(studentData.MadreEmail).trim()) ||
      (isPadre && studentData.PadreEmail && String(studentData.PadreEmail).trim()) ||
      (studentData.MadreEmail && String(studentData.MadreEmail).trim()) ||
      studentData.representative_email;
    const repEmail = rawRepEmail || null;

    const repOccupation = studentData.RepresentanteOcupacion || (isMadre ? studentData.MadreOcupacion : (isPadre ? studentData.PadreOcupacion : null)) || studentData.representative_occupation;
    const repParentesco = studentData.RepresentanteParentesco ?? studentData.parentesco ?? (isMadre ? 'Madre' : (isPadre ? 'Padre' : 'Otro'));

    console.log('🔍 [UPDATE] Datos del representante a actualizar:', {
      repFirstName,
      repLastName,
      repDni,
      repPhone,
      repEmail,
      representative_user_id: existingStudent?.representative_user_id,
      representative_id: existingStudent?.representative_id,
      isMadre,
      isPadre
    });

    // CASO 1: Si no tiene representante asignado en Estudiante pero se enviaron datos, crearlo o vincularlo
    if (!existingStudent?.representative_user_id && (repFirstName || repLastName || repDni || repPhone || repEmail)) {
      let usuarioId = null;
      if (repDni) {
        const uRes = await db.query(
          'SELECT "Id_usuario" FROM "Usuario" WHERE "cedula" = $1 OR "cedula" = $2',
          [repDni, `V-${repDni}`]
        );
        if (uRes.rows.length > 0) {
          usuarioId = uRes.rows[0].Id_usuario;
        }
      }

      if (!usuarioId) {
        const insertUser = await db.query(`
          INSERT INTO "Usuario" ("nombre", "apellido", "cedula", "telefono", "correo", "Id_rol")
          VALUES ($1, $2, $3, $4, $5, 2)
          RETURNING "Id_usuario"
        `, [
          repFirstName ? capitalizeWords(repFirstName) : 'Representante',
          repLastName ? capitalizeWords(repLastName) : '',
          repDni,
          repPhone,
          repEmail
        ]);
        usuarioId = insertUser.rows[0].Id_usuario;
      }

      let repId = null;
      const existRep = await db.query('SELECT "Id_representante" FROM "Representante" WHERE "Id_usuario" = $1', [usuarioId]);
      if (existRep.rows.length > 0) {
        repId = existRep.rows[0].Id_representante;
      } else {
        const insertRep = await db.query(`
          INSERT INTO "Representante" ("Id_usuario", "es_familiar", "profesion_rep")
          VALUES ($1, $2, $3)
          RETURNING "Id_representante"
        `, [
          usuarioId,
          repParentesco !== 'Otro',
          repOccupation || null
        ]);
        repId = insertRep.rows[0].Id_representante;
      }

      await db.query(`UPDATE "Estudiante" SET "Id_representante" = $1 WHERE "Id_estudiante" = $2`, [repId, id]);
    } else if (existingStudent?.representative_user_id) {
      // CASO 2: Ya tiene representante asignado
      // Verificar si la cédula ya pertenece a otro Usuario para evitar error de constraint UNIQUE
      if (repDni) {
        const dupCheck = await db.query(
          'SELECT "Id_usuario" FROM "Usuario" WHERE ("cedula" = $1 OR "cedula" = $2) AND "Id_usuario" != $3',
          [repDni, `V-${repDni}`, existingStudent.representative_user_id]
        );
        if (dupCheck.rows.length > 0) {
          const otherUserId = dupCheck.rows[0].Id_usuario;
          const repCheck = await db.query('SELECT "Id_representante" FROM "Representante" WHERE "Id_usuario" = $1', [otherUserId]);
          let otherRepId = repCheck.rows[0]?.Id_representante;
          if (!otherRepId) {
            const newRep = await db.query('INSERT INTO "Representante" ("Id_usuario", "es_familiar") VALUES ($1, true) RETURNING "Id_representante"', [otherUserId]);
            otherRepId = newRep.rows[0].Id_representante;
          }
          await db.query('UPDATE "Estudiante" SET "Id_representante" = $1 WHERE "Id_estudiante" = $2', [otherRepId, id]);
          existingStudent.representative_user_id = otherUserId;
          existingStudent.representative_id = otherRepId;
        }
      }

      if (repFirstName || repLastName || repDni || repPhone || repEmail) {
        const updateResult = await db.query(`
          UPDATE "Usuario"
          SET
            "nombre" = COALESCE($1, "nombre"),
            "apellido" = COALESCE($2, "apellido"),
            "cedula" = COALESCE($3, "cedula"),
            "telefono" = COALESCE($4, "telefono"),
            "correo" = COALESCE($5, "correo"),
            "actualizado_en" = NOW()
          WHERE "Id_usuario" = $6
          RETURNING "Id_usuario", "cedula"
        `, [
          repFirstName ? capitalizeWords(repFirstName) : null,
          repLastName ? capitalizeWords(repLastName) : null,
          repDni,
          repPhone,
          repEmail,
          existingStudent.representative_user_id
        ]);
        console.log('✅ [UPDATE] Resultado de UPDATE Usuario:', updateResult.rows);
      }

      if (existingStudent.representative_id && (repOccupation !== undefined || repParentesco !== undefined)) {
        await db.query(`
          UPDATE "Representante"
          SET
            "profesion_rep" = COALESCE($1, "profesion_rep"),
            "es_familiar" = COALESCE($2, "es_familiar")
          WHERE "Id_representante" = $3
        `, [
          repOccupation || null,
          repParentesco ? (repParentesco !== 'Otro') : null,
          existingStudent.representative_id
        ]);
      }
    }

    // Actualizar tipo de sangre en Historial_Medico
    const tipoSangre = studentData.tipo_sangre ?? studentData.blood_type ?? studentData.TipoSangre;
    if (tipoSangre) {
      if (existingStudent?.medical_history_id) {
        await db.query(
          'UPDATE "Historial_Medico" SET "tipo_sangre" = $1 WHERE "Id_historial" = $2',
          [tipoSangre, existingStudent.medical_history_id]
        );
      } else {
        const insHist = await db.query(
          'INSERT INTO "Historial_Medico" ("tipo_sangre") VALUES ($1) RETURNING "Id_historial"',
          [tipoSangre]
        );
        const newHistId = insHist.rows[0].Id_historial;
        await db.query('UPDATE "Estudiante" SET "Id_historial" = $1 WHERE "Id_estudiante" = $2', [newHistId, id]);
      }
    }

    // Actualizar Dirección / Ciudad si se proporcionó
    const dirVal = studentData.Direccion ?? studentData.address ?? studentData.direccion;
    const ciudadVal = studentData.Ciudad ?? studentData.city ?? studentData.ciudad;
    if (dirVal || ciudadVal) {
      let ciudadId = null;
      if (ciudadVal) {
        const cRes = await db.query('SELECT "Id_ciudad" FROM "Ciudad" WHERE LOWER("nombre_ciudad") = LOWER($1)', [ciudadVal]);
        if (cRes.rows.length > 0) {
          ciudadId = cRes.rows[0].Id_ciudad;
        }
      }

      const repUserId = existingStudent?.representative_user_id;
      if (repUserId) {
        const uDirRes = await db.query('SELECT "Id_direccion" FROM "Usuario" WHERE "Id_usuario" = $1', [repUserId]);
        const currentDirId = uDirRes.rows[0]?.Id_direccion;
        if (currentDirId) {
          await db.query(
            'UPDATE "Direccion" SET "nombre_direccion" = COALESCE($1, "nombre_direccion"), "Id_ciudad" = COALESCE($2, "Id_ciudad") WHERE "Id_direccion" = $3',
            [dirVal, ciudadId, currentDirId]
          );
        } else if (dirVal) {
          const insDir = await db.query(
            'INSERT INTO "Direccion" ("nombre_direccion", "Id_ciudad") VALUES ($1, $2) RETURNING "Id_direccion"',
            [dirVal, ciudadId]
          );
          await db.query('UPDATE "Usuario" SET "Id_direccion" = $1 WHERE "Id_usuario" = $2', [insDir.rows[0].Id_direccion, repUserId]);
        }
      }
    }

    const fullUpdated = await findById(id);
    return fullUpdated || rows[0];
  } catch (error) {
    console.error("Error en update student:", error);
    throw error;
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
          e."Id_estudiante" as id,
          e."nombre" as first_name,
          e."apellido" as last_name,
          e."cedula" as dni,
          e."fecha_nacimiento" as birth_date,
          e."genero" as gender
        FROM "Estudiante" e
        WHERE e."nombre" ILIKE $1
           OR e."apellido" ILIKE $1
           OR e."cedula" ILIKE $1
        ORDER BY e."apellido", e."nombre"
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
      text: 'SELECT "Id_estudiante" as id FROM "Estudiante" WHERE "cedula" = $1',
      values: [cedula]
    };

    if (excludeId) {
      query.text += ' AND "Id_estudiante" != $2';
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
    const query = {
      text: `
        SELECT 
          e."Id_estudiante" as id,
          e."nombre" as first_name,
          e."apellido" as last_name,
          e."cedula" as dni,
          e."fecha_nacimiento" as birth_date,
          e."genero" as gender,
          nl."nivel" as grade_level,
          nd."nivel_danza" as dance_level,
          e."seguro_escolar" as school_insurance
        FROM "Estudiante" e
        LEFT JOIN "Nivel_Escolar" nl ON e."Id_nivel" = nl."Id_nivel"
        LEFT JOIN "Nivel_Danza" nd ON e."Id_nivel_danza" = nd."Id_nivel_danza"
        WHERE e."Id_representante" = $1
        ORDER BY e."apellido", e."nombre"
      `,
      values: [representanteId]
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