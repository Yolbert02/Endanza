// src/views/horarios/HorarioForm.jsx - VERSIÓN CORREGIDA CON NIVEL ACADÉMICO
import React, { useState, useEffect } from 'react'
import {
    CModal,
    CModalHeader,
    CModalTitle,
    CModalBody,
    CForm,
    CFormInput,
    CModalFooter,
    CButton,
    CFormSelect,
    CRow,
    CCol,
    CCard,
    CCardBody,
    CTable,
    CTableHead,
    CTableRow,
    CTableHeaderCell,
    CTableBody,
    CTableDataCell,
    CBadge,
    CSpinner
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import {
    cilCalendar,
    cilPlus,
    cilTrash,
    cilWarning,
    cilSchool,
    cilClock,
    cilUser
} from '@coreui/icons'

// SERVICIOS REALES
import * as TeacherService from '../../services/teacherService'
import {
    getClassrooms,
    getDays,
    getBlocks,
    checkAvailability,
    createSection,
    updateSection,
    addScheduleToSection
} from '../../services/scheduleService'

// Constantes alineadas con la base de datos de materias
const SUBJECTS = [
    { id: 5, value: 'Danza Clásica', label: 'Danza Clásica' },
    { id: 21, value: 'Danza Contemporánea', label: 'Danza Contemporánea' },
    { id: 2, value: 'Danza Tradicional', label: 'Danza Tradicional' },
    { id: 7, value: 'Danza Creativa', label: 'Danza Creativa' },
    { id: 3, value: 'Preparación Física', label: 'Preparación Física' },
    { id: 4, value: 'Música', label: 'Música' },
    { id: 16, value: 'Historia de la Danza', label: 'Historia de la Danza' },
    { id: 18, value: 'Nutrición', label: 'Nutrición' },
    { id: 41, value: 'Kinesiología', label: 'Kinesiología' },
    { id: 25, value: 'Francés', label: 'Francés' },
    { id: 40, value: 'Composición Coreográfica', label: 'Composición Coreográfica' },
    { id: 49, value: 'Danza de Carácter', label: 'Danza de Carácter' }
]

const GRADE_LEVELS = [
    { value: 'Preparatorio', label: 'Preparatorio' },
    { value: '1er Grado', label: '1er Grado' },
    { value: '2do Grado', label: '2do Grado' },
    { value: '3er Grado', label: '3er Grado' },
    { value: '4to Grado', label: '4to Grado' },
    { value: '5to Grado', label: '5to Grado' },
    { value: '6to Grado', label: '6to Grado' },
    { value: '7mo Grado', label: '7mo Grado' },
    { value: '8vo Grado', label: '8vo Grado' }
]

const DEFAULT_SPECIALTIES = [
    { id: 7, value: 'Danza Clásica', label: 'Danza Clásica', name: 'Danza Clásica' },
    { id: 8, value: 'Danza Tradicional', label: 'Danza Tradicional', name: 'Danza Tradicional' },
    { id: 9, value: 'Danza Contemporánea', label: 'Danza Contemporánea', name: 'Danza Contemporánea' }
]

export const isSpecialtyRequired = (grade) => {
    if (!grade) return false;
    const g = String(grade).toLowerCase().trim();
    return (
        g === '6to grado' || g === '7mo grado' || g === '8vo grado' ||
        g === '6to_grado' || g === '7mo_grado' || g === '8vo_grado' ||
        g.includes('6to') || g.includes('7mo') || g.includes('8vo') ||
        g === '6' || g === '7' || g === '8' ||
        g.includes('sexto') || g.includes('septimo') || g.includes('séptimo') || g.includes('octavo')
    );
};

const HorarioForm = ({ visible, onClose, onSave, initial = null, academicYear }) => {
    // ============================================
    // ESTADOS PARA DATOS DEL FORMULARIO
    // ============================================
    const [sectionName, setSectionName] = useState('')
    const [gradeLevel, setGradeLevel] = useState('1er Grado')
    const [specialty, setSpecialty] = useState('')
    const [specialtiesList, setSpecialtiesList] = useState(DEFAULT_SPECIALTIES)
    const [section, setSection] = useState('')
    const [errorModal, setErrorModal] = useState({ visible: false, message: '' })
    const [schedules, setSchedules] = useState([])
    const [saving, setSaving] = useState(false)

    // Manejador del cambio de nivel académico con actualización inmediata
    const handleGradeLevelChange = (e) => {
        const selectedGrade = e.target.value;
        setGradeLevel(selectedGrade);
        if (!isSpecialtyRequired(selectedGrade)) {
            setSpecialty('');
        }
    };

    // ============================================
    // ESTADOS PARA DATOS DE CATÁLOGOS (DESDE BD)
    // ============================================
    const [teachers, setTeachers] = useState([])
    const [classrooms, setClassrooms] = useState([])
    const [days, setDays] = useState([])
    const [blocks, setBlocks] = useState([])
    const [loadingCatalogs, setLoadingCatalogs] = useState(false)

    // ============================================
    // ESTADO PARA NUEVO HORARIO (CON IDS)
    // ============================================
    const [newSchedule, setNewSchedule] = useState({
        subject: 'Danza Clásica',
        subjectId: 1,
        teacherId: '',
        classroomId: '',
        dayId: '',
        blockId: ''
    })

    // ============================================
    // EFECTOS
    // ============================================

    // Cargar datos cuando se abre el modal
    useEffect(() => {
        if (visible) {
            if (initial) {
                setSectionName(initial.sectionName || '')
                setGradeLevel(initial.gradeLevel || '1er Grado')
                setSpecialty(initial.specialty || initial.specialty_name || initial.nombre_especialidad || initial.especialidad || '')
                setSection(initial.section || '')
                
                // Normalizar horarios existentes marcándolos como ya persistidos en la base de datos
                const initialSchedules = (initial.schedules || []).map(s => {
                    const matchedSubject = SUBJECTS.find(sub => sub.id === s.subject_id || sub.value === s.subject || sub.value === s.subject_name);
                    return {
                        id: s.id,
                        subject: s.subject || s.subject_name || s.subjectName || matchedSubject?.value || 'Danza Clásica',
                        subjectId: s.subject_id || s.subjectId || matchedSubject?.id || null,
                        teacherId: s.teacher_id || s.teacherId || s.teacher_user_id || s.teacherUserId,
                        teacherName: s.teacher_name || s.teacherName || 'Docente',
                        classroomId: s.classroom_id || s.classroomId,
                        classroom: s.classroom_name || s.classroomName || s.classroom || 'Aula',
                        dayId: s.day_id || s.dayId,
                        dayOfWeek: s.day_name || s.dayName || s.dayOfWeek || 'LUNES',
                        blockId: s.block_id || s.blockId,
                        startTime: (s.start_time || s.startTime || '00:00').substring(0, 5),
                        endTime: (s.end_time || s.endTime || '00:00').substring(0, 5),
                        isPersisted: true
                    };
                });
                setSchedules(initialSchedules);
            } else {
                setSectionName('')
                setGradeLevel('1er Grado')
                setSpecialty('')
                setSection('')
                setSchedules([])
                setNewSchedule({
                    subject: 'Danza Clásica',
                    subjectId: 5,
                    teacherId: '',
                    classroomId: '',
                    dayId: '',
                    blockId: ''
                })
            }

            // Cargar catálogos si hay año académico seleccionado
            if (academicYear) {
                loadCatalogData()
            } else {
                console.warn('⚠️ No hay año académico seleccionado')
                setErrorModal({
                    visible: true,
                    message: 'Error: No hay año académico seleccionado. Por favor, selecciona un año primero.'
                })
            }
        }
    }, [visible, initial, academicYear])

    // ============================================
    // FUNCIONES AUXILIARES
    // ============================================

    const addMinutes = (time, minsToAdd) => {
        try {
            const [h, m] = time.split(':').map(Number);
            const date = new Date();
            date.setHours(h);
            date.setMinutes(m + minsToAdd);
            const newH = String(date.getHours()).padStart(2, '0');
            const newM = String(date.getMinutes()).padStart(2, '0');
            return `${newH}:${newM}`;
        } catch { return time; }
    }

    const formatTime = (time) => {
        if (!time) return ''
        const [hours, minutes] = time.split(':')
        return `${hours}:${minutes}`
    }

    const isOverlapping = (start1, end1, start2, end2) => {
        return start1 < end2 && start2 < end1
    }

    // ============================================
    // CARGA DE DATOS DESDE BD
    // ============================================

    const loadCatalogData = async () => {
        setLoadingCatalogs(true)
        try {
            console.log('📥 Cargando profesores para año:', academicYear.id)
            const teachersRes = await TeacherService.getAll(academicYear.id)
            console.log('👨‍🏫 Profesores cargados:', teachersRes)
            setTeachers(teachersRes || [])

            // Cargar aulas
            const classroomsRes = await getClassrooms()
            console.log('🏫 Aulas cargadas:', classroomsRes)
            setClassrooms(classroomsRes || [])

            // Cargar días
            const daysRes = await getDays()
            console.log('📅 Días cargados:', daysRes)
            setDays(daysRes || [])

            // Cargar bloques
            const blocksRes = await getBlocks()
            console.log('⏰ Bloques cargados:', blocksRes)
            setBlocks(blocksRes || [])

            // Cargar catálogo de especialidades
            try {
                const specialtiesRes = await TeacherService.getSpecialties()
                if (specialtiesRes && specialtiesRes.length > 0) {
                    setSpecialtiesList(specialtiesRes.map(s => ({
                        id: s.id || s.Id_especialidad,
                        value: s.name || s.nombre_especialidad,
                        label: s.name || s.nombre_especialidad,
                        name: s.name || s.nombre_especialidad
                    })))
                }
            } catch (espErr) {
                console.warn('⚠️ Usando catálogo por defecto de especialidades:', espErr.message)
            }
        } catch (error) {
            console.error('❌ Error loading catalog data:', error)
            setErrorModal({ visible: true, message: 'Error al cargar datos del formulario' })
        } finally {
            setLoadingCatalogs(false)
        }
    }

    // ============================================
    // MANEJADORES DE HORARIOS
    // ============================================

    const handleAddSchedule = async () => {
        // Validar que hay año académico
        if (!academicYear || !academicYear.id) {
            setErrorModal({
                visible: true,
                message: 'Error: No hay año académico seleccionado'
            })
            return
        }

        // Validar campos requeridos
        if (!newSchedule.subject || !newSchedule.teacherId || !newSchedule.classroomId ||
            !newSchedule.dayId || !newSchedule.blockId) {
            setErrorModal({ visible: true, message: 'Por favor complete todos los campos del horario.' })
            return
        }

        // Obtener el bloque seleccionado para conocer horas
        const selectedBlock = blocks.find(b => b.id === parseInt(newSchedule.blockId))
        if (!selectedBlock) {
            setErrorModal({ visible: true, message: 'Error al obtener información del bloque horario' })
            return
        }

        try {
            // 1. Conflicto LOCAL de aula (mismo día y bloque)
            const hasClassroomLocalConflict = schedules.some(s =>
                parseInt(s.dayId) === parseInt(newSchedule.dayId) &&
                parseInt(s.blockId) === parseInt(newSchedule.blockId) &&
                parseInt(s.classroomId) === parseInt(newSchedule.classroomId)
            );

            if (hasClassroomLocalConflict) {
                const classroom = classrooms.find(c => c.id === parseInt(newSchedule.classroomId));
                setErrorModal({
                    visible: true,
                    message: `El aula ${classroom?.name || 'seleccionada'} ya se encuentra ocupada en este bloque y día.`
                });
                return;
            }

            // Conflicto LOCAL de profesor (mismo día y bloque)
            const hasTeacherLocalConflict = schedules.some(s =>
                parseInt(s.dayId) === parseInt(newSchedule.dayId) &&
                parseInt(s.blockId) === parseInt(newSchedule.blockId) &&
                parseInt(s.teacherId) === parseInt(newSchedule.teacherId)
            );

            if (hasTeacherLocalConflict) {
                const teacher = teachers.find(t => t.id === parseInt(newSchedule.teacherId));
                setErrorModal({
                    visible: true,
                    message: `El profesor ${teacher ? `${teacher.first_name} ${teacher.last_name}` : 'seleccionado'} ya tiene una clase asignada en este bloque y día.`
                });
                return;
            }

            // 2. Validación de disponibilidad GLOBAL en el backend
            const availability = await checkAvailability({
                academicYearId: academicYear?.id,
                dayId: newSchedule.dayId,
                blockId: newSchedule.blockId,
                classroomId: newSchedule.classroomId,
                teacherId: newSchedule.teacherId
            });

            if (!availability.available) {
                setErrorModal({
                    visible: true,
                    message: availability.message || 'Conflicto de horario'
                });
                return;
            }

            // 3. Preparar datos para visualización
            const teacher = teachers.find(t => t.id === parseInt(newSchedule.teacherId));
            const classroom = classrooms.find(c => c.id === parseInt(newSchedule.classroomId));
            const day = days.find(d => d.id === parseInt(newSchedule.dayId));
            const block = blocks.find(b => b.id === parseInt(newSchedule.blockId));
            const selectedSubject = SUBJECTS.find(s => s.value === newSchedule.subject);

            const targetSectionId = initial?.id || initial?.section_id;
            let realScheduleId = null;

            // 4. Si la sección ya existe, insertar de inmediato en la base de datos
            if (targetSectionId) {
                const schedulePayload = {
                    classroom_id: parseInt(newSchedule.classroomId),
                    teacher_id: parseInt(newSchedule.teacherId),
                    block_id: parseInt(newSchedule.blockId),
                    day_id: parseInt(newSchedule.dayId),
                    subject_id: selectedSubject?.id || null,
                    subject_name: newSchedule.subject || selectedSubject?.value || null
                };
                const res = await addScheduleToSection(targetSectionId, schedulePayload);
                realScheduleId = res?.schedule?.id || res?.id;
            }

            const scheduleId = realScheduleId || (Math.max(...schedules.map(s => Number(s.id) || 0), 0) + 1);

            // 5. Agregar de inmediato el bloque a la lista visual
            setSchedules(prev => [...prev, {
                id: scheduleId,
                subject: newSchedule.subject,
                subjectId: selectedSubject?.id || null,
                teacherId: newSchedule.teacherId,
                teacherName: teacher ? `${teacher.first_name} ${teacher.last_name}` : 'Sin nombre',
                classroomId: newSchedule.classroomId,
                classroom: classroom?.name || 'Sin aula',
                dayId: newSchedule.dayId,
                dayOfWeek: day?.name?.toUpperCase() || 'LUNES',
                blockId: newSchedule.blockId,
                startTime: block?.start_time?.substring(0, 5) || '00:00',
                endTime: block?.end_time?.substring(0, 5) || '00:00',
                isPersisted: !!targetSectionId
            }]);

            // 6. Resetear campos para permitir agregar el próximo bloque fluido
            setNewSchedule({
                subject: newSchedule.subject,
                subjectId: selectedSubject?.id || 5,
                teacherId: '',
                classroomId: '',
                dayId: '',
                blockId: ''
            });

        } catch (error) {
            console.error('Error adding schedule:', error);
            setErrorModal({ visible: true, message: error.message || 'Error al agregar horario' });
        }
    }

    // Manejar cambio de materia
    const handleSubjectChange = (e) => {
        const selectedValue = e.target.value;
        const selectedSubject = SUBJECTS.find(s => s.value === selectedValue);

        setNewSchedule({
            ...newSchedule,
            subject: selectedValue,
            subjectId: selectedSubject?.id || null
        });
    };

    const handleRemoveSchedule = async (id) => {
        const itemToRemove = schedules.find(s => s.id === id);
        const targetSectionId = initial?.id || initial?.section_id;
        if (targetSectionId && itemToRemove?.isPersisted) {
            try {
                await removeScheduleFromSection(targetSectionId, id);
            } catch (err) {
                console.warn('Error al eliminar horario en backend:', err);
            }
        }
        setSchedules(schedules.filter(schedule => schedule.id !== id));
    }

    // ============================================
    // CÁLCULOS
    // ============================================

    const calculateTotalHours = () => {
        if (schedules.length === 0) return 0
        let totalMinutes = 0
        schedules.forEach(schedule => {
            const block = blocks.find(b => b.id === schedule.blockId)
            if (block) {
                const start = new Date(`2000-01-01T${block.start_time}`)
                const end = new Date(`2000-01-01T${block.end_time}`)
                totalMinutes += (end - start) / (1000 * 60)
            }
        })
        return Math.round(totalMinutes / 60)
    }

    // ============================================
    // VALIDACIÓN Y ENVÍO - VERSIÓN CORREGIDA CON NIVEL ACADÉMICO
    // ============================================

    const validateForm = () => {
        if (!sectionName.trim()) {
            setErrorModal({ visible: true, message: 'El nombre de la sección es obligatorio' })
            return false
        }
        if (!gradeLevel) {
            setErrorModal({ visible: true, message: 'El grado es obligatorio' })
            return false
        }
        if (isSpecialtyRequired(gradeLevel) && !specialty) {
            setErrorModal({ visible: true, message: 'Debe seleccionar una especialidad para 6to, 7mo u 8vo grado' })
            return false
        }
        return true
    }

    const handleSubmit = async (e) => {
        e.preventDefault()
        e.stopPropagation()

        if (saving) return

        if (!validateForm()) return

        if (!academicYear || !academicYear.id) {
            setErrorModal({
                visible: true,
                message: 'Error: No hay año académico seleccionado. Por favor, selecciona un año primero.'
            })
            return
        }

        setSaving(true)

        try {
            // Detectar si estamos en modo edición verificando la existencia del ID en 'initial'
            const isEditing = Boolean(initial?.id || initial?.section_id)
            const targetSectionId = initial?.id || initial?.section_id

            const selectedSpecialtyObj = specialtiesList.find(s => s.value === specialty || s.name === specialty || s.label === specialty);

            // Datos de la sección a procesar
            const sectionData = {
                sectionName: sectionName.trim(),
                gradeLevel: gradeLevel,  // Nivel académico
                section: section,         // Letra de la sección
                capacity: 30,
                specialty: isSpecialtyRequired(gradeLevel) ? specialty : null,
                specialtyId: isSpecialtyRequired(gradeLevel) ? (selectedSpecialtyObj?.id || null) : null,
                Id_especialidad: isSpecialtyRequired(gradeLevel) ? (selectedSpecialtyObj?.id || null) : null,
                especialidad_id: isSpecialtyRequired(gradeLevel) ? (selectedSpecialtyObj?.id || null) : null
            }

            let currentSection = null

            if (isEditing) {
                // PASO 1A: Actualizar la sección existente si es edición
                console.log(`📝 Actualizando sección ID ${targetSectionId}:`, sectionData)
                const updatedSection = await updateSection(targetSectionId, sectionData)
                currentSection = updatedSection || { id: targetSectionId, ...sectionData }
            } else {
                // PASO 1B: Crear la sección si es un registro nuevo
                console.log('📤 Creando nueva sección:', {
                    sectionData,
                    academicYearId: academicYear.id,
                    gradeLevel: gradeLevel
                })
                currentSection = await createSection(sectionData, academicYear.id)
                console.log('✅ Sección creada:', currentSection)
            }

            const activeSectionId = currentSection.id || targetSectionId

            // PASO 2: Si hay horarios en la lista local, guardarlos
            if (schedules.length > 0 && activeSectionId) {
                console.log(`📤 Guardando ${schedules.length} horarios para la sección ${activeSectionId}...`)

                let horariosGuardados = 0
                let horariosConError = 0

                for (const schedule of schedules) {
                    if (schedule.isPersisted) {
                        continue;
                    }
                    try {
                        const scheduleData = {
                            classroom_id: schedule.classroomId,
                            teacher_id: schedule.teacherId,
                            block_id: schedule.blockId,
                            day_id: schedule.dayId,
                            subject_id: schedule.subjectId,
                            subject_name: schedule.subject || null
                        }

                        console.log('📤 Guardando horario:', scheduleData)

                        // Agregar el horario a la sección activa (nueva o editada)
                        await addScheduleToSection(activeSectionId, scheduleData)
                        horariosGuardados++

                    } catch (error) {
                        console.error('❌ Error guardando horario:', error)
                        horariosConError++
                    }
                }

                console.log(`✅ Horarios guardados: ${horariosGuardados}, Errores: ${horariosConError}`)

                if (horariosConError > 0) {
                    setErrorModal({
                        visible: true,
                        message: `Se procesó la sección pero ${horariosConError} horarios no pudieron guardarse.`
                    })
                }
            }

            // Objeto de respuesta completo para enviar a la función del padre
            const sectionCompleta = {
                ...currentSection,
                id: activeSectionId,
                gradeLevel: gradeLevel,
                sectionName: sectionName.trim(),
                section: section
            }

            if (onSave) {
                await onSave(sectionCompleta)
            }

            onClose()

        } catch (error) {
            console.error('❌ Error en handleSubmit:', error)
            setErrorModal({
                visible: true,
                message: error.message || 'Error al procesar la sección'
            })
        } finally {
            setSaving(false)
        }
    }

    // ============================================
    // RENDER
    // ============================================

    return (
        <>
            <CModal size="xl" visible={visible} onClose={onClose} backdrop="static" className="premium-modal">
                <CModalHeader className="bg-primary text-white border-0 py-3">
                    <CModalTitle className="fw-bold d-flex align-items-center ls-1 small">
                        <CIcon icon={cilSchool} className="me-2" />
                        {initial ? 'EDITAR SECCIÓN' : 'NUEVA SECCIÓN ACADÉMICA'}
                        {academicYear && (
                            <span className="ms-3 small text-white-50">
                                {academicYear.name}
                            </span>
                        )}
                    </CModalTitle>
                </CModalHeader>

                <CForm onSubmit={handleSubmit}>
                    <CModalBody className="p-4 bg-light-custom bg-opacity-10" style={{ maxHeight: '75vh', overflowY: 'auto' }}>

                        {/* SECCIÓN 1: DATOS GENERALES */}
                        <CCard className="border-0 shadow-lg mb-4 premium-card">
                            <CCardBody className="p-4">
                                <h6 className="mb-4 text-primary fw-bold text-uppercase small ls-1 border-bottom border-light-custom border-opacity-10 pb-3">
                                    Datos Generales
                                </h6>
                                <CRow className="g-4">
                                    <CCol md={isSpecialtyRequired(gradeLevel) ? 4 : 5}>
                                        <CFormInput
                                            label={<span className="text-muted-custom small fw-bold text-uppercase ls-1">Nombre de la Sección</span>}
                                            placeholder="Ej: 6to Grado A"
                                            value={sectionName}
                                            onChange={(e) => setSectionName(e.target.value)}
                                            required
                                            className="bg-light-custom border-light-custom header-title-custom fw-bold shadow-sm py-2"
                                        />
                                    </CCol>
                                    <CCol md={isSpecialtyRequired(gradeLevel) ? 3 : 4}>
                                        <CFormSelect
                                            label={<span className="text-muted-custom small fw-bold text-uppercase ls-1">Nivel Académico</span>}
                                            value={gradeLevel}
                                            onChange={handleGradeLevelChange}
                                            required
                                            className="bg-light-custom border-light-custom header-title-custom fw-bold shadow-sm py-2"
                                        >
                                            {GRADE_LEVELS.map(grade => (
                                                <option key={grade.value} value={grade.value}>{grade.label}</option>
                                            ))}
                                        </CFormSelect>
                                    </CCol>
                                    {isSpecialtyRequired(gradeLevel) && (
                                        <CCol md={3} className="animate__animated animate__fadeIn">
                                            <CFormSelect
                                                label={
                                                    <span className="text-muted-custom small fw-bold text-uppercase ls-1 text-primary">
                                                        Especialidad <span className="text-danger">*</span>
                                                    </span>
                                                }
                                                value={specialty}
                                                onChange={(e) => setSpecialty(e.target.value)}
                                                required
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold shadow-sm py-2"
                                            >
                                                <option value="">Seleccione especialidad...</option>
                                                {specialtiesList.map(esp => (
                                                    <option key={esp.id || esp.value} value={esp.value}>
                                                        {esp.label || esp.name}
                                                    </option>
                                                ))}
                                            </CFormSelect>
                                            <small className="text-muted mt-1 d-block" style={{ fontSize: '0.72rem' }}>
                                                Requerido para 6to, 7mo y 8vo grado
                                            </small>
                                        </CCol>
                                    )}
                                    <CCol md={isSpecialtyRequired(gradeLevel) ? 2 : 3}>
                                        <CFormInput
                                            label={<span className="text-muted-custom small fw-bold text-uppercase ls-1">Letra (Opcional)</span>}
                                            placeholder="A"
                                            value={section}
                                            onChange={(e) => setSection(e.target.value)}
                                            className="bg-light-custom border-light-custom header-title-custom text-center fw-bold shadow-sm py-2"
                                        />
                                    </CCol>
                                </CRow>
                            </CCardBody>
                        </CCard>

                        {/* SECCIÓN 2: GESTOR DE HORARIOS */}
                        <CCard className="border-0 shadow-lg mb-4 overflow-hidden premium-card">
                            <div className="bg-orange-soft px-4 py-3 border-bottom border-warning border-opacity-10">
                                <h6 className="mb-0 text-primary fw-bold text-uppercase small ls-1 d-flex align-items-center">
                                    <CIcon icon={cilClock} className="me-2" />
                                    Gestor de Clases
                                    {loadingCatalogs && <CSpinner size="sm" className="ms-2" style={{ color: '#E07A00' }} />}
                                </h6>
                            </div>

                            <CCardBody className="p-4 bg-light-custom bg-opacity-10">
                                <div className="p-4 bg-light-custom bg-opacity-25 rounded-4 mb-4 border border-light-custom shadow-sm">
                                    <CRow className="g-3 align-items-end">
                                        {/* Asignatura */}
                                        <CCol md={2}>
                                            <CFormSelect
                                                label={<span className="text-muted-custom small fw-bold text-uppercase" style={{ fontSize: '10px' }}>Asignatura</span>}
                                                value={newSchedule.subject}
                                                onChange={handleSubjectChange}
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold py-2"
                                            >
                                                {SUBJECTS.map(subject => (
                                                    <option key={subject.id} value={subject.value}>{subject.label}</option>
                                                ))}
                                            </CFormSelect>
                                        </CCol>

                                        {/* Profesor (desde BD) */}
                                        <CCol md={3}>
                                            <CFormSelect
                                                label={<span className="text-muted-custom small fw-bold text-uppercase" style={{ fontSize: '10px' }}>Profesor</span>}
                                                value={newSchedule.teacherId}
                                                onChange={(e) => setNewSchedule({ ...newSchedule, teacherId: e.target.value })}
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold py-2"
                                                disabled={loadingCatalogs}
                                            >
                                                <option value="">Seleccionar profesor...</option>
                                                {teachers
                                                    .filter((teacher, index, self) => self.findIndex(t => t.id === teacher.id) === index)
                                                    .map(teacher => (
                                                        <option key={teacher.id} value={teacher.id}>
                                                            {teacher.first_name} {teacher.last_name}
                                                        </option>
                                                    ))
                                                }
                                            </CFormSelect>
                                        </CCol>

                                        {/* Día (desde BD) */}
                                        <CCol md={2}>
                                            <CFormSelect
                                                label={<span className="text-muted-custom small fw-bold text-uppercase" style={{ fontSize: '10px' }}>Día</span>}
                                                value={newSchedule.dayId}
                                                onChange={(e) => setNewSchedule({ ...newSchedule, dayId: e.target.value })}
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold py-2"
                                                disabled={loadingCatalogs}
                                            >
                                                <option value="">Seleccionar día...</option>
                                                {days.map(day => (
                                                    <option key={day.id} value={day.id}>
                                                        {day.name}
                                                    </option>
                                                ))}
                                            </CFormSelect>
                                        </CCol>

                                        {/* Bloque (desde BD) */}
                                        <CCol md={2}>
                                            <CFormSelect
                                                label={<span className="text-muted-custom small fw-bold text-uppercase" style={{ fontSize: '10px' }}>Bloque</span>}
                                                value={newSchedule.blockId}
                                                onChange={(e) => setNewSchedule({ ...newSchedule, blockId: e.target.value })}
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold py-2"
                                                disabled={loadingCatalogs}
                                            >
                                                <option value="">Seleccionar bloque...</option>
                                                {blocks.map(block => (
                                                    <option key={block.id} value={block.id}>
                                                        {block.name} ({block.start_time?.substring(0, 5)} - {block.end_time?.substring(0, 5)})
                                                    </option>
                                                ))}
                                            </CFormSelect>
                                        </CCol>

                                        {/* Aula (desde BD) */}
                                        <CCol md={2}>
                                            <CFormSelect
                                                label={<span className="text-muted-custom small fw-bold text-uppercase" style={{ fontSize: '10px' }}>Aula</span>}
                                                value={newSchedule.classroomId}
                                                onChange={(e) => setNewSchedule({ ...newSchedule, classroomId: e.target.value })}
                                                className="bg-light-custom border-light-custom header-title-custom fw-bold py-2"
                                                disabled={loadingCatalogs}
                                            >
                                                <option value="">Seleccionar aula...</option>
                                                {classrooms.map(room => (
                                                    <option key={room.id} value={room.id}>
                                                        {room.name}
                                                    </option>
                                                ))}
                                            </CFormSelect>
                                        </CCol>

                                        {/* Botón Agregar */}
                                        <CCol md={1}>
                                            <CButton
                                                onClick={handleAddSchedule}
                                                className="w-100 fw-bold py-2 btn-premium shadow-sm"
                                                disabled={loadingCatalogs || saving}
                                            >
                                                <CIcon icon={cilPlus} />
                                            </CButton>
                                        </CCol>
                                    </CRow>
                                </div>

                                {/* TABLA DE HORARIOS AGREGADOS */}
                                {schedules.length > 0 ? (
                                    <div className="table-responsive rounded-4 border border-light-custom overflow-hidden shadow-sm">
                                        <CTable hover align="middle" className="mb-0 bg-transparent">
                                            <CTableHead className="bg-light-custom bg-opacity-25 border-bottom border-light-custom border-opacity-10">
                                                <CTableRow>
                                                    <CTableHeaderCell className="text-muted-custom small text-uppercase fw-bold ps-4">Día</CTableHeaderCell>
                                                    <CTableHeaderCell className="text-muted-custom small text-uppercase fw-bold text-center">Horario</CTableHeaderCell>
                                                    <CTableHeaderCell className="text-muted-custom small text-uppercase fw-bold">Materia</CTableHeaderCell>
                                                    <CTableHeaderCell className="text-muted-custom small text-uppercase fw-bold">Profesor</CTableHeaderCell>
                                                    <CTableHeaderCell className="text-muted-custom small text-uppercase fw-bold">Aula</CTableHeaderCell>
                                                    <CTableHeaderCell className="text-end pe-4"></CTableHeaderCell>
                                                </CTableRow>
                                            </CTableHead>
                                            <CTableBody>
                                                {schedules.map(schedule => (
                                                    <CTableRow key={schedule.id} className="border-0">
                                                        <CTableDataCell className="fw-bold text-primary ps-4 border-0">{schedule.dayOfWeek}</CTableDataCell>
                                                        <CTableDataCell className="text-center font-monospace border-0">
                                                            <div className="bg-light-custom bg-opacity-25 rounded-3 px-2 py-1 header-title-custom d-inline-block small shadow-sm border border-light-custom border-opacity-10">
                                                                {schedule.startTime} - {schedule.endTime}
                                                            </div>
                                                        </CTableDataCell>
                                                        <CTableDataCell className="fw-bold header-title-custom border-0">{schedule.subject}</CTableDataCell>
                                                        <CTableDataCell className="small text-muted-custom fw-medium border-0">{schedule.teacherName}</CTableDataCell>
                                                        <CTableDataCell className="border-0">
                                                            <CBadge color="primary" className="fw-bold bg-opacity-10 text-primary border border-primary border-opacity-10 px-3 py-2 text-uppercase" style={{ fontSize: '0.65rem' }}>
                                                                {schedule.classroom}
                                                            </CBadge>
                                                        </CTableDataCell>
                                                        <CTableDataCell className="text-end pe-4 border-0">
                                                            <CButton
                                                                size="sm"
                                                                color="transparent"
                                                                className="text-danger hover-lift shadow-sm bg-light-custom bg-opacity-10 border-light-custom"
                                                                onClick={() => handleRemoveSchedule(schedule.id)}
                                                                disabled={saving}
                                                            >
                                                                <CIcon icon={cilTrash} />
                                                            </CButton>
                                                        </CTableDataCell>
                                                    </CTableRow>
                                                ))}
                                            </CTableBody>
                                        </CTable>
                                    </div>
                                ) : (
                                    <div className="text-center py-5 bg-light-custom bg-opacity-10 rounded-4 border border-dashed text-muted-custom shadow-sm border-light-custom">
                                        <CIcon icon={cilCalendar} size="3xl" className="mb-3 opacity-25" />
                                        <p className="mb-0 fw-medium">No hay horarios asignados aún.</p>
                                    </div>
                                )}
                            </CCardBody>
                        </CCard>

                        {/* RESUMEN */}
                        <div className="d-flex justify-content-end text-muted-custom fw-bold small ls-1 text-uppercase">
                            <span className="me-4 d-flex align-items-center">
                                <div className="bg-primary rounded-circle me-2" style={{ width: '8px', height: '8px' }}></div>
                                Total Clases: <strong className="ms-1 header-title-custom">{schedules.length}</strong>
                            </span>
                            <span className="d-flex align-items-center">
                                <div className="bg-success rounded-circle me-2" style={{ width: '8px', height: '8px' }}></div>
                                Carga Horaria: <strong className="ms-1 header-title-custom">{calculateTotalHours()} hrs/sem</strong>
                            </span>
                        </div>
                    </CModalBody>

                    <CModalFooter className="bg-light-custom bg-opacity-10 border-top border-light-custom border-opacity-10">
                        <CButton
                            onClick={onClose}
                            className="fw-bold px-4 py-2 border-0 bg-transparent text-muted-custom hover-lift"
                            disabled={saving}
                        >
                            CANCELAR
                        </CButton>
                        <CButton
                            type="submit"
                            className={`px-4 py-2 fw-bold shadow-lg transition-all ${saving ? 'opacity-50' : 'hover-lift'}`}
                            disabled={saving || schedules.length === 0}
                            style={{
                                background: schedules.length === 0 || saving
                                    ? '#4b5563'
                                    : 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                                border: 'none',
                                color: 'white',
                                borderRadius: '12px'
                            }}
                        >
                            {saving ? (
                                <>
                                    <CSpinner size="sm" className="me-2" />
                                    GUARDANDO...
                                </>
                            ) : (
                                <>
                                    <CIcon icon={cilPlus} className="me-2" />
                                    {initial ? 'GUARDAR CAMBIOS' : 'CREAR SECCIÓN'}
                                </>
                            )}
                        </CButton>
                    </CModalFooter>
                </CForm>
            </CModal>

            {/* Modal de Error */}
            <CModal
                visible={errorModal.visible}
                onClose={() => setErrorModal({ ...errorModal, visible: false })}
                alignment="center"
                className="premium-modal"
            >
                <div className="border-top border-4 border-danger rounded-top premium-card">
                    <CModalHeader className="border-0 pb-0 bg-transparent">
                        <CModalTitle className="text-danger fw-bold d-flex align-items-center ls-1 small">
                            <CIcon icon={cilWarning} className="me-2" />
                            ERROR
                        </CModalTitle>
                    </CModalHeader>
                    <CModalBody className="p-4 bg-transparent">
                        <div className="header-title-custom">
                            {typeof errorModal.message === 'string' ? errorModal.message : errorModal.message}
                        </div>
                    </CModalBody>
                    <CModalFooter className="border-0 pt-0 bg-transparent">
                        <CButton className="btn-premium px-4" onClick={() => setErrorModal({ ...errorModal, visible: false })}>
                            ENTENDIDO
                        </CButton>
                    </CModalFooter>
                </div>
            </CModal>

            <style>{`
                .bg-orange-soft { background-color: rgba(242, 140, 15, 0.12); }
                .ls-1 { letter-spacing: 1px; }
                .transition-all { transition: all 0.3s ease; }
                .grayscale { filter: grayscale(1); }
                .hover-lift:hover { 
                    transform: translateY(-2px);
                    box-shadow: 0 8px 16px rgba(0,0,0,0.2) !important;
                }
                .btn-premium {
                    background: #E07A00;
                    border: none;
                    color: white;
                }
                .btn-premium:hover {
                    background: #C66900;
                }
            `}</style>
        </>
    )
}

export default HorarioForm