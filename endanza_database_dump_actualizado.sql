--
-- PostgreSQL database dump
--

\restrict Qe6saIonhkaODssT5jq078mBp3URdDUKtfgr42m4ao25S8HcgQWzApe0TM5ns2w

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
    cedula character varying(50),
    fecha_nacimiento date,
    genero character varying(30),
    seguro_escolar boolean DEFAULT false,
    "Id_nivel" integer,
    "Id_nivel_danza" integer,
    "Id_escuela" integer,
    "Id_seguro" integer,
    "Id_representante" integer,
    "Id_historial" integer,
    estatus character varying(20) DEFAULT 'Activo'::character varying,
    direccion character varying(255),
    telefono character varying(50),
    nombre_seguro character varying(150),
    grado_escuela character varying(100),
    "Id_especialidad" integer
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
    "Id_seccion" integer,
    "Id_especialidad" integer
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
    "Id_dia" integer,
    "Id_materia" integer
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
    nombre_seccion character varying(100),
    capacidad integer,
    "Id_materia" integer,
    "Id_lapso" integer,
    "Id_ano" integer NOT NULL,
    nivel_academico character varying(100),
    "Id_especialidad" integer,
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
3	2025 - 2026	Activo	2025-09-15	2026-07-31	t
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
\.


--
-- Data for Name: Carga_Nota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Carga_Nota" ("Id_nota", puntaje, esta_formalizada, "Id_estudiante", "Id_estructura_evaluacion") FROM stdin;
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
\.


