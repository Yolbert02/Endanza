import React, { useState, useEffect } from "react";
import {
  CCard, CCardBody, CCardHeader, CCardFooter,
  CContainer, CButton, CRow, CCol,
  CAlert, CBadge, CProgress, CProgressBar,
  CNav, CNavItem, CNavLink, CTabContent, CTabPane, CSpinner
} from "@coreui/react";
import CIcon from "@coreui/icons-react";
import {
  cilArrowLeft, cilCheckCircle, cilWarning,
  cilUser, cilBriefcase, cilMedicalCross,
  cilFile, cilArrowRight
} from "@coreui/icons";

import DatosEstudiante from "./steps/datosEstudiante";
import DatosRepresentante from "./steps/datosRepresentante";
import DatosSalud from "./steps/datosSalud";
import ConfirmacionInscripcion from "./steps/confirmacionInscripcion";
import { generarCodigoInscripcion, validarFormularioCompleto } from "./utils/validators";
import { generarPlanillaHTML } from "./utils/pdfGenerator";
import { inscribirEstudiante, obtenerDatosPrecargaEstudiante } from "../../../../services/inscripcionService";
import { capitalizeWords } from "../../../../utils/formatters";
import "./styles/inscripcion.css";

// Funciones auxiliares para separar nombres y teléfonos
const splitTwoParts = (str) => {
  if (!str) return { first: "", second: "" };
  const parts = str.trim().split(/\s+/);
  return {
    first: parts[0] || "",
    second: parts.slice(1).join(" ") || ""
  };
};

const splitPhoneParts = (phone) => {
  if (!phone) return { prefix: "0414", number: "" };
  const digits = String(phone).replace(/[^\d]/g, "");
  if (digits.length >= 4) {
    return {
      prefix: digits.slice(0, 4),
      number: digits.slice(4)
    };
  }
  return { prefix: "0414", number: digits };
};

