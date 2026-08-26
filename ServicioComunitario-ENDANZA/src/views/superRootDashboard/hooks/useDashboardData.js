// src/dashboard/hooks/useDashboardData.js

import { useState, useEffect, useCallback } from 'react';
import { listUsers } from '../../../services/userService';
import {
  getEnrollmentPeriod,
  updateEnrollmentPeriod,
  getGradesPeriod,
  updateGradesPeriod
} from '../../../services/configService';
import { listSections } from '../../../services/sectionsService';
import { listStudents } from '../../../services/studentsService';
import {
  getNotasPendientes,
  aprobarNota,
  rechazarNota,
  aprobarTodasNotas
} from '../../../services/notasService';
import {
  getBoletines,
  toggleBoletinDisponible,
  habilitarTodosBoletines,
  verificarNotasPendientes
} from '../../../services/boletinesService';
// ✅ IMPORTAR SERVICIO DE DOCENTES
import * as TeacherService from '../../../services/teacherService';

export const useDashboardData = (selectedYearId) => {
  const [usuarios, setUsuarios] = useState([]);
  const [repsCount, setRepsCount] = useState(0);
  const [students, setStudents] = useState([]);
  const [sections, setSections] = useState([]);
  const [notasPendientes, setNotasPendientes] = useState([]);
  const [boletines, setBoletines] = useState([]);
  // ✅ NUEVO: Estado para docentes
  const [teachers, setTeachers] = useState([]);
  const [loading, setLoading] = useState(true);

  // Estados para modales
  const [visiblePeriodoInscripcion, setVisiblePeriodoInscripcion] = useState(false);
  const [visibleSubidaNotas, setVisibleSubidaNotas] = useState(false);
  const [visibleValidacionNotas, setVisibleValidacionNotas] = useState(false);
  const [visibleControlBoletines, setVisibleControlBoletines] = useState(false);

  const [periodoInscripcion, setPeriodoInscripcion] = useState({
    fechaInicio: '',
    fechaFin: '',
    activo: false
  });

  const [periodoSubidaNotas, setPeriodoSubidaNotas] = useState({
    fechaInicio: '',
    fechaFin: '',
    activo: false
  });

  // 📌 Función para cargar todos los datos
  const fetchAllData = useCallback(async () => {
    if (!selectedYearId) {
      console.log("📊 No hay año seleccionado, esperando...");
      setLoading(false);
      return;
    }

    setLoading(true);
    console.log(`📊 Cargando datos para año ID: ${selectedYearId}`);

    try {
      // 1. Cargar usuarios
      const usersData = await listUsers();
      const users = Array.isArray(usersData) ? usersData : [];

      const usuariosTransformados = users
        .filter(u => u?.role !== 'representante')
        .map(u => ({
          id: u.id,
          nombre: `${u.first_name || ''} ${u.last_name || ''}`.trim() || u.email || 'Sin nombre',
          rol: u.role || 'sin rol',
          activo: u.status === 'active'
        }));

      setUsuarios(usuariosTransformados);
      setRepsCount(users.filter(u => u?.role === 'representante').length);

      // 2. Cargar períodos
      const enrollmentData = await getEnrollmentPeriod(selectedYearId);
      setPeriodoInscripcion(enrollmentData);

      const gradesData = await getGradesPeriod(selectedYearId);
      setPeriodoSubidaNotas(gradesData);

      // 3. Cargar secciones
      const sectionsData = await listSections(selectedYearId);
      setSections(sectionsData);

      // 4. Cargar estudiantes
      const studentsData = await listStudents({ academicYearId: selectedYearId });
      setStudents(studentsData);

      // 5. Cargar notas pendientes
      const notasData = await getNotasPendientes(selectedYearId);
      setNotasPendientes(notasData);

      // 6. Cargar boletines
      const boletinesData = await getBoletines(selectedYearId);
      setBoletines(boletinesData);

      // ✅ 7. Cargar docentes FILTRADOS POR EL AÑO SELECCIONADO
      const teachersData = await TeacherService.getAll(selectedYearId);
      setTeachers(teachersData || []);

    } catch (error) {
      console.error("❌ Error cargando datos del dashboard:", error);
    } finally {
      setLoading(false);
    }
  }, [selectedYearId]);

  // 📌 Función para copiar asignaciones del año anterior
  const copyTeacherAssignmentsFromPreviousYear = useCallback(async () => {
    if (!selectedYearId) return false;

    try {
      // Obtener el año anterior (asumiendo que los IDs son consecutivos)
      const previousYearId = selectedYearId - 1;

      const response = await TeacherService.copyTeacherAssignments(previousYearId, selectedYearId);

      if (response.ok) {
        console.log(`✅ Asignaciones copiadas: ${response.copied || 0}`);
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error copiando asignaciones:", error);
      return false;
    }
  }, [selectedYearId, fetchAllData]);

  // 📌 Cargar datos cuando cambia el año
  useEffect(() => {
    fetchAllData();
  }, [fetchAllData, selectedYearId]);

  // 📌 Guardar período de inscripción
  const guardarPeriodoInscripcion = async (data) => {
    if (!selectedYearId) return;
    try {
      const response = await updateEnrollmentPeriod(selectedYearId, {
        ...data,
        activo: Boolean(data.activo)
      });
      if (response.ok) {
        setPeriodoInscripcion(data);
        setVisiblePeriodoInscripcion(false);
        await fetchAllData();
      }
    } catch (error) {
      console.error("❌ Error guardando período de inscripción:", error);
    }
  };

  // 📌 Guardar período de subida de notas
  const guardarPeriodoSubidaNotas = async (data) => {
    if (!selectedYearId) {
      alert("No hay un año académico seleccionado.");
      return;
    }

    try {
      console.log(`💾 Guardando periodo de notas para año ${selectedYearId}:`, data);

      const response = await updateGradesPeriod(selectedYearId, {
        fechaInicio: data.fechaInicio,
        fechaFin: data.fechaFin,
        activo: Boolean(data.activo)
      });

      if (response && (response.ok || response._ok)) {
        console.log("✅ Periodo de notas guardado correctamente");
        alert("¡Periodo actualizado con éxito!");
        setPeriodoSubidaNotas(data);
        setVisibleSubidaNotas(false);
        await fetchAllData();
        return true;
      } else {
        const msg = response.msg || response.message || "Error desconocido del servidor";
        console.error("❌ Error del servidor:", msg);
        alert(`No se pudo guardar: ${msg}`);
        return false;
      }
    } catch (error) {
      console.error("❌ Error guardando período de notas:", error);
      alert("Error de red al intentar guardar los cambios.");
      return false;
    }
  };

  // 📌 Aprobar una nota
  const aprobarNotaPendiente = async (notaId) => {
    try {
      const response = await aprobarNota(notaId);
      if (response.ok) {
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error aprobando nota:", error);
      return false;
    }
  };

  // 📌 Rechazar una nota
  const rechazarNotaPendiente = async (notaId) => {
    try {
      const response = await rechazarNota(notaId);
      if (response.ok) {
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error rechazando nota:", error);
      return false;
    }
  };

  // 📌 Aprobar todas las notas
  const aprobarTodasNotasPendientes = async () => {
    try {
      const response = await aprobarTodasNotas();
      if (response.ok) {
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error aprobando todas las notas:", error);
      return false;
    }
  };

  // 📌 Alternar disponibilidad de boletín
  const toggleBoletin = async (boletinId, disponible) => {
    try {
      const response = await toggleBoletinDisponible(boletinId, disponible);
      if (response.ok) {
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error alternando boletín:", error);
      return false;
    }
  };

  // 📌 Habilitar todos los boletines
  const habilitarTodosBoletinesDelAnio = async () => {
    if (!selectedYearId) return false;

    // Verificar si hay notas pendientes
    const hayPendientes = await verificarNotasPendientes(selectedYearId);
    if (hayPendientes) {
      alert("No se pueden habilitar los boletines porque hay notas pendientes de validación.");
      return false;
    }

    try {
      const response = await habilitarTodosBoletines(selectedYearId);
      if (response.ok) {
        await fetchAllData(); // Recargar datos
        return true;
      }
      return false;
    } catch (error) {
      console.error("❌ Error habilitando todos los boletines:", error);
      return false;
    }
  };

  return {
    // Datos
    periodoInscripcion,
    periodoSubidaNotas,
    usuarios,
    repsCount,
    students,
    sections,
    notasPendientes,
    boletines,
    teachers, // ✅ DOCENTES FILTRADOS POR AÑO
    loading,

    // Estados de modales
    visiblePeriodoInscripcion,
    setVisiblePeriodoInscripcion,
    visibleSubidaNotas,
    setVisibleSubidaNotas,
    visibleValidacionNotas,
    setVisibleValidacionNotas,
    visibleControlBoletines,
    setVisibleControlBoletines,

    // Acciones
    guardarPeriodoInscripcion,
    guardarPeriodoSubidaNotas,
    aprobarNotaPendiente,
    rechazarNotaPendiente,
    aprobarTodasNotasPendientes,
    toggleBoletin,
    habilitarTodosBoletinesDelAnio,
    copyTeacherAssignmentsFromPreviousYear, // ✅ NUEVA FUNCIÓN
    refreshData: fetchAllData
  };
};

export default useDashboardData;