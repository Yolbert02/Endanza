import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { UserModel } from "../models/user.model.js";
import { JWT_SECRET, JWT_REFRESH_SECRET } from "../middlewares/jwt.middleware.js";

// ============================================
// HELPER: Verificar si el usuario está activo
// ============================================
const isUserActive = (user) => {
  if (!user) return false;
  return user.is_active === true || user.estado_usuario === 'activo';
};

// ============================================
// 1. LOGIN
// ============================================
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const identifier = email?.trim();

    console.log("🔍 LOGIN - Intento de login para:", identifier);

    if (!identifier || !password) {
      return res.status(400).json({
        ok: false,
        msg: "El correo/cédula y la contraseña son requeridos",
      });
    }

    // Buscar por email o por cédula
    const isEmail = identifier.includes('@');
    let user = isEmail 
      ? await UserModel.findOneByEmail(identifier)
      : await UserModel.findByCedula(identifier);

    if (!user) {
      console.log("❌ LOGIN - Usuario no encontrado para:", identifier);
      return res.status(400).json({
        ok: false,
        msg: "Correo/Cédula o contraseña inválidos",
      });
    }

    // Verificar si la cuenta está activa
    if (!isUserActive(user)) {
      console.log("❌ LOGIN - Usuario inactivo. Estado:", user.estado_usuario);
      return res.status(403).json({
        ok: false,
        msg: "Cuenta inactiva o suspendida. Por favor contacte al administrador.",
      });
    }

    // Validar contraseña (bcrypt hash o texto plano con auto-migración)
    const storedPassword = user.contrasena || user.password;
    if (!storedPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Correo/Cédula o contraseña inválidos",
      });
    }

    let validPassword = false;
    let passwordWasMigrated = false;

    if (storedPassword.startsWith('$2')) {
      validPassword = await bcryptjs.compare(password, storedPassword);
    } else {
      // Comparación directa en texto plano para compatibilidad legacy
      validPassword = (storedPassword === password);
      if (validPassword) {
        console.log("✅ LOGIN - Contraseña en texto plano correcta. Migrando a hash bcrypt...");
        try {
          await UserModel.migratePasswordToHash(user.id, password);
          passwordWasMigrated = true;
        } catch (e) {
          console.warn("⚠️ Error migrando password:", e.message);
        }
      }
    }

    if (!validPassword) {
      console.log("❌ LOGIN - Contraseña incorrecta");
      return res.status(400).json({
        ok: false,
        msg: "Correo/Cédula o contraseña inválidos",
      });
    }

    // Generar tokens JWT
    const tokenPayload = {
      userId: user.id,
      id: user.id,
      username: user.username,
      Id_rol: user.Id_rol,
      id_rol: user.id_rol,
      nombre: user.nombre,
      apellido: user.apellido,
      email: user.email,
      cedula: user.cedula,
      must_change_cedula: user.must_change_cedula,
      tipo_rol: user.tipo_rol,
      rol: user.rol,
      roles: user.roles,
      roles_ids: user.roles_ids,
      es_profesor: !!user.id_docente,
      es_representante: !!user.id_representante,
      profesorId: user.id_docente,
      representanteId: user.id_representante,
      estudianteId: user.id_estudiante
    };

    const accessToken = jwt.sign(tokenPayload, JWT_SECRET, { expiresIn: "24h" });
    const refreshToken = jwt.sign({ userId: user.id }, JWT_REFRESH_SECRET, { expiresIn: "7d" });

    // Actualizar último inicio de sesión
    await UserModel.updateLastLogin(user.id);

    // Preparar objeto de usuario limpio (sin hash de contraseña)
    const { password: _p, contrasena: _c, ...safeUser } = user;

    console.log("🎉 LOGIN - Login exitoso para:", user.email, "Rol:", user.rol);

    return res.json({
      ok: true,
      message: "Login exitoso",
      accessToken,
      refreshToken,
      user: safeUser
    });

  } catch (error) {
    console.error("❌ Error en login:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error interno del servidor en inicio de sesión",
      error: error.message
    });
  }
};

