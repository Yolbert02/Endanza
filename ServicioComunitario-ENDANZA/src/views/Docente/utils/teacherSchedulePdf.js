// src/views/Docente/utils/teacherSchedulePdf.js
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

// Bloques oficiales de ENDANZA
export const SCHEDULE_BLOCKS = [
  { id: 'b1', label: '14:00 - 14:40', start: '14:00', end: '14:40', isBreak: false },
  { id: 'b2', label: '14:40 - 15:20', start: '14:40', end: '15:20', isBreak: false },
  { id: 'b3', label: '15:20 - 15:50', start: '15:20', end: '15:50', isBreak: false },
  { id: 'receso', label: '15:50 - 16:10', start: '15:50', end: '16:10', isBreak: true, text: 'RECESO' },
  { id: 'b4', label: '16:10 - 16:50', start: '16:10', end: '16:50', isBreak: false },
  { id: 'b5', label: '16:50 - 17:20', start: '16:50', end: '17:20', isBreak: false },
  { id: 'b6', label: '17:20 - 18:00', start: '17:20', end: '18:00', isBreak: false },
];

export const DAYS_CONFIG = [
  { key: 'LUNES', name: 'LUNES', aliases: ['lunes', 'lun', '1'] },
  { key: 'MARTES', name: 'MARTES', aliases: ['martes', 'mar', '2'] },
  { key: 'MIÉRCOLES', name: 'MIÉRCOLES', aliases: ['miercoles', 'miércoles', 'mie', '3'] },
  { key: 'JUEVES', name: 'JUEVES', aliases: ['jueves', 'jue', '4'] },
  { key: 'VIERNES', name: 'VIERNES', aliases: ['viernes', 'vie', '5'] },
  { key: 'SÁBADO', name: 'SÁBADO', aliases: ['sabado', 'sábado', 'sab', '6'] },
];

function normalizeDay(dayStr) {
  if (!dayStr) return '';
  const s = String(dayStr).toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();
  for (const d of DAYS_CONFIG) {
    for (const a of d.aliases) {
      if (s === a || s.startsWith(a)) return d.key;
    }
  }
  return '';
}

function findTeacherClassForSlot(classes, dayKey, block) {
  if (block.isBreak) return null;
  return classes.find(c => {
    const cDay = normalizeDay(c.dayName || c.dayOfWeek || c.day_name || c.nombre_dia);
    if (cDay !== dayKey) return false;

    const cStart = String(c.startTime || c.start_time || '').substring(0, 5);
    const cEnd = String(c.endTime || c.end_time || '').substring(0, 5);

    if (cStart === block.start) return true;
    if (cStart && cEnd && cStart <= block.start && cEnd >= block.end) return true;

    return false;
  });
}

/**
 * Genera y descarga el PDF del horario del docente
 * Con el mismo diseño limpio, elegante y por bloques de clases
 */
