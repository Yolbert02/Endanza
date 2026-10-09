import { helpFetch } from '../api/helpFetch';

const fetch = helpFetch();

/**
 * Obtiene todas las especialidades activas desde el backend
 * @returns {Promise<Array>} Lista de especialidades con id y name
 */
export const listSpecialties = async () => {
  try {
    const response = await fetch.get('/api/especialidades');
    if (response.ok && (response.data || response.specialties)) {
      return response.data || response.specialties;
    }
    return [];
  } catch (error) {
    console.error("Error en listSpecialties:", error);
    return [];
  }
};

/**
 * Verifica si un grado requiere especialidad
 * @param {string} grado - Nombre del grado (ej: "6to Grado")
 * @returns {Promise<boolean>}
 */
export const checkSpecialtyRequired = async (grado) => {
  try {
    const response = await fetch.get(`/api/especialidades/requerida/${encodeURIComponent(grado)}`);
    if (response.ok) {
      return response.required || false;
    }
    return false;
  } catch (error) {
    console.error("Error en checkSpecialtyRequired:", error);
    return false;
  }
};
