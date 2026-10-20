// src/views/Horario/utils/sectionSchedulePdf.js
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

// Bloques estándar de ENDANZA
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

/**
 * Normaliza el nombre del día para comparar sin tildes ni mayúsculas
 */
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

/**
 * Extrae solo el grado: 1ro, 2do, 3ro, 4to, 5to, etc.
 */
function extractGradeOnly(section) {
  const text = String(
    section.gradeLevel ||
    section.subject_name ||
    section.nivel_academico ||
    section.sectionName ||
    ''
  ).trim();

  const lower = text.toLowerCase();
  if (lower.includes('prep')) return 'Preparatorio';
  if (lower.includes('1') || lower.includes('prim')) return '1ro';
  if (lower.includes('2') || lower.includes('seg')) return '2do';
  if (lower.includes('3') || lower.includes('ter')) return '3ro';
  if (lower.includes('4') || lower.includes('cuar')) return '4to';
  if (lower.includes('5') || lower.includes('quin')) return '5to';
  if (lower.includes('6') || lower.includes('sex')) return '6to';
  if (lower.includes('7') || lower.includes('sep')) return '7mo';
  if (lower.includes('8') || lower.includes('oct')) return '8vo';

  const clean = text.split(' - ')[0].replace(/grado/i, '').trim();
  return clean || '1ro';
}

/**
 * Extrae la letra de la sección: A, B, C o vacío si no tiene
 */
function extractSectionLetterOnly(section) {
  let letter = section.sectionLetter || section.section_letter || section.seccion || section.section || '';
  if (!letter && section.sectionName) {
    if (/^[A-Za-z]$/.test(section.sectionName.trim())) {
      letter = section.sectionName.trim();
    } else {
      const match = section.sectionName.trim().match(/\b([A-Za-z])\b$/);
      if (match) letter = match[1];
    }
  }
  letter = String(letter || '').trim().toUpperCase();
  if (['ÚNICA', 'UNICA', 'N/A', 'SIN NOMBRE', 'SIN NIVEL'].includes(letter)) {
    return '';
  }
  return letter;
}

/**
 * Encuentra la clase de una sección que coincide con un día y bloque
 */
function findClassForSlot(schedules, dayKey, block) {
  if (block.isBreak) return null;
  return schedules.find(s => {
    const sDay = normalizeDay(s.dayName || s.dayOfWeek || s.day_name || s.nombre_dia);
    if (sDay !== dayKey) return false;

    const sStart = String(s.startTime || s.start_time || '').substring(0, 5);
    const sEnd = String(s.endTime || s.end_time || '').substring(0, 5);

    if (sStart === block.start) return true;
    if (sStart && sEnd && sStart <= block.start && sEnd >= block.end) return true;

    return false;
  });
}

/**
 * Genera y descarga el PDF del horario de una sección
 * con la cuadrícula de bloques y días estilo calendario moderno (como imagen 2)
 */
