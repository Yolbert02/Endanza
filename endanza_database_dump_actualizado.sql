-- ==========================================
-- TIPOS ENUMERADOS
-- ==========================================

CREATE TYPE rol_enum AS ENUM (
  'administrador',
  'docente',
  'secretaria',
  'representante',
  'estudiante'
);

CREATE TYPE estado_usuario_enum AS ENUM (
  'activo',
  'suspendido',
  'inactivo'
);

CREATE TYPE genero_enum AS ENUM (
  'masculino',
  'femenino'
);

CREATE TYPE estado_ano_enum AS ENUM (
  'planificado',
  'en_curso',
  'finalizado'
);

CREATE TYPE estado_inscripcion_enum AS ENUM (
  'activo',
  'retirado',
  'egresado'
);

CREATE TYPE tipo_materia_enum AS ENUM (
  'teorica',
  'practica'
);

CREATE TYPE termino_nacimiento_enum AS ENUM (
  'a_termino',
  'prematuro'
);

CREATE TYPE tipo_incidencia_enum AS ENUM (
  'estudiante',
  'docente'
);

CREATE TYPE tipo_certificado_enum AS ENUM (
  'constancia_estudio',
  'buena_conducta',
  'permiso_endanza'
);

CREATE TYPE estado_certificado_enum AS ENUM (
  'pendiente',
  'procesada',
  'entregada'
);

-- ==========================================
-- CONFIGURACIÓN DE ROLES Y USUARIOS
-- ==========================================

CREATE TABLE rol (
  id_rol SERIAL PRIMARY KEY,
  tipo_rol rol_enum NOT NULL
);

CREATE TABLE direccion (
  id_direccion SERIAL PRIMARY KEY,
  direccion VARCHAR(255)
);

CREATE TABLE persona (
  id_persona SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  segundo_nombre VARCHAR(100),
  apellido VARCHAR(100) NOT NULL,
  segundo_apellido VARCHAR(100),
  cedula VARCHAR(20) UNIQUE,
  numero_telefono VARCHAR(20),
  email VARCHAR(100),
  fecha_nacimiento DATE,
  genero genero_enum
);

CREATE TABLE usuario (
  id_usuario SERIAL PRIMARY KEY,
  contrasena VARCHAR(255) NOT NULL,
  foto_usuario VARCHAR(255),
  estado_usuario estado_usuario_enum DEFAULT 'activo',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  id_rol INT REFERENCES rol(id_rol),
  id_direccion INT REFERENCES direccion(id_direccion),
  id_persona INT REFERENCES persona(id_persona)
);

CREATE TABLE usuario_rol (
  id_usuario INT REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  id_rol INT REFERENCES rol(id_rol) ON DELETE CASCADE,
  PRIMARY KEY (id_usuario, id_rol)
);

-- ==========================================
-- ROLES ESPECÍFICOS Y FAMILIA
-- ==========================================

CREATE TABLE docente (
  id_docente SERIAL PRIMARY KEY,
  id_usuario INT REFERENCES usuario(id_usuario)
);

CREATE TABLE representante (
  id_representante SERIAL PRIMARY KEY,
  id_persona INT REFERENCES persona(id_persona),
  id_usuario INT REFERENCES usuario(id_usuario),
  profesion VARCHAR(100),
  direccion_trabajo VARCHAR(150),
  telefono_trabajo VARCHAR(20)
);

-- ==========================================
-- CATÁLOGOS Y DATOS MÉDICOS DE ESTUDIANTES
-- ==========================================

