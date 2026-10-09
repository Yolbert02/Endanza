import React, { useState, useMemo, useRef } from 'react';
import {
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CButton,
  CNav,
  CNavItem,
  CNavLink,
  CBadge,
  CSpinner
} from '@coreui/react';
import CIcon from '@coreui/icons-react';
import {
  cilPrint,
  cilX,
  cilFile,
  cilDescription,
  cilNotes,
  cilMedicalCross,
  cilCloudDownload
} from '@coreui/icons';
import {
  normalizarDatosPlanillas,
  imprimirPlanillasDirecto,
  descargarPlanillasPDF,
  FichaInscripcionSheet,
  ActaCompromisoRepresentanteSheet,
  ActaCompromisoEstudianteSheet,
  HistoriaClinicaNutricionalSheet
} from './PlanillasOficialesEndanza';
import '../../styles/planillasOficiales.css';

export const ModalPlanillasInscripcion = ({
  visible,
  onClose,
  data = {},
  codigoInscripcion = '',
  activeYear = null
}) => {
  const [tabActiva, setTabActiva] = useState('todas');
  const [descargando, setDescargando] = useState(false);
  const [modoDescarga, setModoDescarga] = useState('');

  const offscreenContainerRef = useRef(null);
  const previewContainerRef = useRef(null);

  const infoNormalizada = useMemo(() => {
    return normalizarDatosPlanillas(data, {
      codigoInscripcion,
      activeYear
    });
  }, [data, codigoInscripcion, activeYear]);

  const handleImprimirTodo = () => {
    imprimirPlanillasDirecto(infoNormalizada, 'todas');
  };

  const handleImprimirActual = () => {
    imprimirPlanillasDirecto(infoNormalizada, tabActiva);
  };

  const handleDescargar = async (modo = 'todas') => {
    try {
      setDescargando(true);
      setModoDescarga(modo);

      let sheets = [];
      if (offscreenContainerRef.current) {
        const allSheets = offscreenContainerRef.current.querySelectorAll('.planilla-sheet');
        if (modo === 'todas') {
          sheets = Array.from(allSheets);
        } else if (modo === 'ficha' && allSheets[0]) {
          sheets = [allSheets[0]];
        } else if (modo === 'acta_rep' && allSheets[1]) {
          sheets = [allSheets[1]];
        } else if (modo === 'acta_est' && allSheets[2]) {
          sheets = [allSheets[2]];
        } else if (modo === 'historia' && allSheets[3]) {
          sheets = [allSheets[3]];
        }
      }

      if (sheets.length === 0 && previewContainerRef.current) {
        sheets = Array.from(previewContainerRef.current.querySelectorAll('.planilla-sheet'));
      }

      await descargarPlanillasPDF(sheets, infoNormalizada, modo);
    } catch (err) {
      console.error('Error al descargar PDF:', err);
      alert('Ocurrió un error al generar el PDF. Puedes utilizar la opción "Imprimir" para Guardar como PDF.');
    } finally {
      setDescargando(false);
      setModoDescarga('');
    }
  };

  return (
    <CModal
      visible={visible}
      onClose={onClose}
      size="xl"
      scrollable
      backdrop="static"
      className="modal-planillas"
    >
      <CModalHeader closeButton className="bg-light border-bottom py-3 px-4">
        <div className="d-flex align-items-center gap-2">
          <CIcon icon={cilFile} size="lg" className="text-primary me-2" />
          <div>
            <CModalTitle className="fs-5 fw-bold mb-0">Planillas Oficiales de Inscripción</CModalTitle>
            <small className="text-muted">
              {infoNormalizada.estudiante.nombres} {infoNormalizada.estudiante.apellidos} • Período {infoNormalizada.institucion.periodo}
            </small>
          </div>
        </div>
      </CModalHeader>

      <div className="bg-white border-bottom px-4 pt-3 no-print">
        <CNav variant="tabs" className="border-0">
          <CNavItem>
            <CNavLink
              active={tabActiva === 'todas'}
              onClick={() => setTabActiva('todas')}
              role="button"
              className="fw-bold d-flex align-items-center gap-2 cursor-pointer"
            >
              <CIcon icon={cilFile} size="sm" />
              Todas las 4 Planillas
              <CBadge color="primary" shape="rounded-pill" className="ms-1">4</CBadge>
            </CNavLink>
          </CNavItem>
          <CNavItem>
            <CNavLink
              active={tabActiva === 'ficha'}
              onClick={() => setTabActiva('ficha')}
              role="button"
              className="d-flex align-items-center gap-1 cursor-pointer"
            >
              <CIcon icon={cilDescription} size="sm" />
              1. Ficha de Inscripción
            </CNavLink>
          </CNavItem>
          <CNavItem>
            <CNavLink
              active={tabActiva === 'acta_rep'}
              onClick={() => setTabActiva('acta_rep')}
              role="button"
              className="d-flex align-items-center gap-1 cursor-pointer"
            >
              <CIcon icon={cilNotes} size="sm" />
              2. Acta Representante
            </CNavLink>
          </CNavItem>
          <CNavItem>
            <CNavLink
              active={tabActiva === 'acta_est'}
              onClick={() => setTabActiva('acta_est')}
              role="button"
              className="d-flex align-items-center gap-1 cursor-pointer"
            >
              <CIcon icon={cilNotes} size="sm" />
              3. Acta Estudiante
            </CNavLink>
          </CNavItem>
          <CNavItem>
            <CNavLink
              active={tabActiva === 'historia'}
              onClick={() => setTabActiva('historia')}
              role="button"
              className="d-flex align-items-center gap-1 cursor-pointer"
            >
              <CIcon icon={cilMedicalCross} size="sm" />
              4. Historia Nutricional
            </CNavLink>
          </CNavItem>
        </CNav>
      </div>

      <CModalBody className="p-0 position-relative">
        {/* Contenedor offscreen para garantizar captura perfecta de las 4 hojas en PDF */}
        <div
          ref={offscreenContainerRef}
          style={{
            position: 'fixed',
            left: '-9999px',
            top: 0,
            width: '216mm',
            opacity: 0,
            pointerEvents: 'none',
            zIndex: -9999
          }}
          aria-hidden="true"
        >
          <FichaInscripcionSheet info={infoNormalizada} />
          <ActaCompromisoRepresentanteSheet info={infoNormalizada} />
          <ActaCompromisoEstudianteSheet info={infoNormalizada} />
          <HistoriaClinicaNutricionalSheet info={infoNormalizada} />
        </div>

        {/* Vista previa en pantalla */}
        <div ref={previewContainerRef} className="planillas-preview-container">
          {(tabActiva === 'todas' || tabActiva === 'ficha') && (
            <FichaInscripcionSheet info={infoNormalizada} />
          )}

          {(tabActiva === 'todas' || tabActiva === 'acta_rep') && (
            <ActaCompromisoRepresentanteSheet info={infoNormalizada} />
          )}

          {(tabActiva === 'todas' || tabActiva === 'acta_est') && (
            <ActaCompromisoEstudianteSheet info={infoNormalizada} />
          )}

          {(tabActiva === 'todas' || tabActiva === 'historia') && (
            <HistoriaClinicaNutricionalSheet info={infoNormalizada} />
          )}
        </div>
      </CModalBody>

      <CModalFooter className="bg-light border-top d-flex justify-content-between align-items-center px-4 py-3">
        <CButton color="secondary" variant="ghost" onClick={onClose} disabled={descargando}>
          <CIcon icon={cilX} className="me-1" /> Cerrar
        </CButton>
        <div className="d-flex flex-wrap gap-2 justify-content-end align-items-center">
          {tabActiva !== 'todas' && (
            <>
              <CButton
                color="success"
                variant="outline"
                onClick={() => handleDescargar(tabActiva)}
                disabled={descargando}
                className="fw-bold d-flex align-items-center gap-2"
              >
                {descargando && modoDescarga === tabActiva ? (
                  <>
                    <CSpinner size="sm" />
                    Descargando...
                  </>
                ) : (
                  <>
                    <CIcon icon={cilCloudDownload} />
                    Descargar Esta Hoja (PDF)
                  </>
                )}
              </CButton>
              <CButton
                color="secondary"
                variant="outline"
                onClick={handleImprimirActual}
                disabled={descargando}
                className="fw-bold d-flex align-items-center gap-2"
              >
                <CIcon icon={cilPrint} />
                Imprimir Esta Hoja
              </CButton>
            </>
          )}

          <CButton
            color="success"
            onClick={() => handleDescargar('todas')}
            disabled={descargando}
            className="fw-bold d-flex align-items-center gap-2 text-white shadow-sm"
            style={{ backgroundColor: '#198754', borderColor: '#198754' }}
          >
            {descargando && modoDescarga === 'todas' ? (
              <>
                <CSpinner size="sm" />
                Generando PDF Completo...
              </>
            ) : (
              <>
                <CIcon icon={cilCloudDownload} />
                Descargar Paquete PDF (4 Planillas)
              </>
            )}
          </CButton>

          <CButton
            color="primary"
            onClick={handleImprimirTodo}
            disabled={descargando}
            className="fw-bold d-flex align-items-center gap-2 shadow-sm text-white"
          >
            <CIcon icon={cilPrint} />
            Imprimir Paquete Completo (4 Planillas)
          </CButton>
        </div>
      </CModalFooter>
    </CModal>
  );
};

export default ModalPlanillasInscripcion;
