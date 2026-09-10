import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { UserModel } from "../models/user.model.js";
import crypto from "crypto";
import { JWT_SECRET, JWT_REFRESH_SECRET } from "../middlewares/jwt.middleware.js";
import { db } from "../db/connection.database.js";

// **FUNCIÓN HELPER PARA VERIFICAR ESTADO - MEJORADA**
const isUserActive = (user) => {
  if (!user || !user.is_active) return false;

  // Normalizar el estado: convertir a minúsculas, quitar espacios
  const normalizedStatus = String(user.is_active || '')
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '');

  console.log(`🔍 Verificando estado: "${user.is_active}" -> "${normalizedStatus}"`);

  // Aceptar varias formas de "activo"
  const activeStatuses = ['activo', 'active', 'activado', 'enabled', 'true', '1', 'yes', 'sí'];
  return activeStatuses.includes(normalizedStatus);
};

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // El campo 'email' puede contener un correo electrónico o una cédula
    const identifier = email;
    console.log("🔍 LOGIN - Intento de login para:", identifier);

    if (!identifier || !password) {
      return res.status(400).json({
        ok: false,
        msg: "Email/Cédula and password are required",
      });
    }

    console.log("🔍 LOGIN - Buscando usuario en BD...");

    // Detectar si el identificador es un email o una cédula
    const isEmail = identifier.includes('@');
    let user;

    if (isEmail) {
      console.log("📧 LOGIN - Buscando por correo electrónico...");
      user = await UserModel.findOneByEmail(identifier);
    } else {
      console.log("🪪 LOGIN - Buscando por cédula...");
      // Normalizar cédula: si no tiene prefijo V- o E-, agregarlo
      let cedula = identifier.trim();
      if (!/^[VvEe]-/.test(cedula)) {
        cedula = 'V-' + cedula;
      }
      console.log("🪪 LOGIN - Cédula normalizada:", cedula);
      try {
        user = await UserModel.findByCedula(cedula);
        console.log("🪪 LOGIN - Resultado findByCedula:", user ? `ENCONTRADO (id: ${user.id})` : "NO ENCONTRADO");
      } catch (err) {
        console.error("🪪 LOGIN - Error en findByCedula:", err.message);
      }
    }

    if (!user) {
      console.log("❌ LOGIN - Usuario no encontrado para:", identifier);
      return res.status(400).json({
        ok: false,
        msg: "Invalid email or password",
      });
    }

    console.log("✅ LOGIN - Usuario encontrado:", {
      id: user.id,
      username: user.username,
      email: user.email,
      is_active: user.is_active,
      Id_rol: user.Id_rol,
    });

    // Verificar estado del usuario con la función mejorada
    if (!isUserActive(user)) {
      console.log("❌ LOGIN - Usuario inactivo. Estado:", user.is_active);
      return res.status(403).json({
        ok: false,
        msg: "Account is inactive. Please contact an administrator",
      });
    }

    console.log("🔑 LOGIN - Verificando contraseña...");

    // DEBUG: Ver qué tipo de password tenemos
    console.log("🔍 DEBUG - Password en BD (primeros 30 chars):", user.password?.substring(0, 30) || 'N/A');
    console.log("🔍 DEBUG - Longitud password BD:", user.password?.length || 0);

    // Verificar si el password está vacío o no existe
    if (!user.password || user.password.trim() === '') {
      console.log("❌ LOGIN - Password está vacío en la BD");
      return res.status(400).json({
        ok: false,
        msg: "Invalid email or password",
      });
    }

    let validPassword = false;
    let passwordWasMigrated = false;
    let migratedHash = null;

    // CASO 1: Si el password en BD es un hash bcrypt (usuarios nuevos)
    if (user.password.startsWith('$2')) {
      console.log("🔐 LOGIN - Password en BD es hash bcrypt, usando bcrypt.compare()");
      validPassword = await bcryptjs.compare(password, user.password);

      if (!validPassword) {
        console.log("❌ LOGIN - Contraseña incorrecta (hash bcrypt)");
      }
    }
    // CASO 2: Si el password en BD está en texto plano (usuarios antiguos)
    else {
      console.log("📝 LOGIN - Password en BD es texto plano, comparando directamente");
      validPassword = (user.password === password);

      if (validPassword) {
        console.log("✅ LOGIN - Contraseña correcta (texto plano). Migrando a hash...");

        try {
          // Auto-migrar a hash bcrypt
          migratedHash = await UserModel.migratePasswordToHash(user.id, password);
          passwordWasMigrated = true;
          console.log("✅ LOGIN - Password migrado exitosamente a hash bcrypt");
        } catch (migrateError) {
          console.log("⚠️ LOGIN - Error migrando password (continuando):", migrateError.message);
          // Continuamos aunque falle la migración
        }
      } else {
        console.log("❌ LOGIN - Contraseña incorrecta (texto plano)");
      }
    }

    if (!validPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Invalid email or password",
      });
    }

    console.log("🎉 LOGIN - Credenciales válidas, generando tokens...");

    // Verificar si es profesor
    let profesorInfo = null;
    try {
      profesorInfo = await UserModel.isProfesor(user.id);
      if (profesorInfo) {
        console.log("👨‍🏫 LOGIN - Usuario es profesor:", profesorInfo.Id_profesor);
      }
    } catch (error) {
      console.log("ℹ️ LOGIN - No es profesor o error al verificar:", error.message);
    }

    // Verificar si es representante
    let representanteInfo = null;
    try {
      representanteInfo = await UserModel.isRepresentante(user.id);
      if (representanteInfo) {
        console.log("👨‍👩‍👧‍👦 LOGIN - Usuario es representante:", representanteInfo.Id_representante);
      }
    } catch (error) {
      console.log("ℹ️ LOGIN - No es representante o error al verificar:", error.message);
    }

    // Verificar si la cédula está vacía, nula o si es una cédula temporal
    const mustChangeCedula =
      !user.cedula ||
      String(user.cedula || '').trim() === '' ||
      String(user.cedula || '').trim().toUpperCase().startsWith('V-1000');

    // Generate access token
    const accessToken = jwt.sign(
      {
        userId: user.id,
        username: user.username,
        Id_rol: user.Id_rol,
        nombre: user.nombre,
        apellido: user.apellido,
        email: user.email,
        cedula: user.cedula,
        must_change_cedula: mustChangeCedula,
        tipo_rol: user.tipo_rol,
        es_profesor: !!profesorInfo,
        es_representante: !!representanteInfo,
        profesorId: profesorInfo?.Id_profesor || null,
        representanteId: representanteInfo?.Id_representante || null
      },
      JWT_SECRET,
      { expiresIn: "24h" }
    );

    // Generate refresh token
    const refreshToken = jwt.sign(
      {
        userId: user.id,
      },
      JWT_REFRESH_SECRET,
      { expiresIn: "7d" }
    );

    console.log("✅ LOGIN - Tokens generados exitosamente");
    console.log("🔑 LOGIN - Access token para userId:", user.id);
    console.log("📊 LOGIN - Password migrado:", passwordWasMigrated ? "✅ Sí" : "❌ No");

    // Update last login
    try {
      await UserModel.updateLastLogin(user.id);
    } catch (updateError) {
      console.log("⚠️ LOGIN - Error actualizando last_login:", updateError.message);
    }

    // Preparar respuesta del usuario
    const userResponse = {
      id: user.id,
      username: user.username,
      email: user.email,
      nombre: user.nombre,
      apellido: user.apellido,
      cedula: user.cedula,
      must_change_cedula: mustChangeCedula,
      telefono: user.telefono,
      fecha_nacimiento: user.fecha_nacimiento,
      genero: user.genero,
      foto_usuario: user.foto_usuario,
      Id_rol: user.Id_rol,
      tipo_rol: user.tipo_rol,
      Id_direccion: user.Id_direccion,
      nombre_direccion: user.nombre_direccion,
      nombre_ciudad: user.nombre_ciudad,
      nombre_parroquia: user.nombre_parroquia,
      nombre_municipio: user.nombre_municipio,
      nombre_estado: user.nombre_estado,
      nombre_pais: user.nombre_pais,
      is_active: user.is_active,
      email_verified: user.email_verified,
      created_at: user.created_at,
    };

    // Agregar información específica si es profesor
    if (profesorInfo) {
      userResponse.Id_profesor = profesorInfo.Id_profesor;
      userResponse.especialidad = profesorInfo.especialidad;
    }

    // Agregar información específica si es representante
    if (representanteInfo) {
      userResponse.Id_representante = representanteInfo.Id_representante;
      userResponse.es_familiar = representanteInfo.es_familiar;
      userResponse.profesion_rep = representanteInfo.profesion_rep;
      userResponse.direccion_trabajo_rep = representanteInfo.direccion_trabajo_rep;
    }

    res.json({
      ok: true,
      msg: "Login successful" + (passwordWasMigrated ? " (password migrado a hash)" : ""),
      accessToken,
      refreshToken,
      user: userResponse,
    });
  } catch (error) {
    console.error("❌ LOGIN - Error general:", error);
    res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

// ============================================
// FUNCIÓN PARA MIGRAR TODOS LOS PASSWORDS (Endpoint)
// ============================================
export const migrateAllPasswords = async (req, res) => {
  try {
    console.log("🚀 MIGRATE ALL - Iniciando migración de todos los passwords...");

    // Verificar si es admin (opcional)
    if (req.user && req.user.Id_rol !== 1) {
      return res.status(403).json({
        ok: false,
        msg: "Admin access required"
      });
    }

    const result = await UserModel.migrateAllPasswords();

    return res.json({
      ok: true,
      msg: `Migración completada: ${result.migrated} migrados, ${result.errors} errores`,
      migrated: result.migrated,
      errors: result.errors,
      total: result.total,
      results: result.results
    });

  } catch (error) {
    console.error("❌ MIGRATE ALL - Error general:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const refreshToken = async (req, res) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        ok: false,
        msg: "Refresh token is required",
      });
    }

    try {
      // Verify the refresh token
      const decoded = jwt.verify(refreshToken, JWT_REFRESH_SECRET);
      const userId = decoded.userId;

      console.log("🔄 REFRESH - Token válido para userId:", userId);

      // Get the user
      const user = await UserModel.findOneById(userId);
      if (!user) {
        return res.status(404).json({
          ok: false,
          msg: "User not found",
        });
      }

      // **¡CORRECCIÓN APLICADA AQUÍ TAMBIÉN!**
      if (!isUserActive(user)) {
        return res.status(403).json({
          ok: false,
          msg: "Account is inactive",
        });
      }

      // Verificar si es profesor
      let profesorInfo = null;
      try {
        profesorInfo = await UserModel.isProfesor(user.id);
      } catch (error) {
        console.log("ℹ️ REFRESH - Error al verificar profesor:", error.message);
      }

      // Verificar si es representante
      let representanteInfo = null;
      try {
        representanteInfo = await UserModel.isRepresentante(user.id);
      } catch (error) {
        console.log("ℹ️ REFRESH - Error al verificar representante:", error.message);
      }

      // Generate new access token
      const accessToken = jwt.sign(
        {
          userId: user.id,
          username: user.username,
          Id_rol: user.Id_rol,
          nombre: user.nombre,
          apellido: user.apellido,
          email: user.email,
          cedula: user.cedula,
          tipo_rol: user.tipo_rol,
          es_profesor: !!profesorInfo,
          es_representante: !!representanteInfo,
          profesorId: profesorInfo?.Id_profesor || null,
          representanteId: representanteInfo?.Id_representante || null
        },
        JWT_SECRET,
        { expiresIn: "24h" }
      );

      // Generate new refresh token
      const newRefreshToken = jwt.sign(
        {
          userId: user.id,
        },
        JWT_REFRESH_SECRET,
        { expiresIn: "7d" }
      );

      console.log("✅ REFRESH - Nuevos tokens generados");

      return res.json({
        ok: true,
        accessToken,
        refreshToken: newRefreshToken,
      });
    } catch (error) {
      console.error("❌ REFRESH - Error verificando token:", error.message);

      if (error.name === "TokenExpiredError") {
        return res.status(401).json({
          ok: false,
          msg: "Refresh token expired",
        });
      }
      if (error.name === "JsonWebTokenError") {
        return res.status(401).json({
          ok: false,
          msg: "Invalid refresh token",
        });
      }
      throw error;
    }
  } catch (error) {
    console.error("Error in refreshToken:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
    });
  }
};

