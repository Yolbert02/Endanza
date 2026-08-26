// Archivo: src/views/Notas/Revisiones.js
import React, { useState, useEffect, useCallback } from 'react';
import {
  CContainer,
  CCard,
  CCardHeader,
  CCardBody,
  CRow,
  CCol,
  CButton,
  CBadge,
  CTable,
  CTableHead,
  CTableRow,
  CTableHeaderCell,
  CTableBody,
  CTableDataCell,
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CForm,
  CFormInput,
  CFormLabel,
  CFormTextarea,
  CSpinner,
  CToaster,
  CToast,
  CToastHeader,
  CToastBody,
  CAlert
} from '@coreui/react';
import CIcon from '@coreui/icons-react';
import {
  cilBook,
  cilReload,
  cilCheckCircle,
  cilXCircle,
  cilPencil,
  cilSearch,
  cilInfo,
  cilNotes
} from '@coreui/icons';

import { getAvailableYears, getActiveYear } from '../../services/configService';
import {
  getRevisiones,
  updateNotaRevision,
  autoDetectRevisiones
} from '../../services/revisionService';
import useUserRole from '../../Hooks/useUserRole';

const Revisiones = () => {
  const { isSuperadministrador } = useUserRole();

  const [years, setYears] = useState([]);
  const [selectedYear, setSelectedYear] = useState(null);
  const [revisiones, setRevisiones] = useState([]);
  const [loading, setLoading] = useState(true);
  const [detecting, setDetecting] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  // Modal para cargar nota de revisión
  const [modalVisible, setModalVisible] = useState(false);
  const [selectedRevision, setSelectedRevision] = useState(null);
  const [notaRevisionInput, setNotaRevisionInput] = useState('');
  const [observacionInput, setObservacionInput] = useState('');
  const [saving, setSaving] = useState(false);

  // Toasts
  const [toasts, setToasts] = useState([]);

  const showToast = useCallback((type, message) => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, type, message }]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 4000);
  }, []);

  // 1. Cargar Años Académicos
  useEffect(() => {
    const fetchYears = async () => {
      try {
        const availableYears = await getAvailableYears();
        const active = await getActiveYear();
        setYears(availableYears);
        if (active) {
          setSelectedYear(active);
        } else if (availableYears.length > 0) {
          setSelectedYear(availableYears[0]);
        }
      } catch (error) {
        console.error('Error cargando años:', error);
      }
    };
    fetchYears();
  }, []);

  // 2. Cargar Revisiones del Año Seleccionado
  const fetchRevisiones = useCallback(async () => {
    if (!selectedYear) return;
    setLoading(true);
    try {
      const data = await getRevisiones(selectedYear.id);
      setRevisiones(data);
    } catch (error) {
      console.error('Error cargando revisiones:', error);
      showToast('danger', 'Error al cargar las revisiones');
    } finally {
      setLoading(false);
    }
  }, [selectedYear, showToast]);

  useEffect(() => {
    fetchRevisiones();
  }, [fetchRevisiones]);

  // 3. Auto-detectar Materias Teóricas Reprobadas
  const handleAutoDetect = async () => {
    if (!selectedYear) return;
    setDetecting(true);
    try {
      const res = await autoDetectRevisiones(selectedYear.id);
      showToast('success', res.msg || 'Auto-detección completada exitosamente');
      await fetchRevisiones();
    } catch (error) {
      console.error('Error en auto-detección:', error);
      showToast('danger', error.msg || 'Error al ejecutar la auto-detección');
    } finally {
      setDetecting(false);
    }
  };

  // 4. Abrir Modal de Carga de Nota
  const handleOpenModal = (revision) => {
    setSelectedRevision(revision);
    setNotaRevisionInput(revision.nota_revision !== null ? revision.nota_revision : '');
    setObservacionInput(revision.observacion || '');
    setModalVisible(true);
  };

  // 5. Guardar Nota de Revisión
  const handleSaveNota = async (e) => {
    e.preventDefault();
    if (!selectedRevision) return;

    const nota = parseFloat(notaRevisionInput);
    if (isNaN(nota) || nota < 0 || nota > 20) {
      showToast('warning', 'La calificación debe ser un valor válido entre 0 y 20 pts');
      return;
    }

    setSaving(true);
    try {
      await updateNotaRevision(selectedRevision.id, {
        notaRevision: nota,
        observacion: observacionInput
      });
      showToast('success', `Calificación guardada (${nota >= 10 ? 'APROBADO' : 'REPROBADO'})`);
      setModalVisible(false);
      await fetchRevisiones();
    } catch (error) {
      console.error('Error guardando nota de revisión:', error);
      showToast('danger', error.msg || 'Error al guardar la nota');
    } finally {
      setSaving(false);
    }
  };

  // Filtrar revisiones por buscador
  const filteredRevisiones = revisiones.filter(r => {
    const term = searchTerm.toLowerCase();
    return (
      (r.student_name && r.student_name.toLowerCase().includes(term)) ||
      (r.student_dni && r.student_dni.toLowerCase().includes(term)) ||
      (r.subject_name && r.subject_name.toLowerCase().includes(term)) ||
      (r.grade_name && r.grade_name.toLowerCase().includes(term))
    );
  });

  const getBadgeEstado = (estado) => {
    switch (estado?.toLowerCase()) {
      case 'aprobado':
        return <CBadge color="success" className="px-3 py-2 text-uppercase">Aprobado en Revisión</CBadge>;
      case 'reprobado':
        return <CBadge color="danger" className="px-3 py-2 text-uppercase">Reprobado en Revisión</CBadge>;
      default:
        return <CBadge color="warning" className="px-3 py-2 text-uppercase text-dark">Pendiente de Examen</CBadge>;
    }
  };

  return (
    <CContainer className="py-4 animate__animated animate__fadeIn">
      {/* Header */}
      <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
          <div className="d-flex align-items-center gap-2">
            <div className="bg-orange-soft p-2 rounded-circle text-primary">
              <CIcon icon={cilBook} size="xl" />
            </div>
            <h2 className="mb-0 fw-bold header-title-custom">Revisión de Materia Teórica</h2>
          </div>
          <small className="text-muted-custom">
            Gestión de exámenes de reparación para estudiantes con definitiva general &lt; 10 pts
          </small>
        </div>

        <div className="d-flex flex-wrap align-items-center gap-2">
          {/* Selector de Año */}
          {years.length > 0 && (
            <select
              className="form-select form-select-sm w-auto fw-bold shadow-sm"
              value={selectedYear?.id || ''}
              onChange={(e) => {
                const y = years.find(item => item.id === parseInt(e.target.value));
                setSelectedYear(y);
              }}
              style={{ borderRadius: '8px', minWidth: '150px' }}
            >
              {years.map(y => (
                <option key={y.id} value={y.id}>
                  {y.name} {y.active ? '(Activo)' : ''}
                </option>
              ))}
            </select>
          )}

          <CButton
            className="btn-premium d-flex align-items-center gap-2 shadow-sm"
            onClick={handleAutoDetect}
            disabled={detecting || !selectedYear}
          >
            {detecting ? <CSpinner size="sm" /> : <CIcon icon={cilReload} />}
            Auto-Detectar Reprobados
          </CButton>
        </div>
      </div>

      {/* Alerta Informativa */}
      <CAlert color="info" className="border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center gap-3">
        <CIcon icon={cilInfo} size="xl" className="text-info flex-shrink-0" />
        <div className="small">
          <strong>Regla de Evaluación Institucional:</strong> Solo las materias de naturaleza <strong>Teórica</strong> permiten el proceso de revisión tras reprobar la definitiva general. Las materias prácticas no son recuperables por este mecanismo.
        </div>
      </CAlert>

      {/* Tarjeta Principal */}
      <CCard className="premium-card border-0 shadow-sm overflow-hidden mb-4">
        <CCardHeader className="bg-light-custom py-3 px-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
          <div className="fw-bold text-uppercase ls-1 header-title-custom small">
            Estudiantes en Proceso de Revisión ({filteredRevisiones.length})
          </div>

          <div className="position-relative" style={{ minWidth: '260px' }}>
            <CFormInput
              size="sm"
              placeholder="Buscar por estudiante, cédula o materia..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="rounded-pill ps-4"
            />
            <CIcon icon={cilSearch} className="position-absolute text-muted" style={{ left: '10px', top: '9px', fontSize: '0.8rem' }} />
          </div>
        </CCardHeader>

        <CCardBody className="p-0">
          {loading ? (
            <div className="text-center py-5">
              <CSpinner color="warning" />
              <p className="mt-2 text-muted small">Consultando registros de revisión...</p>
            </div>
          ) : filteredRevisiones.length === 0 ? (
            <div className="text-center py-5">
              <CIcon icon={cilCheckCircle} size="3xl" className="text-success mb-3 opacity-50" />
              <h5 className="fw-bold text-muted">No hay materias en revisión</h5>
              <p className="text-muted small mx-auto" style={{ maxWidth: '400px' }}>
                No se encontraron materias teóricas reprobadas para este ciclo académico o todos los casos están al día.
              </p>
            </div>
          ) : (
            <div className="table-responsive">
              <CTable hover align="middle" className="mb-0 border-0">
                <CTableHead className="bg-light-custom">
                  <CTableRow>
                    <CTableHeaderCell className="py-3 px-4 text-muted-custom small text-uppercase fw-bold border-0">Estudiante</CTableHeaderCell>
                    <CTableHeaderCell className="py-3 text-muted-custom small text-uppercase fw-bold border-0">Materia / Grado</CTableHeaderCell>
                    <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Nota Original</CTableHeaderCell>
                    <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Nota Revisión</CTableHeaderCell>
                    <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Estado</CTableHeaderCell>
                    <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Acciones</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {filteredRevisiones.map((rev) => (
                    <CTableRow key={rev.id}>
                      <CTableDataCell className="py-3 px-4">
                        <div className="fw-bold header-title-custom">{rev.student_name}</div>
                        <small className="text-muted font-monospace">{rev.student_dni || 'Sin Cédula'}</small>
                      </CTableDataCell>
                      <CTableDataCell className="py-3">
                        <div className="fw-semibold text-primary">{rev.subject_name}</div>
                        <small className="text-muted">{rev.grade_name || 'General'}</small>
                      </CTableDataCell>
                      <CTableDataCell className="text-center py-3">
                        <span className="fw-bold text-danger fs-6 font-monospace">
                          {rev.nota_definitiva !== null ? rev.nota_definitiva : '--'}
                        </span>
                      </CTableDataCell>
                      <CTableDataCell className="text-center py-3">
                        {rev.nota_revision !== null ? (
                          <span className={`fw-bold fs-6 font-monospace ${parseFloat(rev.nota_revision) >= 10 ? 'text-success' : 'text-danger'}`}>
                            {rev.nota_revision}
                          </span>
                        ) : (
                          <span className="text-muted fst-italic small">Sin calificar</span>
                        )}
                      </CTableDataCell>
                      <CTableDataCell className="text-center py-3">
                        {getBadgeEstado(rev.estado)}
                      </CTableDataCell>
                      <CTableDataCell className="text-center py-3">
                        <CButton
                          color="warning"
                          size="sm"
                          className="rounded-pill px-3 fw-bold text-white shadow-sm d-inline-flex align-items-center gap-1"
                          onClick={() => handleOpenModal(rev)}
                        >
                          <CIcon icon={cilPencil} size="sm" />
                          Calificar
                        </CButton>
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
            </div>
          )}
        </CCardBody>
      </CCard>

      {/* Modal para Cargar Nota de Revisión */}
      <CModal visible={modalVisible} onClose={() => setModalVisible(false)} alignment="center">
        <CModalHeader className="border-0 pb-0">
          <CModalTitle className="fw-bold header-title-custom">
            Cargar Calificación de Revisión
          </CModalTitle>
        </CModalHeader>
        <CForm onSubmit={handleSaveNota}>
          <CModalBody className="py-3">
            {selectedRevision && (
              <div className="p-3 bg-light-custom rounded-4 mb-3">
                <div className="small text-muted text-uppercase fw-bold mb-1">Estudiante</div>
                <div className="fw-bold fs-6">{selectedRevision.student_name}</div>
                <div className="small text-muted mt-2 text-uppercase fw-bold mb-1">Asignatura Teórica</div>
                <div className="fw-semibold text-primary">{selectedRevision.subject_name}</div>
                <div className="d-flex justify-content-between mt-2 pt-2 border-top">
                  <span className="small text-muted">Definitiva Original:</span>
                  <span className="fw-bold text-danger font-monospace">{selectedRevision.nota_definitiva} pts</span>
                </div>
              </div>
            )}

            <div className="mb-3">
              <CFormLabel className="fw-bold small text-uppercase">Nota de Examen de Revisión (0 - 20 pts)</CFormLabel>
              <CFormInput
                type="number"
                step="0.1"
                min="0"
                max="20"
                required
                placeholder="Ej: 14.5"
                value={notaRevisionInput}
                onChange={(e) => setNotaRevisionInput(e.target.value)}
                className="font-monospace fs-5 text-center fw-bold"
              />
              <small className="text-muted mt-1 d-block">
                * Con una calificación &gt;= 10 pts, el estudiante aprueba la materia.
              </small>
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-bold small text-uppercase">Observaciones del Examen (Opcional)</CFormLabel>
              <CFormTextarea
                rows={3}
                placeholder="Detalles sobre el examen aplicado, fecha o consideraciones docentes..."
                value={observacionInput}
                onChange={(e) => setObservacionInput(e.target.value)}
              />
            </div>
          </CModalBody>
          <CModalFooter className="border-0 pt-0">
            <CButton color="secondary" variant="ghost" onClick={() => setModalVisible(false)}>
              Cancelar
            </CButton>
            <CButton color="warning" type="submit" disabled={saving} className="fw-bold text-white px-4 rounded-pill">
              {saving ? <CSpinner size="sm" /> : 'Guardar Calificación'}
            </CButton>
          </CModalFooter>
        </CForm>
      </CModal>

      {/* Toasts */}
      <CToaster placement="top-end">
        {toasts.map((t) => (
          <CToast key={t.id} visible color={t.type} className="border-0 shadow-lg text-white">
            <CToastHeader closeButton className="bg-transparent border-0 text-white">
              <strong className="me-auto">Control de Revisiones</strong>
            </CToastHeader>
            <CToastBody className="fw-medium">{t.message}</CToastBody>
          </CToast>
        ))}
      </CToaster>
    </CContainer>
  );
};

export default Revisiones;
