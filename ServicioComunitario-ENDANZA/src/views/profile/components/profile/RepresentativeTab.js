import React from 'react'
import { CRow, CCol, CCard, CCardHeader, CCardBody, CBadge, CAlert } from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilBadge, cilUser, cilPhone, cilEnvelopeClosed, cilInfo, cilBriefcase, cilAddressBook, cilPeople } from '@coreui/icons'
import PropTypes from 'prop-types'

const RepItem = ({ icon, label, value, isCode }) => (
    <div className="d-flex align-items-center p-3 rounded-4 rep-info-item transition-all mb-1">
        <div className="icon-box-sm bg-orange-soft text-warning me-3 shadow-sm border border-warning border-opacity-10">
            <CIcon icon={icon} />
        </div>
        <div>
            <div className="rep-label text-uppercase ls-1 fw-bold" style={{ fontSize: '0.65rem' }}>{label}</div>
            <div className={`fw-bold rep-value fs-6 mt-1 ${isCode ? 'font-monospace' : ''}`}>{value || 'N/A'}</div>
        </div>
    </div>
)

const FamiliarCard = ({ titulo, nombre, cedula, telefono, email, ocupacion, parentesco, tipo, isEmpty }) => {
    if (isEmpty) {
        return (
            <CCol xs={12} md={6}>
                <CCard className="border-0 shadow-sm rounded-4 h-100 familiar-card-empty">
                    <CCardHeader className="bg-transparent border-0 py-3 px-4">
                        <div className="d-flex align-items-center">
                            <div className="p-2 bg-secondary bg-opacity-10 rounded-circle me-2">
                                <CIcon icon={cilUser} className="text-secondary" />
                            </div>
                            <h6 className="mb-0 fw-bold rep-label text-uppercase" style={{ fontSize: '0.75rem' }}>{titulo}</h6>
                        </div>
                    </CCardHeader>
                    <CCardBody className="text-center py-4">
                        <p className="text-muted mb-0 small">No registrado(a)</p>
                    </CCardBody>
                </CCard>
            </CCol>
        )
    }

    const cedulaFormateada = cedula
        ? (String(cedula).startsWith('V-') ? cedula : `V-${cedula}`)
        : 'N/A';

    return (
        <CCol xs={12} md={6}>
            <CCard className="border-0 shadow-sm rounded-4 h-100 familiar-card">
                <CCardHeader className="bg-transparent border-0 py-3 px-4">
                    <div className="d-flex align-items-center justify-content-between">
                        <div className="d-flex align-items-center">
                            <div className={`p-2 rounded-circle me-2 ${tipo === 'madre' ? 'bg-pink-soft' : 'bg-blue-soft'}`}>
                                <CIcon icon={cilUser} className={tipo === 'madre' ? 'text-danger' : 'text-primary'} />
                            </div>
                            <h6 className="mb-0 fw-bold rep-label text-uppercase" style={{ fontSize: '0.75rem' }}>{titulo}</h6>
                        </div>
                        {parentesco && (
                            <CBadge color={tipo === 'madre' ? 'danger' : 'primary'} className="rounded-pill px-3 py-1" style={{ fontSize: '0.6rem' }}>
                                {parentesco}
                            </CBadge>
                        )}
                    </div>
                </CCardHeader>
                <CCardBody className="px-4 pb-4 pt-2">
                    <h5 className="fw-bold rep-value mb-3">{nombre || 'N/A'}</h5>
                    <div className="d-flex flex-column gap-2">
                        <div className="d-flex align-items-center small">
                            <CIcon icon={cilAddressBook} size="sm" className="me-2 text-warning flex-shrink-0" />
                            <span className="rep-label fw-bold me-1">CÉDULA:</span>
                            <span className="rep-value">{cedulaFormateada}</span>
                        </div>
                        <div className="d-flex align-items-center small">
                            <CIcon icon={cilPhone} size="sm" className="me-2 text-warning flex-shrink-0" />
                            <span className="rep-label fw-bold me-1">TELÉFONO:</span>
                            <span className="rep-value">{telefono || 'N/A'}</span>
                        </div>
                        {email && (
                            <div className="d-flex align-items-center small">
                                <CIcon icon={cilEnvelopeClosed} size="sm" className="me-2 text-warning flex-shrink-0" />
                                <span className="rep-label fw-bold me-1">EMAIL:</span>
                                <span className="rep-value">{email}</span>
                            </div>
                        )}
                        {ocupacion && (
                            <div className="d-flex align-items-center small">
                                <CIcon icon={cilBriefcase} size="sm" className="me-2 text-warning flex-shrink-0" />
                                <span className="rep-label fw-bold me-1">OCUPACIÓN:</span>
                                <span className="rep-value">{ocupacion}</span>
                            </div>
                        )}
                    </div>
                </CCardBody>
            </CCard>
        </CCol>
    )
}