const InscripcionCompletaForm = ({ onVolver, student, studentsList, activeYear }) => {
  const [step, setStep] = useState(1);
  const [inscripcionEnviada, setInscripcionEnviada] = useState(false);
  const [codigoInscripcion, setCodigoInscripcion] = useState("");
  const [errores, setErrores] = useState({});
  const [enviando, setEnviando] = useState(false);
  const [cargandoPrecarga, setCargandoPrecarga] = useState(false);
  const [yaInscrito, setYaInscrito] = useState(false);
  const [mensajeYaInscrito, setMensajeYaInscrito] = useState("");

  // Estado inicial LIMPIO
  const [formData, setFormData] = useState({
    // Datos del estudiante
    id_estudiante: student?.id || null,
    nombres: student?.first_name || student?.name || "",
    apellidos: student?.last_name || student?.lastName || "",
    fecha_nac: student?.birth_date || "",
    direccion_Habitacion: "",
    grado: student?.grade_level || student?.gradeLevel || "",
    especialidad: "",
    convivencia: "",
    escuela: "",
    Grado_Escuela: "",
    Seguro_Escolar: "",
    nombre_Seguro: "",

    // Datos de la Madre (campos divididos + combinado para backend)
    primer_nombre_Madre: "",
    segundo_nombre_Madre: "",
    primer_apellido_Madre: "",
    segundo_apellido_Madre: "",
    nombre_Madre: "",
    apellido_Madre: "",
    cedula_Madre: "",
    ocupacion_Madre: "",
    trabajo_Madre: "",
    direccion_Trabajo_Madre: "",
    telefono_Madre_prefix: "0414",
    telefono_Madre_number: "",
    telefono_Madre: "",

    // Datos del Padre (campos divididos + combinado para backend)
    primer_nombre_Padre: "",
    segundo_nombre_Padre: "",
    primer_apellido_Padre: "",
    segundo_apellido_Padre: "",
    nombre_Padre: "",
    apellido_Padre: "",
    cedula_Padre: "",
    ocupacion_Padre: "",
    trabajo_Padre: "",
    direccion_Trabajo_Padre: "",
    telefono_Padre_prefix: "0414",
    telefono_Padre_number: "",
    telefono_Padre: "",

    // Elección del representante
    quien_es_representante: "Madre",
    parentesco_Otro: "",

    // Datos del representante (campos divididos + combinado para backend)
    primer_nombre_Rep: "",
    segundo_nombre_Rep: "",
    primer_apellido_Rep: "",
    segundo_apellido_Rep: "",
    nombres_Representante: "",
    apellidos_Representante: "",
    telefono_Rep_prefix: "0414",
    telefono_Rep_number: "",
    telefono_Rep: "",
    telefonofijo_Rep: "",
    profesion_Rep: "",
    trabajo_Rep: "",
    direccion_Trabajo_Rep: "",

    // Datos de salud
    peso: "",
    talla: "",
    edad: "",
    intolerancia: "",
    textIntolerancia: "",
    sintomasFrecuentes: "",
    operaciones: "",
    textOperaciones: "",
    medicacion: "",
    textMedicacion: "",
    control_Hormonal: "",
    textcontrolHormonal: "",
    alergias: "",
    textAlergia: "",
    nacimiento: "",
    antecedentesFamiliares: "",

    // Metadatos
    id_ano_academico: activeYear?.id || null
  });

  // Limpiar errores cuando cambias de paso
  useEffect(() => {
    setErrores({});
  }, [step]);

  // Precargar datos del estudiante y su representante desde la base de datos
  useEffect(() => {
    const precargarDatos = async () => {
      if (!student?.id) return;
      setCargandoPrecarga(true);
      try {
        const res = await obtenerDatosPrecargaEstudiante(student.id, activeYear?.id);
        const data = res?.data || res;
        if (!data) return;

        const est = data.estudiante || {};
        const rep = data.representante || {};
        const madre = data.madre || null;
        const padre = data.padre || null;
        const hm = data.historial_medico || {};
        const inscActual = data.inscripcion_actual || {};

        if (inscActual.ya_inscrito) {
          setYaInscrito(true);
          setMensajeYaInscrito(
            `El estudiante ${est.nombres || student.first_name || ''} ${est.apellidos || student.last_name || ''} ya se encuentra inscrito en este período escolar (${activeYear?.name || ''})${inscActual.seccion ? ` en la Sección "${inscActual.seccion}"` : ''}.`
          );
        } else {
          setYaInscrito(false);
          setMensajeYaInscrito("");
        }

        // Formatear fecha de nacimiento
        let formattedDate = "";
        const rawDate = est.fecha_nacimiento || student.birth_date || student.birthDate;
        if (rawDate) {
          formattedDate = String(rawDate).split('T')[0];
        }

        // Grado del estudiante mapeado
        let mappedGrade = "";
        const rawGrade = est.grado_escuela || est.dance_level_name || est.grade_level_name || student.grade_level || student.gradeLevel || "";
        if (rawGrade) {
          mappedGrade = rawGrade.toLowerCase().replace(" ", "_");
        }

        // Separar partes de nombres y teléfonos
        const repNombres = splitTwoParts(rep.nombres);
        const repApellidos = splitTwoParts(rep.apellidos);
        const repTel = splitPhoneParts(rep.telefono);

        // Determinar parentesco del representante (nueva lógica con campo directo del backend)
        const repParentesco = data.quien_es_representante || rep.parentesco || "Madre";

        // Madre: usar datos de tabla Padre si existen, sino datos del rep si es Madre
        const infoMadre = madre || (repParentesco === 'Madre' ? rep : null);
        const madreNombres = splitTwoParts(infoMadre?.nombre || infoMadre?.nombres);
        const madreApellidos = splitTwoParts(infoMadre?.apellido || infoMadre?.apellidos);
        const madreTel = splitPhoneParts(infoMadre?.telefono);

        // Padre: usar datos de tabla Padre si existen, sino datos del rep si es Padre
        const infoPadre = padre || (repParentesco === 'Padre' ? rep : null);
        const padreNombres = splitTwoParts(infoPadre?.nombre || infoPadre?.nombres);
        const padreApellidos = splitTwoParts(infoPadre?.apellido || infoPadre?.apellidos);
        const padreTel = splitPhoneParts(infoPadre?.telefono);

        // Parentesco del representante (usar campo directo del backend si disponible)
        let quienRep = data.quien_es_representante || "Madre";
        let parentescoOtro = "";
        if (quienRep === "Padre") {
          // quienRep ya es "Padre"
        } else if (quienRep !== "Madre" && quienRep !== "Padre") {
          parentescoOtro = quienRep;
          quienRep = "Otro";
        }
        // Fallback: si no vino del backend, usar parentesco del representante
        if (!data.quien_es_representante && rep.parentesco) {
          if (rep.parentesco === "Padre") {
            quienRep = "Padre";
          } else if (rep.parentesco !== "Madre") {
            quienRep = "Otro";
            parentescoOtro = rep.parentesco;
          }
        }

        setFormData(prev => ({
          ...prev,
          id_estudiante: est.id || student.id,
          nombres: est.nombres || student.first_name || prev.nombres,
          apellidos: est.apellidos || student.last_name || prev.apellidos,
          fecha_nac: formattedDate || prev.fecha_nac,
          direccion_Habitacion: est.direccion || prev.direccion_Habitacion,
          grado: mappedGrade || prev.grado,
          escuela: est.escuela || prev.escuela,
          Grado_Escuela: est.grado_escuela || prev.Grado_Escuela,
          Seguro_Escolar: est.seguro_escolar ? "si" : (prev.Seguro_Escolar || "no"),
          nombre_Seguro: est.nombre_seguro || prev.nombre_Seguro,
          Telefono_Celular: est.telefono || prev.Telefono_Celular,

          // Representante
          quien_es_representante: quienRep,
          parentesco_Otro: parentescoOtro,
          primer_nombre_Rep: repNombres.first || prev.primer_nombre_Rep,
          segundo_nombre_Rep: repNombres.second || prev.segundo_nombre_Rep,
          primer_apellido_Rep: repApellidos.first || prev.primer_apellido_Rep,
          segundo_apellido_Rep: repApellidos.second || prev.segundo_apellido_Rep,
          nombres_Representante: rep.nombres || prev.nombres_Representante,
          apellidos_Representante: rep.apellidos || prev.apellidos_Representante,
          telefono_Rep_prefix: repTel.prefix || prev.telefono_Rep_prefix,
          telefono_Rep_number: repTel.number || prev.telefono_Rep_number,
          telefono_Rep: rep.telefono || prev.telefono_Rep,
          profesion_Rep: rep.profesion || prev.profesion_Rep,
          direccion_Trabajo_Rep: rep.direccion_trabajo || prev.direccion_Trabajo_Rep,

          // Madre
          primer_nombre_Madre: madreNombres.first || prev.primer_nombre_Madre,
          segundo_nombre_Madre: madreNombres.second || prev.segundo_nombre_Madre,
          primer_apellido_Madre: madreApellidos.first || prev.primer_apellido_Madre,
          segundo_apellido_Madre: madreApellidos.second || prev.segundo_apellido_Madre,
          nombre_Madre: (infoMadre?.nombre || infoMadre?.nombres) || prev.nombre_Madre,
          apellido_Madre: (infoMadre?.apellido || infoMadre?.apellidos) || prev.apellido_Madre,
          cedula_Madre: infoMadre?.cedula || prev.cedula_Madre,
          ocupacion_Madre: infoMadre?.profesion || infoMadre?.profesion_padre || prev.ocupacion_Madre,
          direccion_Trabajo_Madre: infoMadre?.direccion_trabajo || infoMadre?.direccion_trabajo_padre || prev.direccion_Trabajo_Madre,
          telefono_Madre_prefix: madreTel.prefix || prev.telefono_Madre_prefix,
          telefono_Madre_number: madreTel.number || prev.telefono_Madre_number,
          telefono_Madre: infoMadre?.telefono || prev.telefono_Madre,

          // Padre
          primer_nombre_Padre: padreNombres.first || prev.primer_nombre_Padre,
          segundo_nombre_Padre: padreNombres.second || prev.segundo_nombre_Padre,
          primer_apellido_Padre: padreApellidos.first || prev.primer_apellido_Padre,
          segundo_apellido_Padre: padreApellidos.second || prev.segundo_apellido_Padre,
          nombre_Padre: (infoPadre?.nombre || infoPadre?.nombres) || prev.nombre_Padre,
          apellido_Padre: (infoPadre?.apellido || infoPadre?.apellidos) || prev.apellido_Padre,
          cedula_Padre: infoPadre?.cedula || prev.cedula_Padre,
          ocupacion_Padre: infoPadre?.profesion || infoPadre?.profesion_padre || prev.ocupacion_Padre,
          direccion_Trabajo_Padre: infoPadre?.direccion_trabajo || infoPadre?.direccion_trabajo_padre || prev.direccion_Trabajo_Padre,
          telefono_Padre_prefix: padreTel.prefix || prev.telefono_Padre_prefix,
          telefono_Padre_number: padreTel.number || prev.telefono_Padre_number,
          telefono_Padre: infoPadre?.telefono || prev.telefono_Padre,

          // Salud
          peso: hm.peso || prev.peso,
          talla: hm.talla || prev.talla,
          tipo_sangre: hm.tipo_sangre || prev.tipo_sangre,
          intolerancia: hm.intolerancia || prev.intolerancia,
          textIntolerancia: hm.textIntolerancia || prev.textIntolerancia,
          operaciones: hm.operaciones || prev.operaciones,
          textOperaciones: hm.textOperaciones || prev.textOperaciones,
          control_Hormonal: hm.control_hormonal || prev.control_Hormonal,
          textcontrolHormonal: hm.textcontrolHormonal || prev.textcontrolHormonal,
          alergias: hm.alergias || prev.alergias,
          textAlergia: hm.textAlergia || prev.textAlergia,
          nacimiento: hm.termino_nacimiento || prev.nacimiento,
          antecedentesFamiliares: hm.antecedentes_familiares || prev.antecedentesFamiliares,
        }));

      } catch (err) {
        console.warn("⚠️ No se pudieron precargar los datos completos:", err);
      } finally {
        setCargandoPrecarga(false);
      }
    };

    precargarDatos();
  }, [student, activeYear]);

  useEffect(() => {
    // Actualizar año académico si cambia
    if (activeYear) {
      setFormData(prev => ({ ...prev, id_ano_academico: activeYear.id }));
    }
  }, [activeYear]);

  const calculateAge = (birthDate) => {
    if (!birthDate) return "";
    const today = new Date();
    const birth = new Date(birthDate);
    let age = today.getFullYear() - birth.getFullYear();
    const monthDiff = today.getMonth() - birth.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
      age--;
    }
    return age > 0 ? age : "";
  };

  // Mapa para limpiar errores de campos combinados
  const combinedFieldMap = {
    primer_nombre_Madre: 'nombre_Madre', segundo_nombre_Madre: 'nombre_Madre',
    primer_apellido_Madre: 'apellido_Madre', segundo_apellido_Madre: 'apellido_Madre',
    telefono_Madre_prefix: 'telefono_Madre', telefono_Madre_number: 'telefono_Madre',
    primer_nombre_Padre: 'nombre_Padre', segundo_nombre_Padre: 'nombre_Padre',
    primer_apellido_Padre: 'apellido_Padre', segundo_apellido_Padre: 'apellido_Padre',
    telefono_Padre_prefix: 'telefono_Padre', telefono_Padre_number: 'telefono_Padre',
    primer_nombre_Rep: 'nombres_Representante', segundo_nombre_Rep: 'nombres_Representante',
    primer_apellido_Rep: 'apellidos_Representante', segundo_apellido_Rep: 'apellidos_Representante',
    telefono_Rep_prefix: 'telefono_Rep', telefono_Rep_number: 'telefono_Rep',
  };

  const handleChange = (e) => {
    const { name, value } = e.target;

    // Solo permitir números en cédulas y teléfonos
    let cleanValue = value;
    const numericFields = [
      "cedula_Madre", "cedula_Padre",
      "telefono_Madre_number", "telefono_Padre_number",
      "telefono_Rep_number", "telefonofijo_Rep"
    ];
    if (numericFields.includes(name)) {
      cleanValue = value.replace(/[^0-9]/g, "");
    }

    // Función que combina los campos divididos en los campos que espera el backend
    const buildUpdated = (prev) => {
      const updated = { ...prev, [name]: cleanValue };

      // ─── Madre: nombre ───
      if (['primer_nombre_Madre', 'segundo_nombre_Madre'].includes(name)) {
        const pn = name === 'primer_nombre_Madre' ? cleanValue : prev.primer_nombre_Madre;
        const sn = name === 'segundo_nombre_Madre' ? cleanValue : prev.segundo_nombre_Madre;
        updated.nombre_Madre = [pn, sn].filter(Boolean).join(' ');
      }
      if (['primer_apellido_Madre', 'segundo_apellido_Madre'].includes(name)) {
        const pa = name === 'primer_apellido_Madre' ? cleanValue : prev.primer_apellido_Madre;
        const sa = name === 'segundo_apellido_Madre' ? cleanValue : prev.segundo_apellido_Madre;
        updated.apellido_Madre = [pa, sa].filter(Boolean).join(' ');
      }
      if (['telefono_Madre_prefix', 'telefono_Madre_number'].includes(name)) {
        const prefix = name === 'telefono_Madre_prefix' ? cleanValue : prev.telefono_Madre_prefix;
        const number = name === 'telefono_Madre_number' ? cleanValue : prev.telefono_Madre_number;
        updated.telefono_Madre = number ? `${prefix}-${number}` : '';
      }

      // ─── Padre: nombre ───
      if (['primer_nombre_Padre', 'segundo_nombre_Padre'].includes(name)) {
        const pn = name === 'primer_nombre_Padre' ? cleanValue : prev.primer_nombre_Padre;
        const sn = name === 'segundo_nombre_Padre' ? cleanValue : prev.segundo_nombre_Padre;
        updated.nombre_Padre = [pn, sn].filter(Boolean).join(' ');
      }
      if (['primer_apellido_Padre', 'segundo_apellido_Padre'].includes(name)) {
        const pa = name === 'primer_apellido_Padre' ? cleanValue : prev.primer_apellido_Padre;
        const sa = name === 'segundo_apellido_Padre' ? cleanValue : prev.segundo_apellido_Padre;
        updated.apellido_Padre = [pa, sa].filter(Boolean).join(' ');
      }
      if (['telefono_Padre_prefix', 'telefono_Padre_number'].includes(name)) {
        const prefix = name === 'telefono_Padre_prefix' ? cleanValue : prev.telefono_Padre_prefix;
        const number = name === 'telefono_Padre_number' ? cleanValue : prev.telefono_Padre_number;
        updated.telefono_Padre = number ? `${prefix}-${number}` : '';
      }

      // ─── Representante Otro: nombre ───
      if (['primer_nombre_Rep', 'segundo_nombre_Rep'].includes(name)) {
        const pn = name === 'primer_nombre_Rep' ? cleanValue : prev.primer_nombre_Rep;
        const sn = name === 'segundo_nombre_Rep' ? cleanValue : prev.segundo_nombre_Rep;
        updated.nombres_Representante = [pn, sn].filter(Boolean).join(' ');
      }
      if (['primer_apellido_Rep', 'segundo_apellido_Rep'].includes(name)) {
        const pa = name === 'primer_apellido_Rep' ? cleanValue : prev.primer_apellido_Rep;
        const sa = name === 'segundo_apellido_Rep' ? cleanValue : prev.segundo_apellido_Rep;
        updated.apellidos_Representante = [pa, sa].filter(Boolean).join(' ');
      }
      if (['telefono_Rep_prefix', 'telefono_Rep_number'].includes(name)) {
        const prefix = name === 'telefono_Rep_prefix' ? cleanValue : prev.telefono_Rep_prefix;
        const number = name === 'telefono_Rep_number' ? cleanValue : prev.telefono_Rep_number;
        updated.telefono_Rep = number ? `${prefix}-${number}` : '';
      }

      return updated;
    };

    if (name === "fecha_nac") {
      const calculatedAge = calculateAge(cleanValue);
      setFormData(prev => ({ ...buildUpdated(prev), edad: calculatedAge }));
    } else {
      setFormData(buildUpdated);
    }

    // Limpiar error del campo (y del campo combinado relacionado)
    const combinedKey = combinedFieldMap[name];
    if (errores[name] || errores[combinedKey]) {
      setErrores(prev => {
        const newErrs = { ...prev };
        delete newErrs[name];
        if (combinedKey) delete newErrs[combinedKey];
        return newErrs;
      });
    }
  };

  const validarPaso = (pasoActual) => {
    const nuevosErrores = {};

    switch (pasoActual) {
      case 1:
        if (!formData.nombres?.trim()) nuevosErrores.nombres = "Nombres requeridos";
        if (!formData.apellidos?.trim()) nuevosErrores.apellidos = "Apellidos requeridos";
        if (!formData.fecha_nac) nuevosErrores.fecha_nac = "Fecha de nacimiento requerida";
        if (!formData.grado) nuevosErrores.grado = "Seleccione un grado";
        // 👇 TELÉFONO DEL ESTUDIANTE ELIMINADO DE VALIDACIÓN
        break;

      case 2:
        if (!formData.quien_es_representante) {
          nuevosErrores.quien_es_representante = "Debe seleccionar quién será el representante";
        } else {
          // Validar según la selección
          if (formData.quien_es_representante === 'Madre') {
            // Solo validamos que tenga al menos un teléfono de contacto
            if (!formData.telefono_Madre?.trim()) {
              nuevosErrores.telefono_Madre = "Debe proporcionar un teléfono de contacto para la madre";
            }
            // NO validamos campos de representante (son opcionales)
          }
          else if (formData.quien_es_representante === 'Padre') {
            // Solo validamos que tenga al menos un teléfono de contacto
            if (!formData.telefono_Padre?.trim()) {
              nuevosErrores.telefono_Padre = "Debe proporcionar un teléfono de contacto para el padre";
            }
            // NO validamos campos de representante (son opcionales)
          }
          else if (formData.quien_es_representante === 'Otro') {
            // Validar TODOS los campos del representante (son obligatorios)
            if (!formData.nombres_Representante?.trim()) nuevosErrores.nombres_Representante = "Nombre del representante requerido";
            if (!formData.apellidos_Representante?.trim()) nuevosErrores.apellidos_Representante = "Apellidos del representante requerido";
            if (!formData.parentesco_Otro?.trim()) nuevosErrores.parentesco_Otro = "Parentesco requerido";
            if (!formData.telefono_Rep?.trim()) nuevosErrores.telefono_Rep = "Teléfono del representante requerido";
          }
        }
        break;

      case 3:
        if (formData.alergias === "Si" && !formData.textAlergia?.trim()) {
          nuevosErrores.textAlergia = "Describa las alergias";
        }
        if (formData.intolerancia === "Si" && !formData.textIntolerancia?.trim()) {
          nuevosErrores.textIntolerancia = "Describa las intolerancias";
        }
        if (formData.medicacion === "Si" && !formData.textMedicacion?.trim()) {
          nuevosErrores.textMedicacion = "Describa la medicación";
        }
        if (formData.operaciones === "Si" && !formData.textOperaciones?.trim()) {
          nuevosErrores.textOperaciones = "Describa las operaciones";
        }
        break;
        
      default:
        break;
    }

    setErrores(nuevosErrores);
    return Object.keys(nuevosErrores).length === 0;
  };

  const handleNextStep = () => {
    if (!validarPaso(step)) {
      window.scrollTo(0, 0);
      return;
    }
    setStep(step + 1);
    window.scrollTo(0, 0);
  };

  const handlePrevStep = () => {
    setStep(step - 1);
    window.scrollTo(0, 0);
  };

  const handleSubmit = async () => {
    // Crear una copia del formData sin el campo Telefono_Celular (por si acaso)
    const { Telefono_Celular, ...datosParaEnviar } = formData;
    
    const valido = validarFormularioCompleto(datosParaEnviar);

    if (!valido.esValido) {
      setErrores(valido.errores);
      window.scrollTo(0, 0);
      return;
    }

    // Verificar que tenemos el ID del estudiante
    if (!formData.id_estudiante) {
      alert("Error: No se ha identificado al estudiante.");
      return;
    }

    // Limpiar formato de teléfonos y capitalizar nombres
    const datosLimpios = {
      ...datosParaEnviar,
      nombre_Madre: capitalizeWords(datosParaEnviar.nombre_Madre),
      apellido_Madre: capitalizeWords(datosParaEnviar.apellido_Madre),
      nombre_Padre: capitalizeWords(datosParaEnviar.nombre_Padre),
      apellido_Padre: capitalizeWords(datosParaEnviar.apellido_Padre),
      nombres_Representante: capitalizeWords(datosParaEnviar.nombres_Representante),
      apellidos_Representante: capitalizeWords(datosParaEnviar.apellidos_Representante),
      telefono_Madre: formData.telefono_Madre?.replace(/[^\d]/g, '').slice(0, 11) || null,
      telefono_Padre: formData.telefono_Padre?.replace(/[^\d]/g, '').slice(0, 11) || null,
      telefono_Rep: formData.telefono_Rep?.replace(/[^\d]/g, '').slice(0, 11) || null,
      telefonofijo_Rep: formData.telefonofijo_Rep?.replace(/[^\d]/g, '').slice(0, 11) || null,
    };

    setEnviando(true);
    
    try {
      const resultado = await inscribirEstudiante({
        id_estudiante: formData.id_estudiante,
        id_ano_academico: formData.id_ano_academico,
        datos_completos: datosLimpios
      });
      
      const codigo = resultado.codigo || generarCodigoInscripcion();
      setCodigoInscripcion(codigo);
      setInscripcionEnviada(true);
      setStep(4);

    } catch (error) {
      console.error("Error al enviar inscripción:", error);
      const errorMsg = error.message || "Ocurrió un error al procesar la inscripción. Por favor, intente nuevamente.";
      alert(errorMsg);
      if (errorMsg.toLowerCase().includes("ya se encuentra inscrito")) {
        setYaInscrito(true);
        setMensajeYaInscrito(errorMsg);
      }
    } finally {
      setEnviando(false);
    }
  };

  const handleDescargarPlanilla = () => {
    generarPlanillaHTML(formData, codigoInscripcion);
  };

  const handleFinalizar = () => {
    onVolver();
  };

  const progressPercentage = step * 25;

  return (
    <CContainer className="py-4 animate__animated animate__fadeIn">
      <CCard className="premium-card border-0 shadow-lg overflow-hidden">
        <CCardHeader className="bg-orange-soft border-0 py-4 px-4 px-md-5">
          <CRow className="align-items-center">
            <CCol md={8}>
              <div className="d-flex align-items-center">
                <div className="p-3 bg-primary rounded-circle me-3 shadow-sm d-none d-md-block">
                  <CIcon icon={step === 4 ? cilCheckCircle : cilFile} size="xl" className="text-white" />
                </div>
                <div>
                  <h4 className="mb-0 fw-bold inscripcion-header-title text-uppercase ls-1">
                    {step === 4 ? 'CONFIRMACIÓN EXITOSA' : 'REGISTRO DE ASPIRANTE'}
                  </h4>
                  <p className="mb-0 inscripcion-header-subtitle small fw-bold text-uppercase ls-1">
                    {step === 4 
                      ? 'Proceso finalizado correctamente' 
                      : `ESTUDIANTE: ${formData.nombres} ${formData.apellidos}`}
                  </p>
                  {activeYear && step !== 4 && (
                    <small className="d-block mt-1 text-white-50">
                      Año Académico: {activeYear.name}
                    </small>
                  )}
                </div>
              </div>
            </CCol>
            <CCol md={4} className="text-end">
              <CBadge className="rounded-pill px-4 py-2 inscripcion-id-badge fw-bold shadow-sm border border-light">
                PASO {step} / 4
              </CBadge>
            </CCol>
          </CRow>
        </CCardHeader>

        <CCardBody className="p-4 p-md-5">
          {/* Barra de progreso */}
          <div className="mb-5">
            <div className="d-flex justify-content-between mb-2">
              <small className="inscripcion-header-subtitle fw-bold text-uppercase ls-1" style={{ fontSize: '0.65rem' }}>AVANCE DEL FORMULARIO</small>
              <small className="text-primary fw-bold">{progressPercentage.toFixed(0)}%</small>
            </div>
            <CProgress className="rounded-pill bg-progress-track" height={8}>
              <CProgressBar
                value={progressPercentage}
                className="rounded-pill"
                style={{ backgroundColor: 'var(--primary-600)' }}
              />
            </CProgress>
          </div>

          {/* Navegación por Tabs */}
          {step !== 4 && (
            <CNav variant="pills" className="mb-5 bg-nav-pill p-2 rounded-pill d-inline-flex w-100 justify-content-between">
              <CNavItem className="flex-fill text-center">
                <CNavLink
                  active={step === 1}
                  className={`rounded-pill fw-bold py-2 ${step === 1 ? 'nav-pill-active shadow-sm' : 'nav-pill-inactive'}`}
                  disabled
                >
                  <CIcon icon={cilUser} className="me-2" />
                  ESTUDIANTE
                </CNavLink>
              </CNavItem>
              <CNavItem className="flex-fill text-center">
                <CNavLink
                  active={step === 2}
                  className={`rounded-pill fw-bold py-2 ${step === 2 ? 'nav-pill-active shadow-sm' : 'nav-pill-inactive'}`}
                  disabled
                >
                  <CIcon icon={cilBriefcase} className="me-2" />
                  REPRESENTANTE
                </CNavLink>
              </CNavItem>
              <CNavItem className="flex-fill text-center">
                <CNavLink
                  active={step === 3}
                  className={`rounded-pill fw-bold py-2 ${step === 3 ? 'nav-pill-active shadow-sm' : 'nav-pill-inactive'}`}
                  disabled
                >
                  <CIcon icon={cilMedicalCross} className="me-2" />
                  SALUD
                </CNavLink>
              </CNavItem>
            </CNav>
          )}

          {yaInscrito && step !== 4 && (
            <CAlert color="warning" className="mb-4 border-0 shadow-sm rounded-4 animate__animated animate__fadeIn">
              <div className="d-flex align-items-center">
                <CIcon icon={cilWarning} className="flex-shrink-0 me-3 text-warning" size="xl" />
                <div className="flex-grow-1">
                  <h6 className="mb-1 fw-bold">Estudiante Ya Inscrito en Este Período</h6>
                  <p className="mb-0 small">{mensajeYaInscrito}</p>
                </div>
                <CButton
                  color="warning"
                  variant="outline"
                  size="sm"
                  className="ms-3 rounded-pill fw-bold"
                  onClick={onVolver}
                >
                  Volver a la Lista
                </CButton>
              </div>
            </CAlert>
          )}

          {cargandoPrecarga && (
            <div className="text-center py-3 mb-4 rounded-4 bg-light">
              <CSpinner color="warning" size="sm" className="me-2" />
              <span className="small text-muted fw-bold">Precargando información del estudiante y representante...</span>
            </div>
          )}

          {Object.keys(errores).length > 0 && step !== 4 && (
            <CAlert color="danger" className="mb-4 border-0 shadow-sm rounded-4 animate__animated animate__shakeX">
              <div className="d-flex align-items-center mb-2">
                <CIcon icon={cilWarning} className="me-2" size="lg" />
                <h6 className="mb-0 fw-bold">Atención Requerida</h6>
              </div>
              <ul className="mb-0 ps-3 small">
                {Object.entries(errores).map(([campo, mensaje]) => (
                  <li key={campo}>{mensaje}</li>
                ))}
              </ul>
            </CAlert>
          )}

          <div className="step-content mb-5">
            <CTabContent>
              <CTabPane visible={step === 1}>
                <DatosEstudiante 
                  formData={formData} 
                  onChange={handleChange} 
                  errores={errores} 
                  mode="completo"
                />
              </CTabPane>
              <CTabPane visible={step === 2}>
                <DatosRepresentante 
                  formData={formData} 
                  onChange={handleChange} 
                  errores={errores} 
                  setErrores={setErrores}
                />
              </CTabPane>
              <CTabPane visible={step === 3}>
                <DatosSalud 
                  formData={formData} 
                  onChange={handleChange} 
                  errores={errores} 
                />
              </CTabPane>
              <CTabPane visible={step === 4}>
                <ConfirmacionInscripcion 
                  formData={formData} 
                  codigoInscripcion={codigoInscripcion} 
                  onDescargar={handleDescargarPlanilla} 
                />
              </CTabPane>
            </CTabContent>
          </div>

          <div className="d-flex justify-content-between align-items-center pt-4 border-top border-light-custom">
            <div>
              {step > 1 && step < 4 ? (
                <CButton
                  onClick={handlePrevStep}
                  className="rounded-pill px-4 border-2 fw-bold inscripcion-back-btn hover-orange"
                  disabled={enviando}
                >
                  <CIcon icon={cilArrowLeft} className="me-2" /> ATRÁS
                </CButton>
              ) : step === 1 ? (
                <CButton
                  onClick={onVolver}
                  className="rounded-pill px-4 border-2 fw-bold inscripcion-cancel-btn hover-danger transition-all"
                  disabled={enviando}
                >
                  {yaInscrito ? "VOLVER A LA LISTA" : "CANCELAR PROCESO"}
                </CButton>
              ) : null}
            </div>

            <div>
              {step < 3 ? (
                <CButton
                  className="btn-premium rounded-pill px-5 shadow-sm"
                  onClick={handleNextStep}
                  disabled={enviando || yaInscrito}
                >
                  SIGUIENTE PASO <CIcon icon={cilArrowRight} className="ms-2" />
                </CButton>
              ) : step === 3 ? (
                <CButton
                  color="success"
                  className="rounded-pill px-5 text-white fw-bold shadow-sm bg-success border-0"
                  onClick={handleSubmit}
                  disabled={enviando || yaInscrito}
                  style={{ background: 'linear-gradient(135deg, #10b981, #059669)' }}
                >
                  {enviando ? (
                    <>
                      <CSpinner component="span" size="sm" className="me-2" />
                      PROCESANDO...
                    </>
                  ) : (
                    <>
                      <CIcon icon={cilCheckCircle} className="me-2" /> FINALIZAR INSCRIPCIÓN
                    </>
                  )}
                </CButton>
              ) : step === 4 ? (
                <CButton
                  className="btn-premium rounded-pill px-5 shadow-sm"
                  onClick={handleFinalizar}
                >
                  VOLVER AL INICIO
                </CButton>
              ) : null}
            </div>
          </div>
        </CCardBody>

        <CCardFooter className="text-center inscripcion-footer border-0 py-3">
          <small className="inscripcion-footer-text fw-bold text-uppercase ls-1" style={{ fontSize: '0.65rem' }}>
            {step === 4
              ? `REGISTRO OFICIAL ID: ${codigoInscripcion} • ${new Date().toLocaleDateString('es-ES')}`
              : `INSCRIPCIÓN PARA: ${formData.nombres} ${formData.apellidos} • TODOS LOS CAMPOS MARCADOS CON (*) SON OBLIGATORIOS`}
          </small>
        </CCardFooter>
      </CCard>
    </CContainer>
  );
};

export default InscripcionCompletaForm;