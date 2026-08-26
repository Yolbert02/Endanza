// Archivo: backend/controllers/promocion.controller.js

import { PromocionModel } from "../models/promocion.model.js";

// ============================================
// CONTROLADOR DE PROMOCIÓN ANTICIPADA Y ACTAS
// ============================================

/**
 * GET /api/promocion/candidatos?academicYearId=X&minPromedio=18
 * Obtiene estudiantes con notas sobresalientes en el 1er Lapso
 */
const getCandidatos = async (req, res) => {
  try {
    const { academicYearId, minPromedio } = req.query;

    if (!academicYearId) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere academicYearId"
      });
    }

    const minScore = minPromedio ? parseFloat(minPromedio) : 18.0;
    const candidatos = await PromocionModel.findCandidates(parseInt(academicYearId), minScore);

    return res.json({
      ok: true,
      data: candidatos,
      total: candidatos.length,
      criterioMinimo: minScore
    });
  } catch (error) {
    console.error("Error en getCandidatos:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener candidatos a promoción anticipada",
      error: error.message
    });
  }
};

/**
 * GET /api/promocion/actas?academicYearId=X
 * Lista todas las actas de promoción emitidas
 */
const getActas = async (req, res) => {
  try {
    const { academicYearId } = req.query;

    const actas = await PromocionModel.findAll(
      academicYearId ? parseInt(academicYearId) : null
    );

    return res.json({
      ok: true,
      data: actas,
      total: actas.length
    });
  } catch (error) {
    console.error("Error en getActas:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener actas de promoción",
      error: error.message
    });
  }
};

/**
 * GET /api/promocion/actas/:id
 * Detalle completo de un acta para visualización o impresión
 */
const getActaById = async (req, res) => {
  try {
    const { id } = req.params;

    const acta = await PromocionModel.findById(parseInt(id));

    if (!acta) {
      return res.status(404).json({
        ok: false,
        msg: "Acta de promoción no encontrada"
      });
    }

    return res.json({
      ok: true,
      data: acta
    });
  } catch (error) {
    console.error("Error en getActaById:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener el acta de promoción",
      error: error.message
    });
  }
};

/**
 * POST /api/promocion/actas
 * Emite un Acta Oficial de Promoción Anticipada y promueve al estudiante
 */
const crearActa = async (req, res) => {
  try {
    const {
      numeroActa,
      studentId,
      academicYearId,
      originGradeId,
      targetGradeId,
      promedioLapso1,
      motivo,
      resolucion,
      autoridades,
      fechaSesion
    } = req.body;

    if (!studentId || !academicYearId || !originGradeId || !targetGradeId || !motivo) {
      return res.status(400).json({
        ok: false,
        msg: "Faltan campos obligatorios para emitir el acta (studentId, academicYearId, originGradeId, targetGradeId, motivo)"
      });
    }

    const nuevaActa = await PromocionModel.createActaAndPromote({
      numeroActa,
      studentId: parseInt(studentId),
      academicYearId: parseInt(academicYearId),
      originGradeId: parseInt(originGradeId),
      targetGradeId: parseInt(targetGradeId),
      promedioLapso1: parseFloat(promedioLapso1) || 20.0,
      motivo,
      resolucion,
      autoridades,
      fechaSesion,
      creadoPor: req.user?.id || null
    });

    return res.status(201).json({
      ok: true,
      msg: `Acta N° ${nuevaActa.numero_acta} emitida y promoción formalizada exitosamente.`,
      data: nuevaActa
    });
  } catch (error) {
    console.error("Error en crearActa:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al emitir acta de promoción anticipada",
      error: error.message
    });
  }
};

/**
 * PUT /api/promocion/actas/:id/anular
 * Anular un acta de promoción
 */
const anularActa = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await PromocionModel.anularActa(parseInt(id));

    if (!result) {
      return res.status(404).json({
        ok: false,
        msg: "Acta no encontrada"
      });
    }

    return res.json({
      ok: true,
      msg: "Acta anulada exitosamente",
      data: result
    });
  } catch (error) {
    console.error("Error en anularActa:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al anular acta de promoción",
      error: error.message
    });
  }
};

export const PromocionController = {
  getCandidatos,
  getActas,
  getActaById,
  crearActa,
  anularActa
};