export const logout = async (req, res) => {
  try {
    // En este sistema simplificado, el logout solo confirma que el token es válido
    // El cliente debe eliminar el token de su almacenamiento local
    return res.json({
      ok: true,
      msg: "Logged out successfully",
    });
  } catch (error) {
    console.error("Error in logout:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
    });
  }
};

export const getProfile = async (req, res) => {
    try {
        const userId = req.user?.id || req.user?.userId;
        const userRole = req.user?.role || req.user?.roleName;

        if (!userId) {
            return res.status(401).json({ ok: false, msg: "No autorizado" });
        }

        // Búsqueda genérica segura en el modelo principal de usuarios
        let user = null;
        if (typeof UserModel.findById === 'function') {
            user = await UserModel.findById(userId);
        } else if (typeof UserModel.findOneById === 'function') {
            user = await UserModel.findOneById(userId);
        }

        if (!user) {
            return res.status(404).json({ ok: false, msg: "Perfil de usuario no encontrado en la base de datos" });
        }

        // Excluir contraseñas por seguridad
        delete user.password;
        delete user.clave;

        return res.json({ 
            ok: true, 
            role: userRole,
            user 
        });
    } catch (error) {
        console.error("❌ Error al obtener perfil específico:", error);
        return res.status(500).json({ ok: false, msg: "Error interno al procesar el perfil" });
    }
};

