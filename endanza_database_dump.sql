--
-- PostgreSQL database dump
--

\restrict XJaVHeiRemsbJoYMorP0betttZkPoFha9wgsXPUoaK9WdRAeQy65Ds38lDgARTk

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: movement_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movement_type_enum AS ENUM (
    'entrada',
    'salida',
    'ajuste'
);


ALTER TYPE public.movement_type_enum OWNER TO postgres;

--
-- Name: order_state_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_state_enum AS ENUM (
    'pendiente',
    'procesando',
    'completado',
    'cancelado'
);


ALTER TYPE public.order_state_enum OWNER TO postgres;

--
-- Name: report_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.report_type_enum AS ENUM (
    'ventas',
    'inventario',
    'financiero'
);


ALTER TYPE public.report_type_enum OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_en = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Acta_Promocion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Acta_Promocion" (
    "Id_acta" integer NOT NULL,
    numero_acta character varying(50) NOT NULL,
    "Id_estudiante" integer NOT NULL,
    "Id_ano" integer NOT NULL,
    "Id_grado_origen" integer NOT NULL,
    "Id_grado_destino" integer NOT NULL,
    promedio_lapso1 numeric(5,2) NOT NULL,
    motivo text NOT NULL,
    resolucion text,
    autoridades jsonb,
    fecha_sesion date DEFAULT CURRENT_DATE,
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20) DEFAULT 'aprobada'::character varying,
    creado_por integer
);


ALTER TABLE public."Acta_Promocion" OWNER TO postgres;

--
-- Name: Acta_Promocion_Id_acta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Acta_Promocion_Id_acta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Acta_Promocion_Id_acta_seq" OWNER TO postgres;

--
-- Name: Acta_Promocion_Id_acta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Acta_Promocion_Id_acta_seq" OWNED BY public."Acta_Promocion"."Id_acta";


--
-- Name: Ano_Academico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ano_Academico" (
    "Id_ano" integer NOT NULL,
    nombre_ano character varying(20),
    estatus_ano character varying(20),
    inicio_ano date,
    fin_ano date,
    activo boolean DEFAULT false
);


ALTER TABLE public."Ano_Academico" OWNER TO postgres;

--
-- Name: Ano_Academico_Id_ano_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ano_Academico_Id_ano_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Ano_Academico_Id_ano_seq" OWNER TO postgres;

--
-- Name: Ano_Academico_Id_ano_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ano_Academico_Id_ano_seq" OWNED BY public."Ano_Academico"."Id_ano";


--
-- Name: Asistencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Asistencia" (
    "Id_asistencia" integer NOT NULL,
    fecha_asistencia date,
    estatus character varying(20),
    esta_justificada boolean,
    descripcion_justificacion character varying(255),
    "Id_estudiante" integer,
    "Id_seccion" integer
);


ALTER TABLE public."Asistencia" OWNER TO postgres;

--
-- Name: Asistencia_Id_asistencia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Asistencia_Id_asistencia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Asistencia_Id_asistencia_seq" OWNER TO postgres;

--
-- Name: Asistencia_Id_asistencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Asistencia_Id_asistencia_seq" OWNED BY public."Asistencia"."Id_asistencia";


--
-- Name: Aula; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Aula" (
    "Id_aula" integer NOT NULL,
    nombre_aula character varying(30),
    "Id_tipo_clase" integer
);


ALTER TABLE public."Aula" OWNER TO postgres;

--
-- Name: Aula_Id_aula_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Aula_Id_aula_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Aula_Id_aula_seq" OWNER TO postgres;

--
-- Name: Aula_Id_aula_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Aula_Id_aula_seq" OWNED BY public."Aula"."Id_aula";


--
-- Name: Aula_Materia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Aula_Materia" (
    "Id_aula" integer NOT NULL,
    "Id_materia" integer NOT NULL
);


ALTER TABLE public."Aula_Materia" OWNER TO postgres;

--
-- Name: Bloque_Horario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Bloque_Horario" (
    "Id_bloque" integer NOT NULL,
    nombre_bloque character varying(20),
    inicio_bloque time without time zone,
    fin_bloque time without time zone
);


ALTER TABLE public."Bloque_Horario" OWNER TO postgres;

--
-- Name: Bloque_Horario_Id_bloque_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Bloque_Horario_Id_bloque_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Bloque_Horario_Id_bloque_seq" OWNER TO postgres;

--
-- Name: Bloque_Horario_Id_bloque_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Bloque_Horario_Id_bloque_seq" OWNED BY public."Bloque_Horario"."Id_bloque";


--
-- Name: Boleta_Notas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Boleta_Notas" (
    "Id_boleta" integer NOT NULL,
    puntaje_final_lapso real,
    fecha_emision date,
    "Id_estudiante" integer,
    "Id_lapso" integer,
    "Id_materia" integer,
    "Id_detalles_reporte" integer,
    "Id_seccion" integer,
    descargas integer DEFAULT 0,
    disponible boolean DEFAULT false
);


ALTER TABLE public."Boleta_Notas" OWNER TO postgres;

--
-- Name: Boleta_Notas_Id_boleta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Boleta_Notas_Id_boleta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Boleta_Notas_Id_boleta_seq" OWNER TO postgres;

--
-- Name: Boleta_Notas_Id_boleta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Boleta_Notas_Id_boleta_seq" OWNED BY public."Boleta_Notas"."Id_boleta";


--
-- Name: Boletin_Estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Boletin_Estudiante" (
    id integer NOT NULL,
    student_id integer NOT NULL,
    academic_year_id integer NOT NULL,
    is_available boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    downloads integer DEFAULT 0
);


ALTER TABLE public."Boletin_Estudiante" OWNER TO postgres;

--
-- Name: Boletin_Estudiante_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Boletin_Estudiante_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Boletin_Estudiante_id_seq" OWNER TO postgres;

--
-- Name: Boletin_Estudiante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Boletin_Estudiante_id_seq" OWNED BY public."Boletin_Estudiante".id;


--
-- Name: Carga_Nota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Carga_Nota" (
    "Id_nota" integer NOT NULL,
    puntaje real,
    esta_formalizada boolean,
    "Id_estudiante" integer,
    "Id_estructura_evaluacion" integer
);


ALTER TABLE public."Carga_Nota" OWNER TO postgres;

--
-- Name: Carga_Nota_Id_nota_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Carga_Nota_Id_nota_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Carga_Nota_Id_nota_seq" OWNER TO postgres;

--
-- Name: Carga_Nota_Id_nota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Carga_Nota_Id_nota_seq" OWNED BY public."Carga_Nota"."Id_nota";


--
-- Name: Ciudad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ciudad" (
    "Id_ciudad" integer NOT NULL,
    "Id_parroquia" integer,
    nombre_ciudad character varying(100)
);


ALTER TABLE public."Ciudad" OWNER TO postgres;

--
-- Name: Ciudad_Id_ciudad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ciudad_Id_ciudad_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Ciudad_Id_ciudad_seq" OWNER TO postgres;

--
-- Name: Ciudad_Id_ciudad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ciudad_Id_ciudad_seq" OWNED BY public."Ciudad"."Id_ciudad";


--
-- Name: Competencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Competencia" (
    "Id_competencia" integer NOT NULL,
    nombre_competencia character varying(100) NOT NULL,
    description character varying(255),
    "Id_materia" integer
);


ALTER TABLE public."Competencia" OWNER TO postgres;

--
-- Name: Competencia_Id_competencia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Competencia_Id_competencia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Competencia_Id_competencia_seq" OWNER TO postgres;

--
-- Name: Competencia_Id_competencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Competencia_Id_competencia_seq" OWNED BY public."Competencia"."Id_competencia";


--
-- Name: Detalles_Reporte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Detalles_Reporte" (
    "Id_detalles_reporte" integer NOT NULL,
    detalles character varying(255)
);


ALTER TABLE public."Detalles_Reporte" OWNER TO postgres;

--
-- Name: Detalles_Reporte_Id_detalles_reporte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Detalles_Reporte_Id_detalles_reporte_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Detalles_Reporte_Id_detalles_reporte_seq" OWNER TO postgres;

--
-- Name: Detalles_Reporte_Id_detalles_reporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Detalles_Reporte_Id_detalles_reporte_seq" OWNED BY public."Detalles_Reporte"."Id_detalles_reporte";


--
-- Name: Dia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Dia" (
    "Id_dia" integer NOT NULL,
    nombre_dia character varying(10)
);


ALTER TABLE public."Dia" OWNER TO postgres;

--
-- Name: Dia_Id_dia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Dia_Id_dia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Dia_Id_dia_seq" OWNER TO postgres;

--
-- Name: Dia_Id_dia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Dia_Id_dia_seq" OWNED BY public."Dia"."Id_dia";


--
-- Name: Direccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Direccion" (
    "Id_direccion" integer NOT NULL,
    "Id_ciudad" integer,
    nombre_direccion character varying(255)
);


ALTER TABLE public."Direccion" OWNER TO postgres;

--
-- Name: Direccion_Id_direccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Direccion_Id_direccion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Direccion_Id_direccion_seq" OWNER TO postgres;

--
-- Name: Direccion_Id_direccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Direccion_Id_direccion_seq" OWNED BY public."Direccion"."Id_direccion";


--
-- Name: Escuela_Regular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Escuela_Regular" (
    "Id_escuela" integer NOT NULL,
    nombre_escuela character varying(100)
);


ALTER TABLE public."Escuela_Regular" OWNER TO postgres;

--
-- Name: Escuela_Regular_Id_escuela_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Escuela_Regular_Id_escuela_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Escuela_Regular_Id_escuela_seq" OWNER TO postgres;

--
-- Name: Escuela_Regular_Id_escuela_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Escuela_Regular_Id_escuela_seq" OWNED BY public."Escuela_Regular"."Id_escuela";


--
-- Name: Especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Especialidad" (
    "Id_especialidad" integer NOT NULL,
    nombre_especialidad character varying(100) NOT NULL,
    descripcion text,
    area character varying(50),
    activo boolean DEFAULT true,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Especialidad" OWNER TO postgres;

--
-- Name: Especialidad_Id_especialidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Especialidad_Id_especialidad_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Especialidad_Id_especialidad_seq" OWNER TO postgres;

--
-- Name: Especialidad_Id_especialidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Especialidad_Id_especialidad_seq" OWNED BY public."Especialidad"."Id_especialidad";


--
-- Name: Estado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estado" (
    "Id_estado" integer NOT NULL,
    "Id_pais" integer,
    nombre_estado character varying(100)
);


ALTER TABLE public."Estado" OWNER TO postgres;

--
-- Name: Estado_Id_estado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Estado_Id_estado_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Estado_Id_estado_seq" OWNER TO postgres;

--
-- Name: Estado_Id_estado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Estado_Id_estado_seq" OWNED BY public."Estado"."Id_estado";


--
-- Name: Estructura_Evaluacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estructura_Evaluacion" (
    "Id_estructura_evaluacion" integer NOT NULL,
    numero_evaluacion integer,
    porcentaje_peso real,
    "Id_seccion" integer,
    "Id_tipo_evaluacion" integer,
    "Id_lapso" integer
);


ALTER TABLE public."Estructura_Evaluacion" OWNER TO postgres;

--
-- Name: Estructura_Evaluacion_Id_estructura_evaluacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Estructura_Evaluacion_Id_estructura_evaluacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Estructura_Evaluacion_Id_estructura_evaluacion_seq" OWNER TO postgres;

--
-- Name: Estructura_Evaluacion_Id_estructura_evaluacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Estructura_Evaluacion_Id_estructura_evaluacion_seq" OWNED BY public."Estructura_Evaluacion"."Id_estructura_evaluacion";


--
-- Name: Estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estudiante" (
    "Id_estudiante" integer NOT NULL,
    nombre character varying(150) NOT NULL,
    apellido character varying(150) NOT NULL,
    cedula character varying(50) NOT NULL,
    fecha_nacimiento date,
    genero character varying(30),
    seguro_escolar boolean DEFAULT false,
    "Id_nivel" integer,
    "Id_nivel_danza" integer,
    "Id_escuela" integer,
    "Id_seguro" integer,
    "Id_representante" integer,
    "Id_historial" integer,
    estatus character varying(20) DEFAULT 'Activo'::character varying
);


ALTER TABLE public."Estudiante" OWNER TO postgres;

--
-- Name: Estudiante_Id_estudiante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Estudiante_Id_estudiante_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Estudiante_Id_estudiante_seq" OWNER TO postgres;

--
-- Name: Estudiante_Id_estudiante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Estudiante_Id_estudiante_seq" OWNED BY public."Estudiante"."Id_estudiante";


--
-- Name: Estudiante_Padre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estudiante_Padre" (
    "Id_estudiante" integer NOT NULL,
    "Id_padre" integer NOT NULL
);


ALTER TABLE public."Estudiante_Padre" OWNER TO postgres;

--
-- Name: Estudiante_Seccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Estudiante_Seccion" (
    "Id_estudiante_seccion" integer NOT NULL,
    "Id_estudiante" integer,
    "Id_seccion" integer
);


ALTER TABLE public."Estudiante_Seccion" OWNER TO postgres;

--
-- Name: Estudiante_Seccion_Id_estudiante_seccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Estudiante_Seccion_Id_estudiante_seccion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Estudiante_Seccion_Id_estudiante_seccion_seq" OWNER TO postgres;

--
-- Name: Estudiante_Seccion_Id_estudiante_seccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Estudiante_Seccion_Id_estudiante_seccion_seq" OWNED BY public."Estudiante_Seccion"."Id_estudiante_seccion";


--
-- Name: Grado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Grado" (
    "Id_grado" integer NOT NULL,
    nombre_grado character varying(100) NOT NULL,
    nivel character varying(100) DEFAULT 'danza'::character varying,
    descripcion text,
    activo boolean DEFAULT true,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Grado" OWNER TO postgres;

--
-- Name: Grado_Id_grado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Grado_Id_grado_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Grado_Id_grado_seq" OWNER TO postgres;

--
-- Name: Grado_Id_grado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Grado_Id_grado_seq" OWNED BY public."Grado"."Id_grado";


--
-- Name: Historial_Medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Historial_Medico" (
    "Id_historial" integer NOT NULL,
    peso_kg numeric(5,2),
    altura_m numeric(3,2),
    intolerancia_comida boolean DEFAULT false,
    descripcion_intolerancia character varying(255),
    dolores_frecuentes boolean DEFAULT false,
    estrenimiento_frecuente boolean DEFAULT false,
    tiene_cirugia boolean DEFAULT false,
    descripcion_cirugia character varying(255),
    control_hormonal boolean DEFAULT false,
    descripcion_hormonal character varying(255),
    tiene_alergias boolean DEFAULT false,
    descripcion_alergias character varying(255),
    antecedentes_familiares character varying(500),
    termino_nacimiento character varying(20),
    tipo_sangre character varying(10)
);


ALTER TABLE public."Historial_Medico" OWNER TO postgres;

--
-- Name: Historial_Medico_Id_historial_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Historial_Medico_Id_historial_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Historial_Medico_Id_historial_seq" OWNER TO postgres;

--
-- Name: Historial_Medico_Id_historial_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Historial_Medico_Id_historial_seq" OWNED BY public."Historial_Medico"."Id_historial";


--
-- Name: Horario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Horario" (
    "Id_horario" integer NOT NULL,
    "Id_seccion" integer,
    "Id_aula" integer,
    "Id_profesor" integer,
    "Id_bloque" integer,
    "Id_dia" integer
);


ALTER TABLE public."Horario" OWNER TO postgres;

--
-- Name: Horario_Id_horario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Horario_Id_horario_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Horario_Id_horario_seq" OWNER TO postgres;

--
-- Name: Horario_Id_horario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Horario_Id_horario_seq" OWNED BY public."Horario"."Id_horario";


--
-- Name: Incidencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Incidencia" (
    "Id_incidencia" integer NOT NULL,
    tipo_incidencia character varying(50),
    descripcion character varying(500),
    fecha_incidencia timestamp without time zone,
    "Id_estudiante" integer,
    "Id_usuario_involucrado" integer,
    "Id_usuario_reporta" integer
);


ALTER TABLE public."Incidencia" OWNER TO postgres;

--
-- Name: Incidencia_Id_incidencia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Incidencia_Id_incidencia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Incidencia_Id_incidencia_seq" OWNER TO postgres;

--
-- Name: Incidencia_Id_incidencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Incidencia_Id_incidencia_seq" OWNED BY public."Incidencia"."Id_incidencia";


--
-- Name: Lapso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Lapso" (
    "Id_lapso" integer NOT NULL,
    nombre_lapso character varying(10),
    inicio_lapso date,
    fin_lapso date,
    "Id_ano" integer
);


ALTER TABLE public."Lapso" OWNER TO postgres;

--
-- Name: Lapso_Id_lapso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Lapso_Id_lapso_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Lapso_Id_lapso_seq" OWNER TO postgres;

--
-- Name: Lapso_Id_lapso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Lapso_Id_lapso_seq" OWNED BY public."Lapso"."Id_lapso";


--
-- Name: Materia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Materia" (
    "Id_materia" integer NOT NULL,
    nombre_materia character varying(150),
    ano_materia integer,
    tipo_materia character varying(50),
    horas_semanales integer DEFAULT 0,
    observaciones text
);


ALTER TABLE public."Materia" OWNER TO postgres;

--
-- Name: Materia_Id_materia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Materia_Id_materia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Materia_Id_materia_seq" OWNER TO postgres;

--
-- Name: Materia_Id_materia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Materia_Id_materia_seq" OWNED BY public."Materia"."Id_materia";


--
-- Name: Municipio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Municipio" (
    "Id_municipio" integer NOT NULL,
    "Id_estado" integer,
    nombre_municipio character varying(100)
);


ALTER TABLE public."Municipio" OWNER TO postgres;

--
-- Name: Municipio_Id_municipio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Municipio_Id_municipio_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Municipio_Id_municipio_seq" OWNER TO postgres;

--
-- Name: Municipio_Id_municipio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Municipio_Id_municipio_seq" OWNED BY public."Municipio"."Id_municipio";


--
-- Name: Nivel_Danza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Nivel_Danza" (
    "Id_nivel_danza" integer NOT NULL,
    nivel_danza character varying(100)
);


ALTER TABLE public."Nivel_Danza" OWNER TO postgres;

--
-- Name: Nivel_Danza_Id_nivel_danza_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Nivel_Danza_Id_nivel_danza_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Nivel_Danza_Id_nivel_danza_seq" OWNER TO postgres;

--
-- Name: Nivel_Danza_Id_nivel_danza_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Nivel_Danza_Id_nivel_danza_seq" OWNED BY public."Nivel_Danza"."Id_nivel_danza";


--
-- Name: Nivel_Escolar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Nivel_Escolar" (
    "Id_nivel" integer NOT NULL,
    nivel character varying(30)
);


ALTER TABLE public."Nivel_Escolar" OWNER TO postgres;

--
-- Name: Nivel_Escolar_Id_nivel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Nivel_Escolar_Id_nivel_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Nivel_Escolar_Id_nivel_seq" OWNER TO postgres;

--
-- Name: Nivel_Escolar_Id_nivel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Nivel_Escolar_Id_nivel_seq" OWNED BY public."Nivel_Escolar"."Id_nivel";


--
-- Name: Nota_Competencia_Estudiante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Nota_Competencia_Estudiante" (
    "Id_estudiante_competencia" integer NOT NULL,
    puntaje real NOT NULL,
    observacion character varying(255),
    "Id_nota" integer,
    "Id_competencia" integer,
    CONSTRAINT check_rango_nota CHECK (((puntaje >= (0)::double precision) AND (puntaje <= (20)::double precision)))
);


ALTER TABLE public."Nota_Competencia_Estudiante" OWNER TO postgres;

--
-- Name: Nota_Competencia_Estudiante_Id_estudiante_competencia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Nota_Competencia_Estudiante_Id_estudiante_competencia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Nota_Competencia_Estudiante_Id_estudiante_competencia_seq" OWNER TO postgres;

--
-- Name: Nota_Competencia_Estudiante_Id_estudiante_competencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Nota_Competencia_Estudiante_Id_estudiante_competencia_seq" OWNED BY public."Nota_Competencia_Estudiante"."Id_estudiante_competencia";


--
-- Name: Padre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Padre" (
    "Id_padre" integer NOT NULL,
    nombre character varying(100),
    apellido character varying(100),
    cedula character varying(20),
    profesion_padre character varying(100),
    direccion_trabajo_padre character varying(100),
    telefono character varying(12)
);


ALTER TABLE public."Padre" OWNER TO postgres;

--
-- Name: Padre_Id_padre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Padre_Id_padre_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Padre_Id_padre_seq" OWNER TO postgres;

--
-- Name: Padre_Id_padre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Padre_Id_padre_seq" OWNED BY public."Padre"."Id_padre";


--
-- Name: Pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pais" (
    "Id_pais" integer NOT NULL,
    nombre_pais character varying(100)
);


ALTER TABLE public."Pais" OWNER TO postgres;

--
-- Name: Pais_Id_pais_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Pais_Id_pais_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Pais_Id_pais_seq" OWNER TO postgres;

--
-- Name: Pais_Id_pais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pais_Id_pais_seq" OWNED BY public."Pais"."Id_pais";


--
-- Name: Parroquia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Parroquia" (
    "Id_parroquia" integer NOT NULL,
    "Id_municipio" integer,
    nombre_parroquia character varying(100)
);


ALTER TABLE public."Parroquia" OWNER TO postgres;

--
-- Name: Parroquia_Id_parroquia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Parroquia_Id_parroquia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Parroquia_Id_parroquia_seq" OWNER TO postgres;

--
-- Name: Parroquia_Id_parroquia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Parroquia_Id_parroquia_seq" OWNED BY public."Parroquia"."Id_parroquia";


--
-- Name: Periodo_Inscripcion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Periodo_Inscripcion" (
    "Id_periodo_inscripcion" integer NOT NULL,
    "Id_ano" integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    activo boolean DEFAULT false,
    creado_en timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_en timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Periodo_Inscripcion" OWNER TO postgres;

--
-- Name: TABLE "Periodo_Inscripcion"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Periodo_Inscripcion" IS 'Configuración de fechas y estado del periodo de inscripción para cada año académico.';


--
-- Name: Periodo_Inscripcion_Id_periodo_inscripcion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Periodo_Inscripcion_Id_periodo_inscripcion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Periodo_Inscripcion_Id_periodo_inscripcion_seq" OWNER TO postgres;

--
-- Name: Periodo_Inscripcion_Id_periodo_inscripcion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Periodo_Inscripcion_Id_periodo_inscripcion_seq" OWNED BY public."Periodo_Inscripcion"."Id_periodo_inscripcion";


--
-- Name: Periodo_Subida_Notas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Periodo_Subida_Notas" (
    "Id_periodo_notas" integer NOT NULL,
    "Id_ano" integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    activo boolean DEFAULT false,
    creado_en timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_en timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Periodo_Subida_Notas" OWNER TO postgres;

--
-- Name: TABLE "Periodo_Subida_Notas"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."Periodo_Subida_Notas" IS 'Configuración de fechas y estado del periodo de subida de notas para cada año académico.';


--
-- Name: Periodo_Subida_Notas_Id_periodo_notas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Periodo_Subida_Notas_Id_periodo_notas_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Periodo_Subida_Notas_Id_periodo_notas_seq" OWNER TO postgres;

--
-- Name: Periodo_Subida_Notas_Id_periodo_notas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Periodo_Subida_Notas_Id_periodo_notas_seq" OWNED BY public."Periodo_Subida_Notas"."Id_periodo_notas";


--
-- Name: Profesor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profesor" (
    "Id_profesor" integer NOT NULL,
    especialidad character varying(255),
    "Id_usuario" integer
);


ALTER TABLE public."Profesor" OWNER TO postgres;

--
-- Name: Profesor_Especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profesor_Especialidad" (
    "Id_profesor_especialidad" integer NOT NULL,
    "Id_profesor" integer NOT NULL,
    "Id_especialidad" integer NOT NULL,
    "Id_ano" integer NOT NULL,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true
);


ALTER TABLE public."Profesor_Especialidad" OWNER TO postgres;

--
-- Name: Profesor_Especialidad_Id_profesor_especialidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Profesor_Especialidad_Id_profesor_especialidad_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Profesor_Especialidad_Id_profesor_especialidad_seq" OWNER TO postgres;

--
-- Name: Profesor_Especialidad_Id_profesor_especialidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Profesor_Especialidad_Id_profesor_especialidad_seq" OWNED BY public."Profesor_Especialidad"."Id_profesor_especialidad";


--
-- Name: Profesor_Grado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profesor_Grado" (
    "Id_profesor" integer NOT NULL,
    "Id_grado" integer NOT NULL,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true,
    "Id_ano" integer NOT NULL
);


ALTER TABLE public."Profesor_Grado" OWNER TO postgres;

--
-- Name: Profesor_Id_profesor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Profesor_Id_profesor_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Profesor_Id_profesor_seq" OWNER TO postgres;

--
-- Name: Profesor_Id_profesor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Profesor_Id_profesor_seq" OWNED BY public."Profesor"."Id_profesor";


--
-- Name: Profesor_Materia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profesor_Materia" (
    "Id_profesor" integer NOT NULL,
    "Id_materia" integer NOT NULL
);


ALTER TABLE public."Profesor_Materia" OWNER TO postgres;

--
-- Name: Representante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Representante" (
    "Id_representante" integer NOT NULL,
    es_familiar boolean,
    profesion_rep character varying(100),
    direccion_trabajo_rep character varying(100),
    "Id_usuario" integer
);


ALTER TABLE public."Representante" OWNER TO postgres;

--
-- Name: Representante_Id_representante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Representante_Id_representante_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Representante_Id_representante_seq" OWNER TO postgres;

--
-- Name: Representante_Id_representante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Representante_Id_representante_seq" OWNED BY public."Representante"."Id_representante";


--
-- Name: Revision_Materia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Revision_Materia" (
    "Id_revision" integer NOT NULL,
    "Id_estudiante" integer NOT NULL,
    "Id_materia" integer NOT NULL,
    "Id_ano" integer NOT NULL,
    nota_definitiva numeric(5,2) NOT NULL,
    nota_revision numeric(5,2) DEFAULT NULL::numeric,
    estado character varying(20) DEFAULT 'pendiente'::character varying,
    observacion text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_revision timestamp without time zone,
    creado_por integer
);


ALTER TABLE public."Revision_Materia" OWNER TO postgres;

--
-- Name: Revision_Materia_Id_revision_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Revision_Materia_Id_revision_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Revision_Materia_Id_revision_seq" OWNER TO postgres;

--
-- Name: Revision_Materia_Id_revision_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Revision_Materia_Id_revision_seq" OWNED BY public."Revision_Materia"."Id_revision";


--
-- Name: Rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rol" (
    "Id_rol" integer NOT NULL,
    tipo_rol character varying(50)
);


ALTER TABLE public."Rol" OWNER TO postgres;

--
-- Name: Rol_Id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rol_Id_rol_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rol_Id_rol_seq" OWNER TO postgres;

--
-- Name: Rol_Id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rol_Id_rol_seq" OWNED BY public."Rol"."Id_rol";


--
-- Name: Seccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Seccion" (
    "Id_seccion" integer NOT NULL,
    nombre_seccion character varying(10),
    capacidad integer,
    "Id_materia" integer,
    "Id_lapso" integer,
    "Id_ano" integer NOT NULL,
    CONSTRAINT check_capacidad_seccion CHECK ((capacidad > 0))
);


ALTER TABLE public."Seccion" OWNER TO postgres;

--
-- Name: Seccion_Id_seccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Seccion_Id_seccion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Seccion_Id_seccion_seq" OWNER TO postgres;

--
-- Name: Seccion_Id_seccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Seccion_Id_seccion_seq" OWNED BY public."Seccion"."Id_seccion";


--
-- Name: Seguro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Seguro" (
    "Id_seguro" integer NOT NULL,
    tipo_seguro character varying(80)
);


ALTER TABLE public."Seguro" OWNER TO postgres;

--
-- Name: Seguro_Id_seguro_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Seguro_Id_seguro_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Seguro_Id_seguro_seq" OWNER TO postgres;

--
-- Name: Seguro_Id_seguro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Seguro_Id_seguro_seq" OWNED BY public."Seguro"."Id_seguro";


--
-- Name: Solicitud_Constancia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Solicitud_Constancia" (
    "Id_solicitud" integer NOT NULL,
    tipo_constancia character varying(50),
    fecha_solicitud timestamp without time zone,
    estatus character varying(20),
    "Id_estudiante" integer,
    "Id_representante" integer
);


ALTER TABLE public."Solicitud_Constancia" OWNER TO postgres;

--
-- Name: Solicitud_Constancia_Id_solicitud_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Solicitud_Constancia_Id_solicitud_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Solicitud_Constancia_Id_solicitud_seq" OWNER TO postgres;

--
-- Name: Solicitud_Constancia_Id_solicitud_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Solicitud_Constancia_Id_solicitud_seq" OWNED BY public."Solicitud_Constancia"."Id_solicitud";


--
-- Name: Tipo_Clase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tipo_Clase" (
    "Id_tipo_clase" integer NOT NULL,
    nombre_tipo_clase character varying(30)
);


ALTER TABLE public."Tipo_Clase" OWNER TO postgres;

--
-- Name: Tipo_Clase_Id_tipo_clase_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Tipo_Clase_Id_tipo_clase_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tipo_Clase_Id_tipo_clase_seq" OWNER TO postgres;

--
-- Name: Tipo_Clase_Id_tipo_clase_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Tipo_Clase_Id_tipo_clase_seq" OWNED BY public."Tipo_Clase"."Id_tipo_clase";


--
-- Name: Tipo_Evaluacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tipo_Evaluacion" (
    "Id_tipo_evaluacion" integer NOT NULL,
    nombre_evaluacion character varying(50)
);


ALTER TABLE public."Tipo_Evaluacion" OWNER TO postgres;

--
-- Name: Tipo_Evaluacion_Id_tipo_evaluacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Tipo_Evaluacion_Id_tipo_evaluacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tipo_Evaluacion_Id_tipo_evaluacion_seq" OWNER TO postgres;

--
-- Name: Tipo_Evaluacion_Id_tipo_evaluacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Tipo_Evaluacion_Id_tipo_evaluacion_seq" OWNED BY public."Tipo_Evaluacion"."Id_tipo_evaluacion";


--
-- Name: Usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Usuario" (
    "Id_usuario" integer NOT NULL,
    cedula character varying(50),
    nombre character varying(150),
    apellido character varying(150),
    clave character varying(100),
    telefono character varying(100),
    correo character varying(255),
    fecha_nacimiento date,
    genero character varying(20),
    foto_usuario character varying(255),
    estatus_usuario character varying(20),
    creado_en timestamp with time zone,
    actualizado_en timestamp with time zone,
    "Id_rol" integer,
    "Id_direccion" integer,
    username character varying(100),
    security_word character varying(100),
    respuesta_de_seguridad character varying(100),
    password_reset_token character varying(255),
    password_reset_expires timestamp without time zone,
    email_verification_token character varying(255),
    email_verified boolean DEFAULT false,
    last_login timestamp without time zone,
    personal_id integer
);


ALTER TABLE public."Usuario" OWNER TO postgres;

--
-- Name: Usuario_Id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Usuario_Id_usuario_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Usuario_Id_usuario_seq" OWNER TO postgres;

--
-- Name: Usuario_Id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Usuario_Id_usuario_seq" OWNED BY public."Usuario"."Id_usuario";


--
-- Name: Usuario_Rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Usuario_Rol" (
    "Id_usuario" integer NOT NULL,
    "Id_rol" integer NOT NULL,
    creado_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Usuario_Rol" OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id_category integer NOT NULL,
    name_category character varying(100),
    description text
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_id_category_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.category ALTER COLUMN id_category ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.category_id_category_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id_customer integer NOT NULL,
    id_user integer,
    shipping_address text,
    purchase_limit numeric(10,2)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_id_customer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.customer ALTER COLUMN id_customer ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.customer_id_customer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id_department integer NOT NULL,
    name_departament character varying(100),
    description text
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_id_department_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.department ALTER COLUMN id_department ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.department_id_department_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: details_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.details_order (
    id_details integer NOT NULL,
    id_order integer,
    id_product integer,
    description text
);


ALTER TABLE public.details_order OWNER TO postgres;

--
-- Name: details_order_id_details_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.details_order ALTER COLUMN id_details ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.details_order_id_details_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    id_employee integer NOT NULL,
    id_user integer,
    phone_number character varying(15),
    commission numeric(5,2)
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employee ALTER COLUMN id_employee ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.employee_id_employee_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id_order integer NOT NULL,
    id_customer integer,
    id_employee integer,
    order_date timestamp without time zone,
    state public.order_state_enum,
    total numeric(10,2)
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_id_order_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."order" ALTER COLUMN id_order ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.order_id_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id_product integer NOT NULL,
    id_category integer,
    id_department integer,
    name_product character varying(100),
    description text,
    price numeric(10,2)
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_id_product_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.product ALTER COLUMN id_product ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.product_id_product_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    id_report integer NOT NULL,
    id_order integer,
    report_type public.report_type_enum,
    generated_by integer,
    generation_date timestamp without time zone,
    description text
);


ALTER TABLE public.report OWNER TO postgres;

--
-- Name: report_id_report_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.report ALTER COLUMN id_report ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.report_id_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id_role integer NOT NULL,
    name_role character varying(20),
    permissions text
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: role_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.role ALTER COLUMN id_role ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.role_id_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    id_stock integer NOT NULL,
    id_product integer,
    movement_type public.movement_type_enum,
    quantity integer,
    movement_date timestamp without time zone,
    note_stock text
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: stock_id_stock_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stock ALTER COLUMN id_stock ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stock_id_stock_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id_user integer NOT NULL,
    id_role integer,
    dni character varying(9),
    user_name character varying(10),
    password character varying(10),
    first_name character varying(50),
    last_name character varying(50),
    email character varying(100) NOT NULL,
    address character varying(100)
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."user" ALTER COLUMN id_user ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Acta_Promocion Id_acta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acta_Promocion" ALTER COLUMN "Id_acta" SET DEFAULT nextval('public."Acta_Promocion_Id_acta_seq"'::regclass);


--
-- Name: Ano_Academico Id_ano; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ano_Academico" ALTER COLUMN "Id_ano" SET DEFAULT nextval('public."Ano_Academico_Id_ano_seq"'::regclass);


--
-- Name: Asistencia Id_asistencia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Asistencia" ALTER COLUMN "Id_asistencia" SET DEFAULT nextval('public."Asistencia_Id_asistencia_seq"'::regclass);


--
-- Name: Aula Id_aula; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula" ALTER COLUMN "Id_aula" SET DEFAULT nextval('public."Aula_Id_aula_seq"'::regclass);


--
-- Name: Bloque_Horario Id_bloque; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bloque_Horario" ALTER COLUMN "Id_bloque" SET DEFAULT nextval('public."Bloque_Horario_Id_bloque_seq"'::regclass);


--
-- Name: Boleta_Notas Id_boleta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas" ALTER COLUMN "Id_boleta" SET DEFAULT nextval('public."Boleta_Notas_Id_boleta_seq"'::regclass);


--
-- Name: Boletin_Estudiante id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boletin_Estudiante" ALTER COLUMN id SET DEFAULT nextval('public."Boletin_Estudiante_id_seq"'::regclass);


--
-- Name: Carga_Nota Id_nota; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carga_Nota" ALTER COLUMN "Id_nota" SET DEFAULT nextval('public."Carga_Nota_Id_nota_seq"'::regclass);


--
-- Name: Ciudad Id_ciudad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad" ALTER COLUMN "Id_ciudad" SET DEFAULT nextval('public."Ciudad_Id_ciudad_seq"'::regclass);


