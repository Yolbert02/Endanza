// Archivo: backend/routes/promocion.routes.js
import express from "express";
import { PromocionController } from "../controllers/promocion.controller.js";
import { verifyToken } from "../middlewares/jwt.middleware.js";
import { verifyAdmin } from "../middlewares/jwt.middleware.js";
import { autoVerifyRole } from "../middlewares/role.middleware.js";

const router = express.Router();

// GET /api/promocion/candidatos — Estudiantes elegibles en Lapso 1
router.get("/candidatos", verifyToken, verifyAdmin, autoVerifyRole, PromocionController.getCandidatos);

// GET /api/promocion/actas — Listado de actas emitidas
router.get("/actas", verifyToken, autoVerifyRole, PromocionController.getActas);

// GET /api/promocion/actas/:id — Detalle del acta imprimible
router.get("/actas/:id", verifyToken, autoVerifyRole, PromocionController.getActaById);

// POST /api/promocion/actas — Emitir acta y promover
router.post("/actas", verifyToken, verifyAdmin, autoVerifyRole, PromocionController.crearActa);

// PUT /api/promocion/actas/:id/anular — Anular acta
router.put("/actas/:id/anular", verifyToken, verifyAdmin, autoVerifyRole, PromocionController.anularActa);

export default router;
