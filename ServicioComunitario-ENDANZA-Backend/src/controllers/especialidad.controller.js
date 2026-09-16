import { EspecialidadModel } from "../models/especialidad.model.js";

export const EspecialidadController = {
  /**
   * Listar todas las especialidades activas
   */
  listAll: async (req, res) => {
    try {
      const activeOnly = req.query.all !== 'true';
      const specialties = await EspecialidadModel.findAll(activeOnly);
      return res.json({
        ok: true,
        specialties,
        data: specialties,
        total: specialties.length
      });
    } catch (error) {
      console.error("❌ Error en EspecialidadController.listAll:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al obtener especialidades",
        error: error.message
      });
    }
  },

  /**
   * Obtener especialidad por ID
   */
  getById: async (req, res) => {
    try {
      const { id } = req.params;
      const specialty = await EspecialidadModel.findById(id);
      if (!specialty) {
        return res.status(404).json({
          ok: false,
          msg: "Especialidad no encontrada"
        });
      }
      return res.json({
        ok: true,
        data: specialty,
        specialty
      });
    } catch (error) {
      console.error("❌ Error en EspecialidadController.getById:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al obtener especialidad",
        error: error.message
      });
    }
  },

  /**
   * Verificar si un grado específico requiere especialidad (6to, 7mo u 8vo)
   */
  checkRequired: async (req, res) => {
    try {
      const { grado } = req.params;
      const required = EspecialidadModel.isSpecialtyRequired(grado);
      return res.json({
        ok: true,
        grado,
        required,
        msg: required
          ? "Este grado requiere selección de especialidad"
          : "Este grado no requiere especialidad obligatoria"
      });
    } catch (error) {
      console.error("❌ Error en EspecialidadController.checkRequired:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al verificar requerimiento de especialidad",
        error: error.message
      });
    }
  },

  /**
   * Crear nueva especialidad (Admin)
   */
  create: async (req, res) => {
    try {
      const { nombre_especialidad, descripcion, area } = req.body;
      if (!nombre_especialidad) {
        return res.status(400).json({
          ok: false,
          msg: "El nombre de la especialidad es requerido"
        });
      }

      const existing = await EspecialidadModel.findByName(nombre_especialidad);
      if (existing) {
        return res.status(400).json({
          ok: false,
          msg: "Ya existe una especialidad con ese nombre"
        });
      }

      const created = await EspecialidadModel.create({
        nombre_especialidad,
        descripcion,
        area
      });

      return res.status(201).json({
        ok: true,
        msg: "Especialidad creada exitosamente",
        data: created
      });
    } catch (error) {
      console.error("❌ Error en EspecialidadController.create:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al crear especialidad",
        error: error.message
      });
    }
  },

  /**
   * Actualizar especialidad (Admin)
   */
  update: async (req, res) => {
    try {
      const { id } = req.params;
      const { nombre_especialidad, descripcion, area, activo } = req.body;

      const existing = await EspecialidadModel.findById(id);
      if (!existing) {
        return res.status(404).json({
          ok: false,
          msg: "Especialidad no encontrada"
        });
      }

      const updated = await EspecialidadModel.update(id, {
        nombre_especialidad,
        descripcion,
        area,
        activo
      });

      return res.json({
        ok: true,
        msg: "Especialidad actualizada exitosamente",
        data: updated
      });
    } catch (error) {
      console.error("❌ Error en EspecialidadController.update:", error);
      return res.status(500).json({
        ok: false,
        msg: "Error al actualizar especialidad",
        error: error.message
      });
    }
  }
};
