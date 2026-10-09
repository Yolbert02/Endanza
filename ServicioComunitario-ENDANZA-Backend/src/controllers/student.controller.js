import { StudentModel } from "../models/student.model.js";
import { RepresentanteModel } from "../models/representante.model.js"; // 👈 IMPORTANTE
import { ConfigModel } from "../models/config.model.js";
import { db } from "../db/connection.database.js"; // Solo si otros métodos lo necesitan

// ============================================
// CONTROLADOR DE ESTUDIANTES
// ============================================

/**
 * Listar todos los estudiantes
 */
const listStudents = async (req, res) => {
  try {
    const { academicYearId, sectionId } = req.query;
    console.log(`🔍 listStudents request - academicYearId: ${academicYearId}, sectionId: ${sectionId}`);

    const students = await StudentModel.findAll({
      academicYearId: academicYearId ? parseInt(academicYearId) : null,
      sectionId: sectionId ? parseInt(sectionId) : null
    });

    console.log(`✅ listStudents result - found ${students.length} raw students`);

    // Transformar al formato esperado por el frontend
    const transformed = students.map(s => ({
      id: s.id,
      first_name: s.first_name,
      last_name: s.last_name,
      full_name: `${s.first_name} ${s.last_name}`.trim(),
      dni: s.dni,
      birth_date: s.birth_date,
      gender: s.gender,
      grade_level: s.grade_level_name,
      dance_level: s.dance_level_name,
      school: s.school_name,
      insurance: s.insurance_name,
      representative: s.representative_first_name ?
        `${s.representative_first_name} ${s.representative_last_name}`.trim() : null,
      representative_id: s.representative_id,
      representative_dni: s.representative_dni,
      representative_user_id: s.representative_user_id,
      representative_phone: s.representative_phone,
      representative_email: s.representative_email,
      status: 'active', // Por defecto todos activos si están en la base de datos
      sections: s.sections || []
    }));

    return res.json({
      ok: true,
      data: transformed,
      total: transformed.length
    });
  } catch (error) {
    console.error("Error en listStudents:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al listar estudiantes",
      error: error.message
    });
  }
};

