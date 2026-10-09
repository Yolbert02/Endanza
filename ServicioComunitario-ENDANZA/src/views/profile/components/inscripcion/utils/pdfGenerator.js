import {
  normalizarDatosPlanillas,
  generarHTMLCompleto,
  imprimirPlanillasDirecto
} from '../../../../../components/planillas/PlanillasOficialesEndanza';

export {
  normalizarDatosPlanillas,
  generarHTMLCompleto,
  imprimirPlanillasDirecto
};

/**
 * Función principal para generar/imprimir la planilla oficial desde el formulario de inscripción
 */
export const generarPlanillaHTML = (formData, codigoInscripcion, activeYear = null) => {
  const info = normalizarDatosPlanillas(formData, { codigoInscripcion, activeYear });
  imprimirPlanillasDirecto(info, 'todas');
  return true;
};

/**
 * Genera el comprobante de pre-inscripción simplificado (reserva temporal)
 */
export const generarComprobantePreInscripcion = (formData, codigoPreInscripcion, fechaExpiracion) => {
  const contenido = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>Comprobante Pre-Inscripción - ${formData.nombres || ''}</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; margin-bottom: 30px; }
        .codigo { text-align: center; font-size: 24px; font-weight: bold; color: #e74c3c; margin: 20px 0; padding: 15px; background: #f8f9fa; border: 2px dashed #ddd; }
        .info-item { margin: 8px 0; }
        .label { font-weight: bold; color: #2c3e50; }
        .footer { text-align: center; margin-top: 40px; font-size: 12px; color: #666; }
      </style>
    </head>
    <body>
      <div class="header">
        <h2>COMPROBANTE DE PRE-INSCRIPCIÓN</h2>
        <p>Escuela Nacional de Danza (ENDANZA)</p>
      </div>
      <div class="codigo">
        ${codigoPreInscripcion}<br>
        <small>Válido hasta: ${fechaExpiracion}</small>
      </div>
      <div>
        <div class="info-item"><span class="label">Estudiante:</span> ${formData.nombres || ''} ${formData.apellidos || ''}</div>
        <div class="info-item"><span class="label">Representante:</span> ${formData.nombres_Representante || formData.nombre_Madre || formData.nombre_Padre || ''}</div>
        <div class="info-item"><span class="label">Grado interés:</span> ${formData.grado || ''}</div>
        <div class="info-item"><span class="label">Fecha registro:</span> ${new Date().toLocaleString('es-ES')}</div>
      </div>
      <div class="footer">
        <p>Este comprobante certifica el proceso de inscripción en la institución.</p>
      </div>
    </body>
    </html>
  `;

  const blob = new Blob([contenido], { type: 'text/html' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `pre-inscripcion-${codigoPreInscripcion}.html`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
};