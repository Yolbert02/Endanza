import React, { useState, useEffect } from 'react';
import {
    CCard,
    CCardBody,
    CForm,
    CFormInput,
    CButton,
    CRow,
    CCol,
    CSpinner,
    CListGroup,
    CListGroupItem,
    CAlert,
    CInputGroup,
    CFormSelect
} from '@coreui/react';
import CIcon from '@coreui/icons-react';
import { cilUser, cilArrowRight, cilWarning, cilLockLocked } from '@coreui/icons';

// Importar servicio
import { searchRepresentantes } from '../../services/representanteService';

const RegistroRepresentante = ({ onNext, initialData = {} }) => {
    const [formData, setFormData] = useState({
        dni: initialData?.dni || 'V-',
        firstName1: '',
        firstName2: '',
        lastName1: '',
        lastName2: '',
        first_name: initialData?.first_name || '',
        last_name: initialData?.last_name || '',
        phonePrefix: '0414',
        phoneNumber: '',
        phone: initialData?.phone || '',
        email: initialData?.email || '',
        password: '1234', // Contraseña por defecto 1234
        parentesco: initialData?.parentesco || 'Madre',
        parentesco_otro: initialData?.parentesco_otro || '',
        id_representante: initialData?.id_representante || null
    });

    const [searchTerm, setSearchTerm] = useState('');
    const [filteredReps, setFilteredReps] = useState([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    const [errors, setErrors] = useState({});
    const [searching, setSearching] = useState(false);
    const [representanteSeleccionado, setRepresentanteSeleccionado] = useState(null);

    // Si hay initialData con id_representante, mostrar alerta
    useEffect(() => {
        if (formData.id_representante) {
            setRepresentanteSeleccionado({
                first_name: formData.first_name,
                last_name: formData.last_name,
                dni: formData.dni
            });
        }
    }, [formData.id_representante]);

    const handleSearch = async (term) => {
        setSearchTerm(term);
        if (term.trim().length > 1) {
            setSearching(true);
            try {
                const results = await searchRepresentantes(term);
                setFilteredReps(results);
                setShowSuggestions(true);
            } catch (error) {
                console.error("Error searching representatives:", error);
                setFilteredReps([]);
            } finally {
                setSearching(false);
            }
        } else {
            setShowSuggestions(false);
        }
    };

    const selectRep = (rep) => {
        const [fName1, ...fNameRest] = (rep.first_name || '').trim().split(' ');
        const [lName1, ...lNameRest] = (rep.last_name || '').trim().split(' ');
        const fName2 = fNameRest.join(' ');
        const lName2 = lNameRest.join(' ');

        let pPrefix = '0414';
        let pNumber = '';
        if (rep.phone && rep.phone.includes('-')) {
            const parts = rep.phone.split('-');
            pPrefix = parts[0];
            pNumber = parts[1];
        } else if (rep.phone) {
            pNumber = rep.phone;
        }

        setFormData({
            dni: rep.dni,
            firstName1: fName1 || '',
            firstName2: fName2 || '',
            lastName1: lName1 || '',
            lastName2: lName2 || '',
            first_name: rep.first_name,
            last_name: rep.last_name,
            phonePrefix: pPrefix,
            phoneNumber: pNumber,
            phone: rep.phone || '',
            email: rep.email,
            password: '', // Limpiar contraseña al seleccionar existente
            parentesco: rep.es_familiar !== false ? 'Madre' : 'Otro',
            parentesco_otro: '',
            id_representante: rep.id_representante
        });

        setRepresentanteSeleccionado({
            first_name: rep.first_name,
            last_name: rep.last_name,
            dni: rep.dni
        });

        setSearchTerm(`${rep.first_name} ${rep.last_name}`);
        setShowSuggestions(false);
    };

    const limpiarSeleccion = () => {
        setFormData({
            dni: 'V-',
            firstName1: '',
            firstName2: '',
            lastName1: '',
            lastName2: '',
            first_name: '',
            last_name: '',
            phonePrefix: '0414',
            phoneNumber: '',
            phone: '',
            email: '',
            password: '1234',
            parentesco: 'Madre',
            parentesco_otro: '',
            id_representante: null
        });
        setRepresentanteSeleccionado(null);
        setSearchTerm('');
    };

    const handleDniChange = (e) => {
        let value = e.target.value.toUpperCase();
        if (!value.startsWith('V-')) {
            value = 'V-' + value.replace(/V-|\s/g, '');
        }
        if (value === 'V') value = 'V-';
        const docValue = value.substring(2);
        const cleanedDocValue = docValue.replace(/[^0-9]/g, '');
        setFormData({ ...formData, dni: 'V-' + cleanedDocValue });
    };

    const validate = () => {
        const newErrors = {};
        if (!formData.first_name.trim()) newErrors.first_name = 'El nombre es obligatorio';
        if (!formData.last_name.trim()) newErrors.last_name = 'El apellido es obligatorio';
        if (!formData.dni.trim() || formData.dni.trim() === 'V-') newErrors.dni = 'La cédula es obligatoria';
        if (!formData.email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) newErrors.email = 'Email inválido';

        // Validar contraseña solo si es nuevo representante
        if (!representanteSeleccionado && !formData.password.trim()) {
            newErrors.password = 'La contraseña es obligatoria para nuevos representantes';
        } else if (!representanteSeleccionado && formData.password.trim().length < 4) {
            newErrors.password = 'La contraseña debe tener al menos 4 caracteres';
        }

        if (formData.parentesco === 'Otro' && !formData.parentesco_otro.trim()) {
            newErrors.parentesco_otro = 'Especifique el parentesco';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleFormChange = (field, value) => {
        const newData = { ...formData, [field]: value };
        
        // Actualizar el nombre completo basado en los campos individuales
        if (['firstName1', 'firstName2'].includes(field)) {
            newData.first_name = `${newData.firstName1 || ''} ${newData.firstName2 || ''}`.trim();
        }
        if (['lastName1', 'lastName2'].includes(field)) {
            newData.last_name = `${newData.lastName1 || ''} ${newData.lastName2 || ''}`.trim();
        }
        if (['phonePrefix', 'phoneNumber'].includes(field)) {
            newData.phone = `${newData.phonePrefix || ''}-${newData.phoneNumber || ''}`;
        }
        
        setFormData(newData);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!validate()) return;

        // Pasar los datos al componente padre
        onNext(formData);
    };

    return (
        <div className="animate-fade-in">
            <h4 className="fw-bold mb-4 text-warning d-flex align-items-center">
                <div className="p-2 bg-warning bg-opacity-10 rounded-circle me-3">
                    <CIcon icon={cilUser} size="lg" />
                </div>
                DATOS DEL REPRESENTANTE
            </h4>

            {/* Buscador de Representantes Existentes */}
            <CCard
                className="premium-card border-0 mb-4 shadow-sm position-relative"
                style={{ backgroundColor: 'rgba(245, 185, 55, 0.03)', zIndex: 100 }}
            >
                <CCardBody className="p-4" style={{ overflow: 'visible' }}>
                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                        🔍 Buscar Representante Existente
                    </label>
                    <div className="position-relative">
                        <CFormInput
                            placeholder="Buscar por nombre, cédula o correo..."
                            value={searchTerm}
                            onChange={(e) => handleSearch(e.target.value)}
                            onFocus={() => searchTerm.length > 1 && setShowSuggestions(true)}
                            className="input-premium py-2"
                        />
                        {searching && (
                            <div className="position-absolute end-0 top-0 mt-2 me-3">
                                <CSpinner size="sm" color="warning" />
                            </div>
                        )}
                        {showSuggestions && (
                            <CListGroup className="position-absolute w-100 shadow-lg mt-1 search-suggestions-list" style={{ maxHeight: '250px', overflowY: 'auto', zIndex: 9999 }}>
                                {filteredReps.length > 0 ? (
                                    filteredReps.map(rep => (
                                        <CListGroupItem
                                            key={rep.id_representante || rep.id_usuario}
                                            component="button"
                                            onClick={() => selectRep(rep)}
                                            className="d-flex justify-content-between align-items-center list-group-item-action border-light-custom bg-body"
                                        >
                                            <div className="text-start">
                                                <div className="fw-bold text-body">{rep.first_name} {rep.last_name}</div>
                                                <small className="text-body opacity-75">{rep.dni} | {rep.email}</small>
                                            </div>
                                            <CIcon icon={cilArrowRight} className="text-warning" />
                                        </CListGroupItem>
                                    ))
                                ) : (
                                    <CListGroupItem className="text-body opacity-75 small py-3 bg-body">
                                        No se encontraron coincidencias. Puede registrarlo como nuevo abajo.
                                    </CListGroupItem>
                                )}
                            </CListGroup>
                        )}
                    </div>

                    {/* Alerta cuando se selecciona un representante existente */}
                    {representanteSeleccionado && (
                        <CAlert color="info" className="mt-3 mb-0 text-dark">
                            <div className="d-flex justify-content-between align-items-center">
                                <div>
                                    <CIcon icon={cilWarning} className="me-2" />
                                    <strong>Representante seleccionado:</strong>{' '}
                                    {representanteSeleccionado.first_name} {representanteSeleccionado.last_name} - {representanteSeleccionado.dni}
                                    <br />
                                    <small className="text-dark opacity-75">
                                        Se agregarán nuevos estudiantes a este representante existente.
                                        La contraseña NO será modificada.
                                    </small>
                                </div>
                                <CButton
                                    color="secondary"
                                    variant="outline"
                                    className="border-dark text-dark hover-light"
                                    size="sm"
                                    onClick={limpiarSeleccion}
                                >
                                    Cambiar
                                </CButton>
                            </div>
                        </CAlert>
                    )}
                </CCardBody>
            </CCard>

            <CCard className="premium-card border-0 mb-4 shadow-sm">
                <CCardBody className="p-4">
                    <div className="mb-4">
                        <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1 d-block mb-3">
                            <CIcon icon={cilWarning} className="me-2 text-warning" />
                            EL REPRESENTANTE ES EL/LA:
                        </label>
                        <div className="d-flex gap-2 flex-wrap flex-sm-nowrap">
                            {['Madre', 'Padre', 'Otro'].map((option) => (
                                <CButton
                                    key={option}
                                    type="button"
                                    className={`flex-fill py-3 fw-bold border-2 parentesco-option transition-all ${formData.parentesco === option
                                        ? 'btn-warning text-white shadow-md border-warning'
                                        : 'btn-outline-light bg-light-custom text-muted-custom border-light-custom'
                                        }`}
                                    onClick={() => handleFormChange('parentesco', option)}
                                    style={{ borderRadius: '16px', fontSize: '0.85rem' }}
                                >
                                    {option.toUpperCase()}
                                </CButton>
                            ))}
                        </div>
                    </div>

                    <div className="mb-4 d-flex align-items-center">
                        <div className="flex-grow-1 border-bottom border-light-custom"></div>
                        <span className="px-3 small fw-bold text-uppercase opacity-50">
                            {representanteSeleccionado
                                ? 'Datos del representante existente (no modificables)'
                                : 'Complete los datos del nuevo representante'}
                        </span>
                        <div className="flex-grow-1 border-bottom border-light-custom"></div>
                    </div>

                    <CForm onSubmit={handleSubmit}>
                        <CRow className="g-4">
                            <CCol md={3}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    1er Nombre <span className="text-danger">*</span>
                                </label>
                                <CFormInput
                                    placeholder="Ej: Carlos"
                                    value={formData.firstName1}
                                    onChange={(e) => handleFormChange('firstName1', e.target.value)}
                                    className="input-premium py-2"
                                    invalid={!!errors.first_name}
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>
                            <CCol md={3}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    2do Nombre
                                </label>
                                <CFormInput
                                    placeholder="Ej: Eduardo"
                                    value={formData.firstName2}
                                    onChange={(e) => handleFormChange('firstName2', e.target.value)}
                                    className="input-premium py-2"
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>
                            <CCol md={3}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    1er Apellido <span className="text-danger">*</span>
                                </label>
                                <CFormInput
                                    placeholder="Ej: Rodríguez"
                                    value={formData.lastName1}
                                    onChange={(e) => handleFormChange('lastName1', e.target.value)}
                                    className="input-premium py-2"
                                    invalid={!!errors.last_name}
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>
                            <CCol md={3}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    2do Apellido
                                </label>
                                <CFormInput
                                    placeholder="Ej: Pérez"
                                    value={formData.lastName2}
                                    onChange={(e) => handleFormChange('lastName2', e.target.value)}
                                    className="input-premium py-2"
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>
                            <CCol md={6}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    Cédula de Identidad <span className="text-danger">*</span>
                                </label>
                                <CFormInput
                                    placeholder="V-12345678"
                                    value={formData.dni}
                                    onChange={handleDniChange}
                                    className="input-premium py-2"
                                    invalid={!!errors.dni}
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>
                            <CCol md={6}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    Teléfono Principal
                                </label>
                                <CInputGroup>
                                    <CFormSelect
                                        value={formData.phonePrefix}
                                        onChange={(e) => handleFormChange('phonePrefix', e.target.value)}
                                        className="input-premium py-2"
                                        style={{ maxWidth: '120px' }}
                                        disabled={!!representanteSeleccionado}
                                    >
                                        <option value="0414">0414</option>
                                        <option value="0424">0424</option>
                                        <option value="0416">0416</option>
                                        <option value="0426">0426</option>
                                        <option value="0412">0412</option>
                                    </CFormSelect>
                                    <CFormInput
                                        placeholder="1234567"
                                        value={formData.phoneNumber}
                                        onChange={(e) => handleFormChange('phoneNumber', e.target.value.replace(/\D/g, ''))}
                                        className="input-premium py-2"
                                        maxLength={7}
                                        readOnly={!!representanteSeleccionado}
                                        disabled={!!representanteSeleccionado}
                                    />
                                </CInputGroup>
                            </CCol>
                            <CCol md={12}>
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    Correo Electrónico <span className="text-danger">*</span>
                                </label>
                                <CFormInput
                                    type="email"
                                    placeholder="ejemplo@correo.com"
                                    value={formData.email}
                                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                    className="input-premium py-2"
                                    invalid={!!errors.email}
                                    readOnly={!!representanteSeleccionado}
                                    disabled={!!representanteSeleccionado}
                                />
                            </CCol>

                            {/* Campo de contraseña - SOLO para nuevos representantes */}
                            {!representanteSeleccionado && (
                                <CCol md={12}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                        Contraseña
                                    </label>
                                    <CFormInput
                                        type="password"
                                        placeholder="Contraseña por defecto: 1234"
                                        value={formData.password}
                                        onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                                        className="input-premium py-2"
                                        invalid={!!errors.password}
                                    />
                                    <div className="form-text mt-2 opacity-50">
                                        <CIcon icon={cilLockLocked} className="me-1" size="sm" />
                                        La contraseña por defecto es <strong>1234</strong>. El representante podrá cambiarla después de iniciar sesión.
                                    </div>
                                    {errors.password && <div className="text-danger small mt-1">{errors.password}</div>}
                                </CCol>
                            )}

                            {representanteSeleccionado && (
                                <CCol md={12}>
                                    <div className="p-3 rounded-4 bg-info bg-opacity-10 border border-info border-opacity-25">
                                        <CIcon icon={cilLockLocked} className="me-2 text-info" />
                                        <span className="text-info">
                                            La contraseña del representante existente NO será modificada.
                                        </span>
                                    </div>
                                </CCol>
                            )}

                            {formData.parentesco === 'Otro' && (
                                <CCol md={12} className="animate-fade-in">
                                    <div className="p-3 rounded-4 bg-warning bg-opacity-10 border border-warning border-opacity-10">
                                        <label className="form-label small fw-bold text-uppercase text-warning ls-1">
                                            Parentesco / Relación con el alumno <span className="text-danger">*</span>
                                        </label>
                                        <CFormInput
                                            placeholder="Ej: Tío, Abuela, Tutor Legal..."
                                            value={formData.parentesco_otro}
                                            onChange={(e) => setFormData({ ...formData, parentesco_otro: e.target.value })}
                                            className="input-premium py-2 border-warning border-opacity-25"
                                            invalid={!!errors.parentesco_otro}
                                        />
                                        {errors.parentesco_otro && <div className="text-danger small mt-1">{errors.parentesco_otro}</div>}
                                    </div>
                                </CCol>
                            )}
                        </CRow>

                        <div className="d-flex justify-content-end mt-5 pt-4 border-top border-light-custom">
                            <CButton
                                type="submit"
                                className="btn-premium px-5 d-flex align-items-center fw-bold"
                            >
                                {representanteSeleccionado ? 'CONTINUAR PARA AGREGAR ESTUDIANTES' : 'CONTINUAR A ESTUDIANTE'}
                                <CIcon icon={cilArrowRight} className="ms-2" />
                            </CButton>
                        </div>
                    </CForm>
                </CCardBody>
            </CCard>

            <style>{`
                .parentesco-option {
                    border: 1px solid rgba(0,0,0,0.08) !important;
                }
                .parentesco-option.btn-warning {
                    background-color: #F28C0F !important;
                    border-color: #C35604 !important;
                }
                .parentesco-option:hover:not(.btn-warning) {
                    background-color: rgba(242, 140, 15, 0.1) !important;
                    border-color: rgba(242, 140, 15, 0.3) !important;
                    color: #C35604 !important;
                }
                [data-coreui-theme="dark"] .parentesco-option:not(.btn-warning) {
                    background-color: rgba(255, 255, 255, 0.05) !important;
                    border-color: rgba(255, 255, 255, 0.1) !important;
                    color: rgba(255, 255, 255, 0.6) !important;
                }
                .text-contrast {
                    color: var(--neutral-900, #161413);
                }
                [data-coreui-theme="dark"] .text-contrast {
                    color: white !important;
                }
                .ls-1 { letter-spacing: 0.5px; }
                .search-suggestions-list { 
                    z-index: 9999 !important; 
                    border: 1px solid rgba(0,0,0,0.1);
                    border-radius: 12px;
                    overflow-x: hidden;
                    background: #fff;
                    margin-top: 5px;
                }
                
                .list-group-item-action:hover {
                    background-color: rgba(242, 140, 15, 0.08) !important;
                    color: #C35604 !important;
                }

                [data-coreui-theme="dark"] .search-suggestions-list {
                    background-color: #1e293b;
                    border-color: rgba(255,255,255,0.1);
                }
                [data-coreui-theme="dark"] .list-group-item-action:hover {
                    background-color: rgba(242, 140, 15, 0.2) !important;
                    color: #f9b115 !important;
                }

                [data-coreui-theme="dark"] .list-group-item {
                    background-color: #1e293b;
                    border-color: rgba(255,255,255,0.05);
                    color: rgba(255,255,255,0.8);
                }

                .border-light-custom {
                    border-color: rgba(0,0,0,0.05) !important;
                }

                [data-coreui-theme="dark"] .border-light-custom {
                    border-color: rgba(255,255,255,0.05) !important;
                }

                .opacity-50 {
                    opacity: 0.6 !important;
                }

                input:read-only, input:disabled {
                    background-color: #f8f9fa !important;
                    opacity: 0.8;
                    cursor: not-allowed;
                }
                
                [data-coreui-theme="dark"] input:read-only,
                [data-coreui-theme="dark"] input:disabled {
                    background-color: #2a2a3a !important;
                }
            `}</style>
        </div>
    );
};

export default RegistroRepresentante;