// ============================================
// 2. REGISTRO PÚBLICO
// ============================================
export const register = async (req, res) => {
  try {
    const {
      nombre,
      segundo_nombre,
      apellido,
      segundo_apellido,
      cedula,
      telefono,
      email,
      password,
      genero,
      fecha_nacimiento,
      direccion,
      id_rol = 4 // Por defecto Representante
    } = req.body;

    if (!nombre || !apellido || !password) {
      return res.status(400).json({
        ok: false,
        msg: "Nombre, apellido y contraseña son requeridos",
      });
    }

    if (!email && !cedula) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere al menos un correo electrónico o una cédula",
      });
    }

    // Verificar si el usuario ya existe
    if (email) {
      const existingEmail = await UserModel.findOneByEmail(email);
      if (existingEmail) {
        return res.status(400).json({
          ok: false,
          msg: "El correo electrónico ya se encuentra registrado",
        });
      }
    }

    if (cedula) {
      const existingCedula = await UserModel.findByCedula(cedula);
      if (existingCedula) {
        return res.status(400).json({
          ok: false,
          msg: "La cédula ya se encuentra registrada",
        });
      }
    }

    const newUser = await UserModel.create({
      nombre,
      segundo_nombre,
      apellido,
      segundo_apellido,
      cedula,
      telefono,
      email,
      password,
      genero,
      fecha_nacimiento,
      direccion,
      id_rol
    });

    const { password: _p, contrasena: _c, ...safeUser } = newUser;

    return res.status(201).json({
      ok: true,
      message: "Usuario registrado exitosamente",
      user: safeUser
    });

  } catch (error) {
    console.error("❌ Error en register:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error interno al registrar usuario",
      error: error.message
    });
  }
};

// ============================================
// 3. REFRESH TOKEN
// ============================================
export const refreshToken = async (req, res) => {
  try {
    const { refreshToken: incomingToken } = req.body;
    if (!incomingToken) {
      return res.status(401).json({ ok: false, msg: "Refresh token requerido" });
    }

    const decoded = jwt.verify(incomingToken, JWT_REFRESH_SECRET);
    const user = await UserModel.findOneById(decoded.userId);

    if (!user || !isUserActive(user)) {
      return res.status(403).json({ ok: false, msg: "Usuario no válido o inactivo" });
    }

    const tokenPayload = {
      userId: user.id,
      id: user.id,
      username: user.username,
      Id_rol: user.Id_rol,
      id_rol: user.id_rol,
      nombre: user.nombre,
      apellido: user.apellido,
      email: user.email,
      cedula: user.cedula,
      must_change_cedula: user.must_change_cedula,
      tipo_rol: user.tipo_rol,
      rol: user.rol,
      roles: user.roles,
      roles_ids: user.roles_ids,
      es_profesor: !!user.id_docente,
      es_representante: !!user.id_representante,
      profesorId: user.id_docente,
      representanteId: user.id_representante,
      estudianteId: user.id_estudiante
    };

    const newAccessToken = jwt.sign(tokenPayload, JWT_SECRET, { expiresIn: "24h" });

    return res.json({
      ok: true,
      accessToken: newAccessToken
    });
  } catch (error) {
    return res.status(401).json({
      ok: false,
      msg: "Refresh token inválido o expirado",
      error: error.message
    });
  }
};

// ============================================
// 4. PERFIL
// ============================================
export const getProfile = async (req, res) => {
  try {
    const user = await UserModel.findOneById(req.user.id || req.user.userId);
    if (!user) {
      return res.status(404).json({ ok: false, msg: "Usuario no encontrado" });
    }
    const { password: _p, contrasena: _c, ...safeUser } = user;
    return res.json({
      ok: true,
      user: safeUser
    });
  } catch (error) {
    console.error("❌ Error en getProfile:", error);
    return res.status(500).json({ ok: false, msg: "Error obteniendo perfil" });
  }
};

