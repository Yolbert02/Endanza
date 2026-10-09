import React from 'react';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import '../../styles/planillasOficiales.css';
import logoEndanza from '../../assets/images/logo-endanza.png';
import logoMinisterio from '../../assets/images/logo-ministerio.png';

/**
 * Normaliza cualquier fuente de datos (sea formData de inscripción o student del perfil)
 * en una estructura limpia y consistente para las 4 planillas.
 */
export const normalizarDatosPlanillas = (data = {}, extra = {}) => {
  if (!data) data = {};

  // Determinar quién es el representante: 'Madre', 'Padre', u 'Otro'
  let quienEsRep = data.quien_es_representante || data.representative_relationship || data.RepresentanteParentesco || '';
  quienEsRep = String(quienEsRep).trim();

  // Si no está explícito, inferir por parentesco
  if (!quienEsRep) {
    if (data.parentesco && /madre/i.test(data.parentesco)) quienEsRep = 'Madre';
    else if (data.parentesco && /padre/i.test(data.parentesco)) quienEsRep = 'Padre';
    else if (data.relacion && /madre/i.test(data.relacion)) quienEsRep = 'Madre';
    else if (data.relacion && /padre/i.test(data.relacion)) quienEsRep = 'Padre';
    else quienEsRep = 'Madre'; // default en ENDANZA
  }

  const esMadreRep = /madre/i.test(quienEsRep);
  const esPadreRep = /padre/i.test(quienEsRep);
  const esTerceroRep = !esMadreRep && !esPadreRep;

  // Formato de fecha de nacimiento
  let fechaNac = data.fecha_nac || data.birth_date || data.birthDate || data.fecha_nacimiento || '';
  if (fechaNac && String(fechaNac).includes('T')) {
    fechaNac = String(fechaNac).split('T')[0];
  }

  // Código de planilla
  const codPlanilla = extra.codigoInscripcion || data.codigoInscripcion || data.codigo_inscripcion || data.student_code || data.id || 'END-2025';

  // Periodo académico
  const periodo = extra.activeYear?.name || extra.periodo || data.anoAcademico || data.periodo || '2025-2026';

  // Fecha de emisión actual
  const fechaHoy = new Date().toISOString().split('T')[0];

  // Cálculo de edad
  let edadCalc = data.edad;
  if (!edadCalc && fechaNac) {
    try {
      const b = new Date(fechaNac);
      const diff = Date.now() - b.getTime();
      const ageDate = new Date(diff);
      edadCalc = Math.abs(ageDate.getUTCFullYear() - 1970);
    } catch (e) {
      edadCalc = '';
    }
  }

  // Nombre de Estudiante
  const primerNomEst = data.EstudiantePrimerNombre || data.first_name || data.primer_nombre || '';
  const segundoNomEst = data.EstudianteSegundoNombre || data.middle_name || data.segundo_nombre || '';
  const primerApeEst = data.EstudiantePrimerApellido || data.last_name || data.primer_apellido || '';
  const segundoApeEst = data.EstudianteSegundoApellido || data.second_last_name || data.segundo_apellido || '';

  let nombresEst = (
    data.NombreEstudiante ||
    `${primerNomEst} ${segundoNomEst}`.trim() ||
    data.nombres ||
    data.first_name ||
    data.nombre ||
    ''
  ).trim();

  let apellidosEst = (
    data.ApellidoEstudiante ||
    `${primerApeEst} ${segundoApeEst}`.trim() ||
    data.apellidos ||
    data.last_name ||
    data.apellido ||
    ''
  ).trim();

  if (!nombresEst && !apellidosEst && data.full_name) {
    const parts = data.full_name.trim().split(/\s+/);
    if (parts.length >= 4) {
      nombresEst = `${parts[0]} ${parts[1]}`;
      apellidosEst = parts.slice(2).join(' ');
    } else if (parts.length === 3) {
      nombresEst = `${parts[0]} ${parts[1]}`;
      apellidosEst = parts[2];
    } else if (parts.length === 2) {
      nombresEst = parts[0];
      apellidosEst = parts[1];
    } else {
      nombresEst = data.full_name;
    }
  }

  const cedulaEst = data.cedula || data.dni || data.documento || data.cedula_escolar || '—';

  // Nombre y datos de la Madre
  const primerNomMadre = data.MadrePrimerNombre || data.primer_nombre_Madre || '';
  const segundoNomMadre = data.MadreSegundoNombre || data.segundo_nombre_Madre || '';
  const primerApeMadre = data.MadrePrimerApellido || data.primer_apellido_Madre || '';
  const segundoApeMadre = data.MadreSegundoApellido || data.segundo_apellido_Madre || '';

  let nombresMadre = (
    `${primerNomMadre} ${segundoNomMadre}`.trim() ||
    data.nombre_Madre ||
    data.MadreNombre ||
    data.primer_nombre_Madre ||
    ''
  ).trim();

  let apellidosMadre = (
    `${primerApeMadre} ${segundoApeMadre}`.trim() ||
    data.apellido_Madre ||
    data.MadreApellido ||
    data.primer_apellido_Madre ||
    ''
  ).trim();

  // Si nombresMadre contiene el nombre completo (3 o 4 palabras) y apellidosMadre está vacío:
  if (nombresMadre && !apellidosMadre) {
    const parts = nombresMadre.split(/\s+/).filter(Boolean);
    if (parts.length >= 4) {
      nombresMadre = `${parts[0]} ${parts[1]}`;
      apellidosMadre = parts.slice(2).join(' ');
    } else if (parts.length === 3) {
      nombresMadre = `${parts[0]} ${parts[1]}`;
      apellidosMadre = parts[2];
    } else if (parts.length === 2) {
      nombresMadre = parts[0];
      apellidosMadre = parts[1];
    }
  }

  const cedulaMadre = data.cedula_Madre || data.MadreCedula || (esMadreRep ? (data.cedula_Rep || data.representative_dni) : '') || '—';
  const telMadre = data.telefono_Madre || data.MadreTelefono || (data.telefono_Madre_prefix && data.telefono_Madre_number ? `${data.telefono_Madre_prefix}${data.telefono_Madre_number}` : '') || '—';
  const profesionMadre = data.ocupacion_Madre || data.MadreOcupacion || (esMadreRep ? (data.profesion_Rep || data.representative_occupation || data.RepresentanteOcupacion) : '') || '—';
  const trabajoMadre = data.trabajo_Madre || data.MadreLugarTrabajo || data.lugar_trabajo_Madre || (esMadreRep ? (data.trabajo_Rep || data.representative_workplace || data.RepresentanteLugarTrabajo) : '') || '—';
  const dirTrabajoMadre = data.direccion_Trabajo_Madre || data.MadreDireccionTrabajo || data.direccion_trabajo_Madre || (esMadreRep ? (data.direccion_Trabajo_Rep || data.representative_work_address || data.direccion_trabajo || data.RepresentanteDireccionTrabajo) : '') || '—';
  const telTrabajoMadre = data.telefono_trabajo_Madre || data.MadreTelefonoTrabajo || (esMadreRep ? (data.telefono_trabajo_Rep || data.representative_work_phone || data.telefono_trabajo || data.RepresentanteTelefonoTrabajo) : '') || '—';

  // Nombre y datos del Padre
  const primerNomPadre = data.PadrePrimerNombre || data.primer_nombre_Padre || '';
  const segundoNomPadre = data.PadreSegundoNombre || data.segundo_nombre_Padre || '';
  const primerApePadre = data.PadrePrimerApellido || data.primer_apellido_Padre || '';
  const segundoApePadre = data.PadreSegundoApellido || data.segundo_apellido_Padre || '';

  let nombresPadre = (
    `${primerNomPadre} ${segundoNomPadre}`.trim() ||
    data.nombre_Padre ||
    data.PadreNombre ||
    data.primer_nombre_Padre ||
    ''
  ).trim();

  let apellidosPadre = (
    `${primerApePadre} ${segundoApePadre}`.trim() ||
    data.apellido_Padre ||
    data.PadreApellido ||
    data.primer_apellido_Padre ||
    ''
  ).trim();

  // Si nombresPadre contiene el nombre completo (3 o 4 palabras) y apellidosPadre está vacío:
  if (nombresPadre && !apellidosPadre) {
    const parts = nombresPadre.split(/\s+/).filter(Boolean);
    if (parts.length >= 4) {
      nombresPadre = `${parts[0]} ${parts[1]}`;
      apellidosPadre = parts.slice(2).join(' ');
    } else if (parts.length === 3) {
      nombresPadre = `${parts[0]} ${parts[1]}`;
      apellidosPadre = parts[2];
    } else if (parts.length === 2) {
      nombresPadre = parts[0];
      apellidosPadre = parts[1];
    }
  }

  const cedulaPadre = data.cedula_Padre || data.PadreCedula || (esPadreRep ? (data.cedula_Rep || data.representative_dni) : '') || '—';
  const telPadre = data.telefono_Padre || data.PadreTelefono || (data.telefono_Padre_prefix && data.telefono_Padre_number ? `${data.telefono_Padre_prefix}${data.telefono_Padre_number}` : '') || '—';
  const profesionPadre = data.ocupacion_Padre || data.PadreOcupacion || (esPadreRep ? (data.profesion_Rep || data.representative_occupation || data.RepresentanteOcupacion) : '') || '—';
  const trabajoPadre = data.trabajo_Padre || data.PadreLugarTrabajo || data.lugar_trabajo_Padre || (esPadreRep ? (data.trabajo_Rep || data.representative_workplace || data.RepresentanteLugarTrabajo) : '') || '—';
  const dirTrabajoPadre = data.direccion_Trabajo_Padre || data.PadreDireccionTrabajo || data.direccion_trabajo_Padre || (esPadreRep ? (data.direccion_Trabajo_Rep || data.representative_work_address || data.direccion_trabajo || data.RepresentanteDireccionTrabajo) : '') || '—';
  const telTrabajoPadre = data.telefono_trabajo_Padre || data.PadreTelefonoTrabajo || (esPadreRep ? (data.telefono_trabajo_Rep || data.representative_work_phone || data.telefono_trabajo || data.RepresentanteTelefonoTrabajo) : '') || '—';

  // Representante Legal resuelto
  let repNombreCompleto = '';
  let repCedula = '';
  let repTelefono = '';
  let repProfesion = '';
  let repTrabajo = '';
  let repDirTrabajo = '';
  let repTelTrabajo = '';
  let repParentesco = quienEsRep;

  if (esMadreRep) {
    repNombreCompleto = `${nombresMadre} ${apellidosMadre}`.trim() || data.representative || '—';
    repCedula = cedulaMadre;
    repTelefono = telMadre;
    repProfesion = profesionMadre;
    repTrabajo = trabajoMadre;
    repDirTrabajo = dirTrabajoMadre;
    repTelTrabajo = telTrabajoMadre;
    repParentesco = 'Madre';
  } else if (esPadreRep) {
    repNombreCompleto = `${nombresPadre} ${apellidosPadre}`.trim() || data.representative || '—';
    repCedula = cedulaPadre;
    repTelefono = telPadre;
    repProfesion = profesionPadre;
    repTrabajo = trabajoPadre;
    repDirTrabajo = dirTrabajoPadre;
    repTelTrabajo = telTrabajoPadre;
    repParentesco = 'Padre';
  } else {
    const p1Rep = data.RepresentantePrimerNombre || data.primer_nombre_Rep || data.representative_first_name || '';
    const p2Rep = data.RepresentanteSegundoNombre || data.segundo_nombre_Rep || data.representative_second_name || '';
    const a1Rep = data.RepresentantePrimerApellido || data.primer_apellido_Rep || data.representative_last_name || '';
    const a2Rep = data.RepresentanteSegundoApellido || data.segundo_apellido_Rep || data.representative_second_last_name || '';

    const nombresRep = (data.nombres_Representante || `${p1Rep} ${p2Rep}`.trim() || '').trim();
    const apellidosRep = (data.apellidos_Representante || `${a1Rep} ${a2Rep}`.trim() || '').trim();

    if (nombresRep || apellidosRep) {
      repNombreCompleto = `${nombresRep} ${apellidosRep}`.trim();
    } else {
      repNombreCompleto = data.RepresentanteNombre || data.representative || '—';
    }
    repCedula = data.cedula_Rep || data.representative_dni || data.RepresentanteCedula || '—';
    repTelefono = data.telefono_Rep || data.representative_phone || data.RepresentanteTelefono || (data.telefono_Rep_prefix && data.telefono_Rep_number ? `${data.telefono_Rep_prefix}${data.telefono_Rep_number}` : '') || '—';
    repProfesion = data.profesion_Rep || data.profesion || data.representative_occupation || '—';
    repTrabajo = data.trabajo_Rep || data.trabajo || data.representative_workplace || '—';
    repDirTrabajo = data.direccion_Trabajo_Rep || data.direccion_Trabajo || data.representative_work_address || data.direccion_trabajo || '—';
    repTelTrabajo = data.telefono_trabajo_Rep || data.telefono_trabajo || data.representative_work_phone || '—';
    repParentesco = data.parentesco_Otro || data.parentesco || data.representative_relationship || 'Representante Legal';
  }

  // 1. Grado de la escuela regular (normal / primaria / bachillerato)
  const gradoEscuelaRegular = String(data.Grado_Escuela || data.grado_escuela || data.school_grade || data.grade_level_name || '').trim();

  // 2. Grado de la ESCUELA DE DANZA (priorizar explícitamente nivel de danza de ENDANZA)
  let gradoDanza = data.dance_level_name || data.dance_level || data.nivel_danza || data.grado_danza || data.grado || '';

  // Normalizar grado si viene con slug/guiones bajos (ej: 4to_grado -> 4to Grado)
  if (gradoDanza) {
    const mapGradosFormat = {
      'pre_ballet': 'Pre-Ballet',
      'preparatorio': 'Preparatorio',
      '1er_grado': '1er Grado',
      '2do_grado': '2do Grado',
      '3er_grado': '3er Grado',
      '4to_grado': '4to Grado',
      '5to_grado': '5to Grado',
      '6to_grado': '6to Grado',
      '7mo_grado': '7mo Grado',
      '8vo_grado': '8vo Grado'
    };
    const key = String(gradoDanza).toLowerCase().trim();
    if (mapGradosFormat[key]) {
      gradoDanza = mapGradosFormat[key];
    }
  }

  // Fallback si no se encontró nivel de danza
  if (!gradoDanza) {
    gradoDanza = 'SIN ASIGNAR';
  }

  let gradoFormateado = String(gradoDanza).replace(/_/g, ' ').toUpperCase();

  return {
    estudiante: {
      nombres: nombresEst || '—',
      apellidos: apellidosEst || '—',
      cedula: cedulaEst,
      fecha_nac: fechaNac || '—',
      direccion_Habitacion: data.direccion_Habitacion || data.address || data.direccion || '—',
      telefono_fijo: data.telefono_fijo || data.telefonofijo_Rep || data.telefono_fijo_estudiante || '—',
      telefono_movil: data.telefono_movil || (telMadre !== '—' ? telMadre : (telPadre !== '—' ? telPadre : repTelefono)),
      email: data.email || data.email_estudiante || data.email_Madre || data.email_Padre || data.email_Representante || '—',
      grado: gradoFormateado,
      especialidad: (data.especialidad || data.specialty || 'DANZA CLÁSICA').toUpperCase(),
      asignaturas_pendientes: data.asignaturas_pendientes || data.materias_pendientes || 'NINGUNA',
      alergico_medicamento: data.alergias === 'Si' || data.alergia_medicamento ? 'SÍ' : 'NO',
      alergico_explicacion: data.textAlergia || data.alergias_detalle || '',
      enfermedad: data.sintomasFrecuentes || data.enfermedad ? 'SÍ' : 'NO',
      enfermedad_explicacion: data.sintomasFrecuentes || data.enfermedad_detalle || '',
      convivencia: (data.convivencia || '—').toUpperCase(),
      escuela: (data.escuela || data.regular_school || data.nombre_escuela || '—').toUpperCase(),
      grado_escuela: (gradoEscuelaRegular || '—').toUpperCase(),
      seguro_escolar: data.Seguro_Escolar === 'Si' || data.tiene_seguro ? 'SÍ' : 'NO',
      nombre_seguro: data.nombre_Seguro || data.nombre_seguro || '',
      foto: data.foto || data.photo || data.avatar || null,
      codigo_planilla: codPlanilla
    },
    padre: {
      nombres: nombresPadre || '—',
      apellidos: apellidosPadre || '—',
      cedula: cedulaPadre,
      direccion: data.direccion_Padre || data.direccion_Habitacion || data.address || data.direccion || '—',
      telefono_fijo: data.telefono_fijo || '—',
      telefono_movil: telPadre,
      email: data.email_Padre || '—',
      profesion: profesionPadre,
      lugar_trabajo: trabajoPadre,
      direccion_trabajo: dirTrabajoPadre,
      telefono_trabajo: telTrabajoPadre || data.telefono_trabajo_Padre || '—',
      es_representante: esPadreRep
    },
    madre: {
      nombres: nombresMadre || '—',
      apellidos: apellidosMadre || '—',
      cedula: cedulaMadre,
      direccion: data.direccion_Madre || data.direccion_Habitacion || data.address || data.direccion || '—',
      telefono_fijo: data.telefono_fijo || '—',
      telefono_movil: telMadre,
      email: data.email_Madre || '—',
      profesion: profesionMadre,
      lugar_trabajo: trabajoMadre,
      direccion_trabajo: dirTrabajoMadre,
      telefono_trabajo: telTrabajoMadre || data.telefono_trabajo_Madre || '—',
      es_representante: esMadreRep
    },
    representante: {
      quien_es: quienEsRep,
      es_madre: esMadreRep,
      es_padre: esPadreRep,
      es_tercero: esTerceroRep,
      nombre_completo: repNombreCompleto,
      cedula: repCedula,
      parentesco: repParentesco,
      telefono: repTelefono,
      telefono_fijo: data.telefonofijo_Rep || '—',
      email: data.email_Representante || data.representative_email || '—',
      profesion: repProfesion,
      lugar_trabajo: repTrabajo,
      direccion_trabajo: repDirTrabajo,
      telefono_trabajo: repTelTrabajo || data.telefono_trabajo_Rep || '—',
      direccion: data.direccion_Rep || data.direccion_Habitacion || data.address || data.direccion || '—'
    },
    salud: {
      peso: data.peso || data.NutricionPeso || '25.00',
      talla: data.talla || data.NutricionAltura || '1.30',
      edad: edadCalc || '8',
      intolerancia: data.intolerancia === 'Si' ? 'SÍ' : 'NO',
      intolerancia_exp: data.textIntolerancia || '',
      dolores_cabeza_estomago: data.dolores_frecuentes || (data.sintomasFrecuentes && /dolor/i.test(data.sintomasFrecuentes)) ? 'SÍ' : 'NO',
      estrenimiento: data.estrenimiento === 'Si' ? 'SÍ' : 'NO',
      operaciones: data.operaciones === 'Si' ? 'SÍ' : 'NO',
      operaciones_exp: data.textOperaciones || '',
      tratamiento: data.medicacion === 'Si' ? 'SÍ' : 'NO',
      tratamiento_exp: data.textMedicacion || '',
      control_hormonal: data.control_Hormonal === 'Si' ? 'SÍ' : 'NO',
      control_hormonal_exp: data.textcontrolHormonal || '',
      alergias: data.alergias === 'Si' ? 'SÍ' : 'NO',
      alergias_exp: data.textAlergia || '',
      nacimiento: (data.nacimiento || 'A TÉRMINO').toUpperCase(),
      antecedentes: data.antecedentesFamiliares || 'Ninguno referido'
    },
    institucion: {
      periodo: periodo,
      fecha_emision: extra.fechaEmision || fechaHoy,
      direccion: 'Urbanización Tórbez- final Av. Bolívar. Teléfono 0276 343 49 88',
      lema: 'Escuela Nacional de Danza en el Camino de la Excelencia'
    }
  };
};