const formatStudentPayload = (student, sections = [], currentYear = null) => {
  let s1Nombre = (student.first_name || '').trim();
  let s2Nombre = (student.segundo_nombre || student.middle_name || student.second_name || '').trim();
  if (s1Nombre.includes(' ') && !s2Nombre) {
    const parts = s1Nombre.split(/\s+/);
    s1Nombre = parts[0];
    s2Nombre = parts.slice(1).join(' ');
  }

  let s1Apellido = (student.last_name || '').trim();
  let s2Apellido = (student.segundo_apellido || student.second_last_name || '').trim();
  if (s1Apellido.includes(' ') && !s2Apellido) {
    const parts = s1Apellido.split(/\s+/);
    s1Apellido = parts[0];
    s2Apellido = parts.slice(1).join(' ');
  }

  const studentFullName = `${s1Nombre} ${s2Nombre ? s2Nombre + ' ' : ''}${s1Apellido} ${s2Apellido || ''}`.trim() || student.full_name || `${s1Nombre} ${s1Apellido}`.trim();

  let rep1Nombre = (student.representative_first_name || '').trim();
  let rep2Nombre = (student.representative_second_name || student.representative_segundo_nombre || '').trim();
  if (rep1Nombre.includes(' ') && !rep2Nombre) {
    const parts = rep1Nombre.split(/\s+/);
    rep1Nombre = parts[0];
    rep2Nombre = parts.slice(1).join(' ');
  }

  let rep1Apellido = (student.representative_last_name || '').trim();
  let rep2Apellido = (student.representative_second_last_name || student.representative_segundo_apellido || '').trim();
  if (rep1Apellido.includes(' ') && !rep2Apellido) {
    const parts = rep1Apellido.split(/\s+/);
    rep1Apellido = parts[0];
    rep2Apellido = parts.slice(1).join(' ');
  }

  const repFullName = `${rep1Nombre} ${rep2Nombre ? rep2Nombre + ' ' : ''}${rep1Apellido} ${rep2Apellido || ''}`.trim() || null;

  const activeYear = (sections && sections.length > 0 && sections[0].academic_year_name) || currentYear || '2025-2026';

  return {
    id: student.id,
    first_name: s1Nombre,
    middle_name: s2Nombre,
    segundo_nombre: s2Nombre,
    last_name: s1Apellido,
    second_last_name: s2Apellido,
    segundo_apellido: s2Apellido,
    full_name: studentFullName,
    EstudiantePrimerNombre: s1Nombre,
    EstudianteSegundoNombre: s2Nombre,
    EstudiantePrimerApellido: s1Apellido,
    EstudianteSegundoApellido: s2Apellido,
    NombreEstudiante: `${s1Nombre} ${s2Nombre}`.trim(),
    ApellidoEstudiante: `${s1Apellido} ${s2Apellido}`.trim(),
    dni: student.dni,
    birth_date: student.birth_date,
    gender: student.gender,
    school_insurance: student.school_insurance,
    grade_level_id: student.grade_level_id,
    grade_level_name: student.grade_level_name,
    school_grade: student.grade_level_name,
    grade_level: student.dance_level_name || 'Sin Asignar',
    dance_level_id: student.dance_level_id,
    dance_level_name: student.dance_level_name,
    dance_level: student.dance_level_name,
    Grado: student.dance_level_name || 'Sin Asignar',
    current_academic_year: activeYear,
    academic_year: activeYear,
    school_id: student.school_id,
    school_name: student.school_name,
    insurance_id: student.insurance_id,
    insurance_name: student.insurance_name,
    representative_id: student.representative_id,
    representative: repFullName,
    representative_first_name: rep1Nombre,
    representative_second_name: rep2Nombre,
    representative_last_name: rep1Apellido,
    representative_second_last_name: rep2Apellido,
    representative_dni: student.representative_dni,
    representative_phone: student.representative_phone,
    representative_email: student.representative_email,
    representative_gender: student.representative_gender,
    representative_occupation: student.representative_occupation || student.profesion || null,
    representative_workplace: student.representative_workplace || student.lugar_trabajo || null,
    representative_work_address: student.representative_work_address || student.direccion_trabajo || null,
    representative_work_phone: student.representative_work_phone || student.telefono_trabajo || null,
    profesion_Rep: student.representative_occupation || student.profesion || null,
    trabajo_Rep: student.representative_workplace || student.lugar_trabajo || null,
    direccion_Trabajo_Rep: student.representative_work_address || student.direccion_trabajo || null,
    telefono_trabajo_Rep: student.representative_work_phone || student.telefono_trabajo || null,
    representative_es_familiar: student.representative_es_familiar,
    representative_relationship: student.representative_relationship || 'Madre',
    parentesco: student.representative_relationship || 'Madre',
    RepresentanteParentesco: student.representative_relationship || 'Madre',
    RepresentanteCedula: student.representative_dni,
    RepresentanteNombre: repFullName,
    RepresentanteApellido: rep1Apellido,
    RepresentantePrimerNombre: rep1Nombre,
    RepresentanteSegundoNombre: rep2Nombre,
    RepresentantePrimerApellido: rep1Apellido,
    RepresentanteSegundoApellido: rep2Apellido,
    RepresentanteTelefono: student.representative_phone,
    RepresentanteEmail: student.representative_email,
    RepresentanteOcupacion: student.representative_occupation || student.profesion || null,
    RepresentanteLugarTrabajo: student.representative_workplace || student.lugar_trabajo || null,
    RepresentanteDireccionTrabajo: student.representative_work_address || student.direccion_trabajo || null,
    RepresentanteTelefonoTrabajo: student.representative_work_phone || student.telefono_trabajo || null,
    // Si el representante es Madre, proveer campos precargados
    MadrePrimerNombre: student.representative_relationship === 'Madre' ? rep1Nombre : null,
    MadreSegundoNombre: student.representative_relationship === 'Madre' ? rep2Nombre : null,
    MadrePrimerApellido: student.representative_relationship === 'Madre' ? rep1Apellido : null,
    MadreSegundoApellido: student.representative_relationship === 'Madre' ? rep2Apellido : null,
    MadreNombre: student.representative_relationship === 'Madre' ? `${rep1Nombre} ${rep2Nombre}`.trim() : null,
    MadreApellido: student.representative_relationship === 'Madre' ? `${rep1Apellido} ${rep2Apellido}`.trim() : null,
    MadreNombreCompleto: student.representative_relationship === 'Madre' ? repFullName : null,
    MadreCedula: student.representative_relationship === 'Madre' ? student.representative_dni : null,
    MadreTelefono: student.representative_relationship === 'Madre' ? student.representative_phone : null,
    MadreOcupacion: student.MadreOcupacion || (student.representative_relationship === 'Madre' ? (student.representative_occupation || student.profesion) : null),
    MadreLugarTrabajo: student.representative_relationship === 'Madre' ? (student.representative_workplace || student.lugar_trabajo) : null,
    MadreDireccionTrabajo: student.representative_relationship === 'Madre' ? (student.representative_work_address || student.direccion_trabajo) : null,
    MadreTelefonoTrabajo: student.representative_relationship === 'Madre' ? (student.representative_work_phone || student.telefono_trabajo) : null,
    ocupacion_Madre: student.MadreOcupacion || (student.representative_relationship === 'Madre' ? (student.representative_occupation || student.profesion) : null),
    trabajo_Madre: student.representative_relationship === 'Madre' ? (student.representative_workplace || student.lugar_trabajo) : null,
    direccion_Trabajo_Madre: student.representative_relationship === 'Madre' ? (student.representative_work_address || student.direccion_trabajo) : null,
    telefono_trabajo_Madre: student.representative_relationship === 'Madre' ? (student.representative_work_phone || student.telefono_trabajo) : null,
    // Si el representante es Padre, proveer campos precargados
    PadrePrimerNombre: student.representative_relationship === 'Padre' ? rep1Nombre : null,
    PadreSegundoNombre: student.representative_relationship === 'Padre' ? rep2Nombre : null,
    PadrePrimerApellido: student.representative_relationship === 'Padre' ? rep1Apellido : null,
    PadreSegundoApellido: student.representative_relationship === 'Padre' ? rep2Apellido : null,
    PadreNombre: student.representative_relationship === 'Padre' ? `${rep1Nombre} ${rep2Nombre}`.trim() : null,
    PadreApellido: student.representative_relationship === 'Padre' ? `${rep1Apellido} ${rep2Apellido}`.trim() : null,
    PadreNombreCompleto: student.representative_relationship === 'Padre' ? repFullName : null,
    PadreCedula: student.representative_relationship === 'Padre' ? student.representative_dni : null,
    PadreTelefono: student.representative_relationship === 'Padre' ? student.representative_phone : null,
    PadreEmail: student.representative_relationship === 'Padre' ? student.representative_email : null,
    PadreOcupacion: student.PadreOcupacion || (student.representative_relationship === 'Padre' ? (student.representative_occupation || student.profesion) : null),
    PadreLugarTrabajo: student.representative_relationship === 'Padre' ? (student.representative_workplace || student.lugar_trabajo) : null,
    PadreDireccionTrabajo: student.representative_relationship === 'Padre' ? (student.representative_work_address || student.direccion_trabajo) : null,
    PadreTelefonoTrabajo: student.representative_relationship === 'Padre' ? (student.representative_work_phone || student.telefono_trabajo) : null,
    ocupacion_Padre: student.PadreOcupacion || (student.representative_relationship === 'Padre' ? (student.representative_occupation || student.profesion) : null),
    trabajo_Padre: student.representative_relationship === 'Padre' ? (student.representative_workplace || student.lugar_trabajo) : null,
    direccion_Trabajo_Padre: student.representative_relationship === 'Padre' ? (student.representative_work_address || student.direccion_trabajo) : null,
    telefono_trabajo_Padre: student.representative_relationship === 'Padre' ? (student.representative_work_phone || student.telefono_trabajo) : null,
    address: student.address,
    city: student.city,
    state: student.state,
    status: student.status || 'Activo',
    estatus: student.status || 'Activo',
    blood_type: student.blood_type || null,
    tipo_sangre: student.blood_type || null,
    TipoSangre: student.blood_type || null,
    NutricionPeso: student.peso_kg ? `${student.peso_kg} kg` : (student.NutricionPeso || null),
    NutricionAltura: student.altura_m ? `${student.altura_m} m` : (student.NutricionAltura || null),
    Alergias: student.tiene_alergias ? (student.descripcion_alergias || 'Sí') : (student.Alergias || 'Ninguna'),
    Operaciones: student.tiene_cirugia ? (student.descripcion_cirugia || 'Sí') : (student.Operaciones || 'Ninguna'),
    phone: student.representative_phone || null,
    email: student.representative_email || null,
    medical_history_id: student.medical_history_id,
    sections: (sections || []).map(s => ({
      id: s.id,
      section_id: s.section_id,
      section_name: s.section_name,
      academic_year: s.academic_year_name,
      period: s.period_name
    }))
  };
};