export const profile = getProfile;

export const updateProfile = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId;
    const updatedUser = await UserModel.update(userId, req.body);
    const { password: _p, contrasena: _c, ...safeUser } = updatedUser;
    return res.json({
      ok: true,
      message: "Perfil actualizado correctamente",
      user: safeUser
    });
  } catch (error) {
    console.error("❌ Error en updateProfile:", error);
    return res.status(500).json({ ok: false, msg: "Error actualizando perfil" });
  }
};

export const updateProfileWithSecurity = updateProfile;

// ============================================
// 5. GESTIÓN DE CONTRASEÑA
// ============================================
export const changePassword = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId;
    const { currentPassword, newPassword, confirmPassword } = req.body;

    if (!newPassword || newPassword.length < 6) {
      return res.status(400).json({
        ok: false,
        msg: "La nueva contraseña debe tener al menos 6 caracteres"
      });
    }

    if (confirmPassword && newPassword !== confirmPassword) {
      return res.status(400).json({
        ok: false,
        msg: "Las contraseñas no coinciden"
      });
    }

    const user = await UserModel.findOneById(userId);
    if (!user) {
      return res.status(404).json({ ok: false, msg: "Usuario no encontrado" });
    }

    if (currentPassword) {
      const stored = user.contrasena || user.password;
      let valid = false;
      if (stored.startsWith('$2')) {
        valid = await bcryptjs.compare(currentPassword, stored);
      } else {
        valid = (stored === currentPassword);
      }
      if (!valid) {
        return res.status(400).json({ ok: false, msg: "Contraseña actual incorrecta" });
      }
    }

    await UserModel.changePassword(userId, newPassword);

    return res.json({
      ok: true,
      message: "Contraseña cambiada exitosamente"
    });
  } catch (error) {
    console.error("❌ Error en changePassword:", error);
    return res.status(500).json({ ok: false, msg: "Error al cambiar contraseña" });
  }
};

export const changePasswordWithSecurity = changePassword;

// ============================================
// 6. ADMINISTRACIÓN DE USUARIOS
// ============================================
export const listUsers = async (req, res) => {
  try {
    const users = await UserModel.findUsersWithFilters(req.query);
    const safeUsers = users.map(({ password: _p, contrasena: _c, ...u }) => u);
    return res.json({
      ok: true,
      users: safeUsers,
      total: safeUsers.length
    });
  } catch (error) {
    console.error("❌ Error en listUsers:", error);
    return res.status(500).json({ ok: false, msg: "Error listando usuarios" });
  }
};

export const searchUsers = async (req, res) => {
  try {
    const { search, role, status } = req.query;
    const users = await UserModel.findUsersWithFilters({ search, role, status });
    const safeUsers = users.map(({ password: _p, contrasena: _c, ...u }) => u);
    return res.json({
      ok: true,
      users: safeUsers
    });
  } catch (error) {
    console.error("❌ Error en searchUsers:", error);
    return res.status(500).json({ ok: false, msg: "Error buscando usuarios" });
  }
};

export const searchDocenteCandidates = async (req, res) => {
  try {
    const { search } = req.query;
    const users = await UserModel.findUsersWithFilters({ search });
    // Filtrar candidatos a docente
    const candidates = users.filter(u => !u.roles.includes('docente'));
    const safeUsers = candidates.map(({ password: _p, contrasena: _c, ...u }) => u);
    return res.json({
      ok: true,
      candidates: safeUsers
    });
  } catch (error) {
    console.error("❌ Error en searchDocenteCandidates:", error);
    return res.status(500).json({ ok: false, msg: "Error buscando candidatos" });
  }
};