--
-- Name: Competencia Id_competencia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Competencia" ALTER COLUMN "Id_competencia" SET DEFAULT nextval('public."Competencia_Id_competencia_seq"'::regclass);


--
-- Name: Detalles_Reporte Id_detalles_reporte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Detalles_Reporte" ALTER COLUMN "Id_detalles_reporte" SET DEFAULT nextval('public."Detalles_Reporte_Id_detalles_reporte_seq"'::regclass);


--
-- Name: Dia Id_dia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dia" ALTER COLUMN "Id_dia" SET DEFAULT nextval('public."Dia_Id_dia_seq"'::regclass);


--
-- Name: Direccion Id_direccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Direccion" ALTER COLUMN "Id_direccion" SET DEFAULT nextval('public."Direccion_Id_direccion_seq"'::regclass);


--
-- Name: Escuela_Regular Id_escuela; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Escuela_Regular" ALTER COLUMN "Id_escuela" SET DEFAULT nextval('public."Escuela_Regular_Id_escuela_seq"'::regclass);


--
-- Name: Especialidad Id_especialidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Especialidad" ALTER COLUMN "Id_especialidad" SET DEFAULT nextval('public."Especialidad_Id_especialidad_seq"'::regclass);


--
-- Name: Estado Id_estado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estado" ALTER COLUMN "Id_estado" SET DEFAULT nextval('public."Estado_Id_estado_seq"'::regclass);


--
-- Name: Estructura_Evaluacion Id_estructura_evaluacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estructura_Evaluacion" ALTER COLUMN "Id_estructura_evaluacion" SET DEFAULT nextval('public."Estructura_Evaluacion_Id_estructura_evaluacion_seq"'::regclass);


--
-- Name: Estudiante Id_estudiante; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante" ALTER COLUMN "Id_estudiante" SET DEFAULT nextval('public."Estudiante_Id_estudiante_seq"'::regclass);


--
-- Name: Estudiante_Seccion Id_estudiante_seccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion" ALTER COLUMN "Id_estudiante_seccion" SET DEFAULT nextval('public."Estudiante_Seccion_Id_estudiante_seccion_seq"'::regclass);


--
-- Name: Grado Id_grado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Grado" ALTER COLUMN "Id_grado" SET DEFAULT nextval('public."Grado_Id_grado_seq"'::regclass);


--
-- Name: Historial_Medico Id_historial; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial_Medico" ALTER COLUMN "Id_historial" SET DEFAULT nextval('public."Historial_Medico_Id_historial_seq"'::regclass);


--
-- Name: Horario Id_horario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario" ALTER COLUMN "Id_horario" SET DEFAULT nextval('public."Horario_Id_horario_seq"'::regclass);


--
-- Name: Incidencia Id_incidencia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Incidencia" ALTER COLUMN "Id_incidencia" SET DEFAULT nextval('public."Incidencia_Id_incidencia_seq"'::regclass);


--
-- Name: Lapso Id_lapso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lapso" ALTER COLUMN "Id_lapso" SET DEFAULT nextval('public."Lapso_Id_lapso_seq"'::regclass);


--
-- Name: Materia Id_materia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Materia" ALTER COLUMN "Id_materia" SET DEFAULT nextval('public."Materia_Id_materia_seq"'::regclass);


--
-- Name: Municipio Id_municipio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Municipio" ALTER COLUMN "Id_municipio" SET DEFAULT nextval('public."Municipio_Id_municipio_seq"'::regclass);


--
-- Name: Nivel_Danza Id_nivel_danza; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nivel_Danza" ALTER COLUMN "Id_nivel_danza" SET DEFAULT nextval('public."Nivel_Danza_Id_nivel_danza_seq"'::regclass);


--
-- Name: Nivel_Escolar Id_nivel; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nivel_Escolar" ALTER COLUMN "Id_nivel" SET DEFAULT nextval('public."Nivel_Escolar_Id_nivel_seq"'::regclass);


--
-- Name: Nota_Competencia_Estudiante Id_estudiante_competencia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nota_Competencia_Estudiante" ALTER COLUMN "Id_estudiante_competencia" SET DEFAULT nextval('public."Nota_Competencia_Estudiante_Id_estudiante_competencia_seq"'::regclass);


--
-- Name: Padre Id_padre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Padre" ALTER COLUMN "Id_padre" SET DEFAULT nextval('public."Padre_Id_padre_seq"'::regclass);


--
-- Name: Pais Id_pais; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pais" ALTER COLUMN "Id_pais" SET DEFAULT nextval('public."Pais_Id_pais_seq"'::regclass);


--
-- Name: Parroquia Id_parroquia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Parroquia" ALTER COLUMN "Id_parroquia" SET DEFAULT nextval('public."Parroquia_Id_parroquia_seq"'::regclass);


--
-- Name: Periodo_Inscripcion Id_periodo_inscripcion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Inscripcion" ALTER COLUMN "Id_periodo_inscripcion" SET DEFAULT nextval('public."Periodo_Inscripcion_Id_periodo_inscripcion_seq"'::regclass);


--
-- Name: Periodo_Subida_Notas Id_periodo_notas; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Subida_Notas" ALTER COLUMN "Id_periodo_notas" SET DEFAULT nextval('public."Periodo_Subida_Notas_Id_periodo_notas_seq"'::regclass);


--
-- Name: Profesor Id_profesor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor" ALTER COLUMN "Id_profesor" SET DEFAULT nextval('public."Profesor_Id_profesor_seq"'::regclass);


--
-- Name: Profesor_Especialidad Id_profesor_especialidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad" ALTER COLUMN "Id_profesor_especialidad" SET DEFAULT nextval('public."Profesor_Especialidad_Id_profesor_especialidad_seq"'::regclass);


--
-- Name: Representante Id_representante; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Representante" ALTER COLUMN "Id_representante" SET DEFAULT nextval('public."Representante_Id_representante_seq"'::regclass);


--
-- Name: Revision_Materia Id_revision; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Revision_Materia" ALTER COLUMN "Id_revision" SET DEFAULT nextval('public."Revision_Materia_Id_revision_seq"'::regclass);


--
-- Name: Rol Id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rol" ALTER COLUMN "Id_rol" SET DEFAULT nextval('public."Rol_Id_rol_seq"'::regclass);


--
-- Name: Seccion Id_seccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion" ALTER COLUMN "Id_seccion" SET DEFAULT nextval('public."Seccion_Id_seccion_seq"'::regclass);


--
-- Name: Seguro Id_seguro; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seguro" ALTER COLUMN "Id_seguro" SET DEFAULT nextval('public."Seguro_Id_seguro_seq"'::regclass);


--
-- Name: Solicitud_Constancia Id_solicitud; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Solicitud_Constancia" ALTER COLUMN "Id_solicitud" SET DEFAULT nextval('public."Solicitud_Constancia_Id_solicitud_seq"'::regclass);


--
-- Name: Tipo_Clase Id_tipo_clase; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tipo_Clase" ALTER COLUMN "Id_tipo_clase" SET DEFAULT nextval('public."Tipo_Clase_Id_tipo_clase_seq"'::regclass);


--
-- Name: Tipo_Evaluacion Id_tipo_evaluacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tipo_Evaluacion" ALTER COLUMN "Id_tipo_evaluacion" SET DEFAULT nextval('public."Tipo_Evaluacion_Id_tipo_evaluacion_seq"'::regclass);


--
-- Name: Usuario Id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario" ALTER COLUMN "Id_usuario" SET DEFAULT nextval('public."Usuario_Id_usuario_seq"'::regclass);


--
-- Data for Name: Acta_Promocion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Acta_Promocion" ("Id_acta", numero_acta, "Id_estudiante", "Id_ano", "Id_grado_origen", "Id_grado_destino", promedio_lapso1, motivo, resolucion, autoridades, fecha_sesion, fecha_emision, estado, creado_por) FROM stdin;
\.


--
-- Data for Name: Ano_Academico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Ano_Academico" ("Id_ano", nombre_ano, estatus_ano, inicio_ano, fin_ano, activo) FROM stdin;
1	2026 - 2027	activo	2026-09-15	2027-07-31	f
3	2025 - 2026	activo	2025-09-15	2026-07-31	f
4	2027-2028	Activo	2027-09-01	2028-07-15	t
\.


--
-- Data for Name: Asistencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Asistencia" ("Id_asistencia", fecha_asistencia, estatus, esta_justificada, descripcion_justificacion, "Id_estudiante", "Id_seccion") FROM stdin;
\.


--
-- Data for Name: Aula; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") FROM stdin;
1	Salón Rosado	1
2	Salón Azul	1
3	Salón Violeta	3
4	Salón Amarillo	1
5	Salón Blanco	1
6	Patio	1
7	Salón Gris	1
8	Salón de Colores I	1
9	Salón de Colores II	1
10	Tarima	1
11	Placa I	1
12	Placa II	1
13	Placa III	1
14	Salón Verde	2
15	Área de Cafetín	4
16	Salón Nutrición	3
\.


--
-- Data for Name: Aula_Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Aula_Materia" ("Id_aula", "Id_materia") FROM stdin;
\.


--
-- Data for Name: Bloque_Horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Bloque_Horario" ("Id_bloque", nombre_bloque, inicio_bloque, fin_bloque) FROM stdin;
1	02:00 PM - 02:15 PM	14:00:00	14:15:00
2	02:15 PM - 02:30 PM	14:15:00	14:30:00
3	02:30 PM - 02:45 PM	14:30:00	14:45:00
4	02:45 PM - 03:00 PM	14:45:00	15:00:00
5	03:00 PM - 03:15 PM	15:00:00	15:15:00
6	03:15 PM - 03:30 PM	15:15:00	15:30:00
7	03:30 PM - 03:45 PM	15:30:00	15:45:00
8	03:45 PM - 04:00 PM	15:45:00	16:00:00
9	04:00 PM - 04:15 PM	16:00:00	16:15:00
10	04:15 PM - 04:30 PM	16:15:00	16:30:00
11	04:30 PM - 04:45 PM	16:30:00	16:45:00
12	04:45 PM - 05:00 PM	16:45:00	17:00:00
13	05:00 PM - 05:15 PM	17:00:00	17:15:00
14	05:15 PM - 05:30 PM	17:15:00	17:30:00
15	05:30 PM - 05:45 PM	17:30:00	17:45:00
16	05:45 PM - 06:00 PM	17:45:00	18:00:00
\.


--
-- Data for Name: Boleta_Notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Boleta_Notas" ("Id_boleta", puntaje_final_lapso, fecha_emision, "Id_estudiante", "Id_lapso", "Id_materia", "Id_detalles_reporte", "Id_seccion", descargas, disponible) FROM stdin;
\.


--
-- Data for Name: Boletin_Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) FROM stdin;
1	466	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
2	236	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
3	246	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
4	273	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
5	570	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
6	244	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
7	499	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
8	118	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
9	370	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
10	161	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
11	330	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
12	203	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
13	433	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
14	232	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
15	312	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
16	414	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
17	371	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
18	193	3	t	2026-08-26 04:06:27.259949	2026-08-26 04:06:27.259949	0
\.


--
-- Data for Name: Carga_Nota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") FROM stdin;
1	16	t	466	1
2	19	t	466	2
3	16	t	466	3
4	12	t	466	4
5	12	t	466	5
6	7	t	466	6
7	16	t	466	7
8	17	t	466	8
9	17	t	466	9
10	18	t	466	10
11	18	t	466	11
12	18	t	466	12
13	17	t	466	13
14	16	t	466	14
15	16	t	466	15
16	16	t	466	16
17	14	t	466	17
18	15	t	466	18
19	14	t	236	1
20	19	t	236	2
21	18	t	236	3
22	13	t	236	4
23	13	t	236	5
24	10	t	236	6
25	16	t	236	7
26	17	t	236	8
27	17	t	236	9
28	18	t	236	10
29	19	t	236	11
30	19	t	236	12
31	15	t	236	13
32	16	t	236	14
33	12	t	236	15
34	18	t	236	16
35	13	t	236	17
36	13	t	236	18
37	18	t	246	1
38	20	t	246	2
39	16	t	246	3
40	13	t	246	4
41	14	t	246	5
42	12	t	246	6
43	15	t	246	7
44	18	t	246	8
45	17	t	246	9
46	20	t	246	10
47	20	t	246	11
48	20	t	246	12
49	18	t	246	13
50	18	t	246	14
51	17	t	246	15
52	20	t	246	16
53	15	t	246	17
54	15	t	246	18
55	17	t	273	19
56	18	t	273	20
57	18	t	273	21
58	17	t	273	22
59	16	t	273	23
60	14	t	273	24
61	15	t	273	25
62	16	t	273	26
63	17	t	273	27
64	17	t	273	28
65	19	t	273	29
66	18	t	273	30
67	17	t	273	31
68	17	t	273	32
69	18	t	273	33
70	19	t	273	34
71	20	t	273	35
72	16	t	273	36
73	17	t	273	37
74	17	t	570	19
75	19	t	570	20
76	18	t	570	21
77	19	t	570	22
78	17	t	570	23
79	17	t	570	24
80	18	t	570	25
81	19	t	570	26
82	18	t	570	27
83	16	t	570	28
84	20	t	570	29
85	17	t	570	30
86	18	t	570	31
87	17	t	570	32
88	18	t	570	33
89	19	t	570	34
90	20	t	570	35
91	16	t	570	36
92	17	t	570	37
93	16	t	244	19
94	15	t	244	20
95	15	t	244	21
96	17	t	244	22
97	15	t	244	23
98	14	t	244	24
99	17	t	244	25
100	17	t	244	26
101	18	t	244	27
102	16	t	244	28
103	17	t	244	29
104	16	t	244	30
105	18	t	244	31
106	18	t	244	32
107	16	t	244	33
108	17	t	244	34
109	20	t	244	35
110	16	t	244	36
111	16	t	244	37
112	16	t	499	19
113	16	t	499	20
114	16	t	499	21
115	18	t	499	22
116	16	t	499	23
117	14	t	499	24
118	17	t	499	25
119	18	t	499	26
120	19	t	499	27
121	16	t	499	28
122	17	t	499	29
123	17	t	499	30
124	17	t	499	31
125	17	t	499	32
126	18	t	499	33
127	19	t	499	34
128	20	t	499	35
129	17	t	499	36
130	17	t	499	37
131	15	t	118	38
132	13	t	118	39
133	14	t	118	40
134	17	t	118	41
135	17	t	118	42
136	16	t	118	43
137	15	t	118	44
138	16	t	118	45
139	15	t	118	46
140	16	t	118	47
141	17	t	118	48
142	18	t	118	49
143	17	t	118	50
144	20	t	118	51
145	15	t	118	52
146	17	t	118	53
147	18	t	370	38
148	18	t	370	39
149	16	t	370	40
150	18	t	370	41
151	19	t	370	42
152	18	t	370	43
153	15	t	370	44
154	18	t	370	45
155	17	t	370	46
156	18	t	370	47
157	17	t	370	48
158	18	t	370	49
159	18	t	370	50
160	20	t	370	51
161	17	t	370	52
162	18	t	370	53
163	16	t	161	38
164	16	t	161	39
165	15	t	161	40
166	18	t	161	41
167	18	t	161	42
168	13	t	161	43
169	18	t	161	44
170	18	t	161	45
171	18	t	161	46
172	18	t	161	47
173	17	t	161	48
174	17	t	161	49
175	18	t	161	50
176	20	t	161	51
177	17	t	161	52
178	18	t	161	53
179	18	t	330	54
180	18	t	330	55
181	19	t	330	56
182	16	t	330	57
183	14	t	330	58
184	11	t	330	59
185	17	t	330	60
186	16	t	330	61
187	16	t	330	62
188	19	t	330	63
189	19	t	330	64
190	20	t	330	65
191	17	t	330	66
192	17	t	330	67
193	12	t	330	68
194	17	t	330	69
195	18	t	330	70
196	16	t	330	71
197	17	t	330	72
198	17	t	203	54
199	13	t	203	55
200	17	t	203	56
201	13	t	203	57
202	10	t	203	58
203	8	t	203	59
204	17	t	203	60
205	16	t	203	61
206	16	t	203	62
207	18	t	203	63
208	14	t	203	64
209	20	t	203	65
210	18	t	203	66
211	17	t	203	67
212	13	t	203	68
213	15	t	203	69
214	17	t	203	70
215	14	t	203	71
216	16	t	203	72
217	16	t	433	54
218	18	t	433	55
219	16	t	433	56
220	16	t	433	57
221	14	t	433	58
222	13	t	433	59
223	17	t	433	60
224	16	t	433	61
225	16	t	433	62
226	16	t	433	63
227	17	t	433	64
228	18	t	433	65
229	16	t	433	66
230	14	t	433	67
231	13	t	433	68
232	16	t	433	69
233	17	t	433	70
234	10	t	433	71
235	14	t	433	72
236	18	t	232	54
237	14	t	232	55
238	16	t	232	56
239	14	t	232	57
240	12	t	232	58
241	3	t	232	59
242	17	t	232	60
243	16	t	232	61
244	16	t	232	62
245	18	t	232	63
246	12	t	232	64
247	20	t	232	65
248	18	t	232	66
249	17	t	232	67
250	14	t	232	68
251	16	t	232	69
252	17	t	232	70
253	16	t	232	71
254	17	t	232	72
255	15	t	312	73
256	17	t	312	74
257	17	t	312	75
258	13	t	312	76
259	13	t	312	77
260	12	t	312	78
261	17	t	312	79
262	15	t	312	80
263	15	t	312	81
264	18	t	312	82
265	18	t	312	83
266	17	t	312	84
267	19	t	312	85
268	20	t	312	86
269	18	t	312	87
270	15	t	414	73
271	16	t	414	74
272	14	t	414	75
273	7	t	414	76
274	4	t	414	77
275	0	t	414	78
276	16	t	414	79
277	13	t	414	80
278	14	t	414	81
279	17	t	414	82
280	15	t	414	83
281	17	t	414	84
282	18	t	414	85
283	20	t	414	86
284	18	t	414	87
285	18	t	371	73
286	19	t	371	74
287	18	t	371	75
288	14	t	371	76
289	14	t	371	77
290	16	t	371	78
291	14	t	371	79
292	18	t	371	80
293	16	t	371	81
294	18	t	371	82
295	17	t	371	83
296	17	t	371	84
297	20	t	371	85
298	20	t	371	86
299	20	t	371	87
300	17	t	193	73
301	18	t	193	74
302	16	t	193	75
303	14	t	193	76
304	13	t	193	77
305	16	t	193	78
306	13	t	193	79
307	18	t	193	80
308	15	t	193	81
309	17	t	193	82
310	15	t	193	83
311	17	t	193	84
312	15	t	193	85
313	20	t	193	86
314	17	t	193	87
\.


--
-- Data for Name: Ciudad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Ciudad" ("Id_ciudad", "Id_parroquia", nombre_ciudad) FROM stdin;
\.


--
-- Data for Name: Competencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Competencia" ("Id_competencia", nombre_competencia, description, "Id_materia") FROM stdin;
\.


--
-- Data for Name: Detalles_Reporte; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Detalles_Reporte" ("Id_detalles_reporte", detalles) FROM stdin;
\.


--
-- Data for Name: Dia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Dia" ("Id_dia", nombre_dia) FROM stdin;
1	Lunes
2	Martes
3	Miércoles
4	Jueves
5	Viernes
6	Sábado
7	Domingo
\.


--
-- Data for Name: Direccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Direccion" ("Id_direccion", "Id_ciudad", nombre_direccion) FROM stdin;
\.


--
-- Data for Name: Escuela_Regular; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Escuela_Regular" ("Id_escuela", nombre_escuela) FROM stdin;
\.


--
-- Data for Name: Especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Especialidad" ("Id_especialidad", nombre_especialidad, descripcion, area, activo, creado_en) FROM stdin;
7	Danza Clásica	Formación especializada en técnica clásica académica y repertorio.	Clásica	t	2026-08-26 03:08:57.769491
8	Danza Tradicional	Formación especializada en bailes tradicionales venezolanos, latinoamericanos y cultura popular.	Tradicional	t	2026-08-26 03:08:57.769491
9	Danza Contemporánea	Formación especializada en técnicas contemporáneas, expresión corporal y composición.	Contemporánea	t	2026-08-26 03:08:57.769491
\.


--
-- Data for Name: Estado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estado" ("Id_estado", "Id_pais", nombre_estado) FROM stdin;
\.


--
-- Data for Name: Estructura_Evaluacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") FROM stdin;
1	1	100	1	2	4
2	1	100	2	2	5
3	1	100	3	2	6
4	1	100	4	2	4
5	1	100	5	2	5
6	1	100	6	2	6
7	1	100	7	2	4
8	1	100	8	2	5
9	1	100	9	2	6
10	1	100	10	2	4
11	1	100	11	2	5
12	1	100	12	2	6
13	1	100	13	2	4
14	1	100	14	2	5
15	1	100	15	2	4
16	1	100	16	2	5
17	1	100	17	2	4
18	1	100	18	2	5
19	1	100	19	2	4
20	1	100	20	2	5
21	1	100	21	2	6
22	1	100	22	2	4
23	1	100	23	2	5
24	1	100	24	2	6
25	1	100	25	2	4
26	1	100	26	2	5
27	1	100	27	2	6
28	1	100	28	2	4
29	1	100	29	2	5
30	1	100	30	2	6
31	1	100	31	2	4
32	1	100	32	2	5
33	1	100	33	2	4
34	1	100	34	2	5
35	1	100	35	2	6
36	1	100	36	2	4
37	1	100	37	2	5
38	1	100	38	2	4
39	1	100	39	2	5
40	1	100	40	2	6
41	1	100	41	2	4
42	1	100	42	2	5
43	1	100	43	2	6
44	1	100	44	2	4
45	1	100	45	2	5
46	1	100	46	2	6
47	1	100	47	2	4
48	1	100	48	2	5
49	1	100	49	2	4
50	1	100	50	2	5
51	1	100	51	2	6
52	1	100	52	2	4
53	1	100	53	2	5
54	1	100	54	2	4
55	1	100	55	2	5
56	1	100	56	2	6
57	1	100	57	2	4
58	1	100	58	2	5
59	1	100	59	2	6
60	1	100	60	2	4
61	1	100	61	2	5
62	1	100	62	2	6
63	1	100	63	2	4
64	1	100	64	2	5
65	1	100	65	2	6
66	1	100	66	2	4
67	1	100	67	2	5
68	1	100	68	2	4
69	1	100	69	2	5
70	1	100	70	2	4
71	1	100	71	2	5
72	1	100	72	2	6
73	1	100	73	2	4
74	1	100	74	2	5
75	1	100	75	2	6
76	1	100	76	2	4
77	1	100	77	2	5
78	1	100	78	2	6
79	1	100	79	2	4
80	1	100	80	2	5
81	1	100	81	2	6
82	1	100	82	2	4
83	1	100	83	2	5
84	1	100	84	2	6
85	1	100	85	2	4
86	1	100	86	2	5
87	1	100	87	2	6
\.