/**
 * HOJA 1: FICHA DE INSCRIPCIÓN (OFICIAL)
 */
export const FichaInscripcionSheet = ({ info }) => {
  const { estudiante, padre, madre, representante, institucion } = info;

  return (
    <div className="planilla-sheet">
      <div>
        {/* Encabezado */}
        <div className="planilla-header">
          <div className="planilla-header-logo-left">
            <img src={logoEndanza} alt="Logo Endanza" />
          </div>
          <div className="planilla-header-center">
            <p className="planilla-republica">República Bolivariana de Venezuela</p>
            <p className="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p className="planilla-escuela">Escuela Nacional de Danza</p>
            <p className="planilla-ciudad">San Cristóbal Táchira</p>
            <h4 className="planilla-doc-title">FICHA DE INSCRIPCIÓN</h4>
            <p className="planilla-doc-subtitle">{institucion.periodo}</p>
          </div>
          <div className="planilla-photo-box">
            {estudiante.foto ? (
              <img src={estudiante.foto} alt="Foto Estudiante" />
            ) : (
              <span>Foto del (la)<br />estudiante</span>
            )}
          </div>
        </div>

        {/* 1. DATOS DEL ESTUDIANTE */}
        <div className="planilla-section-bar">
          <span>DATOS DEL ESTUDIANTE</span>
        </div>
        <div className="planilla-grid">
          <div className="planilla-field" style={{ width: '48%' }}>
            <span className="planilla-label">Apellidos:</span>
            <span className="planilla-val">{estudiante.apellidos}</span>
          </div>
          <div className="planilla-field" style={{ width: '32%' }}>
            <span className="planilla-label">Nombres:</span>
            <span className="planilla-val">{estudiante.nombres}</span>
          </div>
          <div className="planilla-field" style={{ width: '18%' }}>
            <span className="planilla-label">Cédula:</span>
            <span className="planilla-val">{estudiante.cedula}</span>
          </div>

          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Fecha de Nacimiento:</span>
            <span className="planilla-val">{estudiante.fecha_nac}</span>
          </div>
          <div className="planilla-field" style={{ width: '68%' }}>
            <span className="planilla-label">Dirección de Habitación:</span>
            <span className="planilla-val">{estudiante.direccion_Habitacion}</span>
          </div>

          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Teléfono Fijo:</span>
            <span className="planilla-val">{estudiante.telefono_fijo}</span>
          </div>
          <div className="planilla-field" style={{ width: '32%' }}>
            <span className="planilla-label">Móvil:</span>
            <span className="planilla-val">{estudiante.telefono_movil}</span>
          </div>
          <div className="planilla-field" style={{ width: '36%' }}>
            <span className="planilla-label">Email:</span>
            <span className="planilla-val" style={{ textTransform: 'lowercase' }}>{estudiante.email}</span>
          </div>

          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Grado a Cursar:</span>
            <span className="planilla-val">{estudiante.grado}</span>
          </div>
          <div className="planilla-field" style={{ width: '34%' }}>
            <span className="planilla-label">Especialidad:</span>
            <span className="planilla-val">{estudiante.especialidad}</span>
          </div>
          <div className="planilla-field" style={{ width: '34%' }}>
            <span className="planilla-label">Asignatura(s) Pendiente(s):</span>
            <span className="planilla-val">{estudiante.asignaturas_pendientes}</span>
          </div>

          <div className="planilla-field" style={{ width: '38%' }}>
            <span className="planilla-label">Alérgico(a) a un medicamento?:</span>
            <span className="planilla-val">{estudiante.alergico_medicamento}</span>
          </div>
          <div className="planilla-field" style={{ width: '60%' }}>
            <span className="planilla-label">Explique:</span>
            <span className="planilla-val">{estudiante.alergico_explicacion || '—'}</span>
          </div>

          <div className="planilla-field" style={{ width: '38%' }}>
            <span className="planilla-label">Padece alguna enfermedad?:</span>
            <span className="planilla-val">{estudiante.enfermedad}</span>
          </div>
          <div className="planilla-field" style={{ width: '60%' }}>
            <span className="planilla-label">Explique:</span>
            <span className="planilla-val">{estudiante.enfermedad_explicacion || '—'}</span>
          </div>

          <div className="planilla-field" style={{ width: '98%' }}>
            <span className="planilla-label">Con quien convive:</span>
            <span className="planilla-val">{estudiante.convivencia}</span>
          </div>

          <div className="planilla-field" style={{ width: '68%' }}>
            <span className="planilla-label">Institución donde cursa estudios regulares:</span>
            <span className="planilla-val">{estudiante.escuela}</span>
          </div>
          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Año o Grado que cursa:</span>
            <span className="planilla-val">{estudiante.grado}</span>
          </div>

          <div className="planilla-field" style={{ width: '45%' }}>
            <span className="planilla-label">La estudiante posee seguro escolar:</span>
            <span className="planilla-val">{estudiante.seguro_escolar}</span>
          </div>
          <div className="planilla-field" style={{ width: '53%' }}>
            <span className="planilla-label">Cuál:</span>
            <span className="planilla-val">{estudiante.nombre_seguro || '—'}</span>
          </div>
        </div>

        {/* 2. DATOS DEL PADRE */}
        <div className="planilla-section-bar">
          <div>
            <span>DATOS DEL PADRE</span>
            {padre.es_representante && (
              <span className="planilla-badge-rep">[ REPRESENTANTE LEGAL ]</span>
            )}
          </div>
        </div>
        <div className="planilla-grid">
          <div className="planilla-field" style={{ width: '45%' }}>
            <span className="planilla-label">Apellidos:</span>
            <span className="planilla-val">{padre.apellidos}</span>
          </div>
          <div className="planilla-field" style={{ width: '33%' }}>
            <span className="planilla-label">Nombres:</span>
            <span className="planilla-val">{padre.nombres}</span>
          </div>
          <div className="planilla-field" style={{ width: '20%' }}>
            <span className="planilla-label">Cédula:</span>
            <span className="planilla-val">{padre.cedula}</span>
          </div>

          <div className="planilla-field" style={{ width: '98%' }}>
            <span className="planilla-label">Dirección de Habitación:</span>
            <span className="planilla-val">{padre.direccion}</span>
          </div>

          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Teléfono Fijo:</span>
            <span className="planilla-val">{padre.telefono_fijo}</span>
          </div>
          <div className="planilla-field" style={{ width: '32%' }}>
            <span className="planilla-label">Móvil:</span>
            <span className="planilla-val">{padre.telefono_movil}</span>
          </div>
          <div className="planilla-field" style={{ width: '36%' }}>
            <span className="planilla-label">Email:</span>
            <span className="planilla-val" style={{ textTransform: 'lowercase' }}>{padre.email}</span>
          </div>

          <div className="planilla-field" style={{ width: '45%' }}>
            <span className="planilla-label">Profesión:</span>
            <span className="planilla-val">{padre.profesion}</span>
          </div>
          <div className="planilla-field" style={{ width: '53%' }}>
            <span className="planilla-label">Lugar de Trabajo:</span>
            <span className="planilla-val">{padre.lugar_trabajo}</span>
          </div>

          <div className="planilla-field" style={{ width: '60%' }}>
            <span className="planilla-label">Dirección del Trabajo:</span>
            <span className="planilla-val">{padre.direccion_trabajo}</span>
          </div>
          <div className="planilla-field" style={{ width: '38%' }}>
            <span className="planilla-label">Teléfono del Trabajo:</span>
            <span className="planilla-val">{padre.telefono_trabajo}</span>
          </div>
        </div>

        {/* 3. DATOS DE LA MADRE */}
        <div className="planilla-section-bar">
          <div>
            <span>DATOS DE LA MADRE</span>
            {madre.es_representante && (
              <span className="planilla-badge-rep">[ REPRESENTANTE LEGAL ]</span>
            )}
          </div>
        </div>
        <div className="planilla-grid">
          <div className="planilla-field" style={{ width: '45%' }}>
            <span className="planilla-label">Apellidos:</span>
            <span className="planilla-val">{madre.apellidos}</span>
          </div>
          <div className="planilla-field" style={{ width: '33%' }}>
            <span className="planilla-label">Nombres:</span>
            <span className="planilla-val">{madre.nombres}</span>
          </div>
          <div className="planilla-field" style={{ width: '20%' }}>
            <span className="planilla-label">Cédula:</span>
            <span className="planilla-val">{madre.cedula}</span>
          </div>

          <div className="planilla-field" style={{ width: '98%' }}>
            <span className="planilla-label">Dirección de Habitación:</span>
            <span className="planilla-val">{madre.direccion}</span>
          </div>

          <div className="planilla-field" style={{ width: '30%' }}>
            <span className="planilla-label">Teléfono Fijo:</span>
            <span className="planilla-val">{madre.telefono_fijo}</span>
          </div>
          <div className="planilla-field" style={{ width: '32%' }}>
            <span className="planilla-label">Móvil:</span>
            <span className="planilla-val">{madre.telefono_movil}</span>
          </div>
          <div className="planilla-field" style={{ width: '36%' }}>
            <span className="planilla-label">Email:</span>
            <span className="planilla-val" style={{ textTransform: 'lowercase' }}>{madre.email}</span>
          </div>

          <div className="planilla-field" style={{ width: '45%' }}>
            <span className="planilla-label">Profesión:</span>
            <span className="planilla-val">{madre.profesion}</span>
          </div>
          <div className="planilla-field" style={{ width: '53%' }}>
            <span className="planilla-label">Lugar de Trabajo:</span>
            <span className="planilla-val">{madre.lugar_trabajo}</span>
          </div>

          <div className="planilla-field" style={{ width: '60%' }}>
            <span className="planilla-label">Dirección del Trabajo:</span>
            <span className="planilla-val">{madre.direccion_trabajo}</span>
          </div>
          <div className="planilla-field" style={{ width: '38%' }}>
            <span className="planilla-label">Teléfono del Trabajo:</span>
            <span className="planilla-val">{madre.telefono_trabajo}</span>
          </div>
        </div>

        {/* 4. DATOS DEL REPRESENTANTE LEGAL (SOLO SE MUESTRA SI ES UN TERCERO) */}
        {representante.es_tercero && (
          <>
            <div className="planilla-section-bar">
              <span>DATOS DEL REPRESENTANTE LEGAL ({representante.parentesco.toUpperCase()})</span>
            </div>
            <div className="planilla-grid">
              <div className="planilla-field" style={{ width: '45%' }}>
                <span className="planilla-label">Apellidos y Nombres:</span>
                <span className="planilla-val">{representante.nombre_completo}</span>
              </div>
              <div className="planilla-field" style={{ width: '30%' }}>
                <span className="planilla-label">Parentesco:</span>
                <span className="planilla-val">{representante.parentesco}</span>
              </div>
              <div className="planilla-field" style={{ width: '23%' }}>
                <span className="planilla-label">Cédula:</span>
                <span className="planilla-val">{representante.cedula}</span>
              </div>

              <div className="planilla-field" style={{ width: '98%' }}>
                <span className="planilla-label">Dirección de Habitación:</span>
                <span className="planilla-val">{representante.direccion}</span>
              </div>

              <div className="planilla-field" style={{ width: '30%' }}>
                <span className="planilla-label">Teléfono Fijo:</span>
                <span className="planilla-val">{representante.telefono_fijo}</span>
              </div>
              <div className="planilla-field" style={{ width: '32%' }}>
                <span className="planilla-label">Móvil:</span>
                <span className="planilla-val">{representante.telefono}</span>
              </div>
              <div className="planilla-field" style={{ width: '36%' }}>
                <span className="planilla-label">Email:</span>
                <span className="planilla-val" style={{ textTransform: 'lowercase' }}>{representante.email}</span>
              </div>

              <div className="planilla-field" style={{ width: '45%' }}>
                <span className="planilla-label">Profesión:</span>
                <span className="planilla-val">{representante.profesion}</span>
              </div>
              <div className="planilla-field" style={{ width: '53%' }}>
                <span className="planilla-label">Lugar de Trabajo:</span>
                <span className="planilla-val">{representante.lugar_trabajo}</span>
              </div>

              <div className="planilla-field" style={{ width: '60%' }}>
                <span className="planilla-label">Dirección del Trabajo:</span>
                <span className="planilla-val">{representante.direccion_trabajo}</span>
              </div>
              <div className="planilla-field" style={{ width: '38%' }}>
                <span className="planilla-label">Teléfono del Trabajo:</span>
                <span className="planilla-val">{representante.telefono_trabajo}</span>
              </div>
            </div>
          </>
        )}

        {/* Firmas */}
        <div className="planilla-signatures">
          <div className="planilla-sig-block">
            <div className="planilla-sig-line"></div>
            <div className="planilla-sig-label">Firma del(la) estudiante</div>
          </div>
          <div className="planilla-sig-block">
            <div className="planilla-sig-line"></div>
            <div className="planilla-sig-label">Firma del representante</div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="planilla-footer">
        {institucion.direccion}
      </div>
    </div>
  );
};