export const profile = getProfile;

// ============================================
// 🆕 LIST USERS - MEJORADO (mapeo de roles)
// ============================================
export const listUsers = async (req, res) => {
  try {
    const users = await UserModel.findAll();

    // Mapear al formato del frontend
    const mappedUsers = users.map(user => {
      const roleMap = {
        1: 'admin',
        2: 'docente',
        3: 'estudiante',
        4: 'representante'
      };

      return {
        id: user.id,
        dni: user.cedula,
        first_name: user.nombre,
        last_name: user.apellido,
        email: user.correo,
        phone: user.telefono || '',
        role: roleMap[user.Id_rol] || 'estudiante',
        status: user.is_active === 'activo' ? 'active' : 'inactive',
        createdAt: user.created_at
      };
    });

    return res.json({
      ok: true,
      users: mappedUsers,
      total: mappedUsers.length,
    });
  } catch (error) {
    console.error("❌ Error in listUsers:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al listar usuarios",
      error: error.message,
    });
  }
};

// ============================================
// 🆕 CREAR USUARIO POR ADMINISTRADOR
// ============================================
export const createUser = async (req, res) => {
  try {
    const {
      dni, first_name, last_name, password, phone, email,
      role, status, fecha_nacimiento, genero, Id_direccion
    } = req.body;

    console.log("👑 ADMIN CREATE - Creando usuario por admin:", {
      email,
      role,
      dni,
      creador: req.user.userId
    });

    // Validaciones básicas
    if (!dni || !first_name || !last_name || !email || !password || !role) {
      return res.status(400).json({
        ok: false,
        msg: "Faltan campos obligatorios: cédula, nombre, apellido, email, contraseña y rol"
      });
    }

    if (password.length < 4) {
      return res.status(400).json({
        ok: false,
        msg: "La contraseña debe tener al menos 4 caracteres"
      });
    }

    // Mapeo de roles (frontend → BD)
    const roleMap = {
      'admin': 1,
      'docente': 2,
      'superadmin': 1,
      'estudiante': 3,
      'representante': 4
    };

    const Id_rol = roleMap[role];
    if (!Id_rol) {
      return res.status(400).json({
        ok: false,
        msg: `Rol inválido: ${role}`
      });
    }

    // Verificar duplicados
    const existingUserByCedula = await UserModel.findByCedula(dni);
    if (existingUserByCedula) {
      return res.status(400).json({
        ok: false,
        msg: "La cédula ya está registrada"
      });
    }

    const existingUserByEmail = await UserModel.findOneByEmail(email);
    if (existingUserByEmail) {
      return res.status(400).json({
        ok: false,
        msg: "El email ya está registrado"
      });
    }

    // Generar username a partir del email
    const username = email.split('@')[0];

    // Crear el usuario
    const newUser = await UserModel.create({
      username,
      email,
      password,
      Id_rol,
      nombre: first_name,
      apellido: last_name,
      cedula: dni,
      telefono: phone || null,
      fecha_nacimiento: fecha_nacimiento || null,
      genero: genero || null,
      Id_direccion: Id_direccion || null,
      security_word: 'predeterminada',
      respuesta_de_seguridad: 'predeterminada'
    });

    // 🔥 Si es DOCENTE, crear automáticamente en tabla Profesor
    if (role === 'docente' && newUser.id) {
      try {
        await UserModel.createProfesor(newUser.id);
        console.log(`✅ Profesor creado automáticamente para usuario ${newUser.id}`);
      } catch (profError) {
        console.error(`❌ Error creando profesor:`, profError.message);
        // No fallamos la operación principal
      }
    }

    // Preparar respuesta en formato frontend
    const userResponse = {
      id: newUser.id,
      dni: newUser.cedula,
      first_name: newUser.nombre,
      last_name: newUser.apellido,
      email: newUser.email,
      phone: newUser.telefono || '',
      role: role,
      status: newUser.is_active === 'activo' ? 'active' : 'inactive',
      createdAt: newUser.created_at
    };

    return res.status(201).json({
      ok: true,
      msg: `Usuario ${role} creado exitosamente`,
      user: userResponse
    });

  } catch (error) {
    console.error("❌ ADMIN CREATE - Error:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al crear usuario",
      error: error.message
    });
  }
};

