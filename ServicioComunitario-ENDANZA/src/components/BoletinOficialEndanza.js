// Archivo: src/components/BoletinOficialEndanza.js
import React, { useMemo } from 'react';
import '../styles/boletinOficial.css';
import logoMinisterio from '../assets/images/logo-ministerio.png';
import logoEndanza from '../assets/images/logo-endanza.png';

/**
 * Componente oficial de Boletín ENDANZA (Soporta modalidad Normal y Promoción Anticipada)
 */
export const BoletinOficialEndanza = ({
  estudiante = {},
  calificaciones = [],
  promocion = null,
  lapsoActual = 3,
  observaciones = null,
  fechaEmision = null,
  configuracionAcademica = {
    notaMinimaAprobatoria: 10,
    porcentajeMaximoInasistencias: 25,
    lapsoInicial: 1,
    lapsoFinal: 3
  }
}) => {
  const isPromovido = Boolean(promocion && promocion.promovido);

  // Normalizar datos del estudiante
  const datosEstudiante = useMemo(() => {
    const nombreCompleto = estudiante.nombreCompleto || 
      `${estudiante.nombres || estudiante.nombre || ''} ${estudiante.apellidos || estudiante.apellido || ''}`.trim() ||
      'ESTUDIANTE';

    return {
      nombre: nombreCompleto,
      cedula: estudiante.cedula || estudiante.dni || '—',
      grado: estudiante.grado || estudiante.nivel || '—',
      seccion: estudiante.seccion || 'A',
      anioEscolar: estudiante.anioEscolar || estudiante.anoAcademico || '2024 - 2025',
      fechaEmision: fechaEmision || estudiante.fechaEmision || new Date().toLocaleDateString('es-ES', {
        day: '2-digit',
        month: 'long',
        year: 'numeric'
      })
    };
  }, [estudiante, fechaEmision]);

  // Funciones de cálculo exactas de ENDANZA
  const obtenerNotaLapso = (materia, lapso) => {
    if (isPromovido) {
      return lapso === 1 ? (materia.lapso1 ?? materia.t1 ?? null) : null;
    }
    if (lapso > lapsoActual) return null;

    switch (lapso) {
      case 1: return materia.lapso1 ?? materia.t1 ?? null;
      case 2: return materia.lapso2 ?? materia.t2 ?? null;
      case 3: return materia.lapso3 ?? materia.t3 ?? null;
      default: return null;
    }
  };

  const obtenerNotaDefinitiva = (materia) => {
    if (isPromovido) {
      return materia.lapso1 ?? materia.t1 ?? null;
    }
    if (lapsoActual < 3) return null;

    const n1 = materia.lapso1 ?? materia.t1;
    const n2 = materia.lapso2 ?? materia.t2;
    const n3 = materia.lapso3 ?? materia.t3;

    const notas = [n1, n2, n3].filter(n => n !== null && n !== undefined && !isNaN(parseFloat(n)));
    if (notas.length !== 3) return null;

    const suma = notas.reduce((acc, n) => acc + parseFloat(n), 0);
    return suma / 3;
  };

  const calcularPorcentajeInasistencias = (materia) => {
    const clases = materia.clasesProgramadas || 40;
    const inasistencias = materia.inasistencias || 0;
    if (clases <= 0) return 0;
    return (inasistencias / clases) * 100;
  };

  const evaluarMateria = (materia) => {
    const inasistenciasPorc = calcularPorcentajeInasistencias(materia);
    const pierdePorInasistencia = inasistenciasPorc >= configuracionAcademica.porcentajeMaximoInasistencias;

    // Caso: Promoción Anticipada
    if (isPromovido) {
      const nota1 = materia.lapso1 ?? materia.t1;
      return {
        definitiva: nota1 !== null && nota1 !== undefined ? parseFloat(nota1) : null,
        reparacion: null,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: false,
        aprobada: true,
        estado: 'APROBADA'
      };
    }

    // Caso: Lapso 1
    if (lapsoActual === 1) {
      const nota = materia.lapso1 ?? materia.t1;
      if (pierdePorInasistencia) {
        return {
          definitiva: null,
          reparacion: null,
          porcentajeInasistencias: inasistenciasPorc,
          pierdePorInasistencia: true,
          aprobada: false,
          estado: 'REPROBADA POR INASISTENCIA'
        };
      }
      const val = parseFloat(nota);
      const aprobada = !isNaN(val) && val >= configuracionAcademica.notaMinimaAprobatoria;
      return {
        definitiva: null,
        reparacion: null,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: false,
        aprobada,
        estado: aprobada ? 'APROBADA' : 'REPROBADA'
      };
    }

    // Caso: Lapso 2
    if (lapsoActual === 2) {
      const nota = materia.lapso2 ?? materia.t2;
      if (pierdePorInasistencia) {
        return {
          definitiva: null,
          reparacion: null,
          porcentajeInasistencias: inasistenciasPorc,
          pierdePorInasistencia: true,
          aprobada: false,
          estado: 'REPROBADA POR INASISTENCIA'
        };
      }
      const val = parseFloat(nota);
      const aprobada = !isNaN(val) && val >= configuracionAcademica.notaMinimaAprobatoria;
      return {
        definitiva: null,
        reparacion: null,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: false,
        aprobada,
        estado: aprobada ? 'APROBADA' : 'REPROBADA'
      };
    }

    // Caso: Lapso 3 / Final
    const definitiva = obtenerNotaDefinitiva(materia);

    if (pierdePorInasistencia) {
      return {
        definitiva,
        reparacion: null,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: true,
        aprobada: false,
        estado: 'REPROBADA POR INASISTENCIA'
      };
    }

    if (definitiva !== null && !isNaN(definitiva) && definitiva >= configuracionAcademica.notaMinimaAprobatoria) {
      return {
        definitiva,
        reparacion: null,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: false,
        aprobada: true,
        estado: 'APROBADA'
      };
    }

    if (definitiva !== null && !isNaN(definitiva) && definitiva < configuracionAcademica.notaMinimaAprobatoria) {
      // Revisar si tiene nota de revisión/reparación
      const repNota = materia.reparacion ?? materia.revision?.nota_revision ?? null;
      if (repNota === null || repNota === undefined || repNota === '') {
        return {
          definitiva,
          reparacion: null,
          porcentajeInasistencias: inasistenciasPorc,
          pierdePorInasistencia: false,
          aprobada: false,
          estado: materia.revision ? 'EN REVISIÓN' : 'REPROBADA'
        };
      }

      const repVal = parseFloat(repNota);
      if (!isNaN(repVal) && repVal >= configuracionAcademica.notaMinimaAprobatoria) {
        return {
          definitiva,
          reparacion: repVal,
          porcentajeInasistencias: inasistenciasPorc,
          pierdePorInasistencia: false,
          aprobada: true,
          estado: 'APROBADA (REV)'
        };
      }

      return {
        definitiva,
        reparacion: repVal,
        porcentajeInasistencias: inasistenciasPorc,
        pierdePorInasistencia: false,
        aprobada: false,
        estado: 'REPROBADA'
      };
    }

    return {
      definitiva: null,
      reparacion: null,
      porcentajeInasistencias: inasistenciasPorc,
      pierdePorInasistencia: false,
      aprobada: null,
      estado: 'EN CURSO'
    };
  };

  // Cálculo del resumen
  const resumen = useMemo(() => {
    const evaluadas = calificaciones.map(m => evaluarMateria(m));
    const total = calificaciones.length;
    const aprobadas = evaluadas.filter(e => e.aprobada === true).length;
    const reprobadas = evaluadas.filter(e => e.aprobada === false).length;

    let notasPromedio = [];
    if (isPromovido) {
      notasPromedio = calificaciones
        .map(m => m.lapso1 ?? m.t1)
        .filter(n => n !== null && n !== undefined && !isNaN(parseFloat(n)))
        .map(n => parseFloat(n));
    } else if (lapsoActual === 1) {
      notasPromedio = calificaciones
        .map(m => m.lapso1 ?? m.t1)
        .filter(n => n !== null && n !== undefined && !isNaN(parseFloat(n)))
        .map(n => parseFloat(n));
    } else if (lapsoActual === 2) {
      calificaciones.forEach(m => {
        const n1 = m.lapso1 ?? m.t1;
        const n2 = m.lapso2 ?? m.t2;
        if (n1 !== null && !isNaN(parseFloat(n1))) notasPromedio.push(parseFloat(n1));
        if (n2 !== null && !isNaN(parseFloat(n2))) notasPromedio.push(parseFloat(n2));
      });
    } else {
      notasPromedio = calificaciones
        .map(m => obtenerNotaDefinitiva(m))
        .filter(n => n !== null && !isNaN(parseFloat(n)));
    }

    const suma = notasPromedio.reduce((acc, n) => acc + n, 0);
    const promedio = notasPromedio.length > 0 ? suma / notasPromedio.length : null;

    return {
      total,
      aprobadas,
      reprobadas,
      promedio: promedio !== null ? promedio.toFixed(2).replace('.', ',') : '—'
    };
  }, [calificaciones, isPromovido, lapsoActual]);

  const textoObservacionesFinal = useMemo(() => {
    if (observaciones) return observaciones;
    if (isPromovido) {
      return `Estudiante promovido anticipadamente al siguiente grado (${promocion.siguienteNivel || 'Nivel Superior'}) por rendimiento sobresaliente según Resolución y Acta Oficial N° ${promocion.numeroActa || 'S/N'}.`;
    }
    return "El estudiante ha demostrado un desempeño satisfactorio durante el período académico. Se recomienda continuar fortaleciendo sus habilidades técnicas y artísticas.";
  }, [observaciones, isPromovido, promocion]);

  const nombresLapso = { 1: "I LAPSO", 2: "II LAPSO", 3: "III LAPSO" };

  return (
    <div className="boletin-print-wrapper">
      <main className="boletin-container-sheet">
        {/* ENCABEZADO INSTITUCIONAL */}
        <header className="boletin-encabezado">
          <div className="boletin-encabezado-logo">
            <img src={logoMinisterio} alt="Logo del Ministerio del Poder Popular para la Cultura" />
          </div>

          <div className="boletin-encabezado-institucion">
            <p className="boletin-republica">REPÚBLICA BOLIVARIANA DE VENEZUELA</p>
            <p className="boletin-ministerio">MINISTERIO DEL PODER POPULAR PARA LA CULTURA</p>
            <h1>ESCUELA NACIONAL DE DANZA</h1>
            <p className="boletin-ubicacion">ENDANZA TÁCHIRA</p>
          </div>

          <div className="boletin-encabezado-logo">
            <img src={logoEndanza} alt="Logo de la Escuela Nacional de Danza Táchira" />
          </div>
        </header>

        {/* TÍTULO DEL DOCUMENTO */}
        <section className="boletin-titulo-documento">
          <h2>
            {isPromovido 
              ? 'BOLETÍN ACADÉMICO — PROMOCIÓN ANTICIPADA' 
              : `BOLETÍN ACADÉMICO — ${nombresLapso[lapsoActual] || 'OFICIAL'}`}
          </h2>
        </section>

        {/* DATOS DEL ESTUDIANTE */}
        <section className="boletin-seccion">
          <h3>DATOS DEL ESTUDIANTE</h3>
          <div className="boletin-datos-grid">
            <div className="boletin-dato">
              <span className="boletin-etiqueta">Nombres y apellidos</span>
              <span className="boletin-valor">{datosEstudiante.nombre}</span>
            </div>

            <div className="boletin-dato">
              <span className="boletin-etiqueta">Cédula de identidad</span>
              <span className="boletin-valor">{datosEstudiante.cedula}</span>
            </div>

            <div className="boletin-dato">
              <span className="boletin-etiqueta">Año / Grado</span>
              <span className="boletin-valor">{datosEstudiante.grado}</span>
            </div>

            <div className="boletin-dato">
              <span className="boletin-etiqueta">Sección</span>
              <span className="boletin-valor">{datosEstudiante.seccion}</span>
            </div>

            <div className="boletin-dato">
              <span className="boletin-etiqueta">Año escolar</span>
              <span className="boletin-valor">{datosEstudiante.anioEscolar}</span>
            </div>

            <div className="boletin-dato">
              <span className="boletin-etiqueta">Fecha de emisión</span>
              <span className="boletin-valor">{datosEstudiante.fechaEmision}</span>
            </div>
          </div>
        </section>

        {/* CALIFICACIONES */}
        <section className="boletin-seccion">
          <h3>CALIFICACIONES</h3>
          <div className="boletin-tabla-contenedor">
            <table className="boletin-tabla-calificaciones">
              <thead>
                <tr>
                  <th style={{ width: '28%' }}>ASIGNATURA</th>
                  <th style={{ width: '8%' }}>1.er<br />LAPSO</th>
                  {(lapsoActual >= 2 && !isPromovido) && (
                    <th style={{ width: '8%' }}>2.º<br />LAPSO</th>
                  )}
                  {(lapsoActual >= 3 && !isPromovido) && (
                    <th style={{ width: '8%' }}>3.er<br />LAPSO</th>
                  )}
                  {(lapsoActual >= 3 || isPromovido) && (
                    <th style={{ width: '10%' }}>DEFINITIVA</th>
                  )}
                  {(lapsoActual === 3 && !isPromovido) && (
                    <th style={{ width: '11%' }}>REPARACIÓN</th>
                  )}
                  <th style={{ width: '13%' }}>INASISTENCIAS</th>
                  <th style={{ width: '14%' }}>ESTADO</th>
                </tr>
              </thead>
              <tbody>
                {calificaciones.length === 0 ? (
                  <tr>
                    <td colSpan="8" style={{ textAlign: 'center', padding: '15px' }}>
                      No hay calificaciones registradas para este período.
                    </td>
                  </tr>
                ) : (
                  calificaciones.map((materia, idx) => {
                    const evalResult = evaluarMateria(materia);
                    const n1 = obtenerNotaLapso(materia, 1);
                    const n2 = obtenerNotaLapso(materia, 2);
                    const n3 = obtenerNotaLapso(materia, 3);
                    const def = isPromovido 
                      ? (n1 !== null ? parseFloat(n1).toFixed(0) : '—') 
                      : (evalResult.definitiva !== null ? (evalResult.definitiva < 10 ? `0${evalResult.definitiva.toFixed(0)}` : evalResult.definitiva.toFixed(0)) : '—');
                    
                    const rep = (lapsoActual === 3 && !isPromovido && evalResult.reparacion !== null)
                      ? evalResult.reparacion
                      : '—';
                    
                    const inasistText = `${materia.inasistencias || 0} / ${materia.clasesProgramadas || 40}`;

                    let estadoClass = 'boletin-estado-materia';
                    if (evalResult.estado?.includes('APROBADA')) estadoClass += ' boletin-estado-aprobada';
                    else if (evalResult.estado?.includes('INASISTENCIA')) estadoClass += ' boletin-estado-inasistencia';
                    else if (evalResult.estado?.includes('REPROBADA')) estadoClass += ' boletin-estado-reprobada';
                    else if (evalResult.estado?.includes('REVISIÓN')) estadoClass += ' boletin-estado-revision';

                    return (
                      <tr key={idx}>
                        <td>{materia.asignatura || materia.nombre || materia.nombre_materia}</td>
                        <td>{n1 !== null && n1 !== undefined ? (Number(n1) < 10 ? `0${Number(n1)}` : n1) : '—'}</td>
                        {(lapsoActual >= 2 && !isPromovido) && (
                          <td>{n2 !== null && n2 !== undefined ? (Number(n2) < 10 ? `0${Number(n2)}` : n2) : '—'}</td>
                        )}
                        {(lapsoActual >= 3 && !isPromovido) && (
                          <td>{n3 !== null && n3 !== undefined ? (Number(n3) < 10 ? `0${Number(n3)}` : n3) : '—'}</td>
                        )}
                        {(lapsoActual >= 3 || isPromovido) && (
                          <td className="definitiva">{def}</td>
                        )}
                        {(lapsoActual === 3 && !isPromovido) && (
                          <td>{rep}</td>
                        )}
                        <td className={evalResult.pierdePorInasistencia ? 'boletin-inasistencias-excesivas' : 'boletin-inasistencias-normal'}>
                          {inasistText}
                        </td>
                        <td className={estadoClass}>
                          {evalResult.estado}
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* RESUMEN ACADÉMICO */}
        <section className="boletin-seccion boletin-resumen">
          <h3>RESUMEN ACADÉMICO</h3>
          <div className="boletin-resumen-grid">
            <div className="boletin-resumen-dato">
              <span className="boletin-etiqueta">Asignaturas cursadas</span>
              <span className="boletin-valor">{resumen.total}</span>
            </div>

            <div className="boletin-resumen-dato">
              <span className="boletin-etiqueta">Asignaturas aprobadas</span>
              <span className="boletin-valor">{resumen.aprobadas}</span>
            </div>

            <div className="boletin-resumen-dato">
              <span className="boletin-etiqueta">Asignaturas reprobadas</span>
              <span className="boletin-valor">{resumen.reprobadas}</span>
            </div>

            <div className="boletin-resumen-dato">
              <span className="boletin-etiqueta">
                {isPromovido ? 'Promedio 1.er Lapso' : (lapsoActual === 1 ? 'Promedio del lapso' : (lapsoActual === 2 ? 'Promedio acumulado' : 'Promedio final'))}
              </span>
              <span className="boletin-valor">{resumen.promedio}</span>
            </div>
          </div>
        </section>

        {/* RESULTADO ACADÉMICO / PROMOCIÓN (Solo cuando es promovido) */}
        {isPromovido && (
          <section className="boletin-resultado-academico">
            <h3>RESULTADO ACADÉMICO</h3>
            <p className="boletin-estado-promocion">PROMOVIDO</p>
            <p className="boletin-siguiente-nivel">
              Próximo nivel: <strong>{promocion.siguienteNivel || 'Grado Superior'}</strong>
              {promocion.numeroActa && <span className="d-block text-muted small mt-1">Acta Oficial: {promocion.numeroActa}</span>}
            </p>
          </section>
        )}

        {/* OBSERVACIONES */}
        <section className="boletin-seccion boletin-observaciones">
          <h3>OBSERVACIONES</h3>
          <div className="boletin-campo-observaciones">
            <p>{textoObservacionesFinal}</p>
          </div>
        </section>

        {/* PIE Y FIRMA */}
        <footer className="boletin-pie">
          <div className="boletin-firma">
            <div className="boletin-linea-firma"></div>
            <p className="boletin-nombre-firma">Director(a)</p>
            <p>Escuela Nacional de Danza</p>
            <p>Táchira</p>
          </div>
        </footer>
      </main>
    </div>
  );
};

export default BoletinOficialEndanza;