/**
 * HOJA 2: ACTA DE COMPROMISO DEL REPRESENTANTE (OFICIAL)
 */
export const ActaCompromisoRepresentanteSheet = ({ info }) => {
  const { estudiante, representante, institucion } = info;

  return (
    <div className="planilla-sheet acta-sheet">
      <div>
        {/* Encabezado */}
        <div className="planilla-header">
          <div className="planilla-header-logo-left">
            <img src={logoEndanza} alt="Logo Endanza" />
          </div>
          <div className="planilla-header-center">
            <p className="planilla-republica">República Bolivariana de Venezuela</p>
            <p className="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p className="planilla-escuela">Escuela Nacional de Danza</p>
            <p className="planilla-ciudad">San Cristóbal Táchira</p>
          </div>
          <div className="planilla-header-logo-right" style={{ visibility: 'hidden' }}>
            <img src={logoEndanza} alt="" />
          </div>
        </div>

        {/* Título */}
        <h3 className="acta-title">ACTA DE COMPROMISO DEL REPRESENTANTE</h3>

        {/* Texto Legal */}
        <div className="acta-body">
          <p>
            Yo, <strong>{representante.nombre_completo}</strong>, C.I. <strong>{representante.cedula}</strong>, representante del (la) estudiante <strong>{estudiante.nombres} {estudiante.apellidos}</strong>, C.I. <strong>{estudiante.cedula}</strong>, me comprometo a ayudar a mi representado (a) en todas las actividades, compromisos y acuerdos de convivencia establecidos en la Escuela Nacional de Danza Táchira, algunos de ellos son el porte del uniforme de manera correcta, el no uso de accesorios (zarcillos, pulseras, collares, anillos) ni esmaltado de uñas, el cumplimiento a cabalidad del horario de entrada y salida de clase establecido, asistir al llamado de la institución para tratar asuntos inherentes a mi representado.
          </p>
          <br />
          <p>
            Así mismo, me comprometo a orientarlo para que su comportamiento sea de respeto hacia sus compañeros y personal de la Institución. De no respetar lo descrito en esta acta, asumiré lo dispuesto en los acuerdos de convivencia escolar.
          </p>
        </div>

        {/* Fecha */}
        <div className="acta-date-row">
          <span>Fecha: <strong>{institucion.fecha_emision}</strong></span>
        </div>

        {/* Firma */}
        <div className="acta-signatures">
          <div className="acta-sig-block">
            <div className="acta-sig-line"></div>
            <div className="planilla-sig-label">Firma del representante</div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="planilla-footer">
        {institucion.direccion}
      </div>
    </div>
  );
};

