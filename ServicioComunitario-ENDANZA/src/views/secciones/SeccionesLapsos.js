import React, { useState, useEffect, useMemo } from 'react'
import {
  CCard,
  CCardBody,
  CCol,
  CRow,
  CButton,
  CTable,
  CTableHead,
  CTableRow,
  CTableHeaderCell,
  CTableBody,
  CTableDataCell,
  CBadge,
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CForm,
  CFormInput,
  CFormSelect,
  CFormLabel,
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
  CSpinner,
  CAlert,
  CProgress,
  CInputGroup,
  CInputGroupText
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import {
  cilSpreadsheet,
  cilCalendar,
  cilPlus,
  cilPeople,
  cilTrash,
  cilPencil,
  cilSearch,
  cilUser
} from '@coreui/icons'

import {
  listSections,
  createSection,
  deleteSection,
  getSectionStudents,
  listLapsos,
  createLapso,
  updateLapso,
  deleteLapso,
  GRADE_LEVELS
} from '../../services/sectionsService'
import { getAvailableYears } from '../../services/configService'

const DEFAULT_SPECIALTIES = [
  { id: 7, name: 'Danza Clásica' },
  { id: 8, name: 'Danza Tradicional' },
  { id: 9, name: 'Danza Contemporánea' }
]

const SeccionesLapsos = () => {
  const [activeTab, setActiveTab] = useState(1)
  const [academicYears, setAcademicYears] = useState([])
  const [selectedYearId, setSelectedYearId] = useState(null)
  const [loading, setLoading] = useState(true)
  const [alert, setAlert] = useState(null)

  // Sections state
  const [sections, setSections] = useState([])
  const [filterGrade, setFilterGrade] = useState('')
  const [searchTerm, setSearchTerm] = useState('')
  const [isSectionModalOpen, setIsSectionModalOpen] = useState(false)
  const [savingSection, setSavingSection] = useState(false)
  const [newSection, setNewSection] = useState({
    nombre_seccion: 'A',
    nivel_academico: '1er Grado',
    capacidad: 30,
    Id_especialidad: ''
  })

  // Students in section modal state
  const [isStudentsModalOpen, setIsStudentsModalOpen] = useState(false)
  const [selectedSectionForStudents, setSelectedSectionForStudents] = useState(null)
  const [sectionStudents, setSectionStudents] = useState([])
  const [loadingStudents, setLoadingStudents] = useState(false)
  const [studentSearch, setStudentSearch] = useState('')

  // Lapsos state
  const [lapsos, setLapsos] = useState([])
  const [isLapsoModalOpen, setIsLapsoModalOpen] = useState(false)
  const [editingLapso, setEditingLapso] = useState(null)
  const [savingLapso, setSavingLapso] = useState(false)
  const [lapsoForm, setLapsoForm] = useState({
    nombre_lapso: '',
    inicio_lapso: '',
    fin_lapso: ''
  })

  // Load academic years on mount
  useEffect(() => {
    const initYears = async () => {
      try {
        setLoading(true)
        const years = await getAvailableYears()
        setAcademicYears(years || [])
        const active = years?.find((y) => y.active) || years?.[0]
        if (active) {
          setSelectedYearId(active.id)
        }
      } catch (err) {
        console.error('Error cargando años:', err)
        showAlert('danger', 'Error al cargar años académicos')
      } finally {
        setLoading(false)
      }
    }
    initYears()
  }, [])

  // Reload sections and lapsos when selectedYearId changes
  useEffect(() => {
    if (selectedYearId) {
      loadData(selectedYearId)
    }
  }, [selectedYearId])

  const showAlert = (type, message) => {
    setAlert({ type, message })
    setTimeout(() => setAlert(null), 4000)
  }

  const loadData = async (yearId) => {
    setLoading(true)
    try {
      const [secData, lapsoData] = await Promise.all([
        listSections(yearId),
        listLapsos(yearId)
      ])
      setSections(secData || [])
      setLapsos(lapsoData || [])
    } catch (err) {
      console.error('Error al cargar datos:', err)
      showAlert('danger', 'Error al sincronizar datos')
    } finally {
      setLoading(false)
    }
  }

  // Filtered sections
  const filteredSections = useMemo(() => {
    return sections.filter((s) => {
      const matchesGrade = filterGrade ? s.grade_name === filterGrade || s.nivel_academico === filterGrade : true
      const matchesSearch = searchTerm
        ? (s.section_name && s.section_name.toLowerCase().includes(searchTerm.toLowerCase())) ||
          (s.grade_name && s.grade_name.toLowerCase().includes(searchTerm.toLowerCase()))
        : true
      return matchesGrade && matchesSearch
    })
  }, [sections, filterGrade, searchTerm])

  // Handlers for Sections
  const handleOpenSectionModal = () => {
    setNewSection({
      nombre_seccion: 'A',
      nivel_academico: '1er Grado',
      capacidad: 30,
      Id_especialidad: ''
    })
    setIsSectionModalOpen(true)
  }

  const handleCreateSection = async (e) => {
    e.preventDefault()
    if (!newSection.nombre_seccion || !newSection.nivel_academico) {
      showAlert('warning', 'El nombre y nivel académico son obligatorios')
      return
    }

    try {
      setSavingSection(true)
      const payload = {
        nombre_seccion: newSection.nombre_seccion.toUpperCase().trim(),
        nivel_academico: newSection.nivel_academico,
        capacidad: parseInt(newSection.capacidad) || 30,
        Id_ano: selectedYearId,
        academic_year_id: selectedYearId,
        Id_especialidad: newSection.Id_especialidad ? parseInt(newSection.Id_especialidad) : null
      }

      const res = await createSection(payload)
      if (res.ok) {
        showAlert('success', 'Sección creada exitosamente')
        setIsSectionModalOpen(false)
        await loadData(selectedYearId)
      } else {
        showAlert('danger', res.msg || 'No se pudo crear la sección')
      }
    } catch (err) {
      console.error('Error al crear sección:', err)
      showAlert('danger', 'Error al guardar la sección')
    } finally {
      setSavingSection(false)
    }
  }

  const handleDeleteSection = async (sectionId, sectionName) => {
    if (!window.confirm(`¿Estás seguro de eliminar la Sección ${sectionName}?`)) return
    try {
      await deleteSection(sectionId)
      showAlert('success', `Sección ${sectionName} eliminada`)
      await loadData(selectedYearId)
    } catch (err) {
      console.error('Error eliminando sección:', err)
      showAlert('danger', 'Error al eliminar la sección')
    }
  }

  // Handler for viewing students
  const handleViewStudents = async (section) => {
    setSelectedSectionForStudents(section)
    setIsStudentsModalOpen(true)
    setLoadingStudents(true)
    setStudentSearch('')
    try {
      const students = await getSectionStudents(section.id)
      setSectionStudents(students || [])
    } catch (err) {
      console.error('Error al cargar alumnos:', err)
      showAlert('danger', 'Error al obtener alumnos inscritos')
    } finally {
      setLoadingStudents(false)
    }
  }

  const filteredStudents = useMemo(() => {
    if (!studentSearch) return sectionStudents
    const term = studentSearch.toLowerCase()
    return sectionStudents.filter(
      (st) =>
        (st.first_name && st.first_name.toLowerCase().includes(term)) ||
        (st.last_name && st.last_name.toLowerCase().includes(term)) ||
        (st.dni && st.dni.toLowerCase().includes(term)) ||
        (st.representative_name && st.representative_name.toLowerCase().includes(term))
    )
  }, [sectionStudents, studentSearch])

  // Handlers for Lapsos
  const handleOpenLapsoModal = (lapso = null) => {
    if (lapso) {
      setEditingLapso(lapso)
      setLapsoForm({
        nombre_lapso: lapso.name || lapso.nombre_lapso || '',
        inicio_lapso: lapso.start_date ? lapso.start_date.substring(0, 10) : '',
        fin_lapso: lapso.end_date ? lapso.end_date.substring(0, 10) : ''
      })
    } else {
      setEditingLapso(null)
      setLapsoForm({
        nombre_lapso: '',
        inicio_lapso: '',
        fin_lapso: ''
      })
    }
    setIsLapsoModalOpen(true)
  }

  const handleSaveLapso = async (e) => {
    e.preventDefault()
    if (!lapsoForm.nombre_lapso || !lapsoForm.inicio_lapso || !lapsoForm.fin_lapso) {
      showAlert('warning', 'Todos los campos del lapso son obligatorios')
      return
    }

    try {
      setSavingLapso(true)
      if (editingLapso) {
        await updateLapso(editingLapso.id, lapsoForm)
        showAlert('success', 'Lapso actualizado correctamente')
      } else {
        await createLapso(selectedYearId, lapsoForm)
        showAlert('success', 'Lapso creado exitosamente')
      }
      setIsLapsoModalOpen(false)
      await loadData(selectedYearId)
    } catch (err) {
      console.error('Error guardando lapso:', err)
      showAlert('danger', 'Error al guardar lapso')
    } finally {
      setSavingLapso(false)
    }
  }

  const handleDeleteLapso = async (lapsoId, lapsoName) => {
    if (!window.confirm(`¿Seguro que deseas eliminar el lapso "${lapsoName}"?`)) return
    try {
      await deleteLapso(lapsoId)
      showAlert('success', 'Lapso eliminado')
      await loadData(selectedYearId)
    } catch (err) {
      console.error('Error al eliminar lapso:', err)
      showAlert('danger', 'Error al eliminar lapso')
    }
  }

  const activeYearName = useMemo(() => {
    const yr = academicYears.find((y) => y.id === selectedYearId)
    return yr ? yr.name : ''
  }, [academicYears, selectedYearId])

  return (
    <div className="animated fadeIn p-2">
      {alert && (
        <CAlert color={alert.type} dismissible className="shadow-sm mb-3">
          {alert.message}
        </CAlert>
      )}

      {/* HEADER CON IDENTIDAD VISUAL ENDANZA */}
      <div className="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
        <div className="d-flex align-items-center gap-3">
          <div
            style={{
              width: '46px',
              height: '46px',
              borderRadius: '10px',
              backgroundColor: '#C35604',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#ffffff',
              boxShadow: '0 4px 12px rgba(195, 86, 4, 0.25)'
            }}
          >
            <CIcon icon={cilSpreadsheet} size="xl" />
          </div>
          <div>
            <h3 className="fw-bold mb-0" style={{ color: '#2B2827', fontSize: '1.5rem' }}>
              Gestión de Secciones y Lapsos
            </h3>
            <p className="text-muted small mb-0">
              Administración de secciones y períodos académicos para el ciclo lectivo
            </p>
          </div>
        </div>

        <div className="d-flex align-items-center gap-2">
          <span className="small text-muted fw-semibold">Año:</span>
          <CFormSelect
            value={selectedYearId || ''}
            onChange={(e) => setSelectedYearId(Number(e.target.value))}
            style={{ minWidth: '180px', borderColor: '#ECE4E0', fontWeight: '600' }}
            size="sm"
          >
            {academicYears.map((y) => (
              <option key={y.id} value={y.id}>
                {y.name} {y.active ? '(Activo)' : ''}
              </option>
            ))}
          </CFormSelect>
        </div>
      </div>

      {/* TABS Y CONTROLES */}
      <CCard className="border-0 shadow-sm mb-4" style={{ borderRadius: '12px', background: '#FFFFFF' }}>
        <div className="border-bottom px-4 pt-3">
          <CNav variant="tabs" className="border-0">
            <CNavItem>
              <CNavLink
                active={activeTab === 1}
                onClick={() => setActiveTab(1)}
                style={{
                  cursor: 'pointer',
                  fontWeight: '700',
                  color: activeTab === 1 ? '#C35604' : '#898787',
                  borderBottom: activeTab === 1 ? '3px solid #C35604' : '3px solid transparent',
                  background: 'transparent',
                  borderTop: 'none',
                  borderLeft: 'none',
                  borderRight: 'none',
                  paddingBottom: '12px'
                }}
              >
                <CIcon icon={cilSpreadsheet} className="me-2" />
                Secciones ({sections.length})
              </CNavLink>
            </CNavItem>
            <CNavItem>
              <CNavLink
                active={activeTab === 2}
                onClick={() => setActiveTab(2)}
                style={{
                  cursor: 'pointer',
                  fontWeight: '700',
                  color: activeTab === 2 ? '#C35604' : '#898787',
                  borderBottom: activeTab === 2 ? '3px solid #C35604' : '3px solid transparent',
                  background: 'transparent',
                  borderTop: 'none',
                  borderLeft: 'none',
                  borderRight: 'none',
                  paddingBottom: '12px'
                }}
              >
                <CIcon icon={cilCalendar} className="me-2" />
                Lapsos Académicos ({lapsos.length})
              </CNavLink>
            </CNavItem>
          </CNav>
        </div>

        <CCardBody className="p-4">
          <CTabContent>
            {/* ===================== TAB 1: SECCIONES ===================== */}
            <CTabPane visible={activeTab === 1}>
              {/* Barra de Búsqueda y Botón NUEVA SECCIÓN */}
              <div
                className="p-3 mb-4 rounded-3 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3"
                style={{ backgroundColor: '#FBFAF9', border: '1px solid #ECE4E0' }}
              >
                <div className="d-flex align-items-center gap-3 flex-wrap">
                  <span className="fw-bold small text-uppercase" style={{ color: '#57504D' }}>
                    Total Secciones: <span style={{ color: '#C35604', fontSize: '1.1rem' }}>{sections.length}</span>
                  </span>
                  <div style={{ minWidth: '180px' }}>
                    <CFormSelect
                      value={filterGrade}
                      onChange={(e) => setFilterGrade(e.target.value)}
                      size="sm"
                      style={{ borderColor: '#ECE4E0' }}
                    >
                      <option value="">Todos los grados</option>
                      {GRADE_LEVELS.map((g) => (
                        <option key={g.value} value={g.value}>
                          {g.label}
                        </option>
                      ))}
                    </CFormSelect>
                  </div>
                </div>

                <div className="d-flex align-items-center gap-2 flex-grow-1 justify-content-md-end">
                  <div style={{ maxWidth: '320px', width: '100%' }}>
                    <CInputGroup size="sm">
                      <CInputGroupText style={{ backgroundColor: '#FFFFFF', borderColor: '#ECE4E0' }}>
                        <CIcon icon={cilSearch} style={{ color: '#ADA5A1' }} />
                      </CInputGroupText>
                      <CFormInput
                        placeholder="Buscar por nombre de sección o grado..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        style={{ borderColor: '#ECE4E0' }}
                      />
                    </CInputGroup>
                  </div>
                  <CButton
                    className="fw-bold px-3 text-white text-nowrap"
                    style={{
                      backgroundColor: '#C35604',
                      border: 'none',
                      borderRadius: '8px',
                      boxShadow: '0 2px 8px rgba(195, 86, 4, 0.3)'
                    }}
                    onClick={handleOpenSectionModal}
                  >
                    + NUEVA SECCIÓN
                  </CButton>
                </div>
              </div>

              {/* LISTADO DE SECCIONES */}
              {loading ? (
                <div className="text-center py-5">
                  <CSpinner style={{ color: '#C35604' }} />
                  <div className="mt-2 text-muted small">Cargando secciones...</div>
                </div>
              ) : filteredSections.length === 0 ? (
                <div className="text-center py-5 border rounded-3 bg-white" style={{ borderColor: '#ECE4E0' }}>
                  <CIcon icon={cilSpreadsheet} size="xxl" style={{ color: '#C35604', opacity: 0.3 }} className="mb-2" />
                  <h5 className="fw-bold" style={{ color: '#413C3A' }}>No hay secciones registradas</h5>
                  <p className="text-muted small">
                    Haz clic en "+ NUEVA SECCIÓN" para crear las secciones de este año escolar ({activeYearName}).
                  </p>
                </div>
              ) : (
                <div className="table-responsive">
                  <CTable hover align="middle" className="border-0">
                    <CTableHead style={{ backgroundColor: '#FBFAF9', borderBottom: '2px solid #ECE4E0' }}>
                      <CTableRow>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Sección</CTableHeaderCell>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Grado / Nivel</CTableHeaderCell>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Especialidad</CTableHeaderCell>
                        <CTableHeaderCell style={{ color: '#57504D', minWidth: '180px' }}>Inscritos / Capacidad</CTableHeaderCell>
                        <CTableHeaderCell className="text-end" style={{ color: '#57504D' }}>Acciones</CTableHeaderCell>
                      </CTableRow>
                    </CTableHead>
                    <CTableBody>
                      {filteredSections.map((sec) => {
                        const count = parseInt(sec.student_count) || 0
                        const cap = parseInt(sec.capacity) || 30
                        const pct = Math.min(Math.round((count / cap) * 100), 100)
                        return (
                          <CTableRow key={sec.id} style={{ borderBottom: '1px solid #F4EFEC' }}>
                            <CTableDataCell>
                              <div
                                style={{
                                  width: '42px',
                                  height: '42px',
                                  borderRadius: '8px',
                                  backgroundColor: '#FDE1CD',
                                  color: '#C35604',
                                  fontWeight: '800',
                                  fontSize: '1.2rem',
                                  display: 'flex',
                                  alignItems: 'center',
                                  justifyContent: 'center',
                                  border: '1px solid #FBC49B'
                                }}
                              >
                                {sec.section_name}
                              </div>
                            </CTableDataCell>
                            <CTableDataCell>
                              <div className="fw-bold" style={{ color: '#2B2827' }}>
                                {sec.grade_name || sec.nivel_academico || 'General'}
                              </div>
                              <span className="small text-muted">Aplica a los 3 lapsos</span>
                            </CTableDataCell>
                            <CTableDataCell>
                              {sec.specialty_name ? (
                                <CBadge
                                  style={{
                                    backgroundColor: '#FEF0E6',
                                    color: '#C35604',
                                    border: '1px solid #FCD3B4',
                                    fontWeight: '600'
                                  }}
                                >
                                  {sec.specialty_name}
                                </CBadge>
                              ) : (
                                <span className="text-muted small">Tronco Común</span>
                              )}
                            </CTableDataCell>
                            <CTableDataCell>
                              <div className="d-flex justify-content-between small fw-semibold mb-1">
                                <span style={{ color: '#2B2827' }}>{count} alumnos</span>
                                <span className="text-muted">{cap} cupos</span>
                              </div>
                              <CProgress
                                value={pct}
                                height={6}
                                style={{
                                  backgroundColor: '#ECE4E0',
                                  borderRadius: '4px'
                                }}
                                color={pct > 90 ? 'danger' : 'warning'}
                              />
                            </CTableDataCell>
                            <CTableDataCell className="text-end">
                              <CButton
                                size="sm"
                                variant="outline"
                                className="me-2 fw-semibold"
                                style={{
                                  borderColor: '#C35604',
                                  color: '#C35604',
                                  borderRadius: '6px'
                                }}
                                onClick={() => handleViewStudents(sec)}
                              >
                                <CIcon icon={cilPeople} className="me-1" />
                                Ver Alumnos ({count})
                              </CButton>
                              <CButton
                                size="sm"
                                variant="ghost"
                                className="text-danger"
                                onClick={() => handleDeleteSection(sec.id, sec.section_name)}
                                title="Eliminar Sección"
                              >
                                <CIcon icon={cilTrash} />
                              </CButton>
                            </CTableDataCell>
                          </CTableRow>
                        )
                      })}
                    </CTableBody>
                  </CTable>
                </div>
              )}
            </CTabPane>

            {/* ===================== TAB 2: LAPSOS ACADÉMICOS ===================== */}
            <CTabPane visible={activeTab === 2}>
              <div className="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                  <h5 className="fw-bold mb-1" style={{ color: '#2B2827' }}>Lapsos del Año Académico</h5>
                  <p className="text-muted small mb-0">
                    Definición de períodos lectivos anuales (I Lapso, II Lapso, III Lapso).
                  </p>
                </div>
                <CButton
                  className="fw-bold text-white px-3"
                  style={{
                    backgroundColor: '#C35604',
                    border: 'none',
                    borderRadius: '8px',
                    boxShadow: '0 2px 8px rgba(195, 86, 4, 0.3)'
                  }}
                  onClick={() => handleOpenLapsoModal()}
                >
                  + NUEVO LAPSO
                </CButton>
              </div>

              {loading ? (
                <div className="text-center py-5">
                  <CSpinner style={{ color: '#C35604' }} />
                </div>
              ) : lapsos.length === 0 ? (
                <div className="text-center py-5 border rounded-3 bg-white" style={{ borderColor: '#ECE4E0' }}>
                  <CIcon icon={cilCalendar} size="xxl" style={{ color: '#C35604', opacity: 0.3 }} className="mb-2" />
                  <h5 className="fw-bold" style={{ color: '#413C3A' }}>No hay lapsos registrados</h5>
                  <p className="text-muted small">Crea los lapsos para el año académico actual.</p>
                </div>
              ) : (
                <div className="table-responsive">
                  <CTable hover align="middle" className="border-0">
                    <CTableHead style={{ backgroundColor: '#FBFAF9', borderBottom: '2px solid #ECE4E0' }}>
                      <CTableRow>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Nombre del Lapso</CTableHeaderCell>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Fecha de Inicio</CTableHeaderCell>
                        <CTableHeaderCell style={{ color: '#57504D' }}>Fecha de Fin</CTableHeaderCell>
                        <CTableHeaderCell className="text-end" style={{ color: '#57504D' }}>Acciones</CTableHeaderCell>
                      </CTableRow>
                    </CTableHead>
                    <CTableBody>
                      {lapsos.map((l) => (
                        <CTableRow key={l.id} style={{ borderBottom: '1px solid #F4EFEC' }}>
                          <CTableDataCell className="fw-bold" style={{ color: '#C35604' }}>
                            {l.name || l.nombre_lapso}
                          </CTableDataCell>
                          <CTableDataCell>
                            {l.start_date ? new Date(l.start_date).toLocaleDateString() : 'No definida'}
                          </CTableDataCell>
                          <CTableDataCell>
                            {l.end_date ? new Date(l.end_date).toLocaleDateString() : 'No definida'}
                          </CTableDataCell>
                          <CTableDataCell className="text-end">
                            <CButton
                              size="sm"
                              variant="ghost"
                              className="me-2"
                              style={{ color: '#C35604' }}
                              onClick={() => handleOpenLapsoModal(l)}
                            >
                              <CIcon icon={cilPencil} />
                            </CButton>
                            <CButton
                              size="sm"
                              variant="ghost"
                              className="text-danger"
                              onClick={() => handleDeleteLapso(l.id, l.name || l.nombre_lapso)}
                            >
                              <CIcon icon={cilTrash} />
                            </CButton>
                          </CTableDataCell>
                        </CTableRow>
                      ))}
                    </CTableBody>
                  </CTable>
                </div>
              )}
            </CTabPane>
          </CTabContent>
        </CCardBody>
      </CCard>

      {/* ===================== MODAL: CREAR SECCIÓN ===================== */}
      <CModal visible={isSectionModalOpen} onClose={() => setIsSectionModalOpen(false)} backdrop="static">
        <CModalHeader closeButton style={{ borderBottom: '1px solid #ECE4E0' }}>
          <CModalTitle className="fw-bold" style={{ color: '#2B2827' }}>
            Nueva Sección
          </CModalTitle>
        </CModalHeader>
        <CForm onSubmit={handleCreateSection}>
          <CModalBody className="p-4">
            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Grado / Nivel Académico
              </CFormLabel>
              <CFormSelect
                value={newSection.nivel_academico}
                onChange={(e) => setNewSection({ ...newSection, nivel_academico: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              >
                {GRADE_LEVELS.map((g) => (
                  <option key={g.value} value={g.value}>
                    {g.label}
                  </option>
                ))}
              </CFormSelect>
              <small className="text-muted">La sección aplicará para todos los lapsos de este grado.</small>
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Letra / Identificador
              </CFormLabel>
              <CFormInput
                placeholder="Ej: A, B, C, Única"
                value={newSection.nombre_seccion}
                onChange={(e) => setNewSection({ ...newSection, nombre_seccion: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              />
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Capacidad de Estudiantes
              </CFormLabel>
              <CFormInput
                type="number"
                min="1"
                max="100"
                value={newSection.capacidad}
                onChange={(e) => setNewSection({ ...newSection, capacidad: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              />
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Especialidad (Opcional para grados superiores)
              </CFormLabel>
              <CFormSelect
                value={newSection.Id_especialidad}
                onChange={(e) => setNewSection({ ...newSection, Id_especialidad: e.target.value })}
                style={{ borderColor: '#ECE4E0' }}
              >
                <option value="">Tronco Común (Sin Especialidad)</option>
                {DEFAULT_SPECIALTIES.map((esp) => (
                  <option key={esp.id} value={esp.id}>
                    {esp.name}
                  </option>
                ))}
              </CFormSelect>
            </div>
          </CModalBody>
          <CModalFooter style={{ borderTop: '1px solid #ECE4E0' }}>
            <CButton color="secondary" variant="ghost" onClick={() => setIsSectionModalOpen(false)}>
              Cancelar
            </CButton>
            <CButton
              type="submit"
              disabled={savingSection}
              style={{
                backgroundColor: '#C35604',
                borderColor: '#C35604',
                color: '#FFFFFF',
                fontWeight: '600'
              }}
            >
              {savingSection ? <CSpinner size="sm" /> : 'Guardar Sección'}
            </CButton>
          </CModalFooter>
        </CForm>
      </CModal>

      {/* ===================== MODAL: VER ALUMNOS INSCRITOS ===================== */}
      <CModal visible={isStudentsModalOpen} onClose={() => setIsStudentsModalOpen(false)} size="lg">
        <CModalHeader closeButton style={{ borderBottom: '1px solid #ECE4E0' }}>
          <CModalTitle className="fw-bold d-flex align-items-center gap-2" style={{ color: '#2B2827' }}>
            <CIcon icon={cilPeople} style={{ color: '#C35604' }} />
            Alumnos Inscritos - Sección {selectedSectionForStudents?.section_name} ({selectedSectionForStudents?.grade_name || selectedSectionForStudents?.nivel_academico})
          </CModalTitle>
        </CModalHeader>
        <CModalBody className="p-4">
          <div className="mb-3">
            <CInputGroup size="sm">
              <CInputGroupText style={{ backgroundColor: '#FFFFFF', borderColor: '#ECE4E0' }}>
                <CIcon icon={cilSearch} style={{ color: '#ADA5A1' }} />
              </CInputGroupText>
              <CFormInput
                placeholder="Buscar por nombre, apellido, cédula o representante..."
                value={studentSearch}
                onChange={(e) => setStudentSearch(e.target.value)}
                style={{ borderColor: '#ECE4E0' }}
              />
            </CInputGroup>
          </div>

          {loadingStudents ? (
            <div className="text-center py-4">
              <CSpinner style={{ color: '#C35604' }} />
              <div className="mt-2 text-muted small">Cargando alumnos...</div>
            </div>
          ) : filteredStudents.length === 0 ? (
            <div className="text-center py-4 border rounded bg-light" style={{ borderColor: '#ECE4E0' }}>
              <CIcon icon={cilUser} size="xl" className="text-muted mb-2 opacity-50" />
              <p className="text-muted mb-0 small">No hay estudiantes inscritos en esta sección.</p>
            </div>
          ) : (
            <div className="table-responsive">
              <CTable hover align="middle" className="border-0">
                <CTableHead style={{ backgroundColor: '#FBFAF9', borderBottom: '2px solid #ECE4E0' }}>
                  <CTableRow>
                    <CTableHeaderCell>#</CTableHeaderCell>
                    <CTableHeaderCell>Estudiante</CTableHeaderCell>
                    <CTableHeaderCell>Cédula</CTableHeaderCell>
                    <CTableHeaderCell>Representante</CTableHeaderCell>
                    <CTableHeaderCell>Contacto</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {filteredStudents.map((st, idx) => (
                    <CTableRow key={st.id || idx} style={{ borderBottom: '1px solid #F4EFEC' }}>
                      <CTableDataCell className="fw-bold text-muted">{idx + 1}</CTableDataCell>
                      <CTableDataCell className="fw-semibold" style={{ color: '#2B2827' }}>
                        {st.first_name} {st.last_name}
                      </CTableDataCell>
                      <CTableDataCell>{st.dni || 'Sin C.I.'}</CTableDataCell>
                      <CTableDataCell>{st.representative_name || 'No registrado'}</CTableDataCell>
                      <CTableDataCell>
                        <div className="small">{st.representative_phone || '-'}</div>
                        <div className="small text-muted">{st.representative_email || ''}</div>
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
            </div>
          )}
        </CModalBody>
        <CModalFooter style={{ borderTop: '1px solid #ECE4E0' }}>
          <CButton color="secondary" onClick={() => setIsStudentsModalOpen(false)}>
            Cerrar
          </CButton>
        </CModalFooter>
      </CModal>

      {/* ===================== MODAL: CREAR / EDITAR LAPSO ===================== */}
      <CModal visible={isLapsoModalOpen} onClose={() => setIsLapsoModalOpen(false)} backdrop="static">
        <CModalHeader closeButton style={{ borderBottom: '1px solid #ECE4E0' }}>
          <CModalTitle className="fw-bold" style={{ color: '#2B2827' }}>
            {editingLapso ? 'Editar Lapso' : 'Nuevo Lapso'}
          </CModalTitle>
        </CModalHeader>
        <CForm onSubmit={handleSaveLapso}>
          <CModalBody className="p-4">
            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Nombre del Lapso
              </CFormLabel>
              <CFormInput
                placeholder="Ej: I LAPSO, II LAPSO, III LAPSO"
                value={lapsoForm.nombre_lapso}
                onChange={(e) => setLapsoForm({ ...lapsoForm, nombre_lapso: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              />
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Fecha de Inicio
              </CFormLabel>
              <CFormInput
                type="date"
                value={lapsoForm.inicio_lapso}
                onChange={(e) => setLapsoForm({ ...lapsoForm, inicio_lapso: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              />
            </div>

            <div className="mb-3">
              <CFormLabel className="fw-semibold small" style={{ color: '#413C3A' }}>
                Fecha de Fin
              </CFormLabel>
              <CFormInput
                type="date"
                value={lapsoForm.fin_lapso}
                onChange={(e) => setLapsoForm({ ...lapsoForm, fin_lapso: e.target.value })}
                required
                style={{ borderColor: '#ECE4E0' }}
              />
            </div>
          </CModalBody>
          <CModalFooter style={{ borderTop: '1px solid #ECE4E0' }}>
            <CButton color="secondary" variant="ghost" onClick={() => setIsLapsoModalOpen(false)}>
              Cancelar
            </CButton>
            <CButton
              type="submit"
              disabled={savingLapso}
              style={{
                backgroundColor: '#C35604',
                borderColor: '#C35604',
                color: '#FFFFFF',
                fontWeight: '600'
              }}
            >
              {savingLapso ? <CSpinner size="sm" /> : 'Guardar Lapso'}
            </CButton>
          </CModalFooter>
        </CForm>
      </CModal>
    </div>
  )
}

export default SeccionesLapsos