const RepresentativeTab = ({ student }) => {
    // Formatear cédula del representante
    const rawCedula = student.representative_dni || student.RepresentanteCedula || student.PadreCedula || student.MadreCedula;
    const cedulaFormateada = rawCedula
        ? (String(rawCedula).startsWith('V-') ? rawCedula : `V-${rawCedula}`)
        : 'N/A';

    // Datos del representante principal
    const representante = {
        nombre: student.representative || (student.representative_first_name ? `${student.representative_first_name} ${student.representative_last_name || ''}`.trim() : (student.RepresentanteNombre || 'No asignado')),
        cedula: cedulaFormateada,
        telefono: student.representative_phone || student.RepresentanteTelefono || 'N/A',
        email: student.representative_email || student.RepresentanteEmail || 'N/A',
        ocupacion: student.representative_occupation || student.RepresentanteOcupacion || student.profesion || '',
        parentesco: student.representative_relationship || student.RepresentanteParentesco || student.parentesco || 'Representante Legal'
    }

    // Datos de la Madre (desde estudiante_familiar o campos del payload)
    const madreNombre = student.MadreNombre || student.MadrePrimerNombre;
    const madreCedula = student.MadreCedula;
    const madreTelefono = student.MadreTelefono;
    const madreEmail = student.MadreEmail;
    const madreOcupacion = student.MadreOcupacion || (student.representative_relationship === 'Madre' ? representante.ocupacion : '');
    const tieneMadre = !!(madreNombre || madreCedula || madreOcupacion);

    // Datos del Padre (desde estudiante_familiar o campos del payload)
    const padreNombre = student.PadreNombre || student.PadrePrimerNombre;
    const padreCedula = student.PadreCedula;
    const padreTelefono = student.PadreTelefono;
    const padreEmail = student.PadreEmail;
    const padreOcupacion = student.PadreOcupacion || (student.representative_relationship === 'Padre' ? representante.ocupacion : '');
    const tienePadre = !!(padreNombre || padreCedula || padreOcupacion);

    return (
        <div className="mt-4 animate__animated animate__fadeIn">
            <CRow className="g-4">
                {/* REPRESENTANTE PRINCIPAL */}
                <CCol xs={12}>
                    <CAlert className="rep-alert border-0 shadow-sm rounded-4 p-4 border-start border-warning border-5 position-relative overflow-hidden">
                        <CRow className="align-items-center g-4">
                            <CCol md={1} className="d-flex justify-content-center">
                                <div className="p-3 bg-warning bg-opacity-10 rounded-circle text-center">
                                    <CIcon icon={cilBadge} size="xl" className="text-warning" />
                                </div>
                            </CCol>
                            <CCol md={8}>
                                <div className="ms-md-3">
                                    <h6 className="text-warning fw-bold text-uppercase ls-1 small mb-2">Representante Legal</h6>
                                    <h4 className="mb-1 fw-bold rep-value">{representante.nombre}</h4>

                                    <div className="d-flex gap-4 flex-wrap mt-3">
                                        <div className="small rep-label fw-bold ls-1 d-flex align-items-center">
                                            <CIcon icon={cilAddressBook} size="sm" className="me-2 text-warning" />
                                            CÉDULA: <span className="ms-1 rep-value">{representante.cedula}</span>
                                        </div>
                                        <div className="small rep-label fw-bold ls-1 d-flex align-items-center">
                                            <CIcon icon={cilPhone} size="sm" className="me-2 text-warning" />
                                            TELÉFONO: <span className="ms-1 rep-value">{representante.telefono}</span>
                                        </div>
                                        <div className="small rep-label fw-bold ls-1 d-flex align-items-center">
                                            <CIcon icon={cilEnvelopeClosed} size="sm" className="me-2 text-warning" />
                                            EMAIL: <span className="ms-1 rep-value">{representante.email}</span>
                                        </div>
                                        <div className="small rep-label fw-bold ls-1 d-flex align-items-center">
                                            <CIcon icon={cilBriefcase} size="sm" className="me-2 text-warning" />
                                            PARENTESCO: <span className="ms-1 rep-value">{representante.parentesco}</span>
                                        </div>
                                        {representante.ocupacion && (
                                            <div className="small rep-label fw-bold ls-1 d-flex align-items-center">
                                                <CIcon icon={cilBriefcase} size="sm" className="me-2 text-warning" />
                                                OCUPACIÓN: <span className="ms-1 rep-value">{representante.ocupacion}</span>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </CCol>
                            <CCol md={3} className="text-md-end">
                                <div className="p-3 rounded-4 bg-orange-soft border border-warning border-opacity-10 text-center shadow-sm">
                                    <small className="text-warning fw-bold text-uppercase d-block mb-1" style={{ fontSize: '0.6rem' }}>Estado de Contacto</small>
                                    <div className="d-flex align-items-center justify-content-center">
                                        <div className="badge-dot bg-success me-2"></div>
                                        <strong className="rep-value text-warning">PRIMARIO</strong>
                                    </div>
                                </div>
                            </CCol>
                        </CRow>
                    </CAlert>
                </CCol>

                {/* MADRE Y PADRE */}
                <CCol xs={12}>
                    <h6 className="fw-bold rep-label text-uppercase ls-1 mb-3 d-flex align-items-center" style={{ fontSize: '0.75rem' }}>
                        <CIcon icon={cilPeople} className="me-2 text-warning" />
                        DATOS FAMILIARES
                    </h6>
                    <CRow className="g-3">
                        <FamiliarCard
                            titulo="Madre"
                            nombre={madreNombre}
                            cedula={madreCedula}
                            telefono={madreTelefono}
                            email={madreEmail}
                            ocupacion={madreOcupacion}
                            parentesco="Madre"
                            tipo="madre"
                            isEmpty={!tieneMadre}
                        />
                        <FamiliarCard
                            titulo="Padre"
                            nombre={padreNombre}
                            cedula={padreCedula}
                            telefono={padreTelefono}
                            email={padreEmail}
                            ocupacion={padreOcupacion}
                            parentesco="Padre"
                            tipo="padre"
                            isEmpty={!tienePadre}
                        />
                    </CRow>
                </CCol>
            </CRow>
            <style>{`
                .ls-1 { letter-spacing: 1px; }
                .icon-box-sm {
                    width: 40px;
                    height: 40px;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .rep-info-item:hover {
                    background-color: rgba(242, 140, 15, 0.05);
                }
                .rep-label { color: var(--neutral-500); }
                .rep-value { color: var(--neutral-800); }
                .rep-alert { background-color: rgba(0, 0, 0, 0.01); border: 1px solid rgba(0,0,0,0.05) !important; border-left: 5px solid #F28C0F !important; }
                .familiar-card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
                .familiar-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,0,0,0.08) !important; }
                .familiar-card-empty { opacity: 0.7; }
                .bg-pink-soft { background-color: rgba(220, 53, 69, 0.1); }
                .bg-blue-soft { background-color: rgba(13, 110, 253, 0.1); }

                [data-coreui-theme="dark"] .rep-label { color: rgba(255,255,255,0.5); }
                [data-coreui-theme="dark"] .rep-value { color: white; }
                [data-coreui-theme="dark"] .rep-info-item:hover { background-color: rgba(255,255,255,0.05); }
                [data-coreui-theme="dark"] .rep-alert { background-color: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05) !important; }
                [data-coreui-theme="dark"] .familiar-card { background-color: rgba(255,255,255,0.03) !important; }
                [data-coreui-theme="dark"] .familiar-card:hover { box-shadow: 0 8px 25px rgba(0,0,0,0.3) !important; }
            `}</style>
        </div>
    )
}

RepresentativeTab.propTypes = {
    student: PropTypes.object.isRequired,
}

export default RepresentativeTab