--
-- Data for Name: Estudiante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante" ("Id_estudiante", nombre, apellido, cedula, fecha_nacimiento, genero, seguro_escolar, "Id_nivel", "Id_nivel_danza", "Id_escuela", "Id_seguro", "Id_representante", "Id_historial", estatus, direccion, telefono, nombre_seguro, grado_escuela, "Id_especialidad") FROM stdin;
710	Eymi Luiciana	Duque Castellanos	\N	2016-08-08	Femenino	t	\N	6	\N	\N	486	\N	Activo	\N	\N	\N	\N	\N
580	Lilian F	Cordoba Molina	\N	2007-12-12	Femenino	t	\N	8	\N	\N	373	\N	Activo	\N	\N	\N	\N	\N
582	Victoria Ayleen	Morales Colmenares	\N	2016-08-15	Femenino	t	\N	8	\N	\N	374	\N	Activo	\N	\N	\N	\N	\N
583	Kamila R.	Kepp Merchan	\N	2007-12-12	Femenino	t	\N	8	\N	\N	375	\N	Activo	\N	\N	\N	\N	\N
584	Sabrina L.	Chacon Montañez	\N	2016-12-12	Femenino	t	\N	8	\N	\N	376	\N	Activo	\N	\N	\N	\N	\N
585	Mariet A.	Carrero Guiral	\N	2016-12-12	Femenino	t	\N	8	\N	\N	377	\N	Activo	\N	\N	\N	\N	\N
586	Noelia S.	Bonilla B.	\N	2016-12-12	Femenino	t	\N	8	\N	\N	378	\N	Activo	\N	\N	\N	\N	\N
587	Anyely C	Zambrano Ramirez	\N	2016-12-12	Femenino	t	\N	8	\N	\N	379	\N	Activo	\N	\N	\N	\N	\N
588	Paula Monserrat	Cacua Moncada	\N	2016-01-06	Femenino	t	\N	8	\N	\N	380	\N	Activo	\N	\N	\N	\N	\N
589	Maria V	Utrera Silva	\N	2016-12-12	Femenino	t	\N	8	\N	\N	381	\N	Activo	\N	\N	\N	\N	\N
590	Sara A	Rivas A	\N	2020-01-02	Femenino	t	\N	7	\N	\N	382	\N	Activo	\N	\N	\N	\N	\N
591	Angely K.	Colmenares Gonez	\N	2016-12-12	Femenino	t	\N	8	\N	\N	383	\N	Activo	\N	\N	\N	\N	\N
592	Sabrina A	Jaimes C	\N	2016-12-12	Femenino	t	\N	8	\N	\N	384	\N	Activo	\N	\N	\N	\N	\N
593	Stephany J.	Roman Mora	\N	2016-12-12	Femenino	t	\N	8	\N	\N	385	\N	Activo	\N	\N	\N	\N	\N
594	Loreiny N	Villasmil G	\N	2020-05-02	Femenino	t	\N	7	\N	\N	386	\N	Activo	\N	\N	\N	\N	\N
595	Maria De Los Angeles	Carrero Gomez	\N	2015-09-08	Femenino	t	\N	8	\N	\N	387	\N	Activo	\N	\N	\N	\N	\N
596	Sofia I	Carrero Pineda	\N	2016-12-12	Femenino	t	\N	8	\N	\N	388	\N	Activo	\N	\N	\N	\N	\N
597	Adriana V	Escalante R	\N	2016-12-12	Femenino	t	\N	8	\N	\N	389	\N	Activo	\N	\N	\N	\N	\N
598	Hariadne R	Losada Fuentes	\N	2020-02-02	Femenino	t	\N	7	\N	\N	390	\N	Activo	\N	\N	\N	\N	\N
600	Lisdani Isabella	Chacón Márquez	\N	2014-12-17	Femenino	t	\N	9	\N	\N	391	\N	Activo	\N	\N	\N	\N	\N
601	Meredith Noely	Pacheco Ramirez	\N	2020-05-05	Femenino	t	\N	7	\N	\N	392	\N	Activo	\N	\N	\N	\N	\N
604	Ashley Y	Martinez C	\N	2016-12-12	Femenino	t	\N	8	\N	\N	393	\N	Activo	\N	\N	\N	\N	\N
605	Anyela Monserrat	Colmenares Díaz	\N	2015-05-15	Femenino	t	\N	9	\N	\N	394	\N	Activo	\N	\N	\N	\N	\N
606	Ariadna Isabel	Labrador B	\N	2020-03-03	Femenino	t	\N	7	\N	\N	395	\N	Activo	\N	\N	\N	\N	\N
607	Ana I	Pineda Escalante	\N	2016-12-12	Femenino	t	\N	8	\N	\N	396	\N	Activo	\N	\N	\N	\N	\N
608	Mariana Lucia	Abreu Gomez	\N	2013-07-27	Femenino	t	\N	11	\N	\N	397	\N	Activo	\N	\N	\N	\N	\N
609	Sophia Valentina	D´santiago Castro	\N	2012-08-20	Femenino	t	\N	9	\N	\N	398	\N	Activo	\N	\N	\N	\N	\N
610	Oriana De Los Angeles	Rosales U	\N	2020-03-03	Femenino	t	\N	7	\N	\N	399	\N	Activo	\N	\N	\N	\N	\N
611	Isabella Salome	Escobar Diaz	\N	2015-05-23	Femenino	t	\N	9	\N	\N	400	\N	Activo	\N	\N	\N	\N	\N
613	Grecia Valeria	Becerra Esteves	\N	2014-01-16	Femenino	t	\N	10	\N	\N	401	\N	Activo	\N	\N	\N	\N	\N
614	Francheska Vicmary	Gallo Zambrano	\N	2012-10-13	Femenino	t	\N	9	\N	\N	402	\N	Activo	\N	\N	\N	\N	\N
615	Amy Antonella	Alvarado Ruiz	\N	2013-06-07	Femenino	t	\N	11	\N	\N	403	\N	Activo	\N	\N	\N	\N	\N
616	Isabella Naomi	González Salas	\N	2015-12-09	Femenino	t	\N	9	\N	\N	404	\N	Activo	\N	\N	\N	\N	\N
617	Skarly Franchesca	Bernal Duran	\N	2014-03-14	Femenino	t	\N	10	\N	\N	405	\N	Activo	\N	\N	\N	\N	\N
618	Fabrizio Alejandro	Beltran Arias	\N	2003-09-03	Masculino	t	\N	12	\N	\N	406	\N	Activo	\N	\N	\N	\N	\N
619	Michelle Alexandra	Guerrero Pérez	\N	2015-04-24	Femenino	t	\N	9	\N	\N	407	\N	Activo	\N	\N	\N	\N	\N
620	Maholy A	Gomez Sanchez	\N	2020-02-02	Masculino	t	\N	7	\N	\N	408	\N	Activo	\N	\N	\N	\N	\N
621	Stefanny Camila	León Rico	\N	2015-11-13	Femenino	t	\N	9	\N	\N	409	\N	Activo	\N	\N	\N	\N	\N
622	Eduanly V	Alvarran H	\N	2020-02-02	Femenino	t	\N	7	\N	\N	410	\N	Activo	\N	\N	\N	\N	\N
623	Aymara Sinahi	Cáceres Leal	\N	2014-04-10	Femenino	t	\N	10	\N	\N	411	\N	Activo	\N	\N	\N	\N	\N
624	Mariana M	Boada Bayona	\N	2011-07-16	Femenino	t	\N	12	\N	\N	412	\N	Activo	\N	\N	\N	\N	\N
625	Ambar Liseth	Molina Cañas	\N	2016-02-12	Femenino	t	\N	9	\N	\N	413	\N	Activo	\N	\N	\N	\N	\N
626	Nahory F	Garcia G	\N	2020-03-03	Femenino	t	\N	7	\N	\N	410	\N	Activo	\N	\N	\N	\N	\N
627	Daniela Alexandra	Montaña Contreras	\N	2016-02-21	Femenino	t	\N	9	\N	\N	414	\N	Activo	\N	\N	\N	\N	\N
628	Jessi Gabriela	Luna Trespalacios	\N	2010-05-15	Femenino	t	\N	12	\N	\N	415	\N	Activo	\N	\N	\N	\N	\N
629	Ashlyn Steissy	Cano Zambrano	\N	2009-09-20	Femenino	t	\N	11	\N	\N	416	\N	Activo	\N	\N	\N	\N	\N
630	Alondra Sofía	Davila Becerra	\N	2013-06-04	Femenino	t	\N	10	\N	\N	417	\N	Activo	\N	\N	\N	\N	\N
631	Paola V	Sandoval M	\N	2020-03-03	Femenino	t	\N	7	\N	\N	418	\N	Activo	\N	\N	\N	\N	\N
632	Aneley Montserrat	Navarro Contramaestre	\N	2015-08-19	Femenino	t	\N	9	\N	\N	419	\N	Activo	\N	\N	\N	\N	\N
634	Wilker Alejandro	Macias Figueroa	\N	2000-08-11	Masculino	t	\N	12	\N	\N	420	\N	Activo	\N	\N	\N	\N	\N
635	Sofia Valeria	Cordero Moncada	\N	2013-07-19	Femenino	t	\N	11	\N	\N	421	\N	Activo	\N	\N	\N	\N	\N
636	María Julieta	Ortiz Herrera	\N	2015-06-17	Femenino	t	\N	9	\N	\N	422	\N	Activo	\N	\N	\N	\N	\N
637	Charlotte D	Contreras L	\N	2020-03-04	Femenino	t	\N	7	\N	\N	423	\N	Activo	\N	\N	\N	\N	\N
638	Camila Sarai	Díaz Contreras	\N	2014-01-20	Femenino	t	\N	10	\N	\N	424	\N	Activo	\N	\N	\N	\N	\N
639	Orianna Sofia	Perez Navarro	\N	2011-05-17	Femenino	t	\N	12	\N	\N	425	\N	Activo	\N	\N	\N	\N	\N
641	Adrian Moises	Ramirez Rivera	\N	2006-02-15	Masculino	t	\N	12	\N	\N	426	\N	Activo	\N	\N	\N	\N	\N
642	Eilyn Sophia	Meza Ostos	\N	2013-11-27	Femenino	t	\N	10	\N	\N	427	\N	Activo	\N	\N	\N	\N	\N
643	Annarella Victoria	Rojas Omaña	\N	2015-06-10	Femenino	t	\N	9	\N	\N	428	\N	Activo	\N	\N	\N	\N	\N
644	Maria Fernanda	Ramirez Rivera	\N	2012-01-13	Femenino	t	\N	12	\N	\N	429	\N	Activo	\N	\N	\N	\N	\N
645	Eva Del Valle	Salas Rodríguez	\N	2014-12-10	Femenino	t	\N	9	\N	\N	430	\N	Activo	\N	\N	\N	\N	\N
646	Aylish Joselyn	Morales Neira	\N	2013-12-29	Femenino	t	\N	10	\N	\N	431	\N	Activo	\N	\N	\N	\N	\N
647	Genesis Alejandra	Zambrano Polanco	\N	2010-10-20	Femenino	t	\N	12	\N	\N	432	\N	Activo	\N	\N	\N	\N	\N
648	Emily Miranda	Aponte Chacon	\N	2020-03-03	Femenino	t	\N	7	\N	\N	433	\N	Activo	\N	\N	\N	\N	\N
650	Daniela Valentina	Zambrano Sanguino	\N	2014-07-21	Femenino	t	\N	9	\N	\N	434	\N	Activo	\N	\N	\N	\N	\N
651	Brithanny Jossie	Delgado Contreras	\N	2012-02-20	Femenino	t	\N	11	\N	\N	435	\N	Activo	\N	\N	\N	\N	\N
652	Ambar Manuela	Borrero Pernía	\N	2012-08-30	Femenino	t	\N	9	\N	\N	436	\N	Activo	\N	\N	\N	\N	\N
653	Bryan Josue	Vasquez Da Cunha	\N	2006-10-18	Masculino	t	\N	12	\N	\N	432	\N	Activo	\N	\N	\N	\N	\N
654	Maria De Los Angeles	Marquez G	\N	2020-02-03	Femenino	t	\N	7	\N	\N	437	\N	Activo	\N	\N	\N	\N	\N
656	Isabella Valentina	Ontiveros Mogrovejo	\N	2014-06-18	Femenino	t	\N	10	\N	\N	438	\N	Activo	\N	\N	\N	\N	\N
657	María Sofia	Guerra Contreras	\N	2010-04-08	Femenino	t	\N	12	\N	\N	439	\N	Activo	\N	\N	\N	\N	\N
659	Sofia Anabhella	Chacon Gonzalez	\N	2020-04-02	Femenino	t	\N	7	\N	\N	441	\N	Activo	\N	\N	\N	\N	\N
660	Nathalia Saray	Bonilla Pulido	\N	2011-11-02	Femenino	t	\N	12	\N	\N	442	\N	Activo	\N	\N	\N	\N	\N
661	Gabriela Sarahí	Ramírez Ballesteros	\N	2014-08-04	Femenino	t	\N	10	\N	\N	443	\N	Activo	\N	\N	\N	\N	\N
662	Vvalery A	Ontiveros M	\N	2020-02-04	Femenino	t	\N	7	\N	\N	444	\N	Activo	\N	\N	\N	\N	\N
664	Daryangel Victoria	Chacon Contreras	\N	2010-10-08	Femenino	t	\N	12	\N	\N	445	\N	Activo	\N	\N	\N	\N	\N
665	Sofia C	Angarita D	\N	2020-04-04	Femenino	t	\N	7	\N	\N	446	\N	Activo	\N	\N	\N	\N	\N
666	Venezia Alegría	Rico Molina	\N	2014-03-14	Femenino	t	\N	10	\N	\N	447	\N	Activo	\N	\N	\N	\N	\N
667	Emily Alicec	Mora Guerrero	\N	2012-02-23	Femenino	t	\N	12	\N	\N	448	\N	Activo	\N	\N	\N	\N	\N
668	Johana V	Morales P	\N	2020-03-03	Femenino	t	\N	7	\N	\N	449	\N	Activo	\N	\N	\N	\N	\N
669	Avril R	Rivera M	\N	2020-08-08	Femenino	t	\N	7	\N	\N	450	\N	Activo	\N	\N	\N	\N	\N
670	Haniry Isabella	Useche Méndez	\N	2014-06-27	Femenino	t	\N	10	\N	\N	451	\N	Activo	\N	\N	\N	\N	\N
671	Carly A	Correa Bonilla	\N	2020-02-03	Femenino	t	\N	7	\N	\N	452	\N	Activo	\N	\N	\N	\N	\N
672	Valeria Valentina	Velazquez Ramírez	\N	2014-04-03	Femenino	t	\N	10	\N	\N	453	\N	Activo	\N	\N	\N	\N	\N
673	Victoria Alejandra	Chacon Prieto	\N	2020-02-03	Femenino	t	\N	7	\N	\N	454	\N	Activo	\N	\N	\N	\N	\N
674	Danna Alejandra	Morales Chacon	\N	2009-06-12	Femenino	t	\N	11	\N	\N	455	\N	Activo	\N	\N	\N	\N	\N
675	Victoria Salome	Granados Murillo	\N	2020-03-03	Femenino	t	\N	7	\N	\N	456	\N	Activo	\N	\N	\N	\N	\N
676	Samantha S	Nava Medina	\N	2020-03-03	Femenino	t	\N	7	\N	\N	457	\N	Activo	\N	\N	\N	\N	\N
677	María José Del Rocio	Pereira Escalante	\N	2012-07-07	Femenino	t	\N	11	\N	\N	458	\N	Activo	\N	\N	\N	\N	\N
678	Aimee Sofía	Becerra Prieto	\N	2014-04-21	Femenino	t	\N	10	\N	\N	459	\N	Activo	\N	\N	\N	\N	\N
679	Osmairel E	Guerero G	\N	2020-03-03	Femenino	t	\N	7	\N	\N	460	\N	Activo	\N	\N	\N	\N	\N
680	Caroline Valentina	Torres Rojas	\N	2013-01-27	Femenino	t	\N	11	\N	\N	461	\N	Activo	\N	\N	\N	\N	\N
681	Dariangael V	Ramirez P	\N	2020-03-03	Masculino	t	\N	7	\N	\N	462	\N	Activo	\N	\N	\N	\N	\N
683	Vikayzs Shekinara	Varela Moreno	\N	2011-10-27	Femenino	t	\N	11	\N	\N	463	\N	Activo	\N	\N	\N	\N	\N
684	Miranda Lucía	Caicedo Duque	\N	2016-04-24	Femenino	t	\N	9	\N	\N	464	\N	Activo	\N	\N	\N	\N	\N
685	Dariana Camila	Brito Laguado	\N	2012-07-06	Femenino	t	\N	10	\N	\N	465	\N	Activo	\N	\N	\N	\N	\N
687	Emma I	Ramirez M	\N	2020-03-03	Femenino	t	\N	7	\N	\N	466	\N	Activo	\N	\N	\N	\N	\N
688	Stephany Paola	Díaz Sánchez	\N	2014-09-23	Femenino	t	\N	9	\N	\N	467	\N	Activo	\N	\N	\N	\N	\N
690	Allison Sophía	Carrero Pulido	\N	2013-07-01	Femenino	t	\N	10	\N	\N	468	\N	Activo	\N	\N	\N	\N	\N
692	Constanza	Egañez Briceño	\N	2014-01-01	Femenino	t	\N	9	\N	\N	469	\N	Activo	\N	\N	\N	\N	\N
693	Loriana Anthonella	Contreras Harms	\N	2013-01-08	Femenino	t	\N	10	\N	\N	470	\N	Activo	\N	\N	\N	\N	\N
694	Mariangely Valentina	Galvis Carvajal	\N	2009-02-18	Femenino	t	\N	9	\N	\N	471	\N	Activo	\N	\N	\N	\N	\N
695	Fiorella Camila	Jugo Freites	\N	2013-12-27	Femenino	t	\N	10	\N	\N	472	\N	Activo	\N	\N	\N	\N	\N
696	María Sophie	Gudiño Rico	\N	2013-07-12	Femenino	t	\N	9	\N	\N	473	\N	Activo	\N	\N	\N	\N	\N
697	Adriana Massiel	Montilva Becerra	\N	2013-05-28	Femenino	t	\N	9	\N	\N	474	\N	Activo	\N	\N	\N	\N	\N
698	Isabel Verónica	Romero Pabón	\N	2011-12-03	Femenino	t	\N	9	\N	\N	475	\N	Activo	\N	\N	\N	\N	\N
699	Melanny Anthonella	Navarro Alviarez	\N	2012-11-02	Femenino	t	\N	10	\N	\N	476	\N	Activo	\N	\N	\N	\N	\N
700	Ivanna Lucia	Perez Plata	\N	2013-04-01	Femenino	t	\N	10	\N	\N	477	\N	Activo	\N	\N	\N	\N	\N
701	Victoria Alejandra	Perez Salcedo	\N	2013-09-13	Femenino	t	\N	10	\N	\N	478	\N	Activo	\N	\N	\N	\N	\N
702	Avril Sophia	Ray Hernandez	\N	2014-05-04	Femenino	t	\N	10	\N	\N	479	\N	Activo	\N	\N	\N	\N	\N
703	Nicolle Anthonella	Ray Hernandez	\N	2012-11-03	Femenino	t	\N	10	\N	\N	479	\N	Activo	\N	\N	\N	\N	\N
704	Leymar Gabriela	Bueno Arellano	\N	2013-01-01	Femenino	t	\N	11	\N	\N	480	\N	Activo	\N	\N	\N	\N	\N
705	Maria Mercedes	Moreno Suarez	\N	2005-11-15	Femenino	t	\N	11	\N	\N	481	\N	Activo	\N	\N	\N	\N	\N
706	Maria Jose	Perez Sandia	\N	2010-07-21	Femenino	t	\N	10	\N	\N	482	\N	Activo	\N	\N	\N	\N	\N
707	Daymari Alejandra	Romero Becerra	\N	2008-08-08	Femenino	t	\N	10	\N	\N	483	\N	Activo	\N	\N	\N	\N	\N
708	Aranza Sofia	Osma Martinez	\N	2013-01-01	Femenino	t	\N	10	\N	\N	484	\N	Activo	\N	\N	\N	\N	\N
709	Luz Mariangel	Rosales Garcia	\N	2007-10-02	Femenino	t	\N	11	\N	\N	485	\N	Activo	\N	\N	\N	\N	\N
\.