// ============================================
// 🆕 ACTUALIZAR USUARIO POR ADMIN
// ============================================
export const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      dni, first_name, last_name, phone, email,
      role, status, password
    } = req.body;

    console.log(`👑 ADMIN UPDATE - Actualizando usuario ${id}`);

    // Verificar que el usuario existe
    const existingUser = await UserModel.findOneById(id);
    if (!existingUser) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado"
      });
    }

    // No permitir modificar superadmin si no eres superadmin
    if (existingUser.Id_rol === 1 && req.user.Id_rol !== 1) {
      return res.status(403).json({
        ok: false,
        msg: "No puedes modificar administradores"
      });
    }

    // Mapear rol
    const roleMap = {
      'admin': 1,
      'docente': 2,
      'superadmin': 1
    };
    const Id_rol = roleMap[role] || existingUser.Id_rol;

    // Verificar duplicados (si cambiaron)
    if (dni && dni !== existingUser.cedula) {
      const existingByCedula = await UserModel.findByCedula(dni);
      if (existingByCedula && existingByCedula.id !== parseInt(id)) {
        return res.status(400).json({
          ok: false,
          msg: "La cédula ya está registrada por otro usuario"
        });
      }
    }

    if (email && email !== existingUser.email) {
      const existingByEmail = await UserModel.findOneByEmail(email);
      if (existingByEmail && existingByEmail.id !== parseInt(id)) {
        return res.status(400).json({
          ok: false,
          msg: "El email ya está registrado por otro usuario"
        });
      }
    }

    // Mapear estado
    let dbStatus = existingUser.is_active;
    if (status === 'active') dbStatus = 'activo';
    else if (status === 'inactive') dbStatus = 'inactivo';
    else if (status === 'suspended') dbStatus = 'suspendido';

    // Actualizar usuario
    const updatedUser = await UserModel.updateUserByAdmin(id, {
      cedula: dni,
      nombre: first_name,
      apellido: last_name,
      telefono: phone,
      email,
      Id_rol,
      status: dbStatus,
      password: password || null
    });

    // Si cambió a DOCENTE y no era docente, crear registro
    if (role === 'docente') {
      const isProf = await UserModel.isProfesor(id);
      if (!isProf) {
        await UserModel.createProfesor(id);
        console.log(`✅ Registro de profesor creado para usuario ${id}`);
      }
    }

    return res.json({
      ok: true,
      msg: "Usuario actualizado correctamente",
      user: {
        ...updatedUser,
        role: role,
        status: status
      }
    });

  } catch (error) {
    console.error("❌ ADMIN UPDATE - Error:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al actualizar usuario",
      error: error.message
    });
  }
};

