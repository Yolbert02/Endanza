/* 1. CONFIGURACIÓN ACADÉMICA */

const configuracionAcademica = {

    notaMinimaAprobatoria: 10,
    porcentajeMaximoInasistencias: 25,
    lapsoInicial: 1,
    lapsoFinal: 3

};


/* 2. CONFIGURACIÓN DEL BOLETÍN */

const configuracionBoletin = {

    lapsoActual: 3

};


/* 3. DATOS DEL ESTUDIANTE */

const estudiante = {

    nombres: "María José",
    apellidos: "Pérez González",
    cedula: "V-30.123.456",
    grado: "5.º año",
    seccion: "A",
    anioEscolar: "2025 - 2026",
    fechaEmision: "08 de agosto de 2026"

};


/* 4. DATOS ACADÉMICOS */

const calificaciones = [

    {
        asignatura: "Danza Clásica",
        lapso1: 10,
        lapso2: 12,
        lapso3: 13,
        reparacion: 10,
        inasistencias: 10,
        clasesProgramadas: 40
    },

    {
        asignatura: "Danza Contemporánea",
        lapso1: 16,
        lapso2: 18,
        lapso3: 17,
        reparacion: 12,
        inasistencias: 4,
        clasesProgramadas: 40
    },

    {
        asignatura: "Danza Tradicional",
        lapso1: 19,
        lapso2: 19,
        lapso3: 20,
        reparacion: null,
        inasistencias: 1,
        clasesProgramadas: 40
    },

    {
        asignatura: "Preparación Física",
        lapso1: 15,
        lapso2: 16,
        lapso3: 17,
        reparacion: null,
        inasistencias: 3,
        clasesProgramadas: 40
    },

    {
        asignatura: "Música",
        lapso1: 18,
        lapso2: 17,
        lapso3: 18,
        reparacion: null,
        inasistencias: 2,
        clasesProgramadas: 40
    },

    {
        asignatura: "Kinesiología",
        lapso1: 10,
        lapso2: 10,
        lapso3: 6,
        reparacion: 9,
        inasistencias: 5,
        clasesProgramadas: 40
    }

];


/* 5. PROMOCIÓN ESPECIAL */

const promocion = {

    promovido: false,
    siguienteNivel: "6.º año",
    promocionUtilizada: false

};


/* 6. OBSERVACIONES */

const observaciones =
    "El estudiante ha demostrado un desempeño satisfactorio durante el período académico. Se recomienda continuar fortaleciendo sus habilidades técnicas y artísticas.";


/* 7. INICIALIZACIÓN */

document.addEventListener("DOMContentLoaded", () => {

    inicializarBoletin();

});


/* 8. INICIALIZAR BOLETÍN */

function inicializarBoletin() {

    validarConfiguracion();
    cargarDatosEstudiante();
    cargarTituloBoletin();
    cargarCalificaciones();
    cargarResumen();
    cargarResultadoAcademico();

}


/* 9. VALIDAR CONFIGURACIÓN */

function validarConfiguracion() {

    let lapso = configuracionBoletin.lapsoActual;

    if (
        lapso < configuracionAcademica.lapsoInicial ||
        lapso > configuracionAcademica.lapsoFinal
    ) {

        console.error(
            "Error: el lapso seleccionado no es válido."
        );

        configuracionBoletin.lapsoActual = 1;

    }

}


/* 10. DATOS DEL ESTUDIANTE */

function cargarDatosEstudiante() {

    document.getElementById(
        "nombre-estudiante"
    ).textContent =
        `${estudiante.nombres} ${estudiante.apellidos}`;


    document.getElementById(
        "cedula-estudiante"
    ).textContent =
        estudiante.cedula;


    document.getElementById(
        "grado-estudiante"
    ).textContent =
        estudiante.grado;


    document.getElementById(
        "seccion-estudiante"
    ).textContent =
        estudiante.seccion;


    document.getElementById(
        "anio-escolar"
    ).textContent =
        estudiante.anioEscolar;


    document.getElementById(
        "fecha-emision"
    ).textContent =
        estudiante.fechaEmision;

}


/* 11. TÍTULO DEL BOLETÍN */

function cargarTituloBoletin() {

    const titulo =
        document.getElementById("titulo-boletin");

    if (!titulo) {

        return;

    }


    const nombresLapso = {

        1: "I LAPSO",
        2: "II LAPSO",
        3: "III LAPSO"

    };


    titulo.textContent =
        `BOLETÍN ACADÉMICO — ${nombresLapso[configuracionBoletin.lapsoActual]}`;

}


