import React, { useState, useEffect } from "react"
import {
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CButton,
  CTabs,
  CNav,
  CNavItem,
  CNavLink,
  CTabContent,
  CTabPane,
  CAlert,
  CSpinner,
  CBadge
} from "@coreui/react"
import CIcon from "@coreui/icons-react"
import {
  cilUser,
  cilSave,
  cilX,
  cilPhone,
  cilPeople,
  cilContact,
  cilBadge
} from "@coreui/icons"
import { capitalizeWords } from "../../../../utils/formatters"
import StudentForm from "./editForm"

const editModal = ({
  visible,
  onClose,
  studentData,
  onSave,
  loading = false
}) => {
  const [activeTab, setActiveTab] = useState(0)
  const [formData, setFormData] = useState({})
  const [errors, setErrors] = useState({})

  // Helper inteligente para desglosar nombres y apellidos en 4 partes (1er/2do nombre, 1er/2do apellido)
  const extractFourParts = (firstNameOrFull = '', lastName = '') => {
    // Si lastName tiene contenido y no está vacío
    if (lastName && String(lastName).trim()) {
      const fnTokens = String(firstNameOrFull || '').trim().split(/\s+/).filter(Boolean)
      const lnTokens = String(lastName || '').trim().split(/\s+/).filter(Boolean)
      return {
        first1: fnTokens[0] || '',
        first2: fnTokens.slice(1).join(' ') || '',
        last1: lnTokens[0] || '',
        last2: lnTokens.slice(1).join(' ') || ''
      }
    }

    // Si viene todo en una sola cadena combinada (ej: "DIANA CAROLINA GALLO CARDENAS")
    const tokens = String(firstNameOrFull || '').trim().split(/\s+/).filter(Boolean)
    if (tokens.length === 0) return { first1: '', first2: '', last1: '', last2: '' }
    if (tokens.length === 1) return { first1: tokens[0], first2: '', last1: '', last2: '' }
    if (tokens.length === 2) return { first1: tokens[0], first2: '', last1: tokens[1], last2: '' }
    if (tokens.length === 3) return { first1: tokens[0], first2: '', last1: tokens[1], last2: tokens[2] }
    
    // 4 o más palabras
    return {
      first1: tokens[0],
      first2: tokens[1],
      last1: tokens[2],
      last2: tokens.slice(3).join(' ')
    }
  }

  // Inicializar formData cuando se abre el modal
  useEffect(() => {
    if (visible && studentData) {
      // 1. Desglosar datos del Estudiante
      const estParts = extractFourParts(
        studentData.EstudiantePrimerNombre 
          ? `${studentData.EstudiantePrimerNombre} ${studentData.EstudianteSegundoNombre || ''}` 
          : (studentData.first_name || studentData.NombreEstudiante || studentData.nombre || ''),
        studentData.EstudiantePrimerApellido 
          ? `${studentData.EstudiantePrimerApellido} ${studentData.EstudianteSegundoApellido || ''}` 
          : (studentData.last_name || studentData.ApellidoEstudiante || studentData.apellido || '')
      )
      const nombreEst = `${estParts.first1} ${estParts.first2}`.trim()
      const apellidoEst = `${estParts.last1} ${estParts.last2}`.trim()

      // Fecha de nacimiento para datepicker (YYYY-MM-DD)
      let fechaNac = studentData.FechaNacimiento || studentData.birth_date || studentData.fecha_nacimiento || ''
      if (fechaNac && fechaNac.includes('/')) {
        const p = fechaNac.split('/')
        if (p.length === 3) fechaNac = `${p[2]}-${p[1].padStart(2, '0')}-${p[0].padStart(2, '0')}`
      } else if (fechaNac && fechaNac.includes('T')) {
        fechaNac = fechaNac.split('T')[0]
      }

      // Sexo / Género normalizado
      let sexoVal = studentData.Sexo || studentData.gender || studentData.genero || ''
      if (typeof sexoVal === 'string') {
        if (sexoVal.toLowerCase().startsWith('m')) sexoVal = 'Masculino'
        else if (sexoVal.toLowerCase().startsWith('f')) sexoVal = 'Femenino'
      }

      // Tipo de sangre
      const tipoSangre = studentData.TipoSangre || studentData.blood_type || studentData.tipo_sangre || ''

      // Estatus
      const estatusVal = studentData.Estatus || studentData.status || studentData.estatus || 'Activo'

      // Grado y Sección
      const gradoVal = studentData.Grado || studentData.grade_level_name || studentData.dance_level_name || studentData.gradeLevel || studentData.dance_level || ''
      const seccionVal = studentData.Seccion || (studentData.sections?.[0]?.section_name) || studentData.section || ''

      // Contacto / Ubicación
      const direccionVal = studentData.Direccion || studentData.address || studentData.direccion || ''
      const ciudadVal = studentData.Ciudad || studentData.city || studentData.ciudad || ''
      const estadoVal = studentData.Estado || studentData.state || studentData.estado || ''
      const telefonoVal = studentData.Telefono || studentData.phone || studentData.telefono || studentData.representative_phone || ''
      const emailVal = studentData.Email || studentData.email || studentData.correo || studentData.representative_email || ''

      // 2. Desglosar datos del Representante
      const repParts = extractFourParts(
        studentData.RepresentantePrimerNombre 
          ? `${studentData.RepresentantePrimerNombre} ${studentData.RepresentanteSegundoNombre || ''}` 
          : (studentData.representative_first_name || studentData.RepresentanteNombre || studentData.representative || ''),
        studentData.RepresentantePrimerApellido 
          ? `${studentData.RepresentantePrimerApellido} ${studentData.RepresentanteSegundoApellido || ''}` 
          : (studentData.representative_last_name || studentData.RepresentanteApellido || '')
      )
      const repCedula = studentData.RepresentanteCedula || studentData.representative_dni || studentData.representative_cedula || ''
      const repTelefono = studentData.RepresentanteTelefono || studentData.representative_phone || ''
      const repEmail = studentData.RepresentanteEmail || studentData.representative_email || ''
      const repOcupacion = studentData.RepresentanteOcupacion || studentData.representative_occupation || ''

      // 3. Determinar parentesco del representante (Madre, Padre u Otro)
      let repParentesco = studentData.RepresentanteParentesco || studentData.parentesco || ''
      const gender = String(studentData.representative_gender || studentData.genero_representante || '').toLowerCase()
      const fnLower = (repParts.first1 || '').toLowerCase()
      const femaleNames = ['diana', 'maria', 'carmen', 'ana', 'patricia', 'paola', 'laura', 'daniela', 'genesis', 'gabriela', 'yusmary', 'andreina', 'stephanie', 'marieth', 'elena', 'rosa', 'isabel', 'lucia', 'valeria', 'camila', 'alejandra', 'vanessa', 'mayerling', 'coromoto']
      const isFemale = gender.startsWith('f') || gender.includes('fem') || femaleNames.includes(fnLower) || (fnLower.endsWith('a') && !['joshua', 'luca', 'noah'].includes(fnLower))

      if (!repParentesco || repParentesco === 'Representante' || repParentesco === 'Otro' || repParentesco === 'OTRO_VALOR') {
        repParentesco = isFemale ? 'Madre' : 'Padre'
      }

      // 4. Desglosar datos existentes de Madre y Padre
      const madreParts = extractFourParts(
        studentData.MadrePrimerNombre 
          ? `${studentData.MadrePrimerNombre} ${studentData.MadreSegundoNombre || ''}` 
          : (studentData.MadreNombre || ''),
        studentData.MadrePrimerApellido 
          ? `${studentData.MadrePrimerApellido} ${studentData.MadreSegundoApellido || ''}` 
          : (studentData.MadreApellido || '')
      )

      const padreParts = extractFourParts(
        studentData.PadrePrimerNombre 
          ? `${studentData.PadrePrimerNombre} ${studentData.PadreSegundoNombre || ''}` 
          : (studentData.PadreNombre || ''),
        studentData.PadrePrimerApellido 
          ? `${studentData.PadrePrimerApellido} ${studentData.PadreSegundoApellido || ''}` 
          : (studentData.PadreApellido || '')
      )

      // Si el representante es Madre, asegurar que la pestaña Madre tenga todos los datos
      const finalMadrePrimerNombre = madreParts.first1 || (repParentesco === 'Madre' ? repParts.first1 : '')
      const finalMadreSegundoNombre = madreParts.first2 || (repParentesco === 'Madre' ? repParts.first2 : '')
      const finalMadrePrimerApellido = madreParts.last1 || (repParentesco === 'Madre' ? repParts.last1 : '')
      const finalMadreSegundoApellido = madreParts.last2 || (repParentesco === 'Madre' ? repParts.last2 : '')
      const finalMadreCedula = studentData.MadreCedula || (repParentesco === 'Madre' ? repCedula : '')
      const finalMadreTelefono = studentData.MadreTelefono || (repParentesco === 'Madre' ? repTelefono : '')
      const finalMadreEmail = studentData.MadreEmail || (repParentesco === 'Madre' ? repEmail : '')
      const finalMadreOcupacion = studentData.MadreOcupacion || (repParentesco === 'Madre' ? repOcupacion : '')

      // Si el representante es Padre, asegurar que la pestaña Padre tenga todos los datos
      const finalPadrePrimerNombre = padreParts.first1 || (repParentesco === 'Padre' ? repParts.first1 : '')
      const finalPadreSegundoNombre = padreParts.first2 || (repParentesco === 'Padre' ? repParts.first2 : '')
      const finalPadrePrimerApellido = padreParts.last1 || (repParentesco === 'Padre' ? repParts.last1 : '')
      const finalPadreSegundoApellido = padreParts.last2 || (repParentesco === 'Padre' ? repParts.last2 : '')
      const finalPadreCedula = studentData.PadreCedula || (repParentesco === 'Padre' ? repCedula : '')
      const finalPadreTelefono = studentData.PadreTelefono || (repParentesco === 'Padre' ? repTelefono : '')
      const finalPadreEmail = studentData.PadreEmail || (repParentesco === 'Padre' ? repEmail : '')
      const finalPadreOcupacion = studentData.PadreOcupacion || (repParentesco === 'Padre' ? repOcupacion : '')

      setFormData({
        ...studentData,
        EstudiantePrimerNombre: estParts.first1,
        EstudianteSegundoNombre: estParts.first2,
        EstudiantePrimerApellido: estParts.last1,
        EstudianteSegundoApellido: estParts.last2,
        NombreEstudiante: nombreEst,
        ApellidoEstudiante: apellidoEst,
        FechaNacimiento: fechaNac,
        Sexo: sexoVal,
        TipoSangre: tipoSangre,
        Estatus: estatusVal,
        Grado: gradoVal,
        Seccion: seccionVal,
        Direccion: direccionVal,
        Ciudad: ciudadVal,
        Estado: estadoVal,
        Telefono: telefonoVal,
        Email: emailVal,
        PadrePrimerNombre: finalPadrePrimerNombre,
        PadreSegundoNombre: finalPadreSegundoNombre,
        PadrePrimerApellido: finalPadrePrimerApellido,
        PadreSegundoApellido: finalPadreSegundoApellido,
        PadreNombre: `${finalPadrePrimerNombre} ${finalPadreSegundoNombre}`.trim(),
        PadreApellido: `${finalPadrePrimerApellido} ${finalPadreSegundoApellido}`.trim(),
        PadreCedula: finalPadreCedula,
        PadreTelefono: finalPadreTelefono,
        PadreEmail: finalPadreEmail,
        PadreOcupacion: finalPadreOcupacion,
        MadrePrimerNombre: finalMadrePrimerNombre,
        MadreSegundoNombre: finalMadreSegundoNombre,
        MadrePrimerApellido: finalMadrePrimerApellido,
        MadreSegundoApellido: finalMadreSegundoApellido,
        MadreNombre: `${finalMadrePrimerNombre} ${finalMadreSegundoNombre}`.trim(),
        MadreApellido: `${finalMadrePrimerApellido} ${finalMadreSegundoApellido}`.trim(),
        MadreCedula: finalMadreCedula,
        MadreTelefono: finalMadreTelefono,
        MadreEmail: finalMadreEmail,
        MadreOcupacion: finalMadreOcupacion,
        RepresentantePrimerNombre: repParts.first1,
        RepresentanteSegundoNombre: repParts.first2,
        RepresentantePrimerApellido: repParts.last1,
        RepresentanteSegundoApellido: repParts.last2,
        RepresentanteNombre: `${repParts.first1} ${repParts.first2}`.trim(),
        RepresentanteApellido: `${repParts.last1} ${repParts.last2}`.trim(),
        RepresentanteCedula: repCedula,
        RepresentanteTelefono: repTelefono,
        RepresentanteEmail: repEmail,
        RepresentanteOcupacion: repOcupacion,
        RepresentanteParentesco: repParentesco
      })
      setActiveTab(0)
      setErrors({})
    }
  }, [visible, studentData])

  // Manejar cambios en el formulario
  const handleInputChange = (e) => {
    const { name, value } = e.target

    // Soporte para actualizaciones múltiples (herencia de datos)
    if (name === 'multiple') {
      setFormData(prev => ({
        ...prev,
        ...value
      }))
      return
    }

    // Solo permitir números en cédulas (máximo 8 dígitos)
    let cleanValue = value
    if (['PadreCedula', 'MadreCedula', 'RepresentanteCedula'].includes(name)) {
      cleanValue = value.replace(/[^0-9]/g, '').slice(0, 8)
    }

    setFormData(prev => {
      const updated = {
        ...prev,
        [name]: cleanValue
      }

      // Sincronizar nombres completos de estudiante
      if (name === 'EstudiantePrimerNombre' || name === 'EstudianteSegundoNombre') {
        const s1 = name === 'EstudiantePrimerNombre' ? cleanValue : (prev.EstudiantePrimerNombre || '')
        const s2 = name === 'EstudianteSegundoNombre' ? cleanValue : (prev.EstudianteSegundoNombre || '')
        updated.NombreEstudiante = `${s1} ${s2}`.trim()
      }
      if (name === 'EstudiantePrimerApellido' || name === 'EstudianteSegundoApellido') {
        const a1 = name === 'EstudiantePrimerApellido' ? cleanValue : (prev.EstudiantePrimerApellido || '')
        const a2 = name === 'EstudianteSegundoApellido' ? cleanValue : (prev.EstudianteSegundoApellido || '')
        updated.ApellidoEstudiante = `${a1} ${a2}`.trim()
      }

      // Sincronizar nombres completos cuando se editan partes individuales
      if (name === 'PadrePrimerNombre' || name === 'PadreSegundoNombre') {
        const p1 = name === 'PadrePrimerNombre' ? cleanValue : (prev.PadrePrimerNombre || '')
        const p2 = name === 'PadreSegundoNombre' ? cleanValue : (prev.PadreSegundoNombre || '')
        updated.PadreNombre = `${p1} ${p2}`.trim()
      }
      if (name === 'PadrePrimerApellido' || name === 'PadreSegundoApellido') {
        const a1 = name === 'PadrePrimerApellido' ? cleanValue : (prev.PadrePrimerApellido || '')
        const a2 = name === 'PadreSegundoApellido' ? cleanValue : (prev.PadreSegundoApellido || '')
        updated.PadreApellido = `${a1} ${a2}`.trim()
      }
      if (name === 'MadrePrimerNombre' || name === 'MadreSegundoNombre') {
        const m1 = name === 'MadrePrimerNombre' ? cleanValue : (prev.MadrePrimerNombre || '')
        const m2 = name === 'MadreSegundoNombre' ? cleanValue : (prev.MadreSegundoNombre || '')
        updated.MadreNombre = `${m1} ${m2}`.trim()
      }
      if (name === 'MadrePrimerApellido' || name === 'MadreSegundoApellido') {
        const a1 = name === 'MadrePrimerApellido' ? cleanValue : (prev.MadrePrimerApellido || '')
        const a2 = name === 'MadreSegundoApellido' ? cleanValue : (prev.MadreSegundoApellido || '')
        updated.MadreApellido = `${a1} ${a2}`.trim()
      }
      if (name === 'RepresentantePrimerNombre' || name === 'RepresentanteSegundoNombre') {
        const r1 = name === 'RepresentantePrimerNombre' ? cleanValue : (prev.RepresentantePrimerNombre || '')
        const r2 = name === 'RepresentanteSegundoNombre' ? cleanValue : (prev.RepresentanteSegundoNombre || '')
        updated.RepresentanteNombre = `${r1} ${r2}`.trim()
      }
      if (name === 'RepresentantePrimerApellido' || name === 'RepresentanteSegundoApellido') {
        const a1 = name === 'RepresentantePrimerApellido' ? cleanValue : (prev.RepresentantePrimerApellido || '')
        const a2 = name === 'RepresentanteSegundoApellido' ? cleanValue : (prev.RepresentanteSegundoApellido || '')
        updated.RepresentanteApellido = `${a1} ${a2}`.trim()
      }

      // Sincronización automática si el representante es Madre o Padre
      const isRepMadre = updated.RepresentanteParentesco === 'Madre' || 
        (!['Padre', 'Tío', 'Abuelo', 'Hermano'].includes(updated.RepresentanteParentesco) && 
         ((updated.MadrePrimerNombre && updated.RepresentantePrimerNombre && updated.MadrePrimerNombre.toLowerCase() === updated.RepresentantePrimerNombre.toLowerCase()) ||
          (updated.MadrePrimerApellido && updated.RepresentantePrimerApellido && updated.MadrePrimerApellido.toLowerCase() === updated.RepresentantePrimerApellido.toLowerCase()) ||
          /diana|maria|carmen|ana|elena|rosa|daniela|patricia/i.test(updated.RepresentantePrimerNombre || '') ||
          updated.RepresentanteParentesco === 'Representante'));

      const isRepPadre = updated.RepresentanteParentesco === 'Padre' || 
        (!['Madre', 'Tía', 'Abuela', 'Hermana'].includes(updated.RepresentanteParentesco) && 
         ((updated.PadrePrimerNombre && updated.RepresentantePrimerNombre && updated.PadrePrimerNombre.toLowerCase() === updated.RepresentantePrimerNombre.toLowerCase()) ||
          (updated.PadrePrimerApellido && updated.RepresentantePrimerApellido && updated.PadrePrimerApellido.toLowerCase() === updated.RepresentantePrimerApellido.toLowerCase())));

      if (isRepMadre) {
        if (name === 'RepresentantePrimerNombre') updated.MadrePrimerNombre = cleanValue
        if (name === 'RepresentanteSegundoNombre') updated.MadreSegundoNombre = cleanValue
        if (name === 'RepresentantePrimerApellido') updated.MadrePrimerApellido = cleanValue
        if (name === 'RepresentanteSegundoApellido') updated.MadreSegundoApellido = cleanValue
        if (name === 'RepresentanteCedula') updated.MadreCedula = cleanValue
        if (name === 'RepresentanteTelefono') updated.MadreTelefono = cleanValue
        if (name === 'RepresentanteEmail') updated.MadreEmail = cleanValue
        if (name === 'RepresentanteOcupacion') updated.MadreOcupacion = cleanValue

        if (name === 'MadrePrimerNombre') updated.RepresentantePrimerNombre = cleanValue
        if (name === 'MadreSegundoNombre') updated.RepresentanteSegundoNombre = cleanValue
        if (name === 'MadrePrimerApellido') updated.RepresentantePrimerApellido = cleanValue
        if (name === 'MadreSegundoApellido') updated.RepresentanteSegundoApellido = cleanValue
        if (name === 'MadreCedula') updated.RepresentanteCedula = cleanValue
        if (name === 'MadreTelefono') updated.RepresentanteTelefono = cleanValue
        if (name === 'MadreEmail') updated.RepresentanteEmail = cleanValue
        if (name === 'MadreOcupacion') updated.RepresentanteOcupacion = cleanValue

        updated.MadreNombre = `${updated.MadrePrimerNombre || ''} ${updated.MadreSegundoNombre || ''}`.trim()
        updated.MadreApellido = `${updated.MadrePrimerApellido || ''} ${updated.MadreSegundoApellido || ''}`.trim()
        updated.RepresentanteNombre = updated.MadreNombre
        updated.RepresentanteApellido = updated.MadreApellido
      } else if (isRepPadre) {
        // Sincronización automática si el representante es Padre
        if (name === 'RepresentantePrimerNombre') updated.PadrePrimerNombre = cleanValue
        if (name === 'RepresentanteSegundoNombre') updated.PadreSegundoNombre = cleanValue
        if (name === 'RepresentantePrimerApellido') updated.PadrePrimerApellido = cleanValue
        if (name === 'RepresentanteSegundoApellido') updated.PadreSegundoApellido = cleanValue
        if (name === 'RepresentanteCedula') updated.PadreCedula = cleanValue
        if (name === 'RepresentanteTelefono') updated.PadreTelefono = cleanValue
        if (name === 'RepresentanteEmail') updated.PadreEmail = cleanValue
        if (name === 'RepresentanteOcupacion') updated.PadreOcupacion = cleanValue

        if (name === 'PadrePrimerNombre') updated.RepresentantePrimerNombre = cleanValue
        if (name === 'PadreSegundoNombre') updated.RepresentanteSegundoNombre = cleanValue
        if (name === 'PadrePrimerApellido') updated.RepresentantePrimerApellido = cleanValue
        if (name === 'PadreSegundoApellido') updated.RepresentanteSegundoApellido = cleanValue
        if (name === 'PadreCedula') updated.RepresentanteCedula = cleanValue
        if (name === 'PadreTelefono') updated.RepresentanteTelefono = cleanValue
        if (name === 'PadreEmail') updated.RepresentanteEmail = cleanValue
        if (name === 'PadreOcupacion') updated.RepresentanteOcupacion = cleanValue

        updated.PadreNombre = `${updated.PadrePrimerNombre || ''} ${updated.PadreSegundoNombre || ''}`.trim()
        updated.PadreApellido = `${updated.PadrePrimerApellido || ''} ${updated.PadreSegundoApellido || ''}`.trim()
        updated.RepresentanteNombre = updated.PadreNombre
        updated.RepresentanteApellido = updated.PadreApellido
      }

      return updated
    })

    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: null }))
    }
  }

  // Validar formulario
  const validateForm = () => {
    const newErrors = {}

    const nombreCompleto = (formData.NombreEstudiante || `${formData.EstudiantePrimerNombre || ''} ${formData.EstudianteSegundoNombre || ''}`).trim()
    const apellidoCompleto = (formData.ApellidoEstudiante || `${formData.EstudiantePrimerApellido || ''} ${formData.EstudianteSegundoApellido || ''}`).trim()

    if (!nombreCompleto) {
      newErrors.NombreEstudiante = "El nombre es requerido"
      newErrors.EstudiantePrimerNombre = "El 1er nombre es requerido"
    }

    if (!apellidoCompleto) {
      newErrors.ApellidoEstudiante = "El apellido es requerido"
      newErrors.EstudiantePrimerApellido = "El 1er apellido es requerido"
    }

    if (!formData.FechaNacimiento) {
      newErrors.FechaNacimiento = "La fecha de nacimiento es requerida"
    }

    if (!formData.Estatus) {
      newErrors.Estatus = "El estatus es requerido"
    }

    // Validar cédulas (7-8 dígitos)
    const cedulaFields = [
      { key: 'PadreCedula', label: 'La cédula del padre' },
      { key: 'MadreCedula', label: 'La cédula de la madre' },
      { key: 'RepresentanteCedula', label: 'La cédula del representante' }
    ]
    cedulaFields.forEach(({ key, label }) => {
      if (formData[key]) {
        const digits = String(formData[key]).replace(/[^0-9]/g, '')
        if (digits && (digits.length < 7 || digits.length > 8)) {
          newErrors[key] = `${label} debe tener entre 7 y 8 dígitos`
        }
      }
    })

    // Validar teléfonos (7 dígitos después del código)
    const phoneFields = [
      { key: 'Telefono', label: 'El teléfono principal' },
      { key: 'PadreTelefono', label: 'El teléfono del padre' },
      { key: 'MadreTelefono', label: 'El teléfono de la madre' },
      { key: 'RepresentanteTelefono', label: 'El teléfono del representante' }
    ]
    phoneFields.forEach(({ key, label }) => {
      if (formData[key]) {
        const parts = String(formData[key]).split('-')
        const numPart = parts.length > 1 ? parts[1] : parts[0].replace(/^04\d{2}/, '')
        const cleanNum = numPart.replace(/[^0-9]/g, '')
        if (cleanNum && cleanNum.length !== 7) {
          newErrors[key] = `${label} debe tener 7 dígitos tras el código`
        }
      }
    })

    setErrors(newErrors)
    return { isValid: Object.keys(newErrors).length === 0, newErrors }
  }

  // Manejar guardar con bloqueo
  const handleSave = () => {
    if (loading) return // Evitar múltiples clics

    const { isValid, newErrors } = validateForm()
    if (isValid) {
      if (onSave) {
        const nombreCompleto = `${formData.EstudiantePrimerNombre || ''} ${formData.EstudianteSegundoNombre || ''}`.trim() || (formData.NombreEstudiante || '').trim()
        const apellidoCompleto = `${formData.EstudiantePrimerApellido || ''} ${formData.EstudianteSegundoApellido || ''}`.trim() || (formData.ApellidoEstudiante || '').trim()

        const isMadre = formData.RepresentanteParentesco === 'Madre' ||
          (!['Padre', 'Tío', 'Abuelo', 'Hermano'].includes(formData.RepresentanteParentesco) &&
           ((formData.MadrePrimerNombre && formData.RepresentantePrimerNombre && formData.MadrePrimerNombre.toLowerCase() === formData.RepresentantePrimerNombre.toLowerCase()) ||
            /diana|maria|carmen|ana|elena|rosa|daniela|patricia/i.test(formData.RepresentantePrimerNombre || '') ||
            formData.RepresentanteParentesco === 'Representante'));

        const isPadre = formData.RepresentanteParentesco === 'Padre' ||
          (!['Madre', 'Tía', 'Abuela', 'Hermano'].includes(formData.RepresentanteParentesco) &&
           (formData.PadrePrimerNombre && formData.RepresentantePrimerNombre && formData.PadrePrimerNombre.toLowerCase() === formData.RepresentantePrimerNombre.toLowerCase()));

        const cedulaFinal = (formData.RepresentanteCedula && String(formData.RepresentanteCedula).trim()) ||
          (isMadre && formData.MadreCedula && String(formData.MadreCedula).trim()) ||
          (isPadre && formData.PadreCedula && String(formData.PadreCedula).trim()) ||
          (formData.MadreCedula && String(formData.MadreCedula).trim()) ||
          (formData.PadreCedula && String(formData.PadreCedula).trim()) || '';

        const telefonoFinal = formData.RepresentanteTelefono || (isMadre ? formData.MadreTelefono : (isPadre ? formData.PadreTelefono : null)) || formData.MadreTelefono || formData.PadreTelefono || '';
        const emailFinal = formData.RepresentanteEmail || (isMadre ? formData.MadreEmail : (isPadre ? formData.PadreEmail : null)) || formData.MadreEmail || formData.PadreEmail || '';
        const ocupacionFinal = formData.RepresentanteOcupacion || (isMadre ? formData.MadreOcupacion : (isPadre ? formData.PadreOcupacion : null)) || formData.MadreOcupacion || formData.PadreOcupacion || '';

        const padreNombreCompleto = `${formData.PadrePrimerNombre || ''} ${formData.PadreSegundoNombre || ''}`.trim() || (formData.PadreNombre || '').trim()
        const padreApellidoCompleto = `${formData.PadrePrimerApellido || ''} ${formData.PadreSegundoApellido || ''}`.trim() || (formData.PadreApellido || '').trim()

        const madreNombreCompleto = `${formData.MadrePrimerNombre || ''} ${formData.MadreSegundoNombre || ''}`.trim() || (formData.MadreNombre || '').trim()
        const madreApellidoCompleto = `${formData.MadrePrimerApellido || ''} ${formData.MadreSegundoApellido || ''}`.trim() || (formData.MadreApellido || '').trim()

        const repNombreCompleto = `${formData.RepresentantePrimerNombre || ''} ${formData.RepresentanteSegundoNombre || ''}`.trim() || (formData.RepresentanteNombre || '').trim()
        const repApellidoCompleto = `${formData.RepresentantePrimerApellido || ''} ${formData.RepresentanteSegundoApellido || ''}`.trim() || (formData.RepresentanteApellido || '').trim()

        const formattedData = {
          ...formData,
          nombre: capitalizeWords(nombreCompleto),
          apellido: capitalizeWords(apellidoCompleto),
          first_name: capitalizeWords(nombreCompleto),
          last_name: capitalizeWords(apellidoCompleto),
          NombreEstudiante: capitalizeWords(nombreCompleto),
          ApellidoEstudiante: capitalizeWords(apellidoCompleto),
          EstudiantePrimerNombre: capitalizeWords(formData.EstudiantePrimerNombre),
          EstudianteSegundoNombre: capitalizeWords(formData.EstudianteSegundoNombre),
          EstudiantePrimerApellido: capitalizeWords(formData.EstudiantePrimerApellido),
          EstudianteSegundoApellido: capitalizeWords(formData.EstudianteSegundoApellido),
          fecha_nacimiento: formData.FechaNacimiento,
          birth_date: formData.FechaNacimiento,
          genero: formData.Sexo,
          gender: formData.Sexo,
          tipo_sangre: formData.TipoSangre,
          blood_type: formData.TipoSangre,
          TipoSangre: formData.TipoSangre,
          status: formData.Estatus,
          estatus: formData.Estatus,
          cedula: formData.Cedula || formData.dni,
          dni: formData.Cedula || formData.dni,
          PadrePrimerNombre: capitalizeWords(formData.PadrePrimerNombre),
          PadreSegundoNombre: capitalizeWords(formData.PadreSegundoNombre),
          PadrePrimerApellido: capitalizeWords(formData.PadrePrimerApellido),
          PadreSegundoApellido: capitalizeWords(formData.PadreSegundoApellido),
          PadreNombre: capitalizeWords(padreNombreCompleto),
          PadreApellido: capitalizeWords(padreApellidoCompleto),
          MadrePrimerNombre: capitalizeWords(formData.MadrePrimerNombre),
          MadreSegundoNombre: capitalizeWords(formData.MadreSegundoNombre),
          MadrePrimerApellido: capitalizeWords(formData.MadrePrimerApellido),
          MadreSegundoApellido: capitalizeWords(formData.MadreSegundoApellido),
          MadreNombre: capitalizeWords(madreNombreCompleto),
          MadreApellido: capitalizeWords(madreApellidoCompleto),
          RepresentantePrimerNombre: capitalizeWords(formData.RepresentantePrimerNombre),
          RepresentanteSegundoNombre: capitalizeWords(formData.RepresentanteSegundoNombre),
          RepresentantePrimerApellido: capitalizeWords(formData.RepresentantePrimerApellido),
          RepresentanteSegundoApellido: capitalizeWords(formData.RepresentanteSegundoApellido),
          RepresentanteNombre: capitalizeWords(repNombreCompleto),
          RepresentanteApellido: capitalizeWords(repApellidoCompleto),
          representative_first_name: capitalizeWords(formData.RepresentantePrimerNombre),
          representative_last_name: capitalizeWords(formData.RepresentantePrimerApellido),
          representative: capitalizeWords(`${repNombreCompleto} ${repApellidoCompleto}`.trim()),
          RepresentanteCedula: cedulaFinal,
          MadreCedula: isMadre ? cedulaFinal : formData.MadreCedula,
          PadreCedula: isPadre ? cedulaFinal : formData.PadreCedula,
          representative_dni: cedulaFinal,
          RepresentanteTelefono: telefonoFinal,
          representative_phone: telefonoFinal,
          MadreTelefono: isMadre ? telefonoFinal : formData.MadreTelefono,
          PadreTelefono: isPadre ? telefonoFinal : formData.PadreTelefono,
          RepresentanteEmail: emailFinal,
          representative_email: emailFinal,
          MadreEmail: isMadre ? emailFinal : formData.MadreEmail,
          PadreEmail: isPadre ? emailFinal : formData.PadreEmail,
          RepresentanteOcupacion: ocupacionFinal,
          representative_occupation: ocupacionFinal,
          MadreOcupacion: isMadre ? ocupacionFinal : formData.MadreOcupacion,
          PadreOcupacion: isPadre ? ocupacionFinal : formData.PadreOcupacion,
          RepresentanteParentesco: isMadre ? 'Madre' : (isPadre ? 'Padre' : (formData.RepresentanteParentesco || 'Madre')),
          parentesco: isMadre ? 'Madre' : (isPadre ? 'Padre' : (formData.RepresentanteParentesco || 'Madre')),
        };
        onSave(formattedData);
      }
    } else {
      // Si hay errores, saltar a la primera pestaña con error
      const tabErrorMap = [
        { tab: 0, fields: ['NombreEstudiante', 'ApellidoEstudiante', 'EstudiantePrimerNombre', 'EstudiantePrimerApellido', 'FechaNacimiento', 'Estatus'] },
        { tab: 1, fields: ['Telefono'] },
        { tab: 2, fields: ['PadreCedula', 'PadreTelefono'] },
        { tab: 3, fields: ['MadreCedula', 'MadreTelefono'] },
        { tab: 4, fields: ['RepresentanteCedula', 'RepresentanteTelefono'] }
      ]
      for (const item of tabErrorMap) {
        if (item.fields.some(f => newErrors[f])) {
          setActiveTab(item.tab)
          break
        }
      }
    }
  }

  // Tabs mejorados
  const tabs = [
    { key: 0, title: "Personal", icon: cilUser },
    { key: 1, title: "Contacto", icon: cilPhone },
    { key: 2, title: "Padre", icon: cilPeople },
    { key: 3, title: "Madre", icon: cilContact },
    { key: 4, title: "Representante", icon: cilBadge },
  ]

  return (
    <CModal
      visible={visible}
      onClose={onClose}
      size="xl"
      backdrop="static"
      className="premium-modal"
    >
      <CModalHeader className="modal-header-bg border-0 py-3">
        <CModalTitle className="fw-bold modal-header-title d-flex align-items-center">
          <div className="p-2 modal-header-icon-bg rounded-circle me-3 shadow-sm">
            <CIcon icon={cilUser} className="text-white" size="sm" />
          </div>
          Edición de Expediente Estudiantil
        </CModalTitle>
      </CModalHeader>

      <CModalBody className="p-4">
        {loading && activeTab === -1 ? ( // Solo si estamos recargando todo el modal
          <div className="text-center py-5">
            <CSpinner color="primary" variant="grow" />
            <p className="mt-3 fw-bold text-primary">Actualizando registros...</p>
          </div>
        ) : (
          <>
            {/* Mostrar errores generales */}
            {Object.keys(errors).length > 0 && (
              <CAlert color="danger" className="mb-4 border-0 shadow-sm rounded-4 animate__animated animate__shakeX">
                <div className="d-flex align-items-center">
                  <CIcon icon={cilX} className="me-3" size="lg" />
                  <strong>Verifica los datos obligatorios en la pestaña Personal.</strong>
                </div>
              </CAlert>
            )}

            <div className="mb-4 p-4 rounded-4 modal-info-box modal-border d-flex justify-content-between align-items-center">
              <div>
                <small className="modal-info-label text-uppercase ls-1 fw-bold" style={{ fontSize: '0.65rem' }}>Editando Perfil de:</small>
                <h4 className="mb-0 fw-bold modal-header-title">
                  {studentData?.NombreEstudiante || studentData?.first_name || studentData?.nombre || formData?.NombreEstudiante} {studentData?.ApellidoEstudiante || studentData?.last_name || studentData?.apellido || formData?.ApellidoEstudiante}
                </h4>
              </div>
              <div className="text-end">
                <CBadge className="modal-badge text-primary border border-primary border-opacity-10 px-3 py-2 rounded-pill shadow-sm fw-bold">
                  MATRÍCULA #{studentData?.id}
                </CBadge>
              </div>
            </div>

            {/* Navegación por Tabs Personalizada */}
            <CTabs activeTabKey={activeTab} onActiveTabKeyChange={setActiveTab}>
              <CNav variant="tabs" className="border-0 gap-2 mb-4">
                {tabs.map((tab) => (
                  <CNavItem key={tab.key}>
                    <CNavLink
                      onClick={() => setActiveTab(tab.key)}
                      active={activeTab === tab.key}
                      className={`rounded-pill border-0 px-4 py-2 fw-bold transition-all cursor-pointer ${activeTab === tab.key
                        ? 'bg-primary text-white shadow-sm'
                        : 'modal-nav-inactive-bg modal-nav-inactive-text hover-orange'
                        }`}
                    >
                      <CIcon icon={tab.icon} className="me-2" />
                      {tab.title}
                    </CNavLink>
                  </CNavItem>
                ))}
              </CNav>

              <CTabContent className="px-1">
                <CTabPane visible={true} className="animate__animated animate__fadeIn">
                  <StudentForm
                    formData={formData}
                    onInputChange={handleInputChange}
                    activeTab={activeTab}
                    errors={errors}
                  />
                </CTabPane>
              </CTabContent>
            </CTabs>
          </>
        )}
      </CModalBody>

      <CModalFooter className="border-0 p-4 pt-0">
        <CButton
          onClick={onClose}
          className="rounded-pill px-4 py-2 border-2 fw-bold modal-cancel-btn hover-orange shadow-sm me-2"
          disabled={loading}
        >
          <CIcon icon={cilX} className="me-2" />
          CANCELAR
        </CButton>
        <CButton
          className="btn-premium rounded-pill px-5 py-2 shadow-sm d-flex align-items-center"
          onClick={handleSave}
          disabled={loading}
        >
          {loading ? (
            <>
              <CSpinner size="sm" className="me-2" />
              GUARDANDO...
            </>
          ) : (
            <>
              <CIcon icon={cilSave} className="me-2" />
              GUARDAR CAMBIOS
            </>
          )}
        </CButton>
      </CModalFooter>
      <style>{`
        .ls-1 { letter-spacing: 1px; }
        .hover-orange:hover {
            background: var(--primary-50) !important;
            color: var(--primary-600) !important;
            border-color: var(--primary-200) !important;
        }
        .cursor-pointer { cursor: pointer; }
        .transition-all { transition: all 0.2s ease; }
        
        .modal-header-title { color: var(--neutral-800); }
        .modal-info-box { background-color: var(--neutral-100); }
        .modal-info-label { color: var(--neutral-500); }
        .modal-border { border: 1px solid var(--neutral-200) !important; }
        .modal-nav-inactive-bg { background-color: var(--neutral-100); }
        .modal-nav-inactive-text { color: var(--neutral-500); }
        .modal-cancel-btn { color: var(--neutral-600); border-color: var(--neutral-200); background-color: transparent; }
        
        .modal-header-bg { background-color: var(--primary-50); }
        .modal-header-icon-bg { background-color: var(--primary-500); }
        .modal-badge { background-color: var(--primary-50); }

        /* Estilos Globales para el Modal Premium en Dark Mode */
        [data-coreui-theme="dark"] .premium-modal .modal-content { 
            background-color: #1e293b !important; 
            border: 1px solid rgba(255,255,255,0.05);
        }
        [data-coreui-theme="dark"] .premium-modal .modal-body { background-color: #1e293b !important; }
        [data-coreui-theme="dark"] .premium-modal .modal-header { border-bottom: 1px solid rgba(255,255,255,0.05) !important; }
        [data-coreui-theme="dark"] .premium-modal .modal-footer { border-top: 1px solid rgba(255,255,255,0.05) !important; }

        [data-coreui-theme="dark"] .modal-header-bg { background-color: rgba(0,0,0,0.2) !important; }
        [data-coreui-theme="dark"] .modal-header-icon-bg { background-color: var(--primary-600) !important; }
        [data-coreui-theme="dark"] .modal-badge { background-color: rgba(255,255,255,0.05) !important; }
        [data-coreui-theme="dark"] .modal-header-title { color: white; }
        [data-coreui-theme="dark"] .modal-info-box { background-color: rgba(255,255,255,0.02); }
        [data-coreui-theme="dark"] .modal-info-label { color: rgba(255,255,255,0.4); }
        [data-coreui-theme="dark"] .modal-border { border: 1px solid rgba(255,255,255,0.05) !important; }
        [data-coreui-theme="dark"] .modal-nav-inactive-bg { background-color: rgba(255,255,255,0.05); }
        [data-coreui-theme="dark"] .modal-nav-inactive-text { color: rgba(255,255,255,0.4); }
        [data-coreui-theme="dark"] .modal-cancel-btn { color: rgba(255,255,255,0.6); border-color: rgba(255,255,255,0.1); }
        
        /* Forzar visibilidad de etiquetas de formulario en modo oscuro */
        [data-coreui-theme="dark"] .premium-modal label { color: rgba(255,255,255,0.7) !important; }
        [data-coreui-theme="dark"] .premium-modal .form-section-border { color: var(--primary-400) !important; }
      `}</style>
    </CModal>
  )
}

export default editModal