/**
 * Enriquecer el payload del estudiante con la información detallada de familiares (Madre y Padre)
 */
const enrichStudentWithFamiliares = async (transformed, studentId) => {
  try {
    const familiaresRes = await db.query(`
      SELECT ef.parentesco, ef.es_representante_legal, ef.vive_con_estudiante,
             COALESCE(ef.ocupacion, p.ocupacion) as ocupacion,
             ef.lugar_trabajo, ef.direccion_trabajo, ef.telefono_trabajo,
             p.nombre, p.segundo_nombre, p.apellido, p.segundo_apellido,
             p.cedula, p.numero_telefono, p.email, p.genero
      FROM estudiante_familiar ef
      JOIN persona p ON ef.id_persona = p.id_persona
      WHERE ef.id_estudiante = $1
      ORDER BY ef.id_estudiante_familiar ASC
    `, [studentId]);

    const madreRow = familiaresRes.rows.find(r => r.parentesco === 'Madre');
    const padreRow = familiaresRes.rows.find(r => r.parentesco === 'Padre');

    if (madreRow) {
      const m1 = madreRow.nombre || '';
      const m2 = madreRow.segundo_nombre || '';
      const ma1 = madreRow.apellido || '';
      const ma2 = madreRow.segundo_apellido || '';
      const nombresM = `${m1} ${m2}`.trim();
      const apellidosM = `${ma1} ${ma2}`.trim();
      transformed.MadreNombre = nombresM || transformed.MadreNombre;
      transformed.MadreApellido = apellidosM || transformed.MadreApellido;
      transformed.MadreNombreCompleto = `${m1} ${m2 ? m2 + ' ' : ''}${ma1} ${ma2 || ''}`.trim() || transformed.MadreNombreCompleto;
      transformed.MadrePrimerNombre = m1 || transformed.MadrePrimerNombre;
      transformed.MadreSegundoNombre = m2 || transformed.MadreSegundoNombre;
      transformed.MadrePrimerApellido = ma1 || transformed.MadrePrimerApellido;
      transformed.MadreSegundoApellido = ma2 || transformed.MadreSegundoApellido;
      transformed.MadreCedula = madreRow.cedula || transformed.MadreCedula;
      transformed.MadreTelefono = madreRow.numero_telefono || transformed.MadreTelefono;
      transformed.MadreEmail = madreRow.email || transformed.MadreEmail;
      transformed.MadreOcupacion = madreRow.ocupacion || transformed.MadreOcupacion || '';
      transformed.ocupacion_Madre = transformed.MadreOcupacion;
      transformed.MadreLugarTrabajo = madreRow.lugar_trabajo || transformed.MadreLugarTrabajo || '';
      transformed.trabajo_Madre = transformed.MadreLugarTrabajo;
      transformed.MadreDireccionTrabajo = madreRow.direccion_trabajo || transformed.MadreDireccionTrabajo || '';
      transformed.direccion_Trabajo_Madre = transformed.MadreDireccionTrabajo;
      transformed.MadreTelefonoTrabajo = madreRow.telefono_trabajo || transformed.MadreTelefonoTrabajo || '';
      transformed.telefono_trabajo_Madre = transformed.MadreTelefonoTrabajo;
    }

    if (padreRow) {
      const p1 = padreRow.nombre || '';
      const p2 = padreRow.segundo_nombre || '';
      const pa1 = padreRow.apellido || '';
      const pa2 = padreRow.segundo_apellido || '';
      const nombresP = `${p1} ${p2}`.trim();
      const apellidosP = `${pa1} ${pa2}`.trim();
      transformed.PadreNombre = nombresP || transformed.PadreNombre;
      transformed.PadreApellido = apellidosP || transformed.PadreApellido;
      transformed.PadreNombreCompleto = `${p1} ${p2 ? p2 + ' ' : ''}${pa1} ${pa2 || ''}`.trim() || transformed.PadreNombreCompleto;
      transformed.PadrePrimerNombre = p1 || transformed.PadrePrimerNombre;
      transformed.PadreSegundoNombre = p2 || transformed.PadreSegundoNombre;
      transformed.PadrePrimerApellido = pa1 || transformed.PadrePrimerApellido;
      transformed.PadreSegundoApellido = pa2 || transformed.PadreSegundoApellido;
      transformed.PadreCedula = padreRow.cedula || transformed.PadreCedula;
      transformed.PadreTelefono = padreRow.numero_telefono || transformed.PadreTelefono;
      transformed.PadreEmail = padreRow.email || transformed.PadreEmail;
      transformed.PadreOcupacion = padreRow.ocupacion || transformed.PadreOcupacion || '';
      transformed.ocupacion_Padre = transformed.PadreOcupacion;
      transformed.PadreLugarTrabajo = padreRow.lugar_trabajo || transformed.PadreLugarTrabajo || '';
      transformed.trabajo_Padre = transformed.PadreLugarTrabajo;
      transformed.PadreDireccionTrabajo = padreRow.direccion_trabajo || transformed.PadreDireccionTrabajo || '';
      transformed.direccion_Trabajo_Padre = transformed.PadreDireccionTrabajo;
      transformed.PadreTelefonoTrabajo = padreRow.telefono_trabajo || transformed.PadreTelefonoTrabajo || '';
      transformed.telefono_trabajo_Padre = transformed.PadreTelefonoTrabajo;
    }

    if (transformed.RepresentanteParentesco === 'Madre') {
      if (!transformed.representative_occupation && transformed.MadreOcupacion) {
        transformed.representative_occupation = transformed.MadreOcupacion;
        transformed.RepresentanteOcupacion = transformed.MadreOcupacion;
        transformed.profesion_Rep = transformed.MadreOcupacion;
      }
      if (!transformed.representative_workplace && transformed.MadreLugarTrabajo) {
        transformed.representative_workplace = transformed.MadreLugarTrabajo;
        transformed.RepresentanteLugarTrabajo = transformed.MadreLugarTrabajo;
        transformed.trabajo_Rep = transformed.MadreLugarTrabajo;
      }
      if (!transformed.representative_work_address && transformed.MadreDireccionTrabajo) {
        transformed.representative_work_address = transformed.MadreDireccionTrabajo;
        transformed.RepresentanteDireccionTrabajo = transformed.MadreDireccionTrabajo;
        transformed.direccion_Trabajo_Rep = transformed.MadreDireccionTrabajo;
      }
      if (!transformed.representative_work_phone && transformed.MadreTelefonoTrabajo) {
        transformed.representative_work_phone = transformed.MadreTelefonoTrabajo;
        transformed.RepresentanteTelefonoTrabajo = transformed.MadreTelefonoTrabajo;
        transformed.telefono_trabajo_Rep = transformed.MadreTelefonoTrabajo;
      }
      // Y si el representante tiene datos de trabajo pero la madre no los tenía en estudiante_familiar:
      if (!transformed.MadreDireccionTrabajo && transformed.representative_work_address) {
        transformed.MadreDireccionTrabajo = transformed.representative_work_address;
        transformed.direccion_Trabajo_Madre = transformed.representative_work_address;
      }
      if (!transformed.MadreLugarTrabajo && transformed.representative_workplace) {
        transformed.MadreLugarTrabajo = transformed.representative_workplace;
        transformed.trabajo_Madre = transformed.representative_workplace;
      }
      if (!transformed.MadreTelefonoTrabajo && transformed.representative_work_phone) {
        transformed.MadreTelefonoTrabajo = transformed.representative_work_phone;
        transformed.telefono_trabajo_Madre = transformed.representative_work_phone;
      }
    } else if (transformed.RepresentanteParentesco === 'Padre') {
      if (!transformed.representative_occupation && transformed.PadreOcupacion) {
        transformed.representative_occupation = transformed.PadreOcupacion;
        transformed.RepresentanteOcupacion = transformed.PadreOcupacion;
        transformed.profesion_Rep = transformed.PadreOcupacion;
      }
      if (!transformed.representative_workplace && transformed.PadreLugarTrabajo) {
        transformed.representative_workplace = transformed.PadreLugarTrabajo;
        transformed.RepresentanteLugarTrabajo = transformed.PadreLugarTrabajo;
        transformed.trabajo_Rep = transformed.PadreLugarTrabajo;
      }
      if (!transformed.representative_work_address && transformed.PadreDireccionTrabajo) {
        transformed.representative_work_address = transformed.PadreDireccionTrabajo;
        transformed.RepresentanteDireccionTrabajo = transformed.PadreDireccionTrabajo;
        transformed.direccion_Trabajo_Rep = transformed.PadreDireccionTrabajo;
      }
      if (!transformed.representative_work_phone && transformed.PadreTelefonoTrabajo) {
        transformed.representative_work_phone = transformed.PadreTelefonoTrabajo;
        transformed.RepresentanteTelefonoTrabajo = transformed.PadreTelefonoTrabajo;
        transformed.telefono_trabajo_Rep = transformed.PadreTelefonoTrabajo;
      }
      if (!transformed.PadreDireccionTrabajo && transformed.representative_work_address) {
        transformed.PadreDireccionTrabajo = transformed.representative_work_address;
        transformed.direccion_Trabajo_Padre = transformed.representative_work_address;
      }
      if (!transformed.PadreLugarTrabajo && transformed.representative_workplace) {
        transformed.PadreLugarTrabajo = transformed.representative_workplace;
        transformed.trabajo_Padre = transformed.representative_workplace;
      }
      if (!transformed.PadreTelefonoTrabajo && transformed.representative_work_phone) {
        transformed.PadreTelefonoTrabajo = transformed.representative_work_phone;
        transformed.telefono_trabajo_Padre = transformed.representative_work_phone;
      }
    }
  } catch (famErr) {
    console.warn("⚠️ No se pudieron obtener familiares:", famErr.message);
  }
  return transformed;
};

