import { db } from "../db/connection.database.js";
import bcryptjs from "bcryptjs";
import { capitalizeWords } from "../utils/formatters.js";

// ============================================
// FORMATTER: Convierte fila de BD al objeto User estándar
// ============================================
export const formatUserResponse = (row) => {
  if (!row) return null;

  const roleType = row.tipo_rol || 'estudiante';
  const roleName = roleType === 'administrador' ? 'admin' : roleType;

  let roles = [];
  let rolesIds = [];
  if (Array.isArray(row.roles_asignados) && row.roles_asignados.length > 0) {
    roles = row.roles_asignados.map(r => r.tipo_rol === 'administrador' ? 'admin' : r.tipo_rol);
    rolesIds = row.roles_asignados.map(r => r.id_rol);
  } else {
    roles = [roleName];
    rolesIds = [row.id_rol || 5];
  }

  // Asegurar que el rol principal esté en la lista
  if (!roles.includes(roleName)) {
    roles.unshift(roleName);
  }
  if (row.id_rol && !rolesIds.includes(row.id_rol)) {
    rolesIds.unshift(row.id_rol);
  }

  const fullName = [row.nombre, row.segundo_nombre, row.apellido, row.segundo_apellido]
    .filter(Boolean)
    .join(' ');

  const mustChangeCedula = !row.cedula || 
    String(row.cedula).trim() === '' || 
    String(row.cedula).toUpperCase().startsWith('V-1000');

  return {
    id: row.id_usuario,
    id_usuario: row.id_usuario,
    id_persona: row.id_persona,
    username: row.email || row.cedula,
    email: row.email,
    correo: row.email,
    nombre: row.nombre,
    segundo_nombre: row.segundo_nombre,
    apellido: row.apellido,
    segundo_apellido: row.segundo_apellido,
    full_name: fullName,
    first_name: row.nombre,
    last_name: row.apellido,
    dni: row.cedula,
    status: row.estado_usuario === 'activo' ? 'active' : 'inactive',
    cedula: row.cedula,
    telefono: row.telefono || row.numero_telefono,
    numero_telefono: row.telefono || row.numero_telefono,
    fecha_nacimiento: row.fecha_nacimiento,
    genero: row.genero,
    foto_usuario: row.foto_usuario,
    id_rol: row.id_rol,
    Id_rol: row.id_rol,
    tipo_rol: roleType,
    rol: roleName,
    role: roleName,
    roles,
    roles_ids: rolesIds,
    estado_usuario: row.estado_usuario,
    is_active: row.estado_usuario === 'activo',
    id_direccion: row.id_direccion,
    direccion: row.direccion,
    must_change_cedula: mustChangeCedula,
    id_docente: row.id_docente || null,
    Id_profesor: row.id_docente || null,
    id_representante: row.id_representante || null,
    Id_representante: row.id_representante || null,
    id_estudiante: row.id_estudiante || null,
    created_at: row.created_at,
    updated_at: row.updated_at,
    // Credenciales para verificación interna
    password: row.contrasena,
    contrasena: row.contrasena
  };
};

// ============================================
// QUERY BASE PARA OBTENER USUARIOS
// ============================================
const BASE_USER_QUERY = `
  SELECT 
    u.id_usuario,
    u.contrasena,
    u.foto_usuario,
    u.estado_usuario,
    u.created_at,
    u.updated_at,
    u.id_rol,
    r.tipo_rol,
    u.id_direccion,
    d.direccion,
    u.id_persona,
    p.nombre,
    p.segundo_nombre,
    p.apellido,
    p.segundo_apellido,
    p.cedula,
    p.numero_telefono as telefono,
    p.email,
    p.fecha_nacimiento,
    p.genero,
    COALESCE(
      (SELECT json_agg(json_build_object('id_rol', ur.id_rol, 'tipo_rol', r2.tipo_rol))
       FROM usuario_rol ur
       JOIN rol r2 ON ur.id_rol = r2.id_rol
       WHERE ur.id_usuario = u.id_usuario),
      '[]'::json
    ) as roles_asignados,
    (SELECT d2.id_docente FROM docente d2 WHERE d2.id_usuario = u.id_usuario LIMIT 1) as id_docente,
    (SELECT rep.id_representante FROM representante rep WHERE rep.id_usuario = u.id_usuario OR rep.id_persona = u.id_persona LIMIT 1) as id_representante,
    (SELECT est.id_estudiante FROM estudiante est WHERE est.id_persona = u.id_persona LIMIT 1) as id_estudiante
  FROM usuario u
  JOIN persona p ON u.id_persona = p.id_persona
  LEFT JOIN rol r ON u.id_rol = r.id_rol
  LEFT JOIN direccion d ON u.id_direccion = d.id_direccion
`;