/**
 * Formatea el grado de danza para mostrarlo en el Acta de Compromiso.
 * Ej: "PRE BALLET" → "PRE BALLET", "1ER GRADO" → "1ER GRADO"
 * Evita que se duplique la palabra "grado" en el texto del acta.
 */
const formatearGradoActa = (grado) => {
  if (!grado) return 'SIN ASIGNAR';
  const g = String(grado).trim().toUpperCase();
  // Si ya contiene "GRADO" no agregar nada extra
  // El texto del acta dice "estudiante del {grado}" así que solo retornamos el valor
  return g;
};

/**
 * HOJA 3: ACTA DE COMPROMISO DEL ESTUDIANTE (OFICIAL)
 */
export const ActaCompromisoEstudianteSheet = ({ info }) => {
  const { estudiante, institucion } = info;

  return (
    <div className="planilla-sheet acta-sheet">
      <div>
        {/* Encabezado */}
        <div className="planilla-header">
          <div className="planilla-header-logo-left">
            <img src={logoEndanza} alt="Logo Endanza" />
          </div>
          <div className="planilla-header-center">
            <p className="planilla-republica">República Bolivariana de Venezuela</p>
            <p className="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p className="planilla-escuela">Escuela Nacional de Danza</p>
            <p className="planilla-ciudad">San Cristóbal Táchira</p>
          </div>
          <div className="planilla-header-logo-right" style={{ visibility: 'hidden' }}>
            <img src={logoEndanza} alt="" />
          </div>
        </div>

        {/* Título */}
        <h3 className="acta-title">ACTA DE COMPROMISO DEL ESTUDIANTE</h3>

        {/* Texto Legal */}
        <div className="acta-body">
          <p>
            Yo, <strong>{estudiante.nombres} {estudiante.apellidos}</strong>, C.I. <strong>{estudiante.cedula}</strong>, estudiante del <strong>{formatearGradoActa(estudiante.grado)}</strong>, me comprometo a cumplir en todas las actividades, compromisos y acuerdos de convivencia establecidos en la Escuela Nacional de Danza Táchira, algunos de ellos son el porte del uniforme de manera correcta, el no uso de accesorios (zarcillos, pulseras, collares, anillos) ni esmaltado de uñas, asistir de manera constante a clases.
          </p>
          <br />
          <p>
            Así mismo, me comprometo a respetar a mis compañeros y personal de la Institución. De no respetarlo descrito en esta acta, asumiré lo dispuesto en los acuerdos de convivencia escolar.
          </p>
        </div>

        {/* Fecha */}
        <div className="acta-date-row">
          <span>Fecha: <strong>{institucion.fecha_emision}</strong></span>
        </div>

        {/* Firma */}
        <div className="acta-signatures">
          <div className="acta-sig-block">
            <div className="acta-sig-line"></div>
            <div className="planilla-sig-label">Firma del estudiante</div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="planilla-footer">
        {institucion.direccion}
      </div>
    </div>
  );
};

