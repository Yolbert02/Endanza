import { helpFetch } from '../api/helpFetch';

const fetch = helpFetch();

/**
 * Inscribe a un estudiante con todos sus datos completos
 * @param {Object} data - Datos completos de la inscripción
 * @returns {Promise<Object>}
 */
export const inscribirEstudiante = async (data) => {
  try {
    // Validar que tenemos los datos necesarios
    if (!data.id_estudiante) {
      throw new Error("ID del estudiante es requerido");
    }
    
    if (!data.id_ano_academico) {
      throw new Error("Año académico es requerido");
    }

    console.log("📤 Enviando inscripción completa:", {
      id_estudiante: data.id_estudiante,
      id_ano_academico: data.id_ano_academico
    });

    // El backend espera: { id_estudiante, id_ano_academico, datos_completos }
    const response = await fetch.post('/api/inscripciones/completar', {
      id_estudiante: data.id_estudiante,
      id_ano_academico: data.id_ano_academico,
      datos_completos: data.datos_completos
    });

    console.log("📦 Respuesta completa de inscripción:", response);
    
    // helpFetch devuelve el JSON del backend directamente
    // El backend devuelve { ok: true/false, msg, data }
    // helpFetch añade _ok (HTTP status ok) y _status
    const isOk = response.ok || response._ok;
    
    if (isOk) {
      // Los datos vienen en response.data (del JSON del backend)
      return response.data || response;
    } else {
      const detail = response.error ? ` (${response.error})` : '';
      const errorMsg = (response.msg || response.message || 'Error al procesar la inscripción') + detail;
      console.error("❌ Error del servidor:", errorMsg, response);
      throw new Error(errorMsg);
    }
  } catch (error) {
    console.error("❌ Error en inscribirEstudiante:", error);
    throw error;
  }
};

/**
 * Verifica si un estudiante ya está inscrito en el año actual
 * @param {number} studentId - ID del estudiante
 * @param {number} academicYearId - ID del año académico
 * @returns {Promise<{inscrito: boolean, seccion?: string, id_seccion?: number}>}
 */
export const verificarInscripcionEstudiante = async (studentId, academicYearId) => {
  try {
    const response = await fetch.get(`/api/inscripciones/verificar/${studentId}?ano=${academicYearId}`);
    
    if (response.ok || response._ok) {
      const payload = response.data || response;
      const data = payload.data || payload;
      return {
        inscrito: data.inscrito === true,
        seccion: data.seccion || null,
        id_seccion: data.id_seccion || null
      };
    }
    return { inscrito: false };
  } catch (error) {
    console.error("Error verificando inscripción:", error);
    return { inscrito: false };
  }
};

/**
 * Obtiene los datos precargados del estudiante y su representante para el formulario
 * @param {number} studentId - ID del estudiante
 * @param {number} academicYearId - ID del año académico (opcional)
 * @returns {Promise<Object>}
 */
export const obtenerDatosPrecargaEstudiante = async (studentId, academicYearId = null) => {
  try {
    const url = academicYearId 
      ? `/api/inscripciones/precargar/${studentId}?ano=${academicYearId}`
      : `/api/inscripciones/precargar/${studentId}`;
    
    const response = await fetch.get(url);
    const isOk = response.ok || response._ok;

    if (isOk) {
      return response.data || response;
    } else {
      const errorMsg = response.msg || response.message || 'Error al obtener datos de inscripción';
      console.error("❌ Error del servidor en precarga:", errorMsg);
      throw new Error(errorMsg);
    }
  } catch (error) {
    console.error("❌ Error en obtenerDatosPrecargaEstudiante:", error);
    throw error;
  }
};