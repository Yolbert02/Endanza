import React, { useState } from 'react'
import {
    CModal,
    CModalBody,
    CButton,
    CSpinner
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilWarning, cilBadge, cilUser, cilArrowRight } from '@coreui/icons'
import { useNavigate } from 'react-router-dom'

/**
 * Modal de aviso obligatorio para representantes sin cédula registrada.
 * Se muestra al primer ingreso al sistema si el campo cédula está vacío.
 */
const CedulaAlertModal = ({ visible, onClose }) => {
    const navigate = useNavigate()
    const [redirecting, setRedirecting] = useState(false)

    const handleGoToProfile = () => {
        setRedirecting(true)
        setTimeout(() => {
            onClose()
            navigate('/perfil')
        }, 300)
    }

    return (
        <CModal
            visible={visible}
            onClose={null} // No se puede cerrar sin acción
            backdrop="static"
            keyboard={false}
            size="md"
            className="cedula-alert-modal animate-fade-in"
            alignment="center"
        >
            <CModalBody className="p-0">
                {/* Header de advertencia */}
                <div className="cedula-alert-header text-center py-5 px-4">
                    <div className="alert-icon-ring mx-auto mb-4">
                        <div className="alert-icon-inner">
                            <CIcon icon={cilWarning} className="text-white" style={{ width: '2rem', height: '2rem' }} />
                        </div>
                    </div>
                    <h4 className="fw-bold text-white mb-2">⚠️ Acción Requerida</h4>
                    <p className="text-white mb-0" style={{ opacity: 0.85, fontSize: '0.95rem' }}>
                        Datos de perfil incompletos
                    </p>
                </div>

                {/* Cuerpo del mensaje */}
                <div className="p-4 pb-2">
                    <div className="alert-message-box p-4 rounded-4 mb-4">
                        <div className="d-flex align-items-start gap-3 mb-3">
                            <div className="alert-badge-icon p-2 rounded-3 flex-shrink-0">
                                <CIcon icon={cilBadge} className="text-warning" style={{ width: '1.25rem', height: '1.25rem' }} />
                            </div>
                            <div>
                                <h6 className="fw-bold mb-1" style={{ color: 'var(--cui-body-color)' }}>
                                    Su cédula de identidad no está registrada
                                </h6>
                                <p className="small mb-0 text-muted">
                                    Este dato es <strong>obligatorio</strong> para identificarlo correctamente como representante y para que el sistema pueda asociar su cuenta con los estudiantes a su cargo.
                                </p>
                            </div>
                        </div>

                        <hr className="my-3 opacity-10" />

                        <div className="d-flex align-items-start gap-3">
                            <div className="alert-badge-icon p-2 rounded-3 flex-shrink-0">
                                <CIcon icon={cilUser} className="text-info" style={{ width: '1.25rem', height: '1.25rem' }} />
                            </div>
                            <div>
                                <h6 className="fw-bold mb-1" style={{ color: 'var(--cui-body-color)' }}>
                                    ¿Qué debe hacer?
                                </h6>
                                <p className="small mb-0 text-muted">
                                    Diríjase a su perfil de usuario, haga clic en <strong>"Editar Información"</strong> y complete el campo de <strong>Cédula de Identidad</strong> junto con cualquier otro dato faltante.
                                </p>
                            </div>
                        </div>
                    </div>

                    {/* Nota urgente */}
                    <div className="urgent-note p-3 rounded-3 mb-4 d-flex align-items-center gap-2">
                        <span style={{ fontSize: '1.1rem' }}>🔴</span>
                        <span className="small fw-bold">
                            Esta acción es <span className="text-danger">obligatoria</span>. Por favor actualice sus datos antes de continuar usando el sistema.
                        </span>
                    </div>
                </div>

                {/* Acciones */}
                <div className="px-4 pb-4 d-flex flex-column gap-2">
                    <CButton
                        className="cedula-alert-primary-btn w-100 d-flex align-items-center justify-content-center gap-2 py-3"
                        onClick={handleGoToProfile}
                        disabled={redirecting}
                    >
                        {redirecting ? (
                            <>
                                <CSpinner size="sm" />
                                Redirigiendo...
                            </>
                        ) : (
                            <>
                                <CIcon icon={cilBadge} />
                                IR A MI PERFIL Y REGISTRAR CÉDULA
                                <CIcon icon={cilArrowRight} />
                            </>
                        )}
                    </CButton>
                    <CButton
                        color="link"
                        className="text-muted small"
                        onClick={onClose}
                    >
                        Recordar más tarde
                    </CButton>
                </div>
            </CModalBody>

            <style>{`
                .cedula-alert-modal .modal-content {
                    border: none;
                    border-radius: 24px;
                    overflow: hidden;
                    box-shadow: 0 25px 60px -12px rgba(0,0,0,0.35);
                }
                .cedula-alert-header {
                    background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
                }
                .alert-icon-ring {
                    width: 80px;
                    height: 80px;
                    background: rgba(255,255,255,0.2);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    animation: pulse-ring 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
                }
                .alert-icon-inner {
                    width: 60px;
                    height: 60px;
                    background: rgba(255,255,255,0.25);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                @keyframes pulse-ring {
                    0%, 100% { box-shadow: 0 0 0 0 rgba(255,255,255,0.4); }
                    50% { box-shadow: 0 0 0 15px rgba(255,255,255,0); }
                }
                .alert-message-box {
                    background: var(--cui-body-bg);
                    border: 1px solid var(--cui-border-color);
                }
                .alert-badge-icon {
                    background: rgba(242, 140, 15, 0.1);
                    min-width: 40px;
                    height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .urgent-note {
                    background: rgba(220, 53, 69, 0.08);
                    border: 1px solid rgba(220, 53, 69, 0.2);
                }
                .cedula-alert-primary-btn {
                    background: linear-gradient(135deg, #F28C0F 0%, #F8A13E 100%);
                    color: white;
                    border: none;
                    border-radius: 14px;
                    font-weight: 700;
                    font-size: 0.85rem;
                    letter-spacing: 0.5px;
                    box-shadow: 0 4px 15px rgba(242, 140, 15, 0.35);
                    transition: all 0.3s ease;
                }
                .cedula-alert-primary-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 25px rgba(242, 140, 15, 0.45);
                    filter: brightness(1.05);
                    color: white;
                }
                .cedula-alert-primary-btn:disabled {
                    opacity: 0.75;
                    transform: none;
                }
                [data-coreui-theme="dark"] .alert-message-box {
                    background: rgba(255,255,255,0.04);
                    border-color: rgba(255,255,255,0.08);
                }
                [data-coreui-theme="dark"] .urgent-note {
                    background: rgba(220, 53, 69, 0.12);
                    border-color: rgba(220, 53, 69, 0.25);
                }
            `}</style>
        </CModal>
    )
}

export default CedulaAlertModal