/**
 * Obtener un estudiante por ID
 */
const getStudent = async (req, res) => {
  try {
    const { id } = req.params;

    const student = await StudentModel.findById(id);

    if (!student) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    // Obtener las secciones del estudiante
    const sections = await StudentModel.findSectionsByStudentId(id);

    // Obtener período/año escolar actual desde la BD
    let currentAcademicYear = '2025-2026';
    try {
      const yearRes = await db.query(
        "SELECT nombre_ano FROM ano_academico WHERE estado_ano = 'en_curso' LIMIT 1"
      );
      if (yearRes.rows.length > 0) {
        currentAcademicYear = yearRes.rows[0].nombre_ano;
      }
    } catch (e) {
      console.warn("No se pudo obtener el año académico activo:", e.message);
    }

    const transformed = formatStudentPayload(student, sections, currentAcademicYear);
    await enrichStudentWithFamiliares(transformed, id);

    return res.json({
      ok: true,
      data: transformed
    });
  } catch (error) {
    console.error("Error en getStudent:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener estudiante",
      error: error.message
    });
  }
};

/**
 * Crear un nuevo estudiante
 */
const createStudent = async (req, res) => {
  try {
    const studentData = req.body;

    // Validar campos obligatorios
    if (!studentData.nombre || !studentData.apellido || !studentData.cedula || !studentData.fecha_nacimiento) {
      return res.status(400).json({
        ok: false,
        msg: "Faltan campos obligatorios: nombre, apellido, cédula, fecha de nacimiento"
      });
    }

    // Verificar si la cédula ya existe
    const exists = await StudentModel.existsByCedula(studentData.cedula);
    if (exists) {
      return res.status(400).json({
        ok: false,
        msg: "La cédula ya está registrada para otro estudiante"
      });
    }

    const newStudent = await StudentModel.create(studentData);

    return res.status(201).json({
      ok: true,
      msg: "Estudiante creado exitosamente",
      data: newStudent
    });
  } catch (error) {
    console.error("Error en createStudent:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al crear estudiante",
      error: error.message
    });
  }
};

