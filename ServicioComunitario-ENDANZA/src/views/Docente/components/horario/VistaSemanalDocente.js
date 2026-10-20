import React from 'react'
import {
    CCard,
    CCardHeader,
    CCardBody,
} from "@coreui/react"
import CIcon from "@coreui/icons-react"
import { cilCalendar, cilClock, cilPeople, cilLocationPin } from "@coreui/icons"

// Bloques horarios oficiales de ENDANZA
const SCHEDULE_BLOCKS = [
    { id: 'b1', label: '14:00 - 14:40', start: '14:00', end: '14:40', isBreak: false },
    { id: 'b2', label: '14:40 - 15:20', start: '14:40', end: '15:20', isBreak: false },
    { id: 'b3', label: '15:20 - 15:50', start: '15:20', end: '15:50', isBreak: false },
    { id: 'receso', label: '15:50 - 16:10', start: '15:50', end: '16:10', isBreak: true, text: 'RECESO' },
    { id: 'b4', label: '16:10 - 16:50', start: '16:10', end: '16:50', isBreak: false },
    { id: 'b5', label: '16:50 - 17:20', start: '16:50', end: '17:20', isBreak: false },
    { id: 'b6', label: '17:20 - 18:00', start: '17:20', end: '18:00', isBreak: false },
]

const findClassForBlock = (dayClases, block) => {
    if (block.isBreak || !Array.isArray(dayClases)) return null
    return dayClases.find(clase => {
        const start = (clase.startTime || clase.start_time || '').substring(0, 5)
        const end = (clase.endTime || clase.end_time || '').substring(0, 5)

        if (start === block.start) return true
        if (start && end && start <= block.start && end >= block.end) return true
        return false
    })
}