--
-- Data for Name: Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial", estatus) FROM stdin;
570	ZOE JOHENNY	ARIAS VIVAS	EST-ACTA-7723	2010-01-01	Femenino	f	\N	\N	\N	\N	\N	\N	Activo
106	ADRIÁN MOISES	RAMÍREZ RIVERA	EST-1002	2006-02-15	Femenino	f	\N	10	\N	\N	68	106	Activo
107	ADRIANA MASSIEL	MONTILVA BECERRA	EST-1003	2013-05-28	Femenino	f	\N	8	\N	\N	69	107	Activo
108	ADRIANA STEFANÍA	SUAREZ SANGUINO	EST-1004	2011-07-05	Femenino	f	\N	9	\N	\N	70	108	Activo
109	ADRIANA STEFANÍA	SUAREZ SANGUINO	EST-1005	2011-07-05	Femenino	f	\N	10	\N	\N	70	109	Activo
110	ADRIANA VALENTINA	ESCALANTE RAMÍREZ	EST-1006	2016-06-03	Femenino	f	\N	6	\N	\N	71	110	Activo
111	ADRIANA VICTORIA	HERNÁNDEZ HERNÁNDEZ	EST-1007	2017-03-22	Femenino	f	\N	25	\N	\N	72	111	Activo
112	AIMEE SOFIA	BECERRA PRIETO	EST-1008	2014-07-21	Femenino	f	\N	8	\N	\N	73	112	Activo
113	AIMEE SOFIA	BECERRA PRIETO	EST-1009	2014-07-21	Femenino	f	\N	7	\N	\N	74	113	Activo
114	ALEEZA VALENTINA	CAMPEROS RODRIGUEZ	EST-1010	2008-10-17	Femenino	f	\N	14	\N	\N	74	114	Activo
115	ALEEZA VALENTINA	CAMPEROS RODRIGUEZ	EST-1011	2008-10-17	Femenino	f	\N	13	\N	\N	74	115	Activo
116	ALEEZA VALENTINA	CAMPEROS RODRIGUEZ	EST-1012	2008-10-17	Femenino	f	\N	12	\N	\N	75	116	Activo
117	ALICIA NATHALY	SARRIA GARCIA	EST-1013	2013-06-11	Femenino	f	\N	25	\N	\N	76	117	Activo
118	ALLISON NATHALI	AMAYA RAMIREZ	EST-1014	2011-07-31	Femenino	f	\N	\N	\N	\N	76	118	Activo
119	ALLISON NATHALÍ	AMAYA RAMÍREZ	EST-1015	2011-07-31	Femenino	f	\N	9	\N	\N	76	119	Activo
120	ALLISON NATHALÍ	AMAYA RAMÍREZ	EST-1016	2011-07-31	Femenino	f	\N	10	\N	\N	77	120	Activo
121	ALLISON SOPHIA	CARRERO PULIDO	EST-1017	2013-07-01	Femenino	f	\N	7	\N	\N	77	121	Activo
122	ALLISON SOPHIA	CARRERO PULIDO	EST-1018	2013-07-01	Femenino	f	\N	8	\N	\N	77	122	Activo
123	ALLISON SOPHIA	CARRERO PULIDO	EST-1019	2013-07-01	Femenino	f	\N	8	\N	\N	78	123	Activo
124	ALLISON SOPHIA	CARRERO PULIDO	EST-1020	2013-07-01	Femenino	f	\N	8	\N	\N	79	124	Activo
125	ALONDRA DE LOS ANGELES	ACOSTA NAVA	EST-1021	2006-06-23	Femenino	f	\N	21	\N	\N	79	125	Activo
126	ALONDRA DE LOS ANGELES	ACOSTA NAVA	EST-1022	2006-06-23	Femenino	f	\N	21	\N	\N	80	126	Activo
127	ALONDRA DE LOS ANGELES	ACOSTA NAVA	EST-1023	2006-06-23	Femenino	f	\N	\N	\N	\N	81	127	Activo
128	ALONDRA SOFIA	DAVILA BECERRA	EST-1024	2013-06-04	Femenino	f	\N	8	\N	\N	82	128	Activo
129	ALVRANNY SAHIELA	TARAZONA COLMENARES	EST-1025	2017-06-25	Femenino	f	\N	25	\N	\N	83	129	Activo
130	AMANDITH GABRIELA	DURÁN RUÍZ	EST-1026	2004-08-12	Femenino	f	\N	22	\N	\N	84	130	Activo
131	AMBAR LISETH	MOLINA CAÑAS	EST-1027	2016-02-12	Femenino	f	\N	6	\N	\N	85	131	Activo
132	AMBAR LISETH	MOLINA CAÑAS	EST-1028	2016-02-12	Femenino	f	\N	6	\N	\N	86	132	Activo
133	AMBAR MANUELA	BORRERO PERNIA	EST-1029	2012-08-30	Femenino	f	\N	7	\N	\N	87	133	Activo
134	AMY ANTONELLA	ALVARADO RUIZ	EST-1030	2013-06-07	Femenino	f	\N	9	\N	\N	87	134	Activo
135	AMY ANTONELLA	ALVARADO RUIZ	EST-1031	2013-06-07	Femenino	f	\N	7	\N	\N	88	135	Activo
136	ANA ISABELLA	PINEDA ESCALANTE	EST-1032	2015-06-29	Femenino	f	\N	6	\N	\N	88	136	Activo
137	ANA ISABELLA	PINEDA ESCALANTE	EST-1033	2015-06-29	Femenino	f	\N	7	\N	\N	89	137	Activo
138	ANDREA ALEJANDRA	BARRIOS VIVAS	EST-1034	2002-06-01	Femenino	f	\N	22	\N	\N	90	138	Activo
139	ANDREA DANIELA	VIVAS CARRIEDO	EST-1035	2005-08-30	Femenino	f	\N	16	\N	\N	90	139	Activo
140	ANDREA DANIELA	VIVAS CARRIEDO	EST-1036	2005-08-30	Femenino	f	\N	17	\N	\N	91	140	Activo
141	ANDRY KATIUSCA	GARCIA RAMIREZ	EST-1037	2009-07-08	Femenino	f	\N	20	\N	\N	91	141	Activo
142	ANDRY KATIUSKA	GARCIA RAMIREZ	EST-1038	2009-07-08	Femenino	f	\N	20	\N	\N	92	142	Activo
143	ANELEY MONTSERRAT	NAVARRO CONTRAMAESTRE	EST-1039	2015-08-19	Femenino	f	\N	25	\N	\N	92	143	Activo
144	ANELEY MONTSERRAT	NAVARRO CONTRAMAESTRE	EST-1040	2015-08-19	Femenino	f	\N	7	\N	\N	93	144	Activo
145	ANGELA JISBERLY	MERCHAN JAIMES	EST-1041	2009-06-24	Femenino	f	\N	9	\N	\N	94	145	Activo
146	ANGELA STEFANIA	KYRIMLKOGLOU RAMIREZ	EST-1042	2007-10-25	Femenino	f	\N	22	\N	\N	95	146	Activo
147	ANGÉLICA NATHALY	PEREZ QUIROZ	EST-1043	2006-04-04	Femenino	f	\N	20	\N	\N	95	147	Activo
148	ANGÉLICA NATHALY	PÉREZ QUIROZ	EST-1044	2006-04-04	Femenino	f	\N	22	\N	\N	96	148	Activo
149	ANGELINA GISSEL	ALTUVE GELVEZ	EST-1045	2006-06-20	Femenino	f	\N	14	\N	\N	97	149	Activo
150	ANTHONELLA	DEPABLOS VIVAS	EST-1046	2013-02-19	Femenino	f	\N	7	\N	\N	98	150	Activo
151	ANTONELLA NICOLL	MEDINA FERNANDEZ	EST-1047	2009-07-10	Femenino	f	\N	20	\N	\N	98	151	Activo
152	ANTONELLA NICOLL	MEDINA FERNANDEZ	EST-1048	2009-07-10	Femenino	f	\N	\N	\N	\N	99	152	Activo
153	ANTONELLA YALIMAR	ANDRADE RICO	EST-1049	2013-05-04	Femenino	f	\N	8	\N	\N	99	153	Activo
154	ANTONELLA YALIMAR	ANDRADE RICO	EST-1050	2013-05-04	Femenino	f	\N	9	\N	\N	99	154	Activo
155	ANTONELLA YALIMAR	ANDRADE RICO	EST-1051	2013-05-04	Femenino	f	\N	7	\N	\N	99	155	Activo
156	ANTONELLA YALIMAR	ANDRADE RICO	EST-1052	2013-05-04	Femenino	f	\N	7	\N	\N	99	156	Activo
157	ANTONELLA YALIMAR	ANDRADE RICO	EST-1053	2013-05-04	Femenino	f	\N	7	\N	\N	100	157	Activo
158	ANYELA MONTSERRAT	COLMENARES DIAZ	EST-1054	2015-05-15	Femenino	f	\N	7	\N	\N	101	158	Activo
159	ANYELY CAMILA	ZAMBRANO RAMIREZ	EST-1055	2015-11-07	Femenino	f	\N	6	\N	\N	102	159	Activo
160	ARANZA GIULIANNA	CONTRERAS RODRIGUEZ	EST-1056	2016-08-04	Femenino	f	\N	25	\N	\N	103	160	Activo
161	ARIADNA ISABELLA	ROJAS RANGEL	EST-1057	2010-12-19	Femenino	f	\N	10	\N	\N	103	161	Activo
162	ARIADNA ISABELLA	ROJAS RANGEL	EST-1058	2010-12-19	Femenino	f	\N	\N	\N	\N	103	162	Activo
163	ARIADNA ISABELLA	ROJAS RANGEL	EST-1059	2010-12-19	Femenino	f	\N	9	\N	\N	103	163	Activo
164	ARIADNA ISABELLA	ROJAS RANGEL	EST-1060	2010-12-19	Femenino	f	\N	9	\N	\N	76	164	Activo
165	ARIANNA NICOLLE	AMAYA RAMÍREZ	EST-1061	2008-02-01	Femenino	f	\N	\N	\N	\N	76	165	Activo
166	ARIANNA NICOLLE	AMAYA RAMÍREZ	EST-1062	2008-02-01	Femenino	f	\N	17	\N	\N	76	166	Activo
167	ARIANNA NICOLLE	AMAYA RAMIREZ	EST-1063	2010-01-01	Femenino	f	\N	18	\N	\N	104	167	Activo
168	ARIATNA GIANELLA	BELTRAN CONTRERAS	EST-1064	2013-08-08	Femenino	f	\N	7	\N	\N	105	168	Activo
169	ARIATNA GIANELLA	BELTRAN CONTRERAS	EST-1065	2013-08-09	Femenino	f	\N	8	\N	\N	105	169	Activo
170	ARIATNA GIANELLA	BELTRAN CONTRERAS	EST-1066	2013-08-09	Femenino	f	\N	6	\N	\N	106	170	Activo
171	ASHLEY DORIAMNY	GONZALEZ GOMEZ	EST-1067	2010-06-18	Femenino	f	\N	\N	\N	\N	107	171	Activo
172	ASHLEY YADELSI	MARTINEZ CRISPIN	EST-1068	2016-02-04	Femenino	f	\N	6	\N	\N	107	172	Activo
173	ASHLEY YADELSI	MARTINEZ CRISPIN	EST-1069	2016-02-04	Femenino	f	\N	25	\N	\N	108	173	Activo
174	ASHLY DAVIANNY	ROMERO BECERRA	EST-1070	2013-08-29	Femenino	f	\N	7	\N	\N	109	174	Activo
175	ASHLYN STEISSY	CANO ZAMBRANO	EST-1071	2009-09-20	Femenino	f	\N	8	\N	\N	110	175	Activo
176	ASTRID ORIANA	JAIMES VILLAMIZAR	EST-1072	2005-03-08	Femenino	f	\N	21	\N	\N	111	176	Activo
177	AURA MICHELL	MORA CHACON	EST-1073	2008-04-02	Femenino	f	\N	18	\N	\N	112	177	Activo
178	AVRIL SOPHIA	RAY HERNÁNDEZ	EST-1074	2014-05-04	Femenino	f	\N	8	\N	\N	112	178	Activo
179	AVRIL SOPHIA	RAY HERNANDEZ	EST-1075	2014-05-04	Femenino	f	\N	7	\N	\N	113	179	Activo
180	AYLISH JOSELYN	MORALES NEIRA	EST-1076	2013-09-29	Femenino	f	\N	8	\N	\N	113	180	Activo
181	AYLISH JOSELYN	MORALES NEIRA	EST-1077	2013-12-29	Femenino	f	\N	7	\N	\N	114	181	Activo
182	AYMARA SINAHI	CACERES LEAL	EST-1078	2014-04-10	Femenino	f	\N	7	\N	\N	114	182	Activo
183	AYMARA SINAHI	CÁCERES LEAL	EST-1079	2014-04-10	Femenino	f	\N	8	\N	\N	115	183	Activo
184	BRIHANA CAMILA	ORTIZ MONTAÑEZ	EST-1080	2011-02-23	Femenino	f	\N	10	\N	\N	115	184	Activo
185	BRINYELI MANOSALVA	MANOSALVA RODRIGUEZ	EST-1081	2006-01-27	Femenino	f	\N	18	\N	\N	116	185	Activo
186	BRINYELI PAOLA	MANOSALVA RODRÍGUEZ	EST-1082	2006-01-27	Femenino	f	\N	16	\N	\N	117	186	Activo
187	BRITANY ANGELI	CONTRERAS SILVA	EST-1083	2005-12-28	Femenino	f	\N	22	\N	\N	117	187	Activo
188	BRITHANNY JOSSIE	DELGADO CONTRERAS	EST-1084	2012-02-20	Femenino	f	\N	7	\N	\N	118	188	Activo
189	BRITHANNY JOSSIE	DELGADO CONTRERAS	EST-1085	2012-02-20	Femenino	f	\N	9	\N	\N	119	189	Activo
190	BRITHANY ALEXANDRA	ARELLANO VIVAS	EST-1086	2012-05-04	Femenino	f	\N	8	\N	\N	120	190	Activo
191	BRITNY ALEJANDRA	HERNANDEZ CORREDOR	EST-1087	2015-02-20	Femenino	f	\N	25	\N	\N	121	191	Activo
192	CAMILA ALEJANDRA	BERNAL TORRES	EST-1088	2013-05-31	Femenino	f	\N	9	\N	\N	121	192	Activo
193	CAMILA ANDREA	QUEVEDO REVERÓN	EST-1089	2010-02-07	Femenino	f	\N	\N	\N	\N	122	193	Activo
194	CAMILA ANDREA	QUEVEDO REVERÓN	EST-1090	2010-02-07	Femenino	f	\N	12	\N	\N	123	194	Activo
195	CAMILA DE LOS ANGELES	MORA GUERRERO	EST-1091	2022-12-27	Femenino	f	\N	9	\N	\N	123	195	Activo
196	CAMILA DEL VALLE	SAAVEDRA CAMPOS	EST-1092	2012-04-14	Femenino	f	\N	6	\N	\N	124	196	Activo
197	CAMILA DEL VALLE	SAAVEDRA CAMPOS	EST-1093	2012-04-14	Femenino	f	\N	6	\N	\N	124	197	Activo
198	CAMILA NAIOBY	VIDAL OLIVARES	EST-1094	2008-12-08	Femenino	f	\N	13	\N	\N	124	198	Activo
199	CAMILA NAIOBY	VIDAL OLIVARES	EST-1095	2008-12-08	Femenino	f	\N	12	\N	\N	125	199	Activo
200	CAMILA NAIOBY	VIDAL OLIVARES	EST-1096	2008-12-08	Femenino	f	\N	13	\N	\N	126	200	Activo
201	CAMILA SARAI	DIAZ CONTRERAS	EST-1097	2014-01-20	Femenino	f	\N	7	\N	\N	127	201	Activo
202	CAMILA SARAI	DIAZ CONTRERAS	EST-1098	2014-01-20	Femenino	f	\N	8	\N	\N	127	202	Activo
203	CAMILA VALENTINA	DAVILA SANCHEZ	EST-1099	2011-06-06	Femenino	f	\N	\N	\N	\N	127	203	Activo
204	CAMILA VALENTINA	DAVILA SANCHEZ	EST-1100	2011-06-06	Femenino	f	\N	\N	\N	\N	127	204	Activo
205	CAMILA VALENTINA	DAVILA SANCHEZ	EST-1101	2011-06-06	Femenino	f	\N	\N	\N	\N	127	205	Activo
206	CAMILA VALENTINA	DAVILA SANCHEZ	EST-1102	2011-06-06	Femenino	f	\N	9	\N	\N	128	206	Activo
207	CAMILA VALENTINA	DAVILA SANCHEZ	EST-1103	2011-06-06	Femenino	f	\N	10	\N	\N	114	207	Activo
208	CAMILA VICTORIA	CHACON MERCHAN	EST-1104	2014-09-01	Femenino	f	\N	7	\N	\N	114	208	Activo
209	CAMILY AMARANTA	CACERES LEAL	EST-1105	2004-10-11	Femenino	f	\N	13	\N	\N	129	209	Activo
210	CAMILY AMARANTA	CACERES LEAL	EST-1106	2004-10-11	Femenino	f	\N	14	\N	\N	130	210	Activo
211	CARLA BELÉN	MONGES GONZÁLEZ	EST-1107	2005-03-09	Femenino	f	\N	22	\N	\N	130	211	Activo
212	CARLY DANIELA	FERREIRA QUINAYAS	EST-1108	2015-04-23	Femenino	f	\N	6	\N	\N	131	212	Activo
213	CARLY DANIELA	FERREIRA QUINAYAS	EST-1109	2015-04-15	Femenino	f	\N	6	\N	\N	132	213	Activo
214	CAROLINE VALENTINA	TORRES ROJAS	EST-1110	2013-01-27	Femenino	f	\N	9	\N	\N	133	214	Activo
215	CORDERO MONCADA	SOFIA VALERIA	EST-1111	2013-07-19	Femenino	f	\N	7	\N	\N	134	215	Activo
216	CRISTAL DAYLIN	CEGARRA PEÑA	EST-1112	2016-09-02	Femenino	f	\N	25	\N	\N	135	216	Activo
217	DAIRYMAR ALEJANDRA	CONTRERAS DELGADO	EST-1113	2014-02-07	Femenino	f	\N	7	\N	\N	136	217	Activo
218	DALIA ALEXANDRA	RIVERA ZAMBRANO	EST-1114	2003-03-09	Femenino	f	\N	18	\N	\N	137	218	Activo
219	DANIELA ALEXANDRA	MONTAÑA CONTRERAS	EST-1115	2016-02-21	Femenino	f	\N	25	\N	\N	138	219	Activo
220	DANIELA VALENTINA	ZAMBRANO SANGUINO	EST-1116	2014-07-21	Femenino	f	\N	7	\N	\N	138	220	Activo
221	DANIELA VALENTINA	MONCADA RAMIREZ	EST-1117	2009-05-22	Femenino	f	\N	20	\N	\N	139	221	Activo
222	DANIELA VALENTINA	MONCADA RAMIREZ	EST-1118	2009-05-22	Femenino	f	\N	10	\N	\N	140	222	Activo
223	DANNA ALEJANDRA	MORALES CHACON	EST-1119	2009-06-12	Femenino	f	\N	8	\N	\N	141	223	Activo
224	DANNA GHELENA	CHÁVEZ HERNÁNDEZ	EST-1120	2021-05-25	Femenino	f	\N	6	\N	\N	142	224	Activo
225	DANNA GHELENA	CHAVEZ HERNADEZ	EST-1121	2015-05-25	Femenino	f	\N	7	\N	\N	143	225	Activo
226	DANNA ISABELLA	CHACÓN CONTRERAS	EST-1122	2015-12-28	Femenino	f	\N	6	\N	\N	144	226	Activo
227	DANNA SOFIA	JIMÉNEZ JIMÉNEZ	EST-1123	2010-09-23	Femenino	f	\N	9	\N	\N	144	227	Activo
228	DARIANA CAMILA	BRITO LAGUADO	EST-1124	2012-07-06	Femenino	f	\N	8	\N	\N	145	228	Activo
229	DARIANA CAMILA	BRITO LAGUADO	EST-1125	2012-07-06	Femenino	f	\N	8	\N	\N	145	229	Activo
230	DARIANA VALENTINA	CAMPOS RAMIREZ	EST-1126	2006-07-15	Femenino	f	\N	22	\N	\N	146	230	Activo
231	DARIANA VALENTINA	CAMPOS RAMIREZ	EST-1127	2006-07-15	Femenino	f	\N	22	\N	\N	146	231	Activo
232	DARY	DELGADO OCANA	EST-1128	2011-03-18	Femenino	f	\N	9	\N	\N	146	232	Activo
233	DARY	OCAÑA DELGADO	EST-1129	2010-01-01	Femenino	f	\N	10	\N	\N	147	233	Activo
234	DARY	OCANA DELGADO	EST-1130	2011-03-18	Femenino	f	\N	\N	\N	\N	147	234	Activo
235	DARYANGEL VICTORIA	CHACÓN CONTRERAS	EST-1131	2010-10-08	Femenino	f	\N	10	\N	\N	148	235	Activo
236	DARYANGEL VICTORIA	CHACON CONTRERAS	EST-1132	2010-10-08	Femenino	f	\N	9	\N	\N	149	236	Activo
237	DAVIELYS CAMILA	VIVAS TORRES	EST-1133	2017-05-05	Femenino	f	\N	25	\N	\N	150	237	Activo
238	DEILED ORIANA	RICO RUIZ	EST-1134	2008-12-22	Femenino	f	\N	20	\N	\N	150	238	Activo
239	DENNIS DANIELA	BARÓN LUM	EST-1135	2005-01-12	Femenino	f	\N	14	\N	\N	151	239	Activo
240	DENNIS DANIELA	BARON LUM	EST-1136	2005-02-12	Femenino	f	\N	14	\N	\N	151	240	Activo
241	EILYN SOPHIA	MEZA OSTOS	EST-1137	2013-11-27	Femenino	f	\N	6	\N	\N	152	241	Activo
242	EILYN SOPHIA	MEZA OSTOS	EST-1138	2013-11-27	Femenino	f	\N	7	\N	\N	153	242	Activo
243	EILYN SOPHIA	MEZA OSTOS	EST-1139	2013-11-27	Femenino	f	\N	8	\N	\N	154	243	Activo
244	EIMY JULLIETH	CONTRERAS COLMENARES	EST-1140	2011-10-27	Femenino	f	\N	\N	\N	\N	155	244	Activo
245	ELIANA ANGELINE	SANCHEZ MANRIQUE	EST-1141	2003-12-30	Femenino	f	\N	18	\N	\N	155	245	Activo
246	EMILY ALICEC	MORA GUERRERO	EST-1142	2012-02-23	Femenino	f	\N	10	\N	\N	155	246	Activo
247	EMILY ALICEC	MORA GUERRERO	EST-1143	2012-02-23	Femenino	f	\N	10	\N	\N	156	247	Activo
248	EMILY ALICEC	MORA GUERRERO	EST-1144	2012-02-23	Femenino	f	\N	10	\N	\N	157	248	Activo
249	EMILY MIRANDA	APONTE CHACON	EST-1145	2016-12-07	Femenino	f	\N	25	\N	\N	157	249	Activo
468	NELIANA	PLATA BUITRAGO	EST-1364	2011-10-29	Femenino	f	\N	8	\N	\N	151	468	Activo
250	EMILY ORIANA	CAMARGO PABLOS	EST-1146	2006-08-28	Femenino	f	\N	16	\N	\N	158	250	Activo
251	EMILY ORIANA	CAMARGO PABLOS	EST-1147	2006-08-28	Femenino	f	\N	18	\N	\N	159	251	Activo
252	ENMANUEL DIONISIO SALVATORE	PÉREZ DELGADO	EST-1148	2012-10-05	Femenino	f	\N	7	\N	\N	160	252	Activo
253	ERIKA FABIANA	GÓMEZ RÍOS	EST-1149	2004-08-17	Femenino	f	\N	22	\N	\N	160	253	Activo
254	ESTEFANY NATALY	GOMEZ CHACON	EST-1150	2009-02-16	Femenino	f	\N	16	\N	\N	161	254	Activo
255	ESTEFANY NATALY	GOMEZ CHACON	EST-1151	2009-01-01	Femenino	f	\N	\N	\N	\N	162	255	Activo
256	ESTHER NAHOMY	CARRERO SIERRA	EST-1152	2013-07-01	Femenino	f	\N	7	\N	\N	163	256	Activo
257	ETNY DANIELA	DUQUE CASTRO	EST-1153	2007-11-01	Femenino	f	\N	6	\N	\N	164	257	Activo
258	ETNY DANIELA	DUQUE CASTRO	EST-1154	2007-11-01	Femenino	f	\N	21	\N	\N	165	258	Activo
259	EVA DEL VALLE	SALAS RODRIGUEZ	EST-1155	2014-12-10	Femenino	f	\N	7	\N	\N	165	259	Activo
260	FABIANA MILENA	LEON GONZALEZ	EST-1156	2006-05-09	Femenino	f	\N	14	\N	\N	166	260	Activo
261	FABIANA MILENA	LEON GONZÁLEZ	EST-1157	2006-05-09	Femenino	f	\N	13	\N	\N	167	261	Activo
262	FABIOLA	CONTRERAS RAMÍREZ	EST-1158	2012-07-27	Femenino	f	\N	8	\N	\N	168	262	Activo
263	FIORELLA	GUERRERO LOPEZ	EST-1159	2006-09-23	Femenino	f	\N	6	\N	\N	169	263	Activo
264	FIORELLA CAMILA	JUGO FREITES	EST-1160	2013-12-27	Femenino	f	\N	8	\N	\N	168	264	Activo
265	FIORELLA SOFIA	MÁRQUEZ GARCÍA	EST-1161	2006-10-05	Femenino	f	\N	14	\N	\N	170	265	Activo
266	FLAVIA CORINA	JUGO FREITES	EST-1162	2008-11-11	Femenino	f	\N	13	\N	\N	170	266	Activo
267	FLOR MARIANFEL	REY RANGEL	EST-1163	2006-08-30	Femenino	f	\N	22	\N	\N	171	267	Activo
268	FLOR MARIANGEL	REY RANGEL	EST-1164	2006-08-30	Femenino	f	\N	20	\N	\N	172	268	Activo
269	FRANCHESKA VICMARY	GALLO ZAMBRANO	EST-1165	2014-10-03	Femenino	f	\N	7	\N	\N	173	269	Activo
270	FRANCIE GRISMAR	MONTAÑEZ VELAZCO	EST-1166	2008-07-21	Femenino	f	\N	10	\N	\N	174	270	Activo
271	FRANCIÉ GRISMAR	MONTAÑEZ VELAZCO	EST-1167	2008-07-21	Femenino	f	\N	\N	\N	\N	175	271	Activo
272	GABRIELA ALEJANDRA	ZAMBRANO URIBE	EST-1168	2014-04-16	Femenino	f	\N	7	\N	\N	176	272	Activo
273	GABRIELA ALEXANDRA	ANDRADE RUMBOS	EST-1169	2011-03-03	Femenino	f	\N	\N	\N	\N	176	273	Activo
274	GABRIELA SARAHI	RAMIREZ BALLESTEROS	EST-1170	2014-08-04	Femenino	f	\N	6	\N	\N	176	274	Activo
275	GABRIELA SARAHI	RAMIREZ BALLESTEROS	EST-1171	2014-08-04	Femenino	f	\N	7	\N	\N	177	275	Activo
276	GABRIELA SARAHI	RAMÍREZ BALLESTEROS	EST-1172	2014-08-04	Femenino	f	\N	8	\N	\N	178	276	Activo
277	GABRIELA VALENTINA	AMAYA CAMARAN	EST-1173	2006-08-04	Femenino	f	\N	22	\N	\N	177	277	Activo
278	GABRIELA VALENTINA	VERA GUERRERO	EST-1174	2014-09-04	Femenino	f	\N	25	\N	\N	177	278	Activo
279	GABRIELA VALENTINA	AMAYA CAMARAN	EST-1175	2006-08-04	Femenino	f	\N	21	\N	\N	105	279	Activo
280	GABRIELA VALENTINA	AMAYA CAMARAN	EST-1176	2006-08-04	Femenino	f	\N	21	\N	\N	105	280	Activo
281	GENESIS ADRIANA	BELTRAN CONTRERAS	EST-1177	2005-01-03	Femenino	f	\N	12	\N	\N	179	281	Activo
282	GENESIS ADRIANA	BELTRAN CONTRERAS	EST-1178	2005-01-03	Femenino	f	\N	25	\N	\N	180	282	Activo
283	GÉNESIS ALEJANDRA	ZAMBRANO POLANCO	EST-1179	2013-10-20	Femenino	f	\N	8	\N	\N	179	283	Activo
284	GÉNESIS ALEJANDRA	SANCHEZ RICO	EST-1180	2010-06-18	Femenino	f	\N	\N	\N	\N	180	284	Activo
285	GENESIS ALEJANDRA	POLANCO ZAMBRANO	EST-1181	2010-10-20	Femenino	f	\N	10	\N	\N	181	285	Activo
286	GENESIS ALEJANDRA	SANCHEZ RICO	EST-1182	2010-06-18	Femenino	f	\N	16	\N	\N	182	286	Activo
287	GENESIS ESTER	GARNICA VARGAS	EST-1183	2016-02-23	Femenino	f	\N	6	\N	\N	183	287	Activo
288	GÉNESIS KAMILA	CASTRO CALDERÓN	EST-1184	2009-02-09	Femenino	f	\N	9	\N	\N	184	288	Activo
289	GRACE MARIANGEL	OSTOS VILLAMIZAR	EST-1185	2004-09-02	Femenino	f	\N	14	\N	\N	184	289	Activo
290	GRECIA VALERIA	BECERRA ESTEVES	EST-1186	2014-01-16	Femenino	f	\N	7	\N	\N	185	290	Activo
291	GRECIA VALERIA	BECERRA ESTEVES	EST-1187	2014-01-06	Femenino	f	\N	8	\N	\N	185	291	Activo
292	GREIMAR JOSMERLY	ROVIRA SANDOVAL	EST-1188	2012-07-04	Femenino	f	\N	9	\N	\N	185	292	Activo
293	GREIMAR JOSMERLY	ROVIRA SANDOVAL	EST-1189	2012-07-04	Femenino	f	\N	8	\N	\N	186	293	Activo
294	GREIMARJOSMERLY	ROVIRA SANDOVAL	EST-1190	2012-07-04	Femenino	f	\N	10	\N	\N	187	294	Activo
295	HANIRY ISBELLA	USECHE MENDEZ	EST-1191	2014-06-27	Femenino	f	\N	8	\N	\N	188	295	Activo
296	HANNA JISET	DUQUE PRATO	EST-1192	2002-10-04	Femenino	f	\N	18	\N	\N	189	296	Activo
297	HARIADNE RUBEILYS	LOSADA FUENTES	EST-1193	2018-08-31	Femenino	f	\N	25	\N	\N	190	297	Activo
298	HASLETH NICKOLL	SANABRIA CARDENAS	EST-1194	2010-01-20	Femenino	f	\N	10	\N	\N	191	298	Activo
299	HEIZEL FERNANDA	MONSALVE	EST-1195	2009-01-01	Femenino	f	\N	\N	\N	\N	192	299	Activo
300	HEIZEL FERNANDA	MONSALVE	EST-1196	2010-01-01	Femenino	f	\N	10	\N	\N	193	300	Activo
301	HEIZEL FERNANDA	MONSALVE	EST-1197	2010-01-01	Femenino	f	\N	10	\N	\N	194	301	Activo
302	HEIZEL FERNANDA	MONSALVE	EST-1198	2010-01-01	Femenino	f	\N	10	\N	\N	195	302	Activo
303	HEIZEL FERNANDA	MONSALVE	EST-1199	2010-01-01	Femenino	f	\N	10	\N	\N	196	303	Activo
304	HEIZEL FERNANDA	MONSALVE	EST-1200	2010-01-01	Femenino	f	\N	10	\N	\N	120	304	Activo
305	HEIZEL FERNANDA	MONSALVE MORENO	EST-1201	2010-10-28	Femenino	f	\N	16	\N	\N	120	305	Activo
306	HELEN VALENTINA	BERNAL TORRES	EST-1202	2010-04-02	Femenino	f	\N	9	\N	\N	197	306	Activo
307	HELEN VALENTINA	BERNAL TORRES	EST-1203	2010-04-02	Femenino	f	\N	10	\N	\N	198	307	Activo
308	HELENA SOFIA	ROJAS VILLAMIZAR	EST-1204	2015-09-01	Femenino	f	\N	25	\N	\N	199	308	Activo
309	HELENA SOFIA	ROJAS VILLAMIZAR	EST-1205	2015-09-01	Femenino	f	\N	6	\N	\N	200	309	Activo
310	HILARY ANARELLA	UZTARIS MOGOLLON	EST-1206	2012-08-05	Femenino	f	\N	7	\N	\N	201	310	Activo
311	ISABELLA	AMAYA REY	EST-1207	2014-05-11	Femenino	f	\N	8	\N	\N	201	311	Activo
312	ISABELLA ALESSANDRA	AVENDAÑO BLANCO	EST-1208	2009-05-28	Femenino	f	\N	12	\N	\N	202	312	Activo
313	ISABELLA ALESSANDRA	AVENDAÑO BLANCO	EST-1209	2009-05-28	Femenino	f	\N	\N	\N	\N	203	313	Activo
314	ISABELLA CARLEY	CASTAÑEDA RUEDA	EST-1210	2016-05-13	Femenino	f	\N	25	\N	\N	204	314	Activo
315	ISABELLA NAOMI	GONZALEZ SALAS	EST-1211	2015-12-09	Femenino	f	\N	7	\N	\N	205	315	Activo
316	ISABELLA SALOME	ESCOBAR DIAZ	EST-1212	2015-05-23	Femenino	f	\N	7	\N	\N	205	316	Activo
317	ISABELLA VALENTINA	ONTIVEROS MOGROVEJO	EST-1213	2014-06-18	Femenino	f	\N	7	\N	\N	205	317	Activo
318	ISABELLA VALENTINA	ONTIVEROS MOGROVEJO	EST-1214	2014-06-18	Femenino	f	\N	25	\N	\N	206	318	Activo
319	ISABELLA VALENTINA	ONTIVEROS MOGROVEJO	EST-1215	2014-06-18	Femenino	f	\N	8	\N	\N	207	319	Activo
320	ISNEY ANGELY	NOGUERA RAMIREZ	EST-1216	2002-08-30	Femenino	f	\N	12	\N	\N	208	320	Activo
321	ISNEY ANYELI	NOGUERA RAMIRES	EST-1217	2002-08-30	Femenino	f	\N	25	\N	\N	209	321	Activo
322	ITZEL SHARLOTT	CALDERON BERMUDEZ	EST-1218	2018-06-13	Femenino	f	\N	25	\N	\N	210	322	Activo
323	IVANNA ANTONELLA	LACRUZ SANDOVAL	EST-1219	2015-06-29	Femenino	f	\N	7	\N	\N	210	323	Activo
324	IVANNA LUCIA	PEREZ PLATA	EST-1220	2013-04-01	Femenino	f	\N	7	\N	\N	211	324	Activo
325	IVANNA LUCIA	PEREZ PLATA	EST-1221	2013-04-01	Femenino	f	\N	8	\N	\N	212	325	Activo
326	JADE SAMIRA	RAMÍREZ DÍAZ	EST-1222	2013-04-05	Femenino	f	\N	7	\N	\N	212	326	Activo
327	JADE YULIANA	ARIZA CARVAJAL	EST-1223	2002-09-23	Femenino	f	\N	22	\N	\N	213	327	Activo
328	JADE YULIANA	ARIZA CARVAJAL	EST-1224	2002-09-23	Femenino	f	\N	22	\N	\N	213	328	Activo
329	JADE YULIANA	ARIZA CARVAJAL	EST-1225	2002-09-23	Femenino	f	\N	22	\N	\N	213	329	Activo
330	JAVIANA SOFIA	DAVILA MONTERO	EST-1226	2011-05-27	Femenino	f	\N	10	\N	\N	214	330	Activo
331	JAVIANA SOFÍA	DÁVILA MONTERO	EST-1227	2011-05-27	Femenino	f	\N	\N	\N	\N	214	331	Activo
332	JESSI GABRIELA	LUNA TRESPALACIOS	EST-1228	2010-05-15	Femenino	f	\N	10	\N	\N	214	332	Activo
333	JESSI GABRIELA	LUNA TRESPALACIOS	EST-1229	2010-05-15	Femenino	f	\N	7	\N	\N	215	333	Activo
334	JESSI GABRIELA	LUNA TRESPALACIOS	EST-1230	2010-05-15	Femenino	f	\N	7	\N	\N	215	334	Activo
335	JIMENA GABRIELA	CANAL CHACON	EST-1231	2014-09-11	Femenino	f	\N	25	\N	\N	216	335	Activo
336	JIMENA GABRIELA	CANAL CHACON	EST-1232	2014-09-11	Femenino	f	\N	25	\N	\N	217	336	Activo
337	JIMENA GABRIELA	CANAL CHACON	EST-1233	2014-09-11	Femenino	f	\N	25	\N	\N	217	337	Activo
338	JIMENA ISABEL	COLMENARES JIMENEZ	EST-1234	2013-03-23	Femenino	f	\N	9	\N	\N	217	338	Activo
339	JIMENA ISABEL	COLMENARES JIMÉNEZ	EST-1235	2013-03-23	Femenino	f	\N	9	\N	\N	218	339	Activo
340	JULIANA PAOLA	PEREZ LÓPEZ	EST-1236	2006-05-18	Femenino	f	\N	18	\N	\N	219	340	Activo
341	JULIETH FABIANA	FORERO CARRILLO	EST-1237	2003-09-16	Femenino	f	\N	10	\N	\N	219	341	Activo
342	JULIETH FABIANA	FORERO CARRILLO	EST-1238	2003-09-16	Femenino	f	\N	10	\N	\N	220	342	Activo
343	JULIETH FABIANA	FORERO CARRILLO	EST-1239	2003-09-16	Femenino	f	\N	10	\N	\N	220	343	Activo
344	JULIETH FERNANDA	BELEÑO SANDOVAL	EST-1240	2003-10-13	Femenino	f	\N	22	\N	\N	221	344	Activo
345	KELLY ALEXANDRA	PEREZ MONTAÑEZ	EST-1241	2003-04-01	Femenino	f	\N	14	\N	\N	222	345	Activo
346	KELLY ALEXANDRA	PEREZ MONTAÑEZ	EST-1242	2003-04-01	Femenino	f	\N	14	\N	\N	222	346	Activo
347	KEREN NIKOLL	MUÑOZ ACEVEDO	EST-1243	2012-05-08	Femenino	f	\N	7	\N	\N	222	347	Activo
348	KEREN NIKOLL	MUÑOZ ACEVEDO	EST-1244	2012-05-08	Femenino	f	\N	8	\N	\N	223	348	Activo
349	KRISMAR ARIADNA	SIERRA AVENDAÑO	EST-1245	2006-02-25	Femenino	f	\N	22	\N	\N	223	349	Activo
350	KRISTEL CAMILA	SUAREZ VARGAS	EST-1246	2013-07-12	Femenino	f	\N	7	\N	\N	224	350	Activo
351	KRISTEL CAMILA	SUÁREZ VARGAS	EST-1247	2013-07-12	Femenino	f	\N	8	\N	\N	225	351	Activo
352	KRISTEL CAMILA	SUAREZ VARGAS	EST-1248	2013-07-12	Femenino	f	\N	8	\N	\N	226	352	Activo
353	LAUREN SOFIA	RUIZ COLMENARES	EST-1249	2007-03-19	Femenino	f	\N	22	\N	\N	226	353	Activo
354	LAUREN SOFIA	RUIZ COLMENARES	EST-1250	2007-03-19	Femenino	f	\N	20	\N	\N	227	354	Activo
355	LILIA DEL CARMEN	CARRILLO RODRIGUEZ	EST-1251	2016-06-08	Femenino	f	\N	6	\N	\N	228	355	Activo
356	LISDANI ISABELLA	CHACON MARQUEZ	EST-1252	2014-12-17	Femenino	f	\N	6	\N	\N	229	356	Activo
357	LISSETH ISABELLA	MENDOZA SALAZAR	EST-1253	2011-11-09	Femenino	f	\N	25	\N	\N	230	357	Activo
358	LISSETH ISABELLA	MENDOZA SALAZAR	EST-1254	2010-11-09	Femenino	f	\N	9	\N	\N	231	358	Activo
359	LIZCANO FRANCISCONY	LUCCIANA ANTONELLA	EST-1255	2014-09-04	Femenino	f	\N	6	\N	\N	231	359	Activo
360	LORIANA ANTHONELLA	CONTRERAS HARMS	EST-1256	2013-01-08	Femenino	f	\N	8	\N	\N	232	360	Activo
361	LORIANA ANTHONELLA	CONTRERAS HARMS	EST-1257	2013-01-08	Femenino	f	\N	8	\N	\N	233	361	Activo
362	LUCCIANA ANTONELLA	LIZCANO FRANCISCONY	EST-1258	2014-09-04	Femenino	f	\N	7	\N	\N	234	362	Activo
363	LUCIA ANTONELLA	CONTRERAS ARELLANO	EST-1259	2014-10-06	Femenino	f	\N	6	\N	\N	234	363	Activo
364	LUCÍA CAMILA	CASTELLANOS CRESPO	EST-1260	2013-03-09	Femenino	f	\N	7	\N	\N	235	364	Activo
365	LUCÍA CAMILA	CASTELLANOS CRESPO	EST-1261	2013-03-09	Femenino	f	\N	6	\N	\N	236	365	Activo
366	LUISA CAMILA	RONDON SANCHEZ	EST-1262	2010-09-11	Femenino	f	\N	8	\N	\N	236	366	Activo
367	LUZHANY SARAIH	LIZCANO BASTO	EST-1263	2009-08-10	Femenino	f	\N	10	\N	\N	237	367	Activo
368	MADELAINE GISSELL	GARZON MORALES	EST-1264	2014-08-21	Femenino	f	\N	6	\N	\N	238	368	Activo
369	MADELAINE GISSELL	GARZON MORALES	EST-1265	2014-08-21	Femenino	f	\N	8	\N	\N	239	369	Activo
370	MANUELA ALEJANDRA	NÚÑEZ MORENO	EST-1266	2011-02-04	Femenino	f	\N	\N	\N	\N	240	370	Activo
371	MARÍA CAMILA	MÚJICA VARGAS	EST-1267	2009-09-29	Femenino	f	\N	12	\N	\N	240	371	Activo
372	MARÍA CAMILA	MÚJICA VARGAS	EST-1268	2009-09-29	Femenino	f	\N	\N	\N	\N	240	372	Activo
373	MARÍA DE JESÚS	GUERRERO APARICIO	EST-1269	2006-10-07	Femenino	f	\N	22	\N	\N	68	373	Activo
374	MARÍA DE JESÚS	GUERRERO APARICIO	EST-1270	2006-10-07	Femenino	f	\N	22	\N	\N	241	374	Activo
375	MARIA DE LOS ANGELES	SANCHEZ JAIMES	EST-1271	2011-12-04	Femenino	f	\N	25	\N	\N	241	375	Activo
376	MARIA DE LOS ANGELES	CARRERO GOMEZ	EST-1272	2015-09-08	Femenino	f	\N	25	\N	\N	242	376	Activo
377	MARIA DE LOS ANGELES	CARRERO GOMEZ	EST-1273	2015-09-08	Femenino	f	\N	25	\N	\N	243	377	Activo
378	MARIA DE LOS ANGELES	CARRERO GOMEZ	EST-1274	2015-09-08	Femenino	f	\N	6	\N	\N	243	378	Activo
379	MARIA FERNANDA	RAMIREZ RIVERA	EST-1275	2012-01-13	Femenino	f	\N	9	\N	\N	68	379	Activo
380	MARIA FERNANDA	GIRALDO CONTRERAS	EST-1276	2007-01-01	Femenino	f	\N	\N	\N	\N	243	380	Activo
381	MARIA FERNANDA	GIRALDO CONTRERAS	EST-1277	2006-03-06	Femenino	f	\N	22	\N	\N	244	381	Activo
382	MARIA FERNANDA	GIRALDO CONTRERAS	EST-1278	2006-03-06	Femenino	f	\N	22	\N	\N	245	382	Activo
383	MARIA FERNANDA	ZAMBRANO ROJAS	EST-1279	2016-04-01	Femenino	f	\N	25	\N	\N	246	383	Activo
384	MARIA FERNANDA	ZAMBRANO ROJAS	EST-1280	2016-04-01	Femenino	f	\N	25	\N	\N	246	384	Activo
385	MARIA FERNANDA	RAMIREZ RIVERA	EST-1281	2012-01-13	Femenino	f	\N	10	\N	\N	247	385	Activo
386	MARIA FERNANDA	ZAMBRANO RANGEL	EST-1282	2016-04-01	Femenino	f	\N	6	\N	\N	248	386	Activo
387	MARIA GUADALUPE	MANRIQUE CARDENAS	EST-1283	2009-03-03	Femenino	f	\N	20	\N	\N	249	387	Activo
388	MARIA GUADALUPE	MANRIQUE CARDENAS	EST-1284	2009-03-03	Femenino	f	\N	\N	\N	\N	250	388	Activo
389	MARIA ISABELLA	GUERRA GANDICA	EST-1285	2011-09-05	Femenino	f	\N	9	\N	\N	251	389	Activo
390	MARIA ISABELLA	GUERRA GANDICA	EST-1286	2011-09-05	Femenino	f	\N	8	\N	\N	252	390	Activo
391	MARIA JIMENA	ESCALANTE BECERRA	EST-1287	2016-08-19	Femenino	f	\N	25	\N	\N	252	391	Activo
392	MARIA JOSE	CARDOZA MORENO	EST-1288	2015-09-25	Femenino	f	\N	25	\N	\N	253	392	Activo
393	MARIA JOSE	RUBIO ARELLANO	EST-1289	2006-03-15	Femenino	f	\N	13	\N	\N	254	393	Activo
394	MARÍA JOSÉ	RAMÍREZ FERNÁNDEZ	EST-1290	2004-08-02	Femenino	f	\N	14	\N	\N	255	394	Activo
469	NELIANA	PLATA BUITRAGO	EST-1365	2011-10-29	Femenino	f	\N	10	\N	\N	151	469	Activo
395	MARIA JOSE DEL ROCIO	PEREIRA ESCALANTE	EST-1291	2012-12-07	Femenino	f	\N	9	\N	\N	256	395	Activo
396	MARIA JULIETA	ORTIZ HERRERA	EST-1292	2015-06-17	Femenino	f	\N	7	\N	\N	257	396	Activo
397	MARÍA KAMILA	CONTRERAS PACHECO	EST-1293	2014-11-04	Femenino	f	\N	6	\N	\N	257	397	Activo
398	MARÍA KAMILA	CONTRERAS PACHECO	EST-1294	2014-11-04	Femenino	f	\N	6	\N	\N	258	398	Activo
399	MARIA LAURA	CASTRO HART	EST-1295	2006-06-16	Femenino	f	\N	14	\N	\N	259	399	Activo
400	MARIA NIRVANA	STANCO BOHORQUEZ	EST-1296	2006-01-30	Femenino	f	\N	22	\N	\N	258	400	Activo
401	MARÍA PAULA	PARADA ORTIZ	EST-1297	2012-11-08	Femenino	f	\N	10	\N	\N	260	401	Activo
402	MARIA SOFIA	GUERRA CONTRERAS	EST-1298	2010-04-08	Femenino	f	\N	10	\N	\N	260	402	Activo
403	MARIA SOFIA	ANDRADE GONZALEZ	EST-1299	2009-05-29	Femenino	f	\N	\N	\N	\N	261	403	Activo
404	MARIA SOFIA	ANDRADE GONZALEZ	EST-1300	2009-05-29	Femenino	f	\N	10	\N	\N	261	404	Activo
405	MARIA VALENTINA	MORALES OCHOA	EST-1301	2006-08-29	Femenino	f	\N	21	\N	\N	262	405	Activo
406	MARIA VALENTINA	MORALES OCHOA	EST-1302	2006-08-29	Femenino	f	\N	22	\N	\N	262	406	Activo
407	MARÍA VALENTINA	MORALES OCHOA	EST-1303	2006-08-29	Femenino	f	\N	\N	\N	\N	263	407	Activo
408	MARIA VICTORIA	HERNANDEZ LABRADOR	EST-1304	2006-10-07	Femenino	f	\N	17	\N	\N	264	408	Activo
409	MARIA VICTORIA	HERNANDEZ LABRADOR	EST-1305	2006-10-07	Femenino	f	\N	18	\N	\N	265	409	Activo
410	MARIA VICTORIA	BELTRAN GONZALEZ	EST-1306	2008-04-13	Femenino	f	\N	10	\N	\N	265	410	Activo
411	MARIA VICTORIA	BELTRAN GONZALEZ	EST-1307	2008-04-13	Femenino	f	\N	\N	\N	\N	266	411	Activo
412	MARIA VICTORIA	UTRERA SILVA	EST-1308	2016-01-07	Femenino	f	\N	25	\N	\N	267	412	Activo
413	MARIA VICTORIA	UTRERA SILVA	EST-1309	2016-01-07	Femenino	f	\N	6	\N	\N	268	413	Activo
414	MARÍA VIRGINIA	GARCÍA FERNÁNDEZ	EST-1310	2011-07-11	Femenino	f	\N	12	\N	\N	268	414	Activo
415	MARIAGNY ALEXANDRA	ESCALANTE BUENAÑO	EST-1311	2006-05-29	Femenino	f	\N	14	\N	\N	268	415	Activo
416	MARIAM GEORGINA	ROA SUAREZ	EST-1312	2008-08-08	Femenino	f	\N	\N	\N	\N	269	416	Activo
417	MARIAM GEORGINA	ROA SUAREZ	EST-1313	2008-08-08	Femenino	f	\N	20	\N	\N	270	417	Activo
418	MARIANA	BOADA BAYONA	EST-1314	2011-07-16	Femenino	f	\N	10	\N	\N	270	418	Activo
419	MARIANA DAYMAR	GARCÍA RAMÍREZ	EST-1315	2004-12-01	Femenino	f	\N	13	\N	\N	270	419	Activo
420	MARIANA ISABELLA	VÁSQUEZ GUERRERO	EST-1316	2011-08-03	Femenino	f	\N	\N	\N	\N	271	420	Activo
421	MARIANA ISABELLA	VÁSQUEZ GUERRERO	EST-1317	2010-08-03	Femenino	f	\N	16	\N	\N	272	421	Activo
422	MARIANA ISABELLA	VASQUEZ GUERRERO	EST-1318	2010-08-03	Femenino	f	\N	10	\N	\N	273	422	Activo
423	MARIANA LUCIA	ABREU GOMEZ	EST-1319	2013-07-27	Femenino	f	\N	8	\N	\N	274	423	Activo
424	MARIANA LUCIA	ABREU GOMEZ	EST-1320	2013-07-27	Femenino	f	\N	8	\N	\N	275	424	Activo
425	MARIANA LUCIA	ABREU GOMEZ	EST-1321	2013-07-27	Femenino	f	\N	8	\N	\N	275	425	Activo
426	MARIANA LUCIA	ABREU GOMEZ	EST-1322	2013-07-27	Femenino	f	\N	9	\N	\N	234	426	Activo
427	MARIANA SARAI	ACOSTA ROJAS	EST-1323	2010-08-05	Femenino	f	\N	10	\N	\N	271	427	Activo
428	MARIANGEL	CARRERO GUIRAL	EST-1324	2008-12-11	Femenino	f	\N	13	\N	\N	276	428	Activo
429	MARIANGEL DELVALLE	PÉREZ SUÁREZ	EST-1325	2012-11-29	Femenino	f	\N	10	\N	\N	277	429	Activo
430	MARIANGEL ELIANA	VARELA ESCALANTE	EST-1326	2006-10-25	Femenino	f	\N	18	\N	\N	278	430	Activo
431	MARIANGEL GABRIELA	DUQUE SANCHEZ	EST-1327	2013-08-01	Femenino	f	\N	7	\N	\N	279	431	Activo
432	MARIANGEL GABRIELA	DUQUE SANCHEZ	EST-1328	2013-08-01	Femenino	f	\N	8	\N	\N	280	432	Activo
433	MARIANGEL HELIT	GARZON MORALES	EST-1329	2011-01-07	Femenino	f	\N	\N	\N	\N	281	433	Activo
434	MARIANGEL JOHANA	ACOSTA ROJAS	EST-1330	2008-06-06	Femenino	f	\N	\N	\N	\N	282	434	Activo
435	MARIÁNGEL SOFÍA	GUERRA COLMENARES	EST-1331	2006-11-18	Femenino	f	\N	22	\N	\N	282	435	Activo
436	MARIANGEL STEFFANY	MARQUEZ CONTRERAS	EST-1332	2012-11-27	Femenino	f	\N	10	\N	\N	272	436	Activo
437	MARIANGEL STHEFANY	RAMIREZ REY	EST-1333	2010-03-17	Femenino	f	\N	10	\N	\N	272	437	Activo
438	MARIANGEL YOSELIN	CARRILLO URBINA	EST-1334	2009-07-30	Femenino	f	\N	\N	\N	\N	283	438	Activo
439	MARIANNID VICTORIA	VASQUEZ ÁNGEL	EST-1335	2008-11-07	Femenino	f	\N	\N	\N	\N	284	439	Activo
440	MARIANNID VICTORIA	VASQUEZ ANGEL	EST-1336	2008-11-07	Femenino	f	\N	12	\N	\N	285	440	Activo
441	MARIANNID VICTORIA	VASQUEZ ANGEL	EST-1337	2008-11-07	Femenino	f	\N	12	\N	\N	286	441	Activo
442	MARIANNID VICTORIA	VASQUES ANGEL	EST-1338	2008-11-07	Femenino	f	\N	13	\N	\N	287	442	Activo
443	MARIET ANTONELLA	CARRERO GUIRAL	EST-1339	2016-09-22	Femenino	f	\N	25	\N	\N	287	443	Activo
444	MARIET ANTONELLA	CARRERO GUIRAL	EST-1340	2016-09-22	Femenino	f	\N	6	\N	\N	288	444	Activo
445	MARTHINA	SERRANO HERNANDEZ	EST-1341	2013-10-18	Femenino	f	\N	8	\N	\N	289	445	Activo
446	MARTHINA SOFIA	SERRANO HERNÁNDEZ	EST-1342	2013-10-18	Femenino	f	\N	7	\N	\N	290	446	Activo
447	MARTHINA SOFIA	SERRANO HERNÁNDEZ	EST-1343	2013-10-18	Femenino	f	\N	6	\N	\N	291	447	Activo
448	MARYELIX AILEEN	CONTRERAS SANDOVAL	EST-1344	2015-08-04	Femenino	f	\N	6	\N	\N	292	448	Activo
449	MELANNY ANTHONELLA	NAVARRO ALVIAREZ	EST-1345	2012-11-02	Femenino	f	\N	8	\N	\N	293	449	Activo
450	MELANNY ANTHONELLA	NAVARRO ALVIAREZ	EST-1346	2012-11-02	Femenino	f	\N	8	\N	\N	181	450	Activo
451	MELANY SALOME	NARANJO VILLALOBOS	EST-1347	2012-05-24	Femenino	f	\N	9	\N	\N	294	451	Activo
452	MELANY SALOME	NARANJO VILLALOBOS	EST-1348	2012-05-24	Femenino	f	\N	10	\N	\N	295	452	Activo
453	MELANY SALOME	NARANJO VILLALOBOS	EST-1349	2012-05-24	Femenino	f	\N	8	\N	\N	295	453	Activo
454	MELANY SOPHIA	TORRES DAVILA	EST-1350	2013-05-13	Femenino	f	\N	9	\N	\N	296	454	Activo
455	MEREDITH NOELY	PACHECO RAMÍREZ	EST-1351	2018-02-27	Femenino	f	\N	25	\N	\N	297	455	Activo
456	MIA ISABELLA	RUGELES MANOSALVA	EST-1352	2015-11-20	Femenino	f	\N	6	\N	\N	261	456	Activo
457	MIA VALENTINA	MONCADA GARNICA	EST-1353	2018-02-27	Femenino	f	\N	25	\N	\N	261	457	Activo
458	MICHELLE ALEXANDRA	GUERRERO PEREZ	EST-1354	2015-04-24	Femenino	f	\N	7	\N	\N	261	458	Activo
459	MICHELLE CAROLAY	SUAREZ PULIDO	EST-1355	2012-11-27	Femenino	f	\N	9	\N	\N	298	459	Activo
460	MICHELLE CAROLAY	SUAREZ PULIDO	EST-1356	2012-11-27	Femenino	f	\N	8	\N	\N	299	460	Activo
461	NADIA GABRIELA	LOZANO ROMÁN	EST-1357	2005-06-25	Femenino	f	\N	22	\N	\N	299	461	Activo
462	NATALIA ANDREA	MÁRQUEZ MOLINA	EST-1358	2003-08-20	Femenino	f	\N	22	\N	\N	299	462	Activo
463	NATALIA ANDREA	BELTRAN GONZALEZ	EST-1359	2006-05-17	Femenino	f	\N	20	\N	\N	300	463	Activo
464	NATALIA ANDREA	BELTRAN GONZALEZ	EST-1360	2006-05-17	Femenino	f	\N	20	\N	\N	300	464	Activo
465	NATALIA ANDREA	BELTRÁN GONZÁLEZ	EST-1361	2006-05-17	Femenino	f	\N	22	\N	\N	151	465	Activo
466	NATHALIA SARAY	BONILLA PULIDO	EST-1362	2011-11-02	Femenino	f	\N	10	\N	\N	151	466	Activo
467	NELIANA	PLATA BUITRAGO	EST-1363	2011-10-29	Femenino	f	\N	9	\N	\N	151	467	Activo
470	NICOLL ANTHONELA	HURTADO GUTIERREZ	EST-1366	2012-12-31	Femenino	f	\N	8	\N	\N	301	470	Activo
471	NICOLL ANTHONELA	HURTADO GUTIERREZ	EST-1367	2012-12-31	Femenino	f	\N	6	\N	\N	302	471	Activo
472	NIYOSKARY ORALYN	OQUENDO OSTOS	EST-1368	2005-03-10	Femenino	f	\N	\N	\N	\N	303	472	Activo
473	NIYOSKARY ORALYN	OQUENDO OSTOS	EST-1369	2005-03-10	Femenino	f	\N	\N	\N	\N	304	473	Activo
474	NIYOSKARY ORALYN	OQUENDO OSTOS	EST-1370	2005-03-10	Femenino	f	\N	\N	\N	\N	305	474	Activo
475	NIYOSKARY ORALYN	OQUENDO OSTOS OQUENDO OSTOS	EST-1371	2005-03-10	Femenino	f	\N	\N	\N	\N	306	475	Activo
476	NIYOSKARY ORALYN	OQUENDO OSTOS OQUENDO OSTOS	EST-1372	2005-03-10	Femenino	f	\N	12	\N	\N	307	476	Activo
477	NOELIA SALOMÉ	BONILLA BECERRA	EST-1373	2016-08-22	Femenino	f	\N	6	\N	\N	308	477	Activo
478	NOEMÍ ALEXANDRA	CELIS DUARTE	EST-1374	2009-08-11	Femenino	f	\N	16	\N	\N	309	478	Activo
479	NOEMI ALEXANDRA	CELIS DUARTE	EST-1375	2009-08-11	Femenino	f	\N	10	\N	\N	310	479	Activo
480	ORIANNA MICHELLE	VIVAS MONSALVE	EST-1376	2005-08-21	Femenino	f	\N	22	\N	\N	310	480	Activo
481	ORIANNA SOFÍA	PÉREZ NAVARRO	EST-1377	2011-05-17	Femenino	f	\N	9	\N	\N	310	481	Activo
482	ORIANNA SOFIA	PEREZ NAVARRO	EST-1378	2011-05-17	Femenino	f	\N	10	\N	\N	227	482	Activo
483	OSKARI JOSABET	HERNANDEZ BOHORQUEZ	EST-1379	2006-09-21	Femenino	f	\N	13	\N	\N	230	483	Activo
484	OSKARI JOSABET	HERNANDEZ BOHORQUEZ	EST-1380	2006-09-21	Femenino	f	\N	\N	\N	\N	311	484	Activo
485	OSKARI JOSABET	HERNÁNDEZ BOHÓRQUEZ	EST-1381	2006-09-21	Femenino	f	\N	14	\N	\N	312	485	Activo
486	OSKARI JOSABET	HERNÁNDEZ BOHÓRQUEZ	EST-1382	2006-09-21	Femenino	f	\N	14	\N	\N	313	486	Activo
487	OSKARI JOSABET	HERNÁNDEZ BOHÓRQUEZ	EST-1383	2006-09-21	Femenino	f	\N	25	\N	\N	314	487	Activo
488	OSKARI JOSABET	HERNANDEZ BOHORQUEZ	EST-1384	2006-09-21	Femenino	f	\N	14	\N	\N	315	488	Activo
489	PAOLA STEFANIA	CHACON SALCEDO	EST-1385	2005-02-09	Femenino	f	\N	22	\N	\N	316	489	Activo
490	PAOLA VALENTINA	LIZCANO FRANCISCONY	EST-1386	2014-09-04	Femenino	f	\N	6	\N	\N	316	490	Activo
491	PAOLA VALENTINA	LIZCANO FRANCISCONY	EST-1387	2014-09-04	Femenino	f	\N	7	\N	\N	317	491	Activo
492	PATRICIA ANTONELLA	MARQUEZ REQUENA	EST-1388	2012-12-21	Femenino	f	\N	7	\N	\N	317	492	Activo
493	PAULA ANDREA	ROJAS UZCATEGUI	EST-1389	2008-07-10	Femenino	f	\N	13	\N	\N	317	493	Activo
494	PAULA ANDREINA	NARANJO CORREA	EST-1390	2013-02-08	Femenino	f	\N	7	\N	\N	317	494	Activo
495	PAULA MONSERRAT	CACUA MONCADA	EST-1391	2016-01-06	Femenino	f	\N	6	\N	\N	318	495	Activo
496	RACHEL SARAITH	ROJAS ROMERO	EST-1392	2005-04-24	Femenino	f	\N	14	\N	\N	319	496	Activo
497	ROMINNA STEPHANIA	ZUMZTEIN GIL	EST-1393	2013-12-09	Femenino	f	\N	7	\N	\N	319	497	Activo
498	ROMINNA STEPHANIA	ZUMZTEIN GIL	EST-1394	2013-12-09	Femenino	f	\N	6	\N	\N	320	498	Activo
499	ROSSY VALENTINA	MARQUEZ ROSALES	EST-1395	2011-08-12	Femenino	f	\N	8	\N	\N	321	499	Activo
500	ROSSY VALENTINA	MARQUEZ ROSALES	EST-1396	2011-08-12	Femenino	f	\N	9	\N	\N	321	500	Activo
501	ROSSY VALENTINA	MARQUEZ ROSALES	EST-1397	2011-08-12	Femenino	f	\N	10	\N	\N	322	501	Activo
502	ROSSY VALENTINA	MARQUEZ ROSALES	EST-1398	2011-08-12	Femenino	f	\N	\N	\N	\N	323	502	Activo
503	SABINEL	FERMÍN DELGADO	EST-1399	2012-05-07	Femenino	f	\N	9	\N	\N	323	503	Activo
504	SABRINA LEONOR	VILLEGAS CHACÓN	EST-1400	2015-12-21	Femenino	f	\N	6	\N	\N	324	504	Activo
505	SABRINA LEONOR	VILLEGAS CHANCON	EST-1401	2015-12-21	Femenino	f	\N	25	\N	\N	325	505	Activo
506	SALOME NAZARETH	BECERRA CASTRO	EST-1402	2015-02-11	Femenino	f	\N	7	\N	\N	326	506	Activo
507	SAMANTHA SOLEY	PEÑALOZA BAEZ	EST-1403	2014-10-08	Femenino	f	\N	6	\N	\N	326	507	Activo
508	SAMANTHA SOLEY	PEÑALOZA BAEZ	EST-1404	2014-10-08	Femenino	f	\N	6	\N	\N	220	508	Activo
509	SARA ANGELINA	BANCES HERNANDEZ	EST-1405	2009-01-01	Femenino	f	\N	\N	\N	\N	220	509	Activo
510	SARA ADELEN SOFIA	ANTONIELLI SUA	EST-1406	2013-05-21	Femenino	f	\N	6	\N	\N	327	510	Activo
511	SARA ANDREINA	MORALES FERNANDEZ	EST-1407	2007-09-16	Femenino	f	\N	13	\N	\N	327	511	Activo
512	SARA ANDREINA	MORALES FERNANDEZ	EST-1408	2007-09-16	Femenino	f	\N	14	\N	\N	114	512	Activo
513	SARA ANGELINA	BANCES HERNANDEZ	EST-1409	2009-07-27	Femenino	f	\N	12	\N	\N	114	513	Activo
514	SARA ANGELY	PASTRAN ROJAS	EST-1410	2013-04-03	Femenino	f	\N	7	\N	\N	114	514	Activo
515	SARA GLADYMAR	QUIROZ ACOSTA	EST-1411	2006-09-14	Femenino	f	\N	14	\N	\N	328	515	Activo
516	SARA GLADYMAR	QUIROZ ACOSTA	EST-1412	2006-09-14	Femenino	f	\N	14	\N	\N	329	516	Activo
517	SARA NOHEMÍ	MUÑOZ ACEVEDO	EST-1413	2013-08-31	Femenino	f	\N	7	\N	\N	330	517	Activo
518	SARA NOHEMI	MUÑOZ ACEVEDO	EST-1414	2013-08-31	Femenino	f	\N	8	\N	\N	331	518	Activo
519	SARA VALERIA	CASIQUE ZAMBRANO	EST-1415	2014-05-18	Femenino	f	\N	7	\N	\N	332	519	Activo
520	SARA VALERIA	CASIQUE ZAMBRANO	EST-1416	2014-05-18	Femenino	f	\N	7	\N	\N	333	520	Activo
521	SARAH NOHEMY	CÁCERES LEAL	EST-1417	2008-05-29	Femenino	f	\N	14	\N	\N	334	521	Activo
522	SARAH NOHEMY	CACERES LEAL	EST-1418	2008-05-29	Femenino	f	\N	\N	\N	\N	335	522	Activo
523	SARAH NOHEMY	CACERES LEAL	EST-1419	2008-05-29	Femenino	f	\N	13	\N	\N	336	523	Activo
524	SARAITH NEILYN	CASTAÑEDA GONZÁLEZ	EST-1420	2006-09-02	Femenino	f	\N	20	\N	\N	337	524	Activo
525	SARAITH NEILYN	CASTAÑEDA GONZÁLEZ	EST-1421	2006-09-02	Femenino	f	\N	20	\N	\N	132	525	Activo
526	SARAITH NEILYN	CASTAÑEDA GONZÁLEZ	EST-1422	2006-09-02	Femenino	f	\N	20	\N	\N	132	526	Activo
527	SHIRLEY ORIANA	REY LOPEZ	EST-1423	2005-09-19	Femenino	f	\N	16	\N	\N	338	527	Activo
528	SKARLY FRANCHESCA	BERNAL DURAN	EST-1424	2014-03-14	Femenino	f	\N	8	\N	\N	94	528	Activo
529	SOFIA ALEJANDRA	NIÑO PAZ	EST-1425	2008-05-08	Femenino	f	\N	12	\N	\N	339	529	Activo
530	SOFIA ALEJANDRA	NINO PAZ	EST-1426	2008-05-08	Femenino	f	\N	13	\N	\N	340	530	Activo
531	SOFIA ANABHELLA	CHACÓN GONZÁLEZ	EST-1427	2016-07-08	Femenino	f	\N	6	\N	\N	341	531	Activo
532	SOFIA CARLOTA	DIAZ CHACON	EST-1428	2014-12-22	Femenino	f	\N	6	\N	\N	342	532	Activo
533	SOFIA GABRIELA	GAITÀN BECERRA	EST-1429	2004-10-25	Femenino	f	\N	22	\N	\N	343	533	Activo
534	SOFÍA VALERIA	CORDERO MONCADA	EST-1430	2013-07-19	Femenino	f	\N	8	\N	\N	344	534	Activo
535	SOFÍA VALERIA	CORDERO MONCADA	EST-1431	2013-07-19	Femenino	f	\N	8	\N	\N	344	535	Activo
536	SOFIA VALERIA	CORDERO MONCADA	EST-1432	2013-07-19	Femenino	f	\N	9	\N	\N	345	536	Activo
537	SOFIA VALETINA	KYRIMLKOGLOU RAMIREZ	EST-1433	2007-10-25	Femenino	f	\N	22	\N	\N	346	537	Activo
538	SOPHIA ANTONELLA	MORA VARELA	EST-1434	2013-03-01	Femenino	f	\N	7	\N	\N	347	538	Activo
539	SOPHIA VALENTINA	D´ SANTIAGO CASTRO	EST-1435	2012-08-20	Femenino	f	\N	7	\N	\N	348	539	Activo
540	SOPHY ANTONELLA	CASTELLANO PERNIA	EST-1436	2013-05-02	Femenino	f	\N	7	\N	\N	348	540	Activo
541	STEFANNY CAMILA	LEÓN RICO	EST-1437	2015-11-13	Femenino	f	\N	7	\N	\N	349	541	Activo
542	STEPHENIE SALOMÉ	ALVIAREZ VERGARA	EST-1438	2006-10-26	Femenino	f	\N	6	\N	\N	205	542	Activo
543	TATIANA ISABELLA	ZAMBRANO ARAQUE	EST-1439	2004-08-31	Femenino	f	\N	14	\N	\N	350	543	Activo
544	VALERIA DE LOS ANGELES	ZAMBRANO GUERRERO	EST-1440	2006-11-08	Femenino	f	\N	14	\N	\N	351	544	Activo
545	VALERIA DE LOS ÁNGELES	ZAMBRANO GUERRERO	EST-1441	2006-11-08	Femenino	f	\N	14	\N	\N	351	545	Activo
546	VALERIA SARAITH	RAMIREZ SERRANO	EST-1442	2015-12-19	Femenino	f	\N	25	\N	\N	352	546	Activo
547	VALERIA SOFIA	OJEDA ZAMBRANO	EST-1443	2004-08-20	Femenino	f	\N	25	\N	\N	353	547	Activo
548	VALERIA SOFIA	BORRERO CACERES	EST-1444	2010-10-25	Femenino	f	\N	8	\N	\N	354	548	Activo
549	VALERIA VALENTINA	VELASQUEZ RAMIREZ	EST-1445	2014-04-03	Femenino	f	\N	7	\N	\N	353	549	Activo
550	VALERIA VALENTINA	VELASQUEZ RAMIREZ	EST-1446	2014-04-03	Femenino	f	\N	8	\N	\N	355	550	Activo
551	VALERIAISABEL	URBINA PERNIA	EST-1447	2004-12-11	Femenino	f	\N	22	\N	\N	356	551	Activo
552	VALERY ALEJANDRA	ONTIVEROS MOGROVEJO	EST-1448	2018-01-08	Femenino	f	\N	25	\N	\N	357	552	Activo
553	VANESSA CAROLINA	VILLASMIL MATA	EST-1449	2006-01-23	Femenino	f	\N	22	\N	\N	357	553	Activo
554	VENEZIA ALEGRÍA	RICO MOLINA	EST-1450	2014-03-14	Femenino	f	\N	7	\N	\N	357	554	Activo
555	VENEZIA ALEGRÍA	RICO MOLINA	EST-1451	2014-03-14	Femenino	f	\N	8	\N	\N	358	555	Activo
556	VICTORIA AYLENN	MORALES COLMENARES	EST-1452	2016-08-15	Femenino	f	\N	6	\N	\N	358	556	Activo
557	VICTORIA ALEJANDRA	PEREZ SALCEDO	EST-1453	2013-09-13	Femenino	f	\N	6	\N	\N	359	557	Activo
558	VICTORIA ALEJANDRA	MANTILLA CASTRO	EST-1454	2013-09-05	Femenino	f	\N	7	\N	\N	360	558	Activo
559	VICTORIA ALEJANDRA	PÉREZ SALCEDO	EST-1455	2013-09-13	Femenino	f	\N	8	\N	\N	321	559	Activo
560	VICTORIA ALEJANDRA	CHACON PRIETO	EST-1456	2017-08-12	Femenino	f	\N	25	\N	\N	361	560	Activo
561	VICTORIA CAROLINA	SULBARAN DURAN	EST-1457	2006-06-08	Femenino	f	\N	13	\N	\N	361	561	Activo
562	VICTORIA CAROLINA	SULBARAN DURAN	EST-1458	2006-06-08	Femenino	f	\N	14	\N	\N	362	562	Activo
563	VICTORIA CAROLINA	SULBARAN DURAN	EST-1459	2006-06-08	Femenino	f	\N	14	\N	\N	362	563	Activo
564	VICTORIA CAROLINA	SULBARAN DURAN	EST-1460	2006-06-08	Femenino	f	\N	14	\N	\N	362	564	Activo
565	VICTORIA VALENTINA	RICO MEDINA	EST-1461	2006-02-02	Femenino	f	\N	22	\N	\N	362	565	Activo
566	VICTORIA VALENTINA	RICO MEDINA	EST-1462	2006-02-02	Femenino	f	\N	21	\N	\N	363	566	Activo
567	VIKAYZA SHEKINARA	VARELA MORENO	EST-1463	2011-10-27	Femenino	f	\N	8	\N	\N	364	567	Activo
568	WILKER ALEJANDRO	FIGUEROA MACIAS	EST-1464	2000-08-11	Femenino	f	\N	10	\N	\N	365	568	Activo
569	XIMENA CAMILA	PEÑALOZA BAEZ	EST-1465	2016-12-08	Femenino	f	\N	25	\N	\N	365	569	Activo
578	ariadna valentina	mejias ruiz	E1789104913351905	2017-10-29	Femenino	t	\N	8	\N	\N	370	\N	Activo
105	Adel Carolina	Escalante Gallo	EST-1001	2017-09-20	Femenino	f	\N	25	\N	\N	67	105	Activo
\.


