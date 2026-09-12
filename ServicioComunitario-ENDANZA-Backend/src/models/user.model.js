import { db } from "../db/connection.database.js";
import bcryptjs from "bcryptjs";
import { capitalizeWords } from "../utils/formatters.js";

// ============================================
// FUNCIÓN PARA MIGRAR PASSWORD AUTOMÁTICAMENTE
// ============================================
const migratePasswordToHash = async (userId, plainPassword) => {
  try {
    console.log(`🔄 MIGRATE - Migrando password a hash para usuario ${userId}`);
    
    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(plainPassword, salt);
    
    const query = {
      text: `
        UPDATE "Usuario"
        SET "clave" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
      `,
      values: [hashedPassword, userId],
    };
    
    await db.query(query.text, query.values);
    console.log(`✅ MIGRATE - Password migrado exitosamente para usuario ${userId}`);
    
    return hashedPassword;
  } catch (error) {
    console.error(`❌ MIGRATE - Error migrando password usuario ${userId}:`, error);
    throw error;
  }
};

// ============================================
// FUNCIÓN PARA MIGRAR TODOS LOS PASSWORDS
// ============================================
const migrateAllPasswords = async () => {
  try {
    console.log("🚀 MIGRATE ALL - Iniciando migración de todos los passwords...");
    
    const query = {
      text: `
        SELECT "Id_usuario", "clave", "username", "correo" 
        FROM "Usuario" 
        WHERE "clave" IS NOT NULL 
        AND "clave" != '' 
        AND "clave" NOT LIKE '$2a$%'
        AND "clave" NOT LIKE '$2b$%'
      `
    };
    
    const { rows } = await db.query(query.text);
    console.log(`📊 MIGRATE ALL - Encontrados ${rows.length} usuarios para migrar`);
    
    let migrated = 0;
    let errors = 0;
    const results = [];
    
    for (const user of rows) {
      try {
        if (!user.clave || user.clave.trim() === '') {
          console.log(`⚠️ Usuario ${user.Id_usuario} tiene password vacío, omitiendo`);
          continue;
        }
        
        console.log(`🔄 Migrando usuario ${user.Id_usuario} (${user.username || user.correo})`);
        
        const salt = await bcryptjs.genSalt(10);
        const hashedPassword = await bcryptjs.hash(user.clave, salt);
        
        const updateQuery = {
          text: `UPDATE "Usuario" SET "clave" = $1 WHERE "Id_usuario" = $2`,
          values: [hashedPassword, user.Id_usuario]
        };
        
        await db.query(updateQuery.text, updateQuery.values);
        migrated++;
        
        results.push({
          id: user.Id_usuario,
          username: user.username || user.correo,
          status: 'success'
        });
        
        console.log(`✅ Migrado usuario ${user.Id_usuario}`);
      } catch (error) {
        errors++;
        results.push({
          id: user.Id_usuario,
          username: user.username || user.correo,
          status: 'error',
          error: error.message
        });
        console.error(`❌ Error migrando usuario ${user.Id_usuario}:`, error.message);
      }
    }
    
    console.log(`🎉 MIGRATE ALL - Migración completada: ${migrated} exitosos, ${errors} errores`);
    
    return {
      migrated,
      errors,
      total: rows.length,
      results
    };
  } catch (error) {
    console.error("❌ MIGRATE ALL - Error general:", error);
    throw error;
  }
};

// ============================================
// CREAR PROFESOR AUTOMÁTICAMENTE - ¡CORREGIDO!
// ============================================
const createProfesor = async (usuarioId) => {
  try {
    console.log(`👨‍🏫 Creando registro de profesor para usuario ${usuarioId}`);
    
    // 1. Verificar si el usuario existe
    const userCheck = await db.query(
      'SELECT "Id_rol" FROM "Usuario" WHERE "Id_usuario" = $1',
      [usuarioId]
    );
    
    if (userCheck.rows.length === 0) {
      throw new Error(`Usuario ${usuarioId} no existe`);
    }
    
    // Asegurar que tenga el rol 2 en Usuario_Rol
    await db.query(
      'INSERT INTO "Usuario_Rol" ("Id_usuario", "Id_rol") VALUES ($1, 2) ON CONFLICT DO NOTHING',
      [usuarioId]
    );
    
    // 2. Verificar si ya existe en Profesor
    const checkQuery = {
      text: `SELECT "Id_profesor" FROM "Profesor" WHERE "Id_usuario" = $1`,
      values: [usuarioId]
    };
    
    const checkResult = await db.query(checkQuery.text, checkQuery.values);
    
    if (checkResult.rows.length > 0) {
      console.log(`ℹ️ El usuario ${usuarioId} ya es profesor (ID: ${checkResult.rows[0].Id_profesor})`);
      return checkResult.rows[0];
    }
    
    // 3. Crear el registro en Profesor
    const insertQuery = {
      text: `
        INSERT INTO "Profesor" ("Id_usuario", "especialidad")
        VALUES ($1, NULL)
        RETURNING "Id_profesor" as id, "Id_usuario" as usuario_id
      `,
      values: [usuarioId]
    };
    
    const { rows } = await db.query(insertQuery.text, insertQuery.values);
    console.log(`✅ Profesor creado exitosamente con ID: ${rows[0].id} para usuario ${usuarioId}`);
    
    return rows[0];
  } catch (error) {
    console.error("❌ Error en createProfesor:", error);
    throw error;
  }
};