--
-- Data for Name: Estudiante_Padre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante_Padre" ("Id_estudiante", "Id_padre") FROM stdin;
\.


--
-- Data for Name: Estudiante_Seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Estudiante_Seccion" ("Id_estudiante_seccion", "Id_estudiante", "Id_seccion", "Id_especialidad") FROM stdin;
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
\.


--
-- Data for Name: Horario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Horario" ("Id_horario", "Id_seccion", "Id_aula", "Id_profesor", "Id_bloque", "Id_dia", "Id_materia") FROM stdin;
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
\.


--
-- Data for Name: Periodo_Subida_Notas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Periodo_Subida_Notas" ("Id_periodo_notas", "Id_ano", fecha_inicio, fecha_fin, activo, creado_en, actualizado_en) FROM stdin;
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
371	t	Administrador del Sistema	ENDANZA	1
373	t	\N	\N	430
374	t	\N	\N	431
375	t	\N	\N	432
376	t	\N	\N	433
377	t	\N	\N	434
378	t	\N	\N	435
379	t	\N	\N	436
380	t	\N	\N	437
381	t	\N	\N	438
382	t	\N	\N	439
383	t	\N	\N	440
384	t	\N	\N	441
385	t	\N	\N	442
386	t	\N	\N	443
387	t	\N	\N	444
388	t	\N	\N	445
389	t	\N	\N	446
390	t	\N	\N	447
391	t	\N	\N	448
392	t	\N	\N	449
393	t	\N	\N	450
394	t	\N	\N	451
395	t	\N	\N	452
396	t	\N	\N	453
397	t	\N	\N	454
398	t	\N	\N	455
399	t	\N	\N	456
400	t	\N	\N	457
401	t	\N	\N	458
402	t	\N	\N	459
403	t	\N	\N	460
404	t	\N	\N	461
405	t	\N	\N	462
406	t	\N	\N	463
407	t	\N	\N	464
408	t	\N	\N	465
409	t	\N	\N	466
410	t	\N	\N	467
411	t	\N	\N	468
412	t	\N	\N	469
413	t	\N	\N	470
414	t	\N	\N	471
415	t	\N	\N	472
416	t	\N	\N	473
417	t	\N	\N	474
418	t	\N	\N	475
419	t	\N	\N	476
420	t	\N	\N	477
421	t	\N	\N	478
422	t	\N	\N	479
423	t	\N	\N	480
424	t	\N	\N	481
425	t	\N	\N	482
426	t	\N	\N	483
427	t	\N	\N	484
428	t	\N	\N	485
429	t	\N	\N	486
430	t	\N	\N	487
431	t	\N	\N	488
432	t	\N	\N	489
433	t	\N	\N	490
434	t	\N	\N	491
435	t	\N	\N	492
436	t	\N	\N	493
437	t	\N	\N	494
438	t	\N	\N	495
439	t	\N	\N	496
441	t	\N	\N	497
442	t	\N	\N	498
443	t	\N	\N	499
444	t	\N	\N	500
445	t	\N	\N	501
446	t	\N	\N	502
447	t	\N	\N	503
448	t	\N	\N	504
449	t	\N	\N	505
450	t	\N	\N	506
451	t	\N	\N	507
452	t	\N	\N	508
453	t	\N	\N	509
454	t	\N	\N	510
455	t	\N	\N	511
456	t	\N	\N	512
457	t	\N	\N	513
458	t	\N	\N	514
459	t	\N	\N	515
460	t	\N	\N	516
461	t	\N	\N	517
462	t	\N	\N	518
463	t	\N	\N	519
464	t	\N	\N	520
465	t	\N	\N	521
466	t	\N	\N	522
467	t	\N	\N	523
468	t	\N	\N	524
469	t	\N	\N	525
470	t	\N	\N	526
471	t	\N	\N	527
472	t	\N	\N	528
473	t	\N	\N	529
474	t	\N	\N	530
475	t	\N	\N	531
476	t	\N	\N	532
477	t	\N	\N	533
478	t	\N	\N	534
479	t	\N	\N	535
480	t	\N	\N	536
481	t	\N	\N	537
482	t	\N	\N	538
483	t	\N	\N	539
484	t	\N	\N	540
485	t	\N	\N	541
486	t	\N	\N	30
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

