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
      const errorMsg = response.msg || response.message || 'Error al procesar la inscripción';
      console.error("❌ Error del servidor:", errorMsg);
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
 * @returns {Promise<boolean>}
 */
export const verificarInscripcionEstudiante = async (studentId, academicYearId) => {
  try {
    const response = await fetch.get(`/api/inscripciones/verificar/${studentId}?ano=${academicYearId}`);
    
    if (response.ok && response.data) {
      return response.data.data?.inscrito || false;
    }
    return false;
  } catch (error) {
    console.error("Error verificando inscripción:", error);
    return false;
  }
};