// ============================================
// 🆕 ACTUALIZAR SOLO EL ROL DEL USUARIO
// ============================================
export const updateUserRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { role } = req.body;

    const roleMap = {
      'admin': 1,
      'docente': 2,
      'superadmin': 1
    };

    const Id_rol = roleMap[role];
    if (!Id_rol) {
      return res.status(400).json({
        ok: false,
        msg: "Rol inválido"
      });
    }

    const updatedUser = await UserModel.updateUserRole(id, Id_rol);

    // Si el nuevo rol es docente, asegurar que tenga registro en Profesor
    if (role === 'docente') {
      const isProf = await UserModel.isProfesor(id);
      if (!isProf) {
        await UserModel.createProfesor(id);
        console.log(`✅ Registro de profesor creado para usuario ${id} (cambio de rol)`);
      }
    }

    return res.json({
      ok: true,
      msg: `Rol actualizado a ${role}`,
      user: updatedUser
    });

  } catch (error) {
    console.error("❌ ADMIN ROLE UPDATE - Error:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al actualizar rol",
      error: error.message
    });
  }
};

// ============================================
// 🆕 DELETE USER - MEJORADO
// ============================================
// ============================================
// 🆕 DELETE USER - VERSIÓN MEJORADA
// ============================================
export const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await UserModel.findOneById(id);
    if (!user) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    // No permitir eliminar superadmin
    if (user.Id_rol === 1) {
      return res.status(403).json({
        ok: false,
        msg: "No puedes eliminar un administrador",
      });
    }

    let result;

    // Si es DOCENTE (Id_rol = 2), usar función especializada
    if (user.Id_rol === 2) {
      console.log(`👨‍🏫 Eliminando docente ${id} con todas sus relaciones...`);
      result = await UserModel.removeProfesorCompleto(id);
    } else {
      // Para otros roles, usar eliminación estándar
      console.log(`👤 Eliminando usuario ${id} (rol: ${user.Id_rol})...`);
      result = await UserModel.remove(id);
    }

    return res.json({
      ok: true,
      msg: "Usuario eliminado exitosamente",
      id: result.id,
    });
  } catch (error) {
    console.error("❌ Error in deleteUser:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al eliminar usuario",
      error: error.message,
    });
  }
};