/* 12. OBTENER NOTA DE UN LAPSO */

function obtenerNotaLapso(materia, lapso) {

    /*
     * Si el estudiante fue promovido,
     * solamente se utiliza la nota del primer lapso.
     */

    if (promocion.promovido) {

        if (lapso === 1) {

            return materia.lapso1;

        }

        return null;

    }


    /*
     * No mostrar lapsos que todavía no han finalizado.
     */

    if (
        lapso >
        configuracionBoletin.lapsoActual
    ) {

        return null;

    }


    switch (lapso) {

        case 1:

            return materia.lapso1;

        case 2:

            return materia.lapso2;

        case 3:

            return materia.lapso3;

        default:

            return null;

    }

}


/* 13. CALCULAR DEFINITIVA */

function obtenerNotaDefinitiva(materia) {

    if (promocion.promovido) {

        return materia.lapso1;

    }


    if (configuracionBoletin.lapsoActual < 3) {

        return null;

    }


    /*
     * Las tres notas son necesarias para calcular
     * la definitiva.
     */

    const notas = [

        materia.lapso1,

        materia.lapso2,

        materia.lapso3

    ];


    const notasValidas = notas.filter(

        nota =>
            nota !== null &&
            nota !== undefined &&
            !isNaN(nota)

    );


    if (notasValidas.length !== 3) {

        return null;

    }


    const suma = notasValidas.reduce(

        (total, nota) =>
            total + Number(nota),

        0

    );


    return suma / 3;

}


/* 14. CALCULAR PORCENTAJE DE INASISTENCIAS */

function calcularPorcentajeInasistencias(materia) {

    if (
        !materia.clasesProgramadas ||
        materia.clasesProgramadas <= 0
    ) {

        return 0;

    }


    return (
        materia.inasistencias /
        materia.clasesProgramadas
    ) * 100;

}


/* 15. DETERMINAR INASISTENCIA EXCESIVA */

function superaLimiteInasistencias(materia) {

    const porcentaje =
        calcularPorcentajeInasistencias(materia);


    return (
        porcentaje >=
        configuracionAcademica.porcentajeMaximoInasistencias
    );

}


/* 16. EVALUAR UNA ASIGNATURA */