/**
 * HOJA 4: HISTORIA CLÍNICA NUTRICIONAL (OFICIAL)
 */
export const HistoriaClinicaNutricionalSheet = ({ info }) => {
  const { estudiante, salud, institucion } = info;

  return (
    <div className="planilla-sheet historia-sheet">
      <div>
        {/* Encabezado con ambos logos */}
        <div className="planilla-header">
          <div className="planilla-header-logo-left">
            <img src={logoMinisterio} alt="Logo Ministerio" />
          </div>
          <div className="planilla-header-center">
            <p className="planilla-republica">República Bolivariana de Venezuela</p>
            <p className="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p className="planilla-escuela">Escuela Nacional de Danza</p>
            <p className="planilla-ciudad">San Cristóbal Táchira</p>
            <h4 className="historia-title">HISTORIA CLÍNICA NUTRICIONAL</h4>
          </div>
          <div className="planilla-header-logo-right">
            <img src={logoEndanza} alt="Logo Endanza" />
          </div>
        </div>

        {/* Datos del estudiante */}
        <div className="historia-datos-basicos">
          <div style={{ fontWeight: 'bold', marginBottom: '3px', fontSize: '8.5pt' }}>
            Datos del(la) Estudiante:
          </div>
          <div className="planilla-grid">
            <div className="planilla-field" style={{ width: '48%' }}>
              <span className="planilla-label">Nombres:</span>
              <span className="planilla-val">{estudiante.nombres}</span>
            </div>
            <div className="planilla-field" style={{ width: '48%' }}>
              <span className="planilla-label">Apellidos:</span>
              <span className="planilla-val">{estudiante.apellidos}</span>
            </div>
            <div className="planilla-field" style={{ width: '98%' }}>
              <span className="planilla-label">Grado:</span>
              <span className="planilla-val">{estudiante.grado}</span>
            </div>

            <div className="planilla-field" style={{ width: '32%', marginTop: '4px' }}>
              <span className="planilla-label">Peso:</span>
              <span className="planilla-val">{salud.peso} kg</span>
            </div>
            <div className="planilla-field" style={{ width: '32%', marginTop: '4px' }}>
              <span className="planilla-label">Talla:</span>
              <span className="planilla-val">{salud.talla} m</span>
            </div>
            <div className="planilla-field" style={{ width: '32%', marginTop: '4px' }}>
              <span className="planilla-label">Edad:</span>
              <span className="planilla-val">{salud.edad}</span>
            </div>
          </div>
        </div>

        {/* Tabla de preguntas y respuestas clínicas */}
        <table className="historia-question-table">
          <tbody>
            <tr>
              <td className="historia-q-left">
                <strong>Su representada(o) refiere algún tipo de intolerancia alimentaria?:</strong> {salud.intolerancia}
              </td>
              <td className="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> {salud.intolerancia_exp || '—'}
              </td>
            </tr>

            <tr>
              <td className="historia-q-left">
                <strong>Refiere con cierta frecuencia dolores de cabeza (o) estomacales?:</strong> {salud.dolores_cabeza_estomago}
              </td>
              <td className="historia-q-right">
                <strong>Padece con cierta frecuencia de estreñimiento?:</strong> {salud.estrenimiento}
              </td>
            </tr>

            <tr>
              <td className="historia-q-left">
                <strong>Ha sido intervenida quirúrgicamente?:</strong> {salud.operaciones}
              </td>
              <td className="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> {salud.operaciones_exp || '—'}
              </td>
            </tr>

            <tr>
              <td className="historia-q-left">
                <strong>Toma algún tipo de tratamiento?:</strong> {salud.tratamiento}
              </td>
              <td className="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> {salud.tratamiento_exp || '—'}
              </td>
            </tr>

            <tr>
              <td className="historia-q-left">
                <strong>Ha tenido algún control hormonal?:</strong> {salud.control_hormonal}
              </td>
              <td className="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> {salud.control_hormonal_exp || '—'}
              </td>
            </tr>

            <tr>
              <td className="historia-q-left">
                <strong>Padece algún tipo de alergia?:</strong> {salud.alergias}
              </td>
              <td className="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> {salud.alergias_exp || '—'}
              </td>
            </tr>

            <tr>
              <td colSpan="2">
                <strong>Su nacimiento fue:</strong> {salud.nacimiento}
              </td>
            </tr>
          </tbody>
        </table>

        {/* Antecedentes Familiares */}
        <div className="historia-antecedentes-box">
          <strong>Antecedentes Familiares de algún tipo de padecimiento:</strong> tales como: Diabetes, Obesidad, Hipertensión, Híper (ó) Hipotiroidismo, cáncer, afecciones cardíacas por Padre, Madre ó Abuelos:
          <div style={{ marginTop: '4px', textTransform: 'uppercase', color: '#111' }}>
            {salud.antecedentes}
          </div>
        </div>
      </div>

      {/* Footer con lema institucional */}
      <div className="planilla-footer">
        <div className="planilla-lema">{institucion.lema}</div>
        <div>{institucion.direccion}</div>
      </div>
    </div>
  );
};

/**
 * Genera el documento HTML completo para impresión de las planillas
 */
