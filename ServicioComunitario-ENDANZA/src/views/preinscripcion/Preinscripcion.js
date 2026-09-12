import React, { useState } from 'react';
import {
    CContainer,
    CRow,
    CCol,
    CCard,
    CCardBody,
    CSpinner
} from '@coreui/react';
import { cilEducation, cilUser, cilPeople } from '@coreui/icons';
import CIcon from '@coreui/icons-react';
import WelcomeBanner from '../Inicio/components/WelcomeBanner';
import RegistroRepresentante from './RegistroRepresentante';
import RegistroEstudiante from './RegistroEstudiante';

// Importar servicios
import { createRepresentanteConEstudiantes } from '../../services/representanteService';
import { listStudents } from '../../services/studentsService';
import SystemMessageModal from '../../components/SystemMessageModal';
import { capitalizeWords } from '../../utils/formatters';

const DEFAULT_STUDENTS = [
    {
        firstName1: '',
        firstName2: '',
        lastName1: '',
        lastName2: '',
        name: '',
        lastName: '',
        gradeLevel: '',
        section: 'A',
        birthDate: '',
        gender: ''
    }
];

const Preinscripcion = () => {
    const [step, setStep] = useState(1);
    const [loading, setLoading] = useState(false);
    const [representativeData, setRepresentativeData] = useState(null);
    const [studentsData, setStudentsData] = useState(DEFAULT_STUDENTS);
    const [existingStudents, setExistingStudents] = useState([]);
    const [modalVisible, setModalVisible] = useState(false);
    const [modalConfig, setModalConfig] = useState({});

    const handleRepresentativeNext = async (data) => {
        setLoading(true);
        setRepresentativeData(data);
        console.log("📥 Datos recibidos del representante:", data); // Verifica que incluya password
        try {
            // Si el representante ya tiene ID, buscamos sus estudiantes
            if (data.id_representante || data.dni) {
                const allStudents = await listStudents();
                // Adaptar según la estructura de tu API de estudiantes
                const filtered = allStudents.data?.filter(s =>
                    s.representative_id === data.id_representante ||
                    s.representative_dni === data.dni
                ) || [];
                setExistingStudents(filtered);
            } else {
                setExistingStudents([]);
            }
            setStep(2);
            window.scrollTo(0, 0);
        } catch (error) {
            console.error("Error fetching students:", error);
            setExistingStudents([]);
            setStep(2);
        } finally {
            setLoading(false);
        }
    };

    const handleBack = (currentStudents) => {
        if (currentStudents && currentStudents.length > 0) {
            setStudentsData(currentStudents);
        }
        setStep(1);
        window.scrollTo(0, 0);
    };

    const handleFinalSave = async (studentsList) => {
        if (studentsList && studentsList.length > 0) {
            setStudentsData(studentsList);
        }
        setLoading(true);
        try {
            // Preparar payload para el backend
            const payload = {
                dni: representativeData.dni,
                first_name: capitalizeWords(representativeData.first_name),
                last_name: capitalizeWords(representativeData.last_name),
                phone: representativeData.phone || '',
                email: representativeData.email,
                password: representativeData.password || '', // 🔑 CONTRASEÑA INCLUIDA
                parentesco: representativeData.parentesco,
                parentesco_otro: representativeData.parentesco_otro || '',
                direccion: '', // Opcional
                estudiantes: studentsList
                    .filter(s => (s.name && s.name.trim() !== '') || (s.firstName1 && s.firstName1.trim() !== ''))
                    .map(s => ({
                        name: capitalizeWords(s.name || `${s.firstName1 || ''} ${s.firstName2 || ''}`),
                        lastName: capitalizeWords(s.lastName || `${s.lastName1 || ''} ${s.lastName2 || ''}`),
                        gradeLevel: s.gradeLevel,
                        section: s.section || 'A',
                        birthDate: s.birthDate,
                        gender: s.gender
                    }))
            };

            // Si ya tenemos id_representante, incluirlo (para representantes existentes)
            if (representativeData.id_representante) {
                payload.id_representante = representativeData.id_representante;
            }

            // Si es un docente de la institución que se vincula como representante
            if (representativeData.id_usuario_docente) {
                payload.id_usuario_docente = representativeData.id_usuario_docente;
            }

            console.log("📤 Enviando preinscripción:", payload);

            // Llamar al servicio
            const response = await createRepresentanteConEstudiantes(payload);

            if (response?.ok) {
                // Determinar si es nuevo representante (tiene credenciales)
                const esNuevo = response.representante?.credenciales ? true : false;
                const esDocenteVinculado = response.representante?.isExistingDocente || false;

                setModalConfig({
                    type: 'success',
                    title: esDocenteVinculado
                        ? '👨‍🏫 DOCENTE VINCULADO COMO REPRESENTANTE'
                        : (esNuevo ? '✅ NUEVO REPRESENTANTE REGISTRADO' : '✅ ESTUDIANTES AGREGADOS'),
                    message: (
                        <div style={{ textAlign: 'left' }}>
                            <div style={{ marginBottom: '10px' }}>
                                <strong>Representante:</strong> {response.representante.first_name} {response.representante.last_name}
                            </div>
                            <div style={{ marginBottom: '10px' }}>
                                <strong>Email:</strong> {response.representante.email}
                            </div>

                            {esNuevo && (
                                <>
                                    <div style={{ marginBottom: '10px' }}>
                                        <strong>Contraseña:</strong>{' '}
                                        <span style={{ color: '#f9b115', fontWeight: 'bold' }}>
                                            {response.representante.credenciales.password}
                                        </span>
                                    </div>
                                    <div style={{ color: '#dc3545', marginBottom: '10px' }}>
                                        ⚠️ GUARDA ESTA CONTRASEÑA. Solo se muestra una vez.
                                    </div>
                                </>
                            )}

                            {esDocenteVinculado ? (
                                <div style={{ color: '#0d6efd', marginBottom: '10px' }}>
                                    ℹ️ Cuenta de docente vinculada con éxito. Puede alternar entre el rol de Docente y Representante desde el menú de usuario usando sus credenciales habituales.
                                </div>
                            ) : (!esNuevo && (
                                <div style={{ color: '#28a745', marginBottom: '10px' }}>
                                    ℹ️ Las credenciales existentes no han sido modificadas.
                                    El representante puede seguir usando su contraseña actual.
                                </div>
                            ))}

                            <div style={{ margin: '15px 0', borderTop: '1px solid #dee2e6' }} />

                            <div style={{ marginBottom: '10px' }}>
                                <strong>Estudiantes registrados en esta sesión:</strong> {response.estudiantes?.length || 0}
                            </div>

                            {response.estudiantes?.length > 0 ? (
                                <div style={{ marginTop: '8px', paddingLeft: '10px' }}>
                                    {response.estudiantes.map((e, i) => (
                                        <div key={i} style={{ marginBottom: '6px', display: 'flex', alignItems: 'center' }}>
                                            <span style={{ marginRight: '8px', color: '#f9b115', fontWeight: 'bold' }}>•</span>
                                            <span>
                                                {e.first_name} {e.last_name}
                                                {e.gradeLevel && <span className="text-muted"> - {e.gradeLevel}</span>}
                                            </span>
                                        </div>
                                    ))}
                                </div>
                            ) : (
                                <div className="text-muted">No se registraron estudiantes nuevos</div>
                            )}
                        </div>
                    ),
                    confirmText: 'ENTENDIDO',
                    onConfirm: () => {
                        setModalVisible(false);
                        setStep(1);
                        setRepresentativeData(null);
                        setStudentsData(DEFAULT_STUDENTS);
                        setExistingStudents([]);
                    }
                });
                setModalVisible(true);
            }

        } catch (error) {
            console.error("❌ Error en preinscripción:", error);

            // Manejar error específico de representante existente
            let errorMessage = error.message || 'Ocurrió un error al intentar guardar los datos.';

            // Si el error es porque ya existe, mostrar opción de buscar
            if (error.message?.includes('Ya existe un representante')) {
                errorMessage = (
                    <div>
                        <p>⚠️ {error.message}</p>
                        <p className="mt-2">Puedes:</p>
                        <ul>
                            <li>Buscar al representante existente usando el buscador</li>
                            <li>Agregar nuevos estudiantes a su cuenta</li>
                        </ul>
                    </div>
                );
            }

            setModalConfig({
                type: 'error',
                title: 'ERROR EN EL REGISTRO',
                message: errorMessage,
                confirmText: 'CERRAR',
                onConfirm: () => setModalVisible(false)
            });
            setModalVisible(true);
        } finally {
            setLoading(false);
        }
    };

    return (
        <CContainer fluid className="mt-4 pb-5">
            <CRow>
                <CCol>
                    <WelcomeBanner
                        title="Módulo de Preinscripción"
                        subtitle="Central de registro para nuevos representantes y estudiantes (Solo Administrador)."
                        icon={cilPeople}
                        bgIcon={cilEducation}
                        colorClass="warning"
                    />

                    {/* Stepper Indictor */}
                    <div className="d-flex justify-content-center mb-5 mt-2">
                        <div className="d-flex align-items-center position-relative w-100" style={{ maxWidth: '600px' }}>
                            <div className="flex-fill text-center">
                                <div
                                    className={`rounded-circle mx-auto d-flex align-items-center justify-content-center mb-2 transition-all stepper-circle ${step >= 1 ? 'active shadow-glow' : ''}`}
                                    style={{ width: '50px', height: '50px', zIndex: 2 }}
                                >
                                    <CIcon icon={cilUser} className={step >= 1 ? 'stepper-icon-active' : 'stepper-icon-inactive'} />
                                </div>
                                <span className={`small fw-bold text-uppercase ls-1 ${step >= 1 ? 'text-warning text-shadow-sm' : 'text-muted-custom opacity-40'}`}>Representante</span>
                            </div>

                            <div
                                className="position-absolute stepper-line"
                                style={{
                                    left: '25%',
                                    top: '25px',
                                    width: '50%',
                                    height: '2px',
                                    backgroundColor: step >= 2 ? '#F28C0F' : 'rgba(0,0,0,0.05)',
                                    zIndex: 1
                                }}
                            ></div>

                            <div className="flex-fill text-center">
                                <div
                                    className={`rounded-circle mx-auto d-flex align-items-center justify-content-center mb-2 transition-all stepper-circle ${step >= 2 ? 'active shadow-glow' : ''}`}
                                    style={{
                                        width: '50px',
                                        height: '50px',
                                        zIndex: 2
                                    }}
                                >
                                    <CIcon icon={cilEducation} className={step >= 2 ? 'stepper-icon-active' : 'stepper-icon-inactive'} />
                                </div>
                                <span className={`small fw-bold text-uppercase ls-1 ${step >= 2 ? 'text-warning text-shadow-sm' : 'text-muted-custom opacity-40'}`}>Estudiante(s)</span>
                            </div>
                        </div>
                    </div>

                    <div className="preinscripcion-content mx-auto" style={{ maxWidth: '900px' }}>
                        <div style={{ display: step === 1 ? 'block' : 'none' }}>
                            <RegistroRepresentante
                                onNext={handleRepresentativeNext}
                                initialData={representativeData}
                                onChange={setRepresentativeData}
                                loading={loading}
                            />
                        </div>

                        <div style={{ display: step === 2 ? 'block' : 'none' }}>
                            <RegistroEstudiante
                                representative={representativeData}
                                existingStudents={existingStudents}
                                initialStudents={studentsData}
                                onChangeStudents={setStudentsData}
                                onBack={handleBack}
                                onSave={handleFinalSave}
                                loading={loading}
                            />
                        </div>
                    </div>
                </CCol>
            </CRow>

            <SystemMessageModal
                visible={modalVisible}
                onClose={() => setModalVisible(false)}
                {...modalConfig}
            />

            <style>{`
                .ls-1 { letter-spacing: 1px; }
                .transition-all { transition: all 0.3s ease; }
                .stepper-circle {
                    position: relative;
                    background-color: rgba(0, 0, 0, 0.03) !important;
                    border: 2px solid transparent;
                }
                .stepper-circle.active {
                    background-color: white !important;
                    border-color: #F28C0F;
                    box-shadow: 0 0 20px rgba(242, 140, 15, 0.5) !important;
                }
                .stepper-icon-active {
                    color: #F28C0F !important;
                    fill: #F28C0F !important;
                    filter: drop-shadow(0 0 3px rgba(242, 140, 15, 0.5));
                }
                .stepper-icon-inactive {
                    color: rgba(0, 0, 0, 0.3) !important;
                    fill: rgba(0, 0, 0, 0.3) !important;
                }
                [data-coreui-theme="dark"] .stepper-icon-inactive {
                    color: rgba(255, 255, 255, 0.25) !important;
                    fill: rgba(255, 255, 255, 0.25) !important;
                }
                .shadow-glow {
                    box-shadow: 0 0 15px rgba(242, 140, 15, 0.4) !important;
                }
                [data-coreui-theme="dark"] .stepper-circle:not(.active) {
                    background-color: rgba(255, 255, 255, 0.03) !important;
                    border: 1px solid rgba(255,255,255,0.05);
                }
                [data-coreui-theme="dark"] .stepper-circle.active {
                    background-color: rgba(242, 140, 15, 0.1) !important;
                    border: 2px solid #F28C0F !important;
                    box-shadow: 0 0 20px rgba(242, 140, 15, 0.3) !important;
                }
                .stepper-line {
                    pointer-events: none;
                }
                .border-light-custom { border-color: rgba(0, 0, 0, 0.05) !important; }
                [data-coreui-theme="dark"] .border-light-custom { border-color: rgba(255, 255, 255, 0.05) !important; }
            `}</style>
        </CContainer>
    );
};

export default Preinscripcion;