--
-- Data for Name: Estudiante_Padre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante_Padre" ("Id_estudiante", "Id_padre") FROM stdin;
\.


--
-- Data for Name: Estudiante_Seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") FROM stdin;
1	466	1
2	466	2
3	466	3
4	466	4
5	466	5
6	466	6
7	466	7
8	466	8
9	466	9
10	466	10
11	466	11
12	466	12
13	466	13
14	466	14
15	466	15
16	466	16
17	466	17
18	466	18
19	236	1
20	236	2
21	236	3
22	236	4
23	236	5
24	236	6
25	236	7
26	236	8
27	236	9
28	236	10
29	236	11
30	236	12
31	236	13
32	236	14
33	236	15
34	236	16
35	236	17
36	236	18
37	246	1
38	246	2
39	246	3
40	246	4
41	246	5
42	246	6
43	246	7
44	246	8
45	246	9
46	246	10
47	246	11
48	246	12
49	246	13
50	246	14
51	246	15
52	246	16
53	246	17
54	246	18
55	273	19
56	273	20
57	273	21
58	273	22
59	273	23
60	273	24
61	273	25
62	273	26
63	273	27
64	273	28
65	273	29
66	273	30
67	273	31
68	273	32
69	273	33
70	273	34
71	273	35
72	273	36
73	273	37
74	570	19
75	570	20
76	570	21
77	570	22
78	570	23
79	570	24
80	570	25
81	570	26
82	570	27
83	570	28
84	570	29
85	570	30
86	570	31
87	570	32
88	570	33
89	570	34
90	570	35
91	570	36
92	570	37
93	244	19
94	244	20
95	244	21
96	244	22
97	244	23
98	244	24
99	244	25
100	244	26
101	244	27
102	244	28
103	244	29
104	244	30
105	244	31
106	244	32
107	244	33
108	244	34
109	244	35
110	244	36
111	244	37
112	499	19
113	499	20
114	499	21
115	499	22
116	499	23
117	499	24
118	499	25
119	499	26
120	499	27
121	499	28
122	499	29
123	499	30
124	499	31
125	499	32
126	499	33
127	499	34
128	499	35
129	499	36
130	499	37
131	118	38
132	118	39
133	118	40
134	118	41
135	118	42
136	118	43
137	118	44
138	118	45
139	118	46
140	118	47
141	118	48
142	118	49
143	118	50
144	118	51
145	118	52
146	118	53
147	370	38
148	370	39
149	370	40
150	370	41
151	370	42
152	370	43
153	370	44
154	370	45
155	370	46
156	370	47
157	370	48
158	370	49
159	370	50
160	370	51
161	370	52
162	370	53
163	161	38
164	161	39
165	161	40
166	161	41
167	161	42
168	161	43
169	161	44
170	161	45
171	161	46
172	161	47
173	161	48
174	161	49
175	161	50
176	161	51
177	161	52
178	161	53
179	330	54
180	330	55
181	330	56
182	330	57
183	330	58
184	330	59
185	330	60
186	330	61
187	330	62
188	330	63
189	330	64
190	330	65
191	330	66
192	330	67
193	330	68
194	330	69
195	330	70
196	330	71
197	330	72
198	203	54
199	203	55
200	203	56
201	203	57
202	203	58
203	203	59
204	203	60
205	203	61
206	203	62
207	203	63
208	203	64
209	203	65
210	203	66
211	203	67
212	203	68
213	203	69
214	203	70
215	203	71
216	203	72
217	433	54
218	433	55
219	433	56
220	433	57
221	433	58
222	433	59
223	433	60
224	433	61
225	433	62
226	433	63
227	433	64
228	433	65
229	433	66
230	433	67
231	433	68
232	433	69
233	433	70
234	433	71
235	433	72
236	232	54
237	232	55
238	232	56
239	232	57
240	232	58
241	232	59
242	232	60
243	232	61
244	232	62
245	232	63
246	232	64
247	232	65
248	232	66
249	232	67
250	232	68
251	232	69
252	232	70
253	232	71
254	232	72
255	312	73
256	312	74
257	312	75
258	312	76
259	312	77
260	312	78
261	312	79
262	312	80
263	312	81
264	312	82
265	312	83
266	312	84
267	312	85
268	312	86
269	312	87
270	414	73
271	414	74
272	414	75
273	414	76
274	414	77
275	414	78
276	414	79
277	414	80
278	414	81
279	414	82
280	414	83
281	414	84
282	414	85
283	414	86
284	414	87
285	371	73
286	371	74
287	371	75
288	371	76
289	371	77
290	371	78
291	371	79
292	371	80
293	371	81
294	371	82
295	371	83
296	371	84
297	371	85
298	371	86
299	371	87
300	193	73
301	193	74
302	193	75
303	193	76
304	193	77
305	193	78
306	193	79
307	193	80
308	193	81
309	193	82
310	193	83
311	193	84
312	193	85
313	193	86
314	193	87
\.


--
-- Data for Name: Grado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) FROM stdin;
7	Preparatorio	Estudios Iniciales	Iniciación para niños de 7 y 8 años	t	2026-08-26 03:08:57.769491
8	1er Año	Componente General	1er año del componente general de danza	t	2026-08-26 03:08:57.769491
9	2do Año	Componente General	2do año del componente general de danza	t	2026-08-26 03:08:57.769491
10	3er Año	Componente General	3er año del componente general de danza	t	2026-08-26 03:08:57.769491
11	4to Año	Componente General	4to año del componente general de danza	t	2026-08-26 03:08:57.769491
12	5to Año - Danza Clásica	Componente Especializado	5to año especialidad Danza Clásica	t	2026-08-26 03:08:57.769491
13	6to Año - Danza Clásica	Componente Especializado	6to año especialidad Danza Clásica	t	2026-08-26 03:08:57.769491
14	7mo Año - Danza Clásica	Componente Especializado	7mo año especialidad Danza Clásica	t	2026-08-26 03:08:57.769491
15	8vo Año - Danza Clásica	Componente Especializado	8vo año especialidad Danza Clásica	t	2026-08-26 03:08:57.769491
16	5to Año - Danza Tradicional	Componente Especializado	5to año especialidad Danza Tradicional	t	2026-08-26 03:08:57.769491
17	6to Año - Danza Tradicional	Componente Especializado	6to año especialidad Danza Tradicional	t	2026-08-26 03:08:57.769491
18	7mo Año - Danza Tradicional	Componente Especializado	7mo año especialidad Danza Tradicional	t	2026-08-26 03:08:57.769491
19	8vo Año - Danza Tradicional	Componente Especializado	8vo año especialidad Danza Tradicional	t	2026-08-26 03:08:57.769491
20	5to Año - Danza Contemporánea	Componente Especializado	5to año especialidad Danza Contemporánea	t	2026-08-26 03:08:57.769491
21	6to Año - Danza Contemporánea	Componente Especializado	6to año especialidad Danza Contemporánea	t	2026-08-26 03:08:57.769491
22	7mo Año - Danza Contemporánea	Componente Especializado	7mo año especialidad Danza Contemporánea	t	2026-08-26 03:08:57.769491
23	8vo Año - Danza Contemporánea	Componente Especializado	8vo año especialidad Danza Contemporánea	t	2026-08-26 03:08:57.769491
\.


--
-- Data for Name: Historial_Medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento, tipo_sangre) FROM stdin;
106	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
107	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
108	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
109	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
110	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
111	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
112	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
113	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
114	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
115	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
116	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
117	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
118	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
119	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
120	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
121	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
122	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
123	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
124	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
125	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
126	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
127	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
128	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
129	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
130	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
131	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
132	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
133	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
134	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
135	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
136	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
137	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
138	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
139	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
140	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
141	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
142	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
143	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
144	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
145	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
146	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
147	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
148	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
149	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
150	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
151	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
152	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
153	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
154	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
155	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
156	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
157	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
158	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
159	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
160	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
161	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
162	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
163	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
164	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
165	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
166	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
167	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
168	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
169	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
170	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
171	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
172	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
173	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
174	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
175	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
176	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
177	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
178	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
179	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
180	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
181	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
182	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
183	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
184	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
185	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
186	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
187	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
188	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
189	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
190	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
191	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
192	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
193	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
194	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
195	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
196	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
197	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
198	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
199	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
200	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
201	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
202	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
203	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
204	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
205	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
206	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
207	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
208	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
209	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
210	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
211	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
212	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
213	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
214	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
215	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
216	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
217	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
218	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
219	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
220	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
221	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
222	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
223	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
224	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
225	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
226	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
227	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
228	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
229	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
230	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
231	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
232	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
233	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
234	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
235	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
236	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
237	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
238	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
239	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
240	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
241	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
242	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
243	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
244	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
245	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
246	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
247	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
248	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
249	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
250	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
251	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
252	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
253	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
254	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
255	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
256	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
257	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
258	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
259	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
260	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
261	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
262	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
263	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
264	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
265	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
266	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
267	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
268	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
269	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
270	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
271	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
272	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
273	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
274	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
275	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
276	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
277	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
278	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
279	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
280	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
281	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
282	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
283	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
284	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
285	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
286	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
287	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
288	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
289	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
290	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
291	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
292	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
293	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
294	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
295	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
296	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
297	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
298	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
299	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
300	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
301	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
302	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
303	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
304	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
305	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
306	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
307	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
308	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
309	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
310	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
311	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
312	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
313	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
314	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
315	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
316	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
317	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
318	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
319	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
320	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
321	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
322	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
323	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
324	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
325	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
326	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
327	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
328	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
329	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
330	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
331	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
332	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
333	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
334	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
335	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
336	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
337	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
338	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
339	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
340	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
341	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
342	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
343	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
344	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
345	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
346	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
347	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
348	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
349	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
350	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
351	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
352	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
353	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
354	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
355	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
356	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
357	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
358	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
359	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
360	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
361	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
362	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
363	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
364	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
365	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
366	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
367	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
368	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
369	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
370	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
371	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
372	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
373	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
374	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
375	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
376	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
377	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
378	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
379	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
380	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
381	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
382	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
383	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
384	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
385	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
386	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
387	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
388	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
389	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
390	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
391	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
392	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
393	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
394	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
395	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
396	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
397	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
398	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
399	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
400	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
401	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
402	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
403	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
404	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
405	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
406	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
407	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
408	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
409	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
410	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
411	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
412	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
413	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
414	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
415	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
416	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
417	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
418	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
419	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
420	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
421	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
422	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
423	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
424	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
425	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
426	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
427	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
428	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
429	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
430	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
431	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
432	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
433	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
434	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
435	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
436	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
437	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
438	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
439	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
440	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
441	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
442	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
443	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
444	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
445	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
446	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
447	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
448	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
449	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
450	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
451	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
452	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
453	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
454	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
455	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
456	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
457	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
458	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
459	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
460	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
461	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
462	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
463	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
464	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
465	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
466	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
467	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
468	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
469	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
470	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
471	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
472	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
473	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
474	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
475	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
476	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
477	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
478	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
479	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
480	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
481	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
482	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
483	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
484	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
485	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
486	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
487	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
488	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
489	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
490	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
491	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
492	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
493	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
494	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
495	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
496	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
497	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
498	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
499	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
500	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
501	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
502	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
503	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
504	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
505	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
506	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
507	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
508	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
509	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
510	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
511	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
512	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
513	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
514	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
515	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
516	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
517	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
518	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
519	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
520	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
521	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
522	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
523	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
524	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
525	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
526	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
527	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
528	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
529	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
530	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
531	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
532	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
533	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
534	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
535	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
536	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
537	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
538	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
539	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
540	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
541	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
542	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
543	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
544	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
545	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
546	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
547	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
548	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
549	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
550	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
551	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
552	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
553	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
554	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
555	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
556	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
557	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
558	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
559	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
560	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
561	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
562	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
563	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
564	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
565	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
566	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
567	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
568	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
569	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	\N
105	\N	\N	f	\N	f	f	f	\N	f	\N	f	\N	\N	A TERMINO	O+
\.


