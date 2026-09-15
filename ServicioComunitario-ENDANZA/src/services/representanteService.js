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

// Grados oficiales de Endanza (usados en Preinscripción, Inscripción y Horarios)
export const GRADOS_ENDANZA = [
  { value: 'Preparatorio', label: 'Preparatorio' },
  { value: '1er Grado', label: '1er Grado' },
  { value: '2do Grado', label: '2do Grado' },
  { value: '3er Grado', label: '3er Grado' },
  { value: '4to Grado', label: '4to Grado' },
  { value: '5to Grado', label: '5to Grado' },
  { value: '6to Grado', label: '6to Grado' },
  { value: '7mo Grado', label: '7mo Grado' },
  { value: '8vo Grado', label: '8vo Grado' }
];

export const getGradosEndanza = async () => {
  try {
    let response = await fetch.get('/api/representantes/catalog/grades');
    if (!response?.ok) {
      response = await fetch.get('/api/teachers/catalog/grades');
    }
    if (response?.ok && Array.isArray(response.grades) && response.grades.length > 0) {
      const dbGrades = [];
      const seen = new Set();
      
      response.grades.forEach(g => {
        let baseName = g.name.replace('Año', 'Grado').split(' - ')[0].trim();
        if (!seen.has(baseName)) {
          seen.add(baseName);
          dbGrades.push({
            value: baseName,
            label: baseName,
            level: g.level,
            id: g.id
          });
        }
      });
      
      if (dbGrades.length > 0) {
        return dbGrades;
      }
    }
    return GRADOS_ENDANZA;
  } catch (error) {
    console.error('❌ Error en getGradosEndanza:', error);
    return GRADOS_ENDANZA;
  }
};