// ============================================
// ACTUALIZAR USUARIO POR ADMIN
// ============================================
const updateUserByAdmin = async (id, { 
  cedula, nombre, apellido, telefono, email, Id_rol, status, password 
}) => {
  try {
    let hashedPassword = null;
    if (password) {
      const salt = await bcryptjs.genSalt(10);
      hashedPassword = await bcryptjs.hash(password, salt);
    }

    const formattedNombre = nombre !== undefined ? capitalizeWords(nombre) : undefined;
    const formattedApellido = apellido !== undefined ? capitalizeWords(apellido) : undefined;

    const query = {
      text: `
        UPDATE "Usuario"
        SET 
          "cedula" = COALESCE($1, "cedula"),
          "nombre" = COALESCE($2, "nombre"),
          "apellido" = COALESCE($3, "apellido"),
          "telefono" = COALESCE($4, "telefono"),
          "correo" = COALESCE($5, "correo"),
          "Id_rol" = COALESCE($6, "Id_rol"),
          "estatus_usuario" = COALESCE($7, "estatus_usuario"),
          "clave" = COALESCE($8, "clave"),
          "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $9
        RETURNING 
          "Id_usuario" as id, 
          "cedula" as dni,
          "nombre" as first_name,
          "apellido" as last_name,
          "telefono" as phone,
          "correo" as email,
          "estatus_usuario" as status,
          "Id_rol"
      `,
      values: [cedula, formattedNombre, formattedApellido, telefono, email, Id_rol, status, hashedPassword, id]
    };

    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("❌ Error en updateUserByAdmin:", error);
    throw error;
  }
};