export const generarHTMLCompleto = (info, modo = 'todas') => {
  const { estudiante, padre, madre, representante, salud, institucion } = info;

  const hoja1 = `
    <div class="planilla-sheet">
      <div>
        <div class="planilla-header">
          <div class="planilla-header-logo-left">
            <img src="${logoEndanza}" alt="Logo Endanza" />
          </div>
          <div class="planilla-header-center">
            <p class="planilla-republica">República Bolivariana de Venezuela</p>
            <p class="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p class="planilla-escuela">Escuela Nacional de Danza</p>
            <p class="planilla-ciudad">San Cristóbal Táchira</p>
            <h4 class="planilla-doc-title">FICHA DE INSCRIPCIÓN</h4>
            <p class="planilla-doc-subtitle">${institucion.periodo}</p>
          </div>
          <div class="planilla-photo-box">
            ${estudiante.foto ? `<img src="${estudiante.foto}" alt="Foto" />` : `<span>Foto del (la)<br>estudiante</span>`}
          </div>
        </div>

        <div class="planilla-section-bar">
          <span>DATOS DEL ESTUDIANTE</span>
        </div>
        <div class="planilla-grid">
          <div class="planilla-field" style="width: 48%;">
            <span class="planilla-label">Apellidos:</span>
            <span class="planilla-val">${estudiante.apellidos}</span>
          </div>
          <div class="planilla-field" style="width: 32%;">
            <span class="planilla-label">Nombres:</span>
            <span class="planilla-val">${estudiante.nombres}</span>
          </div>
          <div class="planilla-field" style="width: 18%;">
            <span class="planilla-label">Cédula:</span>
            <span class="planilla-val">${estudiante.cedula}</span>
          </div>

          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Fecha de Nacimiento:</span>
            <span class="planilla-val">${estudiante.fecha_nac}</span>
          </div>
          <div class="planilla-field" style="width: 68%;">
            <span class="planilla-label">Dirección de Habitación:</span>
            <span class="planilla-val">${estudiante.direccion_Habitacion}</span>
          </div>

          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Teléfono Fijo:</span>
            <span class="planilla-val">${estudiante.telefono_fijo}</span>
          </div>
          <div class="planilla-field" style="width: 32%;">
            <span class="planilla-label">Móvil:</span>
            <span class="planilla-val">${estudiante.telefono_movil}</span>
          </div>
          <div class="planilla-field" style="width: 36%;">
            <span class="planilla-label">Email:</span>
            <span class="planilla-val" style="text-transform: lowercase;">${estudiante.email}</span>
          </div>

          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Grado a Cursar:</span>
            <span class="planilla-val">${estudiante.grado}</span>
          </div>
          <div class="planilla-field" style="width: 34%;">
            <span class="planilla-label">Especialidad:</span>
            <span class="planilla-val">${estudiante.especialidad}</span>
          </div>
          <div class="planilla-field" style="width: 34%;">
            <span class="planilla-label">Asignatura(s) Pendiente(s):</span>
            <span class="planilla-val">${estudiante.asignaturas_pendientes}</span>
          </div>

          <div class="planilla-field" style="width: 38%;">
            <span class="planilla-label">Alérgico(a) a un medicamento?:</span>
            <span class="planilla-val">${estudiante.alergico_medicamento}</span>
          </div>
          <div class="planilla-field" style="width: 60%;">
            <span class="planilla-label">Explique:</span>
            <span class="planilla-val">${estudiante.alergico_explicacion || '—'}</span>
          </div>

          <div class="planilla-field" style="width: 38%;">
            <span class="planilla-label">Padece alguna enfermedad?:</span>
            <span class="planilla-val">${estudiante.enfermedad}</span>
          </div>
          <div class="planilla-field" style="width: 60%;">
            <span class="planilla-label">Explique:</span>
            <span class="planilla-val">${estudiante.enfermedad_explicacion || '—'}</span>
          </div>

          <div class="planilla-field" style="width: 98%;">
            <span class="planilla-label">Con quien convive:</span>
            <span class="planilla-val">${estudiante.convivencia}</span>
          </div>

          <div class="planilla-field" style="width: 68%;">
            <span class="planilla-label">Institución donde cursa estudios regulares:</span>
            <span class="planilla-val">${estudiante.escuela}</span>
          </div>
          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Año o Grado que cursa:</span>
            <span class="planilla-val">${estudiante.grado}</span>
          </div>

          <div class="planilla-field" style="width: 45%;">
            <span class="planilla-label">La estudiante posee seguro escolar:</span>
            <span class="planilla-val">${estudiante.seguro_escolar}</span>
          </div>
          <div class="planilla-field" style="width: 53%;">
            <span class="planilla-label">Cuál:</span>
            <span class="planilla-val">${estudiante.nombre_seguro || '—'}</span>
          </div>
        </div>

        <!-- DATOS DEL PADRE -->
        <div class="planilla-section-bar">
          <div>
            <span>DATOS DEL PADRE</span>
            ${padre.es_representante ? '<span class="planilla-badge-rep">[ REPRESENTANTE LEGAL ]</span>' : ''}
          </div>
        </div>
        <div class="planilla-grid">
          <div class="planilla-field" style="width: 45%;">
            <span class="planilla-label">Apellidos:</span>
            <span class="planilla-val">${padre.apellidos}</span>
          </div>
          <div class="planilla-field" style="width: 33%;">
            <span class="planilla-label">Nombres:</span>
            <span class="planilla-val">${padre.nombres}</span>
          </div>
          <div class="planilla-field" style="width: 20%;">
            <span class="planilla-label">Cédula:</span>
            <span class="planilla-val">${padre.cedula}</span>
          </div>

          <div class="planilla-field" style="width: 98%;">
            <span class="planilla-label">Dirección de Habitación:</span>
            <span class="planilla-val">${padre.direccion}</span>
          </div>

          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Teléfono Fijo:</span>
            <span class="planilla-val">${padre.telefono_fijo}</span>
          </div>
          <div class="planilla-field" style="width: 32%;">
            <span class="planilla-label">Móvil:</span>
            <span class="planilla-val">${padre.telefono_movil}</span>
          </div>
          <div class="planilla-field" style="width: 36%;">
            <span class="planilla-label">Email:</span>
            <span class="planilla-val" style="text-transform: lowercase;">${padre.email}</span>
          </div>

          <div class="planilla-field" style="width: 45%;">
            <span class="planilla-label">Profesión:</span>
            <span class="planilla-val">${padre.profesion}</span>
          </div>
          <div class="planilla-field" style="width: 53%;">
            <span class="planilla-label">Lugar de Trabajo:</span>
            <span class="planilla-val">${padre.lugar_trabajo}</span>
          </div>

          <div class="planilla-field" style="width: 60%;">
            <span class="planilla-label">Dirección del Trabajo:</span>
            <span class="planilla-val">${padre.direccion_trabajo}</span>
          </div>
          <div class="planilla-field" style="width: 38%;">
            <span class="planilla-label">Teléfono del Trabajo:</span>
            <span class="planilla-val">${padre.telefono_trabajo}</span>
          </div>
        </div>

        <!-- DATOS DE LA MADRE -->
        <div class="planilla-section-bar">
          <div>
            <span>DATOS DE LA MADRE</span>
            ${madre.es_representante ? '<span class="planilla-badge-rep">[ REPRESENTANTE LEGAL ]</span>' : ''}
          </div>
        </div>
        <div class="planilla-grid">
          <div class="planilla-field" style="width: 45%;">
            <span class="planilla-label">Apellidos:</span>
            <span class="planilla-val">${madre.apellidos}</span>
          </div>
          <div class="planilla-field" style="width: 33%;">
            <span class="planilla-label">Nombres:</span>
            <span class="planilla-val">${madre.nombres}</span>
          </div>
          <div class="planilla-field" style="width: 20%;">
            <span class="planilla-label">Cédula:</span>
            <span class="planilla-val">${madre.cedula}</span>
          </div>

          <div class="planilla-field" style="width: 98%;">
            <span class="planilla-label">Dirección de Habitación:</span>
            <span class="planilla-val">${madre.direccion}</span>
          </div>

          <div class="planilla-field" style="width: 30%;">
            <span class="planilla-label">Teléfono Fijo:</span>
            <span class="planilla-val">${madre.telefono_fijo}</span>
          </div>
          <div class="planilla-field" style="width: 32%;">
            <span class="planilla-label">Móvil:</span>
            <span class="planilla-val">${madre.telefono_movil}</span>
          </div>
          <div class="planilla-field" style="width: 36%;">
            <span class="planilla-label">Email:</span>
            <span class="planilla-val" style="text-transform: lowercase;">${madre.email}</span>
          </div>

          <div class="planilla-field" style="width: 45%;">
            <span class="planilla-label">Profesión:</span>
            <span class="planilla-val">${madre.profesion}</span>
          </div>
          <div class="planilla-field" style="width: 53%;">
            <span class="planilla-label">Lugar de Trabajo:</span>
            <span class="planilla-val">${madre.lugar_trabajo}</span>
          </div>

          <div class="planilla-field" style="width: 60%;">
            <span class="planilla-label">Dirección del Trabajo:</span>
            <span class="planilla-val">${madre.direccion_trabajo}</span>
          </div>
          <div class="planilla-field" style="width: 38%;">
            <span class="planilla-label">Teléfono del Trabajo:</span>
            <span class="planilla-val">${madre.telefono_trabajo}</span>
          </div>
        </div>

        <!-- DATOS DEL REPRESENTANTE LEGAL (SOLO SI ES TERCERO) -->
        ${representante.es_tercero ? `
          <div class="planilla-section-bar">
            <span>DATOS DEL REPRESENTANTE LEGAL (${representante.parentesco.toUpperCase()})</span>
          </div>
          <div class="planilla-grid">
            <div class="planilla-field" style="width: 45%;">
              <span class="planilla-label">Apellidos y Nombres:</span>
              <span class="planilla-val">${representante.nombre_completo}</span>
            </div>
            <div class="planilla-field" style="width: 30%;">
              <span class="planilla-label">Parentesco:</span>
              <span class="planilla-val">${representante.parentesco}</span>
            </div>
            <div class="planilla-field" style="width: 23%;">
              <span class="planilla-label">Cédula:</span>
              <span class="planilla-val">${representante.cedula}</span>
            </div>

            <div class="planilla-field" style="width: 98%;">
              <span class="planilla-label">Dirección de Habitación:</span>
              <span class="planilla-val">${representante.direccion}</span>
            </div>

            <div class="planilla-field" style="width: 30%;">
              <span class="planilla-label">Teléfono Fijo:</span>
              <span class="planilla-val">${representante.telefono_fijo}</span>
            </div>
            <div class="planilla-field" style="width: 32%;">
              <span class="planilla-label">Móvil:</span>
              <span class="planilla-val">${representante.telefono}</span>
            </div>
            <div class="planilla-field" style="width: 36%;">
              <span class="planilla-label">Email:</span>
              <span class="planilla-val" style="text-transform: lowercase;">${representante.email}</span>
            </div>

            <div class="planilla-field" style="width: 45%;">
              <span class="planilla-label">Profesión:</span>
              <span class="planilla-val">${representante.profesion}</span>
            </div>
            <div class="planilla-field" style="width: 53%;">
              <span class="planilla-label">Lugar de Trabajo:</span>
              <span class="planilla-val">${representante.lugar_trabajo}</span>
            </div>

            <div class="planilla-field" style="width: 60%;">
              <span class="planilla-label">Dirección del Trabajo:</span>
              <span class="planilla-val">${representante.direccion_trabajo}</span>
            </div>
            <div class="planilla-field" style="width: 38%;">
              <span class="planilla-label">Teléfono del Trabajo:</span>
              <span class="planilla-val">${representante.telefono_trabajo}</span>
            </div>
          </div>
        ` : ''}

        <!-- Firmas -->
        <div class="planilla-signatures">
          <div class="planilla-sig-block">
            <div class="planilla-sig-line"></div>
            <div class="planilla-sig-label">Firma del(la) estudiante</div>
          </div>
          <div class="planilla-sig-block">
            <div class="planilla-sig-line"></div>
            <div class="planilla-sig-label">Firma del representante</div>
          </div>
        </div>
      </div>

      <div class="planilla-footer">
        ${institucion.direccion}
      </div>
    </div>
  `;

  const hoja2 = `
    <div class="planilla-sheet acta-sheet">
      <div>
        <div class="planilla-header">
          <div class="planilla-header-logo-left">
            <img src="${logoEndanza}" alt="Logo Endanza" />
          </div>
          <div class="planilla-header-center">
            <p class="planilla-republica">República Bolivariana de Venezuela</p>
            <p class="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p class="planilla-escuela">Escuela Nacional de Danza</p>
            <p class="planilla-ciudad">San Cristóbal Táchira</p>
          </div>
          <div class="planilla-header-logo-right" style="visibility: hidden;">
            <img src="${logoEndanza}" alt="" />
          </div>
        </div>

        <h3 class="acta-title">ACTA DE COMPROMISO DEL REPRESENTANTE</h3>

        <div class="acta-body">
          <p>
            Yo, <strong>${representante.nombre_completo}</strong>, C.I. <strong>${representante.cedula}</strong>, representante del (la) estudiante <strong>${estudiante.nombres} ${estudiante.apellidos}</strong>, C.I. <strong>${estudiante.cedula}</strong>, me comprometo a ayudar a mi representado (a) en todas las actividades, compromisos y acuerdos de convivencia establecidos en la Escuela Nacional de Danza Táchira, algunos de ellos son el porte del uniforme de manera correcta, el no uso de accesorios (zarcillos, pulseras, collares, anillos) ni esmaltado de uñas, el cumplimiento a cabalidad del horario de entrada y salida de clase establecido, asistir al llamado de la institución para tratar asuntos inherentes a mi representado.
          </p>
          <br>
          <p>
            Así mismo, me comprometo a orientarlo para que su comportamiento sea de respeto hacia sus compañeros y personal de la Institución. De no respetar lo descrito en esta acta, asumiré lo dispuesto en los acuerdos de convivencia escolar.
          </p>
        </div>

        <div class="acta-date-row">
          <span>Fecha: <strong>${institucion.fecha_emision}</strong></span>
        </div>

        <div class="acta-signatures">
          <div class="acta-sig-block">
            <div class="acta-sig-line"></div>
            <div class="planilla-sig-label">Firma del representante</div>
          </div>
        </div>
      </div>

      <div class="planilla-footer">
        ${institucion.direccion}
      </div>
    </div>
  `;

  const hoja3 = `
    <div class="planilla-sheet acta-sheet">
      <div>
        <div class="planilla-header">
          <div class="planilla-header-logo-left">
            <img src="${logoEndanza}" alt="Logo Endanza" />
          </div>
          <div class="planilla-header-center">
            <p class="planilla-republica">República Bolivariana de Venezuela</p>
            <p class="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p class="planilla-escuela">Escuela Nacional de Danza</p>
            <p class="planilla-ciudad">San Cristóbal Táchira</p>
          </div>
          <div class="planilla-header-logo-right" style="visibility: hidden;">
            <img src="${logoEndanza}" alt="" />
          </div>
        </div>

        <h3 class="acta-title">ACTA DE COMPROMISO DEL ESTUDIANTE</h3>

        <div class="acta-body">
          <p>
            Yo, <strong>${estudiante.nombres} ${estudiante.apellidos}</strong>, C.I. <strong>${estudiante.cedula}</strong>, estudiante del <strong>${formatearGradoActa(estudiante.grado)}</strong>, me comprometo a cumplir en todas las actividades, compromisos y acuerdos de convivencia establecidos en la Escuela Nacional de Danza Táchira, algunos de ellos son el porte del uniforme de manera correcta, el no uso de accesorios (zarcillos, pulseras, collares, anillos) ni esmaltado de uñas, asistir de manera constante a clases.
          </p>
          <br>
          <p>
            Así mismo, me comprometo a respetar a mis compañeros y personal de la Institución. De no respetarlo descrito en esta acta, asumiré lo dispuesto en los acuerdos de convivencia escolar.
          </p>
        </div>

        <div class="acta-date-row">
          <span>Fecha: <strong>${institucion.fecha_emision}</strong></span>
        </div>

        <div class="acta-signatures">
          <div class="acta-sig-block">
            <div class="acta-sig-line"></div>
            <div class="planilla-sig-label">Firma del estudiante</div>
          </div>
        </div>
      </div>

      <div class="planilla-footer">
        ${institucion.direccion}
      </div>
    </div>
  `;

  const hoja4 = `
    <div class="planilla-sheet historia-sheet">
      <div>
        <div class="planilla-header">
          <div class="planilla-header-logo-left">
            <img src="${logoMinisterio}" alt="Logo Ministerio" />
          </div>
          <div class="planilla-header-center">
            <p class="planilla-republica">República Bolivariana de Venezuela</p>
            <p class="planilla-ministerio">Ministerio del Poder Popular para la Cultura</p>
            <p class="planilla-escuela">Escuela Nacional de Danza</p>
            <p class="planilla-ciudad">San Cristóbal Táchira</p>
            <h4 class="historia-title">HISTORIA CLÍNICA NUTRICIONAL</h4>
          </div>
          <div class="planilla-header-logo-right">
            <img src="${logoEndanza}" alt="Logo Endanza" />
          </div>
        </div>

        <div class="historia-datos-basicos">
          <div style="font-weight: bold; margin-bottom: 3px; font-size: 8.5pt;">
            Datos del(la) Estudiante:
          </div>
          <div class="planilla-grid">
            <div class="planilla-field" style="width: 48%;">
              <span class="planilla-label">Nombres:</span>
              <span class="planilla-val">${estudiante.nombres}</span>
            </div>
            <div class="planilla-field" style="width: 48%;">
              <span class="planilla-label">Apellidos:</span>
              <span class="planilla-val">${estudiante.apellidos}</span>
            </div>
            <div class="planilla-field" style="width: 98%;">
              <span class="planilla-label">Grado:</span>
              <span class="planilla-val">${estudiante.grado}</span>
            </div>

            <div class="planilla-field" style="width: 32%; margin-top: 4px;">
              <span class="planilla-label">Peso:</span>
              <span class="planilla-val">${salud.peso} kg</span>
            </div>
            <div class="planilla-field" style="width: 32%; margin-top: 4px;">
              <span class="planilla-label">Talla:</span>
              <span class="planilla-val">${salud.talla} m</span>
            </div>
            <div class="planilla-field" style="width: 32%; margin-top: 4px;">
              <span class="planilla-label">Edad:</span>
              <span class="planilla-val">${salud.edad}</span>
            </div>
          </div>
        </div>

        <table class="historia-question-table">
          <tbody>
            <tr>
              <td class="historia-q-left">
                <strong>Su representada(o) refiere algún tipo de intolerancia alimentaria?:</strong> ${salud.intolerancia}
              </td>
              <td class="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> ${salud.intolerancia_exp || '—'}
              </td>
            </tr>

            <tr>
              <td class="historia-q-left">
                <strong>Refiere con cierta frecuencia dolores de cabeza (o) estomacales?:</strong> ${salud.dolores_cabeza_estomago}
              </td>
              <td class="historia-q-right">
                <strong>Padece con cierta frecuencia de estreñimiento?:</strong> ${salud.estrenimiento}
              </td>
            </tr>

            <tr>
              <td class="historia-q-left">
                <strong>Ha sido intervenida quirúrgicamente?:</strong> ${salud.operaciones}
              </td>
              <td class="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> ${salud.operaciones_exp || '—'}
              </td>
            </tr>

            <tr>
              <td class="historia-q-left">
                <strong>Toma algún tipo de tratamiento?:</strong> ${salud.tratamiento}
              </td>
              <td class="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> ${salud.tratamiento_exp || '—'}
              </td>
            </tr>

            <tr>
              <td class="historia-q-left">
                <strong>Ha tenido algún control hormonal?:</strong> ${salud.control_hormonal}
              </td>
              <td class="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> ${salud.control_hormonal_exp || '—'}
              </td>
            </tr>

            <tr>
              <td class="historia-q-left">
                <strong>Padece algún tipo de alergia?:</strong> ${salud.alergias}
              </td>
              <td class="historia-q-right">
                <strong>Explique en caso de ser afirmativo:</strong> ${salud.alergias_exp || '—'}
              </td>
            </tr>

            <tr>
              <td colspan="2">
                <strong>Su nacimiento fue:</strong> ${salud.nacimiento}
              </td>
            </tr>
          </tbody>
        </table>

        <div class="historia-antecedentes-box">
          <strong>Antecedentes Familiares de algún tipo de padecimiento:</strong> tales como: Diabetes, Obesidad, Hipertensión, Híper (ó) Hipotiroidismo, cáncer, afecciones cardíacas por Padre, Madre ó Abuelos:
          <div style="margin-top: 4px; text-transform: uppercase; color: #111;">
            ${salud.antecedentes}
          </div>
        </div>
      </div>

      <div class="planilla-footer">
        <div class="planilla-lema">${institucion.lema}</div>
        <div>${institucion.direccion}</div>
      </div>
    </div>
  `;

  let bodyContent = '';
  if (modo === 'ficha') bodyContent = hoja1;
  else if (modo === 'acta_rep') bodyContent = hoja2;
  else if (modo === 'acta_est') bodyContent = hoja3;
  else if (modo === 'historia') bodyContent = hoja4;
  else bodyContent = `${hoja1}${hoja2}${hoja3}${hoja4}`;

  return `
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <title>Planillas Oficiales - ${estudiante.nombres} ${estudiante.apellidos}</title>
      <style>
        @page { size: letter portrait; margin: 6mm 8mm; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, "Helvetica Neue", Helvetica, sans-serif; color: #111; background: #fff; }
        .planilla-sheet {
          width: 216mm;
          min-height: 275mm;
          background-color: #fff;
          font-size: 8pt;
          line-height: 1.3;
          padding: 6mm 10mm 6mm 10mm;
          box-sizing: border-box;
          margin: 0 auto;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          page-break-after: always;
          break-after: page;
        }
        .planilla-sheet:last-child { page-break-after: avoid; break-after: avoid; }
        .planilla-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 4px; }
        .planilla-header-logo-left, .planilla-header-logo-right { width: 32mm; display: flex; align-items: center; }
        .planilla-header-logo-left img, .planilla-header-logo-right img { max-width: 100%; max-height: 20mm; object-fit: contain; }
        .planilla-header-center { flex: 1; text-align: center; padding: 0 5px; }
        .planilla-republica { font-size: 8pt; line-height: 1.15; }
        .planilla-ministerio { font-size: 7.5pt; line-height: 1.15; }
        .planilla-escuela { font-size: 8pt; font-weight: bold; line-height: 1.15; }
        .planilla-ciudad { font-size: 7.5pt; line-height: 1.15; }
        .planilla-doc-title { font-size: 9.5pt; font-weight: bold; text-transform: uppercase; margin-top: 3px; margin-bottom: 1px; letter-spacing: 0.5px; }
        .planilla-doc-subtitle { font-size: 9pt; font-weight: bold; }
        .planilla-photo-box { width: 25mm; height: 32mm; border: 1px solid #777; display: flex; align-items: center; justify-content: center; text-align: center; font-size: 6.5pt; color: #555; background: #fafafa; }
        .planilla-photo-box img { width: 100%; height: 100%; object-fit: cover; }
        .planilla-section-bar { background-color: #d1d5db; color: #111; font-size: 8pt; font-weight: bold; padding: 2.5px 6px; border: 1px solid #9ca3af; margin-top: 5px; margin-bottom: 3px; display: flex; justify-content: space-between; align-items: center; text-transform: uppercase; }
        .planilla-section-code { font-size: 7pt; }
        .planilla-badge-rep { background-color: #1f2937; color: #fff; padding: 1px 5px; border-radius: 3px; font-size: 6.5pt; margin-left: 6px; }
        .planilla-grid { display: flex; flex-wrap: wrap; row-gap: 2px; column-gap: 8px; margin-bottom: 2px; }
        .planilla-field { display: flex; align-items: baseline; gap: 3px; font-size: 7.5pt; line-height: 1.25; }
        .planilla-label { font-weight: bold; color: #111; white-space: nowrap; }
        .planilla-val { color: #111; text-transform: uppercase; word-break: break-word; }
        .planilla-signatures { display: flex; justify-content: space-around; margin-top: 14px; margin-bottom: 6px; }
        .planilla-sig-block { text-align: center; width: 55mm; }
        .planilla-sig-line { border-top: 1px solid #111; height: 1px; margin-bottom: 3px; margin-top: 28px; }
        .planilla-sig-label { font-size: 7.5pt; font-weight: bold; }
        .planilla-footer { border-top: 1px solid #d1d5db; padding-top: 3px; text-align: center; font-size: 7pt; color: #4b5563; margin-top: auto; }
        .planilla-lema { font-style: italic; font-size: 7.5pt; color: #374151; margin-bottom: 2px; }
        .acta-sheet { padding: 16mm 20mm 12mm 20mm; }
        .acta-title { text-align: center; font-size: 13pt; font-weight: bold; text-transform: uppercase; margin-top: 35px; margin-bottom: 45px; }
        .acta-body { font-size: 10pt; line-height: 2; text-align: justify; }
        .acta-date-row { display: flex; justify-content: flex-end; margin-top: 45px; margin-bottom: 45px; font-size: 9.5pt; }
        .acta-signatures { display: flex; justify-content: center; margin-top: 20px; margin-bottom: 40px; }
        .acta-sig-block { text-align: center; width: 70mm; }
        .acta-sig-line { border-top: 1px solid #111; height: 1px; margin-bottom: 4px; }
        .historia-sheet { padding: 8mm 12mm 6mm 12mm; }
        .historia-title { text-align: center; font-size: 11pt; font-weight: bold; text-transform: uppercase; margin-top: 6px; margin-bottom: 12px; }
        .historia-datos-basicos { margin-bottom: 12px; border-bottom: 1px solid #e5e7eb; padding-bottom: 8px; }
        .historia-question-table { width: 100%; border-collapse: collapse; font-size: 7.8pt; line-height: 1.35; }
        .historia-question-table td { padding: 4px 6px; vertical-align: top; }
        .historia-q-left { width: 52%; }
        .historia-q-right { width: 48%; }
        .historia-antecedentes-box { margin-top: 8px; padding: 6px 8px; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 4px; font-size: 7.8pt; line-height: 1.35; }
        @media print {
          @page { size: letter portrait; margin: 6mm 8mm; }
          body { background: transparent !important; }
          .planilla-sheet {
            width: 100% !important;
            padding: 5mm 6mm !important;
            box-shadow: none !important;
            border: none !important;
            page-break-after: always !important;
            break-after: page !important;
          }
          .planilla-sheet:last-child {
            page-break-after: avoid !important;
            break-after: avoid !important;
          }
        }
      </style>
    </head>
    <body>
      ${bodyContent}
    </body>
    </html>
  `;
};