/**
 * Actualizar un estudiante
 */
const updateStudent = async (req, res) => {
  try {
    const { id } = req.params;
    const studentData = req.body;

    console.log('📝 [CONTROLLER] updateStudent recibido:', {
      id,
      RepresentanteCedula: studentData.RepresentanteCedula,
      MadreCedula: studentData.MadreCedula,
      PadreCedula: studentData.PadreCedula,
      MadreOcupacion: studentData.MadreOcupacion,
      PadreOcupacion: studentData.PadreOcupacion,
      representative_dni: studentData.representative_dni,
      RepresentanteParentesco: studentData.RepresentanteParentesco,
    });

    // Verificar si el estudiante existe
    const existing = await StudentModel.findById(id);
    if (!existing) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    // Verificar si la cédula ya existe (si se está cambiando)
    if (studentData.cedula && studentData.cedula !== existing.dni) {
      const exists = await StudentModel.existsByCedula(studentData.cedula, id);
      if (exists) {
        return res.status(400).json({
          ok: false,
          msg: "La cédula ya está registrada para otro estudiante"
        });
      }
    }

    const updated = await StudentModel.update(id, studentData);
    const sections = await StudentModel.findSectionsByStudentId(id);
    const formatted = formatStudentPayload(updated, sections);
    await enrichStudentWithFamiliares(formatted, id);

    return res.json({
      ok: true,
      msg: "Estudiante actualizado",
      data: formatted
    });
  } catch (error) {
    console.error("Error en updateStudent:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al actualizar estudiante",
      error: error.message
    });
  }
};

/**
 * Eliminar un estudiante
 */
const deleteStudent = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar si el estudiante existe
    const existing = await StudentModel.findById(id);
    if (!existing) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    await StudentModel.remove(id);

    return res.json({
      ok: true,
      msg: "Estudiante eliminado"
    });
  } catch (error) {
    console.error("Error en deleteStudent:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al eliminar estudiante",
      error: error.message
    });
  }
};

/**
 * Inscribir estudiante en una sección
 */
const enrollStudent = async (req, res) => {
  try {
    const { studentId, sectionId } = req.body;

    if (!studentId || !sectionId) {
      return res.status(400).json({
        ok: false,
        msg: "Se requiere studentId y sectionId"
      });
    }

    // Verificar que el estudiante existe
    const student = await StudentModel.findById(studentId);
    if (!student) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    const enrollment = await StudentModel.enrollInSection(studentId, sectionId);

    return res.status(201).json({
      ok: true,
      msg: "Estudiante inscrito en la sección",
      data: enrollment
    });
  } catch (error) {
    console.error("Error en enrollStudent:", error);

    if (error.message === "La sección ha alcanzado su capacidad máxima") {
      return res.status(400).json({
        ok: false,
        msg: error.message
      });
    }

    return res.status(500).json({
      ok: false,
      msg: "Error al inscribir estudiante",
      error: error.message
    });
  }
};

/**
 * Eliminar inscripción de estudiante
 */
const removeEnrollment = async (req, res) => {
  try {
    const { studentId, sectionId } = req.params;

    await StudentModel.removeFromSection(studentId, sectionId);

    return res.json({
      ok: true,
      msg: "Inscripción eliminada"
    });
  } catch (error) {
    console.error("Error en removeEnrollment:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al eliminar inscripción",
      error: error.message
    });
  }
};

/**
 * Buscar estudiantes
 */
const searchStudents = async (req, res) => {
  try {
    const { q } = req.query;

    if (!q || q.length < 2) {
      return res.json({
        ok: true,
        data: []
      });
    }

    const students = await StudentModel.search(q);

    const transformed = students.map(s => ({
      id: s.id,
      first_name: s.first_name,
      last_name: s.last_name,
      full_name: `${s.first_name} ${s.last_name}`.trim(),
      dni: s.dni,
      birth_date: s.birth_date,
      gender: s.gender
    }));

    return res.json({
      ok: true,
      data: transformed
    });
  } catch (error) {
    console.error("Error en searchStudents:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al buscar estudiantes",
      error: error.message
    });
  }
};

/**
 * ✅ VERSIÓN CORREGIDA - Obtener estudiantes del representante autenticado
 */
/**
 * ✅ VERSIÓN CORREGIDA - Obtener estudiantes del representante autenticado (Soporte Rol Dual)
 */