// ============================================
// ACTUALIZAR ROL DE USUARIO
// ============================================
const updateUserRole = async (id, Id_rol) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "Id_rol" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
        RETURNING 
          "Id_usuario" as id, 
          "cedula" as dni,
          "nombre" as first_name,
          "apellido" as last_name,
          "correo" as email,
          "estatus_usuario" as status,
          "Id_rol"
      `,
      values: [Id_rol, id]
    };

    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("❌ Error en updateUserRole:", error);
    throw error;
  }
};

// ============================================
// ELIMINAR USUARIO DOCENTE - VERSIÓN ROBUSTA
// ============================================
const removeProfesorCompleto = async (usuarioId) => {
  try {
    console.log(`🔍 Eliminando docente y sus relaciones para usuario ${usuarioId}`);
    
    // 1. Verificar si existe en tabla Profesor - PROBAR MÚLTIPLES FORMATOS
    let profesorId = null;
    
    // Probar con "Id_usuario"
    try {
      const profResult = await db.query(
        'SELECT "Id_profesor" FROM "Profesor" WHERE "Id_usuario" = $1',
        [usuarioId]
      );
      if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
    } catch (e) { /* ignorar */ }
    
    // Probar con "id_usuario" si no encontró
    if (!profesorId) {
      try {
        const profResult = await db.query(
          'SELECT "Id_profesor" FROM "Profesor" WHERE "id_usuario" = $1',
          [usuarioId]
        );
        if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
      } catch (e) { /* ignorar */ }
    }
    
    // Probar con "usuario_id"
    if (!profesorId) {
      try {
        const profResult = await db.query(
          'SELECT "Id_profesor" FROM "Profesor" WHERE "usuario_id" = $1',
          [usuarioId]
        );
        if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
      } catch (e) { /* ignorar */ }
    }
    
    // 2. Si encontramos profesor, eliminar sus relaciones
    if (profesorId) {
      console.log(`📌 Profesor ID: ${profesorId} encontrado`);
      
      // Eliminar relaciones - ESTAS SÍ SABEMOS QUE USAN "Id_profesor"
      await db.query('DELETE FROM "Horario" WHERE "Id_profesor" = $1', [profesorId]);
      await db.query('DELETE FROM "Profesor_Materia" WHERE "Id_profesor" = $1', [profesorId]);
      
      try { await db.query('DELETE FROM "Profesor_Curso" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      try { await db.query('DELETE FROM "Calificacion" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      try { await db.query('DELETE FROM "Asistencia" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      
      // Eliminar el profesor
      await db.query('DELETE FROM "Profesor" WHERE "Id_profesor" = $1', [profesorId]);
    }
    
    // 3. Eliminar REPRESENTANTE - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Representante" WHERE "Id_usuario" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Representante" WHERE "id_usuario" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Representante" WHERE "usuario_id" = $1', [usuarioId]); } catch (e) {}
    
    // 4. Eliminar ESTUDIANTE - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Estudiante" WHERE "Id_usuario" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Estudiante" WHERE "id_usuario" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Estudiante" WHERE "usuario_id" = $1', [usuarioId]); } catch (e) {}
    
    // 5. Eliminar INCIDENCIAS - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Incidencia" WHERE "Id_usuario_involucrado" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "id_usuario_involucrado" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "usuario_involucrado_id" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "Id_usuario_reporta" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "id_usuario_reporta" = $1', [usuarioId]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "usuario_reporta_id" = $1', [usuarioId]); } catch (e) {}
    
    // 6. Eliminar USUARIO - ESTE SÍ SABEMOS QUE FUNCIONA CON "Id_usuario"
    const result = await db.query(
      'DELETE FROM "Usuario" WHERE "Id_usuario" = $1 RETURNING "Id_usuario" as id',
      [usuarioId]
    );
    
    console.log(`✅ Usuario ${usuarioId} eliminado exitosamente`);
    return result.rows[0];
  } catch (error) {
    console.error("❌ Error en removeProfesorCompleto:", error);
    throw error;
  }
};

// ============================================
// ELIMINAR USUARIO GENÉRICO - VERSIÓN ROBUSTA
// ============================================
const remove = async (id) => {
  try {
    console.log(`🔍 Eliminando usuario ${id}...`);
    
    // 1. Verificar si es docente - PROBAR MÚLTIPLES FORMATOS
    let profesorId = null;
    
    try {
      const profResult = await db.query(
        'SELECT "Id_profesor" FROM "Profesor" WHERE "Id_usuario" = $1',
        [id]
      );
      if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
    } catch (e) {}
    
    if (!profesorId) {
      try {
        const profResult = await db.query(
          'SELECT "Id_profesor" FROM "Profesor" WHERE "id_usuario" = $1',
          [id]
        );
        if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
      } catch (e) {}
    }
    
    if (!profesorId) {
      try {
        const profResult = await db.query(
          'SELECT "Id_profesor" FROM "Profesor" WHERE "usuario_id" = $1',
          [id]
        );
        if (profResult.rows.length > 0) profesorId = profResult.rows[0].Id_profesor;
      } catch (e) {}
    }
    
    if (profesorId) {
      // Eliminar relaciones del profesor
      await db.query('DELETE FROM "Horario" WHERE "Id_profesor" = $1', [profesorId]);
      await db.query('DELETE FROM "Profesor_Materia" WHERE "Id_profesor" = $1', [profesorId]);
      
      try { await db.query('DELETE FROM "Profesor_Curso" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      try { await db.query('DELETE FROM "Calificacion" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      try { await db.query('DELETE FROM "Asistencia" WHERE "Id_profesor" = $1', [profesorId]); } catch (e) {}
      
      // Eliminar el profesor
      await db.query('DELETE FROM "Profesor" WHERE "Id_profesor" = $1', [profesorId]);
    }
    
    // 2. Eliminar representante - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Representante" WHERE "Id_usuario" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Representante" WHERE "id_usuario" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Representante" WHERE "usuario_id" = $1', [id]); } catch (e) {}
    
    // 3. Eliminar estudiante - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Estudiante" WHERE "Id_usuario" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Estudiante" WHERE "id_usuario" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Estudiante" WHERE "usuario_id" = $1', [id]); } catch (e) {}
    
    // 4. Eliminar incidencias - PROBAR TODOS LOS FORMATOS
    try { await db.query('DELETE FROM "Incidencia" WHERE "Id_usuario_involucrado" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "id_usuario_involucrado" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "usuario_involucrado_id" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "Id_usuario_reporta" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "id_usuario_reporta" = $1', [id]); } catch (e) {}
    try { await db.query('DELETE FROM "Incidencia" WHERE "usuario_reporta_id" = $1', [id]); } catch (e) {}
    
    // 5. Eliminar usuario - ESTE SÍ FUNCIONA
    const result = await db.query(
      'DELETE FROM "Usuario" WHERE "Id_usuario" = $1 RETURNING "Id_usuario" as id',
      [id]
    );
    
    console.log(`✅ Usuario ${id} eliminado exitosamente`);
    return result.rows[0];
  } catch (error) {
    console.error("❌ Error en remove:", error);
    throw error;
  }
};
// ============================================
// CREATE - Crear nuevo usuario (FUNCIONA)
// ============================================
const create = async ({
  username,
  email,
  password,
  Id_rol,
  security_word,
  respuesta_de_seguridad,
  nombre,
  apellido,
  cedula,
  telefono,
  fecha_nacimiento,
  genero,
  foto_usuario,
  Id_direccion
}) => {
  try {
    console.log("🔍 CREATE - Creando usuario con datos:", {
      username,
      email,
      passwordLength: password?.length || 0,
      Id_rol,
      nombre,
      apellido,
      cedula
    });

    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(password, salt);
    
    const formattedNombre = capitalizeWords(nombre);
    const formattedApellido = capitalizeWords(apellido);

    const query = {
      text: `
        INSERT INTO "Usuario" (
          "cedula", "nombre", "apellido", "clave", "telefono", "correo",
          "fecha_nacimiento", "genero", "foto_usuario", "estatus_usuario",
          "creado_en", "actualizado_en", "Id_rol", "Id_direccion",
          "username", "security_word", "respuesta_de_seguridad",
          "email_verified"
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'activo',
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, $10, $11,
                $12, $13, $14, false)
        RETURNING 
          "Id_usuario" as id, 
          "username", 
          "correo" as email, 
          "nombre", 
          "apellido", 
          "cedula", 
          "telefono",
          "fecha_nacimiento",
          "genero",
          "foto_usuario",
          "estatus_usuario" as is_active,
          "creado_en" as created_at,
          "actualizado_en" as updated_at,
          "Id_rol",
          "Id_direccion",
          "email_verified"
      `,
      values: [
        cedula, formattedNombre, formattedApellido, hashedPassword, telefono, email,
        fecha_nacimiento, genero, foto_usuario, Id_rol, Id_direccion,
        username || email, security_word, respuesta_de_seguridad
      ],
    };
    
    const { rows } = await db.query(query.text, query.values);
    console.log("✅ CREATE - Usuario creado exitosamente:", rows[0].id);
    
    return rows[0];
  } catch (error) {
    console.error("❌ CREATE - Error creando usuario:", error);
    throw error;
  }
};

// ============================================
// FIND ONE BY EMAIL
// ============================================
const findOneByEmail = async (email) => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."clave" as password,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."fecha_nacimiento",
          u."genero",
          u."foto_usuario",
          u."security_word",
          u."respuesta_de_seguridad",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."Id_direccion",
          u."password_reset_token",
          u."password_reset_expires",
          u."email_verification_token",
          u."last_login",
          u."creado_en" as created_at,
          u."actualizado_en" as updated_at,
          r."tipo_rol",
          d."nombre_direccion",
          d."Id_ciudad",
          ci."nombre_ciudad",
          ci."Id_parroquia",
          p."nombre_parroquia",
          p."Id_municipio",
          m."nombre_municipio",
          m."Id_estado",
          e."nombre_estado",
          e."Id_pais",
          pa."nombre_pais"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        LEFT JOIN "Direccion" d ON u."Id_direccion" = d."Id_direccion"
        LEFT JOIN "Ciudad" ci ON d."Id_ciudad" = ci."Id_ciudad"
        LEFT JOIN "Parroquia" p ON ci."Id_parroquia" = p."Id_parroquia"
        LEFT JOIN "Municipio" m ON p."Id_municipio" = m."Id_municipio"
        LEFT JOIN "Estado" e ON m."Id_estado" = e."Id_estado"
        LEFT JOIN "Pais" pa ON e."Id_pais" = pa."Id_pais"
        WHERE u."correo" = $1
      `,
      values: [email],
    };
    const { rows } = await db.query(query.text, query.values);
    const user = rows[0];
    if (user) {
      const userRoles = await getUserRoles(user.id);
      user.roles = userRoles.roles;
      user.roles_ids = userRoles.roles_ids;
    }
    return user;
  } catch (error) {
    console.error("Error in findOneByEmail:", error);
    throw error;
  }
};