export const descargarHorarioSeccionPDF = (section) => {
  try {
    const doc = new jsPDF({
      orientation: 'landscape',
      unit: 'mm',
      format: 'a4'
    });

    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();

    // 1. Datos formateados según requerimientos exactos
    const gradeVal = extractGradeOnly(section);
    const sectionVal = extractSectionLetterOnly(section);
    const academicYear = section.academicYear || section.academic_year_name || '2026-2027';
    const specialty = section.specialtyName || section.specialty_name || section.especialidad || 'Tronco Común';
    const schedules = Array.isArray(section.schedules) ? section.schedules : [];

    // Título institucional superior con línea de acento
    doc.setFillColor(224, 122, 0); // Naranja primario
    doc.rect(0, 0, pageWidth, 4, 'F');

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(15);
    doc.setTextColor(31, 41, 55); // Slate 800
    doc.text('ESCUELA DE DANZA DEL ESTADO TÁCHIRA "ENDANZA"', pageWidth / 2, 13, { align: 'center' });

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.setTextColor(107, 114, 128); // Gray 500
    doc.text('CALENDARIO SEMANAL DE CLASES', pageWidth / 2, 18, { align: 'center' });

    // =========================================================================
    // ENCABEZADO CON GRADO, SECCIÓN, AÑO Y ESPECIALIDAD
    // (Sin emisión y sin total de clases, como pidió el usuario)
    // =========================================================================
    const boxY = 22;
    const boxHeight = 11;
    doc.setFillColor(255, 250, 245); // Crema muy suave
    doc.setDrawColor(253, 200, 150); // Borde naranja suave
    doc.setLineWidth(0.3);
    doc.roundedRect(14, boxY, pageWidth - 28, boxHeight, 2, 2, 'FD');

    const posY = boxY + 7;
    let currX = 22;

    // 1. GRADO
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('GRADO:', currX, posY);
    currX += 17;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10.5);
    doc.setTextColor(17, 24, 39);
    doc.text(gradeVal, currX, posY);
    currX += 35;

    // 2. SECCIÓN
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('SECCIÓN:', currX, posY);
    currX += 19;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10.5);
    doc.setTextColor(17, 24, 39);
    doc.text(sectionVal ? sectionVal : '—', currX, posY);
    currX += 35;

    // 3. AÑO LECTIVO
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(195, 86, 4);
    doc.text('AÑO LECTIVO:', currX, posY);
    currX += 27;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.setTextColor(31, 41, 55);
    doc.text(academicYear, currX, posY);
    currX += 45;

    // 4. ESPECIALIDAD
    if (specialty) {
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9.5);
      doc.setTextColor(195, 86, 4);
      doc.text('ESPECIALIDAD:', currX, posY);
      currX += 29;
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(10);
      doc.setTextColor(31, 41, 55);
      doc.text(specialty, currX, posY);
    }

    // =========================================================================
    // DÍAS DE LA SEMANA: Solo nombres de los días sin abreviaturas
    // =========================================================================
    // Verificar si hay clases el sábado para esta sección
    const hasSaturday = schedules.some(s => normalizeDay(s.dayName || s.dayOfWeek || s.day_name) === 'SÁBADO');
    const activeDays = hasSaturday ? DAYS_CONFIG.slice(0, 6) : DAYS_CONFIG.slice(0, 5);

    // Cabecera: HORA, LUNES, MARTES, MIÉRCOLES, JUEVES, VIERNES (sin abreviaturas)
    const headRow = ['HORA', ...activeDays.map(d => d.name)];

    // Construcción de la matriz con celdas y rowSpan
    const tableBody = [];
    const skipCell = {}; // `${dIdx}-${bIdx}`

    SCHEDULE_BLOCKS.forEach((block, bIdx) => {
      if (block.isBreak) {
        // Fila de Receso estilo minimalista
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

      // Columna de hora: texto naranja y en negrita (igual que en imagen 2)
      const row = [
        {
          content: block.label,
          styles: {
            textColor: [224, 122, 0], // Naranja como imagen 2
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
        if (skipCell[key]) {
          return;
        }

        const cls = findClassForSlot(schedules, day.key, block);

        if (!cls) {
          // Celda vacía con punto sutil centrado (como en imagen 2)
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
          // Calcular cuántos bloques consecutivos abarca esta clase
          let span = 1;
          for (let nextB = bIdx + 1; nextB < SCHEDULE_BLOCKS.length; nextB++) {
            const nextBlock = SCHEDULE_BLOCKS[nextB];
            if (nextBlock.isBreak) break;

            const nextCls = findClassForSlot(schedules, day.key, nextBlock);
            if (
              nextCls &&
              (nextCls.subject || nextCls.subjectName) === (cls.subject || cls.subjectName) &&
              (nextCls.teacherName || nextCls.teacher_name) === (cls.teacherName || cls.teacher_name) &&
              (nextCls.classroom || nextCls.classroom_name) === (cls.classroom || cls.classroom_name)
            ) {
              span++;
              skipCell[`${dIdx}-${nextB}`] = true;
            } else {
              break;
            }
          }

          const subjectName = cls.subject || cls.subjectName || cls.materia || 'Clase';
          const teacherName = cls.teacherName || cls.teacher_name || 'Docente';
          const classroomName = cls.classroom || cls.classroom_name || 'Aula';
          const auxTeacherName = cls.auxiliaryTeacherName || cls.auxiliary_teacher_name || '';

          // Celda con metadatos para ser dibujada como tarjeta en didDrawCell
          row.push({
            content: '', // El texto se dibuja en didDrawCell con colores y tarjeta personalizada
            rowSpan: span,
            cardData: {
              subject: subjectName,
              teacher: teacherName,
              classroom: classroomName,
              auxiliaryTeacher: auxTeacherName
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

    // Renderizar la tabla principal con diseño idéntico a imagen 2
    autoTable(doc, {
      startY: boxY + boxHeight + 4,
      head: [headRow],
      body: tableBody,
      theme: 'plain',
      styles: {
        fontSize: 8,
        cellPadding: 1.5,
        lineColor: [243, 244, 246], // Gris muy sutil
        lineWidth: 0.2,
        halign: 'center',
        valign: 'middle',
        minCellHeight: 11
      },
      headStyles: {
        fillColor: [255, 255, 255], // Fondo blanco limpio
        textColor: [17, 24, 39], // Negro suave moderno
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

      // DIBUJADO DE LAS TARJETAS (ESTILO IMAGEN 2)
      didDrawCell: (data) => {
        if (data.section === 'body' && data.cell.raw && data.cell.raw.cardData) {
          const { subject, teacher, classroom, auxiliaryTeacher } = data.cell.raw.cardData;
          const padX = 1.2;
          const padY = 1.2;
          const cardX = data.cell.x + padX;
          const cardY = data.cell.y + padY;
          const cardW = data.cell.width - (padX * 2);
          const cardH = data.cell.height - (padY * 2);

          // Fondo crema suave + borde naranja redondeado (como en imagen 2)
          doc.setFillColor(255, 248, 240); // #FFF8F0
          doc.setDrawColor(253, 200, 150); // #FDC896
          doc.setLineWidth(0.35);
          doc.roundedRect(cardX, cardY, cardW, cardH, 2.2, 2.2, 'FD');

          const centerX = cardX + (cardW / 2);
          const centerY = cardY + (cardH / 2);

          // 1. TÍTULO DE LA MATERIA: Naranja negrita destacado
          doc.setFont('helvetica', 'bold');
          doc.setFontSize(8);
          doc.setTextColor(224, 122, 0); // Naranja primario
          const subLines = doc.splitTextToSize(subject, cardW - 3);

          if (auxiliaryTeacher) {
            // Materia + Titular + Auxiliar + Aula
            doc.text(subLines[0], centerX, centerY - 4.5, { align: 'center' });

            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.8);
            doc.setTextColor(55, 65, 81);
            doc.text(`Prof: ${teacher}`, centerX, centerY - 1.5, { align: 'center' });

            doc.setFontSize(6.5);
            doc.setTextColor(195, 86, 4); // Naranja suave para auxiliar
            doc.text(`Aux: ${auxiliaryTeacher}`, centerX, centerY + 1.6, { align: 'center' });

            doc.setFontSize(6.2);
            doc.setTextColor(120, 113, 108);
            doc.text(classroom, centerX, centerY + 4.6, { align: 'center' });
          } else if (subLines.length === 1) {
            doc.text(subLines[0], centerX, centerY - 3.2, { align: 'center' });

            // 2. PROFESOR
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(7);
            doc.setTextColor(75, 85, 99); // Slate 600
            const teacherTxt = `Prof: ${teacher}`;
            const teacherLines = doc.splitTextToSize(teacherTxt, cardW - 3);
            doc.text(teacherLines[0], centerX, centerY + 0.8, { align: 'center' });

            // 3. AULA
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.5);
            doc.setTextColor(120, 113, 108); // Stone 500
            const roomLines = doc.splitTextToSize(classroom, cardW - 3);
            doc.text(roomLines[0], centerX, centerY + 4.2, { align: 'center' });
          } else {
            // Materia con 2 líneas
            doc.text(subLines[0], centerX, centerY - 4.5, { align: 'center' });
            doc.text(subLines[1], centerX, centerY - 1.5, { align: 'center' });

            // Profesor
            doc.setFont('helvetica', 'normal');
            doc.setFontSize(6.8);
            doc.setTextColor(75, 85, 99);
            doc.text(`Prof: ${teacher}`, centerX, centerY + 1.8, { align: 'center' });

            // Aula
            doc.setFontSize(6.3);
            doc.setTextColor(120, 113, 108);
            doc.text(classroom, centerX, centerY + 4.8, { align: 'center' });
          }
        }
      }
    });

    // =========================================================================
    // RESUMEN DE ASIGNATURAS Y DOCENTES (ESTILO LIMPIO Y MODERNO)
    // =========================================================================
    const finalY = doc.lastAutoTable.finalY + 4;

    const summaryMap = {};
    schedules.forEach(s => {
      const sub = s.subject || s.subjectName || s.materia || 'General';
      const mainProf = s.teacherName || s.teacher_name || 'Por asignar';
      const auxProf = s.auxiliaryTeacherName || s.auxiliary_teacher_name || '';
      const docLabel = auxProf ? `${mainProf} (Aux: ${auxProf})` : mainProf;
      const key = `${sub}-${docLabel}-${s.classroom || s.classroom_name}`;
      if (!summaryMap[key]) {
        summaryMap[key] = {
          materia: sub,
          docente: docLabel,
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
      item.docente,
      item.aula,
      [...item.dias].join(', ') || 'Semanal',
      `${item.bloques} bloques (${Math.round((item.bloques * 40) / 60)}h)`
    ]);

    if (summaryRows.length > 0 && finalY < pageHeight - 35) {
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8.5);
      doc.setTextColor(195, 86, 4);
      doc.text('RESUMEN DE ASIGNATURAS, DOCENTES Y ESPACIOS', 14, finalY);

      autoTable(doc, {
        startY: finalY + 2,
        head: [['#', 'Materia', 'Docente Responsable', 'Aula Asignada', 'Días', 'Carga Horaria']],
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
          1: { cellWidth: 55, fontStyle: 'bold' },
          2: { cellWidth: 65 },
          3: { cellWidth: 42 },
          4: { cellWidth: 55 },
          5: { cellWidth: 40, halign: 'center' }
        },
        margin: { left: 14, right: 14 }
      });
    }

    // Pie de página discreto
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

    // Guardar archivo
    const displaySectionName = `${gradeVal}${sectionVal ? `_${sectionVal}` : ''}`.replace(/[^a-zA-Z0-9_-]/g, '_');
    const fileName = `Horario_${displaySectionName}_${academicYear.replace(/[^0-9-]/g, '')}.pdf`;
    doc.save(fileName);

    return true;
  } catch (error) {
    console.error('Error generando PDF de horario de sección:', error);
    alert('Error al generar el PDF del horario. Por favor revisa la consola.');
    return false;
  }
};