const getMyStudents = async (req, res) => {
  try {
    const userId = req.user?.userId || req.user?.id;
    const representanteId = req.user?.representanteId;

    console.log("🔍 getMyStudents - Contenido de req.user:", {
      userId,
      roles: req.user?.roles,
      Id_rol: req.user?.Id_rol,
      representanteId
    });

    if (!userId && !representanteId) {
      console.error("❌ No se pudo extraer userId ni representanteId del token");
      return res.status(401).json({
        ok: false,
        msg: "No se pudo identificar al usuario"
      });
    }

    // 1. Obtener representante (por representanteId si existe, por userId o por cédula para rol dual)
    let representante = null;
    if (representanteId) {
      representante = await RepresentanteModel.findById(representanteId);
    }
    if (!representante && userId) {
      representante = await RepresentanteModel.findByUserId(userId);
    }
    if (!representante && req.user?.cedula) {
      representante = await RepresentanteModel.findByCedula(req.user.cedula);
    }

    if (!representante) {
      return res.json({
        ok: true,
        data: [],
        msg: "No es un representante o no tiene estudiantes asociados"
      });
    }

    const repId = parseInt(representante.id_representante || representante.id);

    // ✅ Usar el método en StudentModel para obtener estudiantes
    const students = await StudentModel.findByRepresentante(repId);

    // Obtener periodo / año académico activo directamente de la BD
    let activeYearName = "2025-2026";
    try {
      const activeYear = await ConfigModel.findActiveAcademicYear();
      if (activeYear?.name) {
        activeYearName = activeYear.name;
      }
    } catch (e) {
      console.error("Error obteniendo año académico activo:", e);
    }

    // Transformar al formato esperado por el frontend
    const transformed = students.map(s => {
      // Regla de ENDANZA:
      // De Preparatorio a 5to Grado solo se muestra el Grado (tronco común).
      // En 6to, 7mo y 8vo Grado es que tienen la especialidad/programa (ej. Danza Clásica).
      let rawGrade = (s.dance_level || s.grade_level || '').split(' - ')[0].trim();
      let baseGrade = rawGrade.replace(/Año/gi, 'Grado');
      const isAdvanced = /6|7|8|sexto|séptimo|septimo|octavo/i.test(baseGrade);

      let displayGrade = baseGrade || 'N/A';
      if (isAdvanced && s.specialty_name) {
        displayGrade = `${baseGrade} - ${s.specialty_name}`;
      }

      let sFirst = (s.first_name || '').trim();
      let sMiddle = (s.segundo_nombre || s.middle_name || s.second_name || '').trim();
      if (sFirst.includes(' ') && !sMiddle) {
        const parts = sFirst.split(/\s+/);
        sFirst = parts[0];
        sMiddle = parts.slice(1).join(' ');
      }

      let sLast = (s.last_name || '').trim();
      let sSecondLast = (s.segundo_apellido || s.second_last_name || '').trim();
      if (sLast.includes(' ') && !sSecondLast) {
        const parts = sLast.split(/\s+/);
        sLast = parts[0];
        sSecondLast = parts.slice(1).join(' ');
      }

      const sFullName = `${sFirst} ${sMiddle ? sMiddle + ' ' : ''}${sLast} ${sSecondLast || ''}`.trim();

      let repFirst = (s.representative_first_name || '').trim();
      let repMiddle = (s.representative_second_name || s.representative_segundo_nombre || '').trim();
      if (repFirst.includes(' ') && !repMiddle) {
        const parts = repFirst.split(/\s+/);
        repFirst = parts[0];
        repMiddle = parts.slice(1).join(' ');
      }

      let repLast = (s.representative_last_name || '').trim();
      let repSecondLast = (s.representative_second_last_name || s.representative_segundo_apellido || '').trim();
      if (repLast.includes(' ') && !repSecondLast) {
        const parts = repLast.split(/\s+/);
        repLast = parts[0];
        repSecondLast = parts.slice(1).join(' ');
      }

      const repFullName = repFirst 
        ? `${repFirst} ${repMiddle ? repMiddle + ' ' : ''}${repLast} ${repSecondLast || ''}`.trim()
        : null;

      return {
        id: s.id,
        first_name: sFirst,
        middle_name: sMiddle,
        segundo_nombre: sMiddle,
        second_name: sMiddle,
        last_name: sLast,
        second_last_name: sSecondLast,
        segundo_apellido: sSecondLast,
        full_name: sFullName,
        name: sFirst,
        lastName: sLast,
        fullName: sFullName,
        EstudiantePrimerNombre: sFirst,
        EstudianteSegundoNombre: sMiddle,
        EstudiantePrimerApellido: sLast,
        EstudianteSegundoApellido: sSecondLast,
        NombreEstudiante: `${sFirst} ${sMiddle}`.trim(),
        ApellidoEstudiante: `${sLast} ${sSecondLast}`.trim(),
        dni: s.dni,
        birth_date: s.birth_date,
        gender: s.gender,
        grade_level: displayGrade,
        gradeLevel: displayGrade,
        base_grade: baseGrade,
        dance_level: s.dance_level_name || s.dance_level,
        danceLevel: s.dance_level_name || s.dance_level,
        dance_level_id: s.dance_level_id,
        dance_level_name: s.dance_level_name || s.dance_level,
        Grado: s.dance_level_name || s.dance_level || displayGrade,
        specialty_name: s.specialty_name,
        specialtyName: s.specialty_name,
        has_program: isAdvanced,
        school_insurance: s.school_insurance,
        representative_id: s.representative_id || repId,
        representative: repFullName,
        representative_first_name: s.representative_first_name,
        representative_second_name: repMiddle,
        representative_last_name: s.representative_last_name,
        representative_second_last_name: repSecondLast,
        RepresentantePrimerNombre: s.representative_first_name,
        RepresentanteSegundoNombre: repMiddle,
        RepresentantePrimerApellido: s.representative_last_name,
        RepresentanteSegundoApellido: repSecondLast,
        representative_dni: s.representative_dni,
        representative_phone: s.representative_phone,
        representative_email: s.representative_email,
        representative_relationship: s.parentesco || 'Madre',
        parentesco: s.parentesco || 'Madre',
        RepresentanteParentesco: s.parentesco || 'Madre',
        RepresentanteCedula: s.representative_dni,
        RepresentanteNombre: repFullName,
        RepresentanteTelefono: s.representative_phone,
        RepresentanteEmail: s.representative_email,
        academic_year: activeYearName,
        academicYear: activeYearName
      };
    });

    return res.json({
      ok: true,
      data: transformed,
      total: transformed.length
    });

  } catch (error) {
    console.error("❌ Error en getMyStudents:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener estudiantes del representante",
      error: error.message
    });
  }
};