/**
 * Abre ventana de impresión con las 4 planillas
 */
export const imprimirPlanillasDirecto = (info, modo = 'todas') => {
  const html = generarHTMLCompleto(info, modo);
  const printWindow = window.open('', '_blank', 'width=950,height=850');

  if (printWindow) {
    printWindow.document.open();
    printWindow.document.write(html);
    printWindow.document.close();
    printWindow.focus();
    setTimeout(() => {
      printWindow.print();
    }, 450);
  } else {
    const iframe = document.createElement('iframe');
    iframe.style.position = 'fixed';
    iframe.style.right = '0';
    iframe.style.bottom = '0';
    iframe.style.width = '0';
    iframe.style.height = '0';
    iframe.style.border = '0';
    document.body.appendChild(iframe);
    iframe.contentWindow.document.open();
    iframe.contentWindow.document.write(html);
    iframe.contentWindow.document.close();
    setTimeout(() => {
      iframe.contentWindow.focus();
      iframe.contentWindow.print();
      setTimeout(() => {
        try { document.body.removeChild(iframe); } catch (e) {}
      }, 2000);
    }, 450);
  }
};

/**
 * Descarga las planillas directamente en formato PDF (hoja por hoja en tamaño Carta)
 */
export const descargarPlanillasPDF = async (sheetsElements, info, modo = 'todas') => {
  const elements = Array.isArray(sheetsElements) ? sheetsElements : Array.from(sheetsElements || []);
  if (!elements || elements.length === 0) {
    throw new Error('No se encontraron hojas para exportar');
  }

  const pdf = new jsPDF({
    orientation: 'portrait',
    unit: 'mm',
    format: 'letter'
  });

  const pdfWidth = 216;
  const pdfHeight = 279.4;

  for (let i = 0; i < elements.length; i++) {
    const sheetEl = elements[i];
    if (!sheetEl) continue;

    const canvas = await html2canvas(sheetEl, {
      scale: 2,
      useCORS: true,
      allowTaint: true,
      backgroundColor: '#ffffff',
      logging: false,
      windowWidth: 1200
    });

    const imgData = canvas.toDataURL('image/jpeg', 0.95);
    if (i > 0) {
      pdf.addPage('letter', 'portrait');
    }
    pdf.addImage(imgData, 'JPEG', 0, 0, pdfWidth, pdfHeight);
  }

  const est = info?.estudiante || {};
  const nombreClean = `${est.nombres || 'Estudiante'}_${est.apellidos || ''}`.trim().replace(/\s+/g, '_');

  let prefix = 'Planillas_Inscripcion_ENDANZA';
  if (modo === 'ficha') prefix = '1_Ficha_Inscripcion_ENDANZA';
  else if (modo === 'acta_rep') prefix = '2_Acta_Compromiso_Representante';
  else if (modo === 'acta_est') prefix = '3_Acta_Compromiso_Estudiante';
  else if (modo === 'historia') prefix = '4_Historia_Clinica_Nutricional';

  const fileName = `${prefix}_${nombreClean}.pdf`;
  pdf.save(fileName);
  return true;
};