export const UserModel = {
  // ==========================================
  // BÚSQUEDAS
  // ==========================================
  findOneByEmail: async (email) => {
    try {
      const query = `${BASE_USER_QUERY} WHERE LOWER(TRIM(p.email)) = LOWER(TRIM($1)) OR TRIM(p.cedula) = TRIM($1) LIMIT 1`;
      const { rows } = await db.query(query, [email]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      console.error("❌ UserModel.findOneByEmail:", error);
      throw error;
    }
  },

  findByCedula: async (cedula) => {
    try {
      const cleanCedula = cedula.trim();
      const query = `${BASE_USER_QUERY} WHERE TRIM(p.cedula) = $1 OR TRIM(p.cedula) = $2 LIMIT 1`;
      const altCedula = cleanCedula.startsWith('V-') ? cleanCedula.substring(2) : `V-${cleanCedula}`;
      const { rows } = await db.query(query, [cleanCedula, altCedula]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      console.error("❌ UserModel.findByCedula:", error);
      throw error;
    }
  },

  findOneById: async (id) => {
    try {
      const query = `${BASE_USER_QUERY} WHERE u.id_usuario = $1 LIMIT 1`;
      const { rows } = await db.query(query, [id]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      console.error("❌ UserModel.findOneById:", error);
      throw error;
    }
  },

  findOneByPersonaId: async (personaId) => {
    try {
      const query = `${BASE_USER_QUERY} WHERE u.id_persona = $1 LIMIT 1`;
      const { rows } = await db.query(query, [personaId]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      console.error("❌ UserModel.findOneByPersonaId:", error);
      throw error;
    }
  },

  // ==========================================
  // LISTAR Y FILTRAR USUARIOS
  // ==========================================
  getAllUsers: async () => {
    try {
      const query = `${BASE_USER_QUERY} ORDER BY u.id_usuario ASC`;
      const { rows } = await db.query(query);
      return rows.map(formatUserResponse);
    } catch (error) {
      console.error("❌ UserModel.getAllUsers:", error);
      throw error;
    }
  },

  findUsersWithFilters: async ({ search, role, status } = {}) => {
    try {
      let conditions = [];
      let params = [];
      let paramIndex = 1;

      if (search && search.trim()) {
        params.push(`%${search.trim().toLowerCase()}%`);
        conditions.push(`(
          LOWER(p.nombre) LIKE $${paramIndex} OR
          LOWER(p.apellido) LIKE $${paramIndex} OR
          LOWER(p.cedula) LIKE $${paramIndex} OR
          LOWER(p.email) LIKE $${paramIndex}
        )`);
        paramIndex++;
      }

      if (role) {
        params.push(role);
        conditions.push(`(r.tipo_rol::text = $${paramIndex} OR $${paramIndex} = ANY(SELECT r2.tipo_rol::text FROM usuario_rol ur JOIN rol r2 ON ur.id_rol = r2.id_rol WHERE ur.id_usuario = u.id_usuario))`);
        paramIndex++;
      }

      if (status) {
        params.push(status);
        conditions.push(`u.estado_usuario = $${paramIndex}`);
        paramIndex++;
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(" AND ")}` : "";
      const query = `${BASE_USER_QUERY} ${whereClause} ORDER BY u.id_usuario DESC`;

      const { rows } = await db.query(query, params);
      return rows.map(formatUserResponse);
    } catch (error) {
      console.error("❌ UserModel.findUsersWithFilters:", error);
      throw error;
    }
  },

  // ==========================================
  // CREACIÓN DE USUARIO (TRANSACCIÓN)
  // ==========================================
  create: async (userData) => {
    const client = await db.pool.connect();
    try {
      await client.query('BEGIN');

      // Normalizar nombres y aliases que pueden venir del frontend
      const rawNombre = userData.nombre || userData.first_name || '';
      const rawSegundoNombre = userData.segundo_nombre || null;
      const rawApellido = userData.apellido || userData.last_name || '';
      const rawSegundoApellido = userData.segundo_apellido || null;

      let nombre = rawNombre;
      let segundo_nombre = rawSegundoNombre;
      if (!segundo_nombre && rawNombre.includes(' ')) {
        const parts = rawNombre.trim().split(/\s+/);
        nombre = parts[0];
        segundo_nombre = parts.slice(1).join(' ');
      }

      let apellido = rawApellido;
      let segundo_apellido = rawSegundoApellido;
      if (!segundo_apellido && rawApellido.includes(' ')) {
        const parts = rawApellido.trim().split(/\s+/);
        apellido = parts[0];
        segundo_apellido = parts.slice(1).join(' ');
      }

      const cedula = userData.cedula || userData.dni || null;
      const telefono = userData.telefono || userData.phone || userData.numero_telefono || null;
      const email = userData.email || userData.correo || null;
      const fecha_nacimiento = userData.fecha_nacimiento || null;
      const genero = userData.genero || null;
      const direccion = userData.direccion || null;
      const foto_usuario = userData.foto_usuario || null;

      // Mapear rol si viene en string
      const roleMapping = {
        'admin': 1,
        'administrador': 1,
        'superadmin': 1,
        'docente': 2,
        'profesor': 2,
        'secretaria': 3,
        'representante': 4,
        'estudiante': 5,
      };
      let id_rol = userData.id_rol;
      if (!id_rol && userData.role) {
        id_rol = roleMapping[String(userData.role).toLowerCase()] || 2;
      }
      id_rol = Number(id_rol || 2);

      // Mapear estado
      const statusMapping = {
        'active': 'activo',
        'activo': 'activo',
        'inactive': 'inactivo',
        'inactivo': 'inactivo',
        'suspended': 'suspendido',
        'suspendido': 'suspendido'
      };
      const rawStatus = userData.estado_usuario || userData.status || 'activo';
      const estado_usuario = statusMapping[String(rawStatus).toLowerCase()] || 'activo';

      // Password
      const rawPassword = userData.password || userData.contrasena || 'Endanza.2024';

      // 1. Crear dirección si se suministró
      let id_direccion = null;
      if (direccion && direccion.trim()) {
        const dirRes = await client.query(
          `INSERT INTO direccion (direccion) VALUES ($1) RETURNING id_direccion`,
          [direccion.trim()]
        );
        id_direccion = dirRes.rows[0].id_direccion;
      }

      // 2. Normalizar campos personales
      const nombreNorm = capitalizeWords(nombre?.trim() || '');
      const segNombreNorm = segundo_nombre ? capitalizeWords(segundo_nombre.trim()) : null;
      const apellidoNorm = capitalizeWords(apellido?.trim() || '');
      const segApellidoNorm = segundo_apellido ? capitalizeWords(segundo_apellido.trim()) : null;
      const cedulaNorm = cedula?.trim() || null;
      const emailNorm = email?.trim().toLowerCase() || null;
      const generoNorm = genero && ['masculino', 'femenino'].includes(genero.toLowerCase()) 
        ? genero.toLowerCase() 
        : null;

      // Verificar si ya existe un usuario con este correo o cédula
      if (emailNorm) {
        const uEmailExist = await client.query(
          `SELECT u.id_usuario FROM usuario u JOIN persona p ON u.id_persona = p.id_persona WHERE LOWER(TRIM(p.email)) = $1 LIMIT 1`,
          [emailNorm]
        );
        if (uEmailExist.rows.length > 0) {
          throw new Error(`Ya existe un usuario con el correo electrónico "${emailNorm}"`);
        }
      }

      if (cedulaNorm) {
        const cleanCed = cedulaNorm.replace(/^V-/i, '').trim();
        const uCedExist = await client.query(
          `SELECT u.id_usuario FROM usuario u JOIN persona p ON u.id_persona = p.id_persona WHERE REPLACE(UPPER(TRIM(p.cedula)), 'V-', '') = $1 LIMIT 1`,
          [cleanCed]
        );
        if (uCedExist.rows.length > 0) {
          throw new Error(`Ya existe un usuario registrado con la cédula "${cedulaNorm}"`);
        }
      }

      // 3. Crear o actualizar persona
      let id_persona = null;
      if (cedulaNorm) {
        const cleanCed = cedulaNorm.replace(/^V-/i, '').trim();
        const pExist = await client.query(
          `SELECT id_persona FROM persona WHERE REPLACE(UPPER(TRIM(cedula)), 'V-', '') = $1 LIMIT 1`,
          [cleanCed]
        );
        if (pExist.rows.length > 0) {
          id_persona = pExist.rows[0].id_persona;
          await client.query(`
            UPDATE persona SET
              nombre = COALESCE(NULLIF($1, ''), nombre),
              segundo_nombre = COALESCE($2, segundo_nombre),
              apellido = COALESCE(NULLIF($3, ''), apellido),
              segundo_apellido = COALESCE($4, segundo_apellido),
              numero_telefono = COALESCE($5, numero_telefono),
              email = COALESCE($6, email),
              fecha_nacimiento = COALESCE($7, fecha_nacimiento),
              genero = COALESCE($8, genero)
            WHERE id_persona = $9
          `, [nombreNorm, segNombreNorm, apellidoNorm, segApellidoNorm, telefono, emailNorm, fecha_nacimiento, generoNorm, id_persona]);
        }
      }

      if (!id_persona) {
        const pRes = await client.query(`
          INSERT INTO persona (
            nombre, segundo_nombre, apellido, segundo_apellido,
            cedula, numero_telefono, email, fecha_nacimiento, genero
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
          RETURNING id_persona
        `, [nombreNorm, segNombreNorm, apellidoNorm, segApellidoNorm, cedulaNorm, telefono, emailNorm, fecha_nacimiento, generoNorm]);
        id_persona = pRes.rows[0].id_persona;
      }

      // 4. Hashear password
      const hashedPassword = rawPassword.startsWith('$2') 
        ? rawPassword 
        : await bcryptjs.hash(rawPassword, 10);

      // 5. Crear usuario
      const uRes = await client.query(`
        INSERT INTO usuario (
          contrasena, foto_usuario, estado_usuario, id_rol, id_direccion, id_persona
        ) VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id_usuario
      `, [hashedPassword, foto_usuario, estado_usuario, id_rol, id_direccion, id_persona]);

      const id_usuario = uRes.rows[0].id_usuario;

      // 6. Asignar rol en usuario_rol
      await client.query(`
        INSERT INTO usuario_rol (id_usuario, id_rol)
        VALUES ($1, $2)
        ON CONFLICT (id_usuario, id_rol) DO NOTHING
      `, [id_usuario, id_rol]);

      // 7. Si es docente (id_rol = 2), registrar en tabla docente si no existe
      if (Number(id_rol) === 2) {
        const docExist = await client.query(`SELECT id_docente FROM docente WHERE id_usuario = $1 LIMIT 1`, [id_usuario]);
        if (docExist.rows.length === 0) {
          await client.query(`INSERT INTO docente (id_usuario) VALUES ($1)`, [id_usuario]);
        }
      }

      // 8. Si es representante (id_rol = 4), registrar en tabla representante
      if (Number(id_rol) === 4) {
        await client.query(`
          INSERT INTO representante (id_persona, id_usuario)
          VALUES ($1, $2)
          ON CONFLICT DO NOTHING
        `, [id_persona, id_usuario]);
      }

      await client.query('COMMIT');

      // 9. Devolver usuario recién creado
      const { rows } = await db.query(`${BASE_USER_QUERY} WHERE u.id_usuario = $1`, [id_usuario]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      await client.query('ROLLBACK');
      console.error("❌ UserModel.create error:", error);
      throw error;
    } finally {
      client.release();
    }
  },

  update: async (userId, updateData) => {
    const client = await db.pool.connect();
    try {
      await client.query('BEGIN');

      // Obtener usuario actual
      const currentRes = await client.query(
        `SELECT id_persona, id_direccion, id_rol FROM usuario WHERE id_usuario = $1`,
        [userId]
      );
      if (currentRes.rows.length === 0) {
        throw new Error("Usuario no encontrado");
      }
      const { id_persona, id_direccion, id_rol: currentRol } = currentRes.rows[0];

      // Normalizar campos recibidos
      const rawNombre = updateData.nombre || updateData.first_name;
      const rawSegundoNombre = updateData.segundo_nombre;
      let nombre = rawNombre ? capitalizeWords(rawNombre.trim()) : null;
      let segundo_nombre = rawSegundoNombre ? capitalizeWords(rawSegundoNombre.trim()) : null;
      if (rawNombre && !segundo_nombre && rawNombre.includes(' ')) {
        const parts = rawNombre.trim().split(/\s+/);
        nombre = capitalizeWords(parts[0]);
        segundo_nombre = capitalizeWords(parts.slice(1).join(' '));
      }

      const rawApellido = updateData.apellido || updateData.last_name;
      const rawSegundoApellido = updateData.segundo_apellido;
      let apellido = rawApellido ? capitalizeWords(rawApellido.trim()) : null;
      let segundo_apellido = rawSegundoApellido ? capitalizeWords(rawSegundoApellido.trim()) : null;
      if (rawApellido && !segundo_apellido && rawApellido.includes(' ')) {
        const parts = rawApellido.trim().split(/\s+/);
        apellido = capitalizeWords(parts[0]);
        segundo_apellido = capitalizeWords(parts.slice(1).join(' '));
      }

      const cedula = updateData.cedula || updateData.dni ? (updateData.cedula || updateData.dni).trim() : null;
      const telefono = updateData.telefono || updateData.phone || updateData.numero_telefono || null;
      const email = updateData.email || updateData.correo ? (updateData.email || updateData.correo).trim().toLowerCase() : null;
      const fecha_nacimiento = updateData.fecha_nacimiento || null;
      const genero = updateData.genero && ['masculino', 'femenino'].includes(updateData.genero.toLowerCase())
        ? updateData.genero.toLowerCase()
        : null;

      // Actualizar datos de persona
      if (id_persona) {
        await client.query(`
          UPDATE persona SET
            nombre = COALESCE($1, nombre),
            segundo_nombre = COALESCE($2, segundo_nombre),
            apellido = COALESCE($3, apellido),
            segundo_apellido = COALESCE($4, segundo_apellido),
            cedula = COALESCE($5, cedula),
            numero_telefono = COALESCE($6, numero_telefono),
            email = COALESCE($7, email),
            fecha_nacimiento = COALESCE($8, fecha_nacimiento),
            genero = COALESCE($9, genero)
          WHERE id_persona = $10
        `, [nombre, segundo_nombre, apellido, segundo_apellido, cedula, telefono, email, fecha_nacimiento, genero, id_persona]);
      }

      // Actualizar dirección
      if (updateData.direccion) {
        if (id_direccion) {
          await client.query(`UPDATE direccion SET direccion = $1 WHERE id_direccion = $2`, [updateData.direccion.trim(), id_direccion]);
        } else {
          const dirRes = await client.query(`INSERT INTO direccion (direccion) VALUES ($1) RETURNING id_direccion`, [updateData.direccion.trim()]);
          await client.query(`UPDATE usuario SET id_direccion = $1 WHERE id_usuario = $2`, [dirRes.rows[0].id_direccion, userId]);
        }
      }

      // Actualizar usuario
      const updates = [];
      const values = [];
      let valIdx = 1;

      if (updateData.foto_usuario !== undefined) {
        updates.push(`foto_usuario = $${valIdx++}`);
        values.push(updateData.foto_usuario);
      }

      const statusMapping = {
        'active': 'activo',
        'activo': 'activo',
        'inactive': 'inactivo',
        'inactivo': 'inactivo',
        'suspended': 'suspendido',
        'suspendido': 'suspendido'
      };
      const rawStatus = updateData.estado_usuario || updateData.status;
      if (rawStatus) {
        const estado_usuario = statusMapping[String(rawStatus).toLowerCase()] || 'activo';
        updates.push(`estado_usuario = $${valIdx++}`);
        values.push(estado_usuario);
      }

      // Rol
      const roleMapping = {
        'admin': 1,
        'administrador': 1,
        'superadmin': 1,
        'docente': 2,
        'profesor': 2,
        'secretaria': 3,
        'representante': 4,
        'estudiante': 5,
      };
      let targetRolId = updateData.id_rol;
      if (!targetRolId && updateData.role) {
        targetRolId = roleMapping[String(updateData.role).toLowerCase()];
      }

      if (targetRolId) {
        updates.push(`id_rol = $${valIdx++}`);
        values.push(targetRolId);

        // Actualizar tabla usuario_rol
        await client.query(`
          INSERT INTO usuario_rol (id_usuario, id_rol)
          VALUES ($1, $2)
          ON CONFLICT (id_usuario, id_rol) DO NOTHING
        `, [userId, targetRolId]);

        if (Number(targetRolId) === 2) {
          const docExist = await client.query(`SELECT id_docente FROM docente WHERE id_usuario = $1 LIMIT 1`, [userId]);
          if (docExist.rows.length === 0) {
            await client.query(`INSERT INTO docente (id_usuario) VALUES ($1)`, [userId]);
          }
        }
        if (Number(targetRolId) === 4 && id_persona) {
          await client.query(`INSERT INTO representante (id_persona, id_usuario) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [id_persona, userId]);
        }
      }

      // Contraseña si se envió
      const newPass = updateData.password || updateData.contrasena;
      if (newPass && String(newPass).trim().length >= 4) {
        const hashed = newPass.startsWith('$2') ? newPass : await bcryptjs.hash(newPass.trim(), 10);
        updates.push(`contrasena = $${valIdx++}`);
        values.push(hashed);
      }

      if (updates.length > 0) {
        updates.push(`updated_at = CURRENT_TIMESTAMP`);
        values.push(userId);
        await client.query(`
          UPDATE usuario SET ${updates.join(', ')} WHERE id_usuario = $${valIdx}
        `, values);
      }

      await client.query('COMMIT');

      const { rows } = await db.query(`${BASE_USER_QUERY} WHERE u.id_usuario = $1`, [userId]);
      return formatUserResponse(rows[0]);
    } catch (error) {
      await client.query('ROLLBACK');
      console.error("❌ UserModel.update error:", error);
      throw error;
    } finally {
      client.release();
    }
  },

  // ==========================================
  // CONTRASEÑAS & SESIÓN
  // ==========================================
  migratePasswordToHash: async (userId, plainPassword) => {
    try {
      const salt = await bcryptjs.genSalt(10);
      const hashedPassword = await bcryptjs.hash(plainPassword, salt);
      await db.query(`
        UPDATE usuario SET contrasena = $1, updated_at = CURRENT_TIMESTAMP WHERE id_usuario = $2
      `, [hashedPassword, userId]);
      return hashedPassword;
    } catch (error) {
      console.error("❌ UserModel.migratePasswordToHash error:", error);
      throw error;
    }
  },

  changePassword: async (userId, newPassword) => {
    try {
      const salt = await bcryptjs.genSalt(10);
      const hashedPassword = await bcryptjs.hash(newPassword, salt);
      await db.query(`
        UPDATE usuario SET contrasena = $1, updated_at = CURRENT_TIMESTAMP WHERE id_usuario = $2
      `, [hashedPassword, userId]);
      return true;
    } catch (error) {
      console.error("❌ UserModel.changePassword error:", error);
      throw error;
    }
  },

  updateLastLogin: async (userId) => {
    try {
      await db.query(`UPDATE usuario SET updated_at = CURRENT_TIMESTAMP WHERE id_usuario = $1`, [userId]);
      return true;
    } catch (error) {
      console.error("❌ UserModel.updateLastLogin error:", error);
      return false;
    }
  },

  // ==========================================
  // ESTADO Y ROLES
  // ==========================================
  setUserStatus: async (userId, status) => {
    try {
      const validStatuses = ['activo', 'inactivo', 'suspendido'];
      const st = validStatuses.includes(status) ? status : (status === 'active' ? 'activo' : 'inactivo');
      await db.query(`UPDATE usuario SET estado_usuario = $1, updated_at = CURRENT_TIMESTAMP WHERE id_usuario = $2`, [st, userId]);
      return true;
    } catch (error) {
      console.error("❌ UserModel.setUserStatus error:", error);
      throw error;
    }
  },

  assignRole: async (userId, id_rol) => {
    const client = await db.pool.connect();
    try {
      await client.query('BEGIN');
      await client.query(`
        INSERT INTO usuario_rol (id_usuario, id_rol)
        VALUES ($1, $2)
        ON CONFLICT (id_usuario, id_rol) DO NOTHING
      `, [userId, id_rol]);

      if (Number(id_rol) === 2) {
        await client.query(`INSERT INTO docente (id_usuario) VALUES ($1) ON CONFLICT DO NOTHING`, [userId]);
      } else if (Number(id_rol) === 4) {
        const u = await client.query(`SELECT id_persona FROM usuario WHERE id_usuario = $1`, [userId]);
        if (u.rows.length > 0) {
          await client.query(`INSERT INTO representante (id_persona, id_usuario) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [u.rows[0].id_persona, userId]);
        }
      }

      await client.query('COMMIT');
      return true;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error("❌ UserModel.assignRole error:", error);
      throw error;
    } finally {
      client.release();
    }
  },

  isProfesor: async (userId) => {
    try {
      const { rows } = await db.query(`SELECT id_docente FROM docente WHERE id_usuario = $1 LIMIT 1`, [userId]);
      return rows.length > 0 ? { Id_profesor: rows[0].id_docente, id_docente: rows[0].id_docente } : null;
    } catch (error) {
      console.error("❌ UserModel.isProfesor error:", error);
      return null;
    }
  },

  isRepresentante: async (userId) => {
    try {
      const { rows } = await db.query(`
        SELECT rep.id_representante 
        FROM representante rep 
        WHERE rep.id_usuario = $1 
           OR rep.id_persona = (SELECT id_persona FROM usuario WHERE id_usuario = $1)
        LIMIT 1
      `, [userId]);
      return rows.length > 0 ? { Id_representante: rows[0].id_representante, id_representante: rows[0].id_representante } : null;
    } catch (error) {
      console.error("❌ UserModel.isRepresentante error:", error);
      return null;
    }
  },

  deleteUser: async (userId) => {
    const client = await db.pool.connect();
    try {
      await client.query('BEGIN');

      // 1. Verificar existencia del usuario
      const uRes = await client.query(`SELECT id_usuario, id_persona, id_rol FROM usuario WHERE id_usuario = $1`, [userId]);
      if (uRes.rows.length === 0) {
        throw new Error("Usuario no encontrado");
      }
      const user = uRes.rows[0];

      // Proteger al administrador principal (id_usuario = 2 o único admin)
      if (Number(userId) === 2 || user.id_rol === 1) {
        const adminCount = await client.query(`SELECT COUNT(*) FROM usuario WHERE id_rol = 1 AND estado_usuario = 'activo'`);
        if (Number(adminCount.rows[0].count) <= 1) {
          throw new Error("No se puede eliminar al único administrador del sistema");
        }
      }

      // 2. Desvincular de docente y sus horarios si existiera
      await client.query(`
        UPDATE horario SET id_docente = NULL 
        WHERE id_docente IN (SELECT id_docente FROM docente WHERE id_usuario = $1)
      `, [userId]);

      await client.query(`
        UPDATE horario SET id_docente_auxiliar = NULL 
        WHERE id_docente_auxiliar IN (SELECT id_docente FROM docente WHERE id_usuario = $1)
      `, [userId]);

      await client.query(`DELETE FROM docente WHERE id_usuario = $1`, [userId]);

      // 3. Desvincular de otras tablas donde pueda estar como FK nullable
      await client.query(`UPDATE representante SET id_usuario = NULL WHERE id_usuario = $1`, [userId]);
      await client.query(`UPDATE incidencia SET id_usuario_involucrado = NULL WHERE id_usuario_involucrado = $1`, [userId]);
      await client.query(`UPDATE incidencia SET id_usuario_reporta = NULL WHERE id_usuario_reporta = $1`, [userId]);
      await client.query(`UPDATE revision_materia SET creado_por = NULL WHERE creado_por = $1`, [userId]);
      await client.query(`UPDATE acta_promocion SET creado_por = NULL WHERE creado_por = $1`, [userId]);

      // 4. Eliminar roles asignados
      await client.query(`DELETE FROM usuario_rol WHERE id_usuario = $1`, [userId]);

      // 5. Eliminar usuario
      await client.query(`DELETE FROM usuario WHERE id_usuario = $1`, [userId]);

      // 6. Si la persona asociada no tiene rol de estudiante, representante ni familiar de estudiante, eliminar la persona
      if (user.id_persona) {
        const inEst = await client.query(`SELECT COUNT(*) FROM estudiante WHERE id_persona = $1`, [user.id_persona]);
        const inRep = await client.query(`SELECT COUNT(*) FROM representante WHERE id_persona = $1`, [user.id_persona]);
        const inEf = await client.query(`SELECT COUNT(*) FROM estudiante_familiar WHERE id_persona = $1`, [user.id_persona]);
        const otherUsers = await client.query(`SELECT COUNT(*) FROM usuario WHERE id_persona = $1`, [user.id_persona]);

        if (Number(inEst.rows[0].count) === 0 && 
            Number(inRep.rows[0].count) === 0 && 
            Number(inEf.rows[0].count) === 0 && 
            Number(otherUsers.rows[0].count) === 0) {
          await client.query(`DELETE FROM persona WHERE id_persona = $1`, [user.id_persona]);
        }
      }

      await client.query('COMMIT');
      return true;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error("❌ UserModel.deleteUser error:", error);
      throw error;
    } finally {
      client.release();
    }
  },

  // ==========================================
  // DOCENTES
  // ==========================================
  getDocentes: async () => {
    try {
      const query = `
        SELECT 
          d.id_docente,
          u.id_usuario,
          u.id_usuario as id,
          p.id_persona,
          p.nombre,
          p.segundo_nombre,
          p.apellido,
          p.segundo_apellido,
          p.cedula,
          p.email,
          p.numero_telefono as telefono,
          p.numero_telefono as phone,
          u.estado_usuario,
          u.foto_usuario
        FROM docente d
        JOIN usuario u ON d.id_usuario = u.id_usuario
        JOIN persona p ON u.id_persona = p.id_persona
        WHERE u.estado_usuario = 'activo'
        ORDER BY p.apellido, p.nombre
      `;
      const { rows } = await db.query(query);
      return rows;
    } catch (error) {
      console.error("❌ UserModel.getDocentes error:", error);
      throw error;
    }
  }
};