/**
 * Obtener un estudiante por ID (solo si el representante tiene permiso, soporta rol dual y administradores)
 */
const getStudentForRepresentante = async (req, res) => {
  try {
    const studentId = req.params.id;
    const userId = req.user?.userId || req.user?.id;
    const representanteId = req.user?.representanteId;
    const userRoles = req.user?.roles || [];
    const isAdminOrStaff = userRoles.includes('administrador') || 
                           userRoles.includes('admin') || 
                           userRoles.includes('coordinador') || 
                           userRoles.includes('docente') || 
                           req.user?.Id_rol === 1 || 
                           req.user?.Id_rol === 2;

    console.log(`👤 Usuario (user: ${userId}, repId: ${representanteId}, isAdmin: ${isAdminOrStaff}) solicitando perfil del estudiante ${studentId}`);

    // 1. Si no es admin/staff, verificar que sea un representante válido
    let representante = null;
    if (!isAdminOrStaff) {
      if (representanteId) {
        representante = await RepresentanteModel.findById(representanteId);
      }
      if (!representante && userId) {
        representante = await RepresentanteModel.findByUserId(userId);
      }
      if (!representante && req.user?.cedula) {
        representante = await RepresentanteModel.findByCedula(req.user.cedula);
      }

      if (!representante) {
        return res.status(403).json({
          ok: false,
          msg: "No tienes permisos para ver perfiles de estudiantes"
        });
      }
    }

    // 2. Obtener el estudiante
    const student = await StudentModel.findById(studentId);

    if (!student) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    // 3. Verificar pertenencia solo si NO es admin/staff
    if (!isAdminOrStaff && representante) {
      const repId = parseInt(representante.id_representante || representante.id);
      const studentRepId = parseInt(student.representative_id);
      const studentRepUserId = parseInt(student.representative_user_id);
      let isOwner = studentRepId === repId || (userId && studentRepUserId === parseInt(userId));

      if (!isOwner) {
        // Verificar si está vinculado a través de estudiante_familiar
        const repPersonaRes = await db.query(
          'SELECT id_persona FROM representante WHERE id_representante = $1',
          [repId]
        );
        if (repPersonaRes.rows.length > 0) {
          const famCheck = await db.query(
            'SELECT 1 FROM estudiante_familiar WHERE id_estudiante = $1 AND id_persona = $2',
            [studentId, repPersonaRes.rows[0].id_persona]
          );
          if (famCheck.rows.length > 0) {
            isOwner = true;
          }
        }
      }

      if (!isOwner) {
        console.warn(`🚨 Intento de acceso no autorizado: Representante ${repId} intenta ver estudiante ${studentId} que pertenece a ${studentRepId}`);
        return res.status(403).json({
          ok: false,
          msg: "No tienes permiso para ver este estudiante"
        });
      }
    }

    // 4. Obtener las secciones del estudiante
    const sections = await StudentModel.findSectionsByStudentId(studentId);

    // 5. Obtener período/año escolar actual desde la BD
    let currentAcademicYear = '2025-2026';
    try {
      const yearRes = await db.query(
        "SELECT nombre_ano FROM ano_academico WHERE estado_ano = 'en_curso' LIMIT 1"
      );
      if (yearRes.rows.length > 0) {
        currentAcademicYear = yearRes.rows[0].nombre_ano;
      }
    } catch (e) {
      console.warn("No se pudo obtener el año académico activo:", e.message);
    }

    const transformed = formatStudentPayload(student, sections, currentAcademicYear);

    // 6. Obtener familiares (madre y padre) desde estudiante_familiar + persona
    await enrichStudentWithFamiliares(transformed, studentId);

    return res.json({
      ok: true,
      data: transformed
    });

  } catch (error) {
    console.error("❌ Error en getStudentForRepresentante:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener perfil del estudiante",
      error: error.message
    });
  }
};








/**
* Obtiene los boletines de un estudiante por año académico
*/
const getStudentBoletines = async (req, res) => {
  try {
    const studentId = req.params.id;
    const userId = req.user?.userId || req.user?.id;
    const representanteId = req.user?.representanteId;
    const { academicYearId } = req.query;

    console.log(`👤 Usuario ${userId} solicitando boletines del estudiante ${studentId}`);

    // 1. Verificar que el usuario es representante
    let representante = null;
    if (representanteId) {
      representante = await RepresentanteModel.findById(representanteId);
    }
    if (!representante && userId) {
      representante = await RepresentanteModel.findByUserId(userId);
    }
    if (!representante && req.user?.cedula) {
      representante = await RepresentanteModel.findByCedula(req.user.cedula);
    }

    if (!representante) {
      return res.status(403).json({
        ok: false,
        msg: "No tienes permisos para ver boletines"
      });
    }

    // 2. Verificar que el estudiante pertenece al representante
    const student = await StudentModel.findById(studentId);

    if (!student) {
      return res.status(404).json({
        ok: false,
        msg: "Estudiante no encontrado"
      });
    }

    const repId = parseInt(representante.id_representante || representante.id);
    const studentRepId = parseInt(student.representative_id);
    const studentRepUserId = parseInt(student.representative_user_id);
    const isOwner = studentRepId === repId || (userId && studentRepUserId === parseInt(userId));

    if (!isOwner) {
      return res.status(403).json({
        ok: false,
        msg: "No tienes permiso para ver este estudiante"
      });
    }

    // 3. Obtener boletines del estudiante
    const boletines = await StudentModel.getStudentBoletines(studentId, academicYearId);

    return res.json({
      ok: true,
      data: boletines
    });

  } catch (error) {
    console.error("❌ Error en getStudentBoletines:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener boletines",
      error: error.message
    });
  }
};