export const updateProfile = async (req, res) => {
  try {
    const userId = req.user.userId;
    const {
      email, security_word, respuesta_de_seguridad,
      nombre, apellido, telefono, cedula,
      fecha_nacimiento, genero, foto_usuario, Id_direccion,
      direccion
    } = req.body;

    // Check if email is being updated and if it already exists
    if (email) {
      const existingUserByEmail = await UserModel.findOneByEmail(email);
      if (existingUserByEmail && existingUserByEmail.id !== userId) {
        return res.status(400).json({
          ok: false,
          msg: "Email already exists",
        });
      }
    }

    // Check if cedula is being updated and if it already exists
    let formattedCedula = cedula;
    if (cedula && typeof cedula === 'string' && cedula.trim()) {
      formattedCedula = cedula.trim().toUpperCase();
      if (!/^[VvEe]-/.test(formattedCedula)) {
        formattedCedula = 'V-' + formattedCedula;
      }
      const existingUserByCedula = await UserModel.findByCedula(formattedCedula);
      if (existingUserByCedula && String(existingUserByCedula.id) !== String(userId)) {
        return res.status(400).json({
          ok: false,
          msg: "Esta cédula ya se encuentra registrada por otro usuario",
        });
      }
    }

    // Handle address (direccion) update or creation
    let finalIdDireccion = Id_direccion;
    if (direccion && typeof direccion === 'string' && direccion.trim()) {
      const db = require("../database/db.js");
      // Check if user already has an address linked
      const userResult = await db.query(
        'SELECT "Id_direccion" FROM "Usuario" WHERE "Id_usuario" = $1',
        [userId]
      );
      const currentIdDireccion = userResult.rows[0]?.Id_direccion;

      if (currentIdDireccion) {
        // Update existing Direccion record
        await db.query(
          'UPDATE "Direccion" SET "nombre_direccion" = $1 WHERE "Id_direccion" = $2',
          [direccion.trim(), currentIdDireccion]
        );
        finalIdDireccion = currentIdDireccion;
      } else {
        // Create new Direccion record and link it
        const insertResult = await db.query(
          'INSERT INTO "Direccion" ("nombre_direccion") VALUES ($1) RETURNING "Id_direccion"',
          [direccion.trim()]
        );
        finalIdDireccion = insertResult.rows[0].Id_direccion;
      }
    }

    const updatedUser = await UserModel.updateProfile(userId, {
      email,
      security_word,
      respuesta_de_seguridad,
      nombre,
      apellido,
      telefono,
      cedula: formattedCedula,
      fecha_nacimiento,
      genero,
      foto_usuario,
      Id_direccion: finalIdDireccion,
    });

    if (!updatedUser) {
      return res.status(404).json({
        ok: false,
        msg: "User not found",
      });
    }

    return res.json({
      ok: true,
      msg: "Profile updated successfully",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error in updateProfile:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

// Nueva función para actualizar perfil con validación de seguridad
export const updateProfileWithSecurity = async (req, res) => {
  try {
    const userId = req.user.userId;
    const {
      email, security_word, respuesta_de_seguridad, current_security_answer,
      nombre, apellido, telefono, cedula, fecha_nacimiento, genero, foto_usuario, Id_direccion
    } = req.body;

    if (!current_security_answer) {
      return res.status(400).json({
        ok: false,
        msg: "Current security answer is required",
      });
    }

    // Check if email is being updated and if it already exists
    if (email) {
      const existingUserByEmail = await UserModel.findOneByEmail(email);
      if (existingUserByEmail && existingUserByEmail.id !== userId) {
        return res.status(400).json({
          ok: false,
          msg: "Email already exists",
        });
      }
    }

    // Check if cedula is being updated and if it already exists
    if (cedula) {
      const existingUserByCedula = await UserModel.findByCedula(cedula);
      if (existingUserByCedula && existingUserByCedula.id !== userId) {
        return res.status(400).json({
          ok: false,
          msg: "Cedula already exists",
        });
      }
    }

    const updatedUser = await UserModel.updateProfileWithSecurity(userId, {
      email,
      security_word,
      respuesta_de_seguridad,
      current_security_answer,
      nombre,
      apellido,
      telefono,
      cedula,
      fecha_nacimiento,
      genero,
      foto_usuario,
      Id_direccion,
    });

    return res.json({
      ok: true,
      msg: "Profile updated successfully with security validation",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error in updateProfileWithSecurity:", error);

    if (error.message === "Invalid security answer") {
      return res.status(400).json({
        ok: false,
        msg: "Invalid security answer",
      });
    }

    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const changePassword = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Current password and new password are required",
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "New password must be at least 6 characters long",
      });
    }

    const user = await UserModel.findOneById(userId);
    if (!user) {
      return res.status(404).json({
        ok: false,
        msg: "User not found",
      });
    }

    // Verificar contraseña actual (soporta texto plano y hash)
    let validCurrentPassword = false;

    if (user.password.startsWith('$2')) {
      // Si es hash bcrypt
      validCurrentPassword = await bcryptjs.compare(currentPassword, user.password);
    } else {
      // Si es texto plano
      validCurrentPassword = (user.password === currentPassword);

      // Si la contraseña es correcta y está en texto plano, migrarla
      if (validCurrentPassword) {
        try {
          await UserModel.migratePasswordToHash(userId, currentPassword);
          console.log("✅ CHANGE PASSWORD - Password actual migrado a hash");
        } catch (migrateError) {
          console.log("⚠️ CHANGE PASSWORD - Error migrando password:", migrateError.message);
        }
      }
    }

    if (!validCurrentPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Current password is incorrect",
      });
    }

    // Hash de la nueva contraseña
    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(newPassword, salt);

    await UserModel.updatePassword(userId, hashedPassword);

    return res.json({
      ok: true,
      msg: "Password changed successfully",
    });
  } catch (error) {
    console.error("Error in changePassword:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

// Nueva función para cambiar contraseña con palabra de seguridad
export const changePasswordWithSecurity = async (req, res) => {
  try {
    const { username, respuesta_de_seguridad, newPassword } = req.body;

    if (!username || !respuesta_de_seguridad || !newPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Username, security answer, and new password are required",
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "New password must be at least 6 characters long",
      });
    }

    const updatedUser = await UserModel.changePasswordWithSecurity(username, respuesta_de_seguridad, newPassword);

    return res.json({
      ok: true,
      msg: "Password changed successfully using security question",
      user: {
        id: updatedUser.id,
        username: updatedUser.username,
        email: updatedUser.email,
        nombre: updatedUser.nombre,
        apellido: updatedUser.apellido,
      },
    });
  } catch (error) {
    console.error("Error in changePasswordWithSecurity:", error);

    if (error.message === "Invalid username or security answer") {
      return res.status(400).json({
        ok: false,
        msg: "Invalid username or security answer",
      });
    }

    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        ok: false,
        msg: "Email is required",
      });
    }

    const user = await UserModel.findOneByEmail(email);
    if (!user) {
      return res.json({
        ok: true,
        msg: "If your email exists in our system, you will receive a password reset token",
      });
    }

    const resetToken = crypto.randomBytes(20).toString("hex");
    await UserModel.setPasswordResetToken(user.id, resetToken);

    return res.json({
      ok: true,
      msg: "If your email exists in our system, you will receive a password reset token",
      resetToken,
    });
  } catch (error) {
    console.error("Error in forgotPassword:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const resetPassword = async (req, res) => {
  try {
    const { token, newPassword } = req.body;

    if (!token || !newPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Token and new password are required",
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "New password must be at least 6 characters long",
      });
    }

    const user = await UserModel.findByPasswordResetToken(token);
    if (!user) {
      return res.status(400).json({
        ok: false,
        msg: "Invalid or expired password reset token",
      });
    }

    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(newPassword, salt);

    await UserModel.updatePassword(user.id, hashedPassword);
    await UserModel.clearPasswordResetToken(user.id);

    return res.json({
      ok: true,
      msg: "Password has been reset successfully",
    });
  } catch (error) {
    console.error("Error in resetPassword:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const activateUser = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await UserModel.findOneById(id);
    if (!user) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    const updatedUser = await UserModel.setActive(id, true);

    return res.json({
      ok: true,
      msg: "Usuario activado exitosamente",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error in activateUser:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al activar usuario",
      error: error.message,
    });
  }
};

