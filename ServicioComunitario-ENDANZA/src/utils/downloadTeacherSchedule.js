// src/utils/downloadTeacherSchedule.js
import { listSections } from 'src/services/scheduleService'
import { getActiveYear } from 'src/services/configService'
import { descargarHorarioDocentePDF } from 'src/views/Docente/utils/teacherSchedulePdf'

const normalizeStr = (str) =>
  (str || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, ' ')
    .trim()

/**
 * Descarga directamente el horario en PDF de un docente (sin necesidad de entrar a su perfil).
 * Compatible con objetos de tipo 'User' (del módulo /users) o 'Teacher' (del dashboard / docentes).
 * 
 * @param {Object} teacherOrUser - Datos del usuario o docente
 * @param {Object} options - { academicYearName, sectionsList } opcionales
 * @returns {Promise<{ success: boolean, count: number, message: string }>}
 */
export const downloadTeacherSchedule = async (teacherOrUser, options = {}) => {
  if (!teacherOrUser) {
    return { success: false, count: 0, message: 'No se especificó el docente.' }
  }

  const firstName = teacherOrUser.first_name || teacherOrUser.nombre || ''
  const lastName = teacherOrUser.last_name || teacherOrUser.apellido || ''
  const fullName = `${firstName} ${lastName}`.trim() || teacherOrUser.name || 'Docente'

  const targetUserId = Number(
    teacherOrUser.userId || teacherOrUser.user_id || teacherOrUser.id_usuario ||
    (teacherOrUser.role === 'docente' ? teacherOrUser.id : null)
  )
  const targetTeacherId = Number(
    teacherOrUser.teacherId || teacherOrUser.teacher_id || teacherOrUser.id_docente ||
    teacherOrUser.profesor_id || teacherOrUser.Id_profesor ||
    (!teacherOrUser.role ? teacherOrUser.id : null)
  )
  const normalizedTargetName = normalizeStr(fullName)

  // 1. Resolver el año lectivo
  let yearName = options.academicYearName || options.academicYear
  if (!yearName) {
    try {
      const activeYearObj = await getActiveYear()
      if (activeYearObj?.name) {
        yearName = activeYearObj.name
      }
    } catch (e) {
      console.warn('No se pudo obtener el año lectivo activo:', e)
    }
  }
  if (!yearName) {
    yearName = '2026-2027'
  }

  // 2. Obtener secciones (usar las provistas en options si existen para máxima velocidad)
  let sections = options.sectionsList
  if (!sections || sections.length === 0) {
    try {
      sections = await listSections({ academicYear: yearName })
    } catch (e) {
      console.error('Error al obtener secciones para el horario:', e)
      return { success: false, count: 0, message: 'Error al consultar las secciones del sistema.' }
    }
  }

  // 3. Filtrar horarios correspondientes a este docente
  const matchedClasses = []

  ;(sections || []).forEach(section => {
    const secSchedules = section.schedules || []
    secSchedules.forEach(sched => {
      const schedTeacherName = sched.teacherName || sched.teacher_name || ''
      const schedAuxName = sched.auxiliaryTeacherName || sched.auxiliary_teacher_name || ''
      const schedUserId = Number(sched.teacherUserId || sched.teacher_user_id || sched.user_id)
      const schedTeacherId = Number(sched.teacherId || sched.teacher_id || sched.id_docente)
      const schedAuxUserId = Number(sched.auxiliaryTeacherUserId || sched.auxiliary_teacher_user_id)
      const schedAuxTeacherId = Number(sched.auxiliaryTeacherId || sched.auxiliary_teacher_id)

      const normSchedName = normalizeStr(schedTeacherName)
      const normSchedAux = normalizeStr(schedAuxName)

      // Coincidencia por ID de usuario o docente
      const isIdTitular = (targetUserId && schedUserId && targetUserId === schedUserId) ||
                          (targetTeacherId && schedTeacherId && targetTeacherId === schedTeacherId)

      const isIdAux = (targetUserId && schedAuxUserId && targetUserId === schedAuxUserId) ||
                      (targetTeacherId && schedAuxTeacherId && targetTeacherId === schedAuxTeacherId)

      // Coincidencia por Nombre completo
      const isNameTitular = normalizedTargetName && normSchedName && (
        normSchedName === normalizedTargetName ||
        normSchedName.includes(normalizedTargetName) ||
        normalizedTargetName.includes(normSchedName)
      )

      const isNameAux = normalizedTargetName && normSchedAux && (
        normSchedAux === normalizedTargetName ||
        normSchedAux.includes(normalizedTargetName) ||
        normalizedTargetName.includes(normSchedAux)
      )

      const isTitular = isIdTitular || isNameTitular
      const isAux = isIdAux || isNameAux

      if (isTitular || isAux) {
        matchedClasses.push({
          ...sched,
          sectionName: section.sectionName || section.section_name || 'Sección',
          subjectName: sched.subject || sched.subject_name || section.subjectName || 'Sin materia',
          subject: sched.subject || sched.subject_name || section.subjectName || 'Sin materia',
          gradeLevel: section.gradeLevel || section.grade_level,
          classroom: sched.classroomName || sched.classroom_name || sched.classroom || 'Sin aula',
          startTime: sched.startTime || sched.start_time,
          endTime: sched.endTime || sched.end_time,
          dayName: sched.dayName || sched.day_name,
          isAuxiliary: !isTitular && isAux,
          titularTeacherName: schedTeacherName,
          auxiliaryTeacherName: schedAuxName
        })
      }
    })
  })

  if (matchedClasses.length === 0) {
    return {
      success: false,
      count: 0,
      message: `El docente ${fullName} no tiene clases ni horarios asignados en el período ${yearName}.`
    }
  }

  // 4. Invocar la generación y descarga del PDF
  const ok = descargarHorarioDocentePDF({
    teacherName: fullName,
    academicYear: yearName,
    schedules: matchedClasses
  })

  return {
    success: !!ok,
    count: matchedClasses.length,
    message: ok
      ? `Horario de ${fullName} descargado exitosamente (${matchedClasses.length} clases).`
      : 'Ocurrió un error al generar el archivo PDF.'
  }
}