// ============================================
// FIND ONE BY USERNAME
// ============================================
const findOneByUsername = async (username) => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."clave" as password,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."fecha_nacimiento",
          u."genero",
          u."foto_usuario",
          u."security_word",
          u."respuesta_de_seguridad",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."Id_direccion",
          u."password_reset_token",
          u."password_reset_expires",
          u."email_verification_token",
          u."last_login",
          u."creado_en" as created_at,
          u."actualizado_en" as updated_at,
          r."tipo_rol",
          d."nombre_direccion",
          d."Id_ciudad",
          ci."nombre_ciudad",
          ci."Id_parroquia",
          p."nombre_parroquia",
          p."Id_municipio",
          m."nombre_municipio",
          m."Id_estado",
          e."nombre_estado",
          e."Id_pais",
          pa."nombre_pais"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        LEFT JOIN "Direccion" d ON u."Id_direccion" = d."Id_direccion"
        LEFT JOIN "Ciudad" ci ON d."Id_ciudad" = ci."Id_ciudad"
        LEFT JOIN "Parroquia" p ON ci."Id_parroquia" = p."Id_parroquia"
        LEFT JOIN "Municipio" m ON p."Id_municipio" = m."Id_municipio"
        LEFT JOIN "Estado" e ON m."Id_estado" = e."Id_estado"
        LEFT JOIN "Pais" pa ON e."Id_pais" = pa."Id_pais"
        WHERE u."username" = $1 OR u."correo" = $1
      `,
      values: [username],
    };
    const { rows } = await db.query(query.text, query.values);
    const user = rows[0];
    if (user) {
      const userRoles = await getUserRoles(user.id);
      user.roles = userRoles.roles;
      user.roles_ids = userRoles.roles_ids;
    }
    return user;
  } catch (error) {
    console.error("Error in findOneByUsername:", error);
    throw error;
  }
};

// ============================================
// FIND ONE BY ID
// ============================================
const findOneById = async (id) => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."clave" as password,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."fecha_nacimiento",
          u."genero",
          u."foto_usuario",
          u."security_word",
          u."respuesta_de_seguridad",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."Id_direccion",
          u."password_reset_token",
          u."password_reset_expires",
          u."email_verification_token",
          u."last_login",
          u."creado_en" as created_at,
          u."actualizado_en" as updated_at,
          r."tipo_rol",
          d."nombre_direccion",
          d."Id_ciudad",
          ci."nombre_ciudad",
          ci."Id_parroquia",
          p."nombre_parroquia",
          p."Id_municipio",
          m."nombre_municipio",
          m."Id_estado",
          e."nombre_estado",
          e."Id_pais",
          pa."nombre_pais"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        LEFT JOIN "Direccion" d ON u."Id_direccion" = d."Id_direccion"
        LEFT JOIN "Ciudad" ci ON d."Id_ciudad" = ci."Id_ciudad"
        LEFT JOIN "Parroquia" p ON ci."Id_parroquia" = p."Id_parroquia"
        LEFT JOIN "Municipio" m ON p."Id_municipio" = m."Id_municipio"
        LEFT JOIN "Estado" e ON m."Id_estado" = e."Id_estado"
        LEFT JOIN "Pais" pa ON e."Id_pais" = pa."Id_pais"
        WHERE u."Id_usuario" = $1
      `,
      values: [id],
    };
    const { rows } = await db.query(query.text, query.values);
    const user = rows[0];
    if (user) {
      const userRoles = await getUserRoles(user.id);
      user.roles = userRoles.roles;
      user.roles_ids = userRoles.roles_ids;
    }
    return user;
  } catch (error) {
    console.error("Error in findOneById:", error);
    throw error;
  }
};