export const deactivateUser = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await UserModel.findOneById(id);
    if (!user) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    const updatedUser = await UserModel.setActive(id, false);

    return res.json({
      ok: true,
      msg: "Usuario desactivado exitosamente",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error in deactivateUser:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al desactivar usuario",
      error: error.message,
    });
  }
};

export const searchUsers = async (req, res) => {
  try {
    const { search } = req.query;
    if (!search) {
      return res.status(400).json({
        ok: false,
        msg: "Search parameter is required",
      });
    }

    const users = await UserModel.searchByUsername(search);

    // Mapear al formato del frontend
    const mappedUsers = users.map(user => {
      const roleMap = {
        1: 'admin',
        2: 'docente',
        3: 'estudiante',
        4: 'representante'
      };

      return {
        id: user.id,
        dni: user.cedula,
        first_name: user.nombre,
        last_name: user.apellido,
        email: user.correo,
        phone: user.telefono || '',
        role: roleMap[user.Id_rol] || 'estudiante',
        status: user.is_active === 'activo' ? 'active' : 'inactive',
        createdAt: user.created_at
      };
    });

    return res.json({
      ok: true,
      users: mappedUsers,
      total: mappedUsers.length,
    });
  } catch (error) {
    console.error("Error in searchUsers:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const verifyEmail = async (req, res) => {
  try {
    const { token } = req.params;

    const user = await UserModel.verifyEmail(token);
    if (!user) {
      return res.status(400).json({
        ok: false,
        msg: "Invalid or expired verification token",
      });
    }

    return res.json({
      ok: true,
      msg: "Email verified successfully",
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        email_verified: user.email_verified,
        nombre: user.nombre,
        apellido: user.apellido,
      },
    });
  } catch (error) {
    console.error("Error in verifyEmail:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const recoverPasswordWithSecurity = async (req, res) => {
  try {
    const { username, respuesta_de_seguridad, newPassword } = req.body;

    if (!username || !respuesta_de_seguridad || !newPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Username, security answer, and new password are required",
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "New password must be at least 6 characters long",
      });
    }

    // Verify security answer
    const user = await UserModel.verifySecurityAnswer(username, respuesta_de_seguridad);
    if (!user) {
      return res.status(400).json({
        ok: false,
        msg: "Invalid username or security answer",
      });
    }

    // Hash new password
    const salt = await bcryptjs.genSalt(10);
    const hashedPassword = await bcryptjs.hash(newPassword, salt);

    // Update password
    await UserModel.updatePassword(user.id, hashedPassword);

    return res.json({
      ok: true,
      msg: "Password has been reset successfully using security question",
    });
  } catch (error) {
    console.error("Error in recoverPasswordWithSecurity:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

export const getSecurityQuestion = async (req, res) => {
  try {
    const { username } = req.params;

    if (!username) {
      return res.status(400).json({
        ok: false,
        msg: "Username is required",
      });
    }

    const user = await UserModel.findOneByUsername(username);
    if (!user) {
      // For security reasons, don't reveal that the user doesn't exist
      return res.status(404).json({
        ok: false,
        msg: "User not found",
      });
    }

    return res.json({
      ok: true,
      security_question: user.security_word,
      username: user.username,
    });
  } catch (error) {
    console.error("Error in getSecurityQuestion:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
    });
  }
};

export const register = async (req, res) => {
  try {
    const {
      username, email, password, Id_rol, security_word, respuesta_de_seguridad,
      nombre, apellido, cedula, telefono, fecha_nacimiento, genero, foto_usuario, Id_direccion
    } = req.body;

    if ((!username && !email) || !password || !Id_rol) {
      return res.status(400).json({
        ok: false,
        msg: "Missing required fields: email or username, password, and Id_rol are mandatory",
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "Password must be at least 6 characters long",
      });
    }

    if (!nombre || !apellido || !cedula) {
      return res.status(400).json({
        ok: false,
        msg: "Nombre, apellido, and cedula are required",
      });
    }

    // Use email as username if username not provided
    const finalUsername = username || email;

    // Check if username/email already exists
    const existingUser = await UserModel.findOneByUsername(finalUsername);
    if (existingUser) {
      return res.status(400).json({
        ok: false,
        msg: "Username or email already exists",
      });
    }

    // Check if email already exists (if provided and different from username)
    if (email && email !== finalUsername) {
      const existingUserByEmail = await UserModel.findOneByEmail(email);
      if (existingUserByEmail) {
        return res.status(400).json({
          ok: false,
          msg: "Email already exists",
        });
      }
    }

    // Check if cedula already exists
    const existingUserByCedula = await UserModel.findByCedula(cedula);
    if (existingUserByCedula) {
      return res.status(400).json({
        ok: false,
        msg: "Cedula already exists",
      });
    }

    const newUser = await UserModel.create({
      username: finalUsername,
      email: email || finalUsername,
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
    });

    // Si es docente, crear automáticamente el registro en Profesor
    if (Id_rol === 2 && newUser.id) {
      try {
        await UserModel.createProfesor(newUser.id);
        console.log(`✅ Profesor creado automáticamente para usuario ${newUser.id} (registro)`);
      } catch (profError) {
        console.error(`❌ Error creando profesor:`, profError.message);
      }
    }

    if (!newUser) {
      return res.status(500).json({
        ok: false,
        msg: "Error creating user",
      });
    }

    return res.status(201).json({
      ok: true,
      msg: "User created successfully",
      user: {
        id: newUser.id,
        username: newUser.username,
        email: newUser.email,
        nombre: newUser.nombre,
        apellido: newUser.apellido,
        cedula: newUser.cedula,
        telefono: newUser.telefono,
        Id_rol: newUser.Id_rol,
        Id_direccion: newUser.Id_direccion,
        is_active: newUser.is_active,
        email_verified: newUser.email_verified,
        created_at: newUser.created_at,
      },
    });
  } catch (error) {
    console.error("Error in register:", error);
    return res.status(500).json({
      ok: false,
      msg: "Server error",
      error: error.message,
    });
  }
};

// ============================================
// ACTUALIZAR CÉDULA OBLIGATORIA
// ============================================
export const updateCedula = async (req, res) => {
  try {
    const userId = req.user.userId;
    let { cedula } = req.body;

    if (!cedula || !cedula.trim()) {
      return res.status(400).json({
        ok: false,
        msg: "La cédula es requerida",
      });
    }

    cedula = cedula.trim().toUpperCase();

    // Normalizar prefijo V- o E-
    if (!/^[VvEe]-/.test(cedula)) {
      cedula = "V-" + cedula;
    }

    // Validar formato V-12345678 o E-12345678
    if (!/^[VvEe]-\d{5,10}$/.test(cedula)) {
      return res.status(400).json({
        ok: false,
        msg: "El formato de la cédula no es válido (Ejemplo: V-12345678 o E-12345678)",
      });
    }

    // Verificar que no sea cédula temporal
    if (cedula.startsWith("V-1000")) {
      return res.status(400).json({
        ok: false,
        msg: "Debes ingresar una cédula real válida",
      });
    }

    // Verificar si la cédula ya está tomada por otro usuario
    const existing = await UserModel.findByCedula(cedula);
    if (existing && String(existing.id) !== String(userId)) {
      return res.status(400).json({
        ok: false,
        msg: "Esta cédula ya se encuentra registrada por otro usuario",
      });
    }

    const updatedUser = await UserModel.updateCedula(userId, cedula);

    if (!updatedUser) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    console.log(`✅ Cédula actualizada exitosamente para usuario ${userId}: ${cedula}`);

    return res.json({
      ok: true,
      msg: "Cédula actualizada exitosamente",
      user: {
        ...updatedUser,
        cedula,
        must_change_cedula: false,
      },
    });
  } catch (error) {
    console.error("❌ Error en updateCedula controller:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error en el servidor al actualizar la cédula",
      error: error.message,
    });
  }
};

export const UserController = {
  login,
  migrateAllPasswords,
  refreshToken,
  logout,
  profile,
  getProfile,
  listUsers,
  createUser,
  updateUser,
  updateUserRole,
  deleteUser,
  updateProfile,
  updateProfileWithSecurity,
  changePassword,
  changePasswordWithSecurity,
  forgotPassword,
  resetPassword,
  activateUser,
  deactivateUser,
  searchUsers,
  verifyEmail,
  recoverPasswordWithSecurity,
  getSecurityQuestion,
  register,
  updateCedula,
};


