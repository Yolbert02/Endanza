// Archivo: backend/routes/revision.routes.js
import express from "express";
import { RevisionController } from "../controllers/revision.controller.js";
import { verifyToken } from "../middlewares/jwt.middleware.js";
import { verifyAdmin } from "../middlewares/jwt.middleware.js";
import { autoVerifyRole } from "../middlewares/role.middleware.js";

const router = express.Router();

// GET /api/revisiones?academicYearId=X — Listar revisiones
router.get("/", verifyToken, verifyAdmin, autoVerifyRole, RevisionController.getRevisiones);

// GET /api/revisiones/estudiante/:studentId — Revisiones por estudiante
router.get("/estudiante/:studentId", verifyToken, autoVerifyRole, RevisionController.getRevisionesByStudent);

// POST /api/revisiones — Crear revisión manualmente
router.post("/", verifyToken, verifyAdmin, autoVerifyRole, RevisionController.createRevision);

// PUT /api/revisiones/:id — Cargar nota de revisión
router.put("/:id", verifyToken, verifyAdmin, autoVerifyRole, RevisionController.updateNotaRevision);

// POST /api/revisiones/auto-detectar — Auto-detectar revisiones
router.post("/auto-detectar", verifyToken, verifyAdmin, autoVerifyRole, RevisionController.autoDetectRevisiones);

// DELETE /api/revisiones/:id — Eliminar revisión
router.delete("/:id", verifyToken, verifyAdmin, autoVerifyRole, RevisionController.deleteRevision);

export default router;
