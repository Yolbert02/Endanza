// Archivo: src/services/revisionService.js
import { helpFetch } from '../api/helpFetch';

const fetch = helpFetch();

/**
 * Obtiene todas las revisiones del año académico
 * @param {number} academicYearId
 * @returns {Promise<Array>}
 */
export const getRevisiones = async (academicYearId) => {
  try {
    const response = await fetch.get(`/api/revisiones?academicYearId=${academicYearId}`);
    if (response.ok && response.data) {
      return response.data;
    }
    return [];
  } catch (error) {
    console.error("Error en getRevisiones:", error);
    return [];
  }
};

/**
 * Obtiene las revisiones de un estudiante
 * @param {number} studentId
 * @param {number} academicYearId
 * @returns {Promise<Array>}
 */
export const getRevisionesByStudent = async (studentId, academicYearId = null) => {
  try {
    let endpoint = `/api/revisiones/estudiante/${studentId}`;
    if (academicYearId) {
      endpoint += `?academicYearId=${academicYearId}`;
    }
    const response = await fetch.get(endpoint);
    if (response.ok && response.data) {
      return response.data;
    }
    return [];
  } catch (error) {
    console.error("Error en getRevisionesByStudent:", error);
    return [];
  }
};

/**
 * Crea una revisión manualmente
 * @param {Object} data - { studentId, subjectId, academicYearId, notaDefinitiva }
 * @returns {Promise<Object>}
 */
export const createRevision = async (data) => {
  try {
    const response = await fetch.post('/api/revisiones', data);
    return response;
  } catch (error) {
    console.error("Error en createRevision:", error);
    throw error;
  }
};

/**
 * Carga la calificación obtenida en el examen de revisión
 * @param {number} revisionId
 * @param {Object} data - { notaRevision, observacion }
 * @returns {Promise<Object>}
 */
export const updateNotaRevision = async (revisionId, data) => {
  try {
    const response = await fetch.put(`/api/revisiones/${revisionId}`, data);
    return response;
  } catch (error) {
    console.error("Error en updateNotaRevision:", error);
    throw error;
  }
};

/**
 * Auto-detecta materias teóricas reprobadas en la definitiva general
 * @param {number} academicYearId
 * @returns {Promise<Object>}
 */
export const autoDetectRevisiones = async (academicYearId) => {
  try {
    const response = await fetch.post('/api/revisiones/auto-detectar', { academicYearId });
    return response;
  } catch (error) {
    console.error("Error en autoDetectRevisiones:", error);
    throw error;
  }
};

/**
 * Elimina una revisión
 * @param {number} revisionId
 * @returns {Promise<Object>}
 */
export const deleteRevision = async (revisionId) => {
  try {
    const response = await fetch.delete(`/api/revisiones/${revisionId}`);
    return response;
  } catch (error) {
    console.error("Error en deleteRevision:", error);
    throw error;
  }
};