// ============================================
// FIND ALL USERS
// ============================================
const findAll = async () => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."fecha_nacimiento",
          u."genero",
          u."foto_usuario",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."Id_direccion",
          u."creado_en" as created_at,
          u."last_login",
          r."tipo_rol",
          d."nombre_direccion",
          ci."nombre_ciudad"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        LEFT JOIN "Direccion" d ON u."Id_direccion" = d."Id_direccion"
        LEFT JOIN "Ciudad" ci ON d."Id_ciudad" = ci."Id_ciudad"
        ORDER BY u."Id_usuario"
      `,
    };
    const { rows } = await db.query(query.text);
    return rows;
  } catch (error) {
    console.error("Error in findAll users:", error);
    throw error;
  }
};

// ============================================
// UPDATE PASSWORD
// ============================================
const updatePassword = async (id, hashedPassword) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "clave" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email,
          "nombre",
          "apellido"
      `,
      values: [hashedPassword, id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in updatePassword:", error);
    throw error;
  }
};

// ============================================
// UPDATE PROFILE
// ============================================
const updateProfile = async (id, { 
  email, security_word, respuesta_de_seguridad, 
  nombre, apellido, telefono, cedula,
  fecha_nacimiento, genero, foto_usuario, Id_direccion 
}) => {
  try {
    const formattedNombre = nombre !== undefined ? capitalizeWords(nombre) : undefined;
    const formattedApellido = apellido !== undefined ? capitalizeWords(apellido) : undefined;

    const query = {
      text: `
        UPDATE "Usuario"
        SET 
          "correo" = COALESCE($1, "correo"),
          "security_word" = COALESCE($2, "security_word"),
          "respuesta_de_seguridad" = COALESCE($3, "respuesta_de_seguridad"),
          "nombre" = COALESCE($4, "nombre"),
          "apellido" = COALESCE($5, "apellido"),
          "telefono" = COALESCE($6, "telefono"),
          "cedula" = COALESCE($7, "cedula"),
          "fecha_nacimiento" = COALESCE($8, "fecha_nacimiento"),
          "genero" = COALESCE($9, "genero"),
          "foto_usuario" = COALESCE($10, "foto_usuario"),
          "Id_direccion" = COALESCE($11, "Id_direccion"),
          "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $12
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email, 
          "security_word", 
          "nombre", 
          "apellido", 
          "telefono",
          "cedula",
          "fecha_nacimiento",
          "genero",
          "foto_usuario",
          "Id_direccion"
      `,
      values: [email, security_word, respuesta_de_seguridad, formattedNombre, formattedApellido, 
               telefono, cedula, fecha_nacimiento, genero, foto_usuario, 
               Id_direccion, id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in updateProfile:", error);
    throw error;
  }
};

// ============================================
// UPDATE LAST LOGIN
// ============================================
const updateLastLogin = async (id) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "last_login" = CURRENT_TIMESTAMP,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $1
      `,
      values: [id],
    };
    await db.query(query.text, query.values);
  } catch (error) {
    console.error("Error in updateLastLogin:", error);
  }
};

// ============================================
// SET PASSWORD RESET TOKEN
// ============================================
const setPasswordResetToken = async (userId, token) => {
  try {
    const expires = new Date(Date.now() + 60 * 60 * 1000);
    const query = {
      text: `
        UPDATE "Usuario"
        SET "password_reset_token" = $1,
            "password_reset_expires" = $2,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $3
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email,
          "nombre",
          "apellido"
      `,
      values: [token, expires, userId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in setPasswordResetToken:", error);
    throw error;
  }
};

// ============================================
// FIND BY PASSWORD RESET TOKEN
// ============================================
const findByPasswordResetToken = async (token) => {
  try {
    const query = {
      text: `
        SELECT * FROM "Usuario"
        WHERE "password_reset_token" = $1
        AND "password_reset_expires" > CURRENT_TIMESTAMP
      `,
      values: [token],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in findByPasswordResetToken:", error);
    throw error;
  }
};

// ============================================
// CLEAR PASSWORD RESET TOKEN
// ============================================
const clearPasswordResetToken = async (id) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "password_reset_token" = NULL,
            "password_reset_expires" = NULL,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $1
      `,
      values: [id],
    };
    await db.query(query.text, query.values);
  } catch (error) {
    console.error("Error in clearPasswordResetToken:", error);
    throw error;
  }
};