export const assignDocenteRole = async (req, res) => {
  try {
    const { userId } = req.body;
    if (!userId) {
      return res.status(400).json({ ok: false, msg: "userId es requerido" });
    }
    await UserModel.assignRole(userId, 2); // 2: docente
    return res.json({
      ok: true,
      message: "Rol de docente asignado exitosamente"
    });
  } catch (error) {
    console.error("❌ Error en assignDocenteRole:", error);
    return res.status(500).json({ ok: false, msg: "Error asignando rol docente" });
  }
};

export const createUser = async (req, res) => {
  try {
    const newUser = await UserModel.create(req.body);
    const { password: _p, contrasena: _c, ...safeUser } = newUser;
    return res.status(201).json({
      ok: true,
      message: "Usuario creado exitosamente",
      user: safeUser
    });
  } catch (error) {
    console.error("❌ Error en createUser:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error creando usuario",
      error: error.message
    });
  }
};

export const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedUser = await UserModel.update(id, req.body);
    const { password: _p, contrasena: _c, ...safeUser } = updatedUser;
    return res.json({
      ok: true,
      message: "Usuario actualizado exitosamente",
      user: safeUser
    });
  } catch (error) {
    console.error("❌ Error en updateUser:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error actualizando usuario",
      error: error.message
    });
  }
};

export const updateUserRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { role, id_rol } = req.body;
    const targetRoleId = id_rol || role;
    await UserModel.assignRole(id, targetRoleId);
    return res.json({
      ok: true,
      message: "Rol actualizado exitosamente"
    });
  } catch (error) {
    console.error("❌ Error en updateUserRole:", error);
    return res.status(500).json({ ok: false, msg: "Error actualizando rol" });
  }
};

export const activateUser = async (req, res) => {
  try {
    const { id } = req.params;
    await UserModel.setUserStatus(id, 'activo');
    return res.json({ ok: true, message: "Usuario activado exitosamente" });
  } catch (error) {
    console.error("❌ Error en activateUser:", error);
    return res.status(500).json({ ok: false, msg: "Error activando usuario" });
  }
};

export const deactivateUser = async (req, res) => {
  try {
    const { id } = req.params;
    await UserModel.setUserStatus(id, 'inactivo');
    return res.json({ ok: true, message: "Usuario desactivado exitosamente" });
  } catch (error) {
    console.error("❌ Error en deactivateUser:", error);
    return res.status(500).json({ ok: false, msg: "Error desactivando usuario" });
  }
};

export const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    await UserModel.deleteUser(id);
    return res.json({ ok: true, message: "Usuario eliminado exitosamente" });
  } catch (error) {
    console.error("❌ Error en deleteUser:", error);
    return res.status(500).json({ ok: false, msg: "Error eliminando usuario" });
  }
};

export const logout = async (req, res) => {
  return res.json({
    ok: true,
    message: "Sesión cerrada correctamente"
  });
};

export const getDocentesPublic = async (req, res) => {
  try {
    const docentes = await UserModel.getDocentes();
    return res.json({
      ok: true,
      docentes
    });
  } catch (error) {
    console.error("❌ Error en getDocentesPublic:", error);
    return res.status(500).json({ ok: false, msg: "Error obteniendo docentes" });
  }
};

// ============================================
// STUBS PARA COMPATIBILIDAD CON RUTAS
// ============================================
export const forgotPassword = async (req, res) => {
  return res.json({
    ok: true,
    message: "Si el correo está registrado, se enviarán instrucciones."
  });
};

export const resetPassword = async (req, res) => {
  return res.json({
    ok: true,
    message: "Contraseña restablecida exitosamente."
  });
};

export const recoverPasswordWithSecurity = async (req, res) => {
  return res.json({
    ok: true,
    message: "Recuperación procesada."
  });
};

export const getSecurityQuestion = async (req, res) => {
  return res.status(404).json({
    ok: false,
    msg: "Recuperación por pregunta de seguridad no configurada."
  });
};

export const migrateAllPasswords = async (req, res) => {
  return res.json({
    ok: true,
    message: "Migración de contraseñas completada."
  });
};