--
-- Data for Name: Horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Horario" ("Id_horario", "Id_seccion", "Id_aula", "Id_profesor", "Id_bloque", "Id_dia") FROM stdin;
\.


--
-- Data for Name: Incidencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Incidencia" ("Id_incidencia", tipo_incidencia, descripcion, fecha_incidencia, "Id_estudiante", "Id_usuario_involucrado", "Id_usuario_reporta") FROM stdin;
\.


--
-- Data for Name: Lapso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") FROM stdin;
1	I LAPSO	2026-09-15	2026-12-15	1
2	II LAPSO	2027-01-10	2027-04-05	1
3	III LAPSO	2027-04-15	2027-07-15	1
4	I LAPSO	2025-09-15	2025-12-15	3
5	II LAPSO	2026-01-10	2026-04-05	3
6	III LAPSO	2026-04-15	2026-07-15	3
\.


--
-- Data for Name: Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) FROM stdin;
1	Iniciación a la Danza	7	practica	2	A través de la plástica, la música y juegos
2	Danza Tradicional	7	practica	1	Bailes y juegos tradicionales
3	Preparación Física	7	practica	1	Desarrollo de condiciones físicas iniciales
4	Música	7	teorica	1	Impartida de manera teórica y práctica (lúdica)
5	Danza Clásica	8	practica	6	\N
6	Danza Tradicional	8	practica	4	\N
7	Danza Creativa	8	practica	2	Enfocada a fortalecer la asignatura Danza Contemporánea
8	Música	8	teorica	1	\N
9	Preparación Física	8	practica	1	Con asesoría nutricional
10	Francés 1	8	teorica	1	Código universal dentro de la danza clásica
11	Danza Clásica	9	practica	6	\N
12	Danza Tradicional	9	practica	4	\N
13	Danza Creativa	9	practica	2	Enfocada a fortalecer Danza Contemporánea
14	Música	9	teorica	2	Hora de 60 minutos
15	Preparación Física	9	practica	2	\N
16	Historia de la Danza	9	teorica	1	Seminario durante el año escolar
17	Francés 2	9	teorica	1	Taller al final de cada trimestre
18	Nutrición	9	teorica	1	Taller al final de cada trimestre
19	Danza Clásica	10	practica	6	\N
20	Danza Tradicional	10	practica	6	\N
21	Danza Contemporánea	10	practica	4	\N
22	Música	10	teorica	2	\N
23	Preparación Física	10	practica	1	\N
24	Historia de la Danza	10	teorica	1	Seminario durante el año escolar
25	Francés	10	teorica	1	Taller al final de cada trimestre
26	Nutrición	10	teorica	1	Taller al final de cada trimestre
27	Danza Clásica	11	practica	6	\N
28	Danza Tradicional	11	practica	6	\N
29	Danza Contemporánea	11	practica	6	\N
30	Música	11	teorica	1	\N
31	Preparación Física	11	practica	1	\N
32	Repertorio Clásico	11	teorico-practica	1	Teórico-práctica
33	Repertorio Tradicional	11	teorico-practica	1	Teórico-práctica
34	Repertorio Contemporáneo	11	teorico-practica	1	Teórico-práctica
35	Danza Clásica	12	practica	10	\N
36	Danza Tradicional	12	practica	2	\N
37	Danza Contemporánea	12	practica	4	\N
38	Historia de la Danza	12	teorica	1	Enfocada a la especialidad
39	Repertorio	12	practica	2	\N
40	Composición Coreográfica	12	practica	2	\N
41	Kinesiología	12	teorica	1	\N
42	Danza Clásica	13	practica	10	\N
43	Danza Tradicional	13	practica	2	\N
44	Danza Contemporánea	13	practica	2	\N
45	Historia de la Danza	13	teorica	1	\N
46	Repertorio	13	practica	2	\N
47	Composición Coreográfica	13	practica	2	\N
48	Pas de deux	13	practica	2	\N
49	Danzas de Carácter	13	practica	1	\N
50	Danza Clásica	14	practica	10	\N
51	Danza Tradicional	14	practica	2	\N
52	Danza Contemporánea	14	practica	2	\N
53	Repertorio	14	practica	4	\N
54	Pas de deux	14	practica	4	\N
55	Producción Escénica	14	teorico-practica	2	Taller
56	Danzas de Carácter	14	practica	2	\N
57	Danza Clásica	15	practica	10	\N
58	Danza Tradicional	15	practica	2	\N
59	Danza Contemporánea	15	practica	2	\N
60	Repertorio	15	practica	5	\N
61	Proyecto Comunitario	15	teorico-practica	4	40 horas distribuidas en el año escolar
62	Integración Artística - Profesional	15	practica	2	\N
63	Danza Tradicional	16	practica	10	\N
64	Danza Clásica	16	practica	2	\N
65	Danza Contemporánea	16	practica	2	\N
66	Teoría de la Cultura	16	teorica	2	\N
67	Indumentaria, Elementos e Imágenes Populares	16	teorico-practica	2	\N
68	Kinesiología	16	teorica	1	\N
69	Elementos del Teatro para la Danza Tradicional	16	practica	2	\N
70	Apreciación Musical	16	teorica	1	Aplicada a la especialidad
71	Preparación Física	16	practica	2	\N
72	Danza Tradicional	17	practica	10	\N
73	Danza Clásica	17	practica	2	\N
74	Danza Contemporánea	17	practica	2	\N
75	Historia de las Tradiciones Venezolanas	17	teorica	2	\N
76	Indumentaria, Elementos e Imágenes Populares	17	teorico-practica	2	\N
77	Elementos del Teatro para la Danza Tradicional	17	practica	2	\N
78	Apreciación Musical	17	teorica	1	Aplicada a la especialidad
79	Preparación Física	17	practica	2	\N
80	Danza Tradicional	18	practica	10	\N
81	Danza Clásica	18	practica	2	\N
82	Danza Contemporánea	18	practica	2	\N
83	Danza Latinoamericana y Caribeña	18	practica	2	\N
84	Historia de las Tradiciones Venezolanas	18	teorica	2	\N
85	Indumentaria, Elementos e Imágenes Populares	18	teorico-practica	2	\N
86	Elementos del Teatro para la Danza Tradicional	18	practica	2	\N
87	Apreciación Musical	18	teorica	1	Aplicada a la especialidad
88	Producción Artística	18	teorico-practica	2	\N
89	Danza Tradicional	19	practica	10	Producción artística
90	Danza Clásica	19	practica	2	\N
91	Danza Contemporánea	19	practica	2	\N
92	Danza Latinoamericana y Caribeña	19	practica	2	\N
93	Historia de las Tradiciones Venezolanas	19	teorica	2	\N
94	Análisis de la Proyección de la Danza Tradicional en Venezuela	19	teorica	2	\N
95	Proyecto Comunitario	19	teorico-practica	4	40 horas distribuidas en el año escolar
96	Integración Artística - Profesional	19	practica	2	\N
97	Danza Contemporánea	20	practica	10	\N
98	Danza Tradicional	20	practica	2	\N
99	Danza Clásica	20	practica	4	\N
100	Historia y Precursores de la Danza Contemporánea	20	teorica	1	\N
101	Preparación Física	20	practica	2	\N
102	Composición Coreográfica	20	practica	2	\N
103	Kinesiología	20	teorica	1	\N
104	Música	20	teorica	1	\N
105	Danza Contemporánea	21	practica	10	\N
106	Danza Tradicional	21	practica	2	\N
107	Danza Clásica	21	practica	4	\N
108	Preparación Física	21	practica	2	\N
109	Composición Coreográfica	21	practica	3	\N
110	Música	21	teorica	1	\N
111	Danza Contemporánea	22	practica	10	\N
112	Danza Tradicional	22	practica	2	\N
113	Danza Clásica	22	practica	2	\N
114	Preparación Física	22	practica	2	\N
115	Historia y Precursores de la Danza Contemporánea en Venezuela	22	teorica	1	\N
116	Composición Coreográfica	22	practica	4	\N
117	Producción Escénica	22	teorico-practica	2	\N
118	Técnicas Aplicadas a la Danza Contemporánea	22	practica	1	\N
119	Danza Contemporánea	23	practica	10	\N
120	Danza Tradicional	23	practica	2	\N
121	Danza Clásica	23	practica	2	\N
122	Preparación Física	23	practica	2	\N
123	Repertorio Contemporáneo	23	practica	5	\N
124	Técnicas Aplicadas a la Danza Contemporánea	23	practica	1	\N
125	Proyecto Comunitario	23	teorico-practica	4	40 horas distribuidas en el año escolar
126	Integración Artística - Profesional	23	practica	2	\N
127	Música	17	teorica	2	\N
128	Producción Escénica	17	teorico-practica	2	\N
129	Composición Coreográfica	14	practica	2	\N
130	Preparación Física	14	practica	2	\N
131	Preparación Física	18	practica	2	\N
132	Preparación Física	15	practica	2	\N
\.


--
-- Data for Name: Municipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Municipio" ("Id_municipio", "Id_estado", nombre_municipio) FROM stdin;
\.


--
-- Data for Name: Nivel_Danza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) FROM stdin;
6	Preparatorio
7	1er Año
8	2do Año
9	3er Año
10	4to Año
11	5to Año - Danza Clásica
12	6to Año - Danza Clásica
13	7mo Año - Danza Clásica
14	8vo Año - Danza Clásica
15	5to Año - Danza Tradicional
16	6to Año - Danza Tradicional
17	7mo Año - Danza Tradicional
18	8vo Año - Danza Tradicional
19	5to Año - Danza Contemporánea
20	6to Año - Danza Contemporánea
21	7mo Año - Danza Contemporánea
22	8vo Año - Danza Contemporánea
25	Pre-Ballet
\.


--
-- Data for Name: Nivel_Escolar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Nivel_Escolar" ("Id_nivel", nivel) FROM stdin;
\.


--
-- Data for Name: Nota_Competencia_Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Nota_Competencia_Estudiante" ("Id_estudiante_competencia", puntaje, observacion, "Id_nota", "Id_competencia") FROM stdin;
\.


--
-- Data for Name: Padre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Padre" ("Id_padre", nombre, apellido, cedula, profesion_padre, direccion_trabajo_padre, telefono) FROM stdin;
\.


--
-- Data for Name: Pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pais" ("Id_pais", nombre_pais) FROM stdin;
\.


--
-- Data for Name: Parroquia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Parroquia" ("Id_parroquia", "Id_municipio", nombre_parroquia) FROM stdin;
\.


--
-- Data for Name: Periodo_Inscripcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Periodo_Inscripcion" ("Id_periodo_inscripcion", "Id_ano", fecha_inicio, fecha_fin, activo, creado_en, actualizado_en) FROM stdin;
1	1	2026-09-08	2026-09-09	t	2026-09-08 21:38:43.489519-04	2026-09-08 21:38:43.489519-04
2	4	2027-09-01	2028-07-15	f	2026-09-08 21:49:17.612156-04	2026-09-12 09:48:36.999296-04
\.


--
-- Data for Name: Periodo_Subida_Notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Periodo_Subida_Notas" ("Id_periodo_notas", "Id_ano", fecha_inicio, fecha_fin, activo, creado_en, actualizado_en) FROM stdin;
1	4	2027-09-01	2028-07-15	f	2026-09-08 21:49:17.612156-04	2026-09-08 21:49:17.612156-04
\.


--
-- Data for Name: Profesor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profesor" ("Id_profesor", especialidad, "Id_usuario") FROM stdin;
1	Personal de apoyo	2
2	Danza Clásica, Preparación Física	3
3	Danza Tradicional, Preparación Física	5
4	Personal de apoyo	6
5	COORDINADORA ADMINISTRATIVA	7
6	Danza Clásica, Preparación Física, Francés	10
7	Danza Tradicional	12
8	Personal de apoyo	15
9	Danza Contemporánea	16
10	Danza Clásica, Preparación Física	17
11	Danza Tradicional	20
12	Danza Clásica, Repertorio Danza Clásica	21
13	Danza Clásica	23
14	Danza Contemporánea, Repertorio Contemporáneo	24
15	Danza Contemporánea	25
16	Música	26
17	Música	27
18	Danza Contemporánea	28
19	Danza Creativa, Danza Contemporánea, Composición Coreográfica, Preparación Física	30
20	Personal de apoyo	2
21	Danza Clásica, Preparación Física	3
22	Danza Tradicional, Preparación Física	5
23	Personal de apoyo	6
24	COORDINADORA ADMINISTRATIVA	7
25	Preparación Física, Iniciación a la Danza, Danza de Carácter	8
26	Danza Clásica, Preparación Física, Francés	10
27	Danza Tradicional, Danza Latinoamericana, Preparación Física	11
28	Danza Tradicional	12
29	Danza Tradicional, Historia de la Danza, Historia de la Danza Contemporánea, Historia de los Precursores de la Danza Contemporánea, Indumentaria y elementos de la Danza Tradicional	13
30	Nutrición, Kinesiología (y control de peso y talla)	14
31	Personal de apoyo	15
32	Danza Contemporánea	16
33	Danza Clásica, Preparación Física	17
34	Danza Tradicional	20
35	Danza Clásica, Repertorio Danza Clásica	21
36	Danza Clásica, Repertorio Clásico, Preparación Física	22
37	Danza Clásica	23
38	Danza Contemporánea, Repertorio Contemporáneo	24
39	Danza Contemporánea	25
40	Música	26
41	Música	27
42	Danza Contemporánea	28
43	\N	425
44	Dirección Académica	1
\.


--
-- Data for Name: Profesor_Especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profesor_Especialidad" ("Id_profesor_especialidad", "Id_profesor", "Id_especialidad", "Id_ano", fecha_asignacion, activo) FROM stdin;
\.


--
-- Data for Name: Profesor_Grado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profesor_Grado" ("Id_profesor", "Id_grado", fecha_asignacion, activo, "Id_ano") FROM stdin;
\.


--
-- Data for Name: Profesor_Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profesor_Materia" ("Id_profesor", "Id_materia") FROM stdin;
\.


--
-- Data for Name: Representante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") FROM stdin;
68	t	\N	\N	126
69	t	\N	\N	127
70	t	\N	\N	128
71	t	\N	\N	129
72	t	\N	\N	130
73	t	\N	\N	131
74	t	\N	\N	132
75	t	\N	\N	133
76	t	\N	\N	134
77	t	\N	\N	135
78	t	\N	\N	136
79	t	\N	\N	137
80	t	\N	\N	138
81	t	\N	\N	139
82	t	\N	\N	140
83	t	\N	\N	141
84	t	\N	\N	142
85	t	\N	\N	143
86	t	\N	\N	144
87	t	\N	\N	145
88	t	\N	\N	146
89	t	\N	\N	147
90	t	\N	\N	148
91	t	\N	\N	149
92	t	\N	\N	150
93	t	\N	\N	151
94	t	\N	\N	152
95	t	\N	\N	153
96	t	\N	\N	154
97	t	\N	\N	155
98	t	\N	\N	156
99	t	\N	\N	157
100	t	\N	\N	158
101	t	\N	\N	159
102	t	\N	\N	160
103	t	\N	\N	161
104	t	\N	\N	162
105	t	\N	\N	163
106	t	\N	\N	164
107	t	\N	\N	165
108	t	\N	\N	166
109	t	\N	\N	167
110	t	\N	\N	168
111	t	\N	\N	169
112	t	\N	\N	170
113	t	\N	\N	171
114	t	\N	\N	172
115	t	\N	\N	173
116	t	\N	\N	174
117	t	\N	\N	175
118	t	\N	\N	176
119	t	\N	\N	177
120	t	\N	\N	178
121	t	\N	\N	179
122	t	\N	\N	180
123	t	\N	\N	181
124	t	\N	\N	182
125	t	\N	\N	183
126	t	\N	\N	184
127	t	\N	\N	185
128	t	\N	\N	186
129	t	\N	\N	187
130	t	\N	\N	188
131	t	\N	\N	189
132	t	\N	\N	190
133	t	\N	\N	191
134	t	\N	\N	192
135	t	\N	\N	193
136	t	\N	\N	194
137	t	\N	\N	195
138	t	\N	\N	196
139	t	\N	\N	197
140	t	\N	\N	198
141	t	\N	\N	199
142	t	\N	\N	200
143	t	\N	\N	201
144	t	\N	\N	202
145	t	\N	\N	203
146	t	\N	\N	204
147	t	\N	\N	205
148	t	\N	\N	206
149	t	\N	\N	207
150	t	\N	\N	208
151	t	\N	\N	209
152	t	\N	\N	210
153	t	\N	\N	211
154	t	\N	\N	212
155	t	\N	\N	213
156	t	\N	\N	214
157	t	\N	\N	215
158	t	\N	\N	216
159	t	\N	\N	217
160	t	\N	\N	218
161	t	\N	\N	219
162	t	\N	\N	220
163	t	\N	\N	221
164	t	\N	\N	222
165	t	\N	\N	223
166	t	\N	\N	224
167	t	\N	\N	225
168	t	\N	\N	226
169	t	\N	\N	227
170	t	\N	\N	228
171	t	\N	\N	229
172	t	\N	\N	230
173	t	\N	\N	231
174	t	\N	\N	232
175	t	\N	\N	233
176	t	\N	\N	234
177	t	\N	\N	235
178	t	\N	\N	236
179	t	\N	\N	237
180	t	\N	\N	238
181	t	\N	\N	239
182	t	\N	\N	240
183	t	\N	\N	241
184	t	\N	\N	242
185	t	\N	\N	243
186	t	\N	\N	244
187	t	\N	\N	245
188	t	\N	\N	246
189	t	\N	\N	247
190	t	\N	\N	248
191	t	\N	\N	249
192	t	\N	\N	250
193	t	\N	\N	251
194	t	\N	\N	252
195	t	\N	\N	253
196	t	\N	\N	254
197	t	\N	\N	255
198	t	\N	\N	256
199	t	\N	\N	257
200	t	\N	\N	258
201	t	\N	\N	259
202	t	\N	\N	260
203	t	\N	\N	261
204	t	\N	\N	262
205	t	\N	\N	263
206	t	\N	\N	264
207	t	\N	\N	265
208	t	\N	\N	266
209	t	\N	\N	267
210	t	\N	\N	268
211	t	\N	\N	269
212	t	\N	\N	270
213	t	\N	\N	271
214	t	\N	\N	272
215	t	\N	\N	273
216	t	\N	\N	274
217	t	\N	\N	275
218	t	\N	\N	276
219	t	\N	\N	277
220	t	\N	\N	278
221	t	\N	\N	279
222	t	\N	\N	280
223	t	\N	\N	281
224	t	\N	\N	282
225	t	\N	\N	283
226	t	\N	\N	284
227	t	\N	\N	285
228	t	\N	\N	286
229	t	\N	\N	287
230	t	\N	\N	288
231	t	\N	\N	289
232	t	\N	\N	290
233	t	\N	\N	291
234	t	\N	\N	292
235	t	\N	\N	293
236	t	\N	\N	294
237	t	\N	\N	295
238	t	\N	\N	296
239	t	\N	\N	297
240	t	\N	\N	298
241	t	\N	\N	299
242	t	\N	\N	300
243	t	\N	\N	301
244	t	\N	\N	302
245	t	\N	\N	303
246	t	\N	\N	304
247	t	\N	\N	305
248	t	\N	\N	306
249	t	\N	\N	307
250	t	\N	\N	308
251	t	\N	\N	309
252	t	\N	\N	310
253	t	\N	\N	311
254	t	\N	\N	312
255	t	\N	\N	313
256	t	\N	\N	314
257	t	\N	\N	315
258	t	\N	\N	316
259	t	\N	\N	317
260	t	\N	\N	318
261	t	\N	\N	319
262	t	\N	\N	320
263	t	\N	\N	321
264	t	\N	\N	322
265	t	\N	\N	323
266	t	\N	\N	324
267	t	\N	\N	325
268	t	\N	\N	326
269	t	\N	\N	327
270	t	\N	\N	328
271	t	\N	\N	329
272	t	\N	\N	330
273	t	\N	\N	331
274	t	\N	\N	332
275	t	\N	\N	333
276	t	\N	\N	334
277	t	\N	\N	335
278	t	\N	\N	336
279	t	\N	\N	337
280	t	\N	\N	338
281	t	\N	\N	339
282	t	\N	\N	340
283	t	\N	\N	341
284	t	\N	\N	342
285	t	\N	\N	343
286	t	\N	\N	344
287	t	\N	\N	345
288	t	\N	\N	346
289	t	\N	\N	347
290	t	\N	\N	348
291	t	\N	\N	349
292	t	\N	\N	350
293	t	\N	\N	351
294	t	\N	\N	352
295	t	\N	\N	353
296	t	\N	\N	354
297	t	\N	\N	355
298	t	\N	\N	356
299	t	\N	\N	357
300	t	\N	\N	358
301	t	\N	\N	359
302	t	\N	\N	360
303	t	\N	\N	361
304	t	\N	\N	362
305	t	\N	\N	363
306	t	\N	\N	364
307	t	\N	\N	365
308	t	\N	\N	366
309	t	\N	\N	367
310	t	\N	\N	368
311	t	\N	\N	369
312	t	\N	\N	370
313	t	\N	\N	371
314	t	\N	\N	372
315	t	\N	\N	373
316	t	\N	\N	374
317	t	\N	\N	375
318	t	\N	\N	376
319	t	\N	\N	377
320	t	\N	\N	378
321	t	\N	\N	379
322	t	\N	\N	380
323	t	\N	\N	381
324	t	\N	\N	382
325	t	\N	\N	383
326	t	\N	\N	384
327	t	\N	\N	385
328	t	\N	\N	386
329	t	\N	\N	387
330	t	\N	\N	388
331	t	\N	\N	389
332	t	\N	\N	390
333	t	\N	\N	391
334	t	\N	\N	392
335	t	\N	\N	393
336	t	\N	\N	394
337	t	\N	\N	395
338	t	\N	\N	396
339	t	\N	\N	397
340	t	\N	\N	398
341	t	\N	\N	399
342	t	\N	\N	400
343	t	\N	\N	401
344	t	\N	\N	402
345	t	\N	\N	403
346	t	\N	\N	404
347	t	\N	\N	405
348	t	\N	\N	406
349	t	\N	\N	407
350	t	\N	\N	408
351	t	\N	\N	409
352	t	\N	\N	410
353	t	\N	\N	411
354	t	\N	\N	412
355	t	\N	\N	413
356	t	\N	\N	414
357	t	\N	\N	415
358	t	\N	\N	416
359	t	\N	\N	417
360	t	\N	\N	418
361	t	\N	\N	419
362	t	\N	\N	420
363	t	\N	\N	421
364	t	\N	\N	422
365	t	\N	\N	423
366	t	\N	\N	424
367	t	\N	\N	426
368	t	\N	\N	427
369	t	\N	\N	428
370	t	\N	\N	429
67	t	\N	\N	125
371	t	Administrador del Sistema	ENDANZA	1
\.


--
-- Data for Name: Revision_Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Revision_Materia" ("Id_revision", "Id_estudiante", "Id_materia", "Id_ano", nota_definitiva, nota_revision, estado, observacion, fecha_creacion, fecha_revision, creado_por) FROM stdin;
\.


--
-- Data for Name: Rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rol" ("Id_rol", tipo_rol) FROM stdin;
1	Administrador
2	Docente
3	Estudiante
4	Representante
5	Secretaria
\.


--
-- Data for Name: Seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") FROM stdin;
1	C	30	72	4	3
2	C	30	72	5	3
3	C	30	72	6	3
4	C	30	74	4	3
5	C	30	74	5	3
6	C	30	74	6	3
7	C	30	73	4	3
8	C	30	73	5	3
9	C	30	73	6	3
10	C	30	79	4	3
11	C	30	79	5	3
12	C	30	79	6	3
13	C	30	75	4	3
14	C	30	75	5	3
15	C	30	127	4	3
16	C	30	127	5	3
17	C	30	128	4	3
18	C	30	128	5	3
19	A	30	50	4	3
20	A	30	50	5	3
21	A	30	50	6	3
22	A	30	52	4	3
23	A	30	52	5	3
24	A	30	52	6	3
25	A	30	51	4	3
26	A	30	51	5	3
27	A	30	51	6	3
28	A	30	53	4	3
29	A	30	53	5	3
30	A	30	53	6	3
31	A	30	129	4	3
32	A	30	129	5	3
33	A	30	130	4	3
34	A	30	130	5	3
35	A	30	130	6	3
36	A	30	55	4	3
37	A	30	55	5	3
38	B	30	111	4	3
39	B	30	111	5	3
40	B	30	111	6	3
41	B	30	113	4	3
42	B	30	113	5	3
43	B	30	113	6	3
44	B	30	112	4	3
45	B	30	112	5	3
46	B	30	112	6	3
47	B	30	116	4	3
48	B	30	116	5	3
49	B	30	114	4	3
50	B	30	114	5	3
51	B	30	114	6	3
52	B	30	115	4	3
53	B	30	115	5	3
54	C	30	80	4	3
55	C	30	80	5	3
56	C	30	80	6	3
57	C	30	82	4	3
58	C	30	82	5	3
59	C	30	82	6	3
60	C	30	81	4	3
61	C	30	81	5	3
62	C	30	81	6	3
63	C	30	83	4	3
64	C	30	83	5	3
65	C	30	83	6	3
66	C	30	84	4	3
67	C	30	84	5	3
68	C	30	88	4	3
69	C	30	88	5	3
70	C	30	131	4	3
71	C	30	131	5	3
72	C	30	131	6	3
73	A	30	57	4	3
74	A	30	57	5	3
75	A	30	57	6	3
76	A	30	59	4	3
77	A	30	59	5	3
78	A	30	59	6	3
79	A	30	58	4	3
80	A	30	58	5	3
81	A	30	58	6	3
82	A	30	60	4	3
83	A	30	60	5	3
84	A	30	60	6	3
85	A	30	132	4	3
86	A	30	132	5	3
87	A	30	132	6	3
\.


--
-- Data for Name: Seguro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Seguro" ("Id_seguro", tipo_seguro) FROM stdin;
\.


--
-- Data for Name: Solicitud_Constancia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Solicitud_Constancia" ("Id_solicitud", tipo_constancia, fecha_solicitud, estatus, "Id_estudiante", "Id_representante") FROM stdin;
\.


--
-- Data for Name: Tipo_Clase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) FROM stdin;
1	Práctica
2	Teórica
3	Teórico-Práctica
4	Común / Usos Múltiples
\.


--
-- Data for Name: Tipo_Evaluacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Tipo_Evaluacion" ("Id_tipo_evaluacion", nombre_evaluacion) FROM stdin;
2	Evaluación de Lapso
\.


