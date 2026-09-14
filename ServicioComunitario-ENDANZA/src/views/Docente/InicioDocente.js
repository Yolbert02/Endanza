import React, { useState, useEffect, useMemo } from 'react'
import { CContainer, CRow, CCol, CSpinner } from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilSchool } from '@coreui/icons'
import { listSections } from 'src/services/scheduleService'
import { getAvailableYears, getActiveYear } from 'src/services/configService'
import { listStudents } from 'src/services/studentsService'
import useUserRole from '../../Hooks/useUserRole'

// Components
import WelcomeHeader from './components/inicio/WelcomeHeader'
import ClassGroupsList from './components/inicio/ClassGroupsList'
import StudentListModal from './components/inicio/StudentListModal'

const InicioDocente = () => {
    const { isSuperadministrador } = useUserRole()
    const [loading, setLoading] = useState(true)
    const [sections, setSections] = useState([])
    const [academicYears, setAcademicYears] = useState([])
    const [selectedYear, setSelectedYear] = useState('') // Nombre del año
    const [selectedYearId, setSelectedYearId] = useState(null) // ID del año
    const [selectedTeacher, setSelectedTeacher] = useState('')
    const [fullTeachersList, setFullTeachersList] = useState([])
    const [selectedSection, setSelectedSection] = useState(null)
    const [students, setStudents] = useState([])
    const [showStudentModal, setShowStudentModal] = useState(false)
    const [loadingStudents, setLoadingStudents] = useState(false)
    const [currentUser, setCurrentUser] = useState(null)

    useEffect(() => {
        // 1. Obtener usuario del localStorage
        const userStr = localStorage.getItem('user')
        if (userStr) {
            const user = JSON.parse(userStr)
            console.log("👤 INICIO: Usuario recuperado de localStorage:", user);
            const normalizedUser = { ...user, id: user.id || user.Id_usuario };
            setCurrentUser(normalizedUser)
            // Si es docente, seteamos su nombre completo
            const fullName = `${user.nombre} ${user.apellido}`.trim()
            setSelectedTeacher(fullName)
        }
    }, [])

    useEffect(() => {
        loadInitialData()
    }, [isSuperadministrador])

    useEffect(() => {
        if (selectedYearId) {
            fetchDashboardData()
        }
    }, [selectedYearId, selectedTeacher, currentUser])

    const loadInitialData = async () => {
        try {
            // Cargar años disponibles (objetos completos)
            const years = await getAvailableYears()

            // 2. Obtener año activo REAL del backend
            const activeYearObj = await getActiveYear()

            if (isSuperadministrador) {
                setAcademicYears(years)
                if (activeYearObj) {
                    setSelectedYear(activeYearObj.name)
                    setSelectedYearId(activeYearObj.id)
                } else if (years.length > 0) {
                    setSelectedYear(years[0].name)
                    setSelectedYearId(years[0].id)
                }
            } else {
                if (activeYearObj && activeYearObj.name) {
                    // Solo permitimos el año activo
                    setAcademicYears([activeYearObj])
                    setSelectedYear(activeYearObj.name)
                    setSelectedYearId(activeYearObj.id)
                } else if (years.length > 0) {
                    // Fallback al primero de la lista si no hay activo
                    setAcademicYears([years[0]])
                    setSelectedYear(years[0].name)
                    setSelectedYearId(years[0].id)
                }
            }
        } catch (error) {
            console.error("Error loading years:", error)
        }
    }

    const extractTeachers = (sectionsData) => {
        const teachers = new Set()

        sectionsData.forEach(section => {
            // 🟢 1. Asegurar que 'schedules' exista antes de iterar
            const schedules = section.schedules || []

            schedules.forEach(sched => {
                // 🟢 2. Evaluar 'teacher_name' (PostgreSQL) y 'teacherName' como fallback
                const teacherName = sched.teacher_name || sched.teacherName

                if (teacherName && teacherName.trim() !== '') {
                    teachers.add(teacherName.trim())
                }
            })
        })

        return Array.from(teachers).sort()
    }

    const fetchDashboardData = async () => {
        setLoading(true)
        console.log("🔍 DASHBOARD: Buscando datos para:", { teacher: selectedTeacher, year: selectedYear, yearId: selectedYearId })
        try {
            const allSections = await listSections({ academicYearId: selectedYearId })
            console.log("📦 DASHBOARD: Secciones obtenidas del backend:", allSections)

            // 1. Filtrado por año académico
            const normalizedSelectedYear = (selectedYear || '').trim()
            const yearFiltered = allSections.filter(s => {
                const sYear = (s.academic_year_name || s.academicYear || '').trim()
                return !normalizedSelectedYear || sYear === normalizedSelectedYear
            })

            // Extraer lista global de profesores para los filtros
            const teachers = extractTeachers(yearFiltered)
            setFullTeachersList(teachers)

            // 2. Datos del usuario autenticado
            const userStr = localStorage.getItem('user')
            const localUser = userStr ? JSON.parse(userStr) : null
            const currentUserId = Number(currentUser?.id || currentUser?.Id_usuario || localUser?.id || localUser?.Id_usuario)

            // Función auxiliar para normalizar cadenas (elimina tildes y espacios extra)
            const normalizeText = (text) =>
                (text || '')
                    .toLowerCase()
                    .normalize("NFD")
                    .replace(/[\u0300-\u036f]/g, "")
                    .replace(/\s+/g, ' ')
                    .trim()

            const currentTeacherName = normalizeText(selectedTeacher)

            console.log("👤 DASHBOARD: Datos para filtrado del docente:", {
                currentUserId,
                currentTeacherName
            })

            // 3. Filtrar secciones asignadas al profesor
            const teacherGroups = yearFiltered.filter(section => {
                const schedulesList = section.schedules || []

                const hasMatch = schedulesList.some(s => {
                    // Extracción de IDs posibles
                    const schedUserId = Number(s.teacher_user_id || s.teacherUserId || s.user_id)
                    const schedProfId = Number(s.teacher_id || s.teacherId || s.Id_profesor)

                    // Validación A: Por ID de Usuario
                    if (currentUserId && schedUserId && currentUserId === schedUserId) {
                        console.log(`✅ MATCH POR USER ID en [${section.sectionName || section.nombre_seccion}]`)
                        return true
                    }

                    // Validación B: Por ID de Profesor (si el usuario local guarda Id_profesor)
                    const localProfId = Number(currentUser?.Id_profesor || localUser?.Id_profesor)
                    if (localProfId && schedProfId && localProfId === schedProfId) {
                        console.log(`✅ MATCH POR PROFESOR ID en [${section.sectionName || section.nombre_seccion}]`)
                        return true
                    }

                    // Validación C: Por Nombre completo flexible
                    const schedName = normalizeText(s.teacher_name || s.teacherName || s.profesor_nombre)

                    if (schedName && currentTeacherName) {
                        // Verificación directa o por contención
                        if (schedName === currentTeacherName || schedName.includes(currentTeacherName) || currentTeacherName.includes(schedName)) {
                            console.log(`✅ MATCH POR NOMBRE EXACTO/PARCIAL en [${section.sectionName || section.nombre_seccion}]: "${schedName}" vs "${currentTeacherName}"`)
                            return true
                        }

                        // Verificación por coincidencia de palabras (Nombre O Apellido)
                        const currentTokens = currentTeacherName.split(' ').filter(t => t.length > 2)
                        const schedTokens = schedName.split(' ').filter(t => t.length > 2)

                        const tokenMatch = currentTokens.some(token => schedTokens.includes(token))
                        if (tokenMatch) {
                            console.log(`✅ MATCH POR COINCIDENCIA DE TOKEN en [${section.sectionName || section.nombre_seccion}]`)
                            return true
                        }
                    }

                    return false
                })

                return hasMatch
            })

            console.log("🎯 DASHBOARD: Secciones finales asignadas:", teacherGroups.length)
            setSections(teacherGroups)

        } catch (error) {
            console.error("Error fetching teacher dashboard:", error)
        } finally {
            setLoading(false)
        }
    }

    const handleSeeStudents = async (section) => {
        setSelectedSection(section)
        setLoadingStudents(true)
        setShowStudentModal(true)
        try {
            const studentsList = await listStudents({ sectionId: section.id })
            // Transformar al formato que espera el modal
            const transformed = studentsList.map(s => {
                const firstName = s.first_name || s.nombre || ''
                const lastName = s.last_name || s.apellido || ''
                const birthDate = s.birth_date || s.fecha_nacimiento
                let age = ''
                if (birthDate) {
                    const birth = new Date(birthDate)
                    const today = new Date()
                    age = Math.floor((today - birth) / (365.25 * 24 * 60 * 60 * 1000))
                }
                return {
                    id: s.id || s.Id_estudiante,
                    name: firstName,
                    lastName: lastName,
                    fullName: `${firstName} ${lastName}`.trim(),
                    code: s.dni || s.cedula || 'N/A',
                    status: 'Inscrito',
                    age: age || 'N/A',
                    gender: s.gender || s.genero || 'N/A',
                    academicYear: selectedYear || ''
                }
            })
            setStudents(transformed)
        } catch (error) {
            console.error("Error loading students:", error)
        } finally {
            setLoadingStudents(false)
        }
    }

    const teacherStats = useMemo(() => {
        const normalizedTeacher = (selectedTeacher || '').trim().toLowerCase()
        const totalClasses = sections.reduce((acc, sec) =>
            acc + sec.schedules.filter(s => {
                const schedTeacher = (s.teacherName || '').trim().toLowerCase()
                return schedTeacher === normalizedTeacher || schedTeacher.includes(normalizedTeacher)
            }).length, 0
        )
        return {
            groups: sections.length,
            classes: totalClasses
        }
    }, [sections, selectedTeacher])

    return (
        <CContainer fluid className="pb-5">
            <CRow>
                <CCol>
                    {/* BIENVENIDA DOCENTE */}
                    <WelcomeHeader
                        selectedYear={selectedYear}
                        setSelectedYear={(name) => {
                            setSelectedYear(name)
                            const yearObj = academicYears.find(y => y.name === name)
                            if (yearObj) setSelectedYearId(yearObj.id)
                        }}
                        academicYears={academicYears.map(y => y.name)}
                        selectedTeacher={selectedTeacher}
                        setSelectedTeacher={setSelectedTeacher}
                        fullTeachersList={fullTeachersList}
                        teacherStats={teacherStats}
                        isTeacherView={true}
                    />

                    <h4 className="mb-4 fw-bold header-title-custom text-uppercase ls-1 d-flex align-items-center">
                        <CIcon icon={cilSchool} className="me-2 text-primary" />
                        Mis Grupos de Clase
                    </h4>

                    {loading ? (
                        <div className="text-center py-5">
                            <CSpinner color="primary" variant="grow" />
                        </div>
                    ) : (
                        <ClassGroupsList
                            sections={sections}
                            selectedTeacher={selectedTeacher}
                            onSeeStudents={handleSeeStudents}
                            currentUserId={currentUser?.id || currentUser?.Id_usuario}
                        />
                    )}
                </CCol>
            </CRow>

            <StudentListModal
                show={showStudentModal}
                onClose={() => setShowStudentModal(false)}
                selectedSection={selectedSection}
                students={students}
                loadingStudents={loadingStudents}
            />
        </CContainer>
    )
}

export default InicioDocente