export const descargarHorarioDocentePDF = ({ teacherName, academicYear, schedules = [] }) => {
  try {
    const doc = new jsPDF({
      orientation: 'landscape',
      unit: 'mm',
      format: 'a4'
    });

    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();

    const displayTeacher = teacherName || 'Docente';
    const displayYear = academicYear || '2026-2027';

    // Línea superior institucional en naranja
    doc.setFillColor(224, 122, 0);
    doc.rect(0, 0, pageWidth, 4, 'F');

    // Título institucional
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(15);
    doc.setTextColor(31, 41, 55);
    doc.text('ESCUELA DE DANZA DEL ESTADO TÁCHIRA "ENDANZA"', pageWidth / 2, 13, { align: 'center' });

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.setTextColor(107, 114, 128);
    doc.text('CALENDARIO SEMANAL DOCENTE', pageWidth / 2, 18, { align: 'center' });

    // =========================================================================
    // ENCABEZADO CON DOCENTE, AÑO LECTIVO Y CARGO
    // (Mismo estilo que el horario de secciones)
    // =========================================================================
    const boxY = 22;
    const boxHeight = 11;
    doc.setFillColor(255, 250, 245); // Crema suave
    doc.setDrawColor(253, 200, 150); // Borde naranja suave
    doc.setLineWidth(0.3);
    doc.roundedRect(14, boxY, pageWidth - 28, boxHeight, 2, 2, 'FD');

    const posY = boxY + 7;
    let currX = 22;

    // 1. DOCENTE
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('DOCENTE:', currX, posY);
    currX += 20;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10.5);
    doc.setTextColor(17, 24, 39);
    doc.text(displayTeacher, currX, posY);
    currX += 70;

    // 2. AÑO LECTIVO
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('AÑO LECTIVO:', currX, posY);
    currX += 27;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.setTextColor(31, 41, 55);
    doc.text(displayYear, currX, posY);
    currX += 45;

    // 3. CARGO ACADÉMICO
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('CARGO:', currX, posY);
    currX += 17;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.setTextColor(31, 41, 55);
    doc.text('Docente de Especialidad', currX, posY);

    // =========================================================================
    // DÍAS DE LA SEMANA: Solo nombres de los días sin abreviaturas
    // =========================================================================
    const hasSaturday = schedules.some(s => normalizeDay(s.dayName || s.dayOfWeek || s.day_name) === 'SÁBADO');
    const activeDays = hasSaturday ? DAYS_CONFIG.slice(0, 6) : DAYS_CONFIG.slice(0, 5);

    const headRow = ['HORA', ...activeDays.map(d => d.name)];

    const tableBody = [];
    const skipCell = {}; // `${dIdx}-${bIdx}`

    SCHEDULE_BLOCKS.forEach((block, bIdx) => {
      if (block.isBreak) {
        tableBody.push([
          {
            content: block.label,
            styles: {
              textColor: [156, 163, 175],
              fontStyle: 'normal',
              fontSize: 7.5,
              halign: 'center',
              fillColor: [249, 250, 251]
            }
          },
          {
            content: '— RECESO ACADÉMICO / DESCANSO (15:50 - 16:10) —',
            colSpan: activeDays.length,
            styles: {
              halign: 'center',
              valign: 'middle',
              fillColor: [249, 250, 251],
              textColor: [156, 163, 175],
              fontStyle: 'normal',
              fontSize: 7.5
            }
          }
        ]);
        return;
      }

      // Columna de hora en naranja negrita
      const row = [
        {
          content: block.label,
          styles: {
            textColor: [224, 122, 0],
            fontStyle: 'bold',
            fontSize: 8.5,
            halign: 'center',
            valign: 'middle',
            fillColor: [255, 255, 255]
          }
        }
      ];

      activeDays.forEach((day, dIdx) => {
        const key = `${dIdx}-${bIdx}`;
        if (skipCell[key]) return;

        const cls = findTeacherClassForSlot(schedules, day.key, block);

        if (!cls) {
          // Celda vacía con punto sutil
          row.push({
            content: '·',
            styles: {
              halign: 'center',
              valign: 'middle',
              textColor: [209, 213, 219],
              fontSize: 14,
              fillColor: [255, 255, 255]
            }
          });
        } else {
          // Detectar bloques consecutivos para la misma clase del docente
          let span = 1;
          for (let nextB = bIdx + 1; nextB < SCHEDULE_BLOCKS.length; nextB++) {
            const nextBlock = SCHEDULE_BLOCKS[nextB];
            if (nextBlock.isBreak) break;

            const nextCls = findTeacherClassForSlot(schedules, day.key, nextBlock);
            if (
              nextCls &&
              (nextCls.subject || nextCls.subjectName) === (cls.subject || cls.subjectName) &&
              (nextCls.sectionName || nextCls.section_name) === (cls.sectionName || cls.section_name) &&
              (nextCls.classroom || nextCls.classroom_name) === (cls.classroom || cls.classroom_name)
            ) {
              span++;
              skipCell[`${dIdx}-${nextB}`] = true;
            } else {
              break;
            }
          }

          const subjectName = cls.subject || cls.subjectName || cls.materia || 'Clase';
          const sectionName = cls.sectionName || cls.section_name || cls.gradeLevel || 'Sección';
          const classroomName = cls.classroom || cls.classroom_name || 'Aula';

          row.push({
            content: '',
            rowSpan: span,
            cardData: {
              subject: subjectName,
              section: sectionName,
              classroom: classroomName,
              isAuxiliary: cls.isAuxiliary,
              titularTeacher: cls.titularTeacherName || '',
              auxiliaryTeacher: cls.auxiliaryTeacherName || ''
            },
            styles: {
              fillColor: [255, 255, 255],
              valign: 'middle',
              halign: 'center'
            }
          });
        }
      });

      tableBody.push(row);
    });

    // Renderizar la tabla principal
    autoTable(doc, {
      startY: boxY + boxHeight + 4,
      head: [headRow],
      body: tableBody,
      theme: 'plain',
      styles: {
        fontSize: 8,
        cellPadding: 1.5,
        lineColor: [243, 244, 246],
        lineWidth: 0.2,
        halign: 'center',
        valign: 'middle',
        minCellHeight: 11
      },
      headStyles: {
        fillColor: [255, 255, 255],
        textColor: [17, 24, 39],
        fontStyle: 'bold',
        fontSize: 9,
        halign: 'center',
        cellPadding: 3,
        lineColor: [229, 231, 235],
        lineWidth: { bottom: 0.5 }
      },
      columnStyles: {
        0: {
          cellWidth: 26,
          fontStyle: 'bold',
          textColor: [224, 122, 0],
          fillColor: [255, 255, 255],
          lineColor: [243, 244, 246]
        }
      },
      margin: { left: 14, right: 14 },

      didDrawCell: (data) => {
        if (data.section === 'body' && data.cell.raw && data.cell.raw.cardData) {
          const { subject, section, classroom, isAuxiliary, titularTeacher, auxiliaryTeacher } = data.cell.raw.cardData;
          const padX = 1.2;
          const padY = 1.2;
          const cardX = data.cell.x + padX;
          const cardY = data.cell.y + padY;
          const cardW = data.cell.width - (padX * 2);
          const cardH = data.cell.height - (padY * 2);

          // Fondo crema suave + borde naranja redondeado
          doc.setFillColor(255, 248, 240);
          doc.setDrawColor(253, 200, 150);
          doc.setLineWidth(0.35);
          doc.roundedRect(cardX, cardY, cardW, cardH, 2.2, 2.2, 'FD');

          const centerX = cardX + (cardW / 2);
          const centerY = cardY + (cardH / 2);

          // 1. TÍTULO DE LA MATERIA: Naranja negrita destacado
          doc.setFont('helvetica', 'bold');
          doc.setFontSize(8);
          doc.setTextColor(224, 122, 0);
          const subLines = doc.splitTextToSize(subject, cardW - 3);

          if (isAuxiliary) {
            doc.text(subLines[0], centerX, centerY - 4.5, { align: 'center' });

            doc.setFont('helvetica', 'bold');
            doc.setFontSize(6.8);
            doc.setTextColor(195, 86, 4);
            doc.text(`${section} (Auxiliar)`, centerX, centerY - 1.5, { align: 'center' });

            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.3);
            doc.setTextColor(75, 85, 99);
            const titText = titularTeacher ? `Titular: ${titularTeacher}` : classroom;
            doc.text(titText, centerX, centerY + 1.6, { align: 'center' });

            doc.setFontSize(6.2);
            doc.setTextColor(120, 113, 108);
            doc.text(classroom, centerX, centerY + 4.6, { align: 'center' });
          } else if (auxiliaryTeacher) {
            doc.text(subLines[0], centerX, centerY - 4.5, { align: 'center' });

            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.8);
            doc.setTextColor(75, 85, 99);
            doc.text(section, centerX, centerY - 1.5, { align: 'center' });

            doc.setFontSize(6.5);
            doc.setTextColor(195, 86, 4);
            doc.text(`Aux: ${auxiliaryTeacher}`, centerX, centerY + 1.6, { align: 'center' });

            doc.setFontSize(6.2);
            doc.setTextColor(120, 113, 108);
            doc.text(classroom, centerX, centerY + 4.6, { align: 'center' });
          } else if (subLines.length === 1) {
            doc.text(subLines[0], centerX, centerY - 3.2, { align: 'center' });

            // 2. SECCIÓN / GRADO
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(7);
            doc.setTextColor(75, 85, 99);
            const secLines = doc.splitTextToSize(section, cardW - 3);
            doc.text(secLines[0], centerX, centerY + 0.8, { align: 'center' });

            // 3. AULA
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.5);
            doc.setTextColor(120, 113, 108);
            const roomLines = doc.splitTextToSize(classroom, cardW - 3);
            doc.text(roomLines[0], centerX, centerY + 4.2, { align: 'center' });
          } else {
            doc.text(subLines[0], centerX, centerY - 4.5, { align: 'center' });
            doc.text(subLines[1], centerX, centerY - 1.5, { align: 'center' });

            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.8);
            doc.setTextColor(75, 85, 99);
            doc.text(section, centerX, centerY + 1.8, { align: 'center' });

            doc.setFontSize(6.3);
            doc.setTextColor(120, 113, 108);
            doc.text(classroom, centerX, centerY + 4.8, { align: 'center' });
          }
        }
      }
    });

    // =========================================================================
    // RESUMEN DE ASIGNATURAS Y SECCIONES DEL DOCENTE
    // =========================================================================
    const finalY = doc.lastAutoTable.finalY + 4;

    const summaryMap = {};
    schedules.forEach(s => {
      const sub = s.subject || s.subjectName || s.materia || 'General';
      const sec = s.sectionName || s.section_name || s.gradeLevel || 'General';
      const rol = s.isAuxiliary ? 'Auxiliar' : 'Titular';
      const key = `${sub}-${sec}-${rol}-${s.classroom || s.classroom_name}`;
      if (!summaryMap[key]) {
        summaryMap[key] = {
          materia: sub,
          seccion: sec,
          rol: rol,
          aula: s.classroom || s.classroom_name || 'Por asignar',
          dias: new Set(),
          bloques: 0
        };
      }
      const dayNorm = normalizeDay(s.dayName || s.dayOfWeek || s.day_name);
      if (dayNorm) summaryMap[key].dias.add(dayNorm);
      summaryMap[key].bloques++;
    });

    const summaryRows = Object.values(summaryMap).map((item, idx) => [
      idx + 1,
      item.materia,
      item.seccion,
      item.rol,
      item.aula,
      [...item.dias].join(', ') || 'Semanal',
      `${item.bloques} bloques (${Math.round((item.bloques * 40) / 60)}h)`
    ]);

    if (summaryRows.length > 0 && finalY < pageHeight - 35) {
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8.5);
      doc.setTextColor(195, 86, 4);
      doc.text('RESUMEN DE ASIGNATURAS, SECCIONES Y ESPACIOS ASIGNADOS', 14, finalY);

      autoTable(doc, {
        startY: finalY + 2,
        head: [['#', 'Materia', 'Grado / Sección', 'Rol', 'Aula Asignada', 'Días', 'Carga Horaria']],
        body: summaryRows,
        theme: 'striped',
        styles: {
          fontSize: 7.2,
          cellPadding: 1.4,
          textColor: [55, 65, 81]
        },
        headStyles: {
          fillColor: [255, 248, 240],
          textColor: [195, 86, 4],
          fontStyle: 'bold',
          fontSize: 7.5,
          lineColor: [253, 200, 150],
          lineWidth: { bottom: 0.4 }
        },
        columnStyles: {
          0: { cellWidth: 8, halign: 'center' },
          1: { cellWidth: 48, fontStyle: 'bold' },
          2: { cellWidth: 50 },
          3: { cellWidth: 25, halign: 'center', fontStyle: 'bold' },
          4: { cellWidth: 42 },
          5: { cellWidth: 50 },
          6: { cellWidth: 35, halign: 'center' }
        },
        margin: { left: 14, right: 14 }
      });
    }

    const footerY = pageHeight - 6;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(7);
    doc.setTextColor(156, 163, 175);
    doc.text(
      'Documento Oficial de Programación Académica • Escuela de Danza del Estado Táchira (ENDANZA)',
      pageWidth / 2,
      footerY,
      { align: 'center' }
    );

    const fileNameClean = displayTeacher.replace(/[^a-zA-Z0-9_-]/g, '_');
    const fileName = `Horario_Docente_${fileNameClean}_${displayYear.replace(/[^0-9-]/g, '')}.pdf`;
    doc.save(fileName);

    return true;
  } catch (error) {
    console.error('Error generando PDF de horario del docente:', error);
    alert('Error al generar el PDF del horario docente. Por favor revisa la consola.');
    return false;
  }
};