// ============================================
// SET ACTIVE/INACTIVE
// ============================================
const setActive = async (id, isActive) => {
  try {
    const status = isActive ? 'activo' : 'inactivo';
    const query = {
      text: `
        UPDATE "Usuario"
        SET "estatus_usuario" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email, 
          "estatus_usuario" as is_active,
          "nombre",
          "apellido"
      `,
      values: [status.toLowerCase(), id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in setActive:", error);
    throw error;
  }
};

// ============================================
// FIND BY CEDULA
// ============================================
const findByCedula = async (cedula) => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."clave" as password,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."fecha_nacimiento",
          u."genero",
          u."foto_usuario",
          u."security_word",
          u."respuesta_de_seguridad",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."Id_direccion",
          u."password_reset_token",
          u."password_reset_expires",
          u."email_verification_token",
          u."last_login",
          u."creado_en" as created_at,
          u."actualizado_en" as updated_at,
          r."tipo_rol"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        WHERE u."cedula" = $1
      `,
      values: [cedula],
    };
    const { rows } = await db.query(query.text, query.values);
    if (rows[0]) {
      const userRoles = await getUserRoles(rows[0].id);
      rows[0].roles = userRoles.roles;
      rows[0].roles_ids = userRoles.roles_ids;
    }
    return rows[0];
  } catch (error) {
    console.error("Error in findByCedula:", error);
    throw error;
  }
};

// ============================================
// SEARCH BY USERNAME
// ============================================
const searchByUsername = async (searchTerm) => {
  try {
    const query = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          COALESCE(u."username", u."correo") as username,
          u."correo" as email,
          u."nombre",
          u."apellido",
          u."cedula",
          u."telefono",
          u."estatus_usuario" as is_active,
          u."email_verified",
          u."Id_rol",
          u."creado_en" as created_at,
          u."last_login",
          r."tipo_rol"
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        WHERE u."username" ILIKE $1 
           OR u."correo" ILIKE $1 
           OR u."nombre" ILIKE $1 
           OR u."apellido" ILIKE $1
           OR u."cedula" ILIKE $1
        ORDER BY u."Id_usuario"
      `,
      values: [`%${searchTerm}%`],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows;
  } catch (error) {
    console.error("Error in searchByUsername:", error);
    throw error;
  }
};

// ============================================
// SEARCH CANDIDATES FOR DOCENTE ROLE (REPRESENTANTES / ESTUDIANTES)
// ============================================
const searchDocenteCandidates = async (searchTerm) => {
  try {
    const raw = (searchTerm || '').trim();
    const term = `%${raw}%`;
    const numOnly = raw.replace(/[^0-9]/g, '');
    const numTerm = numOnly ? `%${numOnly}%` : term;
    
    // 1. Buscar en Usuario (Representantes, Estudiantes, etc. que no sean profesores todavía)
    const userQuery = {
      text: `
        SELECT 
          u."Id_usuario" as id,
          NULL::integer as student_id,
          u."nombre" as first_name,
          u."apellido" as last_name,
          u."cedula" as dni,
          u."correo" as email,
          u."telefono" as phone,
          u."estatus_usuario" as status,
          r."tipo_rol" as role_name,
          CASE 
            WHEN rep."Id_representante" IS NOT NULL THEN 'representante'
            WHEN u."Id_rol" = 4 THEN 'representante'
            WHEN u."Id_rol" = 3 THEN 'estudiante'
            ELSE 'usuario'
          END as source_type
        FROM "Usuario" u
        LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol"
        LEFT JOIN "Representante" rep ON rep."Id_usuario" = u."Id_usuario"
        WHERE (
          u."nombre" ILIKE $1 
          OR u."apellido" ILIKE $1 
          OR u."cedula" ILIKE $1 
          OR u."cedula" ILIKE $2
          OR u."correo" ILIKE $1
        )
        AND u."Id_rol" != 2
        AND u."Id_usuario" NOT IN (
          SELECT "Id_usuario" FROM "Profesor" WHERE "Id_usuario" IS NOT NULL
        )
        AND u."Id_usuario" NOT IN (
          SELECT "Id_usuario" FROM "Usuario_Rol" WHERE "Id_rol" = 2
        )
        ORDER BY u."nombre" ASC
        LIMIT 10
      `,
      values: [term, numTerm]
    };
    
    const userResults = await db.query(userQuery.text, userQuery.values);
    
    // 2. Buscar en Estudiante (para estudiantes que no tengan cuenta de Usuario todavía)
    const existingDnis = userResults.rows.map(r => r.dni).filter(Boolean);
    let studentResults = { rows: [] };
    
    if (existingDnis.length > 0) {
      const placeholders = existingDnis.map((_, i) => `$${i + 3}`).join(',');
      const studentQuery = {
        text: `
          SELECT 
            NULL::integer as id,
            e."Id_estudiante" as student_id,
            e."nombre" as first_name,
            e."apellido" as last_name,
            e."cedula" as dni,
            NULL as email,
            NULL as phone,
            'activo' as status,
            'estudiante' as role_name,
            'estudiante' as source_type
          FROM "Estudiante" e
          WHERE (
            e."nombre" ILIKE $1 
            OR e."apellido" ILIKE $1 
            OR e."cedula" ILIKE $1
            OR e."cedula" ILIKE $2
          )
          AND e."cedula" NOT IN (${placeholders})
          ORDER BY e."nombre" ASC
          LIMIT 10
        `,
        values: [term, numTerm, ...existingDnis]
      };
      studentResults = await db.query(studentQuery.text, studentQuery.values);
    } else {
      const studentQuery = {
        text: `
          SELECT 
            NULL::integer as id,
            e."Id_estudiante" as student_id,
            e."nombre" as first_name,
            e."apellido" as last_name,
            e."cedula" as dni,
            NULL as email,
            NULL as phone,
            'activo' as status,
            'estudiante' as role_name,
            'estudiante' as source_type
          FROM "Estudiante" e
          WHERE (
            e."nombre" ILIKE $1 
            OR e."apellido" ILIKE $1 
            OR e."cedula" ILIKE $1
            OR e."cedula" ILIKE $2
          )
          ORDER BY e."nombre" ASC
          LIMIT 10
        `,
        values: [term, numTerm]
      };
      studentResults = await db.query(studentQuery.text, studentQuery.values);
    }
    
    return [...userResults.rows, ...studentResults.rows];
  } catch (error) {
    console.error("Error in searchDocenteCandidates:", error);
    throw error;
  }
};