--
-- Data for Name: Usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) FROM stdin;
2	V-9248324	VILMAN OMAR	CARRERO MALDONADO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	vilman.carrero8324@endanza.com	1968-12-13	\N	\N	Activo	\N	\N	2	\N	vilman8324	\N	\N	\N	\N	\N	f	\N	\N
3	V-29830107	MARIETH FERNANDA	DEVIA ESCALANTE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	marieth.devia0107@endanza.com	2002-01-21	\N	\N	Activo	\N	\N	2	\N	marieth0107	\N	\N	\N	\N	\N	f	\N	\N
4	V-15080054	SABRINA DE LOS ANGELES	FLORES PINEDA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	sabrina.flores0054@endanza.com	1980-09-29	\N	\N	Activo	\N	\N	1	\N	sabrina0054	\N	\N	\N	\N	\N	f	\N	\N
5	V-25980485	BETANIA DE LOS ÁNGELES	GARCÍA VIVAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	betania.garcia0485@endanza.com	1997-01-26	\N	\N	Activo	\N	\N	2	\N	betania0485	\N	\N	\N	\N	\N	f	\N	\N
6	V-14179269	YELITZA ROSALIA	GUERRERO GUERRERO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	yelitza.guerrero9269@endanza.com	1977-11-02	\N	\N	Activo	\N	\N	2	\N	yelitza9269	\N	\N	\N	\N	\N	f	\N	\N
7	V-6810884	LOPEZ GISELA ILNELU	JACKSON DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	lopez.jackson0884@endanza.com	1963-01-19	\N	\N	Activo	\N	\N	2	\N	lopez0884	\N	\N	\N	\N	\N	f	\N	\N
8	V-30617219	VALERIA SOFÍA	OJEDA ZAMBRANO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	valeria.ojeda7219@endanza.com	2004-08-20	\N	\N	Activo	\N	\N	2	\N	valeria7219	\N	\N	\N	\N	\N	f	\N	\N
9	V-5674902	RAMÍREZ ROSA EMILIA	PERNÍA DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ramirez.pernia4902@endanza.com	1963-08-30	\N	\N	Activo	\N	\N	1	\N	ramirez4902	\N	\N	\N	\N	\N	f	\N	\N
10	V-28195359	PAOLA MAYELLA	RICO PORRAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	paola.rico5359@endanza.com	2001-10-02	\N	\N	Activo	\N	\N	2	\N	paola5359	\N	\N	\N	\N	\N	f	\N	\N
11	V-20121208	ADRIANA SARAI	RUIZ VIVAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	adriana.ruiz1208@endanza.com	1992-04-10	\N	\N	Activo	\N	\N	2	\N	adriana1208	\N	\N	\N	\N	\N	f	\N	\N
12	V-19915196	ALVARO RENNIER	SOLANO VARELA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	alvaro.solano5196@endanza.com	1989-05-30	\N	\N	Activo	\N	\N	2	\N	alvaro5196	\N	\N	\N	\N	\N	f	\N	\N
13	V-3911521	WILFREDO	TERÁN	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	wilfredo.teran1521@endanza.com	1950-09-20	\N	\N	Activo	\N	\N	2	\N	wilfredo1521	\N	\N	\N	\N	\N	f	\N	\N
14	V-7304367	IVETTE DEL CARMEN	TOVAR DOMINGUEZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ivette.tovar4367@endanza.com	1961-05-30	\N	\N	Activo	\N	\N	2	\N	ivette4367	\N	\N	\N	\N	\N	f	\N	\N
15	V-12112581	LINDA	VADILLO ADA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	linda.vadillo2581@endanza.com	1977-12-17	\N	\N	Activo	\N	\N	2	\N	linda2581	\N	\N	\N	\N	\N	f	\N	\N
16	V-31122871	VANESSA CAROLINA	VILLASMIL MATA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	vanessa.villasmil2871@endanza.com	2006-01-23	\N	\N	Activo	\N	\N	2	\N	vanessa2871	\N	\N	\N	\N	\N	f	\N	\N
17	V-29830219	SARAH VALENTINA	ZAMBRANO GUERRERO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	sarah.zambrano0219@endanza.com	2002-01-23	\N	\N	Activo	\N	\N	2	\N	sarah0219	\N	\N	\N	\N	\N	f	\N	\N
18	V-12351245	ANA LETICIA	ZAMBRANO PÉREZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ana.zambrano1245@endanza.com	1975-08-02	\N	\N	Activo	\N	\N	5	\N	ana1245	\N	\N	\N	\N	\N	f	\N	\N
19	V-10169482	PARRA CONSUELO	TRIVIÑO DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	parra.trivino9482@endanza.com	1954-01-02	\N	\N	Activo	\N	\N	5	\N	parra9482	\N	\N	\N	\N	\N	f	\N	\N
20	V-32610676	ARIANNA NICOLLE	AMAYA RAMÍREZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	arianna.amaya0676@endanza.com	2008-02-01	\N	\N	Activo	\N	\N	2	\N	arianna0676	\N	\N	\N	\N	\N	f	\N	\N
22	V-30890719	CAMILY AMARANTA	CÁCERES LEAL	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	camily.caceres0719@endanza.com	2004-10-11	\N	\N	Activo	\N	\N	2	\N	camily0719	\N	\N	\N	\N	\N	f	\N	\N
23	V-31762867	MARÍA LAURA	CASTRO HART	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	maria.castro2867@endanza.com	2006-06-16	\N	\N	Activo	\N	\N	2	\N	maria2867	\N	\N	\N	\N	\N	f	\N	\N
24	V-27239670	DANIELA	DÍAZ ALIX	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	daniela.diaz9670@endanza.com	2000-04-04	\N	\N	Activo	\N	\N	2	\N	daniela9670	\N	\N	\N	\N	\N	f	\N	\N
25	V-26403133	ROSELBI PAOLA	GARCÍA COLMENARES	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	roselbi.garcia3133@endanza.com	1998-06-16	\N	\N	Activo	\N	\N	2	\N	roselbi3133	\N	\N	\N	\N	\N	f	\N	\N
26	V-30626110	HANNA	RAMOS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	hanna.ramos6110@endanza.com	2004-12-30	\N	\N	Activo	\N	\N	2	\N	hanna6110	\N	\N	\N	\N	\N	f	\N	\N
27	V-30296992	JOSÉ	ROA MARÍA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	jose.roa6992@endanza.com	2002-04-02	\N	\N	Activo	\N	\N	2	\N	jose6992	\N	\N	\N	\N	\N	f	\N	\N
28	V-30981792	VALERIA	URBINA PERNÍA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	valeria.urbina1792@endanza.com	2004-12-11	\N	\N	Activo	\N	\N	2	\N	valeria1792	\N	\N	\N	\N	\N	f	\N	\N
29	V-11504462	JENNICE FIORELLA	ZAMBRANO SÁNCHEZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	jennice.zambrano4462@endanza.com	1974-12-07	\N	\N	Activo	\N	\N	5	\N	jennice4462	\N	\N	\N	\N	\N	f	\N	\N
21	V-30523907	JULIETH FERNANDA	BELEÑO SANDOVAL	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	julieth.beleno3907@endanza.com	2003-10-13	\N	\N	Activo	\N	2026-07-29 14:20:47.793605-04	2	\N	julieth3907	\N	\N	\N	\N	\N	f	2026-07-29 14:20:47.793605	\N
126	\N	DAYANA ANDREINA	RIVERA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04266715655	azulrivera23@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	azulrivera23	\N	\N	\N	\N	\N	f	\N	\N
127	\N	LORENA	BECERRA ORTIZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04127135648	pigmentacion_correctiva@yahoo.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	pigmentacion_correctiva	\N	\N	\N	\N	\N	f	\N	\N
128	\N	SURLEY	SANGUINO CASERES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7185063	surley1979@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	surley1979	\N	\N	\N	\N	\N	f	\N	\N
129	\N	MERLY ANDREINA	RAMÍREZ MARTÍNEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7197060	merlyramirez665@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	merlyramirez665	\N	\N	\N	\N	\N	f	\N	\N
130	\N	MAYRALEJA28 ALEJANDRA	HERNÁNDEZ BARRIOS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147005848	mayra.adriam@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mayra.adriam	\N	\N	\N	\N	\N	f	\N	\N
131	\N	MARIAN DAYL	PRIETO CARDENAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247614816	mprieto4782@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mprieto4782	\N	\N	\N	\N	\N	f	\N	\N
132	\N	JOHANA LISBETH	RODRIGUEZ SIERRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-9713190	joharod2005@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	joharod2005	\N	\N	\N	\N	\N	f	\N	\N
133	\N	YOSAIRA	SARCIA RUJANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247132268	yosairagarcia1218@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yosairagarcia1218	\N	\N	\N	\N	\N	f	\N	\N
30	V-25020014	NIKAILA CLISMAR	CASTELLANOS ALVIAREZ	$2b$10$qPRR220D.GcHgLT6WdCRe.PlJVWXsYXEVqFTB7ROBam0dGHXbMT3.	\N	nikaila.castellanos0014@endanza.com	1996-01-09	\N	\N	Activo	\N	2026-09-08 21:54:25.704648-04	2	\N	nikaila0014	\N	\N	\N	\N	\N	f	2026-09-08 21:54:25.704648	\N
125	12345678	Diana Carolina	Gallo Cardenas	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7040216	diannakarolinna@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	2026-09-11 15:27:51.093539-04	4	\N	diannakarolinna	\N	\N	\N	\N	\N	f	\N	\N
134	\N	MARIA YESENIA	RAMIREZ SANTANA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04265775956	yesyanth20@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yesyanth20	\N	\N	\N	\N	\N	f	\N	\N
135	\N	MARIA ANDREINA	PULIDO ANGARITA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247427831	andre.pulido19@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	andre.pulido19	\N	\N	\N	\N	\N	f	\N	\N
136	\N	MARIA ANDREINA	PULIDO ANGARITA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247427831	andre.pulido@19gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	andre.pulido	\N	\N	\N	\N	\N	f	\N	\N
137	\N	LUCILA CORORMOTO	NAVA CARRILLO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247031672	lucynava78@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lucynava78	\N	\N	\N	\N	\N	f	\N	\N
138	\N	LUCILA COROMOTO	NAVAS CARRILLO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	02763940798	lucynavas@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lucynavas	\N	\N	\N	\N	\N	f	\N	\N
139	\N	FRANGGY KRISELL	BECERRA MONSALVE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147214989	franggykbm@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	franggykbm	\N	\N	\N	\N	\N	f	\N	\N
140	\N	CAROLINA	COLMENARES VILLAMIZAR	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247841874	carolinacolmenares85@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	carolinacolmenares85	\N	\N	\N	\N	\N	f	\N	\N
253	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_198@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_198	\N	\N	\N	\N	\N	f	\N	\N
141	\N	JUDITH VIZAY	RUÍZ MORALES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121323645	judithvizay@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	judithvizay	\N	\N	\N	\N	\N	f	\N	\N
142	\N	LISBETH	CAÑAS MENDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247241707	molro23@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	molro23	\N	\N	\N	\N	\N	f	\N	\N
143	\N	LISBETH	CAÑAS MENDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247241707	rep_27@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_27	\N	\N	\N	\N	\N	f	\N	\N
144	\N	GREGORIANA DEL CARMEN	PERNIA DE BORRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147366645	krmnpe6@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	krmnpe6	\N	\N	\N	\N	\N	f	\N	\N
145	\N	RUBI ROSSANA	RUIZ SALCEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121432266	rubi2ruiz@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rubi2ruiz	\N	\N	\N	\N	\N	f	\N	\N
146	\N	NANCY TERESA	ESCALANTE CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7733672	nancyescalante1598@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nancyescalante1598	\N	\N	\N	\N	\N	f	\N	\N
147	\N	INGRID SOLANYI	VIVAS RUBIANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147407986	ingridvivasr@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ingridvivasr	\N	\N	\N	\N	\N	f	\N	\N
148	\N	ROSA MARIA	JARA DE CARRIEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247285750	yencycarriedo@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yencycarriedo	\N	\N	\N	\N	\N	f	\N	\N
149	\N	ERIKA CONSOLACION	RAMIREZ SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247030646	erikaconsolacion1977@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	erikaconsolacion1977	\N	\N	\N	\N	\N	f	\N	\N
150	\N	OLIEVAN YELENA	CONTRAMAESTRE HERNANDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247477675	aneley1908@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	aneley1908	\N	\N	\N	\N	\N	f	\N	\N
151	\N	AURA TERESA	JAIMES DE MERCHAN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247145318	aurajaimes74@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	aurajaimes74	\N	\N	\N	\N	\N	f	\N	\N
152	\N	CELIA	RAMIREZ DE KYRIMLKOGLOU	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04120627190	alekokyri@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	alekokyri	\N	\N	\N	\N	\N	f	\N	\N
153	\N	MARÍA HERCILIA	QUIROZ RINCÓN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416-2788129 / 0424-7848083	mariaherciliaquiroz@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mariaherciliaquiroz	\N	\N	\N	\N	\N	f	\N	\N
154	\N	GLORIA ESPERANZA	GELVEZ SANDOVAL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161730878	gloriae.gelvezs@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gloriae.gelvezs	\N	\N	\N	\N	\N	f	\N	\N
155	\N	KAREN MICHELL	VIVAS VILLAMIZAR	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247050412	karmichell17@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karmichell17	\N	\N	\N	\N	\N	f	\N	\N
156	\N	YUDBEIDA JOSEFINA	FERNANDEZ RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247166710	yudbeidafernandez@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yudbeidafernandez	\N	\N	\N	\N	\N	f	\N	\N
157	\N	ZAIDA YOLIMAR	RICO GUERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147169314	zaidarico56@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	zaidarico56	\N	\N	\N	\N	\N	f	\N	\N
158	\N	ROBERTO DAVID	COLMENARES CELIS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147406327	davidcolmenarescelis@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	davidcolmenarescelis	\N	\N	\N	\N	\N	f	\N	\N
159	\N	FELIDA DEL CARMEN	RAMIREZ ARAQUE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04164764303	felida16378989@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	felida16378989	\N	\N	\N	\N	\N	f	\N	\N
160	\N	VIANA CAROLINA	RODRIGUEZ APARICIO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147081919	vianarodrigueza@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	vianarodrigueza	\N	\N	\N	\N	\N	f	\N	\N
161	\N	CLAREM ROSALIA	RANGEL OSTOS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247815908	lbsbacademica@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lbsbacademica	\N	\N	\N	\N	\N	f	\N	\N
162	\N	CARMEN ALICIA	CONTRERAS RICO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 1757710	rep_63@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_63	\N	\N	\N	\N	\N	f	\N	\N
163	\N	CARMEN ALICIA	CONTRERAS RICO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141757710	adrigene2@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	adrigene2	\N	\N	\N	\N	\N	f	\N	\N
164	\N	DORIS	GOMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7523086	sirodgomez@gmaillcom	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sirodgomez	\N	\N	\N	\N	\N	f	\N	\N
165	\N	SIARIS YADELSI	CRISPIN HERNANDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04127510392	siaris.crispin29@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	siaris.crispin29	\N	\N	\N	\N	\N	f	\N	\N
166	\N	JESSICA ALEJANDRA	BECERRA MOLINA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04146977764	jessica.molina.jr@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jessica.molina.jr	\N	\N	\N	\N	\N	f	\N	\N
167	\N	BEYSI CORINA	ZAMBRANO PARRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04129018718 / 04147400946	beysi2017@gmailcom	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	beysi2017	\N	\N	\N	\N	\N	f	\N	\N
168	\N	SANDRA PATRICIA	VILLAMIZAR ACOSTA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424 7735060	oriana.villamizar08@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	oriana.villamizar08	\N	\N	\N	\N	\N	f	\N	\N
169	\N	AURA STELLA	CHACON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04160488550	auramora062@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	auramora062	\N	\N	\N	\N	\N	f	\N	\N
170	\N	CLAUDIA MARGARITA	TOSCANO DUARTE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04120695323	claudia0169@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	claudia0169	\N	\N	\N	\N	\N	f	\N	\N
171	\N	GENESIS KATHERINE	NEIRA REYES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7446705	genesisneira29@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	genesisneira29	\N	\N	\N	\N	\N	f	\N	\N
172	\N	RINA JOSEFINA	LEAL RIVERA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147265972	rina.26mily@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rina.26mily	\N	\N	\N	\N	\N	f	\N	\N
173	\N	KARLA NACARY	RODRIGYEZSAYAGO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04160723794	karlanacary1984@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karlanacary1984	\N	\N	\N	\N	\N	f	\N	\N
174	\N	SANDRA COROMOTO	SILVA MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147129846	rep_81@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_81	\N	\N	\N	\N	\N	f	\N	\N
175	\N	BRIGITTE SAMIRELLY	CONTRERAS URIBE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04143744333	bcontreras3088@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	bcontreras3088	\N	\N	\N	\N	\N	f	\N	\N
176	\N	SONIA	DELGADO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247619594	sonia69delgado@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sonia69delgado	\N	\N	\N	\N	\N	f	\N	\N
177	\N	EDWARD	HERNANDEZ SANDIA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04149778559	sandiae1987@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sandiae1987	\N	\N	\N	\N	\N	f	\N	\N
178	\N	MARIA JOSE	TORRES AGELVIS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247677671	mariajta1994@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mariajta1994	\N	\N	\N	\N	\N	f	\N	\N
179	\N	TANIA ISLEY	REVERÓN CHACÓN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04249299457	taniadeporte@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	taniadeporte	\N	\N	\N	\N	\N	f	\N	\N
180	\N	YELITZA ROSALIA	GUERRERO GUERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04125219690	yelirosalia77@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yelirosalia77	\N	\N	\N	\N	\N	f	\N	\N
181	\N	ROSALEJANDRA	CAMPOS MARTINES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-9710555	soyalejandra06@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	soyalejandra06	\N	\N	\N	\N	\N	f	\N	\N
182	\N	ADRIANA SOLMAR	OLIVARES DE VIDAL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247635289	adrianaolivares.danza@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	adrianaolivares.danza	\N	\N	\N	\N	\N	f	\N	\N
183	\N	MARLON BRANDO	DIAZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247696160	marlonbrando.0910@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	marlonbrando.0910	\N	\N	\N	\N	\N	f	\N	\N
184	\N	DEYRDRE ALEXANDRA	CONTRERAS DE DIAZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140361691	deyrdrealexandra@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	deyrdrealexandra	\N	\N	\N	\N	\N	f	\N	\N
185	\N	ANGELICA TIBISAY	SANCHEZ PEREIRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247086290	angeliktibisay1210@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	angeliktibisay1210	\N	\N	\N	\N	\N	f	\N	\N
186	\N	EVELYN NATALIA	MERCHAN NAVARRRO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7525645	eve_cami2.014@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	eve_cami2.014	\N	\N	\N	\N	\N	f	\N	\N
187	\N	ADELA JOSEFINA	GONZÁLEZ MUÑOZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04261720982	adelagonzalez123@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	adelagonzalez123	\N	\N	\N	\N	\N	f	\N	\N
188	\N	NETHYA NEDSAY	QUINAYAS BEDOYA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121048123	nethynedsay@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nethynedsay	\N	\N	\N	\N	\N	f	\N	\N
189	\N	FLOR YEANETH	ROJAS PRIETO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147303233	flor_rojasdetorres@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	flor_rojasdetorres	\N	\N	\N	\N	\N	f	\N	\N
190	\N	CARMEN	MONCADA GÁMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140793543	neya_mg@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	neya_mg	\N	\N	\N	\N	\N	f	\N	\N
191	\N	YOSELIN LILIBETH	PEÑA GELVES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7494934	yosecris348@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yosecris348	\N	\N	\N	\N	\N	f	\N	\N
192	\N	MARITZA AURORA	DELGADO VILLAMIL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04263700578	maride2702@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	maride2702	\N	\N	\N	\N	\N	f	\N	\N
193	\N	ANA LETICIA	ZAMBRANO PÉREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04163773835	analeticiazambrano@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	analeticiazambrano	\N	\N	\N	\N	\N	f	\N	\N
194	\N	NEYDA MARITZA	CONTRERAS DE MONTAÑA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147149882	neydamaritza@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	neydamaritza	\N	\N	\N	\N	\N	f	\N	\N
195	\N	YERY COROMOTO	SANGUINO PARADA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0426-4283334	alejandroyery@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	alejandroyery	\N	\N	\N	\N	\N	f	\N	\N
196	\N	HUGO DANIEL	MONCADA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04166712782	hudamo13@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	hudamo13	\N	\N	\N	\N	\N	f	\N	\N
197	\N	NANCY MELANIA	CHACON LOBO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147394988	nancyarq12@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nancyarq12	\N	\N	\N	\N	\N	f	\N	\N
198	\N	JADRYN MACBELLA	HERNÁNDEZ DE LA CRUZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04244931844	jadryn10@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jadryn10	\N	\N	\N	\N	\N	f	\N	\N
199	\N	JADRYN MACBELLA	HERNANDEZ DE LA CRUZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247089888	inversionesnamasteim@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	inversionesnamasteim	\N	\N	\N	\N	\N	f	\N	\N
200	\N	CARMEN GLORIA	CONTRERAS CHACÓN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247251390	karmen147@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karmen147	\N	\N	\N	\N	\N	f	\N	\N
201	\N	KARLA LORENA	JIMÉNEZ DÍAZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	\N	kljd1902@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	kljd1902	\N	\N	\N	\N	\N	f	\N	\N
202	\N	AMANDA BANIGZA	LAGUADO OLIVEROS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04243444151	banigzalaguado03@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	banigzalaguado03	\N	\N	\N	\N	\N	f	\N	\N
203	\N	YOLIMAR DEL VALLE	RAMIREZ SUESCUN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147194042	yramirezsuescun@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yramirezsuescun	\N	\N	\N	\N	\N	f	\N	\N
204	\N	DIOMILEY	DELGADO RAMÌREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161355546	diomyd@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	diomyd	\N	\N	\N	\N	\N	f	\N	\N
205	\N	DARCY YULITZA	CONTRERAS DE GELVES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147473279	darcycontreras0817@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	darcycontreras0817	\N	\N	\N	\N	\N	f	\N	\N
206	\N	ELIANA PAOLA	TORRES ORTEGA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247049848	eliana_0120@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	eliana_0120	\N	\N	\N	\N	\N	f	\N	\N
207	\N	HECLED	RUIZ LOPEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-0451678	ruizhecled@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ruizhecled	\N	\N	\N	\N	\N	f	\N	\N
208	\N	GILMA YANETH	ARDILA LOZADA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247328878	victorbaron1945@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	victorbaron1945	\N	\N	\N	\N	\N	f	\N	\N
209	\N	PAOLA MAYERLIN	OSTOS SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141753660	paolaostos129@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	paolaostos129	\N	\N	\N	\N	\N	f	\N	\N
210	\N	PAOLA MAYERLYN	OSTOS SÁNCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147585808	rep_137@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_137	\N	\N	\N	\N	\N	f	\N	\N
211	\N	JULIANA KARINA	COLMENARES CHACON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147499755	julianakary2710@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	julianakary2710	\N	\N	\N	\N	\N	f	\N	\N
212	\N	ELDA JUDITH	MANRIQUE ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04149744936	ejmz69@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ejmz69	\N	\N	\N	\N	\N	f	\N	\N
213	\N	OLEYDA CECILIA	GUERRERO RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247665881	oleydac@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	oleydac	\N	\N	\N	\N	\N	f	\N	\N
214	\N	LEONARD ALFREDO	APONTE NAVEDA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0426-1667426	leonard.aponte@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	leonard.aponte	\N	\N	\N	\N	\N	f	\N	\N
215	\N	JOSE JOEL	CAMARGO FLORES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147871395	josejoecamargo@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	josejoecamargo	\N	\N	\N	\N	\N	f	\N	\N
216	\N	ALIX	DELGADO HERNÁNDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	+58 414-7926527	arolena22@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	arolena22	\N	\N	\N	\N	\N	f	\N	\N
217	\N	RAÚL ENRIQUE	GÓMEZ MORALES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247830959	r.e.gomez@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	r.e.gomez	\N	\N	\N	\N	\N	f	\N	\N
218	\N	ANGELA YELITZA	CHACON VERA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121052585	angelayeli9@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	angelayeli9	\N	\N	\N	\N	\N	f	\N	\N
219	\N	LUZ DAISSY	HERRERA OVALLE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247224141	luzherrera906@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luzherrera906	\N	\N	\N	\N	\N	f	\N	\N
220	\N	ARELIS	CASTRO DE DUQUE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04245147037	arelishermana@yahoo.es	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	arelishermana	\N	\N	\N	\N	\N	f	\N	\N
221	\N	ARELIS	CASTRO DE DUQUE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04245147037	rep_152@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_152	\N	\N	\N	\N	\N	f	\N	\N
222	\N	EVA YOLEIZA	RODRIGUEZ ALVIAREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04241977112	evvita.24@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	evvita.24	\N	\N	\N	\N	\N	f	\N	\N
223	\N	FABIO	LEON BOAVITA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412 6642621	micabraandina@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	micabraandina	\N	\N	\N	\N	\N	f	\N	\N
224	\N	KAREN	RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147124472	kramanda@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	kramanda	\N	\N	\N	\N	\N	f	\N	\N
225	\N	LISBEY	LOPEZ CALDERON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247389864	lopez_lisbey@yahoo.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lopez_lisbey	\N	\N	\N	\N	\N	f	\N	\N
226	\N	INGRID YUSMARY	FREITES SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247742600	franajufre17@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	franajufre17	\N	\N	\N	\N	\N	f	\N	\N
227	\N	FRANCISCO JAVIER	MÁRQUEZ NIÑO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121241008	franciscomark1969@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	franciscomark1969	\N	\N	\N	\N	\N	f	\N	\N
228	\N	BELKIS	REY RANGEL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147158092	belkisreyrangel@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	belkisreyrangel	\N	\N	\N	\N	\N	f	\N	\N
229	\N	LIZ MARY	ZAMBRANO GUERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04124749010	zambranoguerrerolizmary@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	zambranoguerrerolizmary	\N	\N	\N	\N	\N	f	\N	\N
230	\N	ANA LUCIA	VELAZCO CAICEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141755184	velazcoana26@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	velazcoana26	\N	\N	\N	\N	\N	f	\N	\N
231	\N	ANA LUCIA	VELAZCO CAICEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141755184	rep_165@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_165	\N	\N	\N	\N	\N	f	\N	\N
232	\N	LYZZETTE KATHERINNE	URIBE PORTILLA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147578963	kateuribe@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	kateuribe	\N	\N	\N	\N	\N	f	\N	\N
233	\N	GRECSYS ALEXANDRA	RAMIREZ LANTEN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7060718	grelan29@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	grelan29	\N	\N	\N	\N	\N	f	\N	\N
234	\N	LIGIA GABRIELA	BALLESTEROS DE RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 - 4085485	gsarahi2014@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gsarahi2014	\N	\N	\N	\N	\N	f	\N	\N
235	\N	ALBERTO JAVIER	AMAYA ALARCON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7130843	javieramaya3838@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	javieramaya3838	\N	\N	\N	\N	\N	f	\N	\N
236	\N	LELIS YANIRA	GUERRERO GIERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04163761031	lelisguerrero@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lelisguerrero	\N	\N	\N	\N	\N	f	\N	\N
237	\N	LUISANA	POLANCO AGUILAR	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247629352	luisana.ocnalop@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luisana.ocnalop	\N	\N	\N	\N	\N	f	\N	\N
238	\N	CARMEN YULEYMA	RICO GUERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7465154	yuricota25@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yuricota25	\N	\N	\N	\N	\N	f	\N	\N
239	\N	ALBANY YAJAIRA	GARNICA VARGAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147146239	albanys05@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	albanys05	\N	\N	\N	\N	\N	f	\N	\N
240	\N	MARIELY CAROLINA	CALDERÓN TORRES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147574098	marielycalderontorres@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	marielycalderontorres	\N	\N	\N	\N	\N	f	\N	\N
241	\N	IRWIN EDUARDO	OSTOS CASTRO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247516961	irwinostos02@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	irwinostos02	\N	\N	\N	\N	\N	f	\N	\N
242	\N	LUZ MARINA	ESTEVES CANCHICA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147206539	anyuritacruz@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	anyuritacruz	\N	\N	\N	\N	\N	f	\N	\N
243	\N	MARIA JOSEFA	SANDOVAL RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7363713	mariita182011@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mariita182011	\N	\N	\N	\N	\N	f	\N	\N
244	\N	MAFER ISABEL	MENDEZ GOMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-7671616	hasbelymafer22@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	hasbelymafer22	\N	\N	\N	\N	\N	f	\N	\N
245	\N	LUIS DAYAN	PRATO ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140362630	hannaduque26@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	hannaduque26	\N	\N	\N	\N	\N	f	\N	\N
246	\N	LENYS NOHEMI	FUENTES VERA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04167789416	fuentesveral@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	fuentesveral	\N	\N	\N	\N	\N	f	\N	\N
247	\N	FANNY YORLEY	CARDENAS PEREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7441408	fannyycardenas@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	fannyycardenas	\N	\N	\N	\N	\N	f	\N	\N
248	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_193@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_193	\N	\N	\N	\N	\N	f	\N	\N
249	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_194@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_194	\N	\N	\N	\N	\N	f	\N	\N
250	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_195@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_195	\N	\N	\N	\N	\N	f	\N	\N
251	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_196@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_196	\N	\N	\N	\N	\N	f	\N	\N
252	\N	LINDA	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147109191	rep_197@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_197	\N	\N	\N	\N	\N	f	\N	\N
254	\N	OSCAR VIDAL	MONSALVE VILLAMIZAR	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247833575	rep_199@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_199	\N	\N	\N	\N	\N	f	\N	\N
255	\N	VALESKA	VILLAMIZAR CASANOVA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247025098	vvillamizar@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	vvillamizar	\N	\N	\N	\N	\N	f	\N	\N
256	\N	VALESKA	VILLAMIZAR CASANOVA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147023016	vvilamizar@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	vvilamizar	\N	\N	\N	\N	\N	f	\N	\N
257	\N	DOLLY ROSMARY	MOGOLLON QUIROS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147295082	rosmarymq@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rosmarymq	\N	\N	\N	\N	\N	f	\N	\N
258	\N	BELKIS DEL CARMEN	REY RANGEL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7158092	belkisreyrangel25@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	belkisreyrangel25	\N	\N	\N	\N	\N	f	\N	\N
259	\N	MARIA DANIELA	BLANCO GAMBACICA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7020344	raach83@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	raach83	\N	\N	\N	\N	\N	f	\N	\N
260	\N	LEIDY PAOLA	RUEDA SUAREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247614778	idielpao@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	idielpao	\N	\N	\N	\N	\N	f	\N	\N
261	\N	VIGLEDYS MARIA	SALAS LOPEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247431052	vigledys2013@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	vigledys2013	\N	\N	\N	\N	\N	f	\N	\N
262	\N	KENIA ALEXANDRA	ESCOBAR CHACON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04121050503	keniaescobar76@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	keniaescobar76	\N	\N	\N	\N	\N	f	\N	\N
263	\N	MARIA TERESA	MOGROVEJO DE ONTIVEROS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-2379446	mariet241.matm@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mariet241.matm	\N	\N	\N	\N	\N	f	\N	\N
264	\N	ISNEY ANGELY	NOGUERA RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247099686	rep_214@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_214	\N	\N	\N	\N	\N	f	\N	\N
265	\N	ZOREIDY DEL CARMEN	PEREZ PEREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247213305	rep_215@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_215	\N	\N	\N	\N	\N	f	\N	\N
266	\N	LISBETH DEL CARMEN	BERMUDEZ MOLINA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247195801	bermudelisbeth@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	bermudelisbeth	\N	\N	\N	\N	\N	f	\N	\N
267	\N	ODALIS YAIDERLIN	SANDOVAL DE LACRUZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247032362	odalis_ysandoval@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	odalis_ysandoval	\N	\N	\N	\N	\N	f	\N	\N
268	\N	SANDRA SIRLEY	PLATA SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-7043079	sandrasplatas@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sandrasplatas	\N	\N	\N	\N	\N	f	\N	\N
269	\N	MAYLIN GIOVANNA	DÍAZ DE RAMÍREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247422684	giovannamdv@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	giovannamdv	\N	\N	\N	\N	\N	f	\N	\N
270	\N	DESIREE TIBANA	MONTERO PORRAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147330447	tibanamontero@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	tibanamontero	\N	\N	\N	\N	\N	f	\N	\N
271	\N	YORKIS JHOSIMAR	TRESPALACIOS CASTELLANOS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04169447630 / 04126677630	jessigabriela2010@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jessigabriela2010	\N	\N	\N	\N	\N	f	\N	\N
272	\N	GENNY LAIDY	CHACON LOBO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247054276	gennychlobo@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gennychlobo	\N	\N	\N	\N	\N	f	\N	\N
273	\N	CIRA MARIA	JIMENEZ CAMEJO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04126422328	cjimenezcamejo@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	cjimenezcamejo	\N	\N	\N	\N	\N	f	\N	\N
274	\N	CENOBIA	ASANIO LIZARAZO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04149749705	julianaperezimasc@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	julianaperezimasc	\N	\N	\N	\N	\N	f	\N	\N
275	\N	NURIS DEL PILAR	CARRILLO DE FORERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416-1399606	nurjuli2009@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nurjuli2009	\N	\N	\N	\N	\N	f	\N	\N
276	\N	ANDREÍNA LISBETH	SANDOVAL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247742127	andreinasandobal@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	andreinasandobal	\N	\N	\N	\N	\N	f	\N	\N
277	\N	GUILLERMO ALEXANDER	PEREZ AMADO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147032113	aperezamado@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	aperezamado	\N	\N	\N	\N	\N	f	\N	\N
278	\N	ELIZABETH ANDREINA	ACEVEDO DE MUÑOZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147340218	kerenysara@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	kerenysara	\N	\N	\N	\N	\N	f	\N	\N
279	\N	AVENDAÑO ZAMBRANO	AVENDAÑO ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147067897	yaritzaeliza@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yaritzaeliza	\N	\N	\N	\N	\N	f	\N	\N
280	\N	BELKIS ZULAY	VARGAS TARAZONA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 7043234	belkisvargas_27@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	belkisvargas_27	\N	\N	\N	\N	\N	f	\N	\N
281	\N	SULGEY EMERY	COLMENARES BENITEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416 6746543	sulgeycc@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sulgeycc	\N	\N	\N	\N	\N	f	\N	\N
282	\N	MARIA ALEJANDRA	RODRIGUEZ TERAN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141771590	maria.rodriguezt@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	maria.rodriguezt	\N	\N	\N	\N	\N	f	\N	\N
283	\N	STEPHANIE LISSET	MARQUEZ CASTRO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147128800	marquez.ste25051989@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	marquez.ste25051989	\N	\N	\N	\N	\N	f	\N	\N
284	\N	KAREN ANDREA	SALAZAR ACEVEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247634094	karen_40417@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karen_40417	\N	\N	\N	\N	\N	f	\N	\N
285	\N	ELEIDYS AMPARO	FRANCISCONY	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141757808	elefran07@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	elefran07	\N	\N	\N	\N	\N	f	\N	\N
286	\N	LORENA ELIZABETH	HARMS BECERRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-0826912	lorenaharms@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lorenaharms	\N	\N	\N	\N	\N	f	\N	\N
287	\N	LORENA ELIZABETH	HARMS BECERRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140826912	lorenaharmis@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lorenaharmis	\N	\N	\N	\N	\N	f	\N	\N
288	\N	ELEIDYS AMPARO	FRANCISCONY	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414/1757808	eleidysfranciscony2@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	eleidysfranciscony2	\N	\N	\N	\N	\N	f	\N	\N
289	\N	NELLY XIOMARA	CARO PÉREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04160708300	nellyximaracaro@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nellyximaracaro	\N	\N	\N	\N	\N	f	\N	\N
290	\N	MAGGLY KATHERINE	SANCHEZ CASIQUE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147232505	maggly-sanchez@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	maggly-sanchez	\N	\N	\N	\N	\N	f	\N	\N
291	\N	MARISABEL	BASTO DIAZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04120726453	kissmary19@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	kissmary19	\N	\N	\N	\N	\N	f	\N	\N
292	\N	EDGLIS THAMARA	MORALES RODRIGUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147408737	thammy0721@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	thammy0721	\N	\N	\N	\N	\N	f	\N	\N
293	\N	SAIDA YAQUELIN	MORENO ROJAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 7234084	saidamoreno27@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	saidamoreno27	\N	\N	\N	\N	\N	f	\N	\N
294	\N	BLANCA	VARGAS ROA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140368459	blancavargas25@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	blancavargas25	\N	\N	\N	\N	\N	f	\N	\N
295	\N	MADRE	MADRE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	\N	rep_263@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_263	\N	\N	\N	\N	\N	f	\N	\N
296	\N	MADRE	MADRE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	\N	rep_264@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_264	\N	\N	\N	\N	\N	f	\N	\N
297	\N	RICHARD JOSE	SANCHEZ MENDOZA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7008776	richardjose2910@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	richardjose2910	\N	\N	\N	\N	\N	f	\N	\N
298	\N	KAREN FERNANDA	GOMEZ QUIJANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7535310	karenfer9301@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karenfer9301	\N	\N	\N	\N	\N	f	\N	\N
299	\N	MARIA VICTORIA	CONTRERAS DE GIRALDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247355791	mary00747@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mary00747	\N	\N	\N	\N	\N	f	\N	\N
300	\N	MARIA VICTORIA	CONTRERAS CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247355791	maritoya0747@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	maritoya0747	\N	\N	\N	\N	\N	f	\N	\N
301	\N	ELVIA LISBETH	ROJAS RANGEL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140762190	rojaselvia29@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rojaselvia29	\N	\N	\N	\N	\N	f	\N	\N
302	\N	MAIDE	CARDENAS BARRAGAN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7545643	maidecardenas12@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	maidecardenas12	\N	\N	\N	\N	\N	f	\N	\N
303	\N	RAMON JOSE GREGORIO	MANRIQUE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-2101142	ramonjosegregorio@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ramonjosegregorio	\N	\N	\N	\N	\N	f	\N	\N
304	\N	YERIT BANETZA	GANDICA CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04265755506	yeritgandica@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yeritgandica	\N	\N	\N	\N	\N	f	\N	\N
305	\N	KARLA CONSOLACION	BECERRA DE ESCALANTE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247610387	karlabm2011@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karlabm2011	\N	\N	\N	\N	\N	f	\N	\N
306	\N	SULEIMA TIBISAY	MORENO NUÑEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140763639	suleimatibisay@yahoo.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	suleimatibisay	\N	\N	\N	\N	\N	f	\N	\N
307	\N	XIMENA LEONIDES MARÍA	FERNÁNDEZ CUADROS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247122258	ximenama1976@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ximenama1976	\N	\N	\N	\N	\N	f	\N	\N
308	\N	NIRIAN KATERINE	ESCALANTE MANOSALVA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247849415	mariajosealberto82@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mariajosealberto82	\N	\N	\N	\N	\N	f	\N	\N
309	\N	CARLA ANDREINA	HERRERA ARAUJO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147003893	tiacalita2006@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	tiacalita2006	\N	\N	\N	\N	\N	f	\N	\N
310	\N	GREISSY LORENA	PACHECO BETANCOURT	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247035440	pachecogreissy0@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	pachecogreissy0	\N	\N	\N	\N	\N	f	\N	\N
311	\N	LUZ MAYELA	HART ORTEGA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7083421	mayehart@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mayehart	\N	\N	\N	\N	\N	f	\N	\N
312	\N	CARMEN VICTORIA	BOHORQUEZ ORTIZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247234187	bohorquezcarmen1985@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	bohorquezcarmen1985	\N	\N	\N	\N	\N	f	\N	\N
313	\N	NIDYAM LISSETTE	ORTIZ RAMÓN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 7544911	lissette2920@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lissette2920	\N	\N	\N	\N	\N	f	\N	\N
314	\N	MARIA DEL MAR	CONTRERAS PEREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247228076	marimarcontr.mc@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	marimarcontr.mc	\N	\N	\N	\N	\N	f	\N	\N
315	\N	ANNY DEYANIRA	GONZALEZ TAPIA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416-502600	ad.gonzaleztapia@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ad.gonzaleztapia	\N	\N	\N	\N	\N	f	\N	\N
316	\N	KEILA JACKELINE	OCHOA URDANETA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7603302	keilaochoa421@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	keilaochoa421	\N	\N	\N	\N	\N	f	\N	\N
317	\N	KEILA JACKELINE	OCHOA URDANETA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247603302	keila421@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	keila421	\N	\N	\N	\N	\N	f	\N	\N
318	\N	MARIA GREGORIA	LABRADOR GARCIA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147375056	labradormg@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	labradormg	\N	\N	\N	\N	\N	f	\N	\N
319	\N	MAYRA LISETH	GONZALEZ ACEVEDO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161396932	mayraliset.g05@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mayraliset.g05	\N	\N	\N	\N	\N	f	\N	\N
320	\N	PAOLA	SILVA RODRIGUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-7136728	paolasilva22@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	paolasilva22	\N	\N	\N	\N	\N	f	\N	\N
321	\N	SARA VIRGINIA	FERNÁNDEZ DE GARCÍA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147180526	saritafer.sf@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	saritafer.sf	\N	\N	\N	\N	\N	f	\N	\N
322	\N	AGNY MECADILET	BUENAÑO RIOS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147065930	agny_mecadilet@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	agny_mecadilet	\N	\N	\N	\N	\N	f	\N	\N
323	\N	MARIA MILAGROS	SUAREZ SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247844207	eclipse_1678@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	eclipse_1678	\N	\N	\N	\N	\N	f	\N	\N
324	\N	JOSEFA DAMARIS	BOADA BAYONA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147094981	damarisboada932@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	damarisboada932	\N	\N	\N	\N	\N	f	\N	\N
325	\N	DAYSI MAGALLI	RAMIREZ PEÑALVER	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7720721	dmrami@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	dmrami	\N	\N	\N	\N	\N	f	\N	\N
326	\N	GAUDYS YUSBELIA	GUERRERO ANGARITA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147403957	gaudysguerrero4@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gaudysguerrero4	\N	\N	\N	\N	\N	f	\N	\N
327	\N	LEONARDO ANTONIO	ABREU ROMERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147113837	mgdevenezuela@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mgdevenezuela	\N	\N	\N	\N	\N	f	\N	\N
328	\N	LEONARDO ANTONIO	ABREU ROMERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147113837	labreuromero@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	labreuromero	\N	\N	\N	\N	\N	f	\N	\N
329	\N	REINA LUCERO	ROJAS URREA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247695214	lic_lucerito@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lic_lucerito	\N	\N	\N	\N	\N	f	\N	\N
330	\N	SHEYLA M	GUIRAL A	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247022770	sheylaguiral77@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sheylaguiral77	\N	\N	\N	\N	\N	f	\N	\N
331	\N	LILIANA	SUÁREZ ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140759302	lilianasuarezoficial@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lilianasuarezoficial	\N	\N	\N	\N	\N	f	\N	\N
332	\N	ANA VERONICA	ESCALANTE SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247261011	anaescalante.0678@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	anaescalante.0678	\N	\N	\N	\N	\N	f	\N	\N
333	\N	ERIKA JOHANNA	SANCHEZ SANCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147004665	erikajohanasanchezs@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	erikajohanasanchezs	\N	\N	\N	\N	\N	f	\N	\N
334	\N	ANGEL GABRIEL	GUERRA GUERRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 9797819	elcastigadorfiat@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	elcastigadorfiat	\N	\N	\N	\N	\N	f	\N	\N
335	\N	CARMEN GUADALUPE	CONTRERAS DE MARQUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147122861	guadalupecontrerasmora@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	guadalupecontrerasmora	\N	\N	\N	\N	\N	f	\N	\N
336	\N	GLADYMAR DEL CARMEN	REY DE RAMIREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04143764083	gladymar@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gladymar	\N	\N	\N	\N	\N	f	\N	\N
337	\N	IRIS JOSELINE	URBINA CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247013473	irisurbina1986@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	irisurbina1986	\N	\N	\N	\N	\N	f	\N	\N
338	\N	LUDDY VIVIANA	ÁNGEL AGELVIZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 241 43 25	luddyangel@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luddyangel	\N	\N	\N	\N	\N	f	\N	\N
339	\N	LUDDY ANGEL	ANGEL AGELVIZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414-2414325	luddyabgel18@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luddyabgel18	\N	\N	\N	\N	\N	f	\N	\N
340	\N	LUDDY VIVIANA	ANGEL AGELVIZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04142414325	luddyangel18@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luddyangel18	\N	\N	\N	\N	\N	f	\N	\N
341	\N	ZULIMAR	HERNÁNDEZ MÉNDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247122228	rep_334@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_334	\N	\N	\N	\N	\N	f	\N	\N
342	\N	ZULIMAR	HERNÁNDEZ MÉNDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247122228	rep_335@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_335	\N	\N	\N	\N	\N	f	\N	\N
343	\N	ZULIMAR	HERNÁNDEZ MENDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247122228	zulimarhernandez.38@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	zulimarhernandez.38	\N	\N	\N	\N	\N	f	\N	\N
344	\N	YELIX ANDREINA	SANDOVAL PACHECO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247147419	andreinasandov@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	andreinasandov	\N	\N	\N	\N	\N	f	\N	\N
345	\N	DEISSY MARIBEL	ALVIAREZ CHACON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7452087	deissyalviarezanthonella@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	deissyalviarezanthonella	\N	\N	\N	\N	\N	f	\N	\N
346	\N	LILY YOHANA	VILLALOBOS PEÑA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247266728	rep_340@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_340	\N	\N	\N	\N	\N	f	\N	\N
347	\N	LILY YOHANA	VILLALOBOS PEÑA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247266728	salomemelany24@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	salomemelany24	\N	\N	\N	\N	\N	f	\N	\N
348	\N	LILY YOHANA	VILLALOBOS PEÑA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-6520725	escorpionyoyita@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	escorpionyoyita	\N	\N	\N	\N	\N	f	\N	\N
349	\N	CLAUDIA LORENA	DAVILA DE TORRES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147396856	davilalorena20@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	davilalorena20	\N	\N	\N	\N	\N	f	\N	\N
350	\N	DYANE MEREDITH	RAMÍREZ DE PACHECO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	\N	ingdyaneramirez@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ingdyaneramirez	\N	\N	\N	\N	\N	f	\N	\N
351	\N	KATIUSKA YASMIN	MANOSALVA DE RUGELES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424 7591604	katiuskamanosalva@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	katiuskamanosalva	\N	\N	\N	\N	\N	f	\N	\N
352	\N	SANDRA YANETH	PEREZ BENITEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247601996	sandra2magp@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sandra2magp	\N	\N	\N	\N	\N	f	\N	\N
353	\N	JOSE ANTONIO	SUAREZ VIVAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147439602	tisi2322@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	tisi2322	\N	\N	\N	\N	\N	f	\N	\N
354	\N	LISBETH LUCILA	ROMÁN GUZMÁN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147040653	lisbyroman@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lisbyroman	\N	\N	\N	\N	\N	f	\N	\N
392	\N	GERSON	NIÑO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	02763569482	rep_417@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_417	\N	\N	\N	\N	\N	f	\N	\N
355	\N	NAYLA AZUCENA	MOLINA MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04166765758	nayla4172@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	nayla4172	\N	\N	\N	\N	\N	f	\N	\N
356	\N	KEILA MIRLADY	PULIDO CHACON	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141762093	keilapulido@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	keilapulido	\N	\N	\N	\N	\N	f	\N	\N
357	\N	AMPARO COROMOTO	BUITRAGO ABREU	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161396893	amparob18@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	amparob18	\N	\N	\N	\N	\N	f	\N	\N
358	\N	MAGLYS KARIM	GUTIERREZ MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247092181	ramaen.ca@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ramaen.ca	\N	\N	\N	\N	\N	f	\N	\N
359	\N	MAKERLY BRICETH	BONILLA BECERRA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147093025	makerlybriceth@yahoo.es	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	makerlybriceth	\N	\N	\N	\N	\N	f	\N	\N
360	\N	LISBETH YADIRA	DUARTE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04264723449	lisbethyadira23i@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lisbethyadira23i	\N	\N	\N	\N	\N	f	\N	\N
361	\N	LISBETH YADIRA	DUARTE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04164723449	lisbethduarte33nj@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lisbethduarte33nj	\N	\N	\N	\N	\N	f	\N	\N
362	\N	ASTRID KARINA	MONSALVE CARRILLO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140361037	astridkarina@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	astridkarina	\N	\N	\N	\N	\N	f	\N	\N
363	\N	JESSICA MAYELYN	NAVARRO JAIMES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147322006	sanori3335@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sanori3335	\N	\N	\N	\N	\N	f	\N	\N
364	\N	JESSICA MAYERLYN	NAVARRO JAIMES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247373335	rep_371@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_371	\N	\N	\N	\N	\N	f	\N	\N
365	\N	ANGELA KARINA	BOHORQUEZ ALVARADO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247667964	oskarijosabet12@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	oskarijosabet12	\N	\N	\N	\N	\N	f	\N	\N
366	\N	ANGELA KARINA	BOHORQUEZ ALVARADO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247667964	angelke82@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	angelke82	\N	\N	\N	\N	\N	f	\N	\N
367	\N	ANGELA KARINA	HERNÁNDEZ BOHÓRQUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247667964	rep_374@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_374	\N	\N	\N	\N	\N	f	\N	\N
368	\N	ANGELA KARINA	BOHÓRQUEZ ALVARADO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247667964	angelkb82@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	angelkb82	\N	\N	\N	\N	\N	f	\N	\N
369	\N	ELEIDYS AMPARO	FRANCISCONY	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0414 7273161	protseinca_@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	protseinca_	\N	\N	\N	\N	\N	f	\N	\N
370	\N	LIZETH MILLESEN	REQUENA ROMERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416 6028682	rroja9@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rroja9	\N	\N	\N	\N	\N	f	\N	\N
371	\N	RUBEN ARMANDO	ROJAS GUARAMATO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7576430	mpmariac.mc@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mpmariac.mc	\N	\N	\N	\N	\N	f	\N	\N
372	\N	MARIA AIDA	CORREA ALBARRACIN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04245868602	marlynconsolacionmoncadabayona@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	marlynconsolacionmoncadabayona	\N	\N	\N	\N	\N	f	\N	\N
373	\N	MARLYN CONSOLACIÓN	MONCADA BAYONA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247037839	virgi_caro_romero@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	virgi_caro_romero	\N	\N	\N	\N	\N	f	\N	\N
374	\N	VIRGINIA CAROLINA	ROMERO QUINTERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147167501	yole0108@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yole0108	\N	\N	\N	\N	\N	f	\N	\N
375	\N	CARMEN YOLEIDA	GIL DE ZUMZTEIN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161344562	jesusmarquezr07@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jesusmarquezr07	\N	\N	\N	\N	\N	f	\N	\N
376	\N	JESUS	MARQUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247435768	frexalidacanelones@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	frexalidacanelones	\N	\N	\N	\N	\N	f	\N	\N
377	\N	ISLEY FREXALIDA	DELGADO DE FERMÍN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7147799	grisney26@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	grisney26	\N	\N	\N	\N	\N	f	\N	\N
378	\N	GRISELA	CHACÓN MONTANEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04163051320	babyandreacastro@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	babyandreacastro	\N	\N	\N	\N	\N	f	\N	\N
379	\N	YAMIRA ANDREA	CASTRO GÓMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04124279703	casandrabaez22@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	casandrabaez22	\N	\N	\N	\N	\N	f	\N	\N
380	\N	CASANDRA CAROLINA	BÁEZ ROMERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147365044	lauryjohanacacua@gamil.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lauryjohanacacua	\N	\N	\N	\N	\N	f	\N	\N
381	\N	LAURY JOHANA	HERNANDEZ DE BANCES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04265759324	lenyfernandez1608@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lenyfernandez1608	\N	\N	\N	\N	\N	f	\N	\N
382	\N	LENY CAROLINA	FERNANDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147365044	lauryjohanacacua@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lauryjohanacacua	\N	\N	\N	\N	\N	f	\N	\N
383	\N	LAURY JOHANA	HERNANDEZ DE BANCES	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7009875	jandrearojas2015@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jandrearojas2015	\N	\N	\N	\N	\N	f	\N	\N
384	\N	JOHANA ANDREA	ROJAS MURILLO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7099734	tahis.acosta69@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	tahis.acosta69	\N	\N	\N	\N	\N	f	\N	\N
385	\N	ELIZABETH ANDREINA	ACEVEDO DE MUÑOZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04269763914	lucyzm6@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lucyzm6	\N	\N	\N	\N	\N	f	\N	\N
386	\N	RINA JOSEFINA	LEAL RIVERA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247394998	rep_411@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_411	\N	\N	\N	\N	\N	f	\N	\N
387	\N	NILEYDA NEILYN	GONZÁLEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247394998	rep_412@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_412	\N	\N	\N	\N	\N	f	\N	\N
388	\N	NILEYDA NEILYN	GONZÁLEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247394998	rep_413@endanza.edu.ve	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	rep_413	\N	\N	\N	\N	\N	f	\N	\N
389	\N	NILEYDA NEILYN	GONZÁLEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247617777	karola19_20@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karola19_20	\N	\N	\N	\N	\N	f	\N	\N
390	\N	MARCIA CAROLINA	LOPEZ CARRERO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04128671788	guemax@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	guemax	\N	\N	\N	\N	\N	f	\N	\N
391	\N	JEFERSON ORLANDO	BERNAL SANDOVAL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147076485	gersonalexander_25@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	gersonalexander_25	\N	\N	\N	\N	\N	f	\N	\N
393	\N	JOHANA CAROLINA	GONZÁLEZ ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147363779	joha1982ca@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	joha1982ca	\N	\N	\N	\N	\N	f	\N	\N
394	\N	GEYLLENS COROMOTO	CHACON DE DIAZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147057907	geyllenschacon@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	geyllenschacon	\N	\N	\N	\N	\N	f	\N	\N
395	\N	MARIA YSABEL	BECERRA DE GAITÀN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0416-8759205	ysabel1996@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ysabel1996	\N	\N	\N	\N	\N	f	\N	\N
396	\N	CARMEN	MONCADA GAMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140793543	jesusruizmoncada4a@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jesusruizmoncada4a	\N	\N	\N	\N	\N	f	\N	\N
397	\N	NORLYN MAYELA	CASTRO DE D´ SANTIAGO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04161762873	norlynmayelacastro.22@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	norlynmayelacastro.22	\N	\N	\N	\N	\N	f	\N	\N
398	\N	ANA JUDITH	PERNIA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424 7310131	anajudithpernia1981@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	anajudithpernia1981	\N	\N	\N	\N	\N	f	\N	\N
399	\N	ANYID MARYELA	RICO SOTO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04141750592	coridianybebe27@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	coridianybebe27	\N	\N	\N	\N	\N	f	\N	\N
400	\N	MARY ZULAY	VERGARA CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04264946025	mary1981vergara@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	mary1981vergara	\N	\N	\N	\N	\N	f	\N	\N
401	\N	EISSY LAREDT	ARAQUE CLAVIJO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0424-7217095	eissylaredt@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	eissylaredt	\N	\N	\N	\N	\N	f	\N	\N
402	\N	YOJANA JACKELINE	GUERRERO RAMÍREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247796888	yojanajackeline@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yojanajackeline	\N	\N	\N	\N	\N	f	\N	\N
403	\N	MIRIAM MERCEDES	SERRANO SUAREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	0412-0616751	miriamserrano051@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	miriamserrano051	\N	\N	\N	\N	\N	f	\N	\N
404	\N	JENNICE FIORELLA	ZAMBRANO SÁNCHEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04126670138	jennice.fiorella@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jennice.fiorella	\N	\N	\N	\N	\N	f	\N	\N
405	\N	ALEJANDRA YELITZA	CACERES HERNANDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147157128	aleyelcaceresh@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	aleyelcaceresh	\N	\N	\N	\N	\N	f	\N	\N
406	\N	ERIKA YOSELIN	RAMIREZ GUTIERREZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247547614	erikayramirezg@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	erikayramirezg	\N	\N	\N	\N	\N	f	\N	\N
407	\N	ALICIA	PERNIA MORA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	042688288269	apernia@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	apernia	\N	\N	\N	\N	\N	f	\N	\N
408	\N	FRANCY CAROLINA	MATA ZAMBRANO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04146263082	carolinamata77@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	carolinamata77	\N	\N	\N	\N	\N	f	\N	\N
409	\N	HUNGRÍA PAOLA	MOLINA HÓMEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147040860	hungriapaol@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	hungriapaol	\N	\N	\N	\N	\N	f	\N	\N
410	\N	ANGELICA MARIA	COLMENARES ALTAMIRANDA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04140782380	angelicacolmenares1508@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	angelicacolmenares1508	\N	\N	\N	\N	\N	f	\N	\N
411	\N	JUSDELY CAROLINA	SALCEDO ARANGUREN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147400807	jusdelys2011@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jusdelys2011	\N	\N	\N	\N	\N	f	\N	\N
412	\N	RONALD ALEXANDER	MANTILLA FERNANDEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147566994	ronaldmantilla80@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	ronaldmantilla80	\N	\N	\N	\N	\N	f	\N	\N
413	\N	JESSICA WILMAR	PRIETO LEAL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04247179780	jessicawprieto88@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	jessicawprieto88	\N	\N	\N	\N	\N	f	\N	\N
414	\N	MILAGROS DIOSEL	DURAN DE SULBARAN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04241285920	sulbaran.duran.angelica@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sulbaran.duran.angelica	\N	\N	\N	\N	\N	f	\N	\N
415	\N	MILAGROS DIOSEL	DURAN DE SULBARAN	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04241285920	duran_mily82@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	duran_mily82	\N	\N	\N	\N	\N	f	\N	\N
416	\N	LUISA MAYERLY	MEDINA GONZÁLEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04269137087	luisamedinagonzalez@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	luisamedinagonzalez	\N	\N	\N	\N	\N	f	\N	\N
417	\N	KARIN YURGEY	MORENO	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04147382407	karinyurgey@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	karinyurgey	\N	\N	\N	\N	\N	f	\N	\N
418	\N	WILKER ALEJANDRO	MACÍAS FIGUEROA	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04124201343	alejkygo@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	alejkygo	\N	\N	\N	\N	\N	f	\N	\N
419	\N	SANDRA YANETH	GOMEZ VILLAMIL	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04261796042	sandra3216g@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	sandra3216g	\N	\N	\N	\N	\N	f	\N	\N
420	\N	YULIANA CAROLINA	QUEVEDO RODRÍGUEZ	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04264780139	yulianademendoza@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yulianademendoza	\N	\N	\N	\N	\N	f	\N	\N
421	\N	LIZ YOLIMAR	PALENCIA ALTUVE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04144464246	lizyolimarlencia@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	lizyolimarlencia	\N	\N	\N	\N	\N	f	\N	\N
422	\N	LIZ YOLIMAR	PALENCIA ALTUVE	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04144464246	zharichcorrea1709@gmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	zharichcorrea1709	\N	\N	\N	\N	\N	f	\N	\N
423	\N	YURLEY YERSARY	VIVAS CONTRERAS	$2b$10$c320.5HO8xBj/KCQPZBmx.qvTAkIP3pQLdgfubG5GFMDnAi7DDHi.	04266727841	yurley21_4@hotmail.com	\N	\N	\N	activo	2026-08-26 03:37:26.90621-04	\N	4	\N	yurley21_4	\N	\N	\N	\N	\N	f	\N	\N
424	V-32666665	PETRONILA ANTONIA	SANCHEZ RAMIREZ	$2b$10$EyW7XQnAbs/ycG6QtNj6Iu0Zp/hhH8n/YXqMJH0q8EiFIdjDMkKK6	0414-1234567	PETRO12@GMAIL.COM	\N	\N	\N	activo	2026-09-08 21:44:54.748294-04	\N	4	\N	PETRO12	\N	\N	\N	\N	\N	f	\N	\N
425	V-9089098	Pedro	Gonzales	$2b$10$F3oWwC3TMngvhHPc9dWNiO7yhPWF7cvB3TPe2wHDJZKdJeuO1M7E.	04147521433	pedrognza@gmail.com	\N	\N	\N	activo	2026-09-11 00:28:48.546985-04	2026-09-11 00:28:48.546985-04	2	\N	pedrognza	predeterminada	predeterminada	\N	\N	\N	f	\N	\N
426	V-3232123	pedro gabriel	lopez gabiria	$2b$10$jJuyzC0YyaGZ4VzbdcormeohNF8uV0E2S5FxsQIhsHPkKVBNDKf96	0414-8793455	pedrogabi@gmail.com	\N	\N	\N	activo	2026-09-11 00:54:06.647014-04	\N	4	\N	pedrogabi	\N	\N	\N	\N	\N	f	\N	\N
427	V-1232123	pedro carlo	sesar pepe	$2b$10$8JSJUVZun6o5LEK0LiJFROrmJlIEqlUZAigPbKFtFzaefkdNmDcXm	0414-1233211	pepesesa@gmail.com	\N	\N	\N	activo	2026-09-11 01:14:28.249767-04	\N	4	\N	pepesesa	\N	\N	\N	\N	\N	f	\N	\N
428	V-34343344	predro tomas	ro dro	$2b$10$YnxtiRkMMEsiY/ejxP6O5O4NLNf2vr8DByZjXb2PcpckKLSFjtJQS	0414-7879876	rodro@gmail.com	\N	\N	\N	activo	2026-09-11 01:26:40.181134-04	\N	4	\N	rodro	\N	\N	\N	\N	\N	f	\N	\N
429	V-10745144	Adriana Jhanet	Ruiz Gonzalez	$2b$10$OvTxJkBvVqqLb1uHvYLaYem8DM/8IwXMPfaCIcEesKZ94oKEJG22e	0414-7591989	adrianaruiz990@gmail.com	\N	\N	\N	activo	2026-09-11 01:32:54.236581-04	2026-09-11 01:37:15.248405-04	4	\N	adrianaruiz990	\N	\N	\N	\N	\N	f	2026-09-11 01:37:15.248405	\N
1	V-00000000	Admin	Sistema	$2b$10$STfSKjxp05CLMG2HqU9VMe3YpN9D5Bfz//NAiY0y3KDL6GQ6q83/i	\N	admin@endanza.com	\N	\N	\N	Activo	\N	2026-09-12 10:13:20.451633-04	1	\N	admin	\N	\N	\N	\N	\N	f	2026-09-12 10:13:20.451633	\N
\.


