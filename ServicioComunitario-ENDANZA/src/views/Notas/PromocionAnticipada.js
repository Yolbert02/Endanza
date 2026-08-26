// Archivo: src/views/Notas/PromocionAnticipada.js
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
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
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
  cilEducation,
  cilStar,
  cilDescription,
  cilPrint,
  cilCheckCircle,
  cilReload,
  cilUserFollow,
  cilCalendar,
  cilArrowRight,
  cilInfo
} from '@coreui/icons';

import { getAvailableYears, getActiveYear } from '../../services/configService';
import { getTeacherGrades } from '../../services/teacherService';
import {
  getCandidatosPromocion,
  getActasPromocion,
  getActaDetalle,
  emitirActaPromocion
} from '../../services/promocionService';
import useUserRole from '../../Hooks/useUserRole';

const PromocionAnticipada = () => {
  const { isSuperadministrador } = useUserRole();

  const [years, setYears] = useState([]);
  const [selectedYear, setSelectedYear] = useState(null);
  const [grados, setGrados] = useState([]);
  const [activeTab, setActiveTab] = useState('candidatos'); // 'candidatos' o 'actas'

  // Datos
  const [candidatos, setCandidatos] = useState([]);
  const [actas, setActas] = useState([]);
  const [loading, setLoading] = useState(true);

  // Modal para Emitir Acta
  const [modalEmitirVisible, setModalEmitirVisible] = useState(false);
  const [selectedCandidato, setSelectedCandidato] = useState(null);
  const [targetGradeId, setTargetGradeId] = useState('');
  const [numeroActaInput, setNumeroActaInput] = useState('');
  const [motivoInput, setMotivoInput] = useState('');
  const [resolucionInput, setResolucionInput] = useState('');
  const [savingActa, setSavingActa] = useState(false);

  // Modal para Ver / Imprimir Acta Oficial
  const [modalActaPrintVisible, setModalActaPrintVisible] = useState(false);
  const [actaDetalle, setActaDetalle] = useState(null);
  const [loadingActa, setLoadingActa] = useState(false);

  // Toasts
  const [toasts, setToasts] = useState([]);

  const showToast = useCallback((type, message) => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, type, message }]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 4000);
  }, []);

  // 1. Cargar Años y Grados
  useEffect(() => {
    const fetchInitialData = async () => {
      try {
        const availableYears = await getAvailableYears();
        const active = await getActiveYear();
        setYears(availableYears);
        if (active) setSelectedYear(active);
        else if (availableYears.length > 0) setSelectedYear(availableYears[0]);

        const allGrados = await getTeacherGrades();
        setGrados(allGrados || []);
      } catch (error) {
        console.error('Error cargando datos iniciales:', error);
      }
    };
    fetchInitialData();
  }, []);

  // 2. Cargar Candidatos y Actas
  const fetchData = useCallback(async () => {
    if (!selectedYear) return;
    setLoading(true);
    try {
      const [candsData, actasData] = await Promise.all([
        getCandidatosPromocion(selectedYear.id, 18.0),
        getActasPromocion(selectedYear.id)
      ]);
      setCandidatos(candsData);
      setActas(actasData);
    } catch (error) {
      console.error('Error cargando información de promoción:', error);
      showToast('danger', 'Error al consultar candidatos y actas');
    } finally {
      setLoading(false);
    }
  }, [selectedYear, showToast]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // 3. Abrir Modal para Emitir Acta
  const handleOpenEmitirModal = (candidato) => {
    setSelectedCandidato(candidato);
    const correlativoSugerido = `ACTA-PROM-${new Date().getFullYear()}-${String(actas.length + 1).padStart(3, '0')}`;
    setNumeroActaInput(correlativoSugerido);

    // Sugerir el siguiente grado si es posible
    const currentGradeIndex = grados.findIndex(g => g.id === candidato.current_grade_id);
    if (currentGradeIndex !== -1 && currentGradeIndex + 1 < grados.length) {
      setTargetGradeId(grados[currentGradeIndex + 1].id);
    } else {
      setTargetGradeId('');
    }

    setMotivoInput(
      `El/La estudiante ha demostrado un desempeño técnico, artístico y disciplinario sobresaliente durante el 1er Lapso, alcanzando un promedio sobresaliente de ${candidato.promedio_redondeado} puntos.`
    );
    setResolucionInput(
      `El Consejo Docente y Directivo de la Escuela Nacional de Danza (ENDANZA) aprueba por unanimidad la Promoción Anticipada al siguiente nivel académico.`
    );
    setModalEmitirVisible(true);
  };

  // 4. Guardar y Formalizar Acta
  const handleEmitirActa = async (e) => {
    e.preventDefault();
    if (!selectedCandidato || !targetGradeId) {
      showToast('warning', 'Debe seleccionar el grado destino');
      return;
    }

    setSavingActa(true);
    try {
      const res = await emitirActaPromocion({
        numeroActa: numeroActaInput,
        studentId: selectedCandidato.Id_estudiante,
        academicYearId: selectedYear.id,
        originGradeId: selectedCandidato.current_grade_id,
        targetGradeId: parseInt(targetGradeId),
        promedioLapso1: selectedCandidato.promedio_lapso1,
        motivo: motivoInput,
        resolucion: resolucionInput
      });

      showToast('success', res.msg || 'Acta Oficial emitida y guardada en BD');
      setModalEmitirVisible(false);
      await fetchData();

      // Abrir automáticamente el acta para imprimir
      if (res.data?.id) {
        handleVerActa(res.data.id);
      }
    } catch (error) {
      console.error('Error emitiendo acta:', error);
      showToast('danger', error.msg || 'Error al emitir el acta');
    } finally {
      setSavingActa(false);
    }
  };

  // 5. Ver / Imprimir Acta Oficial
  const handleVerActa = async (actaId) => {
    setLoadingActa(true);
    setModalActaPrintVisible(true);
    try {
      const data = await getActaDetalle(actaId);
      setActaDetalle(data);
    } catch (error) {
      console.error('Error cargando detalle del acta:', error);
      showToast('danger', 'Error al cargar el acta oficial');
    } finally {
      setLoadingActa(false);
    }
  };

  return (
    <CContainer className="py-4 animate__animated animate__fadeIn">
      {/* Header */}
      <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
          <div className="d-flex align-items-center gap-2">
            <div className="bg-warning bg-opacity-25 p-2 rounded-circle text-warning">
              <CIcon icon={cilStar} size="xl" />
            </div>
            <h2 className="mb-0 fw-bold header-title-custom">Promoción Anticipada (1er Lapso)</h2>
          </div>
          <small className="text-muted-custom">
            Gestión y emisión de Actas Oficiales para estudiantes con rendimiento sobresaliente en el 1er Lapso
          </small>
        </div>

        <div className="d-flex align-items-center gap-2">
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
            onClick={fetchData}
            disabled={loading}
          >
            <CIcon icon={cilReload} />
            Actualizar
          </CButton>
        </div>
      </div>

      {/* Alerta Informativa */}
      <CAlert color="warning" className="border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center gap-3 bg-warning bg-opacity-10 text-dark">
        <CIcon icon={cilInfo} size="xl" className="text-warning flex-shrink-0" />
        <div className="small">
          <strong>Normativa Institucional:</strong> La promoción al siguiente grado durante el primer lapso aplica únicamente para estudiantes con promedio sobresaliente (&ge; 18.0 pts) y requiere obligatoriamente la emisión formal de un <strong>Acta Oficial avalada por el Consejo Directivo</strong> registrada en el sistema.
        </div>
      </CAlert>

      {/* Pestañas */}
      <CNav variant="tabs" className="mb-4">
        <CNavItem>
          <CNavLink
            active={activeTab === 'candidatos'}
            onClick={() => setActiveTab('candidatos')}
            className="fw-bold d-flex align-items-center gap-2"
            style={{ cursor: 'pointer' }}
          >
            <CIcon icon={cilUserFollow} />
            Candidatos Sobresalientes (1er Lapso)
            <CBadge color="warning" className="ms-1 rounded-pill">{candidatos.length}</CBadge>
          </CNavLink>
        </CNavItem>
        <CNavItem>
          <CNavLink
            active={activeTab === 'actas'}
            onClick={() => setActiveTab('actas')}
            className="fw-bold d-flex align-items-center gap-2"
            style={{ cursor: 'pointer' }}
          >
            <CIcon icon={cilDescription} />
            Libro de Actas Oficiales
            <CBadge color="info" className="ms-1 rounded-pill">{actas.length}</CBadge>
          </CNavLink>
        </CNavItem>
      </CNav>

      <CTabContent>
        {/* Pestaña 1: Candidatos */}
        <CTabPane visible={activeTab === 'candidatos'}>
          <CCard className="premium-card border-0 shadow-sm overflow-hidden mb-4">
            <CCardHeader className="bg-light-custom py-3 px-4 fw-bold text-uppercase ls-1 header-title-custom small">
              Estudiantes con Promedio Sobresaliente (&ge; 18 pts)
            </CCardHeader>
            <CCardBody className="p-0">
              {loading ? (
                <div className="text-center py-5">
                  <CSpinner color="warning" />
                  <p className="mt-2 text-muted small">Buscando estudiantes sobresalientes...</p>
                </div>
              ) : candidatos.length === 0 ? (
                <div className="text-center py-5">
                  <CIcon icon={cilEducation} size="3xl" className="text-muted mb-3 opacity-50" />
                  <h5 className="fw-bold text-muted">No hay candidatos en este momento</h5>
                  <p className="text-muted small mx-auto" style={{ maxWidth: '450px' }}>
                    No se encontraron estudiantes con notas registradas de 1er Lapso con promedio mayor o igual a 18.0 puntos.
                  </p>
                </div>
              ) : (
                <div className="table-responsive">
                  <CTable hover align="middle" className="mb-0 border-0">
                    <CTableHead className="bg-light-custom">
                      <CTableRow>
                        <CTableHeaderCell className="py-3 px-4 text-muted-custom small text-uppercase fw-bold border-0">Estudiante</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-muted-custom small text-uppercase fw-bold border-0">Grado Actual</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Promedio 1er Lapso</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Estatus del Acta</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Acción</CTableHeaderCell>
                      </CTableRow>
                    </CTableHead>
                    <CTableBody>
                      {candidatos.map((cand) => (
                        <CTableRow key={cand.Id_estudiante}>
                          <CTableDataCell className="py-3 px-4">
                            <div className="fw-bold header-title-custom">{cand.first_name} {cand.last_name}</div>
                            <small className="text-muted font-monospace">{cand.dni || 'Sin Cédula'}</small>
                          </CTableDataCell>
                          <CTableDataCell className="py-3">
                            <CBadge color="light" className="text-dark border px-3 py-1">
                              {cand.current_grade_name || cand.dance_level_name || 'Grado no definido'}
                            </CBadge>
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            <span className="fw-bold fs-5 text-success font-monospace">
                              {cand.promedio_redondeado} pts
                            </span>
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            {cand.ya_promovido_acta_id ? (
                              <CBadge color="success" className="px-3 py-2 text-uppercase">
                                Acta Emitida: {cand.acta_existente_numero}
                              </CBadge>
                            ) : (
                              <CBadge color="warning" className="px-3 py-2 text-uppercase text-dark">
                                Elegible para Promoción
                              </CBadge>
                            )}
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            {cand.ya_promovido_acta_id ? (
                              <CButton
                                color="info"
                                size="sm"
                                className="rounded-pill px-3 fw-bold text-white shadow-sm d-inline-flex align-items-center gap-1"
                                onClick={() => handleVerActa(cand.ya_promovido_acta_id)}
                              >
                                <CIcon icon={cilPrint} size="sm" />
                                Ver Acta
                              </CButton>
                            ) : (
                              <CButton
                                color="warning"
                                size="sm"
                                className="rounded-pill px-3 fw-bold text-white shadow-sm d-inline-flex align-items-center gap-1"
                                onClick={() => handleOpenEmitirModal(cand)}
                              >
                                <CIcon icon={cilDescription} size="sm" />
                                Emitir Acta
                              </CButton>
                            )}
                          </CTableDataCell>
                        </CTableRow>
                      ))}
                    </CTableBody>
                  </CTable>
                </div>
              )}
            </CCardBody>
          </CCard>
        </CTabPane>

        {/* Pestaña 2: Libro de Actas */}
        <CTabPane visible={activeTab === 'actas'}>
          <CCard className="premium-card border-0 shadow-sm overflow-hidden mb-4">
            <CCardHeader className="bg-light-custom py-3 px-4 fw-bold text-uppercase ls-1 header-title-custom small">
              Registro Oficial de Actas de Promoción Anticipada
            </CCardHeader>
            <CCardBody className="p-0">
              {loading ? (
                <div className="text-center py-5">
                  <CSpinner color="warning" />
                  <p className="mt-2 text-muted small">Cargando libro de actas...</p>
                </div>
              ) : actas.length === 0 ? (
                <div className="text-center py-5">
                  <CIcon icon={cilDescription} size="3xl" className="text-muted mb-3 opacity-50" />
                  <h5 className="fw-bold text-muted">No hay actas registradas</h5>
                  <p className="text-muted small">Aún no se han emitido actas de promoción para este año académico.</p>
                </div>
              ) : (
                <div className="table-responsive">
                  <CTable hover align="middle" className="mb-0 border-0">
                    <CTableHead className="bg-light-custom">
                      <CTableRow>
                        <CTableHeaderCell className="py-3 px-4 text-muted-custom small text-uppercase fw-bold border-0">N° de Acta</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-muted-custom small text-uppercase fw-bold border-0">Estudiante</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Cambio de Grado</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Promedio Lapso 1</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Fecha de Emisión</CTableHeaderCell>
                        <CTableHeaderCell className="py-3 text-center text-muted-custom small text-uppercase fw-bold border-0">Acciones</CTableHeaderCell>
                      </CTableRow>
                    </CTableHead>
                    <CTableBody>
                      {actas.map((acta) => (
                        <CTableRow key={acta.id}>
                          <CTableDataCell className="py-3 px-4">
                            <span className="fw-bold text-primary font-monospace">{acta.act_number}</span>
                          </CTableDataCell>
                          <CTableDataCell className="py-3">
                            <div className="fw-bold header-title-custom">{acta.student_name}</div>
                            <small className="text-muted">{acta.student_dni || 'Sin Cédula'}</small>
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            <span className="small text-muted">{acta.origin_grade_name}</span>
                            <CIcon icon={cilArrowRight} className="mx-2 text-warning" />
                            <span className="fw-bold text-success">{acta.target_grade_name}</span>
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            <span className="fw-bold text-success font-monospace">{acta.average_lapso1} pts</span>
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3 small text-muted">
                            {new Date(acta.issue_date).toLocaleDateString()}
                          </CTableDataCell>
                          <CTableDataCell className="text-center py-3">
                            <CButton
                              color="primary"
                              variant="outline"
                              size="sm"
                              className="rounded-pill px-3 fw-bold d-inline-flex align-items-center gap-1 shadow-sm"
                              onClick={() => handleVerActa(acta.id)}
                            >
                              <CIcon icon={cilPrint} size="sm" />
                              Ver / Imprimir
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
        </CTabPane>
      </CTabContent>

      {/* Modal para Emitir Acta */}
      <CModal visible={modalEmitirVisible} onClose={() => setModalEmitirVisible(false)} size="lg" alignment="center">
        <CModalHeader className="border-0 pb-0">
          <CModalTitle className="fw-bold header-title-custom d-flex align-items-center gap-2">
            <CIcon icon={cilDescription} className="text-warning" />
            Emisión de Acta Oficial de Promoción Anticipada
          </CModalTitle>
        </CModalHeader>
        <CForm onSubmit={handleEmitirActa}>
          <CModalBody className="py-3">
            {selectedCandidato && (
              <div className="p-3 bg-light-custom rounded-4 mb-3 border">
                <CRow className="g-3">
                  <CCol md={6}>
                    <small className="text-muted text-uppercase fw-bold d-block">Estudiante Destacado</small>
                    <span className="fw-bold fs-6">{selectedCandidato.first_name} {selectedCandidato.last_name}</span>
                  </CCol>
                  <CCol md={3}>
                    <small className="text-muted text-uppercase fw-bold d-block">Grado Actual</small>
                    <span className="fw-semibold text-primary">{selectedCandidato.current_grade_name}</span>
                  </CCol>
                  <CCol md={3}>
                    <small className="text-muted text-uppercase fw-bold d-block">Promedio 1er Lapso</small>
                    <span className="fw-bold text-success fs-6 font-monospace">{selectedCandidato.promedio_redondeado} pts</span>
                  </CCol>
                </CRow>
              </div>
            )}

            <CRow className="g-3 mb-3">
              <CCol md={6}>
                <CFormLabel className="fw-bold small text-uppercase">N° Correlativo de Acta</CFormLabel>
                <CFormInput
                  required
                  value={numeroActaInput}
                  onChange={(e) => setNumeroActaInput(e.target.value)}
                  className="font-monospace fw-bold"
                />
              </CCol>
              <CCol md={6}>
                <CFormLabel className="fw-bold small text-uppercase">Grado al que es Promovido</CFormLabel>
                <select
                  className="form-select fw-bold"
                  required
                  value={targetGradeId}
                  onChange={(e) => setTargetGradeId(e.target.value)}
                >
                  <option value="">-- Seleccionar Grado Destino --</option>
                  {grados.map(g => (
                    <option key={g.id} value={g.id}>
                      {g.name || g.nombre}
                    </option>
                  ))}
                </select>
              </CCol>
            </CRow>

            <div className="mb-3">
              <CFormLabel className="fw-bold small text-uppercase">Motivo y Justificación de Rendimiento</CFormLabel>
              <CFormTextarea
                rows={3}
                required
                value={motivoInput}
                onChange={(e) => setMotivoInput(e.target.value)}
              />
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-bold small text-uppercase">Resolución del Consejo Directivo</CFormLabel>
              <CFormTextarea
                rows={2}
                required
                value={resolucionInput}
                onChange={(e) => setResolucionInput(e.target.value)}
              />
            </div>
          </CModalBody>
          <CModalFooter className="border-0 pt-0">
            <CButton color="secondary" variant="ghost" onClick={() => setModalEmitirVisible(false)}>
              Cancelar
            </CButton>
            <CButton color="warning" type="submit" disabled={savingActa} className="fw-bold text-white px-4 rounded-pill">
              {savingActa ? <CSpinner size="sm" /> : 'Emitir Acta y Promover'}
            </CButton>
          </CModalFooter>
        </CForm>
      </CModal>

      {/* Modal para Visualizar / Imprimir Acta Oficial */}
      <CModal visible={modalActaPrintVisible} onClose={() => setModalActaPrintVisible(false)} size="xl" alignment="center">
        <CModalHeader className="border-0 pb-0 no-print">
          <CModalTitle className="fw-bold header-title-custom">
            Documento Oficial: Acta de Promoción
          </CModalTitle>
        </CModalHeader>
        <CModalBody className="p-4">
          {loadingActa || !actaDetalle ? (
            <div className="text-center py-5">
              <CSpinner color="warning" />
              <p className="mt-2 text-muted small">Cargando formato oficial...</p>
            </div>
          ) : (
            <div id="acta-imprimible" className="p-4 p-md-5 bg-white text-dark rounded-4 shadow-sm border border-secondary border-opacity-25" style={{ minHeight: '600px' }}>
              {/* Membrete Oficial */}
              <div className="text-center border-bottom pb-4 mb-4">
                <h6 className="text-uppercase fw-bold mb-1" style={{ letterSpacing: '1.5px', color: '#1e293b' }}>
                  República Bolivariana de Venezuela
                </h6>
                <h5 className="text-uppercase fw-bold mb-1 text-primary" style={{ letterSpacing: '1px' }}>
                  Escuela Nacional de Danza (ENDANZA)
                </h5>
                <small className="text-muted fw-semibold text-uppercase d-block mb-3">
                  Dirección General y Coordinación Académica
                </small>
                <div className="badge bg-warning text-dark px-4 py-2 rounded-pill fs-6 fw-bold">
                  {actaDetalle.act_number}
                </div>
              </div>

              {/* Título */}
              <div className="text-center mb-4">
                <h4 className="fw-bold text-uppercase" style={{ textDecoration: 'underline' }}>
                  Acta de Promoción Anticipada de Grado
                </h4>
                <small className="text-muted">Ciclo Académico {actaDetalle.academic_year_name}</small>
              </div>

              {/* Cuerpo del Acta */}
              <div className="fs-6 lh-lg mb-4 text-justify" style={{ lineHeight: '1.8' }}>
                <p>
                  En la ciudad sede de la <strong>Escuela Nacional de Danza (ENDANZA)</strong>, en fecha <strong>{actaDetalle.session_date_formatted || 'la presente'}</strong>, reunidos los miembros del Consejo Docente y la Coordinación Académica, se procedió a la revisión formal del desempeño académico, artístico y disciplinario del/la estudiante:
                </p>

                <div className="p-3 bg-light rounded-3 my-3 border">
                  <CRow>
                    <CCol md={6}>
                      <strong>Nombres y Apellidos:</strong> {actaDetalle.student_name}
                    </CCol>
                    <CCol md={6}>
                      <strong>Cédula de Identidad:</strong> {actaDetalle.student_dni || 'N/A'}
                    </CCol>
                    <CCol md={6} className="mt-2">
                      <strong>Grado de Origen:</strong> {actaDetalle.origin_grade_name}
                    </CCol>
                    <CCol md={6} className="mt-2">
                      <strong>Promedio en 1er Lapso:</strong> <span className="text-success fw-bold">{actaDetalle.average_lapso1} pts / 20</span>
                    </CCol>
                  </CRow>
                </div>

                <p>
                  <strong>CONSIDERANDO:</strong> {actaDetalle.reason}
                </p>

                <p>
                  <strong>RESUELVE:</strong> {actaDetalle.resolution}. Consecuentemente, se formaliza la promoción al grado de <strong>{actaDetalle.target_grade_name}</strong> a partir del presente ciclo formativo.
                </p>
              </div>

              {/* Firmas de Autoridades */}
              <div className="mt-5 pt-4 text-center">
                <CRow className="justify-content-center g-4">
                  <CCol md={4}>
                    <div className="border-top border-dark w-75 mx-auto mb-2 opacity-75"></div>
                    <strong className="d-block small text-uppercase">Dirección General</strong>
                    <small className="text-muted">ENDANZA</small>
                  </CCol>
                  <CCol md={4}>
                    <div className="border-top border-dark w-75 mx-auto mb-2 opacity-75"></div>
                    <strong className="d-block small text-uppercase">Coordinación Académica</strong>
                    <small className="text-muted">Control de Estudios</small>
                  </CCol>
                  <CCol md={4}>
                    <div className="border-top border-dark w-75 mx-auto mb-2 opacity-75"></div>
                    <strong className="d-block small text-uppercase">Consejo Docente</strong>
                    <small className="text-muted">Firma y Sello Húmedo</small>
                  </CCol>
                </CRow>
              </div>
            </div>
          )}
        </CModalBody>
        <CModalFooter className="border-0 pt-0 no-print">
          <CButton color="secondary" variant="ghost" onClick={() => setModalActaPrintVisible(false)}>
            Cerrar
          </CButton>
          <CButton color="warning" className="text-white fw-bold d-flex align-items-center gap-2 px-4 rounded-pill" onClick={() => window.print()}>
            <CIcon icon={cilPrint} />
            Imprimir Acta Oficial
          </CButton>
        </CModalFooter>
      </CModal>

      {/* Toasts */}
      <CToaster placement="top-end">
        {toasts.map((t) => (
          <CToast key={t.id} visible color={t.type} className="border-0 shadow-lg text-white">
            <CToastHeader closeButton className="bg-transparent border-0 text-white">
              <strong className="me-auto">Promoción Anticipada</strong>
            </CToastHeader>
            <CToastBody className="fw-medium">{t.message}</CToastBody>
          </CToast>
        ))}
      </CToaster>

      <style>{`
        @media print {
          .no-print, nav, header, .sidebar, .header { display: none !important; }
          body * { visibility: hidden; }
          #acta-imprimible, #acta-imprimible * { visibility: visible; }
          #acta-imprimible { position: absolute; left: 0; top: 0; width: 100%; border: none !important; box-shadow: none !important; }
        }
      `}</style>
    </CContainer>
  );
};

export default PromocionAnticipada;
