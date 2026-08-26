// Archivo: backend/controllers/revision.controller.js

import { RevisionModel } from "../models/revision.model.js";

// ============================================
// CONTROLADOR DE REVISIÓN DE MATERIA
// ============================================

/**
 * GET /api/revisiones?academicYearId=X
 * Obtener todas las revisiones de un año académico
 */
const getRevisiones = async (req, res) => {
  try {
    const { academicYearId } = req.query;

    if (!academicYearId) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere academicYearId"
      });
    }

    const revisiones = await RevisionModel.findByAcademicYear(parseInt(academicYearId));

    return res.json({
      ok: true,
      data: revisiones,
      total: revisiones.length
    });
  } catch (error) {
    console.error("Error en getRevisiones:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener revisiones",
      error: error.message
    });
  }
};

/**
 * GET /api/revisiones/estudiante/:studentId?academicYearId=X
 * Obtener revisiones de un estudiante específico
 */
const getRevisionesByStudent = async (req, res) => {
  try {
    const { studentId } = req.params;
    const { academicYearId } = req.query;

    const revisiones = await RevisionModel.findByStudent(
      parseInt(studentId),
      academicYearId ? parseInt(academicYearId) : null
    );

    return res.json({
      ok: true,
      data: revisiones,
      total: revisiones.length
    });
  } catch (error) {
    console.error("Error en getRevisionesByStudent:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener revisiones del estudiante",
      error: error.message
    });
  }
};

/**
 * POST /api/revisiones
 * Crear una revisión manualmente
 * Body: { studentId, subjectId, academicYearId, notaDefinitiva }
 */
const createRevision = async (req, res) => {
  try {
    const { studentId, subjectId, academicYearId, notaDefinitiva } = req.body;

    if (!studentId || !subjectId || !academicYearId || notaDefinitiva === undefined) {
      return res.status(400).json({
        ok: false,
        msg: "Se requieren studentId, subjectId, academicYearId y notaDefinitiva"
      });
    }

    if (parseFloat(notaDefinitiva) >= 10) {
      return res.status(400).json({
        ok: false,
        msg: "No se puede crear revisión para una materia aprobada (nota >= 10)"
      });
    }

    const revision = await RevisionModel.create({
      studentId: parseInt(studentId),
      subjectId: parseInt(subjectId),
      academicYearId: parseInt(academicYearId),
      notaDefinitiva: parseFloat(notaDefinitiva),
      creadoPor: req.user?.id || null
    });

    return res.status(201).json({
      ok: true,
      msg: "Revisión creada exitosamente",
      data: revision
    });
  } catch (error) {
    console.error("Error en createRevision:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al crear revisión",
      error: error.message
    });
  }
};

/**
 * PUT /api/revisiones/:id
 * Cargar la nota de revisión
 * Body: { notaRevision, observacion }
 */
const updateNotaRevision = async (req, res) => {
  try {
    const { id } = req.params;
    const { notaRevision, observacion } = req.body;

    if (notaRevision === undefined || notaRevision === null) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere notaRevision"
      });
    }

    const nota = parseFloat(notaRevision);
    if (isNaN(nota) || nota < 0 || nota > 20) {
      return res.status(400).json({
        ok: false,
        msg: "La nota de revisión debe ser un número entre 0 y 20"
      });
    }

    const revision = await RevisionModel.updateNotaRevision(
      parseInt(id),
      nota,
      observacion || null
    );

    if (!revision) {
      return res.status(404).json({
        ok: false,
        msg: "Revisión no encontrada"
      });
    }

    return res.json({
      ok: true,
      msg: `Nota de revisión cargada. Estado: ${revision.estado.toUpperCase()}`,
      data: revision
    });
  } catch (error) {
    console.error("Error en updateNotaRevision:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al actualizar nota de revisión",
      error: error.message
    });
  }
};

/**
 * POST /api/revisiones/auto-detectar
 * Auto-detectar estudiantes que necesitan revisión
 * Body: { academicYearId }
 */
const autoDetectRevisiones = async (req, res) => {
  try {
    const { academicYearId } = req.body;

    if (!academicYearId) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere academicYearId"
      });
    }

    const resultado = await RevisionModel.autoDetect(
      parseInt(academicYearId),
      req.user?.id || null
    );

    return res.json({
      ok: true,
      msg: `Se detectaron ${resultado.total_detectados} materias reprobadas. ${resultado.creados} nuevas revisiones creadas, ${resultado.actualizados} actualizadas.`,
      data: resultado
    });
  } catch (error) {
    console.error("Error en autoDetectRevisiones:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al auto-detectar revisiones",
      error: error.message
    });
  }
};

/**
 * DELETE /api/revisiones/:id
 * Eliminar una revisión
 */
const deleteRevision = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await RevisionModel.remove(parseInt(id));

    if (!deleted) {
      return res.status(404).json({
        ok: false,
        msg: "Revisión no encontrada"
      });
    }

    return res.json({
      ok: true,
      msg: "Revisión eliminada exitosamente"
    });
  } catch (error) {
    console.error("Error en deleteRevision:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al eliminar revisión",
      error: error.message
    });
  }
};

export const RevisionController = {
  getRevisiones,
  getRevisionesByStudent,
  createRevision,
  updateNotaRevision,
  autoDetectRevisiones,
  deleteRevision
};