const VistaSemanalDocente = ({ diasSemana = ['LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES'], horario = {} }) => {
    // Pre-calcular absorción de celdas (rowSpan) para clases que abarcan múltiples bloques
    const skipCell = {}
    const cellSpan = {}

    SCHEDULE_BLOCKS.forEach((block, bIdx) => {
        if (block.isBreak) return

        diasSemana.forEach(dia => {
            const key = `${dia}-${bIdx}`
            if (skipCell[key]) return

            const cls = findClassForBlock(horario[dia], block)
            if (cls) {
                let span = 1
                for (let nextB = bIdx + 1; nextB < SCHEDULE_BLOCKS.length; nextB++) {
                    const nextBlock = SCHEDULE_BLOCKS[nextB]
                    if (nextBlock.isBreak) break

                    const nextCls = findClassForBlock(horario[dia], nextBlock)
                    if (
                        nextCls &&
                        (nextCls.subject || nextCls.subjectName) === (cls.subject || cls.subjectName) &&
                        (nextCls.sectionName || nextCls.section_name) === (cls.sectionName || cls.section_name) &&
                        (nextCls.classroom || nextCls.classroom_name) === (cls.classroom || cls.classroom_name)
                    ) {
                        span++
                        skipCell[`${dia}-${nextB}`] = true
                    } else {
                        break
                    }
                }
                cellSpan[key] = span
            }
        })
    })

    return (
        <CCard className="premium-card border-0 overflow-hidden shadow-lg animate__animated animate__fadeIn">
            <CCardHeader className="schedule-header border-0 py-3 px-4 d-flex justify-content-between align-items-center">
                <h5 className="mb-0 fw-bold header-title-custom text-uppercase ls-1">
                    <CIcon icon={cilCalendar} className="me-2 text-primary" />
                    Calendario Semanal Docente
                </h5>
                <div className="badge bg-light-custom text-primary rounded-pill px-3 py-2 border border-primary border-opacity-10 shadow-sm">
                    Planificación de Cátedra
                </div>
            </CCardHeader>
            <CCardBody className="p-0 schedule-body-main">
                <div className="table-responsive schedule-responsive-container">
                    <table className="table table-bordered mb-0 schedule-table-fixed">
                        <thead className="schedule-thead">
                            <tr>
                                <th className="py-3 px-3 text-center border-0 small fw-bold text-muted-custom text-uppercase" style={{ width: '13%' }}>
                                    <CIcon icon={cilClock} className="me-1 text-primary" /> Hora
                                </th>
                                {diasSemana.map(dia => (
                                    <th key={dia} className="py-3 px-3 text-center border-0 small fw-bold text-muted-custom text-uppercase">
                                        {dia}
                                    </th>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {SCHEDULE_BLOCKS.map((block, bIdx) => {
                                if (block.isBreak) {
                                    return (
                                        <tr key={block.id} className="schedule-recess-row" style={{ backgroundColor: '#FFFDF9' }}>
                                            <td className="py-2 text-center text-muted font-monospace small" style={{ fontSize: '0.75rem', borderColor: '#F3F4F6' }}>
                                                {block.label}
                                            </td>
                                            <td
                                                colSpan={diasSemana.length}
                                                className="text-center py-2 small fw-bold"
                                                style={{
                                                    fontSize: '0.75rem',
                                                    color: '#C35604',
                                                    letterSpacing: '0.5px',
                                                    borderColor: '#F3F4F6'
                                                }}
                                            >
                                                ☕ RECESO ACADÉMICO / DESCANSO (15:50 - 16:10)
                                            </td>
                                        </tr>
                                    )
                                }

                                return (
                                    <tr key={block.id} className="schedule-row">
                                        <td
                                            className="py-3 px-2 text-center fw-bold text-primary font-monospace schedule-time-col"
                                            style={{
                                                fontSize: '0.8rem',
                                                verticalAlign: 'middle',
                                                whiteSpace: 'nowrap',
                                                borderColor: '#F3F4F6'
                                            }}
                                        >
                                            {block.label}
                                        </td>

                                        {diasSemana.map(dia => {
                                            const key = `${dia}-${bIdx}`
                                            if (skipCell[key]) {
                                                return null
                                            }

                                            const cls = findClassForBlock(horario[dia], block)
                                            const span = cellSpan[key] || 1

                                            return (
                                                <td
                                                    key={dia}
                                                    rowSpan={span}
                                                    className="p-1 schedule-cell"
                                                    style={{
                                                        verticalAlign: 'middle',
                                                        borderColor: '#F3F4F6',
                                                        height: span > 1 ? `${span * 75}px` : '75px'
                                                    }}
                                                >
                                                    {cls ? (
                                                        <div
                                                            className="p-3 rounded-4 schedule-class-card border h-100 transition-all hover-lift-sm d-flex flex-column justify-content-center"
                                                            style={{
                                                                backgroundColor: '#FFF8F0',
                                                                borderColor: 'rgba(242, 140, 15, 0.35)',
                                                                boxShadow: '0 2px 6px rgba(242, 140, 15, 0.08)'
                                                            }}
                                                        >
                                                            <div className="d-flex justify-content-between align-items-start mb-2">
                                                                <div
                                                                    className="fw-bold header-title-custom lh-sm"
                                                                    style={{ fontSize: '0.9rem', color: '#C35604' }}
                                                                >
                                                                    {cls.subject}
                                                                </div>
                                                                {cls.isAuxiliary && (
                                                                    <span
                                                                        className="badge px-2 py-1 ms-1 text-uppercase"
                                                                        style={{
                                                                            backgroundColor: '#FFE8D6',
                                                                            color: '#C35604',
                                                                            fontSize: '0.65rem',
                                                                            fontWeight: 'bold',
                                                                            border: '1px solid #FDC896'
                                                                        }}
                                                                    >
                                                                        Auxiliar
                                                                    </span>
                                                                )}
                                                            </div>
                                                            <div className="d-flex flex-column gap-1">
                                                                <div className="small text-muted-custom d-flex align-items-center">
                                                                    <CIcon icon={cilPeople} size="sm" className="me-1 text-primary opacity-75" />
                                                                    <span className="fw-medium">{cls.sectionName}</span>
                                                                </div>
                                                                <div className="small text-muted-custom d-flex align-items-center">
                                                                    <CIcon icon={cilLocationPin} size="sm" className="me-1 text-primary opacity-75" />
                                                                    <span>{cls.classroom}</span>
                                                                </div>
                                                                {cls.isAuxiliary && cls.titularTeacherName && (
                                                                    <div className="small text-muted-custom" style={{ fontSize: '0.72rem' }}>
                                                                        <span className="fw-bold">Titular:</span> {cls.titularTeacherName}
                                                                    </div>
                                                                )}
                                                                {!cls.isAuxiliary && cls.auxiliaryTeacherName && (
                                                                    <div className="small text-muted-custom" style={{ fontSize: '0.72rem' }}>
                                                                        <span className="fw-bold">Auxiliar:</span> {cls.auxiliaryTeacherName}
                                                                    </div>
                                                                )}
                                                            </div>
                                                        </div>
                                                    ) : (
                                                        <div className="h-100 d-flex align-items-center justify-content-center py-3">
                                                            <div className="schedule-empty-dot"></div>
                                                        </div>
                                                    )}
                                                </td>
                                            )
                                        })}
                                    </tr>
                                )
                            })}
                        </tbody>
                    </table>
                </div>
            </CCardBody>
        </CCard>
    )
}

export default VistaSemanalDocente
