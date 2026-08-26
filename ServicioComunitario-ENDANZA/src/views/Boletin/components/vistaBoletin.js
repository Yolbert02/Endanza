import React, { useState } from 'react';
import {
  CButton,
  CNav,
  CNavItem,
  CNavLink
} from "@coreui/react";
import CIcon from "@coreui/icons-react";
import { cilPrint, cilArrowLeft, cilDescription, cilViewModule } from "@coreui/icons";
import { BoletinOficialEndanza } from '../../../components/BoletinOficialEndanza';

export const VistaBoletin = ({ boletinData, calculos, dispatch, academicYear }) => {
  const [selectedLapso, setSelectedLapso] = useState(3);

  if (!boletinData) return null;

  // Adaptar materias al formato de BoletinOficialEndanza
  const calificacionesAdaptadas = (boletinData.materias || []).map((m) => ({
    asignatura: m.nombre || m.asignatura || 'Materia',
    lapso1: m.notas?.t1 !== undefined && m.notas?.t1 !== '' ? parseFloat(m.notas.t1) : null,
    lapso2: m.notas?.t2 !== undefined && m.notas?.t2 !== '' ? parseFloat(m.notas.t2) : null,
    lapso3: m.notas?.t3 !== undefined && m.notas?.t3 !== '' ? parseFloat(m.notas.t3) : null,
    definitiva: m.notas?.final !== undefined && m.notas?.final !== '' ? parseFloat(m.notas.final) : null,
    reparacion: m.reparacion ?? m.revision?.nota_revision ?? null,
    inasistencias: m.inasistencias || 0,
    clasesProgramadas: m.clasesProgramadas || 40,
    tipo: m.tipo || m.subject_type || 'practica'
  }));

  const promocionData = boletinData.promocionInfo || (
    typeof boletinData.promocion === 'object' && boletinData.promocion?.promovido
      ? boletinData.promocion
      : null
  );

  return (
    <div className="animate__animated animate__fadeIn">
      {/* Barra superior de acciones */}
      <div className="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4 no-print">
        <CButton
          className="btn-back-premium px-3 py-2 shadow-sm"
          onClick={() => dispatch({ type: 'OCULTAR_BOLETIN' })}
        >
          <CIcon icon={cilArrowLeft} className="me-2" />
          Volver al listado
        </CButton>

        <div className="d-flex align-items-center gap-2">
          {/* Selector de Lapso para visualización */}
          {!promocionData?.promovido && (
            <div className="d-flex align-items-center bg-white p-1 rounded-pill shadow-sm border">
              {[1, 2, 3].map((num) => (
                <button
                  key={num}
                  type="button"
                  className={`btn btn-sm rounded-pill px-3 fw-bold ${
                    selectedLapso === num ? 'btn-warning text-white' : 'btn-light text-dark'
                  }`}
                  onClick={() => setSelectedLapso(num)}
                >
                  {num === 1 ? '1er Lapso' : num === 2 ? '2do Lapso' : '3er Lapso (Final)'}
                </button>
              ))}
            </div>
          )}

          <CButton
            className="btn-premium d-flex align-items-center shadow-sm px-4 py-2"
            onClick={() => window.print()}
          >
            <CIcon icon={cilPrint} className="me-2 text-white" />
            Imprimir Boletín Oficial A4
          </CButton>
        </div>
      </div>

      {/* Componente Oficial ENDANZA */}
      <div className="shadow-lg rounded-3 overflow-hidden">
        <BoletinOficialEndanza
          estudiante={{
            nombre: boletinData.estudiante?.nombre,
            nombres: boletinData.estudiante?.nombre,
            cedula: boletinData.estudiante?.codigo || boletinData.estudiante?.cedula,
            grado: boletinData.grado,
            seccion: boletinData.seccion || 'A',
            anioEscolar: academicYear || '2024 - 2025',
            fechaEmision: boletinData.fecha
          }}
          calificaciones={calificacionesAdaptadas}
          promocion={promocionData}
          lapsoActual={selectedLapso}
          observaciones={boletinData.observaciones}
        />
      </div>
    </div>
  );
};

export default VistaBoletin;