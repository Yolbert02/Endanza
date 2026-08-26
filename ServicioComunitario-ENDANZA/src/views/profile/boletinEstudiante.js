import React, { useState, useEffect, useCallback } from "react"
import {
  CCard,
  CCardBody,
  CCardFooter,
  CContainer,
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
  CButton,
  CRow,
  CCol,
  CToaster,
  CToast,
  CToastHeader,
  CToastBody,
  CSpinner,
  CAlert,
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter
} from "@coreui/react"
import CIcon from "@coreui/icons-react"
import { useParams, useNavigate, useLocation } from "react-router-dom"
import PeriodoTab from "./components/boletin/periodoTab"
import AcademicHeader from "./components/common/AcademicHeader"
import StudentInfoCard from "./components/common/StudentInfoCard"
import { BoletinOficialEndanza } from "../../components/BoletinOficialEndanza"
import {
  cilLockLocked,
  cilBan,
  cilCloudDownload,
  cilFolderOpen,
  cilArrowLeft,
  cilPrint
} from "@coreui/icons"
import useUserRole from '../../Hooks/useUserRole'
import { getStudentBoletines } from '../../services/studentsService'
import { getActiveYearPublic } from '../../services/configService' // 👈 CAMBIO AQUÍ

const BoletinEstudiante = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const location = useLocation()
  const { isRepresentante, isLoading: userLoading } = useUserRole()

  const [loading, setLoading] = useState(true)
  const [loadingYear, setLoadingYear] = useState(true)
  const [studentInfo, setStudentInfo] = useState(null)
  const [boletines, setBoletines] = useState([])
  const [activeYear, setActiveYear] = useState(null)
  const [activeKey, setActiveKey] = useState(null)
  const [toasts, setToasts] = useState([])
  const [modalBoletinVisible, setModalBoletinVisible] = useState(false)
  const [selectedPeriodObj, setSelectedPeriodObj] = useState(null)

  // Obtener información del estudiante del caché
  useEffect(() => {
    const studentsList = location.state?.studentsList
    if (studentsList && studentsList.length > 0) {
      const foundStudent = studentsList.find(s => s.id === parseInt(id) || s.id === id)
      if (foundStudent) {
        console.log("✅ Estudiante encontrado en caché:", foundStudent)
        setStudentInfo(foundStudent)
      }
    }
  }, [id, location.state])

  // Cargar año académico activo (usando el endpoint público)
  useEffect(() => {
    const fetchActiveYear = async () => {
      if (!isRepresentante || userLoading) return

      setLoadingYear(true)
      try {
        const year = await getActiveYearPublic() // 👈 CAMBIO AQUÍ
        console.log("📅 Año académico activo (público):", year)
        setActiveYear(year)
      } catch (error) {
        console.error("Error cargando año académico activo:", error)
        showToast("danger", "Error al cargar año académico")
      } finally {
        setLoadingYear(false)
      }
    }
    fetchActiveYear()
  }, [isRepresentante, userLoading])

  // Cargar boletines cuando se tenga el año activo
  useEffect(() => {
    if (!activeYear) return

    const fetchBoletines = async () => {
      setLoading(true)
      try {
        console.log(`📥 Cargando boletines para estudiante ${id} en año ${activeYear.id}`)
        const data = await getStudentBoletines(id)
        console.log("📊 Boletines recibidos:", data)
        setBoletines(data)

        // Seleccionar primer período disponible
        if (data.length > 0 && data[0].periods.length > 0) {
          setActiveKey(data[0].periods[0].period_id)
        }
      } catch (error) {
        console.error("❌ Error cargando boletines:", error)
        showToast("danger", "Error al cargar boletines")
      } finally {
        setLoading(false)
      }
    }
    fetchBoletines()
  }, [id, activeYear])

  // Redirigir si no es representante
  useEffect(() => {
    if (!userLoading && !isRepresentante) {
      console.log("🚫 No es representante, redirigiendo a /inicio")
      navigate('/inicio')
    }
  }, [isRepresentante, userLoading, navigate])

  const showToast = useCallback((type, message) => {
    const id = Date.now()
    const newToast = { id, type, message }
    setToasts(prev => [...prev, newToast])
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id))
    }, 4000)
  }, [])

  const handleDescargarBoletin = useCallback((periodoId) => {
    const period = boletines[0]?.periods.find(p => p.period_id === periodoId);
    setSelectedPeriodObj(period || boletines[0]?.periods[0] || null);
    setModalBoletinVisible(true);
  }, [boletines]);

  const handleGoBack = () => {
    navigate('/inicio-boletines')
  }

  if (userLoading || loadingYear) {
    return (
      <CContainer className="py-5 text-center">
        <CSpinner color="warning" />
        <p className="mt-2 text-muted">Cargando información académica...</p>
      </CContainer>
    )
  }

  if (!studentInfo) {
    return (
      <CContainer className="py-5">
        <CAlert color="danger">Estudiante no encontrado</CAlert>
        <CButton className="btn-back-premium px-4" onClick={handleGoBack}>Volver a Boletines</CButton>
      </CContainer>
    )
  }

  const hasBoletines = boletines.length > 0 && boletines[0].periods.length > 0

  return (
    <CContainer className="py-4 animate__animated animate__fadeIn">
      <CButton
        onClick={handleGoBack}
        className="mb-3 btn-back-premium px-3 py-2"
      >
        <CIcon icon={cilArrowLeft} className="me-2" />
        Volver a lista de estudiantes
      </CButton>

      <CCard className="premium-card border-0 overflow-hidden shadow-lg pb-4">
        <AcademicHeader
          title="Expediente Académico"
          subtitle="Consulta de Boletines"
          studentCode={`EST-${studentInfo.id}`}
          icon={cilFolderOpen}
          colorClass="warning"
        />

        <CCardBody className="p-3 p-md-5">
          <CRow className="mb-4">
            <CCol md={12}>
              <StudentInfoCard
                student={{
                  nombre: studentInfo.full_name,
                  dni: studentInfo.dni,
                  grado: studentInfo.grade_level,
                  representante: studentInfo.representante || 'N/A'
                }}
                colorClass="warning"
              />
            </CCol>
          </CRow>

          {activeYear && (
            <div className="mb-4 text-center p-3 bg-warning bg-opacity-10 rounded-3 border border-warning border-opacity-20">
              <h6 className="text-warning fw-bold mb-0">
                <CIcon icon={cilFolderOpen} className="me-2" />
                Año Académico Activo: {activeYear.name}
              </h6>
            </div>
          )}

          {loading ? (
            <div className="text-center py-5">
              <CSpinner color="warning" />
              <p className="mt-2">Cargando boletines...</p>
            </div>
          ) : !hasBoletines ? (
            <div className="text-center py-5">
              <div className="p-4 bg-orange-soft rounded-circle d-inline-flex mb-4 shadow-sm">
                <CIcon icon={cilBan} size="4xl" className="text-warning" />
              </div>
              <h3 className="fw-bold mb-3">Sin Boletines Disponibles</h3>
              <p className="text-muted mx-auto mb-4" style={{ maxWidth: '500px' }}>
                No hay boletines publicados para este estudiante en el año académico actual.
              </p>
            </div>
          ) : (
            <div className="px-md-2">
              <CNav variant="pills" className="bg-nav-pills p-2 rounded-pill mb-4 d-flex flex-nowrap overflow-auto gap-2 shadow-sm">
                {boletines[0]?.periods.map(period => (
                  <CNavItem key={period.period_id} className="flex-shrink-0">
                    <CNavLink
                      className={`rounded-pill px-4 fw-bold py-2 transition-all ${activeKey === period.period_id
                          ? 'bg-warning text-white shadow-sm'
                          : 'nav-pill-link hover-bg-orange-soft'
                        }`}
                      style={{ cursor: 'pointer', whiteSpace: 'nowrap' }}
                      onClick={() => setActiveKey(period.period_id)}
                    >
                      {period.period_name}
                    </CNavLink>
                  </CNavItem>
                ))}
              </CNav>

              <CTabContent className="mt-2">
                {boletines[0]?.periods.map(period => (
                  <CTabPane key={period.period_id} visible={activeKey === period.period_id}>
                    <PeriodoTab
                      notas={period.subjects.map(s => ({
                        materia: s.subject_name,
                        codigo: `MAT-${s.subject_id}`,
                        nota: s.final_score,
                        creditos: s.subject_year,
                        tipo: s.subject_type,
                        revision: s.revision,
                        observacion: s.final_score >= 10 ? 'Aprobado' : 'Reprobado',
                        docente: 'Docente asignado'
                      }))}
                      periodoNumero={period.period_id}
                      periodoNombre={period.period_name}
                      estadoSecretaria={period.subjects[0]?.available ? 'aprobado' : 'pendiente'}
                      fechaAprobacion={period.subjects[0]?.issue_date}
                      aprobadoPor="Secretaría Académica"
                      onDescargar={() => handleDescargarBoletin(period.period_id)}
                    />
                  </CTabPane>
                ))}
              </CTabContent>
            </div>
          )}
        </CCardBody>

        <CCardFooter className="border-0 py-4 text-center bg-transparent">
          <small className="text-muted fw-bold text-uppercase ls-1 opacity-75" style={{ fontSize: '0.7rem' }}>
            <CIcon icon={cilLockLocked} className="me-2" size="sm" />
            Documento Oficial Validado por la Coordinación Académica
          </small>
        </CCardFooter>
      </CCard>

      {/* Modal de Boletín Oficial Imprimible ENDANZA */}
      <CModal
        visible={modalBoletinVisible}
        onClose={() => setModalBoletinVisible(false)}
        size="xl"
        backdrop="static"
        className="modal-boletin-oficial"
      >
        <CModalHeader className="bg-light-custom border-bottom d-flex justify-content-between align-items-center">
          <CModalTitle className="fw-bold text-dark fs-5">
            Boletín Académico Oficial — ENDANZA
          </CModalTitle>
        </CModalHeader>
        <CModalBody className="p-0 bg-secondary bg-opacity-10 overflow-auto" style={{ maxHeight: '80vh' }}>
          {selectedPeriodObj && (
            <BoletinOficialEndanza
              estudiante={{
                nombre: studentInfo.full_name,
                nombres: studentInfo.first_name || studentInfo.full_name,
                apellidos: studentInfo.last_name || '',
                cedula: studentInfo.dni,
                grado: studentInfo.grade_level,
                seccion: studentInfo.seccion || 'A',
                anioEscolar: activeYear?.name || '2024 - 2025'
              }}
              calificaciones={selectedPeriodObj.subjects.map(s => ({
                asignatura: s.subject_name,
                lapso1: s.final_score,
                lapso2: null,
                lapso3: null,
                definitiva: s.final_score,
                reparacion: s.revision?.nota_revision || null,
                inasistencias: s.inasistencias || 0,
                clasesProgramadas: 40,
                tipo: s.subject_type
              }))}
              promocion={boletines[0]?.promocion || null}
              lapsoActual={selectedPeriodObj.period_id || 1}
            />
          )}
        </CModalBody>
        <CModalFooter className="bg-light-custom border-top d-flex justify-content-between">
          <CButton
            color="secondary"
            variant="ghost"
            onClick={() => setModalBoletinVisible(false)}
          >
            Cerrar
          </CButton>
          <CButton
            className="btn-premium d-flex align-items-center px-4"
            onClick={() => window.print()}
          >
            <CIcon icon={cilPrint} className="me-2" />
            Imprimir / Guardar PDF
          </CButton>
        </CModalFooter>
      </CModal>

      <CToaster placement="top-end">
        {toasts.map((t) => (
          <CToast key={t.id} visible color={t.type} className="border-0 shadow-lg text-white">
            <CToastHeader closeButton className="bg-transparent border-0 text-white">
              <strong className="me-auto">Sistema Académico</strong>
            </CToastHeader>
            <CToastBody className="fw-medium">{t.message}</CToastBody>
          </CToast>
        ))}
      </CToaster>

      <style>{`
        .ls-1 { letter-spacing: 1px; }
        .transition-all { transition: all 0.2s ease; }
        .bg-nav-pills { background-color: var(--neutral-100); }
        .nav-pill-link { color: var(--neutral-600); }
        .nav-pill-link:hover { background-color: rgba(242, 140, 15, 0.05); color: #F28C0F; }
        
        [data-coreui-theme="dark"] .bg-nav-pills { background-color: rgba(255, 255, 255, 0.05); }
        [data-coreui-theme="dark"] .nav-pill-link { color: rgba(255, 255, 255, 0.6); }
        [data-coreui-theme="dark"] .nav-pill-link:hover { background-color: rgba(242, 140, 15, 0.1); color: #F28C0F; }
      `}</style>
    </CContainer>
  )
}

export default BoletinEstudiante