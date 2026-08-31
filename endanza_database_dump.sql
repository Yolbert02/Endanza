--
-- PostgreSQL database dump
--

\restrict jv9f3Cnsh3rKe5hocMCOmeYBueCj5s58S7Qdvga6CJzSCohFkHJ35wXKEqevOd0

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
    "Id_historial" integer
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
    termino_nacimiento character varying(20)
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
-- Data for Name: Ano_Academico; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Ano_Academico" ("Id_ano", nombre_ano, estatus_ano, inicio_ano, fin_ano, activo) (INSERT statements)
INSERT INTO public."Ano_Academico" ("Id_ano", nombre_ano, estatus_ano, inicio_ano, fin_ano, activo) VALUES ('1', '2026 - 2027', 'activo', '2026-09-15', '2027-07-31', 't');
INSERT INTO public."Ano_Academico" ("Id_ano", nombre_ano, estatus_ano, inicio_ano, fin_ano, activo) VALUES ('3', '2025 - 2026', 'activo', '2025-09-15', '2026-07-31', 't');



--
-- Data for Name: Asistencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Asistencia" ("Id_asistencia", fecha_asistencia, estatus, esta_justificada, descripcion_justificacion, "Id_estudiante", "Id_seccion") (INSERT statements)



--
-- Data for Name: Aula; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") (INSERT statements)
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('1', 'Salón Rosado', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('2', 'Salón Azul', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('3', 'Salón Violeta', '3');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('4', 'Salón Amarillo', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('5', 'Salón Blanco', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('6', 'Patio', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('7', 'Salón Gris', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('8', 'Salón de Colores I', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('9', 'Salón de Colores II', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('10', 'Tarima', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('11', 'Placa I', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('12', 'Placa II', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('13', 'Placa III', '1');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('14', 'Salón Verde', '2');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('15', 'Área de Cafetín', '4');
INSERT INTO public."Aula" ("Id_aula", nombre_aula, "Id_tipo_clase") VALUES ('16', 'Salón Nutrición', '3');



--
-- Data for Name: Aula_Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Aula_Materia" ("Id_aula", "Id_materia") (INSERT statements)



--
-- Data for Name: Bloque_Horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Bloque_Horario" ("Id_bloque", nombre_bloque, inicio_bloque, fin_bloque) (INSERT statements)



--
-- Data for Name: Boleta_Notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Boleta_Notas" ("Id_boleta", puntaje_final_lapso, fecha_emision, "Id_estudiante", "Id_lapso", "Id_materia", "Id_detalles_reporte", "Id_seccion", descargas, disponible) (INSERT statements)



--
-- Data for Name: Boletin_Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) (INSERT statements)
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('1', '466', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('2', '236', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('3', '246', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('4', '273', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('5', '570', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('6', '244', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('7', '499', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('8', '118', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('9', '370', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('10', '161', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('11', '330', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('12', '203', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('13', '433', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('14', '232', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('15', '312', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('16', '414', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('17', '371', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');
INSERT INTO public."Boletin_Estudiante" (id, student_id, academic_year_id, is_available, created_at, updated_at, downloads) VALUES ('18', '193', '3', 't', '2026-08-26 04:06:27.259949', '2026-08-26 04:06:27.259949', '0');



--
-- Data for Name: Carga_Nota; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") (INSERT statements)
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('1', '16', 't', '466', '1');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('2', '19', 't', '466', '2');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('3', '16', 't', '466', '3');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('4', '12', 't', '466', '4');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('5', '12', 't', '466', '5');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('6', '7', 't', '466', '6');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('7', '16', 't', '466', '7');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('8', '17', 't', '466', '8');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('9', '17', 't', '466', '9');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('10', '18', 't', '466', '10');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('11', '18', 't', '466', '11');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('12', '18', 't', '466', '12');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('13', '17', 't', '466', '13');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('14', '16', 't', '466', '14');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('15', '16', 't', '466', '15');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('16', '16', 't', '466', '16');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('17', '14', 't', '466', '17');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('18', '15', 't', '466', '18');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('19', '14', 't', '236', '1');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('20', '19', 't', '236', '2');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('21', '18', 't', '236', '3');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('22', '13', 't', '236', '4');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('23', '13', 't', '236', '5');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('24', '10', 't', '236', '6');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('25', '16', 't', '236', '7');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('26', '17', 't', '236', '8');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('27', '17', 't', '236', '9');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('28', '18', 't', '236', '10');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('29', '19', 't', '236', '11');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('30', '19', 't', '236', '12');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('31', '15', 't', '236', '13');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('32', '16', 't', '236', '14');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('33', '12', 't', '236', '15');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('34', '18', 't', '236', '16');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('35', '13', 't', '236', '17');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('36', '13', 't', '236', '18');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('37', '18', 't', '246', '1');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('38', '20', 't', '246', '2');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('39', '16', 't', '246', '3');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('40', '13', 't', '246', '4');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('41', '14', 't', '246', '5');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('42', '12', 't', '246', '6');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('43', '15', 't', '246', '7');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('44', '18', 't', '246', '8');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('45', '17', 't', '246', '9');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('46', '20', 't', '246', '10');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('47', '20', 't', '246', '11');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('48', '20', 't', '246', '12');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('49', '18', 't', '246', '13');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('50', '18', 't', '246', '14');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('51', '17', 't', '246', '15');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('52', '20', 't', '246', '16');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('53', '15', 't', '246', '17');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('54', '15', 't', '246', '18');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('55', '17', 't', '273', '19');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('56', '18', 't', '273', '20');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('57', '18', 't', '273', '21');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('58', '17', 't', '273', '22');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('59', '16', 't', '273', '23');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('60', '14', 't', '273', '24');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('61', '15', 't', '273', '25');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('62', '16', 't', '273', '26');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('63', '17', 't', '273', '27');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('64', '17', 't', '273', '28');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('65', '19', 't', '273', '29');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('66', '18', 't', '273', '30');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('67', '17', 't', '273', '31');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('68', '17', 't', '273', '32');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('69', '18', 't', '273', '33');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('70', '19', 't', '273', '34');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('71', '20', 't', '273', '35');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('72', '16', 't', '273', '36');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('73', '17', 't', '273', '37');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('74', '17', 't', '570', '19');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('75', '19', 't', '570', '20');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('76', '18', 't', '570', '21');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('77', '19', 't', '570', '22');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('78', '17', 't', '570', '23');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('79', '17', 't', '570', '24');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('80', '18', 't', '570', '25');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('81', '19', 't', '570', '26');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('82', '18', 't', '570', '27');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('83', '16', 't', '570', '28');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('84', '20', 't', '570', '29');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('85', '17', 't', '570', '30');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('86', '18', 't', '570', '31');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('87', '17', 't', '570', '32');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('88', '18', 't', '570', '33');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('89', '19', 't', '570', '34');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('90', '20', 't', '570', '35');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('91', '16', 't', '570', '36');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('92', '17', 't', '570', '37');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('93', '16', 't', '244', '19');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('94', '15', 't', '244', '20');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('95', '15', 't', '244', '21');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('96', '17', 't', '244', '22');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('97', '15', 't', '244', '23');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('98', '14', 't', '244', '24');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('99', '17', 't', '244', '25');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('100', '17', 't', '244', '26');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('101', '18', 't', '244', '27');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('102', '16', 't', '244', '28');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('103', '17', 't', '244', '29');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('104', '16', 't', '244', '30');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('105', '18', 't', '244', '31');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('106', '18', 't', '244', '32');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('107', '16', 't', '244', '33');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('108', '17', 't', '244', '34');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('109', '20', 't', '244', '35');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('110', '16', 't', '244', '36');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('111', '16', 't', '244', '37');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('112', '16', 't', '499', '19');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('113', '16', 't', '499', '20');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('114', '16', 't', '499', '21');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('115', '18', 't', '499', '22');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('116', '16', 't', '499', '23');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('117', '14', 't', '499', '24');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('118', '17', 't', '499', '25');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('119', '18', 't', '499', '26');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('120', '19', 't', '499', '27');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('121', '16', 't', '499', '28');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('122', '17', 't', '499', '29');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('123', '17', 't', '499', '30');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('124', '17', 't', '499', '31');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('125', '17', 't', '499', '32');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('126', '18', 't', '499', '33');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('127', '19', 't', '499', '34');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('128', '20', 't', '499', '35');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('129', '17', 't', '499', '36');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('130', '17', 't', '499', '37');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('131', '15', 't', '118', '38');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('132', '13', 't', '118', '39');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('133', '14', 't', '118', '40');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('134', '17', 't', '118', '41');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('135', '17', 't', '118', '42');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('136', '16', 't', '118', '43');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('137', '15', 't', '118', '44');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('138', '16', 't', '118', '45');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('139', '15', 't', '118', '46');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('140', '16', 't', '118', '47');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('141', '17', 't', '118', '48');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('142', '18', 't', '118', '49');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('143', '17', 't', '118', '50');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('144', '20', 't', '118', '51');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('145', '15', 't', '118', '52');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('146', '17', 't', '118', '53');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('147', '18', 't', '370', '38');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('148', '18', 't', '370', '39');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('149', '16', 't', '370', '40');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('150', '18', 't', '370', '41');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('151', '19', 't', '370', '42');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('152', '18', 't', '370', '43');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('153', '15', 't', '370', '44');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('154', '18', 't', '370', '45');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('155', '17', 't', '370', '46');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('156', '18', 't', '370', '47');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('157', '17', 't', '370', '48');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('158', '18', 't', '370', '49');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('159', '18', 't', '370', '50');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('160', '20', 't', '370', '51');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('161', '17', 't', '370', '52');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('162', '18', 't', '370', '53');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('163', '16', 't', '161', '38');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('164', '16', 't', '161', '39');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('165', '15', 't', '161', '40');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('166', '18', 't', '161', '41');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('167', '18', 't', '161', '42');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('168', '13', 't', '161', '43');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('169', '18', 't', '161', '44');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('170', '18', 't', '161', '45');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('171', '18', 't', '161', '46');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('172', '18', 't', '161', '47');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('173', '17', 't', '161', '48');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('174', '17', 't', '161', '49');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('175', '18', 't', '161', '50');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('176', '20', 't', '161', '51');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('177', '17', 't', '161', '52');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('178', '18', 't', '161', '53');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('179', '18', 't', '330', '54');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('180', '18', 't', '330', '55');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('181', '19', 't', '330', '56');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('182', '16', 't', '330', '57');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('183', '14', 't', '330', '58');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('184', '11', 't', '330', '59');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('185', '17', 't', '330', '60');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('186', '16', 't', '330', '61');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('187', '16', 't', '330', '62');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('188', '19', 't', '330', '63');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('189', '19', 't', '330', '64');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('190', '20', 't', '330', '65');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('191', '17', 't', '330', '66');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('192', '17', 't', '330', '67');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('193', '12', 't', '330', '68');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('194', '17', 't', '330', '69');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('195', '18', 't', '330', '70');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('196', '16', 't', '330', '71');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('197', '17', 't', '330', '72');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('198', '17', 't', '203', '54');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('199', '13', 't', '203', '55');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('200', '17', 't', '203', '56');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('201', '13', 't', '203', '57');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('202', '10', 't', '203', '58');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('203', '8', 't', '203', '59');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('204', '17', 't', '203', '60');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('205', '16', 't', '203', '61');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('206', '16', 't', '203', '62');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('207', '18', 't', '203', '63');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('208', '14', 't', '203', '64');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('209', '20', 't', '203', '65');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('210', '18', 't', '203', '66');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('211', '17', 't', '203', '67');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('212', '13', 't', '203', '68');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('213', '15', 't', '203', '69');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('214', '17', 't', '203', '70');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('215', '14', 't', '203', '71');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('216', '16', 't', '203', '72');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('217', '16', 't', '433', '54');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('218', '18', 't', '433', '55');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('219', '16', 't', '433', '56');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('220', '16', 't', '433', '57');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('221', '14', 't', '433', '58');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('222', '13', 't', '433', '59');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('223', '17', 't', '433', '60');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('224', '16', 't', '433', '61');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('225', '16', 't', '433', '62');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('226', '16', 't', '433', '63');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('227', '17', 't', '433', '64');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('228', '18', 't', '433', '65');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('229', '16', 't', '433', '66');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('230', '14', 't', '433', '67');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('231', '13', 't', '433', '68');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('232', '16', 't', '433', '69');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('233', '17', 't', '433', '70');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('234', '10', 't', '433', '71');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('235', '14', 't', '433', '72');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('236', '18', 't', '232', '54');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('237', '14', 't', '232', '55');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('238', '16', 't', '232', '56');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('239', '14', 't', '232', '57');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('240', '12', 't', '232', '58');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('241', '3', 't', '232', '59');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('242', '17', 't', '232', '60');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('243', '16', 't', '232', '61');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('244', '16', 't', '232', '62');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('245', '18', 't', '232', '63');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('246', '12', 't', '232', '64');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('247', '20', 't', '232', '65');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('248', '18', 't', '232', '66');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('249', '17', 't', '232', '67');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('250', '14', 't', '232', '68');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('251', '16', 't', '232', '69');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('252', '17', 't', '232', '70');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('253', '16', 't', '232', '71');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('254', '17', 't', '232', '72');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('255', '15', 't', '312', '73');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('256', '17', 't', '312', '74');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('257', '17', 't', '312', '75');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('258', '13', 't', '312', '76');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('259', '13', 't', '312', '77');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('260', '12', 't', '312', '78');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('261', '17', 't', '312', '79');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('262', '15', 't', '312', '80');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('263', '15', 't', '312', '81');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('264', '18', 't', '312', '82');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('265', '18', 't', '312', '83');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('266', '17', 't', '312', '84');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('267', '19', 't', '312', '85');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('268', '20', 't', '312', '86');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('269', '18', 't', '312', '87');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('270', '15', 't', '414', '73');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('271', '16', 't', '414', '74');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('272', '14', 't', '414', '75');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('273', '7', 't', '414', '76');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('274', '4', 't', '414', '77');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('275', '0', 't', '414', '78');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('276', '16', 't', '414', '79');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('277', '13', 't', '414', '80');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('278', '14', 't', '414', '81');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('279', '17', 't', '414', '82');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('280', '15', 't', '414', '83');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('281', '17', 't', '414', '84');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('282', '18', 't', '414', '85');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('283', '20', 't', '414', '86');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('284', '18', 't', '414', '87');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('285', '18', 't', '371', '73');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('286', '19', 't', '371', '74');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('287', '18', 't', '371', '75');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('288', '14', 't', '371', '76');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('289', '14', 't', '371', '77');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('290', '16', 't', '371', '78');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('291', '14', 't', '371', '79');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('292', '18', 't', '371', '80');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('293', '16', 't', '371', '81');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('294', '18', 't', '371', '82');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('295', '17', 't', '371', '83');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('296', '17', 't', '371', '84');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('297', '20', 't', '371', '85');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('298', '20', 't', '371', '86');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('299', '20', 't', '371', '87');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('300', '17', 't', '193', '73');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('301', '18', 't', '193', '74');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('302', '16', 't', '193', '75');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('303', '14', 't', '193', '76');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('304', '13', 't', '193', '77');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('305', '16', 't', '193', '78');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('306', '13', 't', '193', '79');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('307', '18', 't', '193', '80');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('308', '15', 't', '193', '81');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('309', '17', 't', '193', '82');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('310', '15', 't', '193', '83');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('311', '17', 't', '193', '84');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('312', '15', 't', '193', '85');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('313', '20', 't', '193', '86');
INSERT INTO public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") VALUES ('314', '17', 't', '193', '87');



--
-- Data for Name: Ciudad; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Ciudad" ("Id_ciudad", "Id_parroquia", nombre_ciudad) (INSERT statements)



--
-- Data for Name: Competencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Competencia" ("Id_competencia", nombre_competencia, description, "Id_materia") (INSERT statements)



--
-- Data for Name: Detalles_Reporte; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Detalles_Reporte" ("Id_detalles_reporte", detalles) (INSERT statements)



--
-- Data for Name: Dia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Dia" ("Id_dia", nombre_dia) (INSERT statements)



--
-- Data for Name: Direccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Direccion" ("Id_direccion", "Id_ciudad", nombre_direccion) (INSERT statements)



--
-- Data for Name: Escuela_Regular; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Escuela_Regular" ("Id_escuela", nombre_escuela) (INSERT statements)



--
-- Data for Name: Especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Especialidad" ("Id_especialidad", nombre_especialidad, descripcion, area, activo, creado_en) (INSERT statements)
INSERT INTO public."Especialidad" ("Id_especialidad", nombre_especialidad, descripcion, area, activo, creado_en) VALUES ('7', 'Danza Clásica', 'Formación especializada en técnica clásica académica y repertorio.', 'Clásica', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Especialidad" ("Id_especialidad", nombre_especialidad, descripcion, area, activo, creado_en) VALUES ('8', 'Danza Tradicional', 'Formación especializada en bailes tradicionales venezolanos, latinoamericanos y cultura popular.', 'Tradicional', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Especialidad" ("Id_especialidad", nombre_especialidad, descripcion, area, activo, creado_en) VALUES ('9', 'Danza Contemporánea', 'Formación especializada en técnicas contemporáneas, expresión corporal y composición.', 'Contemporánea', 't', '2026-08-26 03:08:57.769491');



--
-- Data for Name: Estado; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Estado" ("Id_estado", "Id_pais", nombre_estado) (INSERT statements)



--
-- Data for Name: Estructura_Evaluacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") (INSERT statements)
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('1', '1', '100', '1', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('2', '1', '100', '2', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('3', '1', '100', '3', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('4', '1', '100', '4', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('5', '1', '100', '5', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('6', '1', '100', '6', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('7', '1', '100', '7', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('8', '1', '100', '8', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('9', '1', '100', '9', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('10', '1', '100', '10', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('11', '1', '100', '11', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('12', '1', '100', '12', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('13', '1', '100', '13', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('14', '1', '100', '14', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('15', '1', '100', '15', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('16', '1', '100', '16', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('17', '1', '100', '17', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('18', '1', '100', '18', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('19', '1', '100', '19', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('20', '1', '100', '20', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('21', '1', '100', '21', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('22', '1', '100', '22', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('23', '1', '100', '23', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('24', '1', '100', '24', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('25', '1', '100', '25', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('26', '1', '100', '26', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('27', '1', '100', '27', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('28', '1', '100', '28', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('29', '1', '100', '29', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('30', '1', '100', '30', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('31', '1', '100', '31', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('32', '1', '100', '32', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('33', '1', '100', '33', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('34', '1', '100', '34', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('35', '1', '100', '35', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('36', '1', '100', '36', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('37', '1', '100', '37', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('38', '1', '100', '38', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('39', '1', '100', '39', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('40', '1', '100', '40', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('41', '1', '100', '41', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('42', '1', '100', '42', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('43', '1', '100', '43', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('44', '1', '100', '44', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('45', '1', '100', '45', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('46', '1', '100', '46', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('47', '1', '100', '47', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('48', '1', '100', '48', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('49', '1', '100', '49', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('50', '1', '100', '50', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('51', '1', '100', '51', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('52', '1', '100', '52', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('53', '1', '100', '53', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('54', '1', '100', '54', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('55', '1', '100', '55', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('56', '1', '100', '56', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('57', '1', '100', '57', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('58', '1', '100', '58', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('59', '1', '100', '59', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('60', '1', '100', '60', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('61', '1', '100', '61', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('62', '1', '100', '62', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('63', '1', '100', '63', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('64', '1', '100', '64', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('65', '1', '100', '65', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('66', '1', '100', '66', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('67', '1', '100', '67', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('68', '1', '100', '68', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('69', '1', '100', '69', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('70', '1', '100', '70', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('71', '1', '100', '71', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('72', '1', '100', '72', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('73', '1', '100', '73', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('74', '1', '100', '74', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('75', '1', '100', '75', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('76', '1', '100', '76', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('77', '1', '100', '77', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('78', '1', '100', '78', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('79', '1', '100', '79', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('80', '1', '100', '80', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('81', '1', '100', '81', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('82', '1', '100', '82', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('83', '1', '100', '83', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('84', '1', '100', '84', '2', '6');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('85', '1', '100', '85', '2', '4');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('86', '1', '100', '86', '2', '5');
INSERT INTO public."Estructura_Evaluacion" ("Id_estructura_evaluacion", numero_evaluacion, porcentaje_peso, "Id_seccion", "Id_tipo_evaluacion", "Id_lapso") VALUES ('87', '1', '100', '87', '2', '6');



--
-- Data for Name: Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") (INSERT statements)
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('570', 'ZOE JOHENNY', 'ARIAS VIVAS', 'EST-ACTA-7723', '2010-01-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('105', 'ADEL CAROLINA', 'ESCALANTE GALLO', 'EST-1001', '2017-09-20', 'Femenino', 'f', NULL, '25', NULL, NULL, '67', '105');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('106', 'ADRIÁN MOISES', 'RAMÍREZ RIVERA', 'EST-1002', '2006-02-15', 'Femenino', 'f', NULL, '10', NULL, NULL, '68', '106');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('107', 'ADRIANA MASSIEL', 'MONTILVA BECERRA', 'EST-1003', '2013-05-28', 'Femenino', 'f', NULL, '8', NULL, NULL, '69', '107');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('108', 'ADRIANA STEFANÍA', 'SUAREZ SANGUINO', 'EST-1004', '2011-07-05', 'Femenino', 'f', NULL, '9', NULL, NULL, '70', '108');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('109', 'ADRIANA STEFANÍA', 'SUAREZ SANGUINO', 'EST-1005', '2011-07-05', 'Femenino', 'f', NULL, '10', NULL, NULL, '70', '109');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('110', 'ADRIANA VALENTINA', 'ESCALANTE RAMÍREZ', 'EST-1006', '2016-06-03', 'Femenino', 'f', NULL, '6', NULL, NULL, '71', '110');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('111', 'ADRIANA VICTORIA', 'HERNÁNDEZ HERNÁNDEZ', 'EST-1007', '2017-03-22', 'Femenino', 'f', NULL, '25', NULL, NULL, '72', '111');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('112', 'AIMEE SOFIA', 'BECERRA PRIETO', 'EST-1008', '2014-07-21', 'Femenino', 'f', NULL, '8', NULL, NULL, '73', '112');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('113', 'AIMEE SOFIA', 'BECERRA PRIETO', 'EST-1009', '2014-07-21', 'Femenino', 'f', NULL, '7', NULL, NULL, '74', '113');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('114', 'ALEEZA VALENTINA', 'CAMPEROS RODRIGUEZ', 'EST-1010', '2008-10-17', 'Femenino', 'f', NULL, '14', NULL, NULL, '74', '114');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('115', 'ALEEZA VALENTINA', 'CAMPEROS RODRIGUEZ', 'EST-1011', '2008-10-17', 'Femenino', 'f', NULL, '13', NULL, NULL, '74', '115');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('116', 'ALEEZA VALENTINA', 'CAMPEROS RODRIGUEZ', 'EST-1012', '2008-10-17', 'Femenino', 'f', NULL, '12', NULL, NULL, '75', '116');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('117', 'ALICIA NATHALY', 'SARRIA GARCIA', 'EST-1013', '2013-06-11', 'Femenino', 'f', NULL, '25', NULL, NULL, '76', '117');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('118', 'ALLISON NATHALI', 'AMAYA RAMIREZ', 'EST-1014', '2011-07-31', 'Femenino', 'f', NULL, NULL, NULL, NULL, '76', '118');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('119', 'ALLISON NATHALÍ', 'AMAYA RAMÍREZ', 'EST-1015', '2011-07-31', 'Femenino', 'f', NULL, '9', NULL, NULL, '76', '119');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('120', 'ALLISON NATHALÍ', 'AMAYA RAMÍREZ', 'EST-1016', '2011-07-31', 'Femenino', 'f', NULL, '10', NULL, NULL, '77', '120');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('121', 'ALLISON SOPHIA', 'CARRERO PULIDO', 'EST-1017', '2013-07-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '77', '121');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('122', 'ALLISON SOPHIA', 'CARRERO PULIDO', 'EST-1018', '2013-07-01', 'Femenino', 'f', NULL, '8', NULL, NULL, '77', '122');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('123', 'ALLISON SOPHIA', 'CARRERO PULIDO', 'EST-1019', '2013-07-01', 'Femenino', 'f', NULL, '8', NULL, NULL, '78', '123');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('124', 'ALLISON SOPHIA', 'CARRERO PULIDO', 'EST-1020', '2013-07-01', 'Femenino', 'f', NULL, '8', NULL, NULL, '79', '124');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('125', 'ALONDRA DE LOS ANGELES', 'ACOSTA NAVA', 'EST-1021', '2006-06-23', 'Femenino', 'f', NULL, '21', NULL, NULL, '79', '125');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('126', 'ALONDRA DE LOS ANGELES', 'ACOSTA NAVA', 'EST-1022', '2006-06-23', 'Femenino', 'f', NULL, '21', NULL, NULL, '80', '126');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('127', 'ALONDRA DE LOS ANGELES', 'ACOSTA NAVA', 'EST-1023', '2006-06-23', 'Femenino', 'f', NULL, NULL, NULL, NULL, '81', '127');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('128', 'ALONDRA SOFIA', 'DAVILA BECERRA', 'EST-1024', '2013-06-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '82', '128');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('129', 'ALVRANNY SAHIELA', 'TARAZONA COLMENARES', 'EST-1025', '2017-06-25', 'Femenino', 'f', NULL, '25', NULL, NULL, '83', '129');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('130', 'AMANDITH GABRIELA', 'DURÁN RUÍZ', 'EST-1026', '2004-08-12', 'Femenino', 'f', NULL, '22', NULL, NULL, '84', '130');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('131', 'AMBAR LISETH', 'MOLINA CAÑAS', 'EST-1027', '2016-02-12', 'Femenino', 'f', NULL, '6', NULL, NULL, '85', '131');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('132', 'AMBAR LISETH', 'MOLINA CAÑAS', 'EST-1028', '2016-02-12', 'Femenino', 'f', NULL, '6', NULL, NULL, '86', '132');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('133', 'AMBAR MANUELA', 'BORRERO PERNIA', 'EST-1029', '2012-08-30', 'Femenino', 'f', NULL, '7', NULL, NULL, '87', '133');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('134', 'AMY ANTONELLA', 'ALVARADO RUIZ', 'EST-1030', '2013-06-07', 'Femenino', 'f', NULL, '9', NULL, NULL, '87', '134');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('135', 'AMY ANTONELLA', 'ALVARADO RUIZ', 'EST-1031', '2013-06-07', 'Femenino', 'f', NULL, '7', NULL, NULL, '88', '135');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('136', 'ANA ISABELLA', 'PINEDA ESCALANTE', 'EST-1032', '2015-06-29', 'Femenino', 'f', NULL, '6', NULL, NULL, '88', '136');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('137', 'ANA ISABELLA', 'PINEDA ESCALANTE', 'EST-1033', '2015-06-29', 'Femenino', 'f', NULL, '7', NULL, NULL, '89', '137');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('138', 'ANDREA ALEJANDRA', 'BARRIOS VIVAS', 'EST-1034', '2002-06-01', 'Femenino', 'f', NULL, '22', NULL, NULL, '90', '138');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('139', 'ANDREA DANIELA', 'VIVAS CARRIEDO', 'EST-1035', '2005-08-30', 'Femenino', 'f', NULL, '16', NULL, NULL, '90', '139');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('140', 'ANDREA DANIELA', 'VIVAS CARRIEDO', 'EST-1036', '2005-08-30', 'Femenino', 'f', NULL, '17', NULL, NULL, '91', '140');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('141', 'ANDRY KATIUSCA', 'GARCIA RAMIREZ', 'EST-1037', '2009-07-08', 'Femenino', 'f', NULL, '20', NULL, NULL, '91', '141');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('142', 'ANDRY KATIUSKA', 'GARCIA RAMIREZ', 'EST-1038', '2009-07-08', 'Femenino', 'f', NULL, '20', NULL, NULL, '92', '142');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('143', 'ANELEY MONTSERRAT', 'NAVARRO CONTRAMAESTRE', 'EST-1039', '2015-08-19', 'Femenino', 'f', NULL, '25', NULL, NULL, '92', '143');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('144', 'ANELEY MONTSERRAT', 'NAVARRO CONTRAMAESTRE', 'EST-1040', '2015-08-19', 'Femenino', 'f', NULL, '7', NULL, NULL, '93', '144');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('145', 'ANGELA JISBERLY', 'MERCHAN JAIMES', 'EST-1041', '2009-06-24', 'Femenino', 'f', NULL, '9', NULL, NULL, '94', '145');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('146', 'ANGELA STEFANIA', 'KYRIMLKOGLOU RAMIREZ', 'EST-1042', '2007-10-25', 'Femenino', 'f', NULL, '22', NULL, NULL, '95', '146');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('147', 'ANGÉLICA NATHALY', 'PEREZ QUIROZ', 'EST-1043', '2006-04-04', 'Femenino', 'f', NULL, '20', NULL, NULL, '95', '147');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('148', 'ANGÉLICA NATHALY', 'PÉREZ QUIROZ', 'EST-1044', '2006-04-04', 'Femenino', 'f', NULL, '22', NULL, NULL, '96', '148');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('149', 'ANGELINA GISSEL', 'ALTUVE GELVEZ', 'EST-1045', '2006-06-20', 'Femenino', 'f', NULL, '14', NULL, NULL, '97', '149');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('150', 'ANTHONELLA', 'DEPABLOS VIVAS', 'EST-1046', '2013-02-19', 'Femenino', 'f', NULL, '7', NULL, NULL, '98', '150');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('151', 'ANTONELLA NICOLL', 'MEDINA FERNANDEZ', 'EST-1047', '2009-07-10', 'Femenino', 'f', NULL, '20', NULL, NULL, '98', '151');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('152', 'ANTONELLA NICOLL', 'MEDINA FERNANDEZ', 'EST-1048', '2009-07-10', 'Femenino', 'f', NULL, NULL, NULL, NULL, '99', '152');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('153', 'ANTONELLA YALIMAR', 'ANDRADE RICO', 'EST-1049', '2013-05-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '99', '153');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('154', 'ANTONELLA YALIMAR', 'ANDRADE RICO', 'EST-1050', '2013-05-04', 'Femenino', 'f', NULL, '9', NULL, NULL, '99', '154');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('155', 'ANTONELLA YALIMAR', 'ANDRADE RICO', 'EST-1051', '2013-05-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '99', '155');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('156', 'ANTONELLA YALIMAR', 'ANDRADE RICO', 'EST-1052', '2013-05-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '99', '156');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('157', 'ANTONELLA YALIMAR', 'ANDRADE RICO', 'EST-1053', '2013-05-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '100', '157');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('158', 'ANYELA MONTSERRAT', 'COLMENARES DIAZ', 'EST-1054', '2015-05-15', 'Femenino', 'f', NULL, '7', NULL, NULL, '101', '158');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('159', 'ANYELY CAMILA', 'ZAMBRANO RAMIREZ', 'EST-1055', '2015-11-07', 'Femenino', 'f', NULL, '6', NULL, NULL, '102', '159');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('160', 'ARANZA GIULIANNA', 'CONTRERAS RODRIGUEZ', 'EST-1056', '2016-08-04', 'Femenino', 'f', NULL, '25', NULL, NULL, '103', '160');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('161', 'ARIADNA ISABELLA', 'ROJAS RANGEL', 'EST-1057', '2010-12-19', 'Femenino', 'f', NULL, '10', NULL, NULL, '103', '161');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('162', 'ARIADNA ISABELLA', 'ROJAS RANGEL', 'EST-1058', '2010-12-19', 'Femenino', 'f', NULL, NULL, NULL, NULL, '103', '162');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('163', 'ARIADNA ISABELLA', 'ROJAS RANGEL', 'EST-1059', '2010-12-19', 'Femenino', 'f', NULL, '9', NULL, NULL, '103', '163');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('164', 'ARIADNA ISABELLA', 'ROJAS RANGEL', 'EST-1060', '2010-12-19', 'Femenino', 'f', NULL, '9', NULL, NULL, '76', '164');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('165', 'ARIANNA NICOLLE', 'AMAYA RAMÍREZ', 'EST-1061', '2008-02-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, '76', '165');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('166', 'ARIANNA NICOLLE', 'AMAYA RAMÍREZ', 'EST-1062', '2008-02-01', 'Femenino', 'f', NULL, '17', NULL, NULL, '76', '166');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('167', 'ARIANNA NICOLLE', 'AMAYA RAMIREZ', 'EST-1063', '2010-01-01', 'Femenino', 'f', NULL, '18', NULL, NULL, '104', '167');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('168', 'ARIATNA GIANELLA', 'BELTRAN CONTRERAS', 'EST-1064', '2013-08-08', 'Femenino', 'f', NULL, '7', NULL, NULL, '105', '168');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('169', 'ARIATNA GIANELLA', 'BELTRAN CONTRERAS', 'EST-1065', '2013-08-09', 'Femenino', 'f', NULL, '8', NULL, NULL, '105', '169');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('170', 'ARIATNA GIANELLA', 'BELTRAN CONTRERAS', 'EST-1066', '2013-08-09', 'Femenino', 'f', NULL, '6', NULL, NULL, '106', '170');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('171', 'ASHLEY DORIAMNY', 'GONZALEZ GOMEZ', 'EST-1067', '2010-06-18', 'Femenino', 'f', NULL, NULL, NULL, NULL, '107', '171');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('172', 'ASHLEY YADELSI', 'MARTINEZ CRISPIN', 'EST-1068', '2016-02-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '107', '172');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('173', 'ASHLEY YADELSI', 'MARTINEZ CRISPIN', 'EST-1069', '2016-02-04', 'Femenino', 'f', NULL, '25', NULL, NULL, '108', '173');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('174', 'ASHLY DAVIANNY', 'ROMERO BECERRA', 'EST-1070', '2013-08-29', 'Femenino', 'f', NULL, '7', NULL, NULL, '109', '174');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('175', 'ASHLYN STEISSY', 'CANO ZAMBRANO', 'EST-1071', '2009-09-20', 'Femenino', 'f', NULL, '8', NULL, NULL, '110', '175');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('176', 'ASTRID ORIANA', 'JAIMES VILLAMIZAR', 'EST-1072', '2005-03-08', 'Femenino', 'f', NULL, '21', NULL, NULL, '111', '176');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('177', 'AURA MICHELL', 'MORA CHACON', 'EST-1073', '2008-04-02', 'Femenino', 'f', NULL, '18', NULL, NULL, '112', '177');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('178', 'AVRIL SOPHIA', 'RAY HERNÁNDEZ', 'EST-1074', '2014-05-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '112', '178');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('179', 'AVRIL SOPHIA', 'RAY HERNANDEZ', 'EST-1075', '2014-05-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '113', '179');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('180', 'AYLISH JOSELYN', 'MORALES NEIRA', 'EST-1076', '2013-09-29', 'Femenino', 'f', NULL, '8', NULL, NULL, '113', '180');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('181', 'AYLISH JOSELYN', 'MORALES NEIRA', 'EST-1077', '2013-12-29', 'Femenino', 'f', NULL, '7', NULL, NULL, '114', '181');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('182', 'AYMARA SINAHI', 'CACERES LEAL', 'EST-1078', '2014-04-10', 'Femenino', 'f', NULL, '7', NULL, NULL, '114', '182');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('183', 'AYMARA SINAHI', 'CÁCERES LEAL', 'EST-1079', '2014-04-10', 'Femenino', 'f', NULL, '8', NULL, NULL, '115', '183');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('184', 'BRIHANA CAMILA', 'ORTIZ MONTAÑEZ', 'EST-1080', '2011-02-23', 'Femenino', 'f', NULL, '10', NULL, NULL, '115', '184');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('185', 'BRINYELI MANOSALVA', 'MANOSALVA RODRIGUEZ', 'EST-1081', '2006-01-27', 'Femenino', 'f', NULL, '18', NULL, NULL, '116', '185');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('186', 'BRINYELI PAOLA', 'MANOSALVA RODRÍGUEZ', 'EST-1082', '2006-01-27', 'Femenino', 'f', NULL, '16', NULL, NULL, '117', '186');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('187', 'BRITANY ANGELI', 'CONTRERAS SILVA', 'EST-1083', '2005-12-28', 'Femenino', 'f', NULL, '22', NULL, NULL, '117', '187');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('188', 'BRITHANNY JOSSIE', 'DELGADO CONTRERAS', 'EST-1084', '2012-02-20', 'Femenino', 'f', NULL, '7', NULL, NULL, '118', '188');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('189', 'BRITHANNY JOSSIE', 'DELGADO CONTRERAS', 'EST-1085', '2012-02-20', 'Femenino', 'f', NULL, '9', NULL, NULL, '119', '189');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('190', 'BRITHANY ALEXANDRA', 'ARELLANO VIVAS', 'EST-1086', '2012-05-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '120', '190');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('191', 'BRITNY ALEJANDRA', 'HERNANDEZ CORREDOR', 'EST-1087', '2015-02-20', 'Femenino', 'f', NULL, '25', NULL, NULL, '121', '191');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('192', 'CAMILA ALEJANDRA', 'BERNAL TORRES', 'EST-1088', '2013-05-31', 'Femenino', 'f', NULL, '9', NULL, NULL, '121', '192');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('193', 'CAMILA ANDREA', 'QUEVEDO REVERÓN', 'EST-1089', '2010-02-07', 'Femenino', 'f', NULL, NULL, NULL, NULL, '122', '193');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('194', 'CAMILA ANDREA', 'QUEVEDO REVERÓN', 'EST-1090', '2010-02-07', 'Femenino', 'f', NULL, '12', NULL, NULL, '123', '194');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('195', 'CAMILA DE LOS ANGELES', 'MORA GUERRERO', 'EST-1091', '2022-12-27', 'Femenino', 'f', NULL, '9', NULL, NULL, '123', '195');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('196', 'CAMILA DEL VALLE', 'SAAVEDRA CAMPOS', 'EST-1092', '2012-04-14', 'Femenino', 'f', NULL, '6', NULL, NULL, '124', '196');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('197', 'CAMILA DEL VALLE', 'SAAVEDRA CAMPOS', 'EST-1093', '2012-04-14', 'Femenino', 'f', NULL, '6', NULL, NULL, '124', '197');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('198', 'CAMILA NAIOBY', 'VIDAL OLIVARES', 'EST-1094', '2008-12-08', 'Femenino', 'f', NULL, '13', NULL, NULL, '124', '198');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('199', 'CAMILA NAIOBY', 'VIDAL OLIVARES', 'EST-1095', '2008-12-08', 'Femenino', 'f', NULL, '12', NULL, NULL, '125', '199');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('200', 'CAMILA NAIOBY', 'VIDAL OLIVARES', 'EST-1096', '2008-12-08', 'Femenino', 'f', NULL, '13', NULL, NULL, '126', '200');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('201', 'CAMILA SARAI', 'DIAZ CONTRERAS', 'EST-1097', '2014-01-20', 'Femenino', 'f', NULL, '7', NULL, NULL, '127', '201');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('202', 'CAMILA SARAI', 'DIAZ CONTRERAS', 'EST-1098', '2014-01-20', 'Femenino', 'f', NULL, '8', NULL, NULL, '127', '202');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('203', 'CAMILA VALENTINA', 'DAVILA SANCHEZ', 'EST-1099', '2011-06-06', 'Femenino', 'f', NULL, NULL, NULL, NULL, '127', '203');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('204', 'CAMILA VALENTINA', 'DAVILA SANCHEZ', 'EST-1100', '2011-06-06', 'Femenino', 'f', NULL, NULL, NULL, NULL, '127', '204');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('205', 'CAMILA VALENTINA', 'DAVILA SANCHEZ', 'EST-1101', '2011-06-06', 'Femenino', 'f', NULL, NULL, NULL, NULL, '127', '205');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('206', 'CAMILA VALENTINA', 'DAVILA SANCHEZ', 'EST-1102', '2011-06-06', 'Femenino', 'f', NULL, '9', NULL, NULL, '128', '206');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('207', 'CAMILA VALENTINA', 'DAVILA SANCHEZ', 'EST-1103', '2011-06-06', 'Femenino', 'f', NULL, '10', NULL, NULL, '114', '207');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('208', 'CAMILA VICTORIA', 'CHACON MERCHAN', 'EST-1104', '2014-09-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '114', '208');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('209', 'CAMILY AMARANTA', 'CACERES LEAL', 'EST-1105', '2004-10-11', 'Femenino', 'f', NULL, '13', NULL, NULL, '129', '209');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('210', 'CAMILY AMARANTA', 'CACERES LEAL', 'EST-1106', '2004-10-11', 'Femenino', 'f', NULL, '14', NULL, NULL, '130', '210');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('211', 'CARLA BELÉN', 'MONGES GONZÁLEZ', 'EST-1107', '2005-03-09', 'Femenino', 'f', NULL, '22', NULL, NULL, '130', '211');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('212', 'CARLY DANIELA', 'FERREIRA QUINAYAS', 'EST-1108', '2015-04-23', 'Femenino', 'f', NULL, '6', NULL, NULL, '131', '212');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('213', 'CARLY DANIELA', 'FERREIRA QUINAYAS', 'EST-1109', '2015-04-15', 'Femenino', 'f', NULL, '6', NULL, NULL, '132', '213');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('214', 'CAROLINE VALENTINA', 'TORRES ROJAS', 'EST-1110', '2013-01-27', 'Femenino', 'f', NULL, '9', NULL, NULL, '133', '214');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('215', 'CORDERO MONCADA', 'SOFIA VALERIA', 'EST-1111', '2013-07-19', 'Femenino', 'f', NULL, '7', NULL, NULL, '134', '215');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('216', 'CRISTAL DAYLIN', 'CEGARRA PEÑA', 'EST-1112', '2016-09-02', 'Femenino', 'f', NULL, '25', NULL, NULL, '135', '216');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('217', 'DAIRYMAR ALEJANDRA', 'CONTRERAS DELGADO', 'EST-1113', '2014-02-07', 'Femenino', 'f', NULL, '7', NULL, NULL, '136', '217');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('218', 'DALIA ALEXANDRA', 'RIVERA ZAMBRANO', 'EST-1114', '2003-03-09', 'Femenino', 'f', NULL, '18', NULL, NULL, '137', '218');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('219', 'DANIELA ALEXANDRA', 'MONTAÑA CONTRERAS', 'EST-1115', '2016-02-21', 'Femenino', 'f', NULL, '25', NULL, NULL, '138', '219');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('220', 'DANIELA VALENTINA', 'ZAMBRANO SANGUINO', 'EST-1116', '2014-07-21', 'Femenino', 'f', NULL, '7', NULL, NULL, '138', '220');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('221', 'DANIELA VALENTINA', 'MONCADA RAMIREZ', 'EST-1117', '2009-05-22', 'Femenino', 'f', NULL, '20', NULL, NULL, '139', '221');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('222', 'DANIELA VALENTINA', 'MONCADA RAMIREZ', 'EST-1118', '2009-05-22', 'Femenino', 'f', NULL, '10', NULL, NULL, '140', '222');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('223', 'DANNA ALEJANDRA', 'MORALES CHACON', 'EST-1119', '2009-06-12', 'Femenino', 'f', NULL, '8', NULL, NULL, '141', '223');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('224', 'DANNA GHELENA', 'CHÁVEZ HERNÁNDEZ', 'EST-1120', '2021-05-25', 'Femenino', 'f', NULL, '6', NULL, NULL, '142', '224');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('225', 'DANNA GHELENA', 'CHAVEZ HERNADEZ', 'EST-1121', '2015-05-25', 'Femenino', 'f', NULL, '7', NULL, NULL, '143', '225');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('226', 'DANNA ISABELLA', 'CHACÓN CONTRERAS', 'EST-1122', '2015-12-28', 'Femenino', 'f', NULL, '6', NULL, NULL, '144', '226');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('227', 'DANNA SOFIA', 'JIMÉNEZ JIMÉNEZ', 'EST-1123', '2010-09-23', 'Femenino', 'f', NULL, '9', NULL, NULL, '144', '227');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('228', 'DARIANA CAMILA', 'BRITO LAGUADO', 'EST-1124', '2012-07-06', 'Femenino', 'f', NULL, '8', NULL, NULL, '145', '228');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('229', 'DARIANA CAMILA', 'BRITO LAGUADO', 'EST-1125', '2012-07-06', 'Femenino', 'f', NULL, '8', NULL, NULL, '145', '229');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('230', 'DARIANA VALENTINA', 'CAMPOS RAMIREZ', 'EST-1126', '2006-07-15', 'Femenino', 'f', NULL, '22', NULL, NULL, '146', '230');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('231', 'DARIANA VALENTINA', 'CAMPOS RAMIREZ', 'EST-1127', '2006-07-15', 'Femenino', 'f', NULL, '22', NULL, NULL, '146', '231');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('232', 'DARY', 'DELGADO OCANA', 'EST-1128', '2011-03-18', 'Femenino', 'f', NULL, '9', NULL, NULL, '146', '232');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('233', 'DARY', 'OCAÑA DELGADO', 'EST-1129', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '147', '233');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('234', 'DARY', 'OCANA DELGADO', 'EST-1130', '2011-03-18', 'Femenino', 'f', NULL, NULL, NULL, NULL, '147', '234');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('235', 'DARYANGEL VICTORIA', 'CHACÓN CONTRERAS', 'EST-1131', '2010-10-08', 'Femenino', 'f', NULL, '10', NULL, NULL, '148', '235');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('236', 'DARYANGEL VICTORIA', 'CHACON CONTRERAS', 'EST-1132', '2010-10-08', 'Femenino', 'f', NULL, '9', NULL, NULL, '149', '236');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('237', 'DAVIELYS CAMILA', 'VIVAS TORRES', 'EST-1133', '2017-05-05', 'Femenino', 'f', NULL, '25', NULL, NULL, '150', '237');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('238', 'DEILED ORIANA', 'RICO RUIZ', 'EST-1134', '2008-12-22', 'Femenino', 'f', NULL, '20', NULL, NULL, '150', '238');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('239', 'DENNIS DANIELA', 'BARÓN LUM', 'EST-1135', '2005-01-12', 'Femenino', 'f', NULL, '14', NULL, NULL, '151', '239');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('240', 'DENNIS DANIELA', 'BARON LUM', 'EST-1136', '2005-02-12', 'Femenino', 'f', NULL, '14', NULL, NULL, '151', '240');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('241', 'EILYN SOPHIA', 'MEZA OSTOS', 'EST-1137', '2013-11-27', 'Femenino', 'f', NULL, '6', NULL, NULL, '152', '241');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('242', 'EILYN SOPHIA', 'MEZA OSTOS', 'EST-1138', '2013-11-27', 'Femenino', 'f', NULL, '7', NULL, NULL, '153', '242');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('243', 'EILYN SOPHIA', 'MEZA OSTOS', 'EST-1139', '2013-11-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '154', '243');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('244', 'EIMY JULLIETH', 'CONTRERAS COLMENARES', 'EST-1140', '2011-10-27', 'Femenino', 'f', NULL, NULL, NULL, NULL, '155', '244');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('245', 'ELIANA ANGELINE', 'SANCHEZ MANRIQUE', 'EST-1141', '2003-12-30', 'Femenino', 'f', NULL, '18', NULL, NULL, '155', '245');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('246', 'EMILY ALICEC', 'MORA GUERRERO', 'EST-1142', '2012-02-23', 'Femenino', 'f', NULL, '10', NULL, NULL, '155', '246');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('247', 'EMILY ALICEC', 'MORA GUERRERO', 'EST-1143', '2012-02-23', 'Femenino', 'f', NULL, '10', NULL, NULL, '156', '247');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('248', 'EMILY ALICEC', 'MORA GUERRERO', 'EST-1144', '2012-02-23', 'Femenino', 'f', NULL, '10', NULL, NULL, '157', '248');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('249', 'EMILY MIRANDA', 'APONTE CHACON', 'EST-1145', '2016-12-07', 'Femenino', 'f', NULL, '25', NULL, NULL, '157', '249');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('468', 'NELIANA', 'PLATA BUITRAGO', 'EST-1364', '2011-10-29', 'Femenino', 'f', NULL, '8', NULL, NULL, '151', '468');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('250', 'EMILY ORIANA', 'CAMARGO PABLOS', 'EST-1146', '2006-08-28', 'Femenino', 'f', NULL, '16', NULL, NULL, '158', '250');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('251', 'EMILY ORIANA', 'CAMARGO PABLOS', 'EST-1147', '2006-08-28', 'Femenino', 'f', NULL, '18', NULL, NULL, '159', '251');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('252', 'ENMANUEL DIONISIO SALVATORE', 'PÉREZ DELGADO', 'EST-1148', '2012-10-05', 'Femenino', 'f', NULL, '7', NULL, NULL, '160', '252');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('253', 'ERIKA FABIANA', 'GÓMEZ RÍOS', 'EST-1149', '2004-08-17', 'Femenino', 'f', NULL, '22', NULL, NULL, '160', '253');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('254', 'ESTEFANY NATALY', 'GOMEZ CHACON', 'EST-1150', '2009-02-16', 'Femenino', 'f', NULL, '16', NULL, NULL, '161', '254');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('255', 'ESTEFANY NATALY', 'GOMEZ CHACON', 'EST-1151', '2009-01-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, '162', '255');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('256', 'ESTHER NAHOMY', 'CARRERO SIERRA', 'EST-1152', '2013-07-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '163', '256');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('257', 'ETNY DANIELA', 'DUQUE CASTRO', 'EST-1153', '2007-11-01', 'Femenino', 'f', NULL, '6', NULL, NULL, '164', '257');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('258', 'ETNY DANIELA', 'DUQUE CASTRO', 'EST-1154', '2007-11-01', 'Femenino', 'f', NULL, '21', NULL, NULL, '165', '258');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('259', 'EVA DEL VALLE', 'SALAS RODRIGUEZ', 'EST-1155', '2014-12-10', 'Femenino', 'f', NULL, '7', NULL, NULL, '165', '259');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('260', 'FABIANA MILENA', 'LEON GONZALEZ', 'EST-1156', '2006-05-09', 'Femenino', 'f', NULL, '14', NULL, NULL, '166', '260');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('261', 'FABIANA MILENA', 'LEON GONZÁLEZ', 'EST-1157', '2006-05-09', 'Femenino', 'f', NULL, '13', NULL, NULL, '167', '261');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('262', 'FABIOLA', 'CONTRERAS RAMÍREZ', 'EST-1158', '2012-07-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '168', '262');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('263', 'FIORELLA', 'GUERRERO LOPEZ', 'EST-1159', '2006-09-23', 'Femenino', 'f', NULL, '6', NULL, NULL, '169', '263');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('264', 'FIORELLA CAMILA', 'JUGO FREITES', 'EST-1160', '2013-12-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '168', '264');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('265', 'FIORELLA SOFIA', 'MÁRQUEZ GARCÍA', 'EST-1161', '2006-10-05', 'Femenino', 'f', NULL, '14', NULL, NULL, '170', '265');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('266', 'FLAVIA CORINA', 'JUGO FREITES', 'EST-1162', '2008-11-11', 'Femenino', 'f', NULL, '13', NULL, NULL, '170', '266');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('267', 'FLOR MARIANFEL', 'REY RANGEL', 'EST-1163', '2006-08-30', 'Femenino', 'f', NULL, '22', NULL, NULL, '171', '267');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('268', 'FLOR MARIANGEL', 'REY RANGEL', 'EST-1164', '2006-08-30', 'Femenino', 'f', NULL, '20', NULL, NULL, '172', '268');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('269', 'FRANCHESKA VICMARY', 'GALLO ZAMBRANO', 'EST-1165', '2014-10-03', 'Femenino', 'f', NULL, '7', NULL, NULL, '173', '269');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('270', 'FRANCIE GRISMAR', 'MONTAÑEZ VELAZCO', 'EST-1166', '2008-07-21', 'Femenino', 'f', NULL, '10', NULL, NULL, '174', '270');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('271', 'FRANCIÉ GRISMAR', 'MONTAÑEZ VELAZCO', 'EST-1167', '2008-07-21', 'Femenino', 'f', NULL, NULL, NULL, NULL, '175', '271');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('272', 'GABRIELA ALEJANDRA', 'ZAMBRANO URIBE', 'EST-1168', '2014-04-16', 'Femenino', 'f', NULL, '7', NULL, NULL, '176', '272');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('273', 'GABRIELA ALEXANDRA', 'ANDRADE RUMBOS', 'EST-1169', '2011-03-03', 'Femenino', 'f', NULL, NULL, NULL, NULL, '176', '273');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('274', 'GABRIELA SARAHI', 'RAMIREZ BALLESTEROS', 'EST-1170', '2014-08-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '176', '274');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('275', 'GABRIELA SARAHI', 'RAMIREZ BALLESTEROS', 'EST-1171', '2014-08-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '177', '275');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('276', 'GABRIELA SARAHI', 'RAMÍREZ BALLESTEROS', 'EST-1172', '2014-08-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '178', '276');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('277', 'GABRIELA VALENTINA', 'AMAYA CAMARAN', 'EST-1173', '2006-08-04', 'Femenino', 'f', NULL, '22', NULL, NULL, '177', '277');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('278', 'GABRIELA VALENTINA', 'VERA GUERRERO', 'EST-1174', '2014-09-04', 'Femenino', 'f', NULL, '25', NULL, NULL, '177', '278');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('279', 'GABRIELA VALENTINA', 'AMAYA CAMARAN', 'EST-1175', '2006-08-04', 'Femenino', 'f', NULL, '21', NULL, NULL, '105', '279');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('280', 'GABRIELA VALENTINA', 'AMAYA CAMARAN', 'EST-1176', '2006-08-04', 'Femenino', 'f', NULL, '21', NULL, NULL, '105', '280');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('281', 'GENESIS ADRIANA', 'BELTRAN CONTRERAS', 'EST-1177', '2005-01-03', 'Femenino', 'f', NULL, '12', NULL, NULL, '179', '281');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('282', 'GENESIS ADRIANA', 'BELTRAN CONTRERAS', 'EST-1178', '2005-01-03', 'Femenino', 'f', NULL, '25', NULL, NULL, '180', '282');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('283', 'GÉNESIS ALEJANDRA', 'ZAMBRANO POLANCO', 'EST-1179', '2013-10-20', 'Femenino', 'f', NULL, '8', NULL, NULL, '179', '283');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('284', 'GÉNESIS ALEJANDRA', 'SANCHEZ RICO', 'EST-1180', '2010-06-18', 'Femenino', 'f', NULL, NULL, NULL, NULL, '180', '284');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('285', 'GENESIS ALEJANDRA', 'POLANCO ZAMBRANO', 'EST-1181', '2010-10-20', 'Femenino', 'f', NULL, '10', NULL, NULL, '181', '285');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('286', 'GENESIS ALEJANDRA', 'SANCHEZ RICO', 'EST-1182', '2010-06-18', 'Femenino', 'f', NULL, '16', NULL, NULL, '182', '286');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('287', 'GENESIS ESTER', 'GARNICA VARGAS', 'EST-1183', '2016-02-23', 'Femenino', 'f', NULL, '6', NULL, NULL, '183', '287');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('288', 'GÉNESIS KAMILA', 'CASTRO CALDERÓN', 'EST-1184', '2009-02-09', 'Femenino', 'f', NULL, '9', NULL, NULL, '184', '288');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('289', 'GRACE MARIANGEL', 'OSTOS VILLAMIZAR', 'EST-1185', '2004-09-02', 'Femenino', 'f', NULL, '14', NULL, NULL, '184', '289');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('290', 'GRECIA VALERIA', 'BECERRA ESTEVES', 'EST-1186', '2014-01-16', 'Femenino', 'f', NULL, '7', NULL, NULL, '185', '290');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('291', 'GRECIA VALERIA', 'BECERRA ESTEVES', 'EST-1187', '2014-01-06', 'Femenino', 'f', NULL, '8', NULL, NULL, '185', '291');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('292', 'GREIMAR JOSMERLY', 'ROVIRA SANDOVAL', 'EST-1188', '2012-07-04', 'Femenino', 'f', NULL, '9', NULL, NULL, '185', '292');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('293', 'GREIMAR JOSMERLY', 'ROVIRA SANDOVAL', 'EST-1189', '2012-07-04', 'Femenino', 'f', NULL, '8', NULL, NULL, '186', '293');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('294', 'GREIMARJOSMERLY', 'ROVIRA SANDOVAL', 'EST-1190', '2012-07-04', 'Femenino', 'f', NULL, '10', NULL, NULL, '187', '294');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('295', 'HANIRY ISBELLA', 'USECHE MENDEZ', 'EST-1191', '2014-06-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '188', '295');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('296', 'HANNA JISET', 'DUQUE PRATO', 'EST-1192', '2002-10-04', 'Femenino', 'f', NULL, '18', NULL, NULL, '189', '296');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('297', 'HARIADNE RUBEILYS', 'LOSADA FUENTES', 'EST-1193', '2018-08-31', 'Femenino', 'f', NULL, '25', NULL, NULL, '190', '297');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('298', 'HASLETH NICKOLL', 'SANABRIA CARDENAS', 'EST-1194', '2010-01-20', 'Femenino', 'f', NULL, '10', NULL, NULL, '191', '298');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('299', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1195', '2009-01-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, '192', '299');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('300', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1196', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '193', '300');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('301', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1197', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '194', '301');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('302', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1198', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '195', '302');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('303', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1199', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '196', '303');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('304', 'HEIZEL FERNANDA', 'MONSALVE', 'EST-1200', '2010-01-01', 'Femenino', 'f', NULL, '10', NULL, NULL, '120', '304');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('305', 'HEIZEL FERNANDA', 'MONSALVE MORENO', 'EST-1201', '2010-10-28', 'Femenino', 'f', NULL, '16', NULL, NULL, '120', '305');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('306', 'HELEN VALENTINA', 'BERNAL TORRES', 'EST-1202', '2010-04-02', 'Femenino', 'f', NULL, '9', NULL, NULL, '197', '306');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('307', 'HELEN VALENTINA', 'BERNAL TORRES', 'EST-1203', '2010-04-02', 'Femenino', 'f', NULL, '10', NULL, NULL, '198', '307');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('308', 'HELENA SOFIA', 'ROJAS VILLAMIZAR', 'EST-1204', '2015-09-01', 'Femenino', 'f', NULL, '25', NULL, NULL, '199', '308');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('309', 'HELENA SOFIA', 'ROJAS VILLAMIZAR', 'EST-1205', '2015-09-01', 'Femenino', 'f', NULL, '6', NULL, NULL, '200', '309');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('310', 'HILARY ANARELLA', 'UZTARIS MOGOLLON', 'EST-1206', '2012-08-05', 'Femenino', 'f', NULL, '7', NULL, NULL, '201', '310');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('311', 'ISABELLA', 'AMAYA REY', 'EST-1207', '2014-05-11', 'Femenino', 'f', NULL, '8', NULL, NULL, '201', '311');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('312', 'ISABELLA ALESSANDRA', 'AVENDAÑO BLANCO', 'EST-1208', '2009-05-28', 'Femenino', 'f', NULL, '12', NULL, NULL, '202', '312');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('313', 'ISABELLA ALESSANDRA', 'AVENDAÑO BLANCO', 'EST-1209', '2009-05-28', 'Femenino', 'f', NULL, NULL, NULL, NULL, '203', '313');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('314', 'ISABELLA CARLEY', 'CASTAÑEDA RUEDA', 'EST-1210', '2016-05-13', 'Femenino', 'f', NULL, '25', NULL, NULL, '204', '314');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('315', 'ISABELLA NAOMI', 'GONZALEZ SALAS', 'EST-1211', '2015-12-09', 'Femenino', 'f', NULL, '7', NULL, NULL, '205', '315');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('316', 'ISABELLA SALOME', 'ESCOBAR DIAZ', 'EST-1212', '2015-05-23', 'Femenino', 'f', NULL, '7', NULL, NULL, '205', '316');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('317', 'ISABELLA VALENTINA', 'ONTIVEROS MOGROVEJO', 'EST-1213', '2014-06-18', 'Femenino', 'f', NULL, '7', NULL, NULL, '205', '317');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('318', 'ISABELLA VALENTINA', 'ONTIVEROS MOGROVEJO', 'EST-1214', '2014-06-18', 'Femenino', 'f', NULL, '25', NULL, NULL, '206', '318');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('319', 'ISABELLA VALENTINA', 'ONTIVEROS MOGROVEJO', 'EST-1215', '2014-06-18', 'Femenino', 'f', NULL, '8', NULL, NULL, '207', '319');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('320', 'ISNEY ANGELY', 'NOGUERA RAMIREZ', 'EST-1216', '2002-08-30', 'Femenino', 'f', NULL, '12', NULL, NULL, '208', '320');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('321', 'ISNEY ANYELI', 'NOGUERA RAMIRES', 'EST-1217', '2002-08-30', 'Femenino', 'f', NULL, '25', NULL, NULL, '209', '321');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('322', 'ITZEL SHARLOTT', 'CALDERON BERMUDEZ', 'EST-1218', '2018-06-13', 'Femenino', 'f', NULL, '25', NULL, NULL, '210', '322');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('323', 'IVANNA ANTONELLA', 'LACRUZ SANDOVAL', 'EST-1219', '2015-06-29', 'Femenino', 'f', NULL, '7', NULL, NULL, '210', '323');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('324', 'IVANNA LUCIA', 'PEREZ PLATA', 'EST-1220', '2013-04-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '211', '324');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('325', 'IVANNA LUCIA', 'PEREZ PLATA', 'EST-1221', '2013-04-01', 'Femenino', 'f', NULL, '8', NULL, NULL, '212', '325');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('326', 'JADE SAMIRA', 'RAMÍREZ DÍAZ', 'EST-1222', '2013-04-05', 'Femenino', 'f', NULL, '7', NULL, NULL, '212', '326');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('327', 'JADE YULIANA', 'ARIZA CARVAJAL', 'EST-1223', '2002-09-23', 'Femenino', 'f', NULL, '22', NULL, NULL, '213', '327');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('328', 'JADE YULIANA', 'ARIZA CARVAJAL', 'EST-1224', '2002-09-23', 'Femenino', 'f', NULL, '22', NULL, NULL, '213', '328');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('329', 'JADE YULIANA', 'ARIZA CARVAJAL', 'EST-1225', '2002-09-23', 'Femenino', 'f', NULL, '22', NULL, NULL, '213', '329');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('330', 'JAVIANA SOFIA', 'DAVILA MONTERO', 'EST-1226', '2011-05-27', 'Femenino', 'f', NULL, '10', NULL, NULL, '214', '330');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('331', 'JAVIANA SOFÍA', 'DÁVILA MONTERO', 'EST-1227', '2011-05-27', 'Femenino', 'f', NULL, NULL, NULL, NULL, '214', '331');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('332', 'JESSI GABRIELA', 'LUNA TRESPALACIOS', 'EST-1228', '2010-05-15', 'Femenino', 'f', NULL, '10', NULL, NULL, '214', '332');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('333', 'JESSI GABRIELA', 'LUNA TRESPALACIOS', 'EST-1229', '2010-05-15', 'Femenino', 'f', NULL, '7', NULL, NULL, '215', '333');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('334', 'JESSI GABRIELA', 'LUNA TRESPALACIOS', 'EST-1230', '2010-05-15', 'Femenino', 'f', NULL, '7', NULL, NULL, '215', '334');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('335', 'JIMENA GABRIELA', 'CANAL CHACON', 'EST-1231', '2014-09-11', 'Femenino', 'f', NULL, '25', NULL, NULL, '216', '335');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('336', 'JIMENA GABRIELA', 'CANAL CHACON', 'EST-1232', '2014-09-11', 'Femenino', 'f', NULL, '25', NULL, NULL, '217', '336');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('337', 'JIMENA GABRIELA', 'CANAL CHACON', 'EST-1233', '2014-09-11', 'Femenino', 'f', NULL, '25', NULL, NULL, '217', '337');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('338', 'JIMENA ISABEL', 'COLMENARES JIMENEZ', 'EST-1234', '2013-03-23', 'Femenino', 'f', NULL, '9', NULL, NULL, '217', '338');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('339', 'JIMENA ISABEL', 'COLMENARES JIMÉNEZ', 'EST-1235', '2013-03-23', 'Femenino', 'f', NULL, '9', NULL, NULL, '218', '339');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('340', 'JULIANA PAOLA', 'PEREZ LÓPEZ', 'EST-1236', '2006-05-18', 'Femenino', 'f', NULL, '18', NULL, NULL, '219', '340');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('341', 'JULIETH FABIANA', 'FORERO CARRILLO', 'EST-1237', '2003-09-16', 'Femenino', 'f', NULL, '10', NULL, NULL, '219', '341');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('342', 'JULIETH FABIANA', 'FORERO CARRILLO', 'EST-1238', '2003-09-16', 'Femenino', 'f', NULL, '10', NULL, NULL, '220', '342');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('343', 'JULIETH FABIANA', 'FORERO CARRILLO', 'EST-1239', '2003-09-16', 'Femenino', 'f', NULL, '10', NULL, NULL, '220', '343');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('344', 'JULIETH FERNANDA', 'BELEÑO SANDOVAL', 'EST-1240', '2003-10-13', 'Femenino', 'f', NULL, '22', NULL, NULL, '221', '344');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('345', 'KELLY ALEXANDRA', 'PEREZ MONTAÑEZ', 'EST-1241', '2003-04-01', 'Femenino', 'f', NULL, '14', NULL, NULL, '222', '345');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('346', 'KELLY ALEXANDRA', 'PEREZ MONTAÑEZ', 'EST-1242', '2003-04-01', 'Femenino', 'f', NULL, '14', NULL, NULL, '222', '346');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('347', 'KEREN NIKOLL', 'MUÑOZ ACEVEDO', 'EST-1243', '2012-05-08', 'Femenino', 'f', NULL, '7', NULL, NULL, '222', '347');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('348', 'KEREN NIKOLL', 'MUÑOZ ACEVEDO', 'EST-1244', '2012-05-08', 'Femenino', 'f', NULL, '8', NULL, NULL, '223', '348');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('349', 'KRISMAR ARIADNA', 'SIERRA AVENDAÑO', 'EST-1245', '2006-02-25', 'Femenino', 'f', NULL, '22', NULL, NULL, '223', '349');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('350', 'KRISTEL CAMILA', 'SUAREZ VARGAS', 'EST-1246', '2013-07-12', 'Femenino', 'f', NULL, '7', NULL, NULL, '224', '350');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('351', 'KRISTEL CAMILA', 'SUÁREZ VARGAS', 'EST-1247', '2013-07-12', 'Femenino', 'f', NULL, '8', NULL, NULL, '225', '351');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('352', 'KRISTEL CAMILA', 'SUAREZ VARGAS', 'EST-1248', '2013-07-12', 'Femenino', 'f', NULL, '8', NULL, NULL, '226', '352');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('353', 'LAUREN SOFIA', 'RUIZ COLMENARES', 'EST-1249', '2007-03-19', 'Femenino', 'f', NULL, '22', NULL, NULL, '226', '353');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('354', 'LAUREN SOFIA', 'RUIZ COLMENARES', 'EST-1250', '2007-03-19', 'Femenino', 'f', NULL, '20', NULL, NULL, '227', '354');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('355', 'LILIA DEL CARMEN', 'CARRILLO RODRIGUEZ', 'EST-1251', '2016-06-08', 'Femenino', 'f', NULL, '6', NULL, NULL, '228', '355');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('356', 'LISDANI ISABELLA', 'CHACON MARQUEZ', 'EST-1252', '2014-12-17', 'Femenino', 'f', NULL, '6', NULL, NULL, '229', '356');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('357', 'LISSETH ISABELLA', 'MENDOZA SALAZAR', 'EST-1253', '2011-11-09', 'Femenino', 'f', NULL, '25', NULL, NULL, '230', '357');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('358', 'LISSETH ISABELLA', 'MENDOZA SALAZAR', 'EST-1254', '2010-11-09', 'Femenino', 'f', NULL, '9', NULL, NULL, '231', '358');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('359', 'LIZCANO FRANCISCONY', 'LUCCIANA ANTONELLA', 'EST-1255', '2014-09-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '231', '359');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('360', 'LORIANA ANTHONELLA', 'CONTRERAS HARMS', 'EST-1256', '2013-01-08', 'Femenino', 'f', NULL, '8', NULL, NULL, '232', '360');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('361', 'LORIANA ANTHONELLA', 'CONTRERAS HARMS', 'EST-1257', '2013-01-08', 'Femenino', 'f', NULL, '8', NULL, NULL, '233', '361');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('362', 'LUCCIANA ANTONELLA', 'LIZCANO FRANCISCONY', 'EST-1258', '2014-09-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '234', '362');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('363', 'LUCIA ANTONELLA', 'CONTRERAS ARELLANO', 'EST-1259', '2014-10-06', 'Femenino', 'f', NULL, '6', NULL, NULL, '234', '363');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('364', 'LUCÍA CAMILA', 'CASTELLANOS CRESPO', 'EST-1260', '2013-03-09', 'Femenino', 'f', NULL, '7', NULL, NULL, '235', '364');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('365', 'LUCÍA CAMILA', 'CASTELLANOS CRESPO', 'EST-1261', '2013-03-09', 'Femenino', 'f', NULL, '6', NULL, NULL, '236', '365');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('366', 'LUISA CAMILA', 'RONDON SANCHEZ', 'EST-1262', '2010-09-11', 'Femenino', 'f', NULL, '8', NULL, NULL, '236', '366');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('367', 'LUZHANY SARAIH', 'LIZCANO BASTO', 'EST-1263', '2009-08-10', 'Femenino', 'f', NULL, '10', NULL, NULL, '237', '367');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('368', 'MADELAINE GISSELL', 'GARZON MORALES', 'EST-1264', '2014-08-21', 'Femenino', 'f', NULL, '6', NULL, NULL, '238', '368');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('369', 'MADELAINE GISSELL', 'GARZON MORALES', 'EST-1265', '2014-08-21', 'Femenino', 'f', NULL, '8', NULL, NULL, '239', '369');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('370', 'MANUELA ALEJANDRA', 'NÚÑEZ MORENO', 'EST-1266', '2011-02-04', 'Femenino', 'f', NULL, NULL, NULL, NULL, '240', '370');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('371', 'MARÍA CAMILA', 'MÚJICA VARGAS', 'EST-1267', '2009-09-29', 'Femenino', 'f', NULL, '12', NULL, NULL, '240', '371');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('372', 'MARÍA CAMILA', 'MÚJICA VARGAS', 'EST-1268', '2009-09-29', 'Femenino', 'f', NULL, NULL, NULL, NULL, '240', '372');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('373', 'MARÍA DE JESÚS', 'GUERRERO APARICIO', 'EST-1269', '2006-10-07', 'Femenino', 'f', NULL, '22', NULL, NULL, '68', '373');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('374', 'MARÍA DE JESÚS', 'GUERRERO APARICIO', 'EST-1270', '2006-10-07', 'Femenino', 'f', NULL, '22', NULL, NULL, '241', '374');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('375', 'MARIA DE LOS ANGELES', 'SANCHEZ JAIMES', 'EST-1271', '2011-12-04', 'Femenino', 'f', NULL, '25', NULL, NULL, '241', '375');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('376', 'MARIA DE LOS ANGELES', 'CARRERO GOMEZ', 'EST-1272', '2015-09-08', 'Femenino', 'f', NULL, '25', NULL, NULL, '242', '376');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('377', 'MARIA DE LOS ANGELES', 'CARRERO GOMEZ', 'EST-1273', '2015-09-08', 'Femenino', 'f', NULL, '25', NULL, NULL, '243', '377');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('378', 'MARIA DE LOS ANGELES', 'CARRERO GOMEZ', 'EST-1274', '2015-09-08', 'Femenino', 'f', NULL, '6', NULL, NULL, '243', '378');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('379', 'MARIA FERNANDA', 'RAMIREZ RIVERA', 'EST-1275', '2012-01-13', 'Femenino', 'f', NULL, '9', NULL, NULL, '68', '379');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('380', 'MARIA FERNANDA', 'GIRALDO CONTRERAS', 'EST-1276', '2007-01-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, '243', '380');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('381', 'MARIA FERNANDA', 'GIRALDO CONTRERAS', 'EST-1277', '2006-03-06', 'Femenino', 'f', NULL, '22', NULL, NULL, '244', '381');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('382', 'MARIA FERNANDA', 'GIRALDO CONTRERAS', 'EST-1278', '2006-03-06', 'Femenino', 'f', NULL, '22', NULL, NULL, '245', '382');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('383', 'MARIA FERNANDA', 'ZAMBRANO ROJAS', 'EST-1279', '2016-04-01', 'Femenino', 'f', NULL, '25', NULL, NULL, '246', '383');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('384', 'MARIA FERNANDA', 'ZAMBRANO ROJAS', 'EST-1280', '2016-04-01', 'Femenino', 'f', NULL, '25', NULL, NULL, '246', '384');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('385', 'MARIA FERNANDA', 'RAMIREZ RIVERA', 'EST-1281', '2012-01-13', 'Femenino', 'f', NULL, '10', NULL, NULL, '247', '385');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('386', 'MARIA FERNANDA', 'ZAMBRANO RANGEL', 'EST-1282', '2016-04-01', 'Femenino', 'f', NULL, '6', NULL, NULL, '248', '386');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('387', 'MARIA GUADALUPE', 'MANRIQUE CARDENAS', 'EST-1283', '2009-03-03', 'Femenino', 'f', NULL, '20', NULL, NULL, '249', '387');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('388', 'MARIA GUADALUPE', 'MANRIQUE CARDENAS', 'EST-1284', '2009-03-03', 'Femenino', 'f', NULL, NULL, NULL, NULL, '250', '388');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('389', 'MARIA ISABELLA', 'GUERRA GANDICA', 'EST-1285', '2011-09-05', 'Femenino', 'f', NULL, '9', NULL, NULL, '251', '389');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('390', 'MARIA ISABELLA', 'GUERRA GANDICA', 'EST-1286', '2011-09-05', 'Femenino', 'f', NULL, '8', NULL, NULL, '252', '390');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('391', 'MARIA JIMENA', 'ESCALANTE BECERRA', 'EST-1287', '2016-08-19', 'Femenino', 'f', NULL, '25', NULL, NULL, '252', '391');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('392', 'MARIA JOSE', 'CARDOZA MORENO', 'EST-1288', '2015-09-25', 'Femenino', 'f', NULL, '25', NULL, NULL, '253', '392');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('393', 'MARIA JOSE', 'RUBIO ARELLANO', 'EST-1289', '2006-03-15', 'Femenino', 'f', NULL, '13', NULL, NULL, '254', '393');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('394', 'MARÍA JOSÉ', 'RAMÍREZ FERNÁNDEZ', 'EST-1290', '2004-08-02', 'Femenino', 'f', NULL, '14', NULL, NULL, '255', '394');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('469', 'NELIANA', 'PLATA BUITRAGO', 'EST-1365', '2011-10-29', 'Femenino', 'f', NULL, '10', NULL, NULL, '151', '469');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('395', 'MARIA JOSE DEL ROCIO', 'PEREIRA ESCALANTE', 'EST-1291', '2012-12-07', 'Femenino', 'f', NULL, '9', NULL, NULL, '256', '395');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('396', 'MARIA JULIETA', 'ORTIZ HERRERA', 'EST-1292', '2015-06-17', 'Femenino', 'f', NULL, '7', NULL, NULL, '257', '396');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('397', 'MARÍA KAMILA', 'CONTRERAS PACHECO', 'EST-1293', '2014-11-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '257', '397');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('398', 'MARÍA KAMILA', 'CONTRERAS PACHECO', 'EST-1294', '2014-11-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '258', '398');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('399', 'MARIA LAURA', 'CASTRO HART', 'EST-1295', '2006-06-16', 'Femenino', 'f', NULL, '14', NULL, NULL, '259', '399');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('400', 'MARIA NIRVANA', 'STANCO BOHORQUEZ', 'EST-1296', '2006-01-30', 'Femenino', 'f', NULL, '22', NULL, NULL, '258', '400');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('401', 'MARÍA PAULA', 'PARADA ORTIZ', 'EST-1297', '2012-11-08', 'Femenino', 'f', NULL, '10', NULL, NULL, '260', '401');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('402', 'MARIA SOFIA', 'GUERRA CONTRERAS', 'EST-1298', '2010-04-08', 'Femenino', 'f', NULL, '10', NULL, NULL, '260', '402');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('403', 'MARIA SOFIA', 'ANDRADE GONZALEZ', 'EST-1299', '2009-05-29', 'Femenino', 'f', NULL, NULL, NULL, NULL, '261', '403');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('404', 'MARIA SOFIA', 'ANDRADE GONZALEZ', 'EST-1300', '2009-05-29', 'Femenino', 'f', NULL, '10', NULL, NULL, '261', '404');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('405', 'MARIA VALENTINA', 'MORALES OCHOA', 'EST-1301', '2006-08-29', 'Femenino', 'f', NULL, '21', NULL, NULL, '262', '405');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('406', 'MARIA VALENTINA', 'MORALES OCHOA', 'EST-1302', '2006-08-29', 'Femenino', 'f', NULL, '22', NULL, NULL, '262', '406');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('407', 'MARÍA VALENTINA', 'MORALES OCHOA', 'EST-1303', '2006-08-29', 'Femenino', 'f', NULL, NULL, NULL, NULL, '263', '407');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('408', 'MARIA VICTORIA', 'HERNANDEZ LABRADOR', 'EST-1304', '2006-10-07', 'Femenino', 'f', NULL, '17', NULL, NULL, '264', '408');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('409', 'MARIA VICTORIA', 'HERNANDEZ LABRADOR', 'EST-1305', '2006-10-07', 'Femenino', 'f', NULL, '18', NULL, NULL, '265', '409');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('410', 'MARIA VICTORIA', 'BELTRAN GONZALEZ', 'EST-1306', '2008-04-13', 'Femenino', 'f', NULL, '10', NULL, NULL, '265', '410');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('411', 'MARIA VICTORIA', 'BELTRAN GONZALEZ', 'EST-1307', '2008-04-13', 'Femenino', 'f', NULL, NULL, NULL, NULL, '266', '411');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('412', 'MARIA VICTORIA', 'UTRERA SILVA', 'EST-1308', '2016-01-07', 'Femenino', 'f', NULL, '25', NULL, NULL, '267', '412');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('413', 'MARIA VICTORIA', 'UTRERA SILVA', 'EST-1309', '2016-01-07', 'Femenino', 'f', NULL, '6', NULL, NULL, '268', '413');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('414', 'MARÍA VIRGINIA', 'GARCÍA FERNÁNDEZ', 'EST-1310', '2011-07-11', 'Femenino', 'f', NULL, '12', NULL, NULL, '268', '414');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('415', 'MARIAGNY ALEXANDRA', 'ESCALANTE BUENAÑO', 'EST-1311', '2006-05-29', 'Femenino', 'f', NULL, '14', NULL, NULL, '268', '415');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('416', 'MARIAM GEORGINA', 'ROA SUAREZ', 'EST-1312', '2008-08-08', 'Femenino', 'f', NULL, NULL, NULL, NULL, '269', '416');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('417', 'MARIAM GEORGINA', 'ROA SUAREZ', 'EST-1313', '2008-08-08', 'Femenino', 'f', NULL, '20', NULL, NULL, '270', '417');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('418', 'MARIANA', 'BOADA BAYONA', 'EST-1314', '2011-07-16', 'Femenino', 'f', NULL, '10', NULL, NULL, '270', '418');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('419', 'MARIANA DAYMAR', 'GARCÍA RAMÍREZ', 'EST-1315', '2004-12-01', 'Femenino', 'f', NULL, '13', NULL, NULL, '270', '419');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('420', 'MARIANA ISABELLA', 'VÁSQUEZ GUERRERO', 'EST-1316', '2011-08-03', 'Femenino', 'f', NULL, NULL, NULL, NULL, '271', '420');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('421', 'MARIANA ISABELLA', 'VÁSQUEZ GUERRERO', 'EST-1317', '2010-08-03', 'Femenino', 'f', NULL, '16', NULL, NULL, '272', '421');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('422', 'MARIANA ISABELLA', 'VASQUEZ GUERRERO', 'EST-1318', '2010-08-03', 'Femenino', 'f', NULL, '10', NULL, NULL, '273', '422');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('423', 'MARIANA LUCIA', 'ABREU GOMEZ', 'EST-1319', '2013-07-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '274', '423');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('424', 'MARIANA LUCIA', 'ABREU GOMEZ', 'EST-1320', '2013-07-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '275', '424');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('425', 'MARIANA LUCIA', 'ABREU GOMEZ', 'EST-1321', '2013-07-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '275', '425');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('426', 'MARIANA LUCIA', 'ABREU GOMEZ', 'EST-1322', '2013-07-27', 'Femenino', 'f', NULL, '9', NULL, NULL, '234', '426');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('427', 'MARIANA SARAI', 'ACOSTA ROJAS', 'EST-1323', '2010-08-05', 'Femenino', 'f', NULL, '10', NULL, NULL, '271', '427');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('428', 'MARIANGEL', 'CARRERO GUIRAL', 'EST-1324', '2008-12-11', 'Femenino', 'f', NULL, '13', NULL, NULL, '276', '428');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('429', 'MARIANGEL DELVALLE', 'PÉREZ SUÁREZ', 'EST-1325', '2012-11-29', 'Femenino', 'f', NULL, '10', NULL, NULL, '277', '429');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('430', 'MARIANGEL ELIANA', 'VARELA ESCALANTE', 'EST-1326', '2006-10-25', 'Femenino', 'f', NULL, '18', NULL, NULL, '278', '430');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('431', 'MARIANGEL GABRIELA', 'DUQUE SANCHEZ', 'EST-1327', '2013-08-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '279', '431');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('432', 'MARIANGEL GABRIELA', 'DUQUE SANCHEZ', 'EST-1328', '2013-08-01', 'Femenino', 'f', NULL, '8', NULL, NULL, '280', '432');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('433', 'MARIANGEL HELIT', 'GARZON MORALES', 'EST-1329', '2011-01-07', 'Femenino', 'f', NULL, NULL, NULL, NULL, '281', '433');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('434', 'MARIANGEL JOHANA', 'ACOSTA ROJAS', 'EST-1330', '2008-06-06', 'Femenino', 'f', NULL, NULL, NULL, NULL, '282', '434');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('435', 'MARIÁNGEL SOFÍA', 'GUERRA COLMENARES', 'EST-1331', '2006-11-18', 'Femenino', 'f', NULL, '22', NULL, NULL, '282', '435');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('436', 'MARIANGEL STEFFANY', 'MARQUEZ CONTRERAS', 'EST-1332', '2012-11-27', 'Femenino', 'f', NULL, '10', NULL, NULL, '272', '436');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('437', 'MARIANGEL STHEFANY', 'RAMIREZ REY', 'EST-1333', '2010-03-17', 'Femenino', 'f', NULL, '10', NULL, NULL, '272', '437');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('438', 'MARIANGEL YOSELIN', 'CARRILLO URBINA', 'EST-1334', '2009-07-30', 'Femenino', 'f', NULL, NULL, NULL, NULL, '283', '438');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('439', 'MARIANNID VICTORIA', 'VASQUEZ ÁNGEL', 'EST-1335', '2008-11-07', 'Femenino', 'f', NULL, NULL, NULL, NULL, '284', '439');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('440', 'MARIANNID VICTORIA', 'VASQUEZ ANGEL', 'EST-1336', '2008-11-07', 'Femenino', 'f', NULL, '12', NULL, NULL, '285', '440');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('441', 'MARIANNID VICTORIA', 'VASQUEZ ANGEL', 'EST-1337', '2008-11-07', 'Femenino', 'f', NULL, '12', NULL, NULL, '286', '441');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('442', 'MARIANNID VICTORIA', 'VASQUES ANGEL', 'EST-1338', '2008-11-07', 'Femenino', 'f', NULL, '13', NULL, NULL, '287', '442');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('443', 'MARIET ANTONELLA', 'CARRERO GUIRAL', 'EST-1339', '2016-09-22', 'Femenino', 'f', NULL, '25', NULL, NULL, '287', '443');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('444', 'MARIET ANTONELLA', 'CARRERO GUIRAL', 'EST-1340', '2016-09-22', 'Femenino', 'f', NULL, '6', NULL, NULL, '288', '444');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('445', 'MARTHINA', 'SERRANO HERNANDEZ', 'EST-1341', '2013-10-18', 'Femenino', 'f', NULL, '8', NULL, NULL, '289', '445');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('446', 'MARTHINA SOFIA', 'SERRANO HERNÁNDEZ', 'EST-1342', '2013-10-18', 'Femenino', 'f', NULL, '7', NULL, NULL, '290', '446');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('447', 'MARTHINA SOFIA', 'SERRANO HERNÁNDEZ', 'EST-1343', '2013-10-18', 'Femenino', 'f', NULL, '6', NULL, NULL, '291', '447');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('448', 'MARYELIX AILEEN', 'CONTRERAS SANDOVAL', 'EST-1344', '2015-08-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '292', '448');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('449', 'MELANNY ANTHONELLA', 'NAVARRO ALVIAREZ', 'EST-1345', '2012-11-02', 'Femenino', 'f', NULL, '8', NULL, NULL, '293', '449');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('450', 'MELANNY ANTHONELLA', 'NAVARRO ALVIAREZ', 'EST-1346', '2012-11-02', 'Femenino', 'f', NULL, '8', NULL, NULL, '181', '450');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('451', 'MELANY SALOME', 'NARANJO VILLALOBOS', 'EST-1347', '2012-05-24', 'Femenino', 'f', NULL, '9', NULL, NULL, '294', '451');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('452', 'MELANY SALOME', 'NARANJO VILLALOBOS', 'EST-1348', '2012-05-24', 'Femenino', 'f', NULL, '10', NULL, NULL, '295', '452');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('453', 'MELANY SALOME', 'NARANJO VILLALOBOS', 'EST-1349', '2012-05-24', 'Femenino', 'f', NULL, '8', NULL, NULL, '295', '453');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('454', 'MELANY SOPHIA', 'TORRES DAVILA', 'EST-1350', '2013-05-13', 'Femenino', 'f', NULL, '9', NULL, NULL, '296', '454');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('455', 'MEREDITH NOELY', 'PACHECO RAMÍREZ', 'EST-1351', '2018-02-27', 'Femenino', 'f', NULL, '25', NULL, NULL, '297', '455');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('456', 'MIA ISABELLA', 'RUGELES MANOSALVA', 'EST-1352', '2015-11-20', 'Femenino', 'f', NULL, '6', NULL, NULL, '261', '456');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('457', 'MIA VALENTINA', 'MONCADA GARNICA', 'EST-1353', '2018-02-27', 'Femenino', 'f', NULL, '25', NULL, NULL, '261', '457');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('458', 'MICHELLE ALEXANDRA', 'GUERRERO PEREZ', 'EST-1354', '2015-04-24', 'Femenino', 'f', NULL, '7', NULL, NULL, '261', '458');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('459', 'MICHELLE CAROLAY', 'SUAREZ PULIDO', 'EST-1355', '2012-11-27', 'Femenino', 'f', NULL, '9', NULL, NULL, '298', '459');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('460', 'MICHELLE CAROLAY', 'SUAREZ PULIDO', 'EST-1356', '2012-11-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '299', '460');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('461', 'NADIA GABRIELA', 'LOZANO ROMÁN', 'EST-1357', '2005-06-25', 'Femenino', 'f', NULL, '22', NULL, NULL, '299', '461');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('462', 'NATALIA ANDREA', 'MÁRQUEZ MOLINA', 'EST-1358', '2003-08-20', 'Femenino', 'f', NULL, '22', NULL, NULL, '299', '462');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('463', 'NATALIA ANDREA', 'BELTRAN GONZALEZ', 'EST-1359', '2006-05-17', 'Femenino', 'f', NULL, '20', NULL, NULL, '300', '463');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('464', 'NATALIA ANDREA', 'BELTRAN GONZALEZ', 'EST-1360', '2006-05-17', 'Femenino', 'f', NULL, '20', NULL, NULL, '300', '464');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('465', 'NATALIA ANDREA', 'BELTRÁN GONZÁLEZ', 'EST-1361', '2006-05-17', 'Femenino', 'f', NULL, '22', NULL, NULL, '151', '465');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('466', 'NATHALIA SARAY', 'BONILLA PULIDO', 'EST-1362', '2011-11-02', 'Femenino', 'f', NULL, '10', NULL, NULL, '151', '466');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('467', 'NELIANA', 'PLATA BUITRAGO', 'EST-1363', '2011-10-29', 'Femenino', 'f', NULL, '9', NULL, NULL, '151', '467');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('470', 'NICOLL ANTHONELA', 'HURTADO GUTIERREZ', 'EST-1366', '2012-12-31', 'Femenino', 'f', NULL, '8', NULL, NULL, '301', '470');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('471', 'NICOLL ANTHONELA', 'HURTADO GUTIERREZ', 'EST-1367', '2012-12-31', 'Femenino', 'f', NULL, '6', NULL, NULL, '302', '471');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('472', 'NIYOSKARY ORALYN', 'OQUENDO OSTOS', 'EST-1368', '2005-03-10', 'Femenino', 'f', NULL, NULL, NULL, NULL, '303', '472');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('473', 'NIYOSKARY ORALYN', 'OQUENDO OSTOS', 'EST-1369', '2005-03-10', 'Femenino', 'f', NULL, NULL, NULL, NULL, '304', '473');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('474', 'NIYOSKARY ORALYN', 'OQUENDO OSTOS', 'EST-1370', '2005-03-10', 'Femenino', 'f', NULL, NULL, NULL, NULL, '305', '474');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('475', 'NIYOSKARY ORALYN', 'OQUENDO OSTOS OQUENDO OSTOS', 'EST-1371', '2005-03-10', 'Femenino', 'f', NULL, NULL, NULL, NULL, '306', '475');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('476', 'NIYOSKARY ORALYN', 'OQUENDO OSTOS OQUENDO OSTOS', 'EST-1372', '2005-03-10', 'Femenino', 'f', NULL, '12', NULL, NULL, '307', '476');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('477', 'NOELIA SALOMÉ', 'BONILLA BECERRA', 'EST-1373', '2016-08-22', 'Femenino', 'f', NULL, '6', NULL, NULL, '308', '477');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('478', 'NOEMÍ ALEXANDRA', 'CELIS DUARTE', 'EST-1374', '2009-08-11', 'Femenino', 'f', NULL, '16', NULL, NULL, '309', '478');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('479', 'NOEMI ALEXANDRA', 'CELIS DUARTE', 'EST-1375', '2009-08-11', 'Femenino', 'f', NULL, '10', NULL, NULL, '310', '479');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('480', 'ORIANNA MICHELLE', 'VIVAS MONSALVE', 'EST-1376', '2005-08-21', 'Femenino', 'f', NULL, '22', NULL, NULL, '310', '480');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('481', 'ORIANNA SOFÍA', 'PÉREZ NAVARRO', 'EST-1377', '2011-05-17', 'Femenino', 'f', NULL, '9', NULL, NULL, '310', '481');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('482', 'ORIANNA SOFIA', 'PEREZ NAVARRO', 'EST-1378', '2011-05-17', 'Femenino', 'f', NULL, '10', NULL, NULL, '227', '482');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('483', 'OSKARI JOSABET', 'HERNANDEZ BOHORQUEZ', 'EST-1379', '2006-09-21', 'Femenino', 'f', NULL, '13', NULL, NULL, '230', '483');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('484', 'OSKARI JOSABET', 'HERNANDEZ BOHORQUEZ', 'EST-1380', '2006-09-21', 'Femenino', 'f', NULL, NULL, NULL, NULL, '311', '484');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('485', 'OSKARI JOSABET', 'HERNÁNDEZ BOHÓRQUEZ', 'EST-1381', '2006-09-21', 'Femenino', 'f', NULL, '14', NULL, NULL, '312', '485');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('486', 'OSKARI JOSABET', 'HERNÁNDEZ BOHÓRQUEZ', 'EST-1382', '2006-09-21', 'Femenino', 'f', NULL, '14', NULL, NULL, '313', '486');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('487', 'OSKARI JOSABET', 'HERNÁNDEZ BOHÓRQUEZ', 'EST-1383', '2006-09-21', 'Femenino', 'f', NULL, '25', NULL, NULL, '314', '487');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('488', 'OSKARI JOSABET', 'HERNANDEZ BOHORQUEZ', 'EST-1384', '2006-09-21', 'Femenino', 'f', NULL, '14', NULL, NULL, '315', '488');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('489', 'PAOLA STEFANIA', 'CHACON SALCEDO', 'EST-1385', '2005-02-09', 'Femenino', 'f', NULL, '22', NULL, NULL, '316', '489');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('490', 'PAOLA VALENTINA', 'LIZCANO FRANCISCONY', 'EST-1386', '2014-09-04', 'Femenino', 'f', NULL, '6', NULL, NULL, '316', '490');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('491', 'PAOLA VALENTINA', 'LIZCANO FRANCISCONY', 'EST-1387', '2014-09-04', 'Femenino', 'f', NULL, '7', NULL, NULL, '317', '491');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('492', 'PATRICIA ANTONELLA', 'MARQUEZ REQUENA', 'EST-1388', '2012-12-21', 'Femenino', 'f', NULL, '7', NULL, NULL, '317', '492');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('493', 'PAULA ANDREA', 'ROJAS UZCATEGUI', 'EST-1389', '2008-07-10', 'Femenino', 'f', NULL, '13', NULL, NULL, '317', '493');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('494', 'PAULA ANDREINA', 'NARANJO CORREA', 'EST-1390', '2013-02-08', 'Femenino', 'f', NULL, '7', NULL, NULL, '317', '494');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('495', 'PAULA MONSERRAT', 'CACUA MONCADA', 'EST-1391', '2016-01-06', 'Femenino', 'f', NULL, '6', NULL, NULL, '318', '495');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('496', 'RACHEL SARAITH', 'ROJAS ROMERO', 'EST-1392', '2005-04-24', 'Femenino', 'f', NULL, '14', NULL, NULL, '319', '496');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('497', 'ROMINNA STEPHANIA', 'ZUMZTEIN GIL', 'EST-1393', '2013-12-09', 'Femenino', 'f', NULL, '7', NULL, NULL, '319', '497');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('498', 'ROMINNA STEPHANIA', 'ZUMZTEIN GIL', 'EST-1394', '2013-12-09', 'Femenino', 'f', NULL, '6', NULL, NULL, '320', '498');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('499', 'ROSSY VALENTINA', 'MARQUEZ ROSALES', 'EST-1395', '2011-08-12', 'Femenino', 'f', NULL, '8', NULL, NULL, '321', '499');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('500', 'ROSSY VALENTINA', 'MARQUEZ ROSALES', 'EST-1396', '2011-08-12', 'Femenino', 'f', NULL, '9', NULL, NULL, '321', '500');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('501', 'ROSSY VALENTINA', 'MARQUEZ ROSALES', 'EST-1397', '2011-08-12', 'Femenino', 'f', NULL, '10', NULL, NULL, '322', '501');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('502', 'ROSSY VALENTINA', 'MARQUEZ ROSALES', 'EST-1398', '2011-08-12', 'Femenino', 'f', NULL, NULL, NULL, NULL, '323', '502');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('503', 'SABINEL', 'FERMÍN DELGADO', 'EST-1399', '2012-05-07', 'Femenino', 'f', NULL, '9', NULL, NULL, '323', '503');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('504', 'SABRINA LEONOR', 'VILLEGAS CHACÓN', 'EST-1400', '2015-12-21', 'Femenino', 'f', NULL, '6', NULL, NULL, '324', '504');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('505', 'SABRINA LEONOR', 'VILLEGAS CHANCON', 'EST-1401', '2015-12-21', 'Femenino', 'f', NULL, '25', NULL, NULL, '325', '505');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('506', 'SALOME NAZARETH', 'BECERRA CASTRO', 'EST-1402', '2015-02-11', 'Femenino', 'f', NULL, '7', NULL, NULL, '326', '506');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('507', 'SAMANTHA SOLEY', 'PEÑALOZA BAEZ', 'EST-1403', '2014-10-08', 'Femenino', 'f', NULL, '6', NULL, NULL, '326', '507');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('508', 'SAMANTHA SOLEY', 'PEÑALOZA BAEZ', 'EST-1404', '2014-10-08', 'Femenino', 'f', NULL, '6', NULL, NULL, '220', '508');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('509', 'SARA ANGELINA', 'BANCES HERNANDEZ', 'EST-1405', '2009-01-01', 'Femenino', 'f', NULL, NULL, NULL, NULL, '220', '509');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('510', 'SARA ADELEN SOFIA', 'ANTONIELLI SUA', 'EST-1406', '2013-05-21', 'Femenino', 'f', NULL, '6', NULL, NULL, '327', '510');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('511', 'SARA ANDREINA', 'MORALES FERNANDEZ', 'EST-1407', '2007-09-16', 'Femenino', 'f', NULL, '13', NULL, NULL, '327', '511');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('512', 'SARA ANDREINA', 'MORALES FERNANDEZ', 'EST-1408', '2007-09-16', 'Femenino', 'f', NULL, '14', NULL, NULL, '114', '512');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('513', 'SARA ANGELINA', 'BANCES HERNANDEZ', 'EST-1409', '2009-07-27', 'Femenino', 'f', NULL, '12', NULL, NULL, '114', '513');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('514', 'SARA ANGELY', 'PASTRAN ROJAS', 'EST-1410', '2013-04-03', 'Femenino', 'f', NULL, '7', NULL, NULL, '114', '514');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('515', 'SARA GLADYMAR', 'QUIROZ ACOSTA', 'EST-1411', '2006-09-14', 'Femenino', 'f', NULL, '14', NULL, NULL, '328', '515');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('516', 'SARA GLADYMAR', 'QUIROZ ACOSTA', 'EST-1412', '2006-09-14', 'Femenino', 'f', NULL, '14', NULL, NULL, '329', '516');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('517', 'SARA NOHEMÍ', 'MUÑOZ ACEVEDO', 'EST-1413', '2013-08-31', 'Femenino', 'f', NULL, '7', NULL, NULL, '330', '517');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('518', 'SARA NOHEMI', 'MUÑOZ ACEVEDO', 'EST-1414', '2013-08-31', 'Femenino', 'f', NULL, '8', NULL, NULL, '331', '518');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('519', 'SARA VALERIA', 'CASIQUE ZAMBRANO', 'EST-1415', '2014-05-18', 'Femenino', 'f', NULL, '7', NULL, NULL, '332', '519');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('520', 'SARA VALERIA', 'CASIQUE ZAMBRANO', 'EST-1416', '2014-05-18', 'Femenino', 'f', NULL, '7', NULL, NULL, '333', '520');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('521', 'SARAH NOHEMY', 'CÁCERES LEAL', 'EST-1417', '2008-05-29', 'Femenino', 'f', NULL, '14', NULL, NULL, '334', '521');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('522', 'SARAH NOHEMY', 'CACERES LEAL', 'EST-1418', '2008-05-29', 'Femenino', 'f', NULL, NULL, NULL, NULL, '335', '522');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('523', 'SARAH NOHEMY', 'CACERES LEAL', 'EST-1419', '2008-05-29', 'Femenino', 'f', NULL, '13', NULL, NULL, '336', '523');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('524', 'SARAITH NEILYN', 'CASTAÑEDA GONZÁLEZ', 'EST-1420', '2006-09-02', 'Femenino', 'f', NULL, '20', NULL, NULL, '337', '524');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('525', 'SARAITH NEILYN', 'CASTAÑEDA GONZÁLEZ', 'EST-1421', '2006-09-02', 'Femenino', 'f', NULL, '20', NULL, NULL, '132', '525');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('526', 'SARAITH NEILYN', 'CASTAÑEDA GONZÁLEZ', 'EST-1422', '2006-09-02', 'Femenino', 'f', NULL, '20', NULL, NULL, '132', '526');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('527', 'SHIRLEY ORIANA', 'REY LOPEZ', 'EST-1423', '2005-09-19', 'Femenino', 'f', NULL, '16', NULL, NULL, '338', '527');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('528', 'SKARLY FRANCHESCA', 'BERNAL DURAN', 'EST-1424', '2014-03-14', 'Femenino', 'f', NULL, '8', NULL, NULL, '94', '528');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('529', 'SOFIA ALEJANDRA', 'NIÑO PAZ', 'EST-1425', '2008-05-08', 'Femenino', 'f', NULL, '12', NULL, NULL, '339', '529');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('530', 'SOFIA ALEJANDRA', 'NINO PAZ', 'EST-1426', '2008-05-08', 'Femenino', 'f', NULL, '13', NULL, NULL, '340', '530');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('531', 'SOFIA ANABHELLA', 'CHACÓN GONZÁLEZ', 'EST-1427', '2016-07-08', 'Femenino', 'f', NULL, '6', NULL, NULL, '341', '531');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('532', 'SOFIA CARLOTA', 'DIAZ CHACON', 'EST-1428', '2014-12-22', 'Femenino', 'f', NULL, '6', NULL, NULL, '342', '532');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('533', 'SOFIA GABRIELA', 'GAITÀN BECERRA', 'EST-1429', '2004-10-25', 'Femenino', 'f', NULL, '22', NULL, NULL, '343', '533');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('534', 'SOFÍA VALERIA', 'CORDERO MONCADA', 'EST-1430', '2013-07-19', 'Femenino', 'f', NULL, '8', NULL, NULL, '344', '534');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('535', 'SOFÍA VALERIA', 'CORDERO MONCADA', 'EST-1431', '2013-07-19', 'Femenino', 'f', NULL, '8', NULL, NULL, '344', '535');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('536', 'SOFIA VALERIA', 'CORDERO MONCADA', 'EST-1432', '2013-07-19', 'Femenino', 'f', NULL, '9', NULL, NULL, '345', '536');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('537', 'SOFIA VALETINA', 'KYRIMLKOGLOU RAMIREZ', 'EST-1433', '2007-10-25', 'Femenino', 'f', NULL, '22', NULL, NULL, '346', '537');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('538', 'SOPHIA ANTONELLA', 'MORA VARELA', 'EST-1434', '2013-03-01', 'Femenino', 'f', NULL, '7', NULL, NULL, '347', '538');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('539', 'SOPHIA VALENTINA', 'D´ SANTIAGO CASTRO', 'EST-1435', '2012-08-20', 'Femenino', 'f', NULL, '7', NULL, NULL, '348', '539');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('540', 'SOPHY ANTONELLA', 'CASTELLANO PERNIA', 'EST-1436', '2013-05-02', 'Femenino', 'f', NULL, '7', NULL, NULL, '348', '540');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('541', 'STEFANNY CAMILA', 'LEÓN RICO', 'EST-1437', '2015-11-13', 'Femenino', 'f', NULL, '7', NULL, NULL, '349', '541');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('542', 'STEPHENIE SALOMÉ', 'ALVIAREZ VERGARA', 'EST-1438', '2006-10-26', 'Femenino', 'f', NULL, '6', NULL, NULL, '205', '542');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('543', 'TATIANA ISABELLA', 'ZAMBRANO ARAQUE', 'EST-1439', '2004-08-31', 'Femenino', 'f', NULL, '14', NULL, NULL, '350', '543');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('544', 'VALERIA DE LOS ANGELES', 'ZAMBRANO GUERRERO', 'EST-1440', '2006-11-08', 'Femenino', 'f', NULL, '14', NULL, NULL, '351', '544');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('545', 'VALERIA DE LOS ÁNGELES', 'ZAMBRANO GUERRERO', 'EST-1441', '2006-11-08', 'Femenino', 'f', NULL, '14', NULL, NULL, '351', '545');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('546', 'VALERIA SARAITH', 'RAMIREZ SERRANO', 'EST-1442', '2015-12-19', 'Femenino', 'f', NULL, '25', NULL, NULL, '352', '546');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('547', 'VALERIA SOFIA', 'OJEDA ZAMBRANO', 'EST-1443', '2004-08-20', 'Femenino', 'f', NULL, '25', NULL, NULL, '353', '547');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('548', 'VALERIA SOFIA', 'BORRERO CACERES', 'EST-1444', '2010-10-25', 'Femenino', 'f', NULL, '8', NULL, NULL, '354', '548');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('549', 'VALERIA VALENTINA', 'VELASQUEZ RAMIREZ', 'EST-1445', '2014-04-03', 'Femenino', 'f', NULL, '7', NULL, NULL, '353', '549');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('550', 'VALERIA VALENTINA', 'VELASQUEZ RAMIREZ', 'EST-1446', '2014-04-03', 'Femenino', 'f', NULL, '8', NULL, NULL, '355', '550');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('551', 'VALERIAISABEL', 'URBINA PERNIA', 'EST-1447', '2004-12-11', 'Femenino', 'f', NULL, '22', NULL, NULL, '356', '551');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('552', 'VALERY ALEJANDRA', 'ONTIVEROS MOGROVEJO', 'EST-1448', '2018-01-08', 'Femenino', 'f', NULL, '25', NULL, NULL, '357', '552');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('553', 'VANESSA CAROLINA', 'VILLASMIL MATA', 'EST-1449', '2006-01-23', 'Femenino', 'f', NULL, '22', NULL, NULL, '357', '553');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('554', 'VENEZIA ALEGRÍA', 'RICO MOLINA', 'EST-1450', '2014-03-14', 'Femenino', 'f', NULL, '7', NULL, NULL, '357', '554');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('555', 'VENEZIA ALEGRÍA', 'RICO MOLINA', 'EST-1451', '2014-03-14', 'Femenino', 'f', NULL, '8', NULL, NULL, '358', '555');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('556', 'VICTORIA AYLENN', 'MORALES COLMENARES', 'EST-1452', '2016-08-15', 'Femenino', 'f', NULL, '6', NULL, NULL, '358', '556');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('557', 'VICTORIA ALEJANDRA', 'PEREZ SALCEDO', 'EST-1453', '2013-09-13', 'Femenino', 'f', NULL, '6', NULL, NULL, '359', '557');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('558', 'VICTORIA ALEJANDRA', 'MANTILLA CASTRO', 'EST-1454', '2013-09-05', 'Femenino', 'f', NULL, '7', NULL, NULL, '360', '558');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('559', 'VICTORIA ALEJANDRA', 'PÉREZ SALCEDO', 'EST-1455', '2013-09-13', 'Femenino', 'f', NULL, '8', NULL, NULL, '321', '559');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('560', 'VICTORIA ALEJANDRA', 'CHACON PRIETO', 'EST-1456', '2017-08-12', 'Femenino', 'f', NULL, '25', NULL, NULL, '361', '560');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('561', 'VICTORIA CAROLINA', 'SULBARAN DURAN', 'EST-1457', '2006-06-08', 'Femenino', 'f', NULL, '13', NULL, NULL, '361', '561');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('562', 'VICTORIA CAROLINA', 'SULBARAN DURAN', 'EST-1458', '2006-06-08', 'Femenino', 'f', NULL, '14', NULL, NULL, '362', '562');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('563', 'VICTORIA CAROLINA', 'SULBARAN DURAN', 'EST-1459', '2006-06-08', 'Femenino', 'f', NULL, '14', NULL, NULL, '362', '563');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('564', 'VICTORIA CAROLINA', 'SULBARAN DURAN', 'EST-1460', '2006-06-08', 'Femenino', 'f', NULL, '14', NULL, NULL, '362', '564');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('565', 'VICTORIA VALENTINA', 'RICO MEDINA', 'EST-1461', '2006-02-02', 'Femenino', 'f', NULL, '22', NULL, NULL, '362', '565');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('566', 'VICTORIA VALENTINA', 'RICO MEDINA', 'EST-1462', '2006-02-02', 'Femenino', 'f', NULL, '21', NULL, NULL, '363', '566');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('567', 'VIKAYZA SHEKINARA', 'VARELA MORENO', 'EST-1463', '2011-10-27', 'Femenino', 'f', NULL, '8', NULL, NULL, '364', '567');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('568', 'WILKER ALEJANDRO', 'FIGUEROA MACIAS', 'EST-1464', '2000-08-11', 'Femenino', 'f', NULL, '10', NULL, NULL, '365', '568');
INSERT INTO public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial") VALUES ('569', 'XIMENA CAMILA', 'PEÑALOZA BAEZ', 'EST-1465', '2016-12-08', 'Femenino', 'f', NULL, '25', NULL, NULL, '365', '569');



--
-- Data for Name: Estudiante_Padre; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Estudiante_Padre" ("Id_estudiante", "Id_padre") (INSERT statements)



--
-- Data for Name: Estudiante_Seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") (INSERT statements)
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('1', '466', '1');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('2', '466', '2');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('3', '466', '3');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('4', '466', '4');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('5', '466', '5');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('6', '466', '6');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('7', '466', '7');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('8', '466', '8');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('9', '466', '9');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('10', '466', '10');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('11', '466', '11');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('12', '466', '12');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('13', '466', '13');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('14', '466', '14');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('15', '466', '15');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('16', '466', '16');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('17', '466', '17');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('18', '466', '18');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('19', '236', '1');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('20', '236', '2');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('21', '236', '3');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('22', '236', '4');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('23', '236', '5');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('24', '236', '6');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('25', '236', '7');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('26', '236', '8');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('27', '236', '9');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('28', '236', '10');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('29', '236', '11');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('30', '236', '12');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('31', '236', '13');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('32', '236', '14');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('33', '236', '15');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('34', '236', '16');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('35', '236', '17');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('36', '236', '18');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('37', '246', '1');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('38', '246', '2');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('39', '246', '3');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('40', '246', '4');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('41', '246', '5');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('42', '246', '6');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('43', '246', '7');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('44', '246', '8');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('45', '246', '9');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('46', '246', '10');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('47', '246', '11');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('48', '246', '12');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('49', '246', '13');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('50', '246', '14');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('51', '246', '15');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('52', '246', '16');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('53', '246', '17');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('54', '246', '18');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('55', '273', '19');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('56', '273', '20');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('57', '273', '21');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('58', '273', '22');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('59', '273', '23');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('60', '273', '24');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('61', '273', '25');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('62', '273', '26');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('63', '273', '27');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('64', '273', '28');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('65', '273', '29');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('66', '273', '30');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('67', '273', '31');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('68', '273', '32');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('69', '273', '33');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('70', '273', '34');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('71', '273', '35');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('72', '273', '36');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('73', '273', '37');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('74', '570', '19');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('75', '570', '20');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('76', '570', '21');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('77', '570', '22');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('78', '570', '23');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('79', '570', '24');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('80', '570', '25');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('81', '570', '26');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('82', '570', '27');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('83', '570', '28');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('84', '570', '29');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('85', '570', '30');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('86', '570', '31');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('87', '570', '32');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('88', '570', '33');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('89', '570', '34');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('90', '570', '35');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('91', '570', '36');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('92', '570', '37');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('93', '244', '19');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('94', '244', '20');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('95', '244', '21');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('96', '244', '22');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('97', '244', '23');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('98', '244', '24');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('99', '244', '25');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('100', '244', '26');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('101', '244', '27');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('102', '244', '28');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('103', '244', '29');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('104', '244', '30');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('105', '244', '31');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('106', '244', '32');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('107', '244', '33');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('108', '244', '34');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('109', '244', '35');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('110', '244', '36');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('111', '244', '37');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('112', '499', '19');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('113', '499', '20');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('114', '499', '21');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('115', '499', '22');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('116', '499', '23');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('117', '499', '24');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('118', '499', '25');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('119', '499', '26');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('120', '499', '27');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('121', '499', '28');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('122', '499', '29');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('123', '499', '30');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('124', '499', '31');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('125', '499', '32');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('126', '499', '33');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('127', '499', '34');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('128', '499', '35');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('129', '499', '36');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('130', '499', '37');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('131', '118', '38');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('132', '118', '39');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('133', '118', '40');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('134', '118', '41');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('135', '118', '42');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('136', '118', '43');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('137', '118', '44');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('138', '118', '45');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('139', '118', '46');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('140', '118', '47');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('141', '118', '48');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('142', '118', '49');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('143', '118', '50');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('144', '118', '51');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('145', '118', '52');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('146', '118', '53');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('147', '370', '38');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('148', '370', '39');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('149', '370', '40');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('150', '370', '41');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('151', '370', '42');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('152', '370', '43');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('153', '370', '44');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('154', '370', '45');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('155', '370', '46');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('156', '370', '47');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('157', '370', '48');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('158', '370', '49');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('159', '370', '50');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('160', '370', '51');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('161', '370', '52');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('162', '370', '53');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('163', '161', '38');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('164', '161', '39');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('165', '161', '40');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('166', '161', '41');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('167', '161', '42');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('168', '161', '43');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('169', '161', '44');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('170', '161', '45');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('171', '161', '46');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('172', '161', '47');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('173', '161', '48');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('174', '161', '49');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('175', '161', '50');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('176', '161', '51');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('177', '161', '52');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('178', '161', '53');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('179', '330', '54');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('180', '330', '55');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('181', '330', '56');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('182', '330', '57');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('183', '330', '58');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('184', '330', '59');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('185', '330', '60');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('186', '330', '61');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('187', '330', '62');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('188', '330', '63');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('189', '330', '64');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('190', '330', '65');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('191', '330', '66');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('192', '330', '67');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('193', '330', '68');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('194', '330', '69');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('195', '330', '70');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('196', '330', '71');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('197', '330', '72');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('198', '203', '54');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('199', '203', '55');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('200', '203', '56');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('201', '203', '57');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('202', '203', '58');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('203', '203', '59');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('204', '203', '60');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('205', '203', '61');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('206', '203', '62');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('207', '203', '63');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('208', '203', '64');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('209', '203', '65');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('210', '203', '66');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('211', '203', '67');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('212', '203', '68');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('213', '203', '69');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('214', '203', '70');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('215', '203', '71');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('216', '203', '72');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('217', '433', '54');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('218', '433', '55');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('219', '433', '56');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('220', '433', '57');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('221', '433', '58');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('222', '433', '59');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('223', '433', '60');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('224', '433', '61');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('225', '433', '62');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('226', '433', '63');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('227', '433', '64');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('228', '433', '65');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('229', '433', '66');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('230', '433', '67');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('231', '433', '68');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('232', '433', '69');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('233', '433', '70');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('234', '433', '71');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('235', '433', '72');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('236', '232', '54');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('237', '232', '55');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('238', '232', '56');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('239', '232', '57');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('240', '232', '58');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('241', '232', '59');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('242', '232', '60');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('243', '232', '61');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('244', '232', '62');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('245', '232', '63');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('246', '232', '64');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('247', '232', '65');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('248', '232', '66');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('249', '232', '67');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('250', '232', '68');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('251', '232', '69');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('252', '232', '70');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('253', '232', '71');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('254', '232', '72');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('255', '312', '73');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('256', '312', '74');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('257', '312', '75');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('258', '312', '76');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('259', '312', '77');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('260', '312', '78');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('261', '312', '79');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('262', '312', '80');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('263', '312', '81');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('264', '312', '82');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('265', '312', '83');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('266', '312', '84');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('267', '312', '85');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('268', '312', '86');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('269', '312', '87');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('270', '414', '73');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('271', '414', '74');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('272', '414', '75');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('273', '414', '76');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('274', '414', '77');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('275', '414', '78');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('276', '414', '79');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('277', '414', '80');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('278', '414', '81');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('279', '414', '82');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('280', '414', '83');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('281', '414', '84');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('282', '414', '85');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('283', '414', '86');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('284', '414', '87');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('285', '371', '73');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('286', '371', '74');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('287', '371', '75');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('288', '371', '76');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('289', '371', '77');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('290', '371', '78');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('291', '371', '79');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('292', '371', '80');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('293', '371', '81');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('294', '371', '82');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('295', '371', '83');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('296', '371', '84');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('297', '371', '85');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('298', '371', '86');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('299', '371', '87');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('300', '193', '73');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('301', '193', '74');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('302', '193', '75');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('303', '193', '76');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('304', '193', '77');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('305', '193', '78');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('306', '193', '79');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('307', '193', '80');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('308', '193', '81');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('309', '193', '82');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('310', '193', '83');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('311', '193', '84');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('312', '193', '85');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('313', '193', '86');
INSERT INTO public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion") VALUES ('314', '193', '87');



--
-- Data for Name: Grado; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) (INSERT statements)
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('7', 'Preparatorio', 'Estudios Iniciales', 'Iniciación para niños de 7 y 8 años', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('8', '1er Año', 'Componente General', '1er año del componente general de danza', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('9', '2do Año', 'Componente General', '2do año del componente general de danza', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('10', '3er Año', 'Componente General', '3er año del componente general de danza', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('11', '4to Año', 'Componente General', '4to año del componente general de danza', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('12', '5to Año - Danza Clásica', 'Componente Especializado', '5to año especialidad Danza Clásica', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('13', '6to Año - Danza Clásica', 'Componente Especializado', '6to año especialidad Danza Clásica', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('14', '7mo Año - Danza Clásica', 'Componente Especializado', '7mo año especialidad Danza Clásica', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('15', '8vo Año - Danza Clásica', 'Componente Especializado', '8vo año especialidad Danza Clásica', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('16', '5to Año - Danza Tradicional', 'Componente Especializado', '5to año especialidad Danza Tradicional', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('17', '6to Año - Danza Tradicional', 'Componente Especializado', '6to año especialidad Danza Tradicional', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('18', '7mo Año - Danza Tradicional', 'Componente Especializado', '7mo año especialidad Danza Tradicional', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('19', '8vo Año - Danza Tradicional', 'Componente Especializado', '8vo año especialidad Danza Tradicional', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('20', '5to Año - Danza Contemporánea', 'Componente Especializado', '5to año especialidad Danza Contemporánea', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('21', '6to Año - Danza Contemporánea', 'Componente Especializado', '6to año especialidad Danza Contemporánea', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('22', '7mo Año - Danza Contemporánea', 'Componente Especializado', '7mo año especialidad Danza Contemporánea', 't', '2026-08-26 03:08:57.769491');
INSERT INTO public."Grado" ("Id_grado", nombre_grado, nivel, descripcion, activo, creado_en) VALUES ('23', '8vo Año - Danza Contemporánea', 'Componente Especializado', '8vo año especialidad Danza Contemporánea', 't', '2026-08-26 03:08:57.769491');



--
-- Data for Name: Historial_Medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) (INSERT statements)
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('105', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('106', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('107', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('108', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('109', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('110', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('111', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('112', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('113', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('114', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('115', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('116', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('117', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('118', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('119', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('120', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('121', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('122', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('123', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('124', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('125', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('126', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('127', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('128', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('129', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('130', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('131', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('132', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('133', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('134', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('135', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('136', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('137', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('138', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('139', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('140', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('141', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('142', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('143', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('144', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('145', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('146', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('147', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('148', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('149', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('150', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('151', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('152', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('153', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('154', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('155', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('156', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('157', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('158', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('159', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('160', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('161', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('162', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('163', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('164', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('165', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('166', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('167', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('168', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('169', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('170', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('171', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('172', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('173', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('174', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('175', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('176', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('177', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('178', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('179', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('180', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('181', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('182', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('183', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('184', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('185', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('186', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('187', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('188', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('189', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('190', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('191', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('192', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('193', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('194', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('195', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('196', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('197', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('198', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('199', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('200', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('201', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('202', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('203', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('204', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('205', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('206', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('207', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('208', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('209', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('210', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('211', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('212', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('213', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('214', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('215', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('216', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('217', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('218', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('219', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('220', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('221', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('222', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('223', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('224', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('225', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('226', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('227', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('228', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('229', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('230', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('231', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('232', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('233', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('234', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('235', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('236', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('237', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('238', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('239', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('240', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('241', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('242', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('243', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('244', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('245', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('246', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('247', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('248', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('249', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('250', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('251', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('252', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('253', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('254', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('255', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('256', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('257', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('258', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('259', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('260', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('261', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('262', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('263', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('264', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('265', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('266', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('267', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('268', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('269', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('270', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('271', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('272', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('273', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('274', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('275', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('276', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('277', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('278', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('279', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('280', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('281', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('282', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('283', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('284', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('285', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('286', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('287', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('288', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('289', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('290', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('291', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('292', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('293', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('294', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('295', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('296', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('297', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('298', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('299', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('300', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('301', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('302', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('303', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('304', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('305', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('306', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('307', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('308', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('309', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('310', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('311', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('312', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('313', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('314', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('315', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('316', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('317', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('318', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('319', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('320', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('321', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('322', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('323', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('324', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('325', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('326', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('327', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('328', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('329', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('330', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('331', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('332', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('333', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('334', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('335', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('336', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('337', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('338', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('339', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('340', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('341', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('342', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('343', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('344', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('345', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('346', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('347', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('348', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('349', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('350', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('351', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('352', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('353', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('354', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('355', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('356', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('357', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('358', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('359', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('360', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('361', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('362', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('363', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('364', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('365', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('366', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('367', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('368', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('369', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('370', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('371', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('372', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('373', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('374', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('375', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('376', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('377', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('378', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('379', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('380', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('381', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('382', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('383', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('384', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('385', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('386', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('387', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('388', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('389', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('390', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('391', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('392', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('393', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('394', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('395', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('396', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('397', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('398', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('399', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('400', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('401', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('402', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('403', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('404', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('405', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('406', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('407', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('408', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('409', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('410', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('411', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('412', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('413', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('414', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('415', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('416', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('417', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('418', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('419', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('420', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('421', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('422', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('423', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('424', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('425', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('426', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('427', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('428', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('429', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('430', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('431', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('432', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('433', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('434', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('435', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('436', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('437', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('438', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('439', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('440', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('441', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('442', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('443', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('444', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('445', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('446', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('447', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('448', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('449', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('450', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('451', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('452', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('453', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('454', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('455', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('456', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('457', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('458', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('459', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('460', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('461', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('462', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('463', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('464', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('465', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('466', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('467', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('468', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('469', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('470', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('471', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('472', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('473', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('474', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('475', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('476', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('477', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('478', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('479', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('480', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('481', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('482', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('483', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('484', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('485', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('486', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('487', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('488', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('489', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('490', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('491', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('492', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('493', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('494', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('495', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('496', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('497', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('498', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('499', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('500', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('501', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('502', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('503', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('504', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('505', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('506', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('507', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('508', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('509', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('510', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('511', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('512', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('513', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('514', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('515', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('516', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('517', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('518', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('519', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('520', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('521', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('522', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('523', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('524', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('525', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('526', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('527', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('528', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('529', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('530', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('531', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('532', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('533', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('534', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('535', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('536', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('537', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('538', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('539', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('540', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('541', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('542', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('543', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('544', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('545', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('546', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('547', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('548', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('549', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('550', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('551', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('552', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('553', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('554', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('555', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('556', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('557', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('558', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('559', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('560', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('561', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('562', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('563', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('564', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('565', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('566', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('567', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('568', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');
INSERT INTO public."Historial_Medico" ("Id_historial", peso_kg, altura_m, intolerancia_comida, descripcion_intolerancia, dolores_frecuentes, estrenimiento_frecuente, tiene_cirugia, descripcion_cirugia, control_hormonal, descripcion_hormonal, tiene_alergias, descripcion_alergias, antecedentes_familiares, termino_nacimiento) VALUES ('569', NULL, NULL, 'f', NULL, 'f', 'f', 'f', NULL, 'f', NULL, 'f', NULL, NULL, 'A TERMINO');



--
-- Data for Name: Horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Horario" ("Id_horario", "Id_seccion", "Id_aula", "Id_profesor", "Id_bloque", "Id_dia") (INSERT statements)



--
-- Data for Name: Incidencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Incidencia" ("Id_incidencia", tipo_incidencia, descripcion, fecha_incidencia, "Id_estudiante", "Id_usuario_involucrado", "Id_usuario_reporta") (INSERT statements)



--
-- Data for Name: Lapso; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") (INSERT statements)
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('1', 'I LAPSO', '2026-09-15', '2026-12-15', '1');
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('2', 'II LAPSO', '2027-01-10', '2027-04-05', '1');
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('3', 'III LAPSO', '2027-04-15', '2027-07-15', '1');
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('4', 'I LAPSO', '2025-09-15', '2025-12-15', '3');
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('5', 'II LAPSO', '2026-01-10', '2026-04-05', '3');
INSERT INTO public."Lapso" ("Id_lapso", nombre_lapso, inicio_lapso, fin_lapso, "Id_ano") VALUES ('6', 'III LAPSO', '2026-04-15', '2026-07-15', '3');



--
-- Data for Name: Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) (INSERT statements)
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('1', 'Iniciación a la Danza', '7', 'practica', '2', 'A través de la plástica, la música y juegos');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('2', 'Danza Tradicional', '7', 'practica', '1', 'Bailes y juegos tradicionales');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('3', 'Preparación Física', '7', 'practica', '1', 'Desarrollo de condiciones físicas iniciales');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('4', 'Música', '7', 'teorica', '1', 'Impartida de manera teórica y práctica (lúdica)');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('5', 'Danza Clásica', '8', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('6', 'Danza Tradicional', '8', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('7', 'Danza Creativa', '8', 'practica', '2', 'Enfocada a fortalecer la asignatura Danza Contemporánea');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('8', 'Música', '8', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('9', 'Preparación Física', '8', 'practica', '1', 'Con asesoría nutricional');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('10', 'Francés 1', '8', 'teorica', '1', 'Código universal dentro de la danza clásica');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('11', 'Danza Clásica', '9', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('12', 'Danza Tradicional', '9', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('13', 'Danza Creativa', '9', 'practica', '2', 'Enfocada a fortalecer Danza Contemporánea');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('14', 'Música', '9', 'teorica', '2', 'Hora de 60 minutos');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('15', 'Preparación Física', '9', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('16', 'Historia de la Danza', '9', 'teorica', '1', 'Seminario durante el año escolar');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('17', 'Francés 2', '9', 'teorica', '1', 'Taller al final de cada trimestre');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('18', 'Nutrición', '9', 'teorica', '1', 'Taller al final de cada trimestre');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('19', 'Danza Clásica', '10', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('20', 'Danza Tradicional', '10', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('21', 'Danza Contemporánea', '10', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('22', 'Música', '10', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('23', 'Preparación Física', '10', 'practica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('24', 'Historia de la Danza', '10', 'teorica', '1', 'Seminario durante el año escolar');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('25', 'Francés', '10', 'teorica', '1', 'Taller al final de cada trimestre');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('26', 'Nutrición', '10', 'teorica', '1', 'Taller al final de cada trimestre');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('27', 'Danza Clásica', '11', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('28', 'Danza Tradicional', '11', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('29', 'Danza Contemporánea', '11', 'practica', '6', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('30', 'Música', '11', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('31', 'Preparación Física', '11', 'practica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('32', 'Repertorio Clásico', '11', 'teorico-practica', '1', 'Teórico-práctica');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('33', 'Repertorio Tradicional', '11', 'teorico-practica', '1', 'Teórico-práctica');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('34', 'Repertorio Contemporáneo', '11', 'teorico-practica', '1', 'Teórico-práctica');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('35', 'Danza Clásica', '12', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('36', 'Danza Tradicional', '12', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('37', 'Danza Contemporánea', '12', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('38', 'Historia de la Danza', '12', 'teorica', '1', 'Enfocada a la especialidad');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('39', 'Repertorio', '12', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('40', 'Composición Coreográfica', '12', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('41', 'Kinesiología', '12', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('42', 'Danza Clásica', '13', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('43', 'Danza Tradicional', '13', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('44', 'Danza Contemporánea', '13', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('45', 'Historia de la Danza', '13', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('46', 'Repertorio', '13', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('47', 'Composición Coreográfica', '13', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('48', 'Pas de deux', '13', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('49', 'Danzas de Carácter', '13', 'practica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('50', 'Danza Clásica', '14', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('51', 'Danza Tradicional', '14', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('52', 'Danza Contemporánea', '14', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('53', 'Repertorio', '14', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('54', 'Pas de deux', '14', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('55', 'Producción Escénica', '14', 'teorico-practica', '2', 'Taller');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('56', 'Danzas de Carácter', '14', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('57', 'Danza Clásica', '15', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('58', 'Danza Tradicional', '15', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('59', 'Danza Contemporánea', '15', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('60', 'Repertorio', '15', 'practica', '5', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('61', 'Proyecto Comunitario', '15', 'teorico-practica', '4', '40 horas distribuidas en el año escolar');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('62', 'Integración Artística - Profesional', '15', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('63', 'Danza Tradicional', '16', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('64', 'Danza Clásica', '16', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('65', 'Danza Contemporánea', '16', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('66', 'Teoría de la Cultura', '16', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('67', 'Indumentaria, Elementos e Imágenes Populares', '16', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('68', 'Kinesiología', '16', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('69', 'Elementos del Teatro para la Danza Tradicional', '16', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('70', 'Apreciación Musical', '16', 'teorica', '1', 'Aplicada a la especialidad');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('71', 'Preparación Física', '16', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('72', 'Danza Tradicional', '17', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('73', 'Danza Clásica', '17', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('74', 'Danza Contemporánea', '17', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('75', 'Historia de las Tradiciones Venezolanas', '17', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('76', 'Indumentaria, Elementos e Imágenes Populares', '17', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('77', 'Elementos del Teatro para la Danza Tradicional', '17', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('78', 'Apreciación Musical', '17', 'teorica', '1', 'Aplicada a la especialidad');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('79', 'Preparación Física', '17', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('80', 'Danza Tradicional', '18', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('81', 'Danza Clásica', '18', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('82', 'Danza Contemporánea', '18', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('83', 'Danza Latinoamericana y Caribeña', '18', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('84', 'Historia de las Tradiciones Venezolanas', '18', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('85', 'Indumentaria, Elementos e Imágenes Populares', '18', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('86', 'Elementos del Teatro para la Danza Tradicional', '18', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('87', 'Apreciación Musical', '18', 'teorica', '1', 'Aplicada a la especialidad');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('88', 'Producción Artística', '18', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('89', 'Danza Tradicional', '19', 'practica', '10', 'Producción artística');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('90', 'Danza Clásica', '19', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('91', 'Danza Contemporánea', '19', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('92', 'Danza Latinoamericana y Caribeña', '19', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('93', 'Historia de las Tradiciones Venezolanas', '19', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('94', 'Análisis de la Proyección de la Danza Tradicional en Venezuela', '19', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('95', 'Proyecto Comunitario', '19', 'teorico-practica', '4', '40 horas distribuidas en el año escolar');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('96', 'Integración Artística - Profesional', '19', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('97', 'Danza Contemporánea', '20', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('98', 'Danza Tradicional', '20', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('99', 'Danza Clásica', '20', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('100', 'Historia y Precursores de la Danza Contemporánea', '20', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('101', 'Preparación Física', '20', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('102', 'Composición Coreográfica', '20', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('103', 'Kinesiología', '20', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('104', 'Música', '20', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('105', 'Danza Contemporánea', '21', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('106', 'Danza Tradicional', '21', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('107', 'Danza Clásica', '21', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('108', 'Preparación Física', '21', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('109', 'Composición Coreográfica', '21', 'practica', '3', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('110', 'Música', '21', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('111', 'Danza Contemporánea', '22', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('112', 'Danza Tradicional', '22', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('113', 'Danza Clásica', '22', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('114', 'Preparación Física', '22', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('115', 'Historia y Precursores de la Danza Contemporánea en Venezuela', '22', 'teorica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('116', 'Composición Coreográfica', '22', 'practica', '4', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('117', 'Producción Escénica', '22', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('118', 'Técnicas Aplicadas a la Danza Contemporánea', '22', 'practica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('119', 'Danza Contemporánea', '23', 'practica', '10', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('120', 'Danza Tradicional', '23', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('121', 'Danza Clásica', '23', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('122', 'Preparación Física', '23', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('123', 'Repertorio Contemporáneo', '23', 'practica', '5', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('124', 'Técnicas Aplicadas a la Danza Contemporánea', '23', 'practica', '1', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('125', 'Proyecto Comunitario', '23', 'teorico-practica', '4', '40 horas distribuidas en el año escolar');
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('126', 'Integración Artística - Profesional', '23', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('127', 'Música', '17', 'teorica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('128', 'Producción Escénica', '17', 'teorico-practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('129', 'Composición Coreográfica', '14', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('130', 'Preparación Física', '14', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('131', 'Preparación Física', '18', 'practica', '2', NULL);
INSERT INTO public."Materia" ("Id_materia", nombre_materia, ano_materia, tipo_materia, horas_semanales, observaciones) VALUES ('132', 'Preparación Física', '15', 'practica', '2', NULL);



--
-- Data for Name: Municipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Municipio" ("Id_municipio", "Id_estado", nombre_municipio) (INSERT statements)



--
-- Data for Name: Nivel_Danza; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) (INSERT statements)
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('6', 'Preparatorio');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('7', '1er Año');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('8', '2do Año');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('9', '3er Año');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('10', '4to Año');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('11', '5to Año - Danza Clásica');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('12', '6to Año - Danza Clásica');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('13', '7mo Año - Danza Clásica');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('14', '8vo Año - Danza Clásica');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('15', '5to Año - Danza Tradicional');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('16', '6to Año - Danza Tradicional');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('17', '7mo Año - Danza Tradicional');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('18', '8vo Año - Danza Tradicional');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('19', '5to Año - Danza Contemporánea');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('20', '6to Año - Danza Contemporánea');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('21', '7mo Año - Danza Contemporánea');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('22', '8vo Año - Danza Contemporánea');
INSERT INTO public."Nivel_Danza" ("Id_nivel_danza", nivel_danza) VALUES ('25', 'Pre-Ballet');



--
-- Data for Name: Nivel_Escolar; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Nivel_Escolar" ("Id_nivel", nivel) (INSERT statements)



--
-- Data for Name: Nota_Competencia_Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Nota_Competencia_Estudiante" ("Id_estudiante_competencia", puntaje, observacion, "Id_nota", "Id_competencia") (INSERT statements)



--
-- Data for Name: Padre; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Padre" ("Id_padre", nombre, apellido, cedula, profesion_padre, direccion_trabajo_padre, telefono) (INSERT statements)



--
-- Data for Name: Pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Pais" ("Id_pais", nombre_pais) (INSERT statements)



--
-- Data for Name: Parroquia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Parroquia" ("Id_parroquia", "Id_municipio", nombre_parroquia) (INSERT statements)



--
-- Data for Name: Periodo_Inscripcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Periodo_Inscripcion" ("Id_periodo_inscripcion", "Id_ano", fecha_inicio, fecha_fin, activo, creado_en, actualizado_en) (INSERT statements)



--
-- Data for Name: Periodo_Subida_Notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Periodo_Subida_Notas" ("Id_periodo_notas", "Id_ano", fecha_inicio, fecha_fin, activo, creado_en, actualizado_en) (INSERT statements)



--
-- Data for Name: Profesor; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Profesor" ("Id_profesor", especialidad, "Id_usuario") (INSERT statements)
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('1', 'Personal de apoyo', '2');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('2', 'Danza Clásica, Preparación Física', '3');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('3', 'Danza Tradicional, Preparación Física', '5');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('4', 'Personal de apoyo', '6');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('5', 'COORDINADORA ADMINISTRATIVA', '7');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('6', 'Danza Clásica, Preparación Física, Francés', '10');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('7', 'Danza Tradicional', '12');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('8', 'Personal de apoyo', '15');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('9', 'Danza Contemporánea', '16');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('10', 'Danza Clásica, Preparación Física', '17');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('11', 'Danza Tradicional', '20');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('12', 'Danza Clásica, Repertorio Danza Clásica', '21');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('13', 'Danza Clásica', '23');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('14', 'Danza Contemporánea, Repertorio Contemporáneo', '24');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('15', 'Danza Contemporánea', '25');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('16', 'Música', '26');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('17', 'Música', '27');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('18', 'Danza Contemporánea', '28');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('19', 'Danza Creativa, Danza Contemporánea, Composición Coreográfica, Preparación Física', '30');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('20', 'Personal de apoyo', '2');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('21', 'Danza Clásica, Preparación Física', '3');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('22', 'Danza Tradicional, Preparación Física', '5');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('23', 'Personal de apoyo', '6');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('24', 'COORDINADORA ADMINISTRATIVA', '7');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('25', 'Preparación Física, Iniciación a la Danza, Danza de Carácter', '8');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('26', 'Danza Clásica, Preparación Física, Francés', '10');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('27', 'Danza Tradicional, Danza Latinoamericana, Preparación Física', '11');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('28', 'Danza Tradicional', '12');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('29', 'Danza Tradicional, Historia de la Danza, Historia de la Danza Contemporánea, Historia de los Precursores de la Danza Contemporánea, Indumentaria y elementos de la Danza Tradicional', '13');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('30', 'Nutrición, Kinesiología (y control de peso y talla)', '14');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('31', 'Personal de apoyo', '15');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('32', 'Danza Contemporánea', '16');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('33', 'Danza Clásica, Preparación Física', '17');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('34', 'Danza Tradicional', '20');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('35', 'Danza Clásica, Repertorio Danza Clásica', '21');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('36', 'Danza Clásica, Repertorio Clásico, Preparación Física', '22');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('37', 'Danza Clásica', '23');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('38', 'Danza Contemporánea, Repertorio Contemporáneo', '24');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('39', 'Danza Contemporánea', '25');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('40', 'Música', '26');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('41', 'Música', '27');
INSERT INTO public."Profesor" ("Id_profesor", especialidad, "Id_usuario") VALUES ('42', 'Danza Contemporánea', '28');



--
-- Data for Name: Profesor_Especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Profesor_Especialidad" ("Id_profesor_especialidad", "Id_profesor", "Id_especialidad", "Id_ano", fecha_asignacion, activo) (INSERT statements)



--
-- Data for Name: Profesor_Grado; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Profesor_Grado" ("Id_profesor", "Id_grado", fecha_asignacion, activo, "Id_ano") (INSERT statements)



--
-- Data for Name: Profesor_Materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Profesor_Materia" ("Id_profesor", "Id_materia") (INSERT statements)



--
-- Data for Name: Representante; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") (INSERT statements)
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('67', 't', NULL, NULL, '125');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('68', 't', NULL, NULL, '126');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('69', 't', NULL, NULL, '127');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('70', 't', NULL, NULL, '128');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('71', 't', NULL, NULL, '129');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('72', 't', NULL, NULL, '130');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('73', 't', NULL, NULL, '131');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('74', 't', NULL, NULL, '132');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('75', 't', NULL, NULL, '133');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('76', 't', NULL, NULL, '134');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('77', 't', NULL, NULL, '135');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('78', 't', NULL, NULL, '136');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('79', 't', NULL, NULL, '137');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('80', 't', NULL, NULL, '138');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('81', 't', NULL, NULL, '139');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('82', 't', NULL, NULL, '140');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('83', 't', NULL, NULL, '141');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('84', 't', NULL, NULL, '142');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('85', 't', NULL, NULL, '143');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('86', 't', NULL, NULL, '144');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('87', 't', NULL, NULL, '145');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('88', 't', NULL, NULL, '146');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('89', 't', NULL, NULL, '147');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('90', 't', NULL, NULL, '148');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('91', 't', NULL, NULL, '149');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('92', 't', NULL, NULL, '150');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('93', 't', NULL, NULL, '151');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('94', 't', NULL, NULL, '152');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('95', 't', NULL, NULL, '153');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('96', 't', NULL, NULL, '154');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('97', 't', NULL, NULL, '155');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('98', 't', NULL, NULL, '156');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('99', 't', NULL, NULL, '157');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('100', 't', NULL, NULL, '158');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('101', 't', NULL, NULL, '159');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('102', 't', NULL, NULL, '160');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('103', 't', NULL, NULL, '161');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('104', 't', NULL, NULL, '162');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('105', 't', NULL, NULL, '163');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('106', 't', NULL, NULL, '164');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('107', 't', NULL, NULL, '165');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('108', 't', NULL, NULL, '166');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('109', 't', NULL, NULL, '167');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('110', 't', NULL, NULL, '168');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('111', 't', NULL, NULL, '169');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('112', 't', NULL, NULL, '170');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('113', 't', NULL, NULL, '171');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('114', 't', NULL, NULL, '172');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('115', 't', NULL, NULL, '173');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('116', 't', NULL, NULL, '174');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('117', 't', NULL, NULL, '175');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('118', 't', NULL, NULL, '176');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('119', 't', NULL, NULL, '177');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('120', 't', NULL, NULL, '178');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('121', 't', NULL, NULL, '179');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('122', 't', NULL, NULL, '180');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('123', 't', NULL, NULL, '181');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('124', 't', NULL, NULL, '182');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('125', 't', NULL, NULL, '183');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('126', 't', NULL, NULL, '184');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('127', 't', NULL, NULL, '185');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('128', 't', NULL, NULL, '186');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('129', 't', NULL, NULL, '187');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('130', 't', NULL, NULL, '188');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('131', 't', NULL, NULL, '189');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('132', 't', NULL, NULL, '190');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('133', 't', NULL, NULL, '191');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('134', 't', NULL, NULL, '192');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('135', 't', NULL, NULL, '193');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('136', 't', NULL, NULL, '194');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('137', 't', NULL, NULL, '195');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('138', 't', NULL, NULL, '196');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('139', 't', NULL, NULL, '197');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('140', 't', NULL, NULL, '198');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('141', 't', NULL, NULL, '199');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('142', 't', NULL, NULL, '200');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('143', 't', NULL, NULL, '201');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('144', 't', NULL, NULL, '202');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('145', 't', NULL, NULL, '203');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('146', 't', NULL, NULL, '204');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('147', 't', NULL, NULL, '205');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('148', 't', NULL, NULL, '206');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('149', 't', NULL, NULL, '207');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('150', 't', NULL, NULL, '208');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('151', 't', NULL, NULL, '209');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('152', 't', NULL, NULL, '210');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('153', 't', NULL, NULL, '211');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('154', 't', NULL, NULL, '212');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('155', 't', NULL, NULL, '213');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('156', 't', NULL, NULL, '214');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('157', 't', NULL, NULL, '215');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('158', 't', NULL, NULL, '216');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('159', 't', NULL, NULL, '217');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('160', 't', NULL, NULL, '218');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('161', 't', NULL, NULL, '219');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('162', 't', NULL, NULL, '220');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('163', 't', NULL, NULL, '221');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('164', 't', NULL, NULL, '222');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('165', 't', NULL, NULL, '223');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('166', 't', NULL, NULL, '224');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('167', 't', NULL, NULL, '225');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('168', 't', NULL, NULL, '226');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('169', 't', NULL, NULL, '227');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('170', 't', NULL, NULL, '228');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('171', 't', NULL, NULL, '229');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('172', 't', NULL, NULL, '230');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('173', 't', NULL, NULL, '231');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('174', 't', NULL, NULL, '232');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('175', 't', NULL, NULL, '233');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('176', 't', NULL, NULL, '234');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('177', 't', NULL, NULL, '235');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('178', 't', NULL, NULL, '236');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('179', 't', NULL, NULL, '237');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('180', 't', NULL, NULL, '238');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('181', 't', NULL, NULL, '239');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('182', 't', NULL, NULL, '240');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('183', 't', NULL, NULL, '241');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('184', 't', NULL, NULL, '242');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('185', 't', NULL, NULL, '243');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('186', 't', NULL, NULL, '244');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('187', 't', NULL, NULL, '245');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('188', 't', NULL, NULL, '246');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('189', 't', NULL, NULL, '247');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('190', 't', NULL, NULL, '248');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('191', 't', NULL, NULL, '249');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('192', 't', NULL, NULL, '250');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('193', 't', NULL, NULL, '251');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('194', 't', NULL, NULL, '252');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('195', 't', NULL, NULL, '253');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('196', 't', NULL, NULL, '254');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('197', 't', NULL, NULL, '255');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('198', 't', NULL, NULL, '256');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('199', 't', NULL, NULL, '257');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('200', 't', NULL, NULL, '258');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('201', 't', NULL, NULL, '259');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('202', 't', NULL, NULL, '260');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('203', 't', NULL, NULL, '261');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('204', 't', NULL, NULL, '262');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('205', 't', NULL, NULL, '263');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('206', 't', NULL, NULL, '264');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('207', 't', NULL, NULL, '265');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('208', 't', NULL, NULL, '266');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('209', 't', NULL, NULL, '267');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('210', 't', NULL, NULL, '268');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('211', 't', NULL, NULL, '269');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('212', 't', NULL, NULL, '270');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('213', 't', NULL, NULL, '271');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('214', 't', NULL, NULL, '272');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('215', 't', NULL, NULL, '273');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('216', 't', NULL, NULL, '274');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('217', 't', NULL, NULL, '275');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('218', 't', NULL, NULL, '276');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('219', 't', NULL, NULL, '277');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('220', 't', NULL, NULL, '278');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('221', 't', NULL, NULL, '279');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('222', 't', NULL, NULL, '280');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('223', 't', NULL, NULL, '281');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('224', 't', NULL, NULL, '282');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('225', 't', NULL, NULL, '283');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('226', 't', NULL, NULL, '284');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('227', 't', NULL, NULL, '285');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('228', 't', NULL, NULL, '286');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('229', 't', NULL, NULL, '287');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('230', 't', NULL, NULL, '288');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('231', 't', NULL, NULL, '289');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('232', 't', NULL, NULL, '290');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('233', 't', NULL, NULL, '291');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('234', 't', NULL, NULL, '292');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('235', 't', NULL, NULL, '293');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('236', 't', NULL, NULL, '294');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('237', 't', NULL, NULL, '295');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('238', 't', NULL, NULL, '296');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('239', 't', NULL, NULL, '297');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('240', 't', NULL, NULL, '298');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('241', 't', NULL, NULL, '299');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('242', 't', NULL, NULL, '300');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('243', 't', NULL, NULL, '301');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('244', 't', NULL, NULL, '302');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('245', 't', NULL, NULL, '303');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('246', 't', NULL, NULL, '304');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('247', 't', NULL, NULL, '305');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('248', 't', NULL, NULL, '306');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('249', 't', NULL, NULL, '307');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('250', 't', NULL, NULL, '308');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('251', 't', NULL, NULL, '309');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('252', 't', NULL, NULL, '310');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('253', 't', NULL, NULL, '311');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('254', 't', NULL, NULL, '312');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('255', 't', NULL, NULL, '313');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('256', 't', NULL, NULL, '314');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('257', 't', NULL, NULL, '315');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('258', 't', NULL, NULL, '316');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('259', 't', NULL, NULL, '317');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('260', 't', NULL, NULL, '318');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('261', 't', NULL, NULL, '319');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('262', 't', NULL, NULL, '320');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('263', 't', NULL, NULL, '321');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('264', 't', NULL, NULL, '322');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('265', 't', NULL, NULL, '323');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('266', 't', NULL, NULL, '324');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('267', 't', NULL, NULL, '325');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('268', 't', NULL, NULL, '326');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('269', 't', NULL, NULL, '327');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('270', 't', NULL, NULL, '328');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('271', 't', NULL, NULL, '329');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('272', 't', NULL, NULL, '330');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('273', 't', NULL, NULL, '331');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('274', 't', NULL, NULL, '332');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('275', 't', NULL, NULL, '333');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('276', 't', NULL, NULL, '334');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('277', 't', NULL, NULL, '335');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('278', 't', NULL, NULL, '336');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('279', 't', NULL, NULL, '337');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('280', 't', NULL, NULL, '338');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('281', 't', NULL, NULL, '339');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('282', 't', NULL, NULL, '340');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('283', 't', NULL, NULL, '341');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('284', 't', NULL, NULL, '342');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('285', 't', NULL, NULL, '343');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('286', 't', NULL, NULL, '344');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('287', 't', NULL, NULL, '345');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('288', 't', NULL, NULL, '346');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('289', 't', NULL, NULL, '347');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('290', 't', NULL, NULL, '348');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('291', 't', NULL, NULL, '349');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('292', 't', NULL, NULL, '350');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('293', 't', NULL, NULL, '351');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('294', 't', NULL, NULL, '352');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('295', 't', NULL, NULL, '353');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('296', 't', NULL, NULL, '354');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('297', 't', NULL, NULL, '355');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('298', 't', NULL, NULL, '356');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('299', 't', NULL, NULL, '357');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('300', 't', NULL, NULL, '358');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('301', 't', NULL, NULL, '359');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('302', 't', NULL, NULL, '360');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('303', 't', NULL, NULL, '361');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('304', 't', NULL, NULL, '362');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('305', 't', NULL, NULL, '363');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('306', 't', NULL, NULL, '364');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('307', 't', NULL, NULL, '365');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('308', 't', NULL, NULL, '366');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('309', 't', NULL, NULL, '367');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('310', 't', NULL, NULL, '368');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('311', 't', NULL, NULL, '369');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('312', 't', NULL, NULL, '370');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('313', 't', NULL, NULL, '371');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('314', 't', NULL, NULL, '372');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('315', 't', NULL, NULL, '373');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('316', 't', NULL, NULL, '374');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('317', 't', NULL, NULL, '375');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('318', 't', NULL, NULL, '376');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('319', 't', NULL, NULL, '377');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('320', 't', NULL, NULL, '378');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('321', 't', NULL, NULL, '379');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('322', 't', NULL, NULL, '380');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('323', 't', NULL, NULL, '381');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('324', 't', NULL, NULL, '382');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('325', 't', NULL, NULL, '383');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('326', 't', NULL, NULL, '384');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('327', 't', NULL, NULL, '385');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('328', 't', NULL, NULL, '386');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('329', 't', NULL, NULL, '387');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('330', 't', NULL, NULL, '388');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('331', 't', NULL, NULL, '389');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('332', 't', NULL, NULL, '390');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('333', 't', NULL, NULL, '391');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('334', 't', NULL, NULL, '392');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('335', 't', NULL, NULL, '393');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('336', 't', NULL, NULL, '394');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('337', 't', NULL, NULL, '395');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('338', 't', NULL, NULL, '396');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('339', 't', NULL, NULL, '397');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('340', 't', NULL, NULL, '398');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('341', 't', NULL, NULL, '399');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('342', 't', NULL, NULL, '400');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('343', 't', NULL, NULL, '401');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('344', 't', NULL, NULL, '402');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('345', 't', NULL, NULL, '403');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('346', 't', NULL, NULL, '404');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('347', 't', NULL, NULL, '405');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('348', 't', NULL, NULL, '406');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('349', 't', NULL, NULL, '407');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('350', 't', NULL, NULL, '408');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('351', 't', NULL, NULL, '409');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('352', 't', NULL, NULL, '410');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('353', 't', NULL, NULL, '411');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('354', 't', NULL, NULL, '412');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('355', 't', NULL, NULL, '413');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('356', 't', NULL, NULL, '414');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('357', 't', NULL, NULL, '415');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('358', 't', NULL, NULL, '416');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('359', 't', NULL, NULL, '417');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('360', 't', NULL, NULL, '418');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('361', 't', NULL, NULL, '419');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('362', 't', NULL, NULL, '420');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('363', 't', NULL, NULL, '421');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('364', 't', NULL, NULL, '422');
INSERT INTO public."Representante" ("Id_representante", es_familiar, profesion_rep, direccion_trabajo_rep, "Id_usuario") VALUES ('365', 't', NULL, NULL, '423');



--
-- Data for Name: Rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Rol" ("Id_rol", tipo_rol) (INSERT statements)
INSERT INTO public."Rol" ("Id_rol", tipo_rol) VALUES ('1', 'Administrador');
INSERT INTO public."Rol" ("Id_rol", tipo_rol) VALUES ('2', 'Docente');
INSERT INTO public."Rol" ("Id_rol", tipo_rol) VALUES ('3', 'Estudiante');
INSERT INTO public."Rol" ("Id_rol", tipo_rol) VALUES ('4', 'Representante');
INSERT INTO public."Rol" ("Id_rol", tipo_rol) VALUES ('5', 'Secretaria');



--
-- Data for Name: Seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") (INSERT statements)
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('1', 'C', '30', '72', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('2', 'C', '30', '72', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('3', 'C', '30', '72', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('4', 'C', '30', '74', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('5', 'C', '30', '74', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('6', 'C', '30', '74', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('7', 'C', '30', '73', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('8', 'C', '30', '73', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('9', 'C', '30', '73', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('10', 'C', '30', '79', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('11', 'C', '30', '79', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('12', 'C', '30', '79', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('13', 'C', '30', '75', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('14', 'C', '30', '75', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('15', 'C', '30', '127', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('16', 'C', '30', '127', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('17', 'C', '30', '128', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('18', 'C', '30', '128', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('19', 'A', '30', '50', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('20', 'A', '30', '50', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('21', 'A', '30', '50', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('22', 'A', '30', '52', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('23', 'A', '30', '52', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('24', 'A', '30', '52', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('25', 'A', '30', '51', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('26', 'A', '30', '51', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('27', 'A', '30', '51', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('28', 'A', '30', '53', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('29', 'A', '30', '53', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('30', 'A', '30', '53', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('31', 'A', '30', '129', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('32', 'A', '30', '129', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('33', 'A', '30', '130', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('34', 'A', '30', '130', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('35', 'A', '30', '130', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('36', 'A', '30', '55', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('37', 'A', '30', '55', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('38', 'B', '30', '111', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('39', 'B', '30', '111', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('40', 'B', '30', '111', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('41', 'B', '30', '113', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('42', 'B', '30', '113', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('43', 'B', '30', '113', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('44', 'B', '30', '112', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('45', 'B', '30', '112', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('46', 'B', '30', '112', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('47', 'B', '30', '116', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('48', 'B', '30', '116', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('49', 'B', '30', '114', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('50', 'B', '30', '114', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('51', 'B', '30', '114', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('52', 'B', '30', '115', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('53', 'B', '30', '115', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('54', 'C', '30', '80', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('55', 'C', '30', '80', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('56', 'C', '30', '80', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('57', 'C', '30', '82', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('58', 'C', '30', '82', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('59', 'C', '30', '82', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('60', 'C', '30', '81', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('61', 'C', '30', '81', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('62', 'C', '30', '81', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('63', 'C', '30', '83', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('64', 'C', '30', '83', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('65', 'C', '30', '83', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('66', 'C', '30', '84', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('67', 'C', '30', '84', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('68', 'C', '30', '88', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('69', 'C', '30', '88', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('70', 'C', '30', '131', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('71', 'C', '30', '131', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('72', 'C', '30', '131', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('73', 'A', '30', '57', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('74', 'A', '30', '57', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('75', 'A', '30', '57', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('76', 'A', '30', '59', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('77', 'A', '30', '59', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('78', 'A', '30', '59', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('79', 'A', '30', '58', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('80', 'A', '30', '58', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('81', 'A', '30', '58', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('82', 'A', '30', '60', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('83', 'A', '30', '60', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('84', 'A', '30', '60', '6', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('85', 'A', '30', '132', '4', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('86', 'A', '30', '132', '5', '3');
INSERT INTO public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano") VALUES ('87', 'A', '30', '132', '6', '3');



--
-- Data for Name: Seguro; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Seguro" ("Id_seguro", tipo_seguro) (INSERT statements)



--
-- Data for Name: Solicitud_Constancia; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Solicitud_Constancia" ("Id_solicitud", tipo_constancia, fecha_solicitud, estatus, "Id_estudiante", "Id_representante") (INSERT statements)



--
-- Data for Name: Tipo_Clase; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) (INSERT statements)
INSERT INTO public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) VALUES ('1', 'Práctica');
INSERT INTO public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) VALUES ('2', 'Teórica');
INSERT INTO public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) VALUES ('3', 'Teórico-Práctica');
INSERT INTO public."Tipo_Clase" ("Id_tipo_clase", nombre_tipo_clase) VALUES ('4', 'Común / Usos Múltiples');



--
-- Data for Name: Tipo_Evaluacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Tipo_Evaluacion" ("Id_tipo_evaluacion", nombre_evaluacion) (INSERT statements)
INSERT INTO public."Tipo_Evaluacion" ("Id_tipo_evaluacion", nombre_evaluacion) VALUES ('2', 'Evaluación de Lapso');



--
-- Data for Name: Usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) (INSERT statements)
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('1', 'V-00000000', 'Admin', 'Sistema', '$2b$10$STfSKjxp05CLMG2HqU9VMe3YpN9D5Bfz//NAiY0y3KDL6GQ6q83/i', NULL, 'admin@endanza.com', NULL, NULL, NULL, 'Activo', NULL, '2026-07-29 14:12:52.963497-04', '1', NULL, 'admin', NULL, NULL, NULL, NULL, NULL, 'f', '2026-07-29 14:12:52.963497', NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('2', 'V-9248324', 'VILMAN OMAR', 'CARRERO MALDONADO', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'vilman.carrero8324@endanza.com', '1968-12-13', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'vilman8324', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('3', 'V-29830107', 'MARIETH FERNANDA', 'DEVIA ESCALANTE', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'marieth.devia0107@endanza.com', '2002-01-21', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'marieth0107', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('4', 'V-15080054', 'SABRINA DE LOS ANGELES', 'FLORES PINEDA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'sabrina.flores0054@endanza.com', '1980-09-29', NULL, NULL, 'Activo', NULL, NULL, '1', NULL, 'sabrina0054', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('5', 'V-25980485', 'BETANIA DE LOS ÁNGELES', 'GARCÍA VIVAS', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'betania.garcia0485@endanza.com', '1997-01-26', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'betania0485', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('6', 'V-14179269', 'YELITZA ROSALIA', 'GUERRERO GUERRERO', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'yelitza.guerrero9269@endanza.com', '1977-11-02', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'yelitza9269', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('7', 'V-6810884', 'LOPEZ GISELA ILNELU', 'JACKSON DE', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'lopez.jackson0884@endanza.com', '1963-01-19', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'lopez0884', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('8', 'V-30617219', 'VALERIA SOFÍA', 'OJEDA ZAMBRANO', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'valeria.ojeda7219@endanza.com', '2004-08-20', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'valeria7219', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('9', 'V-5674902', 'RAMÍREZ ROSA EMILIA', 'PERNÍA DE', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'ramirez.pernia4902@endanza.com', '1963-08-30', NULL, NULL, 'Activo', NULL, NULL, '1', NULL, 'ramirez4902', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('10', 'V-28195359', 'PAOLA MAYELLA', 'RICO PORRAS', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'paola.rico5359@endanza.com', '2001-10-02', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'paola5359', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('11', 'V-20121208', 'ADRIANA SARAI', 'RUIZ VIVAS', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'adriana.ruiz1208@endanza.com', '1992-04-10', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'adriana1208', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('12', 'V-19915196', 'ALVARO RENNIER', 'SOLANO VARELA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'alvaro.solano5196@endanza.com', '1989-05-30', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'alvaro5196', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('13', 'V-3911521', 'WILFREDO', 'TERÁN', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'wilfredo.teran1521@endanza.com', '1950-09-20', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'wilfredo1521', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('14', 'V-7304367', 'IVETTE DEL CARMEN', 'TOVAR DOMINGUEZ', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'ivette.tovar4367@endanza.com', '1961-05-30', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'ivette4367', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('15', 'V-12112581', 'LINDA', 'VADILLO ADA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'linda.vadillo2581@endanza.com', '1977-12-17', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'linda2581', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('16', 'V-31122871', 'VANESSA CAROLINA', 'VILLASMIL MATA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'vanessa.villasmil2871@endanza.com', '2006-01-23', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'vanessa2871', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('17', 'V-29830219', 'SARAH VALENTINA', 'ZAMBRANO GUERRERO', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'sarah.zambrano0219@endanza.com', '2002-01-23', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'sarah0219', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('18', 'V-12351245', 'ANA LETICIA', 'ZAMBRANO PÉREZ', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'ana.zambrano1245@endanza.com', '1975-08-02', NULL, NULL, 'Activo', NULL, NULL, '5', NULL, 'ana1245', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('19', 'V-10169482', 'PARRA CONSUELO', 'TRIVIÑO DE', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'parra.trivino9482@endanza.com', '1954-01-02', NULL, NULL, 'Activo', NULL, NULL, '5', NULL, 'parra9482', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('20', 'V-32610676', 'ARIANNA NICOLLE', 'AMAYA RAMÍREZ', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'arianna.amaya0676@endanza.com', '2008-02-01', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'arianna0676', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('22', 'V-30890719', 'CAMILY AMARANTA', 'CÁCERES LEAL', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'camily.caceres0719@endanza.com', '2004-10-11', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'camily0719', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('23', 'V-31762867', 'MARÍA LAURA', 'CASTRO HART', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'maria.castro2867@endanza.com', '2006-06-16', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'maria2867', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('24', 'V-27239670', 'DANIELA', 'DÍAZ ALIX', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'daniela.diaz9670@endanza.com', '2000-04-04', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'daniela9670', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('25', 'V-26403133', 'ROSELBI PAOLA', 'GARCÍA COLMENARES', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'roselbi.garcia3133@endanza.com', '1998-06-16', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'roselbi3133', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('26', 'V-30626110', 'HANNA', 'RAMOS', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'hanna.ramos6110@endanza.com', '2004-12-30', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'hanna6110', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('27', 'V-30296992', 'JOSÉ', 'ROA MARÍA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'jose.roa6992@endanza.com', '2002-04-02', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'jose6992', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('28', 'V-30981792', 'VALERIA', 'URBINA PERNÍA', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'valeria.urbina1792@endanza.com', '2004-12-11', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'valeria1792', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('29', 'V-11504462', 'JENNICE FIORELLA', 'ZAMBRANO SÁNCHEZ', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'jennice.zambrano4462@endanza.com', '1974-12-07', NULL, NULL, 'Activo', NULL, NULL, '5', NULL, 'jennice4462', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('30', 'V-25020014', 'NIKAILA CLISMAR', 'CASTELLANOS ALVIAREZ', '$2b$10$qPRR220D.GcHgLT6WdCRe.PlJVWXsYXEVqFTB7ROBam0dGHXbMT3.', NULL, 'nikaila.castellanos0014@endanza.com', '1996-01-09', NULL, NULL, 'Activo', NULL, NULL, '2', NULL, 'nikaila0014', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('21', 'V-30523907', 'JULIETH FERNANDA', 'BELEÑO SANDOVAL', '$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O', NULL, 'julieth.beleno3907@endanza.com', '2003-10-13', NULL, NULL, 'Activo', NULL, '2026-07-29 14:20:47.793605-04', '2', NULL, 'julieth3907', NULL, NULL, NULL, NULL, NULL, 'f', '2026-07-29 14:20:47.793605', NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('125', NULL, 'DIANA CAROLINA', 'GALLO CARDENAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247040216', 'diannakarolinna@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'diannakarolinna', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('126', NULL, 'DAYANA ANDREINA', 'RIVERA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04266715655', 'azulrivera23@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'azulrivera23', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('127', NULL, 'LORENA', 'BECERRA ORTIZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04127135648', 'pigmentacion_correctiva@yahoo.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'pigmentacion_correctiva', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('128', NULL, 'SURLEY', 'SANGUINO CASERES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7185063', 'surley1979@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'surley1979', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('129', NULL, 'MERLY ANDREINA', 'RAMÍREZ MARTÍNEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7197060', 'merlyramirez665@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'merlyramirez665', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('130', NULL, 'MAYRALEJA28 ALEJANDRA', 'HERNÁNDEZ BARRIOS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147005848', 'mayra.adriam@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mayra.adriam', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('131', NULL, 'MARIAN DAYL', 'PRIETO CARDENAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247614816', 'mprieto4782@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mprieto4782', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('132', NULL, 'JOHANA LISBETH', 'RODRIGUEZ SIERRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-9713190', 'joharod2005@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'joharod2005', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('133', NULL, 'YOSAIRA', 'SARCIA RUJANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247132268', 'yosairagarcia1218@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yosairagarcia1218', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('134', NULL, 'MARIA YESENIA', 'RAMIREZ SANTANA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04265775956', 'yesyanth20@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yesyanth20', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('135', NULL, 'MARIA ANDREINA', 'PULIDO ANGARITA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247427831', 'andre.pulido19@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'andre.pulido19', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('136', NULL, 'MARIA ANDREINA', 'PULIDO ANGARITA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247427831', 'andre.pulido@19gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'andre.pulido', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('137', NULL, 'LUCILA CORORMOTO', 'NAVA CARRILLO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247031672', 'lucynava78@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lucynava78', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('138', NULL, 'LUCILA COROMOTO', 'NAVAS CARRILLO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '02763940798', 'lucynavas@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lucynavas', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('139', NULL, 'FRANGGY KRISELL', 'BECERRA MONSALVE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147214989', 'franggykbm@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'franggykbm', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('140', NULL, 'CAROLINA', 'COLMENARES VILLAMIZAR', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247841874', 'carolinacolmenares85@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'carolinacolmenares85', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('253', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_198@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_198', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('141', NULL, 'JUDITH VIZAY', 'RUÍZ MORALES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121323645', 'judithvizay@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'judithvizay', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('142', NULL, 'LISBETH', 'CAÑAS MENDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247241707', 'molro23@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'molro23', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('143', NULL, 'LISBETH', 'CAÑAS MENDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247241707', 'rep_27@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_27', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('144', NULL, 'GREGORIANA DEL CARMEN', 'PERNIA DE BORRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147366645', 'krmnpe6@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'krmnpe6', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('145', NULL, 'RUBI ROSSANA', 'RUIZ SALCEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121432266', 'rubi2ruiz@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rubi2ruiz', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('146', NULL, 'NANCY TERESA', 'ESCALANTE CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7733672', 'nancyescalante1598@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nancyescalante1598', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('147', NULL, 'INGRID SOLANYI', 'VIVAS RUBIANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147407986', 'ingridvivasr@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ingridvivasr', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('148', NULL, 'ROSA MARIA', 'JARA DE CARRIEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247285750', 'yencycarriedo@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yencycarriedo', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('149', NULL, 'ERIKA CONSOLACION', 'RAMIREZ SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247030646', 'erikaconsolacion1977@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'erikaconsolacion1977', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('150', NULL, 'OLIEVAN YELENA', 'CONTRAMAESTRE HERNANDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247477675', 'aneley1908@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'aneley1908', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('151', NULL, 'AURA TERESA', 'JAIMES DE MERCHAN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247145318', 'aurajaimes74@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'aurajaimes74', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('152', NULL, 'CELIA', 'RAMIREZ DE KYRIMLKOGLOU', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04120627190', 'alekokyri@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'alekokyri', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('153', NULL, 'MARÍA HERCILIA', 'QUIROZ RINCÓN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416-2788129 / 0424-7848083', 'mariaherciliaquiroz@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mariaherciliaquiroz', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('154', NULL, 'GLORIA ESPERANZA', 'GELVEZ SANDOVAL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161730878', 'gloriae.gelvezs@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gloriae.gelvezs', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('155', NULL, 'KAREN MICHELL', 'VIVAS VILLAMIZAR', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247050412', 'karmichell17@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karmichell17', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('156', NULL, 'YUDBEIDA JOSEFINA', 'FERNANDEZ RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247166710', 'yudbeidafernandez@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yudbeidafernandez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('157', NULL, 'ZAIDA YOLIMAR', 'RICO GUERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147169314', 'zaidarico56@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'zaidarico56', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('158', NULL, 'ROBERTO DAVID', 'COLMENARES CELIS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147406327', 'davidcolmenarescelis@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'davidcolmenarescelis', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('159', NULL, 'FELIDA DEL CARMEN', 'RAMIREZ ARAQUE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04164764303', 'felida16378989@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'felida16378989', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('160', NULL, 'VIANA CAROLINA', 'RODRIGUEZ APARICIO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147081919', 'vianarodrigueza@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'vianarodrigueza', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('161', NULL, 'CLAREM ROSALIA', 'RANGEL OSTOS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247815908', 'lbsbacademica@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lbsbacademica', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('162', NULL, 'CARMEN ALICIA', 'CONTRERAS RICO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 1757710', 'rep_63@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_63', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('163', NULL, 'CARMEN ALICIA', 'CONTRERAS RICO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141757710', 'adrigene2@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'adrigene2', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('164', NULL, 'DORIS', 'GOMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7523086', 'sirodgomez@gmaillcom', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sirodgomez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('165', NULL, 'SIARIS YADELSI', 'CRISPIN HERNANDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04127510392', 'siaris.crispin29@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'siaris.crispin29', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('166', NULL, 'JESSICA ALEJANDRA', 'BECERRA MOLINA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04146977764', 'jessica.molina.jr@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jessica.molina.jr', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('167', NULL, 'BEYSI CORINA', 'ZAMBRANO PARRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04129018718 / 04147400946', 'beysi2017@gmailcom', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'beysi2017', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('168', NULL, 'SANDRA PATRICIA', 'VILLAMIZAR ACOSTA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424 7735060', 'oriana.villamizar08@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'oriana.villamizar08', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('169', NULL, 'AURA STELLA', 'CHACON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04160488550', 'auramora062@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'auramora062', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('170', NULL, 'CLAUDIA MARGARITA', 'TOSCANO DUARTE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04120695323', 'claudia0169@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'claudia0169', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('171', NULL, 'GENESIS KATHERINE', 'NEIRA REYES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7446705', 'genesisneira29@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'genesisneira29', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('172', NULL, 'RINA JOSEFINA', 'LEAL RIVERA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147265972', 'rina.26mily@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rina.26mily', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('173', NULL, 'KARLA NACARY', 'RODRIGYEZSAYAGO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04160723794', 'karlanacary1984@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karlanacary1984', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('174', NULL, 'SANDRA COROMOTO', 'SILVA MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147129846', 'rep_81@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_81', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('175', NULL, 'BRIGITTE SAMIRELLY', 'CONTRERAS URIBE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04143744333', 'bcontreras3088@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'bcontreras3088', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('176', NULL, 'SONIA', 'DELGADO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247619594', 'sonia69delgado@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sonia69delgado', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('177', NULL, 'EDWARD', 'HERNANDEZ SANDIA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04149778559', 'sandiae1987@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sandiae1987', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('178', NULL, 'MARIA JOSE', 'TORRES AGELVIS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247677671', 'mariajta1994@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mariajta1994', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('179', NULL, 'TANIA ISLEY', 'REVERÓN CHACÓN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04249299457', 'taniadeporte@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'taniadeporte', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('180', NULL, 'YELITZA ROSALIA', 'GUERRERO GUERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04125219690', 'yelirosalia77@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yelirosalia77', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('181', NULL, 'ROSALEJANDRA', 'CAMPOS MARTINES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-9710555', 'soyalejandra06@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'soyalejandra06', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('182', NULL, 'ADRIANA SOLMAR', 'OLIVARES DE VIDAL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247635289', 'adrianaolivares.danza@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'adrianaolivares.danza', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('183', NULL, 'MARLON BRANDO', 'DIAZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247696160', 'marlonbrando.0910@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'marlonbrando.0910', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('184', NULL, 'DEYRDRE ALEXANDRA', 'CONTRERAS DE DIAZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140361691', 'deyrdrealexandra@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'deyrdrealexandra', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('185', NULL, 'ANGELICA TIBISAY', 'SANCHEZ PEREIRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247086290', 'angeliktibisay1210@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'angeliktibisay1210', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('186', NULL, 'EVELYN NATALIA', 'MERCHAN NAVARRRO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7525645', 'eve_cami2.014@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'eve_cami2.014', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('187', NULL, 'ADELA JOSEFINA', 'GONZÁLEZ MUÑOZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04261720982', 'adelagonzalez123@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'adelagonzalez123', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('188', NULL, 'NETHYA NEDSAY', 'QUINAYAS BEDOYA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121048123', 'nethynedsay@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nethynedsay', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('189', NULL, 'FLOR YEANETH', 'ROJAS PRIETO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147303233', 'flor_rojasdetorres@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'flor_rojasdetorres', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('190', NULL, 'CARMEN', 'MONCADA GÁMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140793543', 'neya_mg@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'neya_mg', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('191', NULL, 'YOSELIN LILIBETH', 'PEÑA GELVES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7494934', 'yosecris348@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yosecris348', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('192', NULL, 'MARITZA AURORA', 'DELGADO VILLAMIL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04263700578', 'maride2702@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'maride2702', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('193', NULL, 'ANA LETICIA', 'ZAMBRANO PÉREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04163773835', 'analeticiazambrano@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'analeticiazambrano', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('194', NULL, 'NEYDA MARITZA', 'CONTRERAS DE MONTAÑA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147149882', 'neydamaritza@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'neydamaritza', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('195', NULL, 'YERY COROMOTO', 'SANGUINO PARADA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0426-4283334', 'alejandroyery@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'alejandroyery', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('196', NULL, 'HUGO DANIEL', 'MONCADA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04166712782', 'hudamo13@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'hudamo13', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('197', NULL, 'NANCY MELANIA', 'CHACON LOBO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147394988', 'nancyarq12@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nancyarq12', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('198', NULL, 'JADRYN MACBELLA', 'HERNÁNDEZ DE LA CRUZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04244931844', 'jadryn10@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jadryn10', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('199', NULL, 'JADRYN MACBELLA', 'HERNANDEZ DE LA CRUZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247089888', 'inversionesnamasteim@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'inversionesnamasteim', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('200', NULL, 'CARMEN GLORIA', 'CONTRERAS CHACÓN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247251390', 'karmen147@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karmen147', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('201', NULL, 'KARLA LORENA', 'JIMÉNEZ DÍAZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', NULL, 'kljd1902@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'kljd1902', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('202', NULL, 'AMANDA BANIGZA', 'LAGUADO OLIVEROS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04243444151', 'banigzalaguado03@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'banigzalaguado03', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('203', NULL, 'YOLIMAR DEL VALLE', 'RAMIREZ SUESCUN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147194042', 'yramirezsuescun@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yramirezsuescun', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('204', NULL, 'DIOMILEY', 'DELGADO RAMÌREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161355546', 'diomyd@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'diomyd', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('205', NULL, 'DARCY YULITZA', 'CONTRERAS DE GELVES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147473279', 'darcycontreras0817@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'darcycontreras0817', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('206', NULL, 'ELIANA PAOLA', 'TORRES ORTEGA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247049848', 'eliana_0120@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'eliana_0120', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('207', NULL, 'HECLED', 'RUIZ LOPEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-0451678', 'ruizhecled@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ruizhecled', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('208', NULL, 'GILMA YANETH', 'ARDILA LOZADA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247328878', 'victorbaron1945@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'victorbaron1945', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('209', NULL, 'PAOLA MAYERLIN', 'OSTOS SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141753660', 'paolaostos129@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'paolaostos129', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('210', NULL, 'PAOLA MAYERLYN', 'OSTOS SÁNCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147585808', 'rep_137@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_137', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('211', NULL, 'JULIANA KARINA', 'COLMENARES CHACON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147499755', 'julianakary2710@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'julianakary2710', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('212', NULL, 'ELDA JUDITH', 'MANRIQUE ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04149744936', 'ejmz69@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ejmz69', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('213', NULL, 'OLEYDA CECILIA', 'GUERRERO RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247665881', 'oleydac@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'oleydac', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('214', NULL, 'LEONARD ALFREDO', 'APONTE NAVEDA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0426-1667426', 'leonard.aponte@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'leonard.aponte', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('215', NULL, 'JOSE JOEL', 'CAMARGO FLORES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147871395', 'josejoecamargo@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'josejoecamargo', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('216', NULL, 'ALIX', 'DELGADO HERNÁNDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '+58 414-7926527', 'arolena22@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'arolena22', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('217', NULL, 'RAÚL ENRIQUE', 'GÓMEZ MORALES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247830959', 'r.e.gomez@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'r.e.gomez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('218', NULL, 'ANGELA YELITZA', 'CHACON VERA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121052585', 'angelayeli9@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'angelayeli9', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('219', NULL, 'LUZ DAISSY', 'HERRERA OVALLE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247224141', 'luzherrera906@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luzherrera906', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('220', NULL, 'ARELIS', 'CASTRO DE DUQUE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04245147037', 'arelishermana@yahoo.es', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'arelishermana', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('221', NULL, 'ARELIS', 'CASTRO DE DUQUE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04245147037', 'rep_152@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_152', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('222', NULL, 'EVA YOLEIZA', 'RODRIGUEZ ALVIAREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04241977112', 'evvita.24@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'evvita.24', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('223', NULL, 'FABIO', 'LEON BOAVITA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412 6642621', 'micabraandina@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'micabraandina', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('224', NULL, 'KAREN', 'RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147124472', 'kramanda@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'kramanda', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('225', NULL, 'LISBEY', 'LOPEZ CALDERON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247389864', 'lopez_lisbey@yahoo.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lopez_lisbey', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('226', NULL, 'INGRID YUSMARY', 'FREITES SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247742600', 'franajufre17@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'franajufre17', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('227', NULL, 'FRANCISCO JAVIER', 'MÁRQUEZ NIÑO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121241008', 'franciscomark1969@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'franciscomark1969', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('228', NULL, 'BELKIS', 'REY RANGEL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147158092', 'belkisreyrangel@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'belkisreyrangel', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('229', NULL, 'LIZ MARY', 'ZAMBRANO GUERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04124749010', 'zambranoguerrerolizmary@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'zambranoguerrerolizmary', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('230', NULL, 'ANA LUCIA', 'VELAZCO CAICEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141755184', 'velazcoana26@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'velazcoana26', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('231', NULL, 'ANA LUCIA', 'VELAZCO CAICEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141755184', 'rep_165@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_165', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('232', NULL, 'LYZZETTE KATHERINNE', 'URIBE PORTILLA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147578963', 'kateuribe@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'kateuribe', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('233', NULL, 'GRECSYS ALEXANDRA', 'RAMIREZ LANTEN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7060718', 'grelan29@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'grelan29', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('234', NULL, 'LIGIA GABRIELA', 'BALLESTEROS DE RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 - 4085485', 'gsarahi2014@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gsarahi2014', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('235', NULL, 'ALBERTO JAVIER', 'AMAYA ALARCON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7130843', 'javieramaya3838@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'javieramaya3838', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('236', NULL, 'LELIS YANIRA', 'GUERRERO GIERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04163761031', 'lelisguerrero@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lelisguerrero', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('237', NULL, 'LUISANA', 'POLANCO AGUILAR', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247629352', 'luisana.ocnalop@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luisana.ocnalop', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('238', NULL, 'CARMEN YULEYMA', 'RICO GUERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7465154', 'yuricota25@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yuricota25', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('239', NULL, 'ALBANY YAJAIRA', 'GARNICA VARGAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147146239', 'albanys05@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'albanys05', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('240', NULL, 'MARIELY CAROLINA', 'CALDERÓN TORRES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147574098', 'marielycalderontorres@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'marielycalderontorres', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('241', NULL, 'IRWIN EDUARDO', 'OSTOS CASTRO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247516961', 'irwinostos02@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'irwinostos02', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('242', NULL, 'LUZ MARINA', 'ESTEVES CANCHICA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147206539', 'anyuritacruz@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'anyuritacruz', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('243', NULL, 'MARIA JOSEFA', 'SANDOVAL RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7363713', 'mariita182011@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mariita182011', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('244', NULL, 'MAFER ISABEL', 'MENDEZ GOMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-7671616', 'hasbelymafer22@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'hasbelymafer22', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('245', NULL, 'LUIS DAYAN', 'PRATO ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140362630', 'hannaduque26@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'hannaduque26', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('246', NULL, 'LENYS NOHEMI', 'FUENTES VERA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04167789416', 'fuentesveral@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'fuentesveral', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('247', NULL, 'FANNY YORLEY', 'CARDENAS PEREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7441408', 'fannyycardenas@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'fannyycardenas', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('248', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_193@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_193', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('249', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_194@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_194', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('250', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_195@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_195', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('251', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_196@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_196', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('252', NULL, 'LINDA', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147109191', 'rep_197@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_197', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('254', NULL, 'OSCAR VIDAL', 'MONSALVE VILLAMIZAR', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247833575', 'rep_199@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_199', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('255', NULL, 'VALESKA', 'VILLAMIZAR CASANOVA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247025098', 'vvillamizar@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'vvillamizar', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('256', NULL, 'VALESKA', 'VILLAMIZAR CASANOVA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147023016', 'vvilamizar@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'vvilamizar', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('257', NULL, 'DOLLY ROSMARY', 'MOGOLLON QUIROS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147295082', 'rosmarymq@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rosmarymq', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('258', NULL, 'BELKIS DEL CARMEN', 'REY RANGEL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7158092', 'belkisreyrangel25@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'belkisreyrangel25', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('259', NULL, 'MARIA DANIELA', 'BLANCO GAMBACICA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7020344', 'raach83@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'raach83', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('260', NULL, 'LEIDY PAOLA', 'RUEDA SUAREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247614778', 'idielpao@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'idielpao', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('261', NULL, 'VIGLEDYS MARIA', 'SALAS LOPEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247431052', 'vigledys2013@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'vigledys2013', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('262', NULL, 'KENIA ALEXANDRA', 'ESCOBAR CHACON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04121050503', 'keniaescobar76@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'keniaescobar76', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('263', NULL, 'MARIA TERESA', 'MOGROVEJO DE ONTIVEROS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-2379446', 'mariet241.matm@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mariet241.matm', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('264', NULL, 'ISNEY ANGELY', 'NOGUERA RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247099686', 'rep_214@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_214', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('265', NULL, 'ZOREIDY DEL CARMEN', 'PEREZ PEREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247213305', 'rep_215@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_215', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('266', NULL, 'LISBETH DEL CARMEN', 'BERMUDEZ MOLINA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247195801', 'bermudelisbeth@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'bermudelisbeth', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('267', NULL, 'ODALIS YAIDERLIN', 'SANDOVAL DE LACRUZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247032362', 'odalis_ysandoval@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'odalis_ysandoval', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('268', NULL, 'SANDRA SIRLEY', 'PLATA SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-7043079', 'sandrasplatas@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sandrasplatas', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('269', NULL, 'MAYLIN GIOVANNA', 'DÍAZ DE RAMÍREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247422684', 'giovannamdv@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'giovannamdv', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('270', NULL, 'DESIREE TIBANA', 'MONTERO PORRAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147330447', 'tibanamontero@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'tibanamontero', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('271', NULL, 'YORKIS JHOSIMAR', 'TRESPALACIOS CASTELLANOS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04169447630 / 04126677630', 'jessigabriela2010@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jessigabriela2010', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('272', NULL, 'GENNY LAIDY', 'CHACON LOBO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247054276', 'gennychlobo@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gennychlobo', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('273', NULL, 'CIRA MARIA', 'JIMENEZ CAMEJO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04126422328', 'cjimenezcamejo@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'cjimenezcamejo', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('274', NULL, 'CENOBIA', 'ASANIO LIZARAZO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04149749705', 'julianaperezimasc@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'julianaperezimasc', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('275', NULL, 'NURIS DEL PILAR', 'CARRILLO DE FORERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416-1399606', 'nurjuli2009@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nurjuli2009', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('276', NULL, 'ANDREÍNA LISBETH', 'SANDOVAL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247742127', 'andreinasandobal@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'andreinasandobal', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('277', NULL, 'GUILLERMO ALEXANDER', 'PEREZ AMADO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147032113', 'aperezamado@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'aperezamado', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('278', NULL, 'ELIZABETH ANDREINA', 'ACEVEDO DE MUÑOZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147340218', 'kerenysara@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'kerenysara', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('279', NULL, 'AVENDAÑO ZAMBRANO', 'AVENDAÑO ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147067897', 'yaritzaeliza@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yaritzaeliza', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('280', NULL, 'BELKIS ZULAY', 'VARGAS TARAZONA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 7043234', 'belkisvargas_27@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'belkisvargas_27', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('281', NULL, 'SULGEY EMERY', 'COLMENARES BENITEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416 6746543', 'sulgeycc@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sulgeycc', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('282', NULL, 'MARIA ALEJANDRA', 'RODRIGUEZ TERAN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141771590', 'maria.rodriguezt@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'maria.rodriguezt', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('283', NULL, 'STEPHANIE LISSET', 'MARQUEZ CASTRO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147128800', 'marquez.ste25051989@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'marquez.ste25051989', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('284', NULL, 'KAREN ANDREA', 'SALAZAR ACEVEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247634094', 'karen_40417@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karen_40417', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('285', NULL, 'ELEIDYS AMPARO', 'FRANCISCONY', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141757808', 'elefran07@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'elefran07', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('286', NULL, 'LORENA ELIZABETH', 'HARMS BECERRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-0826912', 'lorenaharms@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lorenaharms', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('287', NULL, 'LORENA ELIZABETH', 'HARMS BECERRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140826912', 'lorenaharmis@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lorenaharmis', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('288', NULL, 'ELEIDYS AMPARO', 'FRANCISCONY', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414/1757808', 'eleidysfranciscony2@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'eleidysfranciscony2', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('289', NULL, 'NELLY XIOMARA', 'CARO PÉREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04160708300', 'nellyximaracaro@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nellyximaracaro', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('290', NULL, 'MAGGLY KATHERINE', 'SANCHEZ CASIQUE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147232505', 'maggly-sanchez@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'maggly-sanchez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('291', NULL, 'MARISABEL', 'BASTO DIAZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04120726453', 'kissmary19@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'kissmary19', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('292', NULL, 'EDGLIS THAMARA', 'MORALES RODRIGUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147408737', 'thammy0721@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'thammy0721', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('293', NULL, 'SAIDA YAQUELIN', 'MORENO ROJAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 7234084', 'saidamoreno27@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'saidamoreno27', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('294', NULL, 'BLANCA', 'VARGAS ROA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140368459', 'blancavargas25@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'blancavargas25', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('295', NULL, 'MADRE', 'MADRE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', NULL, 'rep_263@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_263', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('296', NULL, 'MADRE', 'MADRE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', NULL, 'rep_264@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_264', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('297', NULL, 'RICHARD JOSE', 'SANCHEZ MENDOZA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7008776', 'richardjose2910@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'richardjose2910', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('298', NULL, 'KAREN FERNANDA', 'GOMEZ QUIJANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7535310', 'karenfer9301@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karenfer9301', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('299', NULL, 'MARIA VICTORIA', 'CONTRERAS DE GIRALDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247355791', 'mary00747@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mary00747', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('300', NULL, 'MARIA VICTORIA', 'CONTRERAS CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247355791', 'maritoya0747@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'maritoya0747', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('301', NULL, 'ELVIA LISBETH', 'ROJAS RANGEL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140762190', 'rojaselvia29@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rojaselvia29', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('302', NULL, 'MAIDE', 'CARDENAS BARRAGAN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7545643', 'maidecardenas12@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'maidecardenas12', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('303', NULL, 'RAMON JOSE GREGORIO', 'MANRIQUE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-2101142', 'ramonjosegregorio@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ramonjosegregorio', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('304', NULL, 'YERIT BANETZA', 'GANDICA CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04265755506', 'yeritgandica@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yeritgandica', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('305', NULL, 'KARLA CONSOLACION', 'BECERRA DE ESCALANTE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247610387', 'karlabm2011@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karlabm2011', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('306', NULL, 'SULEIMA TIBISAY', 'MORENO NUÑEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140763639', 'suleimatibisay@yahoo.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'suleimatibisay', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('307', NULL, 'XIMENA LEONIDES MARÍA', 'FERNÁNDEZ CUADROS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247122258', 'ximenama1976@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ximenama1976', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('308', NULL, 'NIRIAN KATERINE', 'ESCALANTE MANOSALVA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247849415', 'mariajosealberto82@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mariajosealberto82', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('309', NULL, 'CARLA ANDREINA', 'HERRERA ARAUJO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147003893', 'tiacalita2006@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'tiacalita2006', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('310', NULL, 'GREISSY LORENA', 'PACHECO BETANCOURT', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247035440', 'pachecogreissy0@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'pachecogreissy0', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('311', NULL, 'LUZ MAYELA', 'HART ORTEGA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7083421', 'mayehart@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mayehart', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('312', NULL, 'CARMEN VICTORIA', 'BOHORQUEZ ORTIZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247234187', 'bohorquezcarmen1985@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'bohorquezcarmen1985', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('313', NULL, 'NIDYAM LISSETTE', 'ORTIZ RAMÓN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 7544911', 'lissette2920@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lissette2920', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('314', NULL, 'MARIA DEL MAR', 'CONTRERAS PEREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247228076', 'marimarcontr.mc@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'marimarcontr.mc', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('315', NULL, 'ANNY DEYANIRA', 'GONZALEZ TAPIA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416-502600', 'ad.gonzaleztapia@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ad.gonzaleztapia', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('316', NULL, 'KEILA JACKELINE', 'OCHOA URDANETA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7603302', 'keilaochoa421@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'keilaochoa421', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('317', NULL, 'KEILA JACKELINE', 'OCHOA URDANETA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247603302', 'keila421@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'keila421', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('318', NULL, 'MARIA GREGORIA', 'LABRADOR GARCIA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147375056', 'labradormg@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'labradormg', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('319', NULL, 'MAYRA LISETH', 'GONZALEZ ACEVEDO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161396932', 'mayraliset.g05@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mayraliset.g05', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('320', NULL, 'PAOLA', 'SILVA RODRIGUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-7136728', 'paolasilva22@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'paolasilva22', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('321', NULL, 'SARA VIRGINIA', 'FERNÁNDEZ DE GARCÍA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147180526', 'saritafer.sf@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'saritafer.sf', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('322', NULL, 'AGNY MECADILET', 'BUENAÑO RIOS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147065930', 'agny_mecadilet@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'agny_mecadilet', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('323', NULL, 'MARIA MILAGROS', 'SUAREZ SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247844207', 'eclipse_1678@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'eclipse_1678', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('324', NULL, 'JOSEFA DAMARIS', 'BOADA BAYONA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147094981', 'damarisboada932@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'damarisboada932', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('325', NULL, 'DAYSI MAGALLI', 'RAMIREZ PEÑALVER', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7720721', 'dmrami@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'dmrami', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('326', NULL, 'GAUDYS YUSBELIA', 'GUERRERO ANGARITA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147403957', 'gaudysguerrero4@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gaudysguerrero4', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('327', NULL, 'LEONARDO ANTONIO', 'ABREU ROMERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147113837', 'mgdevenezuela@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mgdevenezuela', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('328', NULL, 'LEONARDO ANTONIO', 'ABREU ROMERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147113837', 'labreuromero@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'labreuromero', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('329', NULL, 'REINA LUCERO', 'ROJAS URREA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247695214', 'lic_lucerito@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lic_lucerito', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('330', NULL, 'SHEYLA M', 'GUIRAL A', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247022770', 'sheylaguiral77@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sheylaguiral77', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('331', NULL, 'LILIANA', 'SUÁREZ ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140759302', 'lilianasuarezoficial@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lilianasuarezoficial', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('332', NULL, 'ANA VERONICA', 'ESCALANTE SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247261011', 'anaescalante.0678@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'anaescalante.0678', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('333', NULL, 'ERIKA JOHANNA', 'SANCHEZ SANCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147004665', 'erikajohanasanchezs@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'erikajohanasanchezs', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('334', NULL, 'ANGEL GABRIEL', 'GUERRA GUERRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 9797819', 'elcastigadorfiat@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'elcastigadorfiat', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('335', NULL, 'CARMEN GUADALUPE', 'CONTRERAS DE MARQUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147122861', 'guadalupecontrerasmora@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'guadalupecontrerasmora', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('336', NULL, 'GLADYMAR DEL CARMEN', 'REY DE RAMIREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04143764083', 'gladymar@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gladymar', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('337', NULL, 'IRIS JOSELINE', 'URBINA CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247013473', 'irisurbina1986@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'irisurbina1986', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('338', NULL, 'LUDDY VIVIANA', 'ÁNGEL AGELVIZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 241 43 25', 'luddyangel@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luddyangel', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('339', NULL, 'LUDDY ANGEL', 'ANGEL AGELVIZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414-2414325', 'luddyabgel18@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luddyabgel18', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('340', NULL, 'LUDDY VIVIANA', 'ANGEL AGELVIZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04142414325', 'luddyangel18@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luddyangel18', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('341', NULL, 'ZULIMAR', 'HERNÁNDEZ MÉNDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247122228', 'rep_334@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_334', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('342', NULL, 'ZULIMAR', 'HERNÁNDEZ MÉNDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247122228', 'rep_335@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_335', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('343', NULL, 'ZULIMAR', 'HERNÁNDEZ MENDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247122228', 'zulimarhernandez.38@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'zulimarhernandez.38', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('344', NULL, 'YELIX ANDREINA', 'SANDOVAL PACHECO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247147419', 'andreinasandov@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'andreinasandov', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('345', NULL, 'DEISSY MARIBEL', 'ALVIAREZ CHACON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7452087', 'deissyalviarezanthonella@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'deissyalviarezanthonella', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('346', NULL, 'LILY YOHANA', 'VILLALOBOS PEÑA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247266728', 'rep_340@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_340', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('347', NULL, 'LILY YOHANA', 'VILLALOBOS PEÑA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247266728', 'salomemelany24@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'salomemelany24', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('348', NULL, 'LILY YOHANA', 'VILLALOBOS PEÑA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-6520725', 'escorpionyoyita@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'escorpionyoyita', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('349', NULL, 'CLAUDIA LORENA', 'DAVILA DE TORRES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147396856', 'davilalorena20@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'davilalorena20', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('350', NULL, 'DYANE MEREDITH', 'RAMÍREZ DE PACHECO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', NULL, 'ingdyaneramirez@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ingdyaneramirez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('351', NULL, 'KATIUSKA YASMIN', 'MANOSALVA DE RUGELES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424 7591604', 'katiuskamanosalva@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'katiuskamanosalva', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('352', NULL, 'SANDRA YANETH', 'PEREZ BENITEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247601996', 'sandra2magp@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sandra2magp', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('353', NULL, 'JOSE ANTONIO', 'SUAREZ VIVAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147439602', 'tisi2322@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'tisi2322', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('354', NULL, 'LISBETH LUCILA', 'ROMÁN GUZMÁN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147040653', 'lisbyroman@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lisbyroman', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('392', NULL, 'GERSON', 'NIÑO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '02763569482', 'rep_417@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_417', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('355', NULL, 'NAYLA AZUCENA', 'MOLINA MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04166765758', 'nayla4172@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'nayla4172', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('356', NULL, 'KEILA MIRLADY', 'PULIDO CHACON', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141762093', 'keilapulido@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'keilapulido', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('357', NULL, 'AMPARO COROMOTO', 'BUITRAGO ABREU', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161396893', 'amparob18@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'amparob18', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('358', NULL, 'MAGLYS KARIM', 'GUTIERREZ MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247092181', 'ramaen.ca@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ramaen.ca', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('359', NULL, 'MAKERLY BRICETH', 'BONILLA BECERRA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147093025', 'makerlybriceth@yahoo.es', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'makerlybriceth', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('360', NULL, 'LISBETH YADIRA', 'DUARTE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04264723449', 'lisbethyadira23i@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lisbethyadira23i', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('361', NULL, 'LISBETH YADIRA', 'DUARTE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04164723449', 'lisbethduarte33nj@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lisbethduarte33nj', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('362', NULL, 'ASTRID KARINA', 'MONSALVE CARRILLO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140361037', 'astridkarina@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'astridkarina', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('363', NULL, 'JESSICA MAYELYN', 'NAVARRO JAIMES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147322006', 'sanori3335@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sanori3335', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('364', NULL, 'JESSICA MAYERLYN', 'NAVARRO JAIMES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247373335', 'rep_371@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_371', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('365', NULL, 'ANGELA KARINA', 'BOHORQUEZ ALVARADO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247667964', 'oskarijosabet12@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'oskarijosabet12', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('366', NULL, 'ANGELA KARINA', 'BOHORQUEZ ALVARADO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247667964', 'angelke82@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'angelke82', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('367', NULL, 'ANGELA KARINA', 'HERNÁNDEZ BOHÓRQUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247667964', 'rep_374@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_374', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('368', NULL, 'ANGELA KARINA', 'BOHÓRQUEZ ALVARADO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247667964', 'angelkb82@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'angelkb82', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('369', NULL, 'ELEIDYS AMPARO', 'FRANCISCONY', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0414 7273161', 'protseinca_@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'protseinca_', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('370', NULL, 'LIZETH MILLESEN', 'REQUENA ROMERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416 6028682', 'rroja9@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rroja9', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('371', NULL, 'RUBEN ARMANDO', 'ROJAS GUARAMATO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7576430', 'mpmariac.mc@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mpmariac.mc', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('372', NULL, 'MARIA AIDA', 'CORREA ALBARRACIN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04245868602', 'marlynconsolacionmoncadabayona@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'marlynconsolacionmoncadabayona', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('373', NULL, 'MARLYN CONSOLACIÓN', 'MONCADA BAYONA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247037839', 'virgi_caro_romero@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'virgi_caro_romero', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('374', NULL, 'VIRGINIA CAROLINA', 'ROMERO QUINTERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147167501', 'yole0108@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yole0108', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('375', NULL, 'CARMEN YOLEIDA', 'GIL DE ZUMZTEIN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161344562', 'jesusmarquezr07@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jesusmarquezr07', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('376', NULL, 'JESUS', 'MARQUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247435768', 'frexalidacanelones@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'frexalidacanelones', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('377', NULL, 'ISLEY FREXALIDA', 'DELGADO DE FERMÍN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7147799', 'grisney26@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'grisney26', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('378', NULL, 'GRISELA', 'CHACÓN MONTANEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04163051320', 'babyandreacastro@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'babyandreacastro', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('379', NULL, 'YAMIRA ANDREA', 'CASTRO GÓMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04124279703', 'casandrabaez22@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'casandrabaez22', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('380', NULL, 'CASANDRA CAROLINA', 'BÁEZ ROMERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147365044', 'lauryjohanacacua@gamil.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lauryjohanacacua', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('381', NULL, 'LAURY JOHANA', 'HERNANDEZ DE BANCES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04265759324', 'lenyfernandez1608@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lenyfernandez1608', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('382', NULL, 'LENY CAROLINA', 'FERNANDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147365044', 'lauryjohanacacua@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lauryjohanacacua', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('383', NULL, 'LAURY JOHANA', 'HERNANDEZ DE BANCES', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7009875', 'jandrearojas2015@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jandrearojas2015', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('384', NULL, 'JOHANA ANDREA', 'ROJAS MURILLO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7099734', 'tahis.acosta69@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'tahis.acosta69', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('385', NULL, 'ELIZABETH ANDREINA', 'ACEVEDO DE MUÑOZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04269763914', 'lucyzm6@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lucyzm6', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('386', NULL, 'RINA JOSEFINA', 'LEAL RIVERA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247394998', 'rep_411@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_411', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('387', NULL, 'NILEYDA NEILYN', 'GONZÁLEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247394998', 'rep_412@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_412', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('388', NULL, 'NILEYDA NEILYN', 'GONZÁLEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247394998', 'rep_413@endanza.edu.ve', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'rep_413', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('389', NULL, 'NILEYDA NEILYN', 'GONZÁLEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247617777', 'karola19_20@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karola19_20', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('390', NULL, 'MARCIA CAROLINA', 'LOPEZ CARRERO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04128671788', 'guemax@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'guemax', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('391', NULL, 'JEFERSON ORLANDO', 'BERNAL SANDOVAL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147076485', 'gersonalexander_25@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'gersonalexander_25', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('393', NULL, 'JOHANA CAROLINA', 'GONZÁLEZ ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147363779', 'joha1982ca@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'joha1982ca', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('394', NULL, 'GEYLLENS COROMOTO', 'CHACON DE DIAZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147057907', 'geyllenschacon@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'geyllenschacon', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('395', NULL, 'MARIA YSABEL', 'BECERRA DE GAITÀN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0416-8759205', 'ysabel1996@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ysabel1996', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('396', NULL, 'CARMEN', 'MONCADA GAMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140793543', 'jesusruizmoncada4a@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jesusruizmoncada4a', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('397', NULL, 'NORLYN MAYELA', 'CASTRO DE D´ SANTIAGO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04161762873', 'norlynmayelacastro.22@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'norlynmayelacastro.22', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('398', NULL, 'ANA JUDITH', 'PERNIA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424 7310131', 'anajudithpernia1981@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'anajudithpernia1981', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('399', NULL, 'ANYID MARYELA', 'RICO SOTO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04141750592', 'coridianybebe27@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'coridianybebe27', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('400', NULL, 'MARY ZULAY', 'VERGARA CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04264946025', 'mary1981vergara@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'mary1981vergara', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('401', NULL, 'EISSY LAREDT', 'ARAQUE CLAVIJO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0424-7217095', 'eissylaredt@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'eissylaredt', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('402', NULL, 'YOJANA JACKELINE', 'GUERRERO RAMÍREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247796888', 'yojanajackeline@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yojanajackeline', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('403', NULL, 'MIRIAM MERCEDES', 'SERRANO SUAREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '0412-0616751', 'miriamserrano051@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'miriamserrano051', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('404', NULL, 'JENNICE FIORELLA', 'ZAMBRANO SÁNCHEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04126670138', 'jennice.fiorella@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jennice.fiorella', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('405', NULL, 'ALEJANDRA YELITZA', 'CACERES HERNANDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147157128', 'aleyelcaceresh@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'aleyelcaceresh', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('406', NULL, 'ERIKA YOSELIN', 'RAMIREZ GUTIERREZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247547614', 'erikayramirezg@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'erikayramirezg', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('407', NULL, 'ALICIA', 'PERNIA MORA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '042688288269', 'apernia@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'apernia', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('408', NULL, 'FRANCY CAROLINA', 'MATA ZAMBRANO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04146263082', 'carolinamata77@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'carolinamata77', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('409', NULL, 'HUNGRÍA PAOLA', 'MOLINA HÓMEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147040860', 'hungriapaol@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'hungriapaol', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('410', NULL, 'ANGELICA MARIA', 'COLMENARES ALTAMIRANDA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04140782380', 'angelicacolmenares1508@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'angelicacolmenares1508', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('411', NULL, 'JUSDELY CAROLINA', 'SALCEDO ARANGUREN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147400807', 'jusdelys2011@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jusdelys2011', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('412', NULL, 'RONALD ALEXANDER', 'MANTILLA FERNANDEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147566994', 'ronaldmantilla80@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'ronaldmantilla80', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('413', NULL, 'JESSICA WILMAR', 'PRIETO LEAL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04247179780', 'jessicawprieto88@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'jessicawprieto88', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('414', NULL, 'MILAGROS DIOSEL', 'DURAN DE SULBARAN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04241285920', 'sulbaran.duran.angelica@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sulbaran.duran.angelica', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('415', NULL, 'MILAGROS DIOSEL', 'DURAN DE SULBARAN', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04241285920', 'duran_mily82@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'duran_mily82', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('416', NULL, 'LUISA MAYERLY', 'MEDINA GONZÁLEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04269137087', 'luisamedinagonzalez@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'luisamedinagonzalez', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('417', NULL, 'KARIN YURGEY', 'MORENO', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04147382407', 'karinyurgey@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'karinyurgey', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('418', NULL, 'WILKER ALEJANDRO', 'MACÍAS FIGUEROA', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04124201343', 'alejkygo@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'alejkygo', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('419', NULL, 'SANDRA YANETH', 'GOMEZ VILLAMIL', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04261796042', 'sandra3216g@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'sandra3216g', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('420', NULL, 'YULIANA CAROLINA', 'QUEVEDO RODRÍGUEZ', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04264780139', 'yulianademendoza@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yulianademendoza', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('421', NULL, 'LIZ YOLIMAR', 'PALENCIA ALTUVE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04144464246', 'lizyolimarlencia@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'lizyolimarlencia', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('422', NULL, 'LIZ YOLIMAR', 'PALENCIA ALTUVE', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04144464246', 'zharichcorrea1709@gmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'zharichcorrea1709', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);
INSERT INTO public."Usuario" ("Id_usuario", cedula, nombre, apellido, clave, telefono, correo, fecha_nacimiento, genero, foto_usuario, estatus_usuario, creado_en, actualizado_en, "Id_rol", "Id_direccion", username, security_word, respuesta_de_seguridad, password_reset_token, password_reset_expires, email_verification_token, email_verified, last_login, personal_id) VALUES ('423', NULL, 'YURLEY YERSARY', 'VIVAS CONTRERAS', '$2b$10$c320.rxct1nv53IvR4ntT6mNOhkaJFQUFAzm', '04266727841', 'yurley21_4@hotmail.com', NULL, NULL, NULL, 'activo', '2026-08-26 03:37:26.90621-04', NULL, '4', NULL, 'yurley21_4', NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL);



--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.category (id_category, name_category, description) (INSERT statements)



--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.customer (id_customer, id_user, shipping_address, purchase_limit) (INSERT statements)



--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.department (id_department, name_departament, description) (INSERT statements)



--
-- Data for Name: details_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.details_order (id_details, id_order, id_product, description) (INSERT statements)



--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.employee (id_employee, id_user, phone_number, commission) (INSERT statements)



--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."order" (id_order, id_customer, id_employee, order_date, state, total) (INSERT statements)



--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.product (id_product, id_category, id_department, name_product, description, price) (INSERT statements)



--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.report (id_report, id_order, report_type, generated_by, generation_date, description) (INSERT statements)



--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.role (id_role, name_role, permissions) (INSERT statements)



--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public.stock (id_stock, id_product, movement_type, quantity, movement_date, note_stock) (INSERT statements)



--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- Data for public."user" (id_user, id_role, dni, user_name, password, first_name, last_name, email, address) (INSERT statements)



--
-- Name: Ano_Academico_Id_ano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ano_Academico_Id_ano_seq"', 3, true);


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

SELECT pg_catalog.setval('public."Bloque_Horario_Id_bloque_seq"', 1, false);


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

SELECT pg_catalog.setval('public."Dia_Id_dia_seq"', 1, false);


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

SELECT pg_catalog.setval('public."Estudiante_Id_estudiante_seq"', 570, true);


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

SELECT pg_catalog.setval('public."Periodo_Inscripcion_Id_periodo_inscripcion_seq"', 1, false);


--
-- Name: Periodo_Subida_Notas_Id_periodo_notas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Periodo_Subida_Notas_Id_periodo_notas_seq"', 1, false);


--
-- Name: Profesor_Especialidad_Id_profesor_especialidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Profesor_Especialidad_Id_profesor_especialidad_seq"', 1, false);


--
-- Name: Profesor_Id_profesor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Profesor_Id_profesor_seq"', 42, true);


--
-- Name: Representante_Id_representante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Representante_Id_representante_seq"', 365, true);


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

SELECT pg_catalog.setval('public."Usuario_Id_usuario_seq"', 423, true);


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

\unrestrict jv9f3Cnsh3rKe5hocMCOmeYBueCj5s58S7Qdvga6CJzSCohFkHJ35wXKEqevOd0

