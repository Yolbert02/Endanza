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
  create: async ({
    nombre,
    segundo_nombre = null,
    apellido,
    segundo_apellido = null,
    cedula = null,
    telefono = null,
    email = null,
    fecha_nacimiento = null,
    genero = null,
    password,
    id_rol = 5,
    direccion = null,
    estado_usuario = 'activo',
    foto_usuario = null
  }) => {
    const client = await db.pool.connect();
    try {
      await client.query('BEGIN');

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

      // 3. Crear o actualizar persona
      let id_persona = null;
      if (cedulaNorm) {
        const pExist = await client.query(
          `SELECT id_persona FROM persona WHERE cedula = $1 LIMIT 1`,
          [cedulaNorm]
        );
        if (pExist.rows.length > 0) {
          id_persona = pExist.rows[0].id_persona;
          await client.query(`
            UPDATE persona SET
              nombre = COALESCE($1, nombre),
              segundo_nombre = COALESCE($2, segundo_nombre),
              apellido = COALESCE($3, apellido),
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
      const hashedPassword = password.startsWith('$2') 
        ? password 
        : await bcryptjs.hash(password, 10);

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
        await client.query(`
          INSERT INTO docente (id_usuario)
          VALUES ($1)
          ON CONFLICT DO NOTHING
        `, [id_usuario]);
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

  // ==========================================
  // ACTUALIZACIÓN DE USUARIO
  // ==========================================
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

      // Actualizar datos de persona
      if (id_persona) {
        const nombre = updateData.nombre ? capitalizeWords(updateData.nombre.trim()) : null;
        const segundo_nombre = updateData.segundo_nombre ? capitalizeWords(updateData.segundo_nombre.trim()) : null;
        const apellido = updateData.apellido ? capitalizeWords(updateData.apellido.trim()) : null;
        const segundo_apellido = updateData.segundo_apellido ? capitalizeWords(updateData.segundo_apellido.trim()) : null;
        const cedula = updateData.cedula?.trim() || null;
        const telefono = updateData.telefono || updateData.numero_telefono || null;
        const email = updateData.email?.trim().toLowerCase() || null;
        const fecha_nacimiento = updateData.fecha_nacimiento || null;
        const genero = updateData.genero && ['masculino', 'femenino'].includes(updateData.genero.toLowerCase())
          ? updateData.genero.toLowerCase()
          : null;

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

      if (updateData.estado_usuario) {
        updates.push(`estado_usuario = $${valIdx++}`);
        values.push(updateData.estado_usuario);
      }

      if (updateData.id_rol) {
        updates.push(`id_rol = $${valIdx++}`);
        values.push(updateData.id_rol);

        // Actualizar tabla usuario_rol
        await client.query(`
          INSERT INTO usuario_rol (id_usuario, id_rol)
          VALUES ($1, $2)
          ON CONFLICT (id_usuario, id_rol) DO NOTHING
        `, [userId, updateData.id_rol]);

        if (Number(updateData.id_rol) === 2) {
          await client.query(`INSERT INTO docente (id_usuario) VALUES ($1) ON CONFLICT DO NOTHING`, [userId]);
        }
        if (Number(updateData.id_rol) === 4 && id_persona) {
          await client.query(`INSERT INTO representante (id_persona, id_usuario) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [id_persona, userId]);
        }
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
    try {
      // Soft-delete cambiando estado a inactivo
      await db.query(`UPDATE usuario SET estado_usuario = 'inactivo', updated_at = CURRENT_TIMESTAMP WHERE id_usuario = $1`, [userId]);
      return true;
    } catch (error) {
      console.error("❌ UserModel.deleteUser error:", error);
      throw error;
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
          p.id_persona,
          p.nombre,
          p.segundo_nombre,
          p.apellido,
          p.segundo_apellido,
          p.cedula,
          p.email,
          p.numero_telefono as telefono,
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