// backend/routes/user.routes.js
import express from "express";
import {
  register,
  login,
  refreshToken,
  forgotPassword,
  resetPassword,
  recoverPasswordWithSecurity,
  getSecurityQuestion,
  migrateAllPasswords,
  listUsers,
  searchUsers,
  getProfile,
  profile,
  updateProfile,
  updateProfileWithSecurity,
  changePassword,
  changePasswordWithSecurity,
  logout,
  createUser,
  updateUser,
  updateUserRole,
  activateUser,
  deactivateUser,
  deleteUser
} from "../controllers/user.controller.js";
import { verifyToken, verifyAdmin } from "../middlewares/jwt.middleware.js";
import { autoVerifyRole } from "../middlewares/role.middleware.js";

const router = express.Router();

// ============================================
// RUTAS PÚBLICAS (sin autenticación)
// ============================================
router.post("/register", register);
router.post("/login", login);
router.post("/refresh-token", refreshToken);
router.post("/forgot-password", forgotPassword);
router.post("/reset-password", resetPassword);
router.post("/recover-password-security", recoverPasswordWithSecurity);
router.get("/security-question/:username", getSecurityQuestion);

// ============================================
// RUTAS PROTEGIDAS CON AUTENTICACIÓN + AUTORIZACIÓN
// ============================================
// Migración de passwords (solo admin - doble protección)
router.post("/migrate-passwords", verifyToken, verifyAdmin, autoVerifyRole, migrateAllPasswords);

// Rutas que requieren autenticación + verificación automática de roles
router.get("/list", verifyToken, autoVerifyRole, listUsers);
router.get("/search", verifyToken, autoVerifyRole, searchUsers);
router.get("/profile", verifyToken, autoVerifyRole, getProfile);
router.put("/profile", verifyToken, autoVerifyRole, updateProfile);
router.put("/profile/security", verifyToken, autoVerifyRole, updateProfileWithSecurity);
router.put("/change-password", verifyToken, autoVerifyRole, changePassword);
router.put("/change-password/security", verifyToken, autoVerifyRole, changePasswordWithSecurity);

// Logout (requiere token válido)
router.post("/logout", verifyToken, autoVerifyRole, logout);

router.post("/create", verifyToken, verifyAdmin, autoVerifyRole, createUser); 
router.put("/:id", verifyToken, verifyAdmin, autoVerifyRole, updateUser);   
router.put("/:id/role", verifyToken, verifyAdmin, autoVerifyRole, updateUserRole); 
router.put("/activate/:id", verifyToken, verifyAdmin, autoVerifyRole, activateUser);
router.put("/deactivate/:id", verifyToken, verifyAdmin, autoVerifyRole, deactivateUser);
router.delete("/:id", verifyToken, verifyAdmin, autoVerifyRole, deleteUser);

export default router;