COPY public."Seccion" ("Id_seccion", nombre_seccion, capacidad, "Id_materia", "Id_lapso", "Id_ano", nivel_academico, "Id_especialidad") FROM stdin;
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
3	V-29830107	MARIETH FERNANDA	DEVIA ESCALANTE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	marieth.devia0107@endanza.com	2002-01-21	\N	\N	Activo	\N	\N	2	\N	marieth0107	\N	\N	\N	\N	\N	f	\N	\N
5	V-25980485	BETANIA DE LOS ÁNGELES	GARCÍA VIVAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	betania.garcia0485@endanza.com	1997-01-26	\N	\N	Activo	\N	\N	2	\N	betania0485	\N	\N	\N	\N	\N	f	\N	\N
7	V-6810884	LOPEZ GISELA ILNELU	JACKSON DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	lopez.jackson0884@endanza.com	1963-01-19	\N	\N	Activo	\N	\N	2	\N	lopez0884	\N	\N	\N	\N	\N	f	\N	\N
10	V-28195359	PAOLA MAYELLA	RICO PORRAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	paola.rico5359@endanza.com	2001-10-02	\N	\N	Activo	\N	2026-09-13 11:33:30.620905-04	2	\N	paola5359	\N	\N	\N	\N	\N	f	2026-09-13 11:33:30.620905	\N
12	V-19915196	ALVARO RENNIER	SOLANO VARELA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	alvaro.solano5196@endanza.com	1989-05-30	\N	\N	Activo	\N	\N	2	\N	alvaro5196	\N	\N	\N	\N	\N	f	\N	\N
16	V-31122871	VANESSA CAROLINA	VILLASMIL MATA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	vanessa.villasmil2871@endanza.com	2006-01-23	\N	\N	Activo	\N	\N	2	\N	vanessa2871	\N	\N	\N	\N	\N	f	\N	\N
17	V-29830219	SARAH VALENTINA	ZAMBRANO GUERRERO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	sarah.zambrano0219@endanza.com	2002-01-23	\N	\N	Activo	\N	\N	2	\N	sarah0219	\N	\N	\N	\N	\N	f	\N	\N
20	V-32610676	ARIANNA NICOLLE	AMAYA RAMÍREZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	arianna.amaya0676@endanza.com	2008-02-01	\N	\N	Activo	\N	\N	2	\N	arianna0676	\N	\N	\N	\N	\N	f	\N	\N
21	V-30523907	JULIETH FERNANDA	BELEÑO SANDOVAL	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	julieth.beleno3907@endanza.com	2003-10-13	\N	\N	Activo	\N	2026-07-29 14:20:47.793605-04	2	\N	julieth3907	\N	\N	\N	\N	\N	f	2026-07-29 14:20:47.793605	\N
23	V-31762867	MARÍA LAURA	CASTRO HART	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	maria.castro2867@endanza.com	2006-06-16	\N	\N	Activo	\N	\N	2	\N	maria2867	\N	\N	\N	\N	\N	f	\N	\N
24	V-27239670	DANIELA	DÍAZ ALIX	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	daniela.diaz9670@endanza.com	2000-04-04	\N	\N	Activo	\N	\N	2	\N	daniela9670	\N	\N	\N	\N	\N	f	\N	\N
25	V-26403133	ROSELBI PAOLA	GARCÍA COLMENARES	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	roselbi.garcia3133@endanza.com	1998-06-16	\N	\N	Activo	\N	\N	2	\N	roselbi3133	\N	\N	\N	\N	\N	f	\N	\N
26	V-30626110	HANNA	RAMOS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	hanna.ramos6110@endanza.com	2004-12-30	\N	\N	Activo	\N	\N	2	\N	hanna6110	\N	\N	\N	\N	\N	f	\N	\N
27	V-30296992	JOSÉ	ROA MARÍA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	jose.roa6992@endanza.com	2002-04-02	\N	\N	Activo	\N	\N	2	\N	jose6992	\N	\N	\N	\N	\N	f	\N	\N
28	V-30981792	VALERIA	URBINA PERNÍA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	valeria.urbina1792@endanza.com	2004-12-11	\N	\N	Activo	\N	\N	2	\N	valeria1792	\N	\N	\N	\N	\N	f	\N	\N
8	V-30617219	VALERIA SOFÍA	OJEDA ZAMBRANO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	valeria.ojeda7219@endanza.com	2004-08-20	\N	\N	Activo	\N	\N	2	\N	valeria7219	\N	\N	\N	\N	\N	f	\N	\N
11	V-20121208	ADRIANA SARAI	RUIZ VIVAS	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	adriana.ruiz1208@endanza.com	1992-04-10	\N	\N	Activo	\N	\N	2	\N	adriana1208	\N	\N	\N	\N	\N	f	\N	\N
13	V-3911521	WILFREDO	TERÁN	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	wilfredo.teran1521@endanza.com	1950-09-20	\N	\N	Activo	\N	\N	2	\N	wilfredo1521	\N	\N	\N	\N	\N	f	\N	\N
14	V-7304367	IVETTE DEL CARMEN	TOVAR DOMINGUEZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ivette.tovar4367@endanza.com	1961-05-30	\N	\N	Activo	\N	\N	2	\N	ivette4367	\N	\N	\N	\N	\N	f	\N	\N
22	V-30890719	CAMILY AMARANTA	CÁCERES LEAL	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	camily.caceres0719@endanza.com	2004-10-11	\N	\N	Activo	\N	\N	2	\N	camily0719	\N	\N	\N	\N	\N	f	\N	\N
19	V-10169482	PARRA CONSUELO	TRIVIÑO DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	parra.trivino9482@endanza.com	1954-01-02	\N	\N	Activo	\N	\N	5	\N	parra9482	\N	\N	\N	\N	\N	f	\N	\N
29	V-11504462	JENNICE FIORELLA	ZAMBRANO SÁNCHEZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	jennice.zambrano4462@endanza.com	1974-12-07	\N	\N	Activo	\N	\N	5	\N	jennice4462	\N	\N	\N	\N	\N	f	\N	\N
9	V-5674902	RAMÍREZ ROSA EMILIA	PERNÍA DE	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ramirez.pernia4902@endanza.com	1963-08-30	\N	\N	Activo	\N	2026-09-15 15:44:13.551694-04	1	\N	ramirez4902	\N	\N	\N	\N	\N	f	2026-09-15 19:44:13.551694	\N
4	V-15080054	SABRINA DE LOS ANGELES	FLORES PINEDA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	sabrina.flores0054@endanza.com	1980-09-29	\N	\N	Activo	\N	2026-09-15 16:21:26.404029-04	1	\N	sabrina0054	\N	\N	\N	\N	\N	f	2026-09-15 20:21:26.404029	\N
430	V-9966517	Maria Teresa	Molina Aguilera	$2b$10$uAZv.peEZhAPePX4g7ekDePAcmRutjAm9NZmdWsdxfMAltAk4QYda	\N	mariamolina@gmail.com	\N	\N	\N	activo	2026-09-15 15:16:17.53311-04	2026-09-15 15:17:24.651019-04	4	\N	mariamolina	\N	\N	\N	\N	\N	f	2026-09-15 19:17:24.651019	\N
431	V-12631278	Angelica Maria	Colmenares Altamiranda	$2b$10$6EcPkMIlQ8r.3bjTWduc1urIH8UZzeuijzUuYs3.XF7ft.pjqX7b2	\N	angelicacolmenares@gmail.com	\N	\N	\N	activo	2026-09-15 15:25:18.08076-04	\N	4	\N	angelicacolmenares	\N	\N	\N	\N	\N	f	\N	\N
432	V-12226017	Maria Raquel	Merchan Gomez	$2b$10$C0nkupO4aV6cc6pVV4aJB.omfQJ61eOeRNBdt3UdVnCgt5vg8QDvq	\N	mariamerchan@gmail.com	\N	\N	\N	activo	2026-09-15 15:27:59.178379-04	\N	4	\N	mariamerchan	\N	\N	\N	\N	\N	f	\N	\N
433	V-13306389	Grisela G	Chacon Montañez	$2b$10$IS4ldGP7Bv.8.L0Yy9BhCuY1HsNF9Gpe3RTX49VeHerh21S5/bXdu	\N	griselachacon@gmail.com	\N	\N	\N	activo	2026-09-15 15:31:40.229149-04	\N	4	\N	griselachacon	\N	\N	\N	\N	\N	f	\N	\N
434	V-13549949	Sheyla M	Guiral A	$2b$10$wE6.r3MdW7WCDULjFu0oGOuXbrmCPoQbnsF8DcvpeZXDClbh9DCCW	\N	sheylaguiral@gmail.com	\N	\N	\N	activo	2026-09-15 15:35:33.906818-04	\N	4	\N	sheylaguiral	\N	\N	\N	\N	\N	f	\N	\N
435	V-15156265	Makerly Briceth	Bonilla Becerra	$2b$10$cK4h7s8KJ0ptakWKDRCye.UU3t.5xKaAkzJ5jMtswDdQ/G1pyCl0y	\N	makerlybonilla@gmail.com	\N	\N	\N	activo	2026-09-15 15:38:39.080913-04	\N	4	\N	makerlybonilla	\N	\N	\N	\N	\N	f	\N	\N
436	V-16378989	Felida Del C.	Ramirez Araque	$2b$10$NRVXYZdWCBCQsOc3TvHWdOEmWGovEEARZW4lls6Mu9wTugCNbdqfC	\N	felidaramirez@gmail.com	\N	\N	\N	activo	2026-09-15 15:41:55.035933-04	\N	4	\N	felidaramirez	\N	\N	\N	\N	\N	f	\N	\N
437	V-16541830	Marlyn Consolación	Moncada Bayona	$2b$10$JTjwgQaIkPWuO4XODQ9iouq1v2M1ceBPVE2.jvjs5aoxfuDStt67C	\N	marlynmoncada@gmail.com	\N	\N	\N	activo	2026-09-15 15:45:38.515538-04	\N	4	\N	marlynmoncada	\N	\N	\N	\N	\N	f	\N	\N
2	V-9248324	VILMAN OMAR	CARRERO MALDONADO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	vilman.carrero8324@endanza.com	1968-12-13	\N	\N	Activo	\N	2026-09-16 04:15:35.40243-04	2	\N	vilman8324	\N	\N	\N	\N	\N	f	2026-09-16 04:15:35.40243	\N
15	V-12112581	LINDA	VADILLO ADA	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	linda.vadillo2581@endanza.com	1977-12-17	\N	\N	Activo	\N	2026-09-16 04:16:45.903722-04	2	\N	linda2581	\N	\N	\N	\N	\N	f	2026-09-16 04:16:45.903722	\N
1	V-00000000	Admin	Sistema	$2b$10$STfSKjxp05CLMG2HqU9VMe3YpN9D5Bfz//NAiY0y3KDL6GQ6q83/i	\N	admin@endanza.com	\N	\N	\N	Activo	\N	2026-09-16 13:39:01.215547-04	1	\N	admin	\N	\N	\N	\N	\N	f	2026-09-16 13:39:01.215547	\N
30	V-25020014	NIKAILA CLISMAR	CASTELLANOS ALVIAREZ	$2b$10$qPRR220D.GcHgLT6WdCRe.PlJVWXsYXEVqFTB7ROBam0dGHXbMT3.	\N	nikaila.castellanos0014@endanza.com	1996-01-09	\N	\N	Activo	\N	2026-09-16 05:32:13.331148-04	2	\N	nikaila0014	\N	\N	\N	\N	\N	f	2026-09-16 05:32:13.331148	\N
438	V-17646820	Paola P	Silva Rodriguez	$2b$10$Q0pZeHpKScKyx3y1zmAj/e3WmF/lgVPplfdxL0/UmZESt.N1FvY.6	\N	paolasilva@gmail.com	\N	\N	\N	activo	2026-09-15 15:48:27.321977-04	\N	4	\N	paolasilva	\N	\N	\N	\N	\N	f	\N	\N
439	V-11114406	Nyjane A	Arb De Rivas	$2b$10$TeFk10g1Ld9BZrFN0WCkH.oPXmCpzc9B.qq2ln4pQ/mPOHocds5wG	\N	NYJANEARB@GMAIL.COM	\N	\N	\N	activo	2026-09-15 15:49:26.852264-04	\N	4	\N	NYJANEARB	\N	\N	\N	\N	\N	f	\N	\N
440	V-19135259	Ana Carolina	Guerrero Gomez	$2b$10$QpM7AZPEsYpbUi5rzAGVHuJeDiipgCZ9kzmpIinghquxu3dzSS8cK	\N	anaguerrero@gmail.com	\N	\N	\N	activo	2026-09-15 15:50:15.717833-04	\N	4	\N	anaguerrero	\N	\N	\N	\N	\N	f	\N	\N
441	V-19769652	Dayana A	Carrillo H	$2b$10$5Wjx7jsq2wd8MgVZKiWVX.TZcFOdMd/BcXsBgGXD6RY6QfsCEBNyO	\N	dayanacarrillo@gmail.com	\N	\N	\N	activo	2026-09-15 15:52:18.221754-04	\N	4	\N	dayanacarrillo	\N	\N	\N	\N	\N	f	\N	\N
442	V-19778086	Yessika A.	Mora De Porras	$2b$10$Na12FWJEjr91y9hiZ2icHeeqnsWc5k9ekIzfyIjzlxWTCcfHqpD5q	\N	yessikamora@gmail.com	\N	\N	\N	activo	2026-09-15 15:54:24.646146-04	\N	4	\N	yessikamora	\N	\N	\N	\N	\N	f	\N	\N
443	V-13793218	Carmen Lorena	Garcia Alvarez	$2b$10$qvNj4TCwi7GnNrQes0.hTu7nyP0r3uoBYNLR9XJWhywuYoSEok0Uy	\N	CARMENGARCIA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 15:55:07.710736-04	\N	4	\N	CARMENGARCIA	\N	\N	\N	\N	\N	f	\N	\N
444	V-21003299	Karen K	Gomez G	$2b$10$Sw1mP4xnNpvfBlPd9qaL1uw7GZfhYX0VUv9diFCDQ.fZTx9.YfqnG	\N	karengomez@gmail.com	\N	\N	\N	activo	2026-09-15 15:57:32.247333-04	\N	4	\N	karengomez	\N	\N	\N	\N	\N	f	\N	\N
445	V-21085565	Yeysabeth Y	Pineda H	$2b$10$JCHKx68xMvhTQ0d4swMFAuzvnjZlSVSIg8kPTbzh0r8rpyRqYHPUm	\N	yeysabethpineda@gmail.com	\N	\N	\N	activo	2026-09-15 15:59:58.731502-04	\N	4	\N	yeysabethpineda	\N	\N	\N	\N	\N	f	\N	\N
446	V-24151819	Merly Andreina	Ramirez M	$2b$10$LD/v3nFJyc4D04XN/oB.vueWbauwyHLXZg3EwgSECaWNcwjUvcgym	\N	merlyramirez@gmail.com	\N	\N	\N	activo	2026-09-15 16:01:43.716112-04	\N	4	\N	merlyramirez	\N	\N	\N	\N	\N	f	\N	\N
447	V-13304193	Lenys Nohemi	Fuentes Vera	$2b$10$0i2Cpq/Ft.if6K3CU0FQoeqt3j00BpO70SfijzsaNjfuLBsb.7YAG	\N	LENYSF@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:01:44.50254-04	\N	4	\N	LENYSF	\N	\N	\N	\N	\N	f	\N	\N
450	V-24820289	Siaris Yadelsi	Crispin H	$2b$10$ai8nlTz8wFu2u11brDhd3.pCG7VmaNmAfUyYpbdeygSSqM0kWobxm	\N	siariacrispin@gmail.com	\N	\N	\N	activo	2026-09-15 16:11:29.223605-04	\N	4	\N	siariacrispin	\N	\N	\N	\N	\N	f	\N	\N
451	V-14707019	Roberto David	Colmenares Celis	$2b$10$aJKAhaTXcwVjAEZKdUrpAuuLcpW3J9zPXSNo6jtpJLCJoxdWxpYaC	\N	ROBERTOCOLMENARES@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:11:44.539308-04	\N	4	\N	ROBERTOCOLMENARES	\N	\N	\N	\N	\N	f	\N	\N
452	V-14349034	Angel Alexis	Labrador Valero	$2b$10$F23HNEHXiFwbRuP6nzoHW.bwykN3SXwA/9JosSHZSnBwaIO1zSoDq	\N	ANGELABRADOR@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:12:28.492214-04	\N	4	\N	ANGELABRADOR	\N	\N	\N	\N	\N	f	\N	\N
453	V-27227106	Nancy Teresa	Escalante C	$2b$10$Gxn8Xv.ZUupIWvslyscEVuqLW0NeT0af2L1g2eBUoIc4YbnC4xZlG	\N	nancyescalante@gmail.com	\N	\N	\N	activo	2026-09-15 16:13:02.851768-04	\N	4	\N	nancyescalante	\N	\N	\N	\N	\N	f	\N	\N
454	V-16123955	Leonardo Antonio	Abreu Romero	$2b$10$azdbg2WNG/i9BtDURVSU4O.eE9IQoTwhvMeQN7HyuutqB76iSiZa6	\N	leonardoabreu@gmail.com	\N	\N	\N	activo	2026-09-15 16:13:52.858126-04	\N	4	\N	leonardoabreu	\N	\N	\N	\N	\N	f	\N	\N
455	V-12230171	Norlyn Mayela	Castro De D´ Santiago	$2b$10$sgWFcJhI70WLg7lvkQ2gkevgUAH5aMt6MPyTnynhTdA15kVRPWXyi	\N	NORLYNCASTRO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:15:55.580764-04	\N	4	\N	NORLYNCASTRO	\N	\N	\N	\N	\N	f	\N	\N
456	V-14626670	Fran Jonathan	Rosales M	$2b$10$c8f.ZOdXhM1nqbpBNTuuFeeFgHyqgMJW31orBbzQ5uWoFjcWq2Ad2	\N	FRANR@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:17:06.534674-04	\N	4	\N	FRANR	\N	\N	\N	\N	\N	f	\N	\N
457	V-16292912	Kenia Alexandra	Escobar Chacón	$2b$10$cDvBOo32mTvqp5ruEIQQe.LQcsgHivJJFHqAHJs3yw86DNdpNTfPe	\N	KENIAESCOBAR@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:18:59.28253-04	\N	4	\N	KENIAESCOBAR	\N	\N	\N	\N	\N	f	\N	\N
458	V-11497394	Luz Marina	Esteves Canchica	$2b$10$W9e13um5zB/TphVitZ19COTL9AyOoIzkIYA1lwFPO0cGMmJWNtdNS	\N	luzesteves@gmail.com	\N	\N	\N	activo	2026-09-15 16:21:33.94439-04	\N	4	\N	luzesteves	\N	\N	\N	\N	\N	f	\N	\N
459	V-15156594	Lizmary	Zambrano Guerrero	$2b$10$YVYNrxKgub6BSIFbCNCypunSiqIPieb5mKZQOwic30FDpTniBE.0i	\N	LISMARYZAMBRANO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:22:26.293523-04	\N	4	\N	LISMARYZAMBRANO	\N	\N	\N	\N	\N	f	\N	\N
460	V-19768763	Rubi Rossana	Ruiz Salcedo	$2b$10$mYYjAUFH1/urW8Tpoo9tb.0lrOa0IMVFFhGa7xT4hGxV5j0sxFWn.	\N	rubiruiz@gmail.com	\N	\N	\N	activo	2026-09-15 16:24:51.982321-04	\N	4	\N	rubiruiz	\N	\N	\N	\N	\N	f	\N	\N
461	V-15553953	Vigledys María	Salas López	$2b$10$8rKvbWG1KlLf/r9ZfOZ5Xu8oY0y/jlJgDhv/Bktt8yUYpZVQYd1dm	\N	VIGLEDYSSALAS@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:25:01.192742-04	\N	4	\N	VIGLEDYSSALAS	\N	\N	\N	\N	\N	f	\N	\N
462	V-23825753	Jeferson Orlando	Bernal Sandoval	$2b$10$EN57jX5ukKC7ynsrBrPQJ.TFE1UJnWT.D1A0iBPlMys5/ZIBW6IY2	\N	jefersonbernal@gmail.com	\N	\N	\N	activo	2026-09-15 16:26:31.2219-04	\N	4	\N	jefersonbernal	\N	\N	\N	\N	\N	f	\N	\N
463	V-29988512	Fabrizio Alejandro	Beltran Arias	$2b$10$JqO/a7Cb/DadKbG2tyG9IuKcB/m0MNZBM7qmSqaJYhqHatH95X3lO	\N	fabriziobeltran@gmail.com	\N	\N	\N	activo	2026-09-15 16:27:03.375993-04	\N	4	\N	fabriziobeltran	\N	\N	\N	\N	\N	f	\N	\N
464	V-17502948	Sandra Yaneth	Pérez Benitez	$2b$10$6YyEUt/cegIqW71ClYcQx.XgJhQzs7TaD/ezg21Xx8McA791VoqsS	\N	SANDRAPEREZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:27:08.739802-04	\N	4	\N	SANDRAPEREZ	\N	\N	\N	\N	\N	f	\N	\N
465	V-14941778	Maria Luisana	Sanchez Velazco	$2b$10$txkWlqcseq/96thO7Ryu8O9YIzTaguiCpYh52pV4diw96o8Y23GZa	\N	MARIASAN@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:29:10.366174-04	\N	4	\N	MARIASAN	\N	\N	\N	\N	\N	f	\N	\N
466	V-17108886	Anyid Maryela	Rico Soto	$2b$10$6wcH4Kgk.H.om4B/wH8.JeB/samKBrHdnWxiEtToXtU.zQCoQpJDi	\N	ANYIDRICO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:29:41.258402-04	\N	4	\N	ANYIDRICO	\N	\N	\N	\N	\N	f	\N	\N
468	V-16612392	Rina Josefina	Leal Rivera	$2b$10$GutRwbGydEk70JzXdc9ixuBsyUyqb1pY3I4A5mWP7q4Qd59bBRDD2	\N	rinaleal@gmail.com	\N	\N	\N	activo	2026-09-15 16:33:50.43171-04	\N	4	\N	rinaleal	\N	\N	\N	\N	\N	f	\N	\N
469	V-33987641	Josefa Damaris	Boada Bayona	$2b$10$NczVoKmqlPoU.Hw8x8PQyuYPt0U9PZ3AqqN.Z4oP9VCTgDedY9nTS	\N	josefaboada@gmail.com	\N	\N	\N	activo	2026-09-15 16:34:30.924408-04	\N	4	\N	josefaboada	\N	\N	\N	\N	\N	f	\N	\N
470	V-20122969	Lisbeth	Cañas Mendez	$2b$10$RgRe/roziuMKNt3rFIxTQ.C6JC9sfwc9g67HIt3KZ0nGAalgLpp3y	\N	LISBETHCANAS@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:35:03.67541-04	\N	4	\N	LISBETHCANAS	\N	\N	\N	\N	\N	f	\N	\N
471	V-20627665	Neyda Maritza	Contreras De Montaña	$2b$10$u3mbgT0PCnd9CRrlMPRd3.NuSEK5sPhA55pAXSoIsnK10dEuCJ7By	\N	NEYDACONTRERAS@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:37:47.445489-04	\N	4	\N	NEYDACONTRERAS	\N	\N	\N	\N	\N	f	\N	\N
472	V-33283308	Yorkis Jhosimar	Trespalacios Castellanos	$2b$10$IpP6OP48fecCoHPkxYFlSuH56EuBcVQFvXlzl3euAN0zURRex7bPO	\N	yorkistrespalacios@gmail.com	\N	\N	\N	activo	2026-09-15 16:38:05.611774-04	\N	4	\N	yorkistrespalacios	\N	\N	\N	\N	\N	f	\N	\N
473	V-18256178	Beysi Corina	Zambrano Parra	$2b$10$yjeIg.KLsUv99oVk/mw1R.yUs3tZHd.XtyS13YQGFZF2Qcz793Lze	\N	beysizambrano@gmail.com	\N	\N	\N	activo	2026-09-15 16:39:13.107496-04	\N	4	\N	beysizambrano	\N	\N	\N	\N	\N	f	\N	\N
474	V-20628168	Franggy Krisell	Becerra Monsalve	$2b$10$RrNBPpumu0KQRYUDMnuQ3.5II0V0f6BZoFuR4i/7RloChAhPgV/cq	\N	franggybecerra@gmail.com	\N	\N	\N	activo	2026-09-15 16:39:58.85762-04	\N	4	\N	franggybecerra	\N	\N	\N	\N	\N	f	\N	\N
475	V-15433734	Nelly Coromoto	Moreno Sanchez	$2b$10$DNpYUmOP/L0SSoBGLt/wdOTg7bhZV5phiWFXd6RYST.bA1RLNdwM2	\N	MELLYM@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:40:24.63201-04	\N	4	\N	MELLYM	\N	\N	\N	\N	\N	f	\N	\N
476	V-21002581	Olievan Yelena	Contramaestre Hernández	$2b$10$W5erP5ZWEAculVdRlQw0Vu2OHHfWQMYAKa80RZOqtoY27sBf72Z22	\N	OLIEVANCONTRAMAESTRE@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:40:39.283606-04	\N	4	\N	OLIEVANCONTRAMAESTRE	\N	\N	\N	\N	\N	f	\N	\N
477	V-30023482	Wilker Alejandro	Macias Figueroa	$2b$10$p8SRca23YxHVfrSQLRVp8uRT/Yza98tf8KVOYLLFvJnSfuWmP9wPy	\N	wilkermacias@gmail.com	\N	\N	\N	activo	2026-09-15 16:41:07.32678-04	\N	4	\N	wilkermacias	\N	\N	\N	\N	\N	f	\N	\N
467	V-15242022	Andreina A	Alvarran H	$2b$10$B0.NI2h5gXUu5TkuApOt/uzwjXjxJR3ZkxmLF6.giaSFuZZb2miO.	\N	ANDREINA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:33:26.361513-04	2026-09-16 05:14:50.440312-04	4	\N	ANDREINA	\N	\N	\N	\N	\N	f	2026-09-16 05:14:50.440312	\N
449	V-14041785	Vyane Meredith	Ramirez De Pacheco	$2b$10$MwbO3Fkpr.TLZK.tWyOQ5uD5liq0mFBPbwaNJPBWOn5KRCymFo0Da	\N	VYANER@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:07:52.114058-04	2026-09-16 05:47:01.784215-04	4	\N	VYANER	\N	\N	\N	\N	\N	f	2026-09-16 05:47:01.784215	\N
478	V-11501756	Carmen	Moncada Gamez	$2b$10$M1jXV9cfWDL0SBxY22bCUOxgo0Ovo2ji068JdXiS8olxC6/62Uyw6	\N	carmenmoncada@gmail.com	\N	\N	\N	activo	2026-09-15 16:42:16.966022-04	\N	4	\N	carmenmoncada	\N	\N	\N	\N	\N	f	\N	\N
480	V-15701528	Maria Gabriela	Landaeta S	$2b$10$69JIQ7MbcCYmytE/y/zjDur4WwoqH9ipXzz5Ud4DWDZtQ/6Voldie	\N	MARIA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:43:25.214669-04	\N	4	\N	MARIA	\N	\N	\N	\N	\N	f	\N	\N
481	V-14180275	Deyrdre Alexandra	Contreras Díaz	$2b$10$qahLu2kxynGCsVjeQ6gQk.LIKD2FdF8yg6BZQHPPs4qvAu6mJU8Ey	\N	deyrdrecontreras@gmail.com	\N	\N	\N	activo	2026-09-15 16:43:40.059487-04	\N	4	\N	deyrdrecontreras	\N	\N	\N	\N	\N	f	\N	\N
482	V-33849915	Jessica Mayerlyn	Navarro Jaimes	$2b$10$XNNCKJgVJhZRp6eO4je8BuzlXw.0D5KOS3/MVD4SIUsrT6VYSk75.	\N	jessicanavarro@gmail.com	\N	\N	\N	activo	2026-09-15 16:44:00.977706-04	\N	4	\N	jessicanavarro	\N	\N	\N	\N	\N	f	\N	\N
483	V-32071331	Adrian Moises	Ramirez Rivera	$2b$10$hhmg./41FicFhaCL7TdnM.odjPG3N3ZJN2wVIJh5eIwhxvDSuHNE.	\N	adrianramirez@gmail.com	\N	\N	\N	activo	2026-09-15 16:47:17.755812-04	\N	4	\N	adrianramirez	\N	\N	\N	\N	\N	f	\N	\N
484	V-17502136	Paola Mayerlyn	Ostos Sánchez	$2b$10$Gs2zpdXpDxT4l0WQa9/DsunUQwFibgaVja3.6swfIDXdcPTbd6Bx.	\N	paolaostos@gmail.com	\N	\N	\N	activo	2026-09-15 16:48:47.712639-04	\N	4	\N	paolaostos	\N	\N	\N	\N	\N	f	\N	\N
485	V-17169057	Kimberly Karelyn	Omaña Velazco	$2b$10$UGfzG4X6/zbm2GpN9SHfnegfbao06IjdIq9aXt65WAT61jjh6OENy	\N	KIMBERLYOMANA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:49:01.202351-04	\N	4	\N	KIMBERLYOMANA	\N	\N	\N	\N	\N	f	\N	\N
486	V-33975257	Dayana Andreina	Rivera Ramirez	$2b$10$lRC7AqQTucK3VsvlyvTtCe7zt1NTKZJKKXTQ7Dq6DrlWdy/yPaa1K	\N	dayanarivera@gmail.com	\N	\N	\N	activo	2026-09-15 16:49:27.887806-04	\N	4	\N	dayanarivera	\N	\N	\N	\N	\N	f	\N	\N
487	V-16983864	Eva Yoleiza	Rodríguez Alviárez	$2b$10$rZTVeXgHvQA8we4LW8HmJeh1h7cpDgsQ5fX/i4kHlABdFREafn8om	\N	EVARODRIGUEZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:51:47.630753-04	\N	4	\N	EVARODRIGUEZ	\N	\N	\N	\N	\N	f	\N	\N
488	V-24779461	Genesis Katherine	Neira Reyes	$2b$10$EMhK7CkGOOkWpjwiy.3FKOlwSHOLDBIGRrRF1Z1/pTiWVVhWmvfwa	\N	genesisneira@gmail.com	\N	\N	\N	activo	2026-09-15 16:51:58.167179-04	\N	4	\N	genesisneira	\N	\N	\N	\N	\N	f	\N	\N
490	V-15972857	Leonardo Alfredo	Aponte Naveda	$2b$10$0kunbNv77ryT4k5W6zb4Cee4EepeULAjGLdh5YhfjwWv3tm4g6qFm	\N	APONTELEO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:52:42.641185-04	\N	4	\N	APONTELEO	\N	\N	\N	\N	\N	f	\N	\N
491	V-17646957	Yery Coromoto	Sanguino Parada	$2b$10$91NpQ8/joc0vz/Ae.TaBgOYrwfasW0vOqua9zicL.ESmphGgzvo9u	\N	YERYSANGUINO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:53:48.423757-04	\N	4	\N	YERYSANGUINO	\N	\N	\N	\N	\N	f	\N	\N
492	V-19135726	Brigitte Samirelly	Contreras Uribe	$2b$10$6MWCYZTzol.x7QVz.cMO7.ArF/X9k1j8onjMaS9qPQm0Z1rrjPAse	\N	brigettecontreras@gmail.com	\N	\N	\N	activo	2026-09-15 16:55:27.088401-04	\N	4	\N	brigettecontreras	\N	\N	\N	\N	\N	f	\N	\N
493	V-16777189	Gregoriana Del Carmen	Pernía De Borrero	$2b$10$jxXZ81wLgNiWnh5QnkCyp.jwG5rzbEvHw5xKAsG8tCfORSNyabXPq	\N	GREGORIANAPERNIA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:55:52.627676-04	\N	4	\N	GREGORIANAPERNIA	\N	\N	\N	\N	\N	f	\N	\N
494	V-16122891	Carmen Susana	Gomez Guerrero	$2b$10$jLvFLLHLUw5qXHHV5kp..esMkjlmPOL/rCclpLa1hx07StyJTphEy	\N	GOMEZCARMEN@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:58:01.302482-04	\N	4	\N	GOMEZCARMEN	\N	\N	\N	\N	\N	f	\N	\N
495	V-17966997	Maria Teresa	Mogrovejo Chacón	$2b$10$L5lurOVGWdD81UHXYkBOeufYKIwKbU6NV37/cl5IYAnjaj.uB..PW	\N	mariamogrovejo@gmail.com	\N	\N	\N	activo	2026-09-15 17:01:15.827048-04	\N	4	\N	mariamogrovejo	\N	\N	\N	\N	\N	f	\N	\N
496	V-33737551	Maria Del Mar	Contreras Perez	$2b$10$jKd3PR//eGq7eQsPj1alJOQBIp3NzKAeeqPbhzbMQqnv1Y0CXiyGC	\N	mariacontreras@gmail.com	\N	\N	\N	activo	2026-09-15 17:01:58.495411-04	\N	4	\N	mariacontreras	\N	\N	\N	\N	\N	f	\N	\N
497	V-16122914	Johana Carolina	Gonzalez Zambrano	$2b$10$djj.Q/3zMk0RfvwN01yjrOE0mKWHmxXRg5Wmx3UfFvayAh/nErzAi	\N	GONZALEZJO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:02:50.91173-04	\N	4	\N	GONZALEZJO	\N	\N	\N	\N	\N	f	\N	\N
498	V-34135758	Keila Mirlady	Pulido Chacon	$2b$10$ERjD9e..CjDq/QKybxSsjOx3F9Eb7yn9t1lOk92Srl9mFxuOMXt4i	\N	keilapulido@gmail.com	\N	\N	\N	activo	2026-09-15 17:05:14.54417-04	\N	4	\N	keilapulido	\N	\N	\N	\N	\N	f	\N	\N
499	V-13351965	Ligia Gabriela	Ballesteros De Ramírez	$2b$10$3uNY6.SVo7aLr07VwSJO.Oi4WQwHbetr4OSbIL/776t3DnbxwTUz6	\N	ligiaballesteros@gmail.com	\N	\N	\N	activo	2026-09-15 17:06:11.611115-04	\N	4	\N	ligiaballesteros	\N	\N	\N	\N	\N	f	\N	\N
500	V-16422431	Adrian Jose	Ontiveros Rueda	$2b$10$qpKJ.ajU4Z35vqr5P78KsO5pPDX9QgMCYYVsyabyyaVQsOZw6Bg.G	\N	ONTIVEROSAD@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:06:13.075204-04	\N	4	\N	ONTIVEROSAD	\N	\N	\N	\N	\N	f	\N	\N
501	V-34125472	Darcy Yulitza	Contreras De Gelves	$2b$10$aU1I7xmkDqND59hLSN6.yunEIrm1qpW3/JVnb4VDdhrMU7pVva5EC	\N	darcycontreras@gmail.com	\N	\N	\N	activo	2026-09-15 17:08:17.5131-04	\N	4	\N	darcycontreras	\N	\N	\N	\N	\N	f	\N	\N
502	V-16541402	Yoselyn De La Consolacion	Dueñas De A	$2b$10$whfhwUTzg5zD0MDXvxUgu.j7KmLsLv0w5UyAiSDpbIuz71Yxml5.K	\N	YOSELYN@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:09:20.088523-04	\N	4	\N	YOSELYN	\N	\N	\N	\N	\N	f	\N	\N
503	V-17646918	Hungría Paola	Molina Homez	$2b$10$tfzsoprE8RXH0v.vJK0Y7uBl/hvx00MztaFy/30R2rfGn81BedO1G	\N	hungriamolina@gmail.com	\N	\N	\N	activo	2026-09-15 17:10:31.807895-04	\N	4	\N	hungriamolina	\N	\N	\N	\N	\N	f	\N	\N
504	V-11492237	Oleyda Cecilia	Guerrero Ramirez	$2b$10$6q6uCOuyyQOO7xSpI1MEF.fjyYz6IKsygh1bd9V2VNm6MT4sAx6SS	\N	oleydaguerrero@gmail.com	\N	\N	\N	activo	2026-09-15 17:11:06.924624-04	\N	4	\N	oleydaguerrero	\N	\N	\N	\N	\N	f	\N	\N
505	V-17208771	Haylen Yahitza	Perez Gonzalez	$2b$10$GEqq6QOiTfZvgnZrSeMrHepcpb2QwGm2f5SKDg5lvw8entpTn7oS2	\N	HAYLENP@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:12:05.249844-04	\N	4	\N	HAYLENP	\N	\N	\N	\N	\N	f	\N	\N
506	V-18089398	Angie Rebeca	Manosalva C	$2b$10$WTo1WtwFNjCA1gwQlR09VefI3IafJC5I5QrI84ZDxnkTaPxiixsZ2	\N	ANGIEMAN@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:15:19.012337-04	\N	4	\N	ANGIEMAN	\N	\N	\N	\N	\N	f	\N	\N
507	V-24355257	Mafer Isabel	Méndez Gómez	$2b$10$yc5JeqOkNU5uodtM5i2Q7uGc9EPet.9kE0reHclr0D0U7IukneIP.	\N	mafermendez@gmail.com	\N	\N	\N	activo	2026-09-15 17:16:50.045472-04	\N	4	\N	mafermendez	\N	\N	\N	\N	\N	f	\N	\N
508	V-18959698	Jeniree Johana	Bonilla De C	$2b$10$bWZbJtxqnWjoKy8ObaIvwOeEDbDeIhj36j52v.Vov/cKPWm0C37sq	\N	BONILLAJOH@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:17:33.5563-04	\N	4	\N	BONILLAJOH	\N	\N	\N	\N	\N	f	\N	\N
509	V-17501076	Erika Yoselin	Ramírez Gutiérrez	$2b$10$UpKVsbe0uM/jyOvzs8.CBexodEmT73cYX5QmRS3nOLkL0GPTLoGsu	\N	erikaramirez@gmail.com	\N	\N	\N	activo	2026-09-15 17:20:30.117329-04	\N	4	\N	erikaramirez	\N	\N	\N	\N	\N	f	\N	\N
510	V-18989617	Jessica Wilmar	Prieto Leal	$2b$10$8i/jBDyTUagpnrbS3VtLDeUplzzzEKTHTNVDOoEQfh2RSR/wxQ93O	\N	PRIETOJ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:23:14.412735-04	\N	4	\N	PRIETOJ	\N	\N	\N	\N	\N	f	\N	\N
511	V-14265289	Nancy Melania	Chacon Lobo	$2b$10$m117Wyd8s0i.9mUZB.tAzuGsba7Uuo.rLFjP068J5JfvJMmUVkKVG	\N	nancychacon@gmail.com	\N	\N	\N	activo	2026-09-15 17:23:35.987436-04	\N	4	\N	nancychacon	\N	\N	\N	\N	\N	f	\N	\N
512	V-19599698	Daisy Florelvy	Murillo De G	$2b$10$eLL8rxMJKBwGRXHXcXiiF.y5gsAdHONWnjb9NYnjx4Zy2zPw9FCjm	\N	MURILLOD@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:26:23.442525-04	\N	4	\N	MURILLOD	\N	\N	\N	\N	\N	f	\N	\N
513	V-19665275	Sarahi De La T	Medina Tarazona	$2b$10$wzTlqs2M8vsSx1AcmoXDlOaQl4L/g0dZZSp4vdqmBCbj3yU2yGBka	\N	MEDINASAR@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:30:31.200367-04	\N	4	\N	MEDINASAR	\N	\N	\N	\N	\N	f	\N	\N
514	V-19977635	Nirian Katerine	Escalante Manosalva	$2b$10$n7Z1qv0A0T1xU0P41LTHMOvWSOheoO0ZbiRUnxr3bMB90yTK9Dc1y	\N	nirianescalante@gmail.com	\N	\N	\N	activo	2026-09-15 17:30:46.850075-04	\N	4	\N	nirianescalante	\N	\N	\N	\N	\N	f	\N	\N
515	V-16122118	Marian D	Prieto Cárdenas	$2b$10$WcLlennoiz7kca9NyiAjbuaUDNkTgW2zveJOPVVb8afW/5khHS6s2	\N	marianprieto@gmail.com	\N	\N	\N	activo	2026-09-15 17:31:50.737111-04	\N	4	\N	marianprieto	\N	\N	\N	\N	\N	f	\N	\N
516	V-19769779	Alba Marina	Guerrero L	$2b$10$PMGjPZGvi72j0EEO1AWdVewYZo/.vzxa1uNU64g//81MtrbhHuI7S	\N	GUERREEROMA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:33:15.834618-04	\N	4	\N	GUERREEROMA	\N	\N	\N	\N	\N	f	\N	\N
479	V-16019009	Carla Andreina	Herrera Araujo	$2b$10$eV5MATd8WRTJ0y3UdaKCGOEi90Yr/mfUS4BOoT8bd/9QQavMJqX3y	\N	CARLAHERRERA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:42:21.353589-04	2026-09-16 04:49:55.755208-04	4	\N	CARLAHERRERA	\N	\N	\N	\N	\N	f	2026-09-16 04:49:55.755208	\N
517	V-17107153	Flor Yeaneth	Rojas Prieto	$2b$10$pQDnUW/84COWg1ft71slNOI83AGlhaMIi6mQcm8xC1SFOWuXjKP8m	\N	florrojas@gmail.com	\N	\N	\N	activo	2026-09-15 17:34:03.93429-04	\N	4	\N	florrojas	\N	\N	\N	\N	\N	f	\N	\N
518	V-20425205	Yennifer Y	Perez Jaimes	$2b$10$OJv5ShZfDoeGIWDHOjMmn.r53OrLEn3x7Zd7d2kMfktccR3.uNIb2	\N	PEREZYEN@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:36:04.078866-04	\N	4	\N	PEREZYEN	\N	\N	\N	\N	\N	f	\N	\N
519	V-18566247	Karin Yurgey	Moreno	$2b$10$av4B.U3BqMd4x6xvJLljb.YAH0/gmgUJlUWMDCXI8H7S4AUPCgIUe	\N	karinmoreno@gmail.com	\N	\N	\N	activo	2026-09-15 17:37:53.29629-04	\N	4	\N	karinmoreno	\N	\N	\N	\N	\N	f	\N	\N
520	V-19358737	María Fernanda	Duque Bonilla	$2b$10$J8/xNsz0SegOg6NvrzpfV.UHqzO7AfQvRdftHZkCSsWzllwmQZb5S	\N	MARIADUQUE@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:38:46.030843-04	\N	4	\N	MARIADUQUE	\N	\N	\N	\N	\N	f	\N	\N
521	V-18090256	Amanda Banigza	Laguado Oliveros	$2b$10$AOiX.JkhhiFHTGHDaO5VYOAQfYayODRXJ4vS2XDF59akYug1aC1JC	\N	amandalaguado@gmail.com	\N	\N	\N	activo	2026-09-15 17:39:35.720002-04	\N	4	\N	amandalaguado	\N	\N	\N	\N	\N	f	\N	\N
522	V-22677023	Maria De Los Angeles	Martinez O	$2b$10$8kO1DxL5IjiDp8/Q99ZRU.CWpOOmZTm4qQBcDNnAM7gnWUPigRSc2	\N	MARIAMAR@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:43:29.13023-04	\N	4	\N	MARIAMAR	\N	\N	\N	\N	\N	f	\N	\N
523	V-12622772	Marllory Del Carmen	Sánchez León	$2b$10$zY1K5mlla2JjlNE7EwiVDeaGk.I8sJNQkcdkbbCFa1jfghr1XZFbK	\N	MARLLORYSANCHEZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:43:30.005188-04	\N	4	\N	MARLLORYSANCHEZ	\N	\N	\N	\N	\N	f	\N	\N
524	V-17368980	María Andreína	Pulido Angarita	$2b$10$RFGfewnGsxpmI3LQ3SqD.uHkUN8rWUvFubHOIKr5wRqHlGpdd1sOS	\N	mariapulido@gmail.com	\N	\N	\N	activo	2026-09-15 17:44:45.192681-04	\N	4	\N	mariapulido	\N	\N	\N	\N	\N	f	\N	\N
525	V-18256704	Sthefania	Briceño Fernández	$2b$10$i86RV73uBVKabrLZZ5qay.Vp5VzuneC6EZOw0moiOtmLlQuKkp7nm	\N	STHEFANIABRICENO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:46:46.162906-04	\N	4	\N	STHEFANIABRICENO	\N	\N	\N	\N	\N	f	\N	\N
526	V-34661243	Lorena Elizabeth	Harms Becerra	$2b$10$MZRX2rN443gPNcu6bK3QbO1Jyg6gTPlvtKWr88O2DQhHDdAU1bJiS	\N	LORENAHARMS@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:51:47.525683-04	\N	4	\N	LORENAHARMS	\N	\N	\N	\N	\N	f	\N	\N
527	V-13972034	Carmen Elisa	Carvajal Espinosa	$2b$10$qtjbfaI5bmaIcxOUmLMykuIyJHXDqtkEhoV7DaPSGAxP984vE/JVy	\N	CARMENCARVAJAL@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:55:55.112936-04	\N	4	\N	CARMENCARVAJAL	\N	\N	\N	\N	\N	f	\N	\N
528	V-12491336	Ingrid Yusmary	Freites Sanchez	$2b$10$oY9i0y8xLbq9.K/lU6FxBeKFvO/L2ySAp0XP/o4YSHwMypUgppwAm	\N	INGRIDFREITES@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:57:48.626001-04	\N	4	\N	INGRIDFREITES	\N	\N	\N	\N	\N	f	\N	\N
529	V-12233443	Erika Yulbana	Rico Monsalve	$2b$10$wVLVY90OtK6SuJ1JkGU7t.UbYRsqS67w38EiiYHK2rFxIdj1j8gd2	\N	ERIKARICO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 17:58:21.388747-04	\N	4	\N	ERIKARICO	\N	\N	\N	\N	\N	f	\N	\N
530	V-21550385	Lorena	Becerra Ortiz	$2b$10$frxYuDZX8ECXJQeuJZeDIeY3xuJJfh.qq0J/JSpyX.q3qYoBK/wa6	\N	LORENABECERRA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:00:37.496542-04	\N	4	\N	LORENABECERRA	\N	\N	\N	\N	\N	f	\N	\N
531	V-12490923	Nidia Rosa	Pabón Chacón	$2b$10$h/lSoqdyewuuZbjpzE/acewJmmO8XJEDgL6t2.WMBgyTTTxZIxpx.	\N	NIDIAPABON@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:03:23.267335-04	\N	4	\N	NIDIAPABON	\N	\N	\N	\N	\N	f	\N	\N
532	V-34504967	Deissy Maribel	Alviarez Chacon	$2b$10$rzZksCWk60x11NkWwVc2duioHS.PjTGnXrxkffyhjkrB1lrHSTVCy	\N	DEISSYALVIAREZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:03:58.10919-04	\N	4	\N	DEISSYALVIAREZ	\N	\N	\N	\N	\N	f	\N	\N
533	V-34775752	Sandra Sirley	Plata Sanchez	$2b$10$O6FmvcEQWWdnwo7jVPkajexahWbVkeTxZsdqkPSJ1HTFc22EGFvlG	\N	SANDRAPLATA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:07:01.404097-04	\N	4	\N	SANDRAPLATA	\N	\N	\N	\N	\N	f	\N	\N
534	V-15324997	Jusdely Carolina	Salcedo Aranguren	$2b$10$IBTmz1G8XE75EFghb3j4B.es.Jhv4Xe/LP36vTSeNi0QvsMbaO4Ze	\N	JUSDELYSALCEDO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:11:13.349235-04	\N	4	\N	JUSDELYSALCEDO	\N	\N	\N	\N	\N	f	\N	\N
536	V-13148256	Leida A	Arellano Sanchez	$2b$10$IwLdZIbkNRZJv1iRyy3Vpe31qM7730.Wolaz1PkoYvTGCJW0x.ALW	\N	LEIDAARELLANO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:22:26.222814-04	\N	4	\N	LEIDAARELLANO	\N	\N	\N	\N	\N	f	\N	\N
537	V-31098013	Maria Mercedes	Moreno Suarez	$2b$10$rOxIhCnAJAk1wsxpcx12vuVY6L3y5vdq/pQWaTbGeGaqZVfBochBm	\N	MARIAMORENO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:29:46.526153-04	\N	4	\N	MARIAMORENO	\N	\N	\N	\N	\N	f	\N	\N
538	V-15501343	Yerina Danelya	Sandia Vidal	$2b$10$/aZAUWQYS5aLqnG1l8Pg9eqyJrG5/PJ9xug6bHHItPnwn1if9K0nC	\N	YERINASANDIA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:33:16.731754-04	\N	4	\N	YERINASANDIA	\N	\N	\N	\N	\N	f	\N	\N
539	V-14942368	Cayrni Marivet	Becerra Acevedo	$2b$10$6rL16fPZCq4Q0KdhIP/92eYqRB1EzmcZBdAaaq2yRtzlJqPyATcm6	\N	CAYRNIBECERRA@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:35:14.726991-04	\N	4	\N	CAYRNIBECERRA	\N	\N	\N	\N	\N	f	\N	\N
540	V-11507560	Aura Karina	Martinez De Osma	$2b$10$TFIHCmfAOtwfmp6ko4LKDefWjKFH7Kr8fA6RE8.LS0j2IH8t6wwO6	\N	AURAMARTINEZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:37:24.429376-04	\N	4	\N	AURAMARTINEZ	\N	\N	\N	\N	\N	f	\N	\N
541	V-11495710	Aura Jacqueline	Ramirez De Rosales	$2b$10$b3/s/cD1nRmBodxPduARJuIztE7GvxzVkFpqko2Rn1Y9ePKDvNSoW	\N	AURARAMIREZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:39:22.103655-04	\N	4	\N	AURARAMIREZ	\N	\N	\N	\N	\N	f	\N	\N
18	V-12351245	ANA LETICIA	ZAMBRANO PÉREZ	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	ana.zambrano1245@endanza.com	1975-08-02	\N	\N	Activo	\N	2026-09-16 04:12:19.709904-04	5	\N	ana1245	\N	\N	\N	\N	\N	f	2026-09-16 04:12:19.709904	\N
6	V-14179269	YELITZA ROSALIA	GUERRERO GUERRERO	$2b$10$eISQiUxhAuWzRCGggTpyOeV0jQsjIi3pzqxaTay5sXLXpdE18LL5O	\N	yelitza.guerrero9269@endanza.com	1977-11-02	\N	\N	Activo	\N	2026-09-16 04:16:26.378654-04	2	\N	yelitza9269	\N	\N	\N	\N	\N	f	2026-09-16 04:16:26.378654	\N
489	V-34504797	Luisana L	Polanco Aguilar	$2b$10$meP7H0WqMfl.btxwbUZkRO1Inhsrp7F3Qah.d93ybgTtLm7YlH/gC	\N	luisanapolanco@gmail.com	\N	\N	\N	activo	2026-09-15 16:51:58.388754-04	2026-09-16 04:37:51.887035-04	4	\N	luisanapolanco	\N	\N	\N	\N	\N	f	2026-09-16 04:37:51.887035	\N
448	V-18790133	Stephanie Lisset	Márquez Castro	$2b$10$PJNSNzub3bxZEm8.n3wSMOAV0iOpYl5qAvH1ySr1jUzY630qp6Kmm	\N	STEPHANIEMARQUEZ@GMAIL.COM	\N	\N	\N	activo	2026-09-15 16:06:15.66778-04	2026-09-16 04:40:04.589107-04	4	\N	STEPHANIEMARQUEZ	\N	\N	\N	\N	\N	f	2026-09-16 04:40:04.589107	\N
535	V-9244001	Claudia Margarita	Toscano Duarte	$2b$10$ji/plt9u1K52GtAJBhGfF.LvuwN4jIW4BTFKQDa51y8waxxX/jQfK	\N	CLAUDIATOSCANO@GMAIL.COM	\N	\N	\N	activo	2026-09-15 18:16:15.356623-04	2026-09-16 05:12:47.082084-04	4	\N	CLAUDIATOSCANO	\N	\N	\N	\N	\N	f	2026-09-16 05:12:47.082084	\N
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
30	2	2026-09-12 09:17:25.370673
1	1	2026-09-12 09:17:25.370673
1	2	2026-09-12 09:44:14.80292
1	3	2026-09-12 09:44:14.81919
1	4	2026-09-12 09:44:14.821605
1	5	2026-09-12 09:44:14.824113
430	4	2026-09-15 19:16:17.53311
431	4	2026-09-15 19:25:18.08076
432	4	2026-09-15 19:27:59.178379
433	4	2026-09-15 19:31:40.229149
434	4	2026-09-15 19:35:33.906818
435	4	2026-09-15 19:38:39.080913
436	4	2026-09-15 19:41:55.035933
437	4	2026-09-15 19:45:38.515538
438	4	2026-09-15 19:48:27.321977
439	4	2026-09-15 19:49:26.852264
440	4	2026-09-15 19:50:15.717833
441	4	2026-09-15 19:52:18.221754
442	4	2026-09-15 19:54:24.646146
443	4	2026-09-15 19:55:07.710736
444	4	2026-09-15 19:57:32.247333
445	4	2026-09-15 19:59:58.731502
446	4	2026-09-15 20:01:43.716112
447	4	2026-09-15 20:01:44.50254
448	4	2026-09-15 20:06:15.66778
449	4	2026-09-15 20:07:52.114058
450	4	2026-09-15 20:11:29.223605
451	4	2026-09-15 20:11:44.539308
452	4	2026-09-15 20:12:28.492214
453	4	2026-09-15 20:13:02.851768
454	4	2026-09-15 20:13:52.858126
455	4	2026-09-15 20:15:55.580764
456	4	2026-09-15 20:17:06.534674
457	4	2026-09-15 20:18:59.28253
458	4	2026-09-15 20:21:33.94439
459	4	2026-09-15 20:22:26.293523
460	4	2026-09-15 20:24:51.982321
461	4	2026-09-15 20:25:01.192742
462	4	2026-09-15 20:26:31.2219
463	4	2026-09-15 20:27:03.375993
464	4	2026-09-15 20:27:08.739802
465	4	2026-09-15 20:29:10.366174
466	4	2026-09-15 20:29:41.258402
467	4	2026-09-15 20:33:26.361513
468	4	2026-09-15 20:33:50.43171
469	4	2026-09-15 20:34:30.924408
470	4	2026-09-15 20:35:03.67541
471	4	2026-09-15 20:37:47.445489
472	4	2026-09-15 20:38:05.611774
473	4	2026-09-15 20:39:13.107496
474	4	2026-09-15 20:39:58.85762
475	4	2026-09-15 20:40:24.63201
476	4	2026-09-15 20:40:39.283606
477	4	2026-09-15 20:41:07.32678
478	4	2026-09-15 20:42:16.966022
479	4	2026-09-15 20:42:21.353589
480	4	2026-09-15 20:43:25.214669
481	4	2026-09-15 20:43:40.059487
482	4	2026-09-15 20:44:00.977706
483	4	2026-09-15 20:47:17.755812
484	4	2026-09-15 20:48:47.712639
485	4	2026-09-15 20:49:01.202351
486	4	2026-09-15 20:49:27.887806
487	4	2026-09-15 20:51:47.630753
488	4	2026-09-15 20:51:58.167179
489	4	2026-09-15 20:51:58.388754
490	4	2026-09-15 20:52:42.641185
491	4	2026-09-15 20:53:48.423757
492	4	2026-09-15 20:55:27.088401
493	4	2026-09-15 20:55:52.627676
494	4	2026-09-15 20:58:01.302482
495	4	2026-09-15 21:01:15.827048
496	4	2026-09-15 21:01:58.495411
497	4	2026-09-15 21:02:50.91173
498	4	2026-09-15 21:05:14.54417
499	4	2026-09-15 21:06:11.611115
500	4	2026-09-15 21:06:13.075204
501	4	2026-09-15 21:08:17.5131
502	4	2026-09-15 21:09:20.088523
503	4	2026-09-15 21:10:31.807895
504	4	2026-09-15 21:11:06.924624
505	4	2026-09-15 21:12:05.249844
506	4	2026-09-15 21:15:19.012337
507	4	2026-09-15 21:16:50.045472
508	4	2026-09-15 21:17:33.5563
509	4	2026-09-15 21:20:30.117329
510	4	2026-09-15 21:23:14.412735
511	4	2026-09-15 21:23:35.987436
512	4	2026-09-15 21:26:23.442525
513	4	2026-09-15 21:30:31.200367
514	4	2026-09-15 21:30:46.850075
515	4	2026-09-15 21:31:50.737111
516	4	2026-09-15 21:33:15.834618
517	4	2026-09-15 21:34:03.93429
518	4	2026-09-15 21:36:04.078866
519	4	2026-09-15 21:37:53.29629
520	4	2026-09-15 21:38:46.030843
521	4	2026-09-15 21:39:35.720002
522	4	2026-09-15 21:43:29.13023
523	4	2026-09-15 21:43:30.005188
524	4	2026-09-15 21:44:45.192681
525	4	2026-09-15 21:46:46.162906
526	4	2026-09-15 21:51:47.525683
527	4	2026-09-15 21:55:55.112936
528	4	2026-09-15 21:57:48.626001
529	4	2026-09-15 21:58:21.388747
530	4	2026-09-15 22:00:37.496542
531	4	2026-09-15 22:03:23.267335
532	4	2026-09-15 22:03:58.10919
533	4	2026-09-15 22:07:01.404097
534	4	2026-09-15 22:11:13.349235
535	4	2026-09-15 22:16:15.356623
536	4	2026-09-15 22:22:26.222814
537	4	2026-09-15 22:29:46.526153
538	4	2026-09-15 22:33:16.731754
539	4	2026-09-15 22:35:14.726991
540	4	2026-09-15 22:37:24.429376
541	4	2026-09-15 22:39:22.103655
30	4	2026-09-16 05:31:38.900026
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