function evaluarMateria(materia) {

    const lapsoActual =
        configuracionBoletin.lapsoActual;


    const porcentajeInasistencias =
        calcularPorcentajeInasistencias(materia);


    const pierdePorInasistencia =
        superaLimiteInasistencias(materia);


    /* PROMOCIÓN ESPECIAL */

    if (promocion.promovido) {

        return {

            definitiva: materia.lapso1,
            reparacion: null,
            porcentajeInasistencias,
            pierdePorInasistencia: false,
            aprobada: true,
            estado: "APROBADA"

        };

    }


    /* PRIMER LAPSO */

    if (lapsoActual === 1) {

        const nota = materia.lapso1;


        if (pierdePorInasistencia) {

            return {

                definitiva: null,
                reparacion: null,
                porcentajeInasistencias,
                pierdePorInasistencia: true,
                aprobada: false,
                estado: "REPROBADA POR INASISTENCIA"

            };

        }


        if (
            nota !== null &&
            nota !== undefined &&
            !isNaN(nota) &&
            Number(nota) >=
            configuracionAcademica.notaMinimaAprobatoria
        ) {

            return {

                definitiva: null,
                reparacion: null,
                porcentajeInasistencias,
                pierdePorInasistencia: false,
                aprobada: true,
                estado: "APROBADA"

            };

        }


        return {

            definitiva: null,
            reparacion: null,
            porcentajeInasistencias,
            pierdePorInasistencia: false,
            aprobada: false,
            estado: "REPROBADA"

        };

    }


    /* SEGUNDO LAPSO */

    if (lapsoActual === 2) {

        const nota = materia.lapso2;


        if (pierdePorInasistencia) {

            return {

                definitiva: null,
                reparacion: null,
                porcentajeInasistencias,
                pierdePorInasistencia: true,
                aprobada: false,
                estado: "REPROBADA POR INASISTENCIA"

            };

        }


        if (
            nota !== null &&
            nota !== undefined &&
            !isNaN(nota) &&
            Number(nota) >=
            configuracionAcademica.notaMinimaAprobatoria
        ) {

            return {

                definitiva: null,
                reparacion: null,
                porcentajeInasistencias,
                pierdePorInasistencia: false,
                aprobada: true,
                estado: "APROBADA"

            };

        }


        return {

            definitiva: null,
            reparacion: null,
            porcentajeInasistencias,
            pierdePorInasistencia: false,
            aprobada: false,
            estado: "REPROBADA"

        };

    }


    /* TERCER LAPSO / RESULTADO FINAL */

    const definitiva =
        obtenerNotaDefinitiva(materia);


    /* INASISTENCIA */

    if (pierdePorInasistencia) {

        return {

            definitiva,
            reparacion: null,
            porcentajeInasistencias,
            pierdePorInasistencia: true,
            aprobada: false,
            estado: "REPROBADA POR INASISTENCIA"

        };

    }


    /* DEFINITIVA APROBATORIA */

    if (
        definitiva !== null &&
        definitiva !== undefined &&
        !isNaN(definitiva) &&
        Number(definitiva) >=
        configuracionAcademica.notaMinimaAprobatoria
    ) {

        return {

            definitiva,
            reparacion: null,
            porcentajeInasistencias,
            pierdePorInasistencia: false,
            aprobada: true,
            estado: "APROBADA"

        };

    }


    /* DEFINITIVA REPROBATORIA */

    if (
        definitiva !== null &&
        definitiva !== undefined &&
        !isNaN(definitiva) &&
        Number(definitiva) <
        configuracionAcademica.notaMinimaAprobatoria
    ) {

        /*
         * No se ha registrado reparación.
         */

        if (
            materia.reparacion === null ||
            materia.reparacion === undefined ||
            materia.reparacion === ""
        ) {

            return {

                definitiva,
                reparacion: null,
                porcentajeInasistencias,
                pierdePorInasistencia: false,
                aprobada: false,
                estado: "REPROBADA"

            };

        }


        const notaReparacion =
            Number(materia.reparacion);


        /*
         * Reparación >= 10:
         * la asignatura queda aprobada.
         */

        if (
            !isNaN(notaReparacion) &&
            notaReparacion >=
            configuracionAcademica.notaMinimaAprobatoria
        ) {

            return {

                definitiva,
                reparacion: notaReparacion,
                porcentajeInasistencias,
                pierdePorInasistencia: false,
                aprobada: true,
                estado: "APROBADA"

            };

        }


        /*
         * Reparación < 10:
         * asignatura definitivamente reprobada.
         */

        return {

            definitiva,
            reparacion: notaReparacion,
            porcentajeInasistencias,
            pierdePorInasistencia: false,
            aprobada: false,
            estado: "REPROBADA"

        };

    }


    /* SIN DEFINITIVA */

    return {

        definitiva: null,
        reparacion: null,
        porcentajeInasistencias,
        pierdePorInasistencia: false,
        aprobada: null,
        estado: "EN CURSO"

    };

}


/* 17. CALIFICACIONES DE LA TABLA */