CREATE TABLE especialidad (
  id_especialidad SERIAL PRIMARY KEY,
  nombre_especialidad VARCHAR(100) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE escuela_regular (
  id_escuela SERIAL PRIMARY KEY,
  nombre_escuela VARCHAR(100) NOT NULL
);

CREATE TABLE seguro_medico (
  id_seguro SERIAL PRIMARY KEY,
  tipo_seguro VARCHAR(80) NOT NULL
);

CREATE TABLE nivel_escolar (
  id_nivel SERIAL PRIMARY KEY,
  nivel VARCHAR(30) NOT NULL
);

CREATE TABLE nivel_danza (
  id_nivel_danza SERIAL PRIMARY KEY,
  nivel_danza VARCHAR(30) NOT NULL
);

CREATE TABLE historial_medico (
  id_historia SERIAL PRIMARY KEY,
  peso_kg FLOAT,
  altura_m FLOAT,
  intolerancia_alimentos BOOLEAN DEFAULT FALSE,
  descripcion_intolerancia VARCHAR(255),
  dolores_frecuentes BOOLEAN DEFAULT FALSE,
  constipacion_frecuente BOOLEAN DEFAULT FALSE,
  tiene_cirugia BOOLEAN DEFAULT FALSE,
  descripcion_cirugia VARCHAR(255),
  control_hormonal BOOLEAN DEFAULT FALSE,
  descripcion_control_hormonal VARCHAR(255),
  tiene_alergias BOOLEAN DEFAULT FALSE,
  descripcion_alergias VARCHAR(255),
  historial_familiar_desc VARCHAR(500),
  termino_nacimiento termino_nacimiento_enum
);

CREATE TABLE estudiante (
  id_estudiante SERIAL PRIMARY KEY,
  foto_estudiante VARCHAR(255),
  seguro_escolar BOOLEAN DEFAULT TRUE,
  id_persona INT REFERENCES persona(id_persona),
  id_representante INT REFERENCES representante(id_representante),
  id_especialidad INT REFERENCES especialidad(id_especialidad),
  id_nivel INT REFERENCES nivel_escolar(id_nivel),
  id_nivel_danza INT REFERENCES nivel_danza(id_nivel_danza),
  id_escuela INT REFERENCES escuela_regular(id_escuela),
  id_seguro INT REFERENCES seguro_medico(id_seguro),
  id_historia INT REFERENCES historial_medico(id_historia)
);

CREATE TABLE estudiante_familiar (
  id_estudiante_familiar SERIAL PRIMARY KEY,
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_persona INT REFERENCES persona(id_persona),
  parentesco VARCHAR(50),
  es_representante_legal BOOLEAN DEFAULT FALSE,
  vive_con_estudiante BOOLEAN DEFAULT TRUE
);

-- ==========================================
-- ESTRUCTURA ACADÉMICA Y PERIODOS
-- ==========================================

CREATE TABLE ano_academico (
  id_ano SERIAL PRIMARY KEY,
  nombre_ano VARCHAR(20) NOT NULL,
  estado_ano estado_ano_enum DEFAULT 'planificado',
  inicio_ano DATE,
  fin_ano DATE
);

CREATE TABLE periodo (
  id_periodo SERIAL PRIMARY KEY,
  nombre_periodo VARCHAR(20) NOT NULL,
  inicio_periodo DATE,
  fin_periodo DATE,
  id_ano INT REFERENCES ano_academico(id_ano)
);

CREATE TABLE seccion (
  id_seccion SERIAL PRIMARY KEY,
  nombre_seccion VARCHAR(30) NOT NULL,
  id_ano INT REFERENCES ano_academico(id_ano),
  id_nivel_danza INT REFERENCES nivel_danza(id_nivel_danza),
  id_especialidad INT REFERENCES especialidad(id_especialidad)
);

CREATE TABLE inscripcion (
  id_inscripcion SERIAL PRIMARY KEY,
  fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  estado_inscripcion estado_inscripcion_enum DEFAULT 'activo',
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_ano INT REFERENCES ano_academico(id_ano),
  id_seccion INT REFERENCES seccion(id_seccion)
);

CREATE TABLE materia (
  id_materia SERIAL PRIMARY KEY,
  nombre_materia VARCHAR(100) NOT NULL,
  tipo_materia tipo_materia_enum,
  id_nivel_danza INT REFERENCES nivel_danza(id_nivel_danza),
  id_especialidad INT REFERENCES especialidad(id_especialidad)
);

CREATE TABLE tipo_aula (
  id_tipo_aula SERIAL PRIMARY KEY,
  nombre_tipo_aula VARCHAR(30) NOT NULL
);

CREATE TABLE aula (
  id_aula SERIAL PRIMARY KEY,
  nombre_aula VARCHAR(30) NOT NULL,
  id_tipo_aula INT REFERENCES tipo_aula(id_tipo_aula)
);

CREATE TABLE dia (
  id_dia SERIAL PRIMARY KEY,
  nombre_dia VARCHAR(10) NOT NULL
);

CREATE TABLE tiempo_bloque (
  id_bloque SERIAL PRIMARY KEY,
  nombre_bloque VARCHAR(20) NOT NULL,
  inicio_bloque TIME,
  fin_bloque TIME,
  id_dia INT REFERENCES dia(id_dia)
);

CREATE TABLE horario (
  id_horario SERIAL PRIMARY KEY,
  id_seccion INT REFERENCES seccion(id_seccion),
  id_materia INT REFERENCES materia(id_materia),
  id_aula INT REFERENCES aula(id_aula),
  id_docente INT REFERENCES docente(id_docente),
  id_bloque INT REFERENCES tiempo_bloque(id_bloque)
);

-- ==========================================
-- EVALUACIONES, NOTAS Y ASISTENCIAS
-- ==========================================

CREATE TABLE tipo_evaluacion (
  id_tipo_evaluacion SERIAL PRIMARY KEY,
  nombre_evaluacion VARCHAR(50) NOT NULL
);

CREATE TABLE estructura_evaluacion (
  id_estructura_evaluacion SERIAL PRIMARY KEY,
  numero_evaluacion INT,
  porcentaje NUMERIC(5,2),
  descripcion VARCHAR(100),
  id_materia INT REFERENCES materia(id_materia),
  id_seccion INT REFERENCES seccion(id_seccion),
  id_periodo INT REFERENCES periodo(id_periodo),
  id_tipo_evaluacion INT REFERENCES tipo_evaluacion(id_tipo_evaluacion)
);

CREATE TABLE carga_nota (
  id_nota SERIAL PRIMARY KEY,
  nota NUMERIC(5,2),
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_estructura_evaluacion INT REFERENCES estructura_evaluacion(id_estructura_evaluacion)
);

CREATE TABLE asistencia (
  id_asistencia SERIAL PRIMARY KEY,
  fecha_asistencia DATE,
  es_ausente BOOLEAN DEFAULT FALSE,
  horas_perdidas FLOAT,
  es_justificado BOOLEAN DEFAULT FALSE,
  documento_justificacion VARCHAR(255),
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_horario INT REFERENCES horario(id_horario)
);

-- ==========================================
-- PROMOCIÓN, REVISIÓN Y DOCUMENTOS
-- ==========================================

CREATE TABLE acta_promocion (
  id_acta SERIAL PRIMARY KEY,
  numero_acta VARCHAR(50),
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_ano INT REFERENCES ano_academico(id_ano),
  id_grado_origen INT REFERENCES nivel_danza(id_nivel_danza),
  id_grado_destino INT REFERENCES nivel_danza(id_nivel_danza),
  promedio_lapso1 NUMERIC(5,2),
  motivo TEXT,
  resolucion TEXT,
  autoridades JSONB,
  fecha_sesion DATE,
  fecha_emision TIMESTAMP,
  estado VARCHAR(20),
  creado_por INT REFERENCES usuario(id_usuario)
);

CREATE TABLE boletin_estudiante (
  id_boletin SERIAL PRIMARY KEY,
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_ano INT REFERENCES ano_academico(id_ano),
  disponible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  descargas INT DEFAULT 0
);

CREATE TABLE revision_materia (
  id_revision SERIAL PRIMARY KEY,
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_materia INT REFERENCES materia(id_materia),
  id_ano INT REFERENCES ano_academico(id_ano),
  nota_definitiva NUMERIC(5,2),
  nota_revision NUMERIC(5,2),
  estado VARCHAR(20),
  observacion TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_revision TIMESTAMP,
  creado_por INT REFERENCES usuario(id_usuario)
);

CREATE TABLE incidencia (
  id_incidencia SERIAL PRIMARY KEY,
  tipo_incidencia tipo_incidencia_enum,
  descripcion VARCHAR(500),
  fecha_incidencia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_usuario_involucrado INT REFERENCES usuario(id_usuario),
  id_usuario_reporta INT REFERENCES usuario(id_usuario)
);

CREATE TABLE solicitud_certificado (
  id_solicitud SERIAL PRIMARY KEY,
  tipo_certificado tipo_certificado_enum,
  fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  estado estado_certificado_enum DEFAULT 'pendiente',
  id_estudiante INT REFERENCES estudiante(id_estudiante),
  id_representante INT REFERENCES representante(id_representante)
);