// ============================================
// VERIFY SECURITY ANSWER
// ============================================
const verifySecurityAnswer = async (username, respuesta_de_seguridad) => {
  try {
    const query = {
      text: `
        SELECT 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email, 
          "security_word", 
          "respuesta_de_seguridad",
          "nombre",
          "apellido"
        FROM "Usuario"
        WHERE ("username" = $1 OR "correo" = $1) 
          AND "respuesta_de_seguridad" = $2
      `,
      values: [username, respuesta_de_seguridad],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in verifySecurityAnswer:", error);
    throw error;
  }
};

// ============================================
// UPDATE PROFILE WITH SECURITY
// ============================================
const updateProfileWithSecurity = async (
  id,
  { email, security_word, respuesta_de_seguridad, current_security_answer, 
    nombre, apellido, telefono, cedula, fecha_nacimiento, genero, foto_usuario, Id_direccion }
) => {
  try {
    const userQuery = {
      text: `SELECT "respuesta_de_seguridad" FROM "Usuario" WHERE "Id_usuario" = $1`,
      values: [id],
    };
    const userResult = await db.query(userQuery.text, userQuery.values);

    if (!userResult.rows[0] || userResult.rows[0].respuesta_de_seguridad !== current_security_answer) {
      throw new Error("Invalid security answer");
    }

    const formattedNombre = nombre !== undefined ? capitalizeWords(nombre) : undefined;
    const formattedApellido = apellido !== undefined ? capitalizeWords(apellido) : undefined;

    const query = {
      text: `
        UPDATE "Usuario"
        SET 
          "correo" = COALESCE($1, "correo"),
          "security_word" = COALESCE($2, "security_word"),
          "respuesta_de_seguridad" = COALESCE($3, "respuesta_de_seguridad"),
          "nombre" = COALESCE($4, "nombre"),
          "apellido" = COALESCE($5, "apellido"),
          "telefono" = COALESCE($6, "telefono"),
          "cedula" = COALESCE($7, "cedula"),
          "fecha_nacimiento" = COALESCE($8, "fecha_nacimiento"),
          "genero" = COALESCE($9, "genero"),
          "foto_usuario" = COALESCE($10, "foto_usuario"),
          "Id_direccion" = COALESCE($11, "Id_direccion"),
          "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $12
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email, 
          "security_word",
          "nombre", 
          "apellido", 
          "telefono",
          "cedula",
          "fecha_nacimiento",
          "genero",
          "Id_direccion"
      `,
      values: [email, security_word, respuesta_de_seguridad, formattedNombre, formattedApellido, 
               telefono, cedula, fecha_nacimiento, genero, foto_usuario, 
               Id_direccion, id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in updateProfileWithSecurity:", error);
    throw error;
  }
};

// ============================================
// CHANGE PASSWORD WITH SECURITY
// ============================================
const changePasswordWithSecurity = async (username, respuesta_de_seguridad, newPassword) => {
  try {
    const user = await verifySecurityAnswer(username, respuesta_de_seguridad);
    if (!user) {
      throw new Error("Invalid username or security answer");
    }

    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(newPassword, salt);

    const query = {
      text: `
        UPDATE "Usuario"
        SET "clave" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email,
          "nombre",
          "apellido"
      `,
      values: [hashedPassword, user.id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in changePasswordWithSecurity:", error);
    throw error;
  }
};

// ============================================
// SET EMAIL VERIFICATION TOKEN
// ============================================
const setEmailVerificationToken = async (id, token) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "email_verification_token" = $1,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "Id_usuario" = $2
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email,
          "nombre",
          "apellido"
      `,
      values: [token, id],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in setEmailVerificationToken:", error);
    throw error;
  }
};

// ============================================
// VERIFY EMAIL
// ============================================
const verifyEmail = async (token) => {
  try {
    const query = {
      text: `
        UPDATE "Usuario"
        SET "email_verified" = true,
            "email_verification_token" = NULL,
            "actualizado_en" = CURRENT_TIMESTAMP
        WHERE "email_verification_token" = $1
        RETURNING 
          "Id_usuario" as id, 
          COALESCE("username", "correo") as username, 
          "correo" as email, 
          "email_verified",
          "nombre",
          "apellido"
      `,
      values: [token],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in verifyEmail:", error);
    throw error;
  }
};

// ============================================
// IS PROFESOR - CORREGIDO (SIN COMENTARIOS DENTRO DEL SQL)
// ============================================
const isProfesor = async (usuarioId) => {
  try {
    const query = {
      text: `
        SELECT p."Id_profesor", p."especialidad"
        FROM "Profesor" p
        WHERE p."Id_usuario" = $1
      `,
      values: [usuarioId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in isProfesor:", error);
    throw error;
  }
};

// ============================================
// IS REPRESENTANTE - CORREGIDO
// ============================================
const isRepresentante = async (usuarioId) => {
  try {
    const query = {
      text: `
        SELECT r."Id_representante", r."es_familiar", r."profesion_rep", r."direccion_trabajo_rep"
        FROM "Representante" r
        WHERE r."Id_usuario" = $1
      `,
      values: [usuarioId],
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("Error in isRepresentante:", error);
    throw error;
  }
};

// ============================================
// OBTENER ROLES MULTIPLES DEL USUARIO
// ============================================
const getUserRoles = async (usuarioId) => {
  try {
    const res = await db.query(`
      SELECT DISTINCT r."Id_rol", LOWER(r."tipo_rol") as rol_nombre
      FROM "Usuario_Rol" ur
      JOIN "Rol" r ON ur."Id_rol" = r."Id_rol"
      WHERE ur."Id_usuario" = $1
    `, [usuarioId]);

    let roles = res.rows.map(r => {
      const name = r.rol_nombre;
      return name === 'administrador' ? 'admin' : name;
    });
    let roles_ids = res.rows.map(r => r.Id_rol);

    // Verificar si está registrado en Profesor
    const isProf = await isProfesor(usuarioId);
    if (isProf && !roles.includes('docente')) {
      roles.push('docente');
      roles_ids.push(2);
    }

    // Verificar si está registrado en Representante
    const isRep = await isRepresentante(usuarioId);
    if (isRep && !roles.includes('representante')) {
      roles.push('representante');
      roles_ids.push(4);
    }

    // Si aún no tiene roles detectados, consultar el Id_rol de Usuario
    if (roles.length === 0) {
      const uRes = await db.query('SELECT u."Id_rol", LOWER(r."tipo_rol") as rol_nombre FROM "Usuario" u LEFT JOIN "Rol" r ON u."Id_rol" = r."Id_rol" WHERE u."Id_usuario" = $1', [usuarioId]);
      if (uRes.rows.length > 0 && uRes.rows[0].rol_nombre) {
        roles.push(uRes.rows[0].rol_nombre);
        roles_ids.push(uRes.rows[0].Id_rol);
      }
    }

    return { roles, roles_ids };
  } catch (error) {
    console.error("Error in getUserRoles:", error);
    return { roles: [], roles_ids: [] };
  }
};

// ============================================
// AGREGAR ROL A USUARIO (M:N)
// ============================================
const addRoleToUser = async (usuarioId, roleId) => {
  try {
    await db.query(`
      INSERT INTO "Usuario_Rol" ("Id_usuario", "Id_rol")
      VALUES ($1, $2)
      ON CONFLICT DO NOTHING
    `, [usuarioId, roleId]);
    return true;
  } catch (error) {
    console.error("Error in addRoleToUser:", error);
    return false;
  }
};

// ============================================
// EXPORTAR TODOS LOS MÉTODOS
// ============================================
export const UserModel = {
  create,
  findOneByUsername,
  findOneById,
  findById: findOneById,
  findOneByEmail,
  findAll,
  updatePassword,
  updateProfile,
  updateProfileWithSecurity,
  changePasswordWithSecurity,
  updateLastLogin,
  setPasswordResetToken,
  findByPasswordResetToken,
  clearPasswordResetToken,
  setActive,
  remove,
  removeProfesorCompleto,
  findByCedula,
  searchByUsername,
  searchDocenteCandidates,
  verifySecurityAnswer,
  setEmailVerificationToken,
  verifyEmail,
  isProfesor,
  isRepresentante,
  getUserRoles,
  addRoleToUser,
  createProfesor,
  updateUserByAdmin,
  updateUserRole,
  migratePasswordToHash,
  migrateAllPasswords
};