function cargarCalificaciones() {

    const cuerpoTabla =
        document.getElementById(
            "cuerpo-calificaciones"
        );


    if (!cuerpoTabla) {

        console.error(
            "No se encontró el elemento #cuerpo-calificaciones."
        );

        return;

    }


    cuerpoTabla.innerHTML = "";


    const lapsoActual =
        configuracionBoletin.lapsoActual;


    const columnas = {

        lapso1:
            document.querySelectorAll(".col-lapso-1"),

        lapso2:
            document.querySelectorAll(".col-lapso-2"),

        lapso3:
            document.querySelectorAll(".col-lapso-3"),

        definitiva:
            document.querySelectorAll(".col-definitiva"),

        reparacion:
            document.querySelectorAll(".col-reparacion"),

        inasistencias:
            document.querySelectorAll(".col-inasistencias"),

        estado:
            document.querySelectorAll(".col-estado")

    };


    function mostrarColumnas(lista, mostrar) {

        lista.forEach(elemento => {

            elemento.hidden = !mostrar;

        });

    }


    /* VISIBILIDAD DE COLUMNAS */

    mostrarColumnas(
        columnas.lapso1,
        true
    );


    mostrarColumnas(
        columnas.lapso2,
        lapsoActual >= 2
    );


    mostrarColumnas(
        columnas.lapso3,
        lapsoActual >= 3
    );


    mostrarColumnas(
        columnas.definitiva,
        lapsoActual >= 3 || promocion.promovido
    );


    mostrarColumnas(
        columnas.reparacion,
        lapsoActual === 3
    );


    mostrarColumnas(
        columnas.inasistencias,
        true
    );


    mostrarColumnas(
        columnas.estado,
        true
    );


    /* GENERACIÓN DE FILAS */

    calificaciones.forEach(materia => {

        const resultado =
            evaluarMateria(materia);


        const fila =
            document.createElement("tr");


        const nota1 =
            obtenerNotaLapso(
                materia,
                1
            );


        const nota2 =
            obtenerNotaLapso(
                materia,
                2
            );


        const nota3 =
            obtenerNotaLapso(
                materia,
                3
            );


        /* REPARACIÓN */

        const reparacion =
            lapsoActual === 3 &&
            resultado.reparacion !== null &&
            resultado.reparacion !== undefined

                ? resultado.reparacion

                : "—";


        const inasistencias =
            `${materia.inasistencias} / ${materia.clasesProgramadas}`;


        /* CLASE DEL ESTADO */

        let claseEstado =
            "estado-materia";


        if (
            resultado.estado === "APROBADA"
        ) {

            claseEstado +=
                " estado-aprobada";

        }


        else if (
            resultado.estado ===
            "REPROBADA POR INASISTENCIA"
        ) {

            claseEstado +=
                " estado-inasistencia";

        }


        else if (
            resultado.estado === "REPROBADA"
        ) {

            claseEstado +=
                " estado-reprobada";

        }


        /* CLASE DE INASISTENCIA */

        const claseInasistencia =
            resultado.pierdePorInasistencia

                ? "inasistencias-excesivas"

                : "inasistencias-normal";


        /* DEFINITIVA */

        const definitiva =
            resultado.definitiva !== null &&
            resultado.definitiva !== undefined

                ? Number(resultado.definitiva)
                    .toFixed(2)

                : "—";


        /* CREAR FILA */

        fila.innerHTML = `

            <td>
                ${materia.asignatura}
            </td>

            <td class="col-lapso-1">
                ${nota1 ?? "—"}
            </td>

            <td class="col-lapso-2">
                ${nota2 ?? "—"}
            </td>

            <td class="col-lapso-3">
                ${nota3 ?? "—"}
            </td>

            <td class="col-definitiva definitiva">
                ${definitiva}
            </td>

            <td class="col-reparacion">
                ${reparacion}
            </td>

            <td class="col-inasistencias ${claseInasistencia}">
                ${inasistencias}
            </td>

            <td class="col-estado ${claseEstado}">
                ${resultado.estado}
            </td>

        `;


        /* VISIBILIDAD DE LAS CELDAS */

        fila.querySelector(
            ".col-lapso-1"
        ).hidden = false;


        fila.querySelector(
            ".col-lapso-2"
        ).hidden =
            lapsoActual < 2;


        fila.querySelector(
            ".col-lapso-3"
        ).hidden =
            lapsoActual < 3;


        fila.querySelector(
            ".col-definitiva"
        ).hidden =
            lapsoActual < 3 &&
            !promocion.promovido;


        fila.querySelector(
            ".col-reparacion"
        ).hidden =
            lapsoActual !== 3;


        cuerpoTabla.appendChild(fila);

    });

}


/* 18. OBTENER NOTAS PARA RESUMEN */

function obtenerNotasParaResumen() {

    const lapsoActual =
        configuracionBoletin.lapsoActual;


    /* PRIMER LAPSO */

    if (lapsoActual === 1) {

        return calificaciones.map(
            materia => materia.lapso1
        );

    }


    /* SEGUNDO LAPSO */

    if (lapsoActual === 2) {

        const notas = [];


        calificaciones.forEach(materia => {

            if (
                materia.lapso1 !== null &&
                materia.lapso1 !== undefined &&
                !isNaN(materia.lapso1)
            ) {

                notas.push(
                    Number(materia.lapso1)
                );

            }


            if (
                materia.lapso2 !== null &&
                materia.lapso2 !== undefined &&
                !isNaN(materia.lapso2)
            ) {

                notas.push(
                    Number(materia.lapso2)
                );

            }

        });


        return notas;

    }


    /* TERCER LAPSO */

    return calificaciones

        .map(
            materia =>
                obtenerNotaDefinitiva(materia)
        )

        .filter(
            nota =>
                nota !== null &&
                nota !== undefined &&
                !isNaN(nota)
        );

}


