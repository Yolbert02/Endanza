import express from "express";
import { EspecialidadController } from "../controllers/especialidad.controller.js";
import { verifyToken } from "../middlewares/jwt.middleware.js";
import { verifyRole } from "../middlewares/role.middleware.js";

const router = express.Router();

// Listado de especialidades
router.get("/", EspecialidadController.listAll);

// Verificar si un grado específico requiere especialidad
router.get("/requerida/:grado", EspecialidadController.checkRequired);

// Obtener por ID
router.get("/:id", EspecialidadController.getById);

// Rutas administrativas (solo admin)
router.post("/", verifyToken, verifyRole(['admin']), EspecialidadController.create);
router.put("/:id", verifyToken, verifyRole(['admin']), EspecialidadController.update);

export default router;
