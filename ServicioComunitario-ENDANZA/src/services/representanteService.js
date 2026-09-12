// frontend/src/services/representanteService.js
import { helpFetch } from '../api/helpFetch';

const fetch = helpFetch();

export const representanteAPI = {
  // Crear representante con estudiantes (desde preinscripción)
  createFromPreinscripcion: (data) =>
    fetch.post('/api/representantes/preinscripcion', data),

  // Obtener representante con sus estudiantes
  getConEstudiantes: (id) =>
    fetch.get(`/api/representantes/${id}/estudiantes`),

  // Buscar representantes por término
  search: (term) =>
    fetch.get(`/api/representantes/search?term=${encodeURIComponent(term)}`),

  // Listar TODOS los representantes (NUEVO)
  list: () =>
    fetch.get('/api/representantes/list')
};

// Funciones para usar en componentes
export const createRepresentanteConEstudiantes = async (data) => {
  try {
    const response = await representanteAPI.createFromPreinscripcion(data);

    if (response && response.ok === true) {
      return response;
    }

    if (response && response.msg) {
      throw new Error(response.msg);
    }

    throw new Error('Error al crear representante');
  } catch (error) {
    console.error('❌ Error en createRepresentanteConEstudiantes:', error);

    if (error.response?.data?.msg) {
      throw new Error(error.response.data.msg);
    }

    throw error;
  }
};

export const getRepresentanteConEstudiantes = async (id) => {
  try {
    const response = await representanteAPI.getConEstudiantes(id);
    if (response && response.ok) {
      return response;
    }
    return null;
  } catch (error) {
    console.error('❌ Error en getRepresentanteConEstudiantes:', error);
    return null;
  }
};

export const searchRepresentantes = async (term) => {
  try {
    const response = await representanteAPI.search(term);
    if (response && response.ok) {
      return response.representantes || [];
    }
    return [];
  } catch (error) {
    console.error('❌ Error en searchRepresentantes:', error);
    return [];
  }
};

export const listRepresentantes = async () => {
  try {
    const response = await representanteAPI.list();
    console.log("📥 listRepresentantes - Respuesta:", response);

    if (response && response.ok) {
      return response.representantes || [];
    }
    return [];
  } catch (error) {
    console.error('❌ Error en listRepresentantes:', error);
    return [];
  }
};

// Obtener lista pública de docentes para vinculación de rol dual en preinscripción
export const getDocentesList = async () => {
  try {
    const response = await fetch.get('/api/users/docentes');
    if (response && response.ok) {
      return response.docentes || [];
    }
    return [];
  } catch (error) {
    console.error('❌ Error en getDocentesList:', error);
    return [];
  }
};