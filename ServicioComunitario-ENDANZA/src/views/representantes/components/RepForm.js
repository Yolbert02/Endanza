import React, { useState, useEffect } from 'react';
import {
    CModal,
    CModalHeader,
    CModalTitle,
    CModalBody,
    CForm,
    CFormInput,
    CFormSelect,
    CInputGroup,
    CModalFooter,
    CButton,
    CRow,
    CCol,
    CSpinner
} from '@coreui/react';
import CIcon from '@coreui/icons-react';
import { cilSave, cilUser, cilEnvelopeClosed, cilPhone, cilBadge } from '@coreui/icons';
import { capitalizeWords } from '../../../utils/formatters';

const PHONE_PREFIXES = ['0414', '0424', '0416', '0426', '0412', '0422'];

const RepForm = ({ visible, onClose, onSave, initial = null }) => {
    const [dni, setDni] = useState('');
    const [firstName1, setFirstName1] = useState('');
    const [firstName2, setFirstName2] = useState('');
    const [lastName1, setLastName1] = useState('');
    const [lastName2, setLastName2] = useState('');
    const [phonePrefix, setPhonePrefix] = useState('0414');
    const [phoneNumber, setPhoneNumber] = useState('');
    const [email, setEmail] = useState('');
    const [errors, setErrors] = useState({});
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        if (visible) {
            if (initial) {
                setDni(initial.dni || initial.cedula || 'V-');
                
                // Parsear nombres
                const rawFn = initial.first_name || initial.nombre || '';
                const fnParts = String(rawFn).trim().split(/\s+/);
                setFirstName1(fnParts[0] || '');
                setFirstName2(fnParts.slice(1).join(' ') || '');

                const rawLn = initial.last_name || initial.apellido || '';
                const lnParts = String(rawLn).trim().split(/\s+/);
                setLastName1(lnParts[0] || '');
                setLastName2(lnParts.slice(1).join(' ') || '');

                // Parsear teléfono
                const tel = initial.phone || initial.telefono || '';
                const matchedPrefix = PHONE_PREFIXES.find(p => tel.startsWith(p + '-') || tel.startsWith(p));
                if (matchedPrefix) {
                    setPhonePrefix(matchedPrefix);
                    setPhoneNumber(tel.replace(matchedPrefix + '-', '').replace(matchedPrefix, '').slice(0, 7));
                } else if (tel) {
                    setPhonePrefix('0414');
                    setPhoneNumber(tel.replace(/[^0-9]/g, '').slice(0, 7));
                } else {
                    setPhonePrefix('0414');
                    setPhoneNumber('');
                }

                setEmail(initial.email || initial.correo || '');
            } else {
                setDni('V-');
                setFirstName1('');
                setFirstName2('');
                setLastName1('');
                setLastName2('');
                setPhonePrefix('0414');
                setPhoneNumber('');
                setEmail('');
            }
            setErrors({});
        }
    }, [visible, initial]);

    const handleDniChange = (e) => {
        let value = e.target.value.toUpperCase();
        if (!value.startsWith('V-')) {
            value = 'V-' + value.replace(/V-|\s/g, '');
        }
        if (value === 'V') value = 'V-';
        const docValue = value.substring(2);
        const cleanedDocValue = docValue.replace(/[^0-9]/g, '').slice(0, 8);
        setDni('V-' + cleanedDocValue);
        if (errors.dni) setErrors(prev => ({ ...prev, dni: null }));
    };

    const validate = () => {
        const newErrors = {};
        if (!firstName1.trim()) newErrors.firstName1 = 'El primer nombre es obligatorio';
        if (!lastName1.trim()) newErrors.lastName1 = 'El primer apellido es obligatorio';
        
        // Validación de cédula (7-8 dígitos)
        const dniDigits = dni.replace(/V-/i, '').trim();
        if (!dniDigits) {
            newErrors.dni = 'La cédula es obligatoria';
        } else if (dniDigits.length < 7 || dniDigits.length > 8) {
            newErrors.dni = 'La cédula debe tener entre 7 y 8 dígitos';
        }

        // Validación de teléfono (opcional pero si se coloca, debe tener 7 dígitos)
        if (phoneNumber && phoneNumber.length !== 7) {
            newErrors.phone = 'El teléfono debe tener 7 dígitos tras el código';
        }

        if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            newErrors.email = 'Email inválido';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validate()) return;

        setSaving(true);
        try {
            const combinedFirstName = capitalizeWords(`${firstName1} ${firstName2}`);
            const combinedLastName = capitalizeWords(`${lastName1} ${lastName2}`);
            const combinedPhone = phoneNumber ? `${phonePrefix}-${phoneNumber}` : '';

            const payload = {
                dni,
                first_name: combinedFirstName,
                last_name: combinedLastName,
                phone: combinedPhone,
                email,
                role: 'representante'
            };
            await onSave(payload);
            onClose();
        } catch (error) {
            console.error('Error saving representative:', error);
        } finally {
            setSaving(false);
        }
    };

    return (
        <CModal size="lg" visible={visible} onClose={onClose} backdrop="static" className="animate-fade-in premium-modal">
            <CModalHeader className="border-0 bg-warning text-white pb-3">
                <CModalTitle className="fw-bold d-flex align-items-center">
                    <CIcon icon={cilUser} className="me-2 text-white-50" />
                    {initial ? 'Editar Representante' : 'Nuevo Representante'}
                </CModalTitle>
            </CModalHeader>
            <CForm onSubmit={handleSubmit}>
                <CModalBody className="p-4 bg-light-custom bg-opacity-10">
                    {/* NOMBRES */}
                    <div className="d-flex align-items-center gap-2 mb-3">
                        <span className="badge bg-warning bg-opacity-10 text-warning fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                            NOMBRES Y APELLIDOS
                        </span>
                        <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
                    </div>
                    <CRow className="g-3 mb-4">
                        <CCol md={3}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">1er Nombre <span className="text-danger">*</span></label>
                            <CFormInput
                                placeholder="Ej: Juan"
                                value={firstName1}
                                onChange={(e) => {
                                    setFirstName1(e.target.value);
                                    if (errors.firstName1) setErrors(prev => ({ ...prev, firstName1: null }));
                                }}
                                className="input-premium bg-light-custom border-light-custom"
                                invalid={!!errors.firstName1}
                            />
                            {errors.firstName1 && <div className="invalid-feedback d-block small mt-1">{errors.firstName1}</div>}
                        </CCol>
                        <CCol md={3}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">2do Nombre</label>
                            <CFormInput
                                placeholder="Ej: Carlos"
                                value={firstName2}
                                onChange={(e) => setFirstName2(e.target.value)}
                                className="input-premium bg-light-custom border-light-custom"
                            />
                        </CCol>
                        <CCol md={3}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">1er Apellido <span className="text-danger">*</span></label>
                            <CFormInput
                                placeholder="Ej: Pérez"
                                value={lastName1}
                                onChange={(e) => {
                                    setLastName1(e.target.value);
                                    if (errors.lastName1) setErrors(prev => ({ ...prev, lastName1: null }));
                                }}
                                className="input-premium bg-light-custom border-light-custom"
                                invalid={!!errors.lastName1}
                            />
                            {errors.lastName1 && <div className="invalid-feedback d-block small mt-1">{errors.lastName1}</div>}
                        </CCol>
                        <CCol md={3}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">2do Apellido</label>
                            <CFormInput
                                placeholder="Ej: Gómez"
                                value={lastName2}
                                onChange={(e) => setLastName2(e.target.value)}
                                className="input-premium bg-light-custom border-light-custom"
                            />
                        </CCol>
                    </CRow>

                    {/* DATOS DE CONTACTO */}
                    <div className="d-flex align-items-center gap-2 mb-3">
                        <span className="badge bg-warning bg-opacity-10 text-warning fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                            DATOS DE CONTACTO
                        </span>
                        <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
                    </div>
                    <CRow className="g-3">
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Cédula de Identidad <span className="text-danger">*</span></label>
                            <CFormInput
                                placeholder="V-12345678"
                                value={dni}
                                onChange={handleDniChange}
                                maxLength={10}
                                className="input-premium bg-light-custom border-light-custom"
                                invalid={!!errors.dni}
                            />
                            {errors.dni && <div className="invalid-feedback d-block small mt-1">{errors.dni}</div>}
                        </CCol>
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Teléfono Principal</label>
                            <CInputGroup>
                                <CFormSelect
                                    value={phonePrefix}
                                    onChange={(e) => setPhonePrefix(e.target.value)}
                                    style={{ maxWidth: '110px', flex: '0 0 110px' }}
                                    className="input-premium bg-light-custom border-light-custom"
                                >
                                    {PHONE_PREFIXES.map(p => (
                                        <option key={p} value={p}>{p}</option>
                                    ))}
                                </CFormSelect>
                                <CFormInput
                                    type="tel"
                                    placeholder="1234567"
                                    value={phoneNumber}
                                    onChange={(e) => {
                                        setPhoneNumber(e.target.value.replace(/[^0-9]/g, '').slice(0, 7));
                                        if (errors.phone) setErrors(prev => ({ ...prev, phone: null }));
                                    }}
                                    maxLength={7}
                                    className={`input-premium bg-light-custom border-light-custom ${errors.phone ? 'is-invalid' : ''}`}
                                />
                            </CInputGroup>
                            {errors.phone && <div className="invalid-feedback d-block small mt-1">{errors.phone}</div>}
                        </CCol>
                        <CCol md={12}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Email / Usuario de Acceso <span className="text-danger">*</span></label>
                            <CFormInput
                                type="email"
                                placeholder="usuario@correo.com"
                                value={email}
                                onChange={(e) => {
                                    setEmail(e.target.value);
                                    if (errors.email) setErrors(prev => ({ ...prev, email: null }));
                                }}
                                className="input-premium bg-light-custom border-light-custom"
                                invalid={!!errors.email}
                            />
                            {errors.email && <div className="invalid-feedback d-block small mt-1">{errors.email}</div>}
                        </CCol>
                    </CRow>
                </CModalBody>
                <CModalFooter className="border-0 p-4 pt-0 bg-light-custom bg-opacity-10">
                    <CButton color="light" onClick={onClose} className="px-4 fw-bold text-muted-custom bg-transparent border-0 hover-lift">
                        CANCELAR
                    </CButton>
                    <CButton
                        type="submit"
                        className="btn-premium px-4 bg-warning border-0"
                        disabled={saving}
                    >
                        {saving ? <CSpinner size="sm" /> : <CIcon icon={cilSave} className="me-2 text-white" />}
                        <span className="text-white">GUARDAR CAMBIOS</span>
                    </CButton>
                </CModalFooter>
            </CForm>
        </CModal>
    );
};

export default RepForm;