SELECT pg_catalog.setval('public."Estudiante_Id_estudiante_seq"', 710, true);


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

SELECT pg_catalog.setval('public."Horario_Id_horario_seq"', 12, true);


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

SELECT pg_catalog.setval('public."Representante_Id_representante_seq"', 486, true);


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

SELECT pg_catalog.setval('public."Seccion_Id_seccion_seq"', 104, true);


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

SELECT pg_catalog.setval('public."Usuario_Id_usuario_seq"', 541, true);


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
-- Name: Especialidad uq_especialidad_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Especialidad"
    ADD CONSTRAINT uq_especialidad_nombre UNIQUE (nombre_especialidad);


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
-- Name: Estudiante fk_estudiante_especialidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante"
    ADD CONSTRAINT fk_estudiante_especialidad FOREIGN KEY ("Id_especialidad") REFERENCES public."Especialidad"("Id_especialidad") ON DELETE SET NULL;


--
-- Name: Estudiante_Seccion fk_estudiante_seccion_especialidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Estudiante_Seccion"
    ADD CONSTRAINT fk_estudiante_seccion_especialidad FOREIGN KEY ("Id_especialidad") REFERENCES public."Especialidad"("Id_especialidad") ON DELETE SET NULL;


--
-- Name: Horario fk_horario_materia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Horario"
    ADD CONSTRAINT fk_horario_materia FOREIGN KEY ("Id_materia") REFERENCES public."Materia"("Id_materia");


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
-- Name: Seccion fk_seccion_especialidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seccion"
    ADD CONSTRAINT fk_seccion_especialidad FOREIGN KEY ("Id_especialidad") REFERENCES public."Especialidad"("Id_especialidad") ON DELETE SET NULL;


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

\unrestrict Qe6saIonhkaODssT5jq078mBp3URdDUKtfgr42m4ao25S8HcgQWzApe0TM5ns2w

