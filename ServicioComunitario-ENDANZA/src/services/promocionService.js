// Archivo: src/services/promocionService.js
import { helpFetch } from '../api/helpFetch';

const fetch = helpFetch();

/**
 * Obtiene los estudiantes candidatos a promoción anticipada en el 1er Lapso
 * @param {number} academicYearId
 * @param {number} minPromedio (opcional, default 18.0)
 * @returns {Promise<Array>}
 */
export const getCandidatosPromocion = async (academicYearId, minPromedio = 18.0) => {
  try {
    const response = await fetch.get(`/api/promocion/candidatos?academicYearId=${academicYearId}&minPromedio=${minPromedio}`);
    if (response.ok && response.data) {
      return response.data;
    }
    return [];
  } catch (error) {
    console.error("Error en getCandidatosPromocion:", error);
    return [];
  }
};

/**
 * Obtiene el libro de actas de promoción emitidas
 * @param {number} academicYearId (opcional)
 * @returns {Promise<Array>}
 */
export const getActasPromocion = async (academicYearId = null) => {
  try {
    let endpoint = '/api/promocion/actas';
    if (academicYearId) {
      endpoint += `?academicYearId=${academicYearId}`;
    }
    const response = await fetch.get(endpoint);
    if (response.ok && response.data) {
      return response.data;
    }
    return [];
  } catch (error) {
    console.error("Error en getActasPromocion:", error);
    return [];
  }
};

/**
 * Obtiene el detalle de un acta para previsualización o impresión
 * @param {number} actaId
 * @returns {Promise<Object|null>}
 */
export const getActaDetalle = async (actaId) => {
  try {
    const response = await fetch.get(`/api/promocion/actas/${actaId}`);
    if (response.ok && response.data) {
      return response.data;
    }
    return null;
  } catch (error) {
    console.error("Error en getActaDetalle:", error);
    return null;
  }
};

/**
 * Emite formalmente el Acta Oficial y promueve al estudiante de grado
 * @param {Object} data - { studentId, academicYearId, originGradeId, targetGradeId, promedioLapso1, motivo, resolucion, autoridades, fechaSesion }
 * @returns {Promise<Object>}
 */
export const emitirActaPromocion = async (data) => {
  try {
    const response = await fetch.post('/api/promocion/actas', data);
    return response;
  } catch (error) {
    console.error("Error en emitirActaPromocion:", error);
    throw error;
  }
};

/**
 * Anula un acta de promoción
 * @param {number} actaId
 * @returns {Promise<Object>}
 */
export const anularActaPromocion = async (actaId) => {
  try {
    const response = await fetch.put(`/api/promocion/actas/${actaId}/anular`);
    return response;
  } catch (error) {
    console.error("Error en anularActaPromocion:", error);
    throw error;
  }
};