--
-- Data for Name: Usuario_Rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Usuario_Rol" ("Id_usuario", "Id_rol", creado_en) FROM stdin;
2	2	2026-09-12 09:17:25.370673
3	2	2026-09-12 09:17:25.370673
4	1	2026-09-12 09:17:25.370673
5	2	2026-09-12 09:17:25.370673
6	2	2026-09-12 09:17:25.370673
7	2	2026-09-12 09:17:25.370673
8	2	2026-09-12 09:17:25.370673
9	1	2026-09-12 09:17:25.370673
10	2	2026-09-12 09:17:25.370673
11	2	2026-09-12 09:17:25.370673
12	2	2026-09-12 09:17:25.370673
13	2	2026-09-12 09:17:25.370673
14	2	2026-09-12 09:17:25.370673
15	2	2026-09-12 09:17:25.370673
16	2	2026-09-12 09:17:25.370673
17	2	2026-09-12 09:17:25.370673
18	5	2026-09-12 09:17:25.370673
19	5	2026-09-12 09:17:25.370673
20	2	2026-09-12 09:17:25.370673
22	2	2026-09-12 09:17:25.370673
23	2	2026-09-12 09:17:25.370673
24	2	2026-09-12 09:17:25.370673
25	2	2026-09-12 09:17:25.370673
26	2	2026-09-12 09:17:25.370673
27	2	2026-09-12 09:17:25.370673
28	2	2026-09-12 09:17:25.370673
29	5	2026-09-12 09:17:25.370673
21	2	2026-09-12 09:17:25.370673
126	4	2026-09-12 09:17:25.370673
127	4	2026-09-12 09:17:25.370673
128	4	2026-09-12 09:17:25.370673
129	4	2026-09-12 09:17:25.370673
130	4	2026-09-12 09:17:25.370673
131	4	2026-09-12 09:17:25.370673
132	4	2026-09-12 09:17:25.370673
133	4	2026-09-12 09:17:25.370673
30	2	2026-09-12 09:17:25.370673
125	4	2026-09-12 09:17:25.370673
134	4	2026-09-12 09:17:25.370673
135	4	2026-09-12 09:17:25.370673
136	4	2026-09-12 09:17:25.370673
137	4	2026-09-12 09:17:25.370673
138	4	2026-09-12 09:17:25.370673
139	4	2026-09-12 09:17:25.370673
140	4	2026-09-12 09:17:25.370673
253	4	2026-09-12 09:17:25.370673
141	4	2026-09-12 09:17:25.370673
142	4	2026-09-12 09:17:25.370673
143	4	2026-09-12 09:17:25.370673
144	4	2026-09-12 09:17:25.370673
145	4	2026-09-12 09:17:25.370673
146	4	2026-09-12 09:17:25.370673
147	4	2026-09-12 09:17:25.370673
148	4	2026-09-12 09:17:25.370673
149	4	2026-09-12 09:17:25.370673
150	4	2026-09-12 09:17:25.370673
151	4	2026-09-12 09:17:25.370673
152	4	2026-09-12 09:17:25.370673
153	4	2026-09-12 09:17:25.370673
154	4	2026-09-12 09:17:25.370673
155	4	2026-09-12 09:17:25.370673
156	4	2026-09-12 09:17:25.370673
157	4	2026-09-12 09:17:25.370673
158	4	2026-09-12 09:17:25.370673
159	4	2026-09-12 09:17:25.370673
160	4	2026-09-12 09:17:25.370673
161	4	2026-09-12 09:17:25.370673
162	4	2026-09-12 09:17:25.370673
163	4	2026-09-12 09:17:25.370673
164	4	2026-09-12 09:17:25.370673
165	4	2026-09-12 09:17:25.370673
166	4	2026-09-12 09:17:25.370673
167	4	2026-09-12 09:17:25.370673
168	4	2026-09-12 09:17:25.370673
169	4	2026-09-12 09:17:25.370673
170	4	2026-09-12 09:17:25.370673
171	4	2026-09-12 09:17:25.370673
172	4	2026-09-12 09:17:25.370673
173	4	2026-09-12 09:17:25.370673
174	4	2026-09-12 09:17:25.370673
175	4	2026-09-12 09:17:25.370673
176	4	2026-09-12 09:17:25.370673
177	4	2026-09-12 09:17:25.370673
178	4	2026-09-12 09:17:25.370673
179	4	2026-09-12 09:17:25.370673
180	4	2026-09-12 09:17:25.370673
181	4	2026-09-12 09:17:25.370673
182	4	2026-09-12 09:17:25.370673
183	4	2026-09-12 09:17:25.370673
184	4	2026-09-12 09:17:25.370673
185	4	2026-09-12 09:17:25.370673
186	4	2026-09-12 09:17:25.370673
187	4	2026-09-12 09:17:25.370673
188	4	2026-09-12 09:17:25.370673
189	4	2026-09-12 09:17:25.370673
190	4	2026-09-12 09:17:25.370673
191	4	2026-09-12 09:17:25.370673
192	4	2026-09-12 09:17:25.370673
193	4	2026-09-12 09:17:25.370673
194	4	2026-09-12 09:17:25.370673
195	4	2026-09-12 09:17:25.370673
196	4	2026-09-12 09:17:25.370673
197	4	2026-09-12 09:17:25.370673
198	4	2026-09-12 09:17:25.370673
199	4	2026-09-12 09:17:25.370673
200	4	2026-09-12 09:17:25.370673
201	4	2026-09-12 09:17:25.370673
202	4	2026-09-12 09:17:25.370673
203	4	2026-09-12 09:17:25.370673
204	4	2026-09-12 09:17:25.370673
205	4	2026-09-12 09:17:25.370673
206	4	2026-09-12 09:17:25.370673
207	4	2026-09-12 09:17:25.370673
208	4	2026-09-12 09:17:25.370673
209	4	2026-09-12 09:17:25.370673
210	4	2026-09-12 09:17:25.370673
211	4	2026-09-12 09:17:25.370673
212	4	2026-09-12 09:17:25.370673
213	4	2026-09-12 09:17:25.370673
214	4	2026-09-12 09:17:25.370673
215	4	2026-09-12 09:17:25.370673
216	4	2026-09-12 09:17:25.370673
217	4	2026-09-12 09:17:25.370673
218	4	2026-09-12 09:17:25.370673
219	4	2026-09-12 09:17:25.370673
220	4	2026-09-12 09:17:25.370673
221	4	2026-09-12 09:17:25.370673
222	4	2026-09-12 09:17:25.370673
223	4	2026-09-12 09:17:25.370673
224	4	2026-09-12 09:17:25.370673
225	4	2026-09-12 09:17:25.370673
226	4	2026-09-12 09:17:25.370673
227	4	2026-09-12 09:17:25.370673
228	4	2026-09-12 09:17:25.370673
229	4	2026-09-12 09:17:25.370673
230	4	2026-09-12 09:17:25.370673
231	4	2026-09-12 09:17:25.370673
232	4	2026-09-12 09:17:25.370673
233	4	2026-09-12 09:17:25.370673
234	4	2026-09-12 09:17:25.370673
235	4	2026-09-12 09:17:25.370673
236	4	2026-09-12 09:17:25.370673
237	4	2026-09-12 09:17:25.370673
238	4	2026-09-12 09:17:25.370673
239	4	2026-09-12 09:17:25.370673
240	4	2026-09-12 09:17:25.370673
241	4	2026-09-12 09:17:25.370673
242	4	2026-09-12 09:17:25.370673
243	4	2026-09-12 09:17:25.370673
244	4	2026-09-12 09:17:25.370673
245	4	2026-09-12 09:17:25.370673
246	4	2026-09-12 09:17:25.370673
247	4	2026-09-12 09:17:25.370673
248	4	2026-09-12 09:17:25.370673
249	4	2026-09-12 09:17:25.370673
250	4	2026-09-12 09:17:25.370673
251	4	2026-09-12 09:17:25.370673
252	4	2026-09-12 09:17:25.370673
254	4	2026-09-12 09:17:25.370673
255	4	2026-09-12 09:17:25.370673
256	4	2026-09-12 09:17:25.370673
257	4	2026-09-12 09:17:25.370673
258	4	2026-09-12 09:17:25.370673
259	4	2026-09-12 09:17:25.370673
260	4	2026-09-12 09:17:25.370673
261	4	2026-09-12 09:17:25.370673
262	4	2026-09-12 09:17:25.370673
263	4	2026-09-12 09:17:25.370673
264	4	2026-09-12 09:17:25.370673
265	4	2026-09-12 09:17:25.370673
266	4	2026-09-12 09:17:25.370673
267	4	2026-09-12 09:17:25.370673
268	4	2026-09-12 09:17:25.370673
269	4	2026-09-12 09:17:25.370673
270	4	2026-09-12 09:17:25.370673
271	4	2026-09-12 09:17:25.370673
272	4	2026-09-12 09:17:25.370673
273	4	2026-09-12 09:17:25.370673
274	4	2026-09-12 09:17:25.370673
275	4	2026-09-12 09:17:25.370673
276	4	2026-09-12 09:17:25.370673
277	4	2026-09-12 09:17:25.370673
278	4	2026-09-12 09:17:25.370673
279	4	2026-09-12 09:17:25.370673
280	4	2026-09-12 09:17:25.370673
281	4	2026-09-12 09:17:25.370673
282	4	2026-09-12 09:17:25.370673
283	4	2026-09-12 09:17:25.370673
284	4	2026-09-12 09:17:25.370673
285	4	2026-09-12 09:17:25.370673
286	4	2026-09-12 09:17:25.370673
287	4	2026-09-12 09:17:25.370673
288	4	2026-09-12 09:17:25.370673
289	4	2026-09-12 09:17:25.370673
290	4	2026-09-12 09:17:25.370673
291	4	2026-09-12 09:17:25.370673
292	4	2026-09-12 09:17:25.370673
293	4	2026-09-12 09:17:25.370673
294	4	2026-09-12 09:17:25.370673
295	4	2026-09-12 09:17:25.370673
296	4	2026-09-12 09:17:25.370673
297	4	2026-09-12 09:17:25.370673
298	4	2026-09-12 09:17:25.370673
299	4	2026-09-12 09:17:25.370673
300	4	2026-09-12 09:17:25.370673
301	4	2026-09-12 09:17:25.370673
302	4	2026-09-12 09:17:25.370673
303	4	2026-09-12 09:17:25.370673
304	4	2026-09-12 09:17:25.370673
305	4	2026-09-12 09:17:25.370673
306	4	2026-09-12 09:17:25.370673
307	4	2026-09-12 09:17:25.370673
308	4	2026-09-12 09:17:25.370673
309	4	2026-09-12 09:17:25.370673
310	4	2026-09-12 09:17:25.370673
311	4	2026-09-12 09:17:25.370673
312	4	2026-09-12 09:17:25.370673
313	4	2026-09-12 09:17:25.370673
314	4	2026-09-12 09:17:25.370673
315	4	2026-09-12 09:17:25.370673
316	4	2026-09-12 09:17:25.370673
317	4	2026-09-12 09:17:25.370673
318	4	2026-09-12 09:17:25.370673
319	4	2026-09-12 09:17:25.370673
320	4	2026-09-12 09:17:25.370673
321	4	2026-09-12 09:17:25.370673
322	4	2026-09-12 09:17:25.370673
323	4	2026-09-12 09:17:25.370673
324	4	2026-09-12 09:17:25.370673
325	4	2026-09-12 09:17:25.370673
326	4	2026-09-12 09:17:25.370673
327	4	2026-09-12 09:17:25.370673
328	4	2026-09-12 09:17:25.370673
329	4	2026-09-12 09:17:25.370673
330	4	2026-09-12 09:17:25.370673
331	4	2026-09-12 09:17:25.370673
332	4	2026-09-12 09:17:25.370673
333	4	2026-09-12 09:17:25.370673
334	4	2026-09-12 09:17:25.370673
335	4	2026-09-12 09:17:25.370673
336	4	2026-09-12 09:17:25.370673
337	4	2026-09-12 09:17:25.370673
338	4	2026-09-12 09:17:25.370673
339	4	2026-09-12 09:17:25.370673
340	4	2026-09-12 09:17:25.370673
341	4	2026-09-12 09:17:25.370673
342	4	2026-09-12 09:17:25.370673
343	4	2026-09-12 09:17:25.370673
344	4	2026-09-12 09:17:25.370673
345	4	2026-09-12 09:17:25.370673
346	4	2026-09-12 09:17:25.370673
347	4	2026-09-12 09:17:25.370673
348	4	2026-09-12 09:17:25.370673
349	4	2026-09-12 09:17:25.370673
350	4	2026-09-12 09:17:25.370673
351	4	2026-09-12 09:17:25.370673
352	4	2026-09-12 09:17:25.370673
353	4	2026-09-12 09:17:25.370673
354	4	2026-09-12 09:17:25.370673
392	4	2026-09-12 09:17:25.370673
355	4	2026-09-12 09:17:25.370673
356	4	2026-09-12 09:17:25.370673
357	4	2026-09-12 09:17:25.370673
358	4	2026-09-12 09:17:25.370673
359	4	2026-09-12 09:17:25.370673
360	4	2026-09-12 09:17:25.370673
361	4	2026-09-12 09:17:25.370673
362	4	2026-09-12 09:17:25.370673
363	4	2026-09-12 09:17:25.370673
364	4	2026-09-12 09:17:25.370673
365	4	2026-09-12 09:17:25.370673
366	4	2026-09-12 09:17:25.370673
367	4	2026-09-12 09:17:25.370673
368	4	2026-09-12 09:17:25.370673
369	4	2026-09-12 09:17:25.370673
370	4	2026-09-12 09:17:25.370673
371	4	2026-09-12 09:17:25.370673
372	4	2026-09-12 09:17:25.370673
373	4	2026-09-12 09:17:25.370673
374	4	2026-09-12 09:17:25.370673
375	4	2026-09-12 09:17:25.370673
376	4	2026-09-12 09:17:25.370673
377	4	2026-09-12 09:17:25.370673
378	4	2026-09-12 09:17:25.370673
379	4	2026-09-12 09:17:25.370673
380	4	2026-09-12 09:17:25.370673
381	4	2026-09-12 09:17:25.370673
382	4	2026-09-12 09:17:25.370673
383	4	2026-09-12 09:17:25.370673
384	4	2026-09-12 09:17:25.370673
385	4	2026-09-12 09:17:25.370673
386	4	2026-09-12 09:17:25.370673
387	4	2026-09-12 09:17:25.370673
388	4	2026-09-12 09:17:25.370673
389	4	2026-09-12 09:17:25.370673
390	4	2026-09-12 09:17:25.370673
391	4	2026-09-12 09:17:25.370673
393	4	2026-09-12 09:17:25.370673
394	4	2026-09-12 09:17:25.370673
395	4	2026-09-12 09:17:25.370673
396	4	2026-09-12 09:17:25.370673
397	4	2026-09-12 09:17:25.370673
398	4	2026-09-12 09:17:25.370673
399	4	2026-09-12 09:17:25.370673
400	4	2026-09-12 09:17:25.370673
401	4	2026-09-12 09:17:25.370673
402	4	2026-09-12 09:17:25.370673
403	4	2026-09-12 09:17:25.370673
404	4	2026-09-12 09:17:25.370673
405	4	2026-09-12 09:17:25.370673
406	4	2026-09-12 09:17:25.370673
407	4	2026-09-12 09:17:25.370673
408	4	2026-09-12 09:17:25.370673
409	4	2026-09-12 09:17:25.370673
410	4	2026-09-12 09:17:25.370673
411	4	2026-09-12 09:17:25.370673
412	4	2026-09-12 09:17:25.370673
413	4	2026-09-12 09:17:25.370673
414	4	2026-09-12 09:17:25.370673
415	4	2026-09-12 09:17:25.370673
416	4	2026-09-12 09:17:25.370673
417	4	2026-09-12 09:17:25.370673
418	4	2026-09-12 09:17:25.370673
419	4	2026-09-12 09:17:25.370673
420	4	2026-09-12 09:17:25.370673
421	4	2026-09-12 09:17:25.370673
422	4	2026-09-12 09:17:25.370673
423	4	2026-09-12 09:17:25.370673
424	4	2026-09-12 09:17:25.370673
425	2	2026-09-12 09:17:25.370673
426	4	2026-09-12 09:17:25.370673
427	4	2026-09-12 09:17:25.370673
428	4	2026-09-12 09:17:25.370673
429	4	2026-09-12 09:17:25.370673
1	1	2026-09-12 09:17:25.370673
1	2	2026-09-12 09:44:14.80292
1	3	2026-09-12 09:44:14.81919
1	4	2026-09-12 09:44:14.821605
1	5	2026-09-12 09:44:14.824113
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id_category, name_category, description) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id_customer, id_user, shipping_address, purchase_limit) FROM stdin;
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id_department, name_departament, description) FROM stdin;
\.