// controllers/student.controller.js
const getCurrentSection = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`🔍 Buscando sección para estudiante ID: ${id}`);

    const query = `
            SELECT 
                s."Id_seccion" as id,
                s."nombre_seccion" as nombre_seccion,
                g."nombre_grado" as nivel_academico,
                a."nombre_ano" as academic_year_name,
                a."Id_ano" as academic_year_id
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            JOIN "Ano_Academico" a ON s."Id_ano" = a."Id_ano"
            JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
            JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
            WHERE es."Id_estudiante" = $1
            ORDER BY es."Id_estudiante_seccion" DESC
            LIMIT 1
        `;

    const { rows } = await db.query(query, [id]);

    if (rows.length === 0) {
      return res.status(404).json({
        ok: false,
        msg: "El estudiante no está asignado a ninguna sección"
      });
    }

    console.log(`✅ Sección encontrada:`, rows[0]);

    return res.json({
      ok: true,
      seccion: rows[0]
    });

  } catch (error) {
    console.error("Error en getCurrentSection:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener sección del estudiante"
    });
  }
};


/**
 * Obtener horarios por grado del estudiante
 * Busca la sección actual del estudiante, obtiene su nivel_academico,
 * y luego retorna todos los horarios de TODAS las secciones con ese mismo grado
 * en el mismo año académico.
 */
const getScheduleByGrade = async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`📅 Buscando horarios por grado para estudiante ID: ${id}`);

    // PASO 1: Obtener el nombre del grado mediante Materia y Grado
    const sectionQuery = `
            SELECT 
                s."Id_seccion" as section_id,
                s."nombre_seccion" as nombre_seccion,
                g."nombre_grado" as nivel_academico,
                g."Id_grado" as grade_id,
                a."nombre_ano" as academic_year_name,
                a."Id_ano" as academic_year_id
            FROM "Estudiante_Seccion" es
            JOIN "Seccion" s ON es."Id_seccion" = s."Id_seccion"
            JOIN "Ano_Academico" a ON s."Id_ano" = a."Id_ano"
            JOIN "Materia" m ON s."Id_materia" = m."Id_materia"
            JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
            WHERE es."Id_estudiante" = $1
            ORDER BY es."Id_estudiante_seccion" DESC
            LIMIT 1
        `;

    const { rows: sectionRows } = await db.query(sectionQuery, [id]);

    if (sectionRows.length === 0) {
      return res.status(404).json({
        ok: false,
        msg: "El estudiante no está asignado a ninguna sección o materia"
      });
    }

    const currentSection = sectionRows[0];
    const gradeId = currentSection.grade_id;
    const nivelAcademico = currentSection.nivel_academico;
    const academicYearId = currentSection.academic_year_id;

    console.log(`✅ Estudiante en grado: "${nivelAcademico}" (ID: ${gradeId}), año académico ID: ${academicYearId}`);

    // PASO 2: Obtener TODOS los horarios de TODAS las secciones que pertenezcan al mismo GRADO
    const schedulesQuery = `
            SELECT 
                h."Id_horario" as id,
                h."Id_dia" as day_id,
                d."nombre_dia" as day_name,
                h."Id_bloque" as block_id,
                b."nombre_bloque" as block_name,
                b."inicio_bloque" as start_time,
                b."fin_bloque" as end_time,
                h."Id_aula" as classroom_id,
                au."nombre_aula" as classroom_name,
                h."Id_profesor" as teacher_id,
                CONCAT(u."nombre", ' ', u."apellido") as teacher_name,
                m."Id_materia" as subject_id,
                m."nombre_materia" as subject_name,
                m."tipo_materia" as subject_type,
                s."Id_seccion" as section_id,
                s."nombre_seccion" as section_name
            FROM "Horario" h
            JOIN "Seccion" s ON h."Id_seccion" = s."Id_seccion"
            JOIN "Materia" m ON COALESCE(h."Id_materia", s."Id_materia") = m."Id_materia"
            JOIN "Grado" g ON m."ano_materia" = g."Id_grado"
            JOIN "Dia" d ON h."Id_dia" = d."Id_dia"
            JOIN "Bloque_Horario" b ON h."Id_bloque" = b."Id_bloque"
            LEFT JOIN "Aula" au ON h."Id_aula" = au."Id_aula"
            LEFT JOIN "Profesor" p ON h."Id_profesor" = p."Id_profesor"
            LEFT JOIN "Usuario" u ON p."Id_usuario" = u."Id_usuario"
            WHERE g."Id_grado" = $1
              AND s."Id_ano" = $2
            ORDER BY d."Id_dia", b."inicio_bloque"
        `;

    const { rows: scheduleRows } = await db.query(schedulesQuery, [gradeId, academicYearId]);

    console.log(`📋 Horarios encontrados para grado "${nivelAcademico}": ${scheduleRows.length}`);

    return res.json({
      ok: true,
      data: {
        grado: nivelAcademico,
        seccion: currentSection,
        academic_year_name: currentSection.academic_year_name,
        horarios: scheduleRows
      }
    });

  } catch (error) {
    console.error("Error en getScheduleByGrade:", error);
    return res.status(500).json({
      ok: false,
      msg: "Error al obtener horarios por grado del estudiante"
    });
  }
};


// Exportar todos los métodos
export const StudentController = {
  listStudents,
  getStudent,
  createStudent,
  updateStudent,
  deleteStudent,
  enrollStudent,
  removeEnrollment,
  searchStudents,
  getMyStudents,
  getStudentForRepresentante, // 👈 NUEVO // 👈 Método corregido
  getStudentBoletines,
  getCurrentSection,
  getScheduleByGrade,
};