/* 19. CALCULAR PROMEDIO */

function calcularPromedioFinal() {

    const notas =
        obtenerNotasParaResumen();


    if (
        !notas ||
        notas.length === 0
    ) {

        return null;

    }


    const suma =
        notas.reduce(
            (total, nota) =>
                total + Number(nota),
            0
        );


    return suma / notas.length;

}


/* 20. OBTENER RESUMEN ACADÉMICO */

function obtenerResumenAcademico() {

    const resultados =
        calificaciones.map(
            materia =>
                evaluarMateria(materia)
        );


    const asignaturasCursadas =
        calificaciones.length;


    const asignaturasAprobadas =
        resultados.filter(
            resultado =>
                resultado.aprobada === true
        ).length;


    const asignaturasReprobadas =
        resultados.filter(
            resultado =>
                resultado.aprobada === false
        ).length;


    const promedioFinal =
        calcularPromedioFinal();


    return {

        asignaturasCursadas,

        asignaturasAprobadas,

        asignaturasReprobadas,

        promedioFinal

    };

}


/* 21. MOSTRAR RESUMEN ACADÉMICO */

function cargarResumen() {

    const resumen =
        obtenerResumenAcademico();


    const asignaturasCursadas =
        document.getElementById(
            "asignaturas-cursadas"
        );


    const asignaturasAprobadas =
        document.getElementById(
            "asignaturas-aprobadas"
        );


    const asignaturasReprobadas =
        document.getElementById(
            "asignaturas-reprobadas"
        );


    if (asignaturasCursadas) {

        asignaturasCursadas.textContent =
            resumen.asignaturasCursadas;

    }


    if (asignaturasAprobadas) {

        asignaturasAprobadas.textContent =
            resumen.asignaturasAprobadas;

    }


    if (asignaturasReprobadas) {

        asignaturasReprobadas.textContent =
            resumen.asignaturasReprobadas;

    }


    const promedio =
        document.getElementById(
            "promedio-general"
        );


    const etiquetaPromedio =
        document.getElementById(
            "etiqueta-promedio"
        );


    if (etiquetaPromedio) {

        switch (
            configuracionBoletin.lapsoActual
        ) {

            case 1:

                etiquetaPromedio.textContent =
                    "Promedio del lapso";

                break;


            case 2:

                etiquetaPromedio.textContent =
                    "Promedio acumulado";

                break;


            case 3:

                etiquetaPromedio.textContent =
                    "Promedio final";

                break;

        }

    }


    if (promedio) {

        if (
            resumen.promedioFinal === null
        ) {

            promedio.textContent = "—";

        }

        else {

            promedio.textContent =
                resumen.promedioFinal
                    .toFixed(2)
                    .replace(".", ",");

        }

    }

}


/* 22. RESULTADO ACADÉMICO / PROMOCIÓN */

function cargarResultadoAcademico() {

    const bloque =
        document.getElementById(
            "resultado-academico"
        );


    const estado =
        document.getElementById(
            "estado-promocion"
        );


    const siguienteNivel =
        document.getElementById(
            "siguiente-nivel"
        );


    const textoObservaciones =
        document.getElementById(
            "texto-observaciones"
        );


    /*
     * Verificar que existan los elementos.
     */

    if (!bloque) {

        return;

    }


    /*
     * Ocultar inicialmente.
     */

    bloque.hidden = true;


    /*
     * Limpiar contenido.
     */

    if (estado) {

        estado.textContent = "";

    }


    if (siguienteNivel) {

        siguienteNivel.textContent = "";

    }


    /*
     * RESULTADO ACADÉMICO
     *
     * Solamente aparece cuando promovido = true.
     */

    if (promocion.promovido === true) {

        if (estado) {

            estado.textContent =
                "PROMOVIDO";

        }


        if (siguienteNivel) {

            siguienteNivel.innerHTML =
                `Próximo nivel: <strong>${promocion.siguienteNivel}</strong>`;

        }


        bloque.hidden = false;

    }


    /*
     * OBSERVACIONES
     */

    if (textoObservaciones) {

        textoObservaciones.textContent =
            observaciones;

    }

}