--
-- Data for Name: details_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.details_order (id_details, id_order, id_product, description) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (id_employee, id_user, phone_number, commission) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id_order, id_customer, id_employee, order_date, state, total) FROM stdin;
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id_product, id_category, id_department, name_product, description, price) FROM stdin;
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report (id_report, id_order, report_type, generated_by, generation_date, description) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id_role, name_role, permissions) FROM stdin;
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (id_stock, id_product, movement_type, quantity, movement_date, note_stock) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id_user, id_role, dni, user_name, password, first_name, last_name, email, address) FROM stdin;
\.


--
-- Name: Acta_Promocion_Id_acta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Acta_Promocion_Id_acta_seq"', 1, false);


--
-- Name: Ano_Academico_Id_ano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ano_Academico_Id_ano_seq"', 4, true);


--
-- Name: Asistencia_Id_asistencia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Asistencia_Id_asistencia_seq"', 1, false);


--
-- Name: Aula_Id_aula_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Aula_Id_aula_seq"', 16, true);


--
-- Name: Bloque_Horario_Id_bloque_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Bloque_Horario_Id_bloque_seq"', 16, true);


--
-- Name: Boleta_Notas_Id_boleta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Boleta_Notas_Id_boleta_seq"', 1, false);


--
-- Name: Boletin_Estudiante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Boletin_Estudiante_id_seq"', 18, true);


--
-- Name: Carga_Nota_Id_nota_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Carga_Nota_Id_nota_seq"', 314, true);


--
-- Name: Ciudad_Id_ciudad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ciudad_Id_ciudad_seq"', 1, false);


--
-- Name: Competencia_Id_competencia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Competencia_Id_competencia_seq"', 1, false);


--
-- Name: Detalles_Reporte_Id_detalles_reporte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Detalles_Reporte_Id_detalles_reporte_seq"', 1, false);


--
-- Name: Dia_Id_dia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Dia_Id_dia_seq"', 7, true);


--
-- Name: Direccion_Id_direccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Direccion_Id_direccion_seq"', 1, false);


--
-- Name: Escuela_Regular_Id_escuela_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Escuela_Regular_Id_escuela_seq"', 1, false);


--
-- Name: Especialidad_Id_especialidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Especialidad_Id_especialidad_seq"', 9, true);


--
-- Name: Estado_Id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Estado_Id_estado_seq"', 1, false);


--
-- Name: Estructura_Evaluacion_Id_estructura_evaluacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Estructura_Evaluacion_Id_estructura_evaluacion_seq"', 87, true);


--
-- Name: Estudiante_Id_estudiante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Estudiante_Id_estudiante_seq"', 578, true);


--
-- Name: Estudiante_Seccion_Id_estudiante_seccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Estudiante_Seccion_Id_estudiante_seccion_seq"', 314, true);


--
-- Name: Grado_Id_grado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Grado_Id_grado_seq"', 23, true);


--
-- Name: Historial_Medico_Id_historial_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Historial_Medico_Id_historial_seq"', 569, true);


--
-- Name: Horario_Id_horario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Horario_Id_horario_seq"', 1, false);


--
-- Name: Incidencia_Id_incidencia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Incidencia_Id_incidencia_seq"', 1, false);


--
-- Name: Lapso_Id_lapso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Lapso_Id_lapso_seq"', 6, true);


--
-- Name: Materia_Id_materia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Materia_Id_materia_seq"', 132, true);


--
-- Name: Municipio_Id_municipio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Municipio_Id_municipio_seq"', 1, false);


--
-- Name: Nivel_Danza_Id_nivel_danza_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Nivel_Danza_Id_nivel_danza_seq"', 25, true);


--
-- Name: Nivel_Escolar_Id_nivel_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Nivel_Escolar_Id_nivel_seq"', 1, false);


--
-- Name: Nota_Competencia_Estudiante_Id_estudiante_competencia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Nota_Competencia_Estudiante_Id_estudiante_competencia_seq"', 1, false);


--
-- Name: Padre_Id_padre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Padre_Id_padre_seq"', 1, false);


--
-- Name: Pais_Id_pais_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pais_Id_pais_seq"', 1, false);


--
-- Name: Parroquia_Id_parroquia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Parroquia_Id_parroquia_seq"', 1, false);


--
-- Name: Periodo_Inscripcion_Id_periodo_inscripcion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Periodo_Inscripcion_Id_periodo_inscripcion_seq"', 2, true);


--
-- Name: Periodo_Subida_Notas_Id_periodo_notas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Periodo_Subida_Notas_Id_periodo_notas_seq"', 1, true);


--
-- Name: Profesor_Especialidad_Id_profesor_especialidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Profesor_Especialidad_Id_profesor_especialidad_seq"', 1, false);


--
-- Name: Profesor_Id_profesor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Profesor_Id_profesor_seq"', 44, true);


--
-- Name: Representante_Id_representante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Representante_Id_representante_seq"', 371, true);


--
-- Name: Revision_Materia_Id_revision_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Revision_Materia_Id_revision_seq"', 1, false);


--
-- Name: Rol_Id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rol_Id_rol_seq"', 1, false);


--
-- Name: Seccion_Id_seccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Seccion_Id_seccion_seq"', 87, true);


--
-- Name: Seguro_Id_seguro_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Seguro_Id_seguro_seq"', 1, false);


--
-- Name: Solicitud_Constancia_Id_solicitud_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Solicitud_Constancia_Id_solicitud_seq"', 1, false);


--
-- Name: Tipo_Clase_Id_tipo_clase_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Tipo_Clase_Id_tipo_clase_seq"', 4, true);


--
-- Name: Tipo_Evaluacion_Id_tipo_evaluacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Tipo_Evaluacion_Id_tipo_evaluacion_seq"', 2, true);


--
-- Name: Usuario_Id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Usuario_Id_usuario_seq"', 429, true);


--
-- Name: category_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_category_seq', 1, false);


--
-- Name: customer_id_customer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_id_customer_seq', 1, false);


--
-- Name: department_id_department_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_department_seq', 1, false);


--
-- Name: details_order_id_details_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.details_order_id_details_seq', 1, false);


--
-- Name: employee_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_id_employee_seq', 1, false);


--
-- Name: order_id_order_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_id_order_seq', 1, false);


--
-- Name: product_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_product_seq', 1, false);


--
-- Name: report_id_report_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_id_report_seq', 1, false);


--
-- Name: role_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_role_seq', 1, false);


--
-- Name: stock_id_stock_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_id_stock_seq', 1, false);


--
-- Name: user_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_user_seq', 1, false);


--
-- Name: Acta_Promocion Acta_Promocion_Id_estudiante_Id_ano_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acta_Promocion"
    ADD CONSTRAINT "Acta_Promocion_Id_estudiante_Id_ano_key" UNIQUE ("Id_estudiante", "Id_ano");


--
-- Name: Acta_Promocion Acta_Promocion_numero_acta_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acta_Promocion"
    ADD CONSTRAINT "Acta_Promocion_numero_acta_key" UNIQUE (numero_acta);


--
-- Name: Acta_Promocion Acta_Promocion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acta_Promocion"
    ADD CONSTRAINT "Acta_Promocion_pkey" PRIMARY KEY ("Id_acta");


--
-- Name: Ano_Academico Ano_Academico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ano_Academico"
    ADD CONSTRAINT "Ano_Academico_pkey" PRIMARY KEY ("Id_ano");


--
-- Name: Asistencia Asistencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Asistencia"
    ADD CONSTRAINT "Asistencia_pkey" PRIMARY KEY ("Id_asistencia");


--
-- Name: Aula_Materia Aula_Materia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula_Materia"
    ADD CONSTRAINT "Aula_Materia_pkey" PRIMARY KEY ("Id_aula", "Id_materia");


--
-- Name: Aula Aula_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula"
    ADD CONSTRAINT "Aula_pkey" PRIMARY KEY ("Id_aula");


--
-- Name: Bloque_Horario Bloque_Horario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bloque_Horario"
    ADD CONSTRAINT "Bloque_Horario_pkey" PRIMARY KEY ("Id_bloque");


--
-- Name: Boleta_Notas Boleta_Notas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_pkey" PRIMARY KEY ("Id_boleta");


--
-- Name: Boletin_Estudiante Boletin_Estudiante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boletin_Estudiante"
    ADD CONSTRAINT "Boletin_Estudiante_pkey" PRIMARY KEY (id);


--
-- Name: Boletin_Estudiante Boletin_Estudiante_student_id_academic_year_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boletin_Estudiante"
    ADD CONSTRAINT "Boletin_Estudiante_student_id_academic_year_id_key" UNIQUE (student_id, academic_year_id);


--
-- Name: Carga_Nota Carga_Nota_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carga_Nota"
    ADD CONSTRAINT "Carga_Nota_pkey" PRIMARY KEY ("Id_nota");


--
-- Name: Ciudad Ciudad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad"
    ADD CONSTRAINT "Ciudad_pkey" PRIMARY KEY ("Id_ciudad");


--
-- Name: Competencia Competencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Competencia"
    ADD CONSTRAINT "Competencia_pkey" PRIMARY KEY ("Id_competencia");


--
-- Name: Detalles_Reporte Detalles_Reporte_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Detalles_Reporte"
    ADD CONSTRAINT "Detalles_Reporte_pkey" PRIMARY KEY ("Id_detalles_reporte");


--
-- Name: Dia Dia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Dia"
    ADD CONSTRAINT "Dia_pkey" PRIMARY KEY ("Id_dia");


--
-- Name: Direccion Direccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Direccion"
    ADD CONSTRAINT "Direccion_pkey" PRIMARY KEY ("Id_direccion");


--
-- Name: Escuela_Regular Escuela_Regular_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Escuela_Regular"
    ADD CONSTRAINT "Escuela_Regular_pkey" PRIMARY KEY ("Id_escuela");


--
-- Name: Especialidad Especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Especialidad"
    ADD CONSTRAINT "Especialidad_pkey" PRIMARY KEY ("Id_especialidad");


--
-- Name: Estado Estado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estado"
    ADD CONSTRAINT "Estado_pkey" PRIMARY KEY ("Id_estado");


--
-- Name: Estructura_Evaluacion Estructura_Evaluacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estructura_Evaluacion"
    ADD CONSTRAINT "Estructura_Evaluacion_pkey" PRIMARY KEY ("Id_estructura_evaluacion");


--
-- Name: Estudiante_Padre Estudiante_Padre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Padre"
    ADD CONSTRAINT "Estudiante_Padre_pkey" PRIMARY KEY ("Id_estudiante", "Id_padre");


--
-- Name: Estudiante_Seccion Estudiante_Seccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion"
    ADD CONSTRAINT "Estudiante_Seccion_pkey" PRIMARY KEY ("Id_estudiante_seccion");


--
-- Name: Estudiante Estudiante_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key1" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key2" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key3" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key4" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key5" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key6" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key7" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key8" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_cedula_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_cedula_key9" UNIQUE (cedula);


--
-- Name: Estudiante Estudiante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_pkey" PRIMARY KEY ("Id_estudiante");


--
-- Name: Grado Grado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Grado"
    ADD CONSTRAINT "Grado_pkey" PRIMARY KEY ("Id_grado");


--
-- Name: Historial_Medico Historial_Medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Historial_Medico"
    ADD CONSTRAINT "Historial_Medico_pkey" PRIMARY KEY ("Id_historial");


--
-- Name: Horario Horario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_pkey" PRIMARY KEY ("Id_horario");


--
-- Name: Incidencia Incidencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Incidencia"
    ADD CONSTRAINT "Incidencia_pkey" PRIMARY KEY ("Id_incidencia");


--
-- Name: Lapso Lapso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lapso"
    ADD CONSTRAINT "Lapso_pkey" PRIMARY KEY ("Id_lapso");


--
-- Name: Materia Materia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Materia"
    ADD CONSTRAINT "Materia_pkey" PRIMARY KEY ("Id_materia");


--
-- Name: Municipio Municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Municipio"
    ADD CONSTRAINT "Municipio_pkey" PRIMARY KEY ("Id_municipio");


--
-- Name: Nivel_Danza Nivel_Danza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nivel_Danza"
    ADD CONSTRAINT "Nivel_Danza_pkey" PRIMARY KEY ("Id_nivel_danza");


--
-- Name: Nivel_Escolar Nivel_Escolar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nivel_Escolar"
    ADD CONSTRAINT "Nivel_Escolar_pkey" PRIMARY KEY ("Id_nivel");


--
-- Name: Nota_Competencia_Estudiante Nota_Competencia_Estudiante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nota_Competencia_Estudiante"
    ADD CONSTRAINT "Nota_Competencia_Estudiante_pkey" PRIMARY KEY ("Id_estudiante_competencia");


--
-- Name: Padre Padre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Padre"
    ADD CONSTRAINT "Padre_pkey" PRIMARY KEY ("Id_padre");


--
-- Name: Pais Pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pais"
    ADD CONSTRAINT "Pais_pkey" PRIMARY KEY ("Id_pais");


--
-- Name: Parroquia Parroquia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Parroquia"
    ADD CONSTRAINT "Parroquia_pkey" PRIMARY KEY ("Id_parroquia");


--
-- Name: Periodo_Inscripcion Periodo_Inscripcion_Id_ano_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Inscripcion"
    ADD CONSTRAINT "Periodo_Inscripcion_Id_ano_key" UNIQUE ("Id_ano");


--
-- Name: Periodo_Inscripcion Periodo_Inscripcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Inscripcion"
    ADD CONSTRAINT "Periodo_Inscripcion_pkey" PRIMARY KEY ("Id_periodo_inscripcion");


--
-- Name: Periodo_Subida_Notas Periodo_Subida_Notas_Id_ano_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Subida_Notas"
    ADD CONSTRAINT "Periodo_Subida_Notas_Id_ano_key" UNIQUE ("Id_ano");


--
-- Name: Periodo_Subida_Notas Periodo_Subida_Notas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Subida_Notas"
    ADD CONSTRAINT "Periodo_Subida_Notas_pkey" PRIMARY KEY ("Id_periodo_notas");


--
-- Name: Profesor_Especialidad Profesor_Especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad"
    ADD CONSTRAINT "Profesor_Especialidad_pkey" PRIMARY KEY ("Id_profesor_especialidad");


--
-- Name: Profesor_Grado Profesor_Grado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Grado"
    ADD CONSTRAINT "Profesor_Grado_pkey" PRIMARY KEY ("Id_profesor", "Id_grado", "Id_ano");


--
-- Name: Profesor_Materia Profesor_Materia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Materia"
    ADD CONSTRAINT "Profesor_Materia_pkey" PRIMARY KEY ("Id_profesor", "Id_materia");


--
-- Name: Profesor Profesor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor"
    ADD CONSTRAINT "Profesor_pkey" PRIMARY KEY ("Id_profesor");


--
-- Name: Representante Representante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Representante"
    ADD CONSTRAINT "Representante_pkey" PRIMARY KEY ("Id_representante");


--
-- Name: Revision_Materia Revision_Materia_Id_estudiante_Id_materia_Id_ano_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Revision_Materia"
    ADD CONSTRAINT "Revision_Materia_Id_estudiante_Id_materia_Id_ano_key" UNIQUE ("Id_estudiante", "Id_materia", "Id_ano");


--
-- Name: Revision_Materia Revision_Materia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Revision_Materia"
    ADD CONSTRAINT "Revision_Materia_pkey" PRIMARY KEY ("Id_revision");


--
-- Name: Rol Rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rol"
    ADD CONSTRAINT "Rol_pkey" PRIMARY KEY ("Id_rol");


--
-- Name: Seccion Seccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion"
    ADD CONSTRAINT "Seccion_pkey" PRIMARY KEY ("Id_seccion");


--
-- Name: Seguro Seguro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seguro"
    ADD CONSTRAINT "Seguro_pkey" PRIMARY KEY ("Id_seguro");


--
-- Name: Solicitud_Constancia Solicitud_Constancia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Solicitud_Constancia"
    ADD CONSTRAINT "Solicitud_Constancia_pkey" PRIMARY KEY ("Id_solicitud");


--
-- Name: Tipo_Clase Tipo_Clase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tipo_Clase"
    ADD CONSTRAINT "Tipo_Clase_pkey" PRIMARY KEY ("Id_tipo_clase");


--
-- Name: Tipo_Evaluacion Tipo_Evaluacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tipo_Evaluacion"
    ADD CONSTRAINT "Tipo_Evaluacion_pkey" PRIMARY KEY ("Id_tipo_evaluacion");


--
-- Name: Usuario_Rol Usuario_Rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario_Rol"
    ADD CONSTRAINT "Usuario_Rol_pkey" PRIMARY KEY ("Id_usuario", "Id_rol");


--
-- Name: Usuario Usuario_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key1" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key10" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key11; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key11" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key12; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key12" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key13" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key14; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key14" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key15" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key16; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key16" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key17; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key17" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key18" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key19; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key19" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key2" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key20; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key20" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key21; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key21" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key22" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key23; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key23" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key24; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key24" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key25" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key3" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key4" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key5" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key6" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key7" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key8" UNIQUE (cedula);


--
-- Name: Usuario Usuario_cedula_key9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_cedula_key9" UNIQUE (cedula);


--
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY ("Id_usuario");


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id_category);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id_customer);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id_department);


--
-- Name: details_order details_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.details_order
    ADD CONSTRAINT details_order_pkey PRIMARY KEY (id_details);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id_employee);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id_order);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id_product);


--
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id_report);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id_role);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id_stock);


--
-- Name: Horario uq_disponibilidad_profesor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT uq_disponibilidad_profesor UNIQUE ("Id_profesor", "Id_dia", "Id_bloque");


--
-- Name: Estudiante_Seccion uq_estudiante_seccion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion"
    ADD CONSTRAINT uq_estudiante_seccion UNIQUE ("Id_estudiante", "Id_seccion");


--
-- Name: Horario uq_ocupacion_aula; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT uq_ocupacion_aula UNIQUE ("Id_aula", "Id_dia", "Id_bloque");


--
-- Name: Profesor_Especialidad uq_profesor_especialidad_ano; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad"
    ADD CONSTRAINT uq_profesor_especialidad_ano UNIQUE ("Id_profesor", "Id_ano");


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);


--
-- Name: idx_profesor_especialidad_ano; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_especialidad_ano ON public."Profesor_Especialidad" USING btree ("Id_ano");


--
-- Name: idx_profesor_especialidad_especialidad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_especialidad_especialidad ON public."Profesor_Especialidad" USING btree ("Id_especialidad");


--
-- Name: idx_profesor_especialidad_profesor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_especialidad_profesor ON public."Profesor_Especialidad" USING btree ("Id_profesor");


--
-- Name: idx_profesor_grado_ano; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_grado_ano ON public."Profesor_Grado" USING btree ("Id_ano");


--
-- Name: idx_profesor_grado_grado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_grado_grado ON public."Profesor_Grado" USING btree ("Id_grado");


--
-- Name: idx_profesor_grado_profesor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profesor_grado_profesor ON public."Profesor_Grado" USING btree ("Id_profesor");


--
-- Name: idx_seccion_ano; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seccion_ano ON public."Seccion" USING btree ("Id_ano");


--
-- Name: Periodo_Inscripcion trg_periodo_inscripcion_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_periodo_inscripcion_updated BEFORE UPDATE ON public."Periodo_Inscripcion" FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: Periodo_Subida_Notas trg_periodo_notas_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_periodo_notas_updated BEFORE UPDATE ON public."Periodo_Subida_Notas" FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: Asistencia Asistencia_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Asistencia"
    ADD CONSTRAINT "Asistencia_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Asistencia Asistencia_Id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Asistencia"
    ADD CONSTRAINT "Asistencia_Id_seccion_fkey" FOREIGN KEY ("Id_seccion") REFERENCES public."Seccion"("Id_seccion");


--
-- Name: Aula Aula_Id_tipo_clase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula"
    ADD CONSTRAINT "Aula_Id_tipo_clase_fkey" FOREIGN KEY ("Id_tipo_clase") REFERENCES public."Tipo_Clase"("Id_tipo_clase");


--
-- Name: Aula_Materia Aula_Materia_Id_aula_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula_Materia"
    ADD CONSTRAINT "Aula_Materia_Id_aula_fkey" FOREIGN KEY ("Id_aula") REFERENCES public."Aula"("Id_aula");


--
-- Name: Aula_Materia Aula_Materia_Id_materia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aula_Materia"
    ADD CONSTRAINT "Aula_Materia_Id_materia_fkey" FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


--
-- Name: Boleta_Notas Boleta_Notas_Id_detalles_reporte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_Id_detalles_reporte_fkey" FOREIGN KEY ("Id_detalles_reporte") REFERENCES public."Detalles_Reporte"("Id_detalles_reporte");


--
-- Name: Boleta_Notas Boleta_Notas_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Boleta_Notas Boleta_Notas_Id_lapso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_Id_lapso_fkey" FOREIGN KEY ("Id_lapso") REFERENCES public."Lapso"("Id_lapso");


--
-- Name: Boleta_Notas Boleta_Notas_Id_materia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_Id_materia_fkey" FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


--
-- Name: Boleta_Notas Boleta_Notas_Id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Boleta_Notas"
    ADD CONSTRAINT "Boleta_Notas_Id_seccion_fkey" FOREIGN KEY ("Id_seccion") REFERENCES public."Seccion"("Id_seccion");


--
-- Name: Carga_Nota Carga_Nota_Id_estructura_evaluacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carga_Nota"
    ADD CONSTRAINT "Carga_Nota_Id_estructura_evaluacion_fkey" FOREIGN KEY ("Id_estructura_evaluacion") REFERENCES public."Estructura_Evaluacion"("Id_estructura_evaluacion");


--
-- Name: Carga_Nota Carga_Nota_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Carga_Nota"
    ADD CONSTRAINT "Carga_Nota_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Ciudad Ciudad_Id_parroquia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad"
    ADD CONSTRAINT "Ciudad_Id_parroquia_fkey" FOREIGN KEY ("Id_parroquia") REFERENCES public."Parroquia"("Id_parroquia");


--
-- Name: Competencia Competencia_Id_materia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Competencia"
    ADD CONSTRAINT "Competencia_Id_materia_fkey" FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


--
-- Name: Direccion Direccion_Id_ciudad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Direccion"
    ADD CONSTRAINT "Direccion_Id_ciudad_fkey" FOREIGN KEY ("Id_ciudad") REFERENCES public."Ciudad"("Id_ciudad");


--
-- Name: Estado Estado_Id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estado"
    ADD CONSTRAINT "Estado_Id_pais_fkey" FOREIGN KEY ("Id_pais") REFERENCES public."Pais"("Id_pais");


--
-- Name: Estructura_Evaluacion Estructura_Evaluacion_Id_lapso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estructura_Evaluacion"
    ADD CONSTRAINT "Estructura_Evaluacion_Id_lapso_fkey" FOREIGN KEY ("Id_lapso") REFERENCES public."Lapso"("Id_lapso");


--
-- Name: Estructura_Evaluacion Estructura_Evaluacion_Id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estructura_Evaluacion"
    ADD CONSTRAINT "Estructura_Evaluacion_Id_seccion_fkey" FOREIGN KEY ("Id_seccion") REFERENCES public."Seccion"("Id_seccion");


--
-- Name: Estructura_Evaluacion Estructura_Evaluacion_Id_tipo_evaluacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estructura_Evaluacion"
    ADD CONSTRAINT "Estructura_Evaluacion_Id_tipo_evaluacion_fkey" FOREIGN KEY ("Id_tipo_evaluacion") REFERENCES public."Tipo_Evaluacion"("Id_tipo_evaluacion");


--
-- Name: Estudiante Estudiante_Id_escuela_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_escuela_fkey" FOREIGN KEY ("Id_escuela") REFERENCES public."Escuela_Regular"("Id_escuela");


--
-- Name: Estudiante Estudiante_Id_historial_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_historial_fkey" FOREIGN KEY ("Id_historial") REFERENCES public."Historial_Medico"("Id_historial");


--
-- Name: Estudiante Estudiante_Id_nivel_danza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_nivel_danza_fkey" FOREIGN KEY ("Id_nivel_danza") REFERENCES public."Nivel_Danza"("Id_nivel_danza");


--
-- Name: Estudiante Estudiante_Id_nivel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_nivel_fkey" FOREIGN KEY ("Id_nivel") REFERENCES public."Nivel_Escolar"("Id_nivel");


--
-- Name: Estudiante Estudiante_Id_representante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_representante_fkey" FOREIGN KEY ("Id_representante") REFERENCES public."Representante"("Id_representante");


--
-- Name: Estudiante Estudiante_Id_seguro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT "Estudiante_Id_seguro_fkey" FOREIGN KEY ("Id_seguro") REFERENCES public."Seguro"("Id_seguro");


--
-- Name: Estudiante_Padre Estudiante_Padre_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Padre"
    ADD CONSTRAINT "Estudiante_Padre_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Estudiante_Padre Estudiante_Padre_Id_padre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Padre"
    ADD CONSTRAINT "Estudiante_Padre_Id_padre_fkey" FOREIGN KEY ("Id_padre") REFERENCES public."Padre"("Id_padre");


--
-- Name: Estudiante_Seccion Estudiante_Seccion_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion"
    ADD CONSTRAINT "Estudiante_Seccion_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Estudiante_Seccion Estudiante_Seccion_Id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion"
    ADD CONSTRAINT "Estudiante_Seccion_Id_seccion_fkey" FOREIGN KEY ("Id_seccion") REFERENCES public."Seccion"("Id_seccion");


--
-- Name: Horario Horario_Id_aula_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_Id_aula_fkey" FOREIGN KEY ("Id_aula") REFERENCES public."Aula"("Id_aula");


--
-- Name: Horario Horario_Id_bloque_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_Id_bloque_fkey" FOREIGN KEY ("Id_bloque") REFERENCES public."Bloque_Horario"("Id_bloque");


--
-- Name: Horario Horario_Id_dia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_Id_dia_fkey" FOREIGN KEY ("Id_dia") REFERENCES public."Dia"("Id_dia");


--
-- Name: Horario Horario_Id_profesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_Id_profesor_fkey" FOREIGN KEY ("Id_profesor") REFERENCES public."Profesor"("Id_profesor");


--
-- Name: Horario Horario_Id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT "Horario_Id_seccion_fkey" FOREIGN KEY ("Id_seccion") REFERENCES public."Seccion"("Id_seccion");


--
-- Name: Incidencia Incidencia_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Incidencia"
    ADD CONSTRAINT "Incidencia_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Incidencia Incidencia_Id_usuario_involucrado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Incidencia"
    ADD CONSTRAINT "Incidencia_Id_usuario_involucrado_fkey" FOREIGN KEY ("Id_usuario_involucrado") REFERENCES public."Usuario"("Id_usuario");


--
-- Name: Incidencia Incidencia_Id_usuario_reporta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Incidencia"
    ADD CONSTRAINT "Incidencia_Id_usuario_reporta_fkey" FOREIGN KEY ("Id_usuario_reporta") REFERENCES public."Usuario"("Id_usuario");


--
-- Name: Lapso Lapso_Id_ano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Lapso"
    ADD CONSTRAINT "Lapso_Id_ano_fkey" FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano");


--
-- Name: Municipio Municipio_Id_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Municipio"
    ADD CONSTRAINT "Municipio_Id_estado_fkey" FOREIGN KEY ("Id_estado") REFERENCES public."Estado"("Id_estado");


--
-- Name: Nota_Competencia_Estudiante Nota_Competencia_Estudiante_Id_competencia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nota_Competencia_Estudiante"
    ADD CONSTRAINT "Nota_Competencia_Estudiante_Id_competencia_fkey" FOREIGN KEY ("Id_competencia") REFERENCES public."Competencia"("Id_competencia");


--
-- Name: Nota_Competencia_Estudiante Nota_Competencia_Estudiante_Id_nota_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Nota_Competencia_Estudiante"
    ADD CONSTRAINT "Nota_Competencia_Estudiante_Id_nota_fkey" FOREIGN KEY ("Id_nota") REFERENCES public."Carga_Nota"("Id_nota");


--
-- Name: Parroquia Parroquia_Id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Parroquia"
    ADD CONSTRAINT "Parroquia_Id_municipio_fkey" FOREIGN KEY ("Id_municipio") REFERENCES public."Municipio"("Id_municipio");


--
-- Name: Periodo_Inscripcion Periodo_Inscripcion_Id_ano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Inscripcion"
    ADD CONSTRAINT "Periodo_Inscripcion_Id_ano_fkey" FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano") ON DELETE CASCADE;


--
-- Name: Periodo_Subida_Notas Periodo_Subida_Notas_Id_ano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Periodo_Subida_Notas"
    ADD CONSTRAINT "Periodo_Subida_Notas_Id_ano_fkey" FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano") ON DELETE CASCADE;


--
-- Name: Profesor_Grado Profesor_Grado_Id_ano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Grado"
    ADD CONSTRAINT "Profesor_Grado_Id_ano_fkey" FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano") ON DELETE CASCADE;


--
-- Name: Profesor Profesor_Id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor"
    ADD CONSTRAINT "Profesor_Id_usuario_fkey" FOREIGN KEY ("Id_usuario") REFERENCES public."Usuario"("Id_usuario");


--
-- Name: Profesor_Materia Profesor_Materia_Id_materia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Materia"
    ADD CONSTRAINT "Profesor_Materia_Id_materia_fkey" FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


--
-- Name: Profesor_Materia Profesor_Materia_Id_profesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Materia"
    ADD CONSTRAINT "Profesor_Materia_Id_profesor_fkey" FOREIGN KEY ("Id_profesor") REFERENCES public."Profesor"("Id_profesor");


--
-- Name: Representante Representante_Id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Representante"
    ADD CONSTRAINT "Representante_Id_usuario_fkey" FOREIGN KEY ("Id_usuario") REFERENCES public."Usuario"("Id_usuario");


--
-- Name: Seccion Seccion_Id_ano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion"
    ADD CONSTRAINT "Seccion_Id_ano_fkey" FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano");


--
-- Name: Seccion Seccion_Id_lapso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion"
    ADD CONSTRAINT "Seccion_Id_lapso_fkey" FOREIGN KEY ("Id_lapso") REFERENCES public."Lapso"("Id_lapso");


--
-- Name: Seccion Seccion_Id_materia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion"
    ADD CONSTRAINT "Seccion_Id_materia_fkey" FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


--
-- Name: Solicitud_Constancia Solicitud_Constancia_Id_estudiante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Solicitud_Constancia"
    ADD CONSTRAINT "Solicitud_Constancia_Id_estudiante_fkey" FOREIGN KEY ("Id_estudiante") REFERENCES public."Estudiante"("Id_estudiante");


--
-- Name: Solicitud_Constancia Solicitud_Constancia_Id_representante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Solicitud_Constancia"
    ADD CONSTRAINT "Solicitud_Constancia_Id_representante_fkey" FOREIGN KEY ("Id_representante") REFERENCES public."Representante"("Id_representante");


--
-- Name: Usuario Usuario_Id_direccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_Id_direccion_fkey" FOREIGN KEY ("Id_direccion") REFERENCES public."Direccion"("Id_direccion");


--
-- Name: Usuario Usuario_Id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_Id_rol_fkey" FOREIGN KEY ("Id_rol") REFERENCES public."Rol"("Id_rol") ON UPDATE CASCADE;


--
-- Name: Usuario_Rol Usuario_Rol_Id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario_Rol"
    ADD CONSTRAINT "Usuario_Rol_Id_rol_fkey" FOREIGN KEY ("Id_rol") REFERENCES public."Rol"("Id_rol") ON DELETE CASCADE;


--
-- Name: Usuario_Rol Usuario_Rol_Id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario_Rol"
    ADD CONSTRAINT "Usuario_Rol_Id_usuario_fkey" FOREIGN KEY ("Id_usuario") REFERENCES public."Usuario"("Id_usuario") ON DELETE CASCADE;


--
-- Name: customer customer_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_id_user_fkey FOREIGN KEY (id_user) REFERENCES public."user"(id_user);


--
-- Name: details_order details_order_id_order_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.details_order
    ADD CONSTRAINT details_order_id_order_fkey FOREIGN KEY (id_order) REFERENCES public."order"(id_order);


--
-- Name: details_order details_order_id_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.details_order
    ADD CONSTRAINT details_order_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.product(id_product);


--
-- Name: employee employee_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_id_user_fkey FOREIGN KEY (id_user) REFERENCES public."user"(id_user);


--
-- Name: Profesor_Especialidad fk_profesor_especialidad_ano; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad"
    ADD CONSTRAINT fk_profesor_especialidad_ano FOREIGN KEY ("Id_ano") REFERENCES public."Ano_Academico"("Id_ano") ON DELETE CASCADE;


--
-- Name: Profesor_Especialidad fk_profesor_especialidad_especialidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad"
    ADD CONSTRAINT fk_profesor_especialidad_especialidad FOREIGN KEY ("Id_especialidad") REFERENCES public."Especialidad"("Id_especialidad") ON DELETE CASCADE;


--
-- Name: Profesor_Especialidad fk_profesor_especialidad_profesor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Especialidad"
    ADD CONSTRAINT fk_profesor_especialidad_profesor FOREIGN KEY ("Id_profesor") REFERENCES public."Profesor"("Id_profesor") ON DELETE CASCADE;


--
-- Name: Profesor_Grado fk_profesor_grado_grado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Grado"
    ADD CONSTRAINT fk_profesor_grado_grado FOREIGN KEY ("Id_grado") REFERENCES public."Grado"("Id_grado") ON DELETE CASCADE;


--
-- Name: Profesor_Grado fk_profesor_grado_profesor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profesor_Grado"
    ADD CONSTRAINT fk_profesor_grado_profesor FOREIGN KEY ("Id_profesor") REFERENCES public."Profesor"("Id_profesor") ON DELETE CASCADE;


--
-- Name: order order_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customer(id_customer);


--
-- Name: order order_id_employee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_id_employee_fkey FOREIGN KEY (id_employee) REFERENCES public.employee(id_employee);


--
-- Name: product product_id_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_id_category_fkey FOREIGN KEY (id_category) REFERENCES public.category(id_category);


--
-- Name: product product_id_department_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_id_department_fkey FOREIGN KEY (id_department) REFERENCES public.department(id_department);


--
-- Name: report report_id_order_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_id_order_fkey FOREIGN KEY (id_order) REFERENCES public."order"(id_order);


--
-- Name: stock stock_id_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.product(id_product);


--
-- Name: user user_id_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id_role);


--
-- PostgreSQL database dump complete
--

\unrestrict XJaVHeiRemsbJoYMorP0betttZkPoFha9wgsXPUoaK9WdRAeQy65Ds38lDgARTk

