import React, { useState, useEffect } from 'react';
import {
    CModal,
    CModalHeader,
    CModalTitle,
    CModalBody,
    CForm,
    CFormInput,
    CModalFooter,
    CButton,
    CFormSelect,
    CInputGroup,
    CRow,
    CCol,
    CAlert,
    CSpinner
} from '@coreui/react';
import CIcon from '@coreui/icons-react';
import { 
    cilSave, 
    cilX, 
    cilUser, 
    cilEnvelopeClosed, 
    cilLockLocked, 
    cilPhone, 
    cilBadge, 
    cilSearch, 
    cilCheckCircle, 
    cilPeople 
} from '@coreui/icons';
import { capitalizeWords } from '../../utils/formatters';
import { searchDocenteCandidates } from '../../services/userService';

const PHONE_PREFIXES = ['0414', '0424', '0416', '0426', '0412', '0422'];

const UserForm = ({ visible, onClose, onSave, initial = null }) => {
    const [dni, setDni] = useState('');
    const [firstName1, setFirstName1] = useState('');
    const [firstName2, setFirstName2] = useState('');
    const [lastName1, setLastName1] = useState('');
    const [lastName2, setLastName2] = useState('');
    const [password, setPassword] = useState('');
    const [phonePrefix, setPhonePrefix] = useState('0414');
    const [phoneNumber, setPhoneNumber] = useState('');
    const [email, setEmail] = useState('');
    const [role, setRole] = useState('docente');
    const [status, setStatus] = useState('active');
    const [errors, setErrors] = useState({});
    const [saving, setSaving] = useState(false);

    // ============================================
    // ESTADOS PARA ASIGNACIÓN DE CANDIDATO EXISTENTE
    // ============================================
    const [isAssignExisting, setIsAssignExisting] = useState(false);
    const [searchCandidateTerm, setSearchCandidateTerm] = useState('');
    const [candidateResults, setCandidateResults] = useState([]);
    const [searchingCandidates, setSearchingCandidates] = useState(false);
    const [selectedCandidate, setSelectedCandidate] = useState(null);

    useEffect(() => {
        if (visible) {
            setIsAssignExisting(false);
            setSearchCandidateTerm('');
            setCandidateResults([]);
            setSelectedCandidate(null);

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

                setPassword('');
                setEmail(initial.email || initial.correo || '');
                setRole(initial.role || initial.tipo_rol || initial.rol || 'docente');
                setStatus(initial.status || initial.estatus_usuario || 'active');
            } else {
                setDni('V-');
                setFirstName1('');
                setFirstName2('');
                setLastName1('');
                setLastName2('');
                setPassword('');
                setPhonePrefix('0414');
                setPhoneNumber('');
                setEmail('');
                setRole('docente');
                setStatus('active');
            }
            setErrors({});
        }
    }, [visible, initial]);

    // Búsqueda en vivo de candidatos con debounce
    useEffect(() => {
        if (!isAssignExisting || selectedCandidate) return;
        if (!searchCandidateTerm || searchCandidateTerm.trim().length < 2) {
            setCandidateResults([]);
            return;
        }

        const timer = setTimeout(async () => {
            setSearchingCandidates(true);
            try {
                const results = await searchDocenteCandidates(searchCandidateTerm.trim());
                setCandidateResults(results);
            } catch (err) {
                console.error('Error buscando candidatos:', err);
                setCandidateResults([]);
            } finally {
                setSearchingCandidates(false);
            }
        }, 300);

        return () => clearTimeout(timer);
    }, [searchCandidateTerm, isAssignExisting, selectedCandidate]);

    const handleSelectCandidate = (cand) => {
        setSelectedCandidate(cand);
        setDni(cand.dni || 'V-');

        // Parsear nombres del candidato
        const rawFn = cand.first_name || '';
        const fnParts = String(rawFn).trim().split(/\s+/);
        setFirstName1(fnParts[0] || '');
        setFirstName2(fnParts.slice(1).join(' ') || '');

        const rawLn = cand.last_name || '';
        const lnParts = String(rawLn).trim().split(/\s+/);
        setLastName1(lnParts[0] || '');
        setLastName2(lnParts.slice(1).join(' ') || '');

        // Parsear teléfono
        const tel = cand.phone || '';
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

        setEmail(cand.email || '');
        setRole('docente');
        setErrors({});
    };

    const handleClearCandidate = () => {
        setSelectedCandidate(null);
        setSearchCandidateTerm('');
        setCandidateResults([]);
        setDni('V-');
        setFirstName1('');
        setFirstName2('');
        setLastName1('');
        setLastName2('');
        setEmail('');
        setPhoneNumber('');
        setPhonePrefix('0414');
        setPassword('');
        setErrors({});
    };

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

        // Validación de teléfono
        if (phoneNumber && phoneNumber.length !== 7) {
            newErrors.phone = 'El teléfono debe tener 7 dígitos tras el código';
        }

        if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            newErrors.email = 'Email válido es obligatorio';
        }

        // La contraseña es obligatoria solo en creación desde cero
        const isExistingWithAccount = isAssignExisting && selectedCandidate && selectedCandidate.id;
        if (!initial && !isExistingWithAccount && (!password.trim() || password.length < 4)) {
            newErrors.password = 'Contraseña débil (mín. 4 caracteres)';
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

            let payload;
            if (isAssignExisting && selectedCandidate) {
                payload = {
                    is_assign_existing: true,
                    userId: selectedCandidate.id || null,
                    studentId: selectedCandidate.student_id || null,
                    dni,
                    first_name: combinedFirstName,
                    last_name: combinedLastName,
                    phone: combinedPhone,
                    email,
                    role: 'docente',
                    status,
                    ...(password.trim() && { password })
                };
            } else {
                payload = {
                    dni,
                    first_name: combinedFirstName,
                    last_name: combinedLastName,
                    phone: combinedPhone,
                    email,
                    role,
                    status,
                    ...(password.trim() && { password })
                };
            }

            await onSave(payload);
            onClose();
        } catch (error) {
            console.error('Error saving user:', error);
        } finally {
            setSaving(false);
        }
    };

    const isLockedByCandidate = isAssignExisting && !!selectedCandidate;

    return (
        <CModal size="lg" visible={visible} onClose={onClose} backdrop="static" className="animate-fade-in premium-modal">
            <CModalHeader className="border-0 bg-primary text-white pb-3">
                <CModalTitle className="fw-bold d-flex align-items-center">
                    <CIcon icon={cilUser} className="me-2 text-white-50" />
                    {initial ? 'Editar Usuario' : (isAssignExisting ? 'Asignar Rol Docente a Usuario Existente' : 'Nuevo Registro de Acceso')}
                </CModalTitle>
            </CModalHeader>
            <CForm onSubmit={handleSubmit}>
                <CModalBody className="p-4 bg-light-custom bg-opacity-10">
                    
                    {/* PANEL DE ASIGNACIÓN A USUARIO EXISTENTE (SOLO EN CREACIÓN) */}
                    {!initial && (
                        <div className="p-3 mb-4 rounded-3 border border-primary border-opacity-25 bg-primary bg-opacity-10 shadow-sm">
                            <div className="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                <div className="d-flex align-items-center gap-2">
                                    <CIcon icon={cilPeople} className="text-primary fs-4" />
                                    <div>
                                        <div className="fw-bold text-contrast" style={{ fontSize: '0.95rem' }}>
                                            ¿Escoger un Representante o Estudiante existente para ser Docente?
                                        </div>
                                        <div className="text-muted-custom small">
                                            Asigna el rol docente a una persona ya registrada en el sistema sin duplicar su cuenta.
                                        </div>
                                    </div>
                                </div>
                                <div className="form-check form-switch m-0 ms-auto">
                                    <input
                                        className="form-check-input"
                                        type="checkbox"
                                        role="switch"
                                        id="switchAssignDocente"
                                        style={{ width: '2.6em', height: '1.4em', cursor: 'pointer' }}
                                        checked={isAssignExisting}
                                        onChange={(e) => {
                                            setIsAssignExisting(e.target.checked);
                                            if (e.target.checked) {
                                                setRole('docente');
                                            } else {
                                                handleClearCandidate();
                                            }
                                        }}
                                    />
                                </div>
                            </div>

                            {/* CONTENIDO EXPANDIBLE DE BÚSQUEDA */}
                            {isAssignExisting && (
                                <div className="mt-3 pt-3 border-top border-primary border-opacity-25">
                                    {!selectedCandidate ? (
                                        <div>
                                            <label className="form-label small fw-bold text-uppercase text-primary ls-1 mb-1">
                                                Buscar Representante o Estudiante
                                            </label>
                                            <CInputGroup className="mb-2">
                                                <span className="input-group-text bg-white border-end-0">
                                                    <CIcon icon={cilSearch} className="text-muted" />
                                                </span>
                                                <CFormInput
                                                    placeholder="Escribe nombre, apellido o cédula (ej: V-12345678)..."
                                                    value={searchCandidateTerm}
                                                    onChange={(e) => setSearchCandidateTerm(e.target.value)}
                                                    className="input-premium bg-white border-start-0 text-contrast"
                                                    autoFocus
                                                />
                                                {searchingCandidates && (
                                                    <span className="input-group-text bg-white">
                                                        <CSpinner size="sm" color="primary" />
                                                    </span>
                                                )}
                                            </CInputGroup>

                                            {/* RESULTADOS DE BÚSQUEDA */}
                                            {candidateResults.length > 0 && (
                                                <div className="border rounded-2 bg-white shadow-sm overflow-hidden mt-2" style={{ maxHeight: '220px', overflowY: 'auto' }}>
                                                    {candidateResults.map((cand, idx) => (
                                                        <div
                                                            key={cand.id || `stu_${cand.student_id}` || idx}
                                                            className="p-2 px-3 border-bottom d-flex align-items-center justify-content-between hover-bg-light cursor-pointer"
                                                            style={{ transition: 'background 0.2s' }}
                                                            onClick={() => handleSelectCandidate(cand)}
                                                        >
                                                            <div>
                                                                <div className="fw-bold text-dark d-flex align-items-center gap-2">
                                                                    {cand.first_name} {cand.last_name}
                                                                    <span className={`badge ${cand.source_type === 'representante' ? 'bg-primary' : 'bg-info'} text-white text-uppercase`} style={{ fontSize: '0.65rem' }}>
                                                                        {cand.source_type}
                                                                    </span>
                                                                </div>
                                                                <div className="small text-muted d-flex gap-3 mt-1">
                                                                    <span><strong>Cédula:</strong> {cand.dni || 'Sin Cédula'}</span>
                                                                    {cand.email && <span><strong>Correo:</strong> {cand.email}</span>}
                                                                    {cand.phone && <span><strong>Tel:</strong> {cand.phone}</span>}
                                                                </div>
                                                            </div>
                                                            <CButton size="sm" color="primary" variant="outline" className="rounded-pill px-3 fw-bold">
                                                                Escoger
                                                            </CButton>
                                                        </div>
                                                    ))}
                                                </div>
                                            )}

                                            {searchCandidateTerm.trim().length >= 2 && !searchingCandidates && candidateResults.length === 0 && (
                                                <div className="p-2 text-center text-muted small bg-white rounded-2 border mt-2">
                                                    No se encontraron representantes o estudiantes que coincidan con &quot;{searchCandidateTerm}&quot;.
                                                </div>
                                            )}
                                        </div>
                                    ) : (
                                        /* CANDIDATO YA SELECCIONADO */
                                        <div className="d-flex align-items-center justify-content-between p-3 bg-white rounded-3 border border-success shadow-sm">
                                            <div className="d-flex align-items-center gap-3">
                                                <CIcon icon={cilCheckCircle} size="xl" className="text-success flex-shrink-0" />
                                                <div>
                                                    <div className="d-flex align-items-center gap-2">
                                                        <span className="badge bg-success text-uppercase">Candidato Seleccionado</span>
                                                        <span className={`badge ${selectedCandidate.source_type === 'representante' ? 'bg-primary' : 'bg-info'} text-uppercase`}>
                                                            {selectedCandidate.source_type}
                                                        </span>
                                                    </div>
                                                    <div className="fw-bold text-dark fs-6 mt-1">
                                                        {selectedCandidate.first_name} {selectedCandidate.last_name}
                                                    </div>
                                                    <div className="small text-muted">
                                                        Cédula: {selectedCandidate.dni || 'N/A'} {selectedCandidate.email ? `| Correo: ${selectedCandidate.email}` : ''}
                                                    </div>
                                                </div>
                                            </div>
                                            <CButton
                                                size="sm"
                                                color="danger"
                                                variant="outline"
                                                onClick={handleClearCandidate}
                                                className="fw-bold rounded-pill px-3"
                                            >
                                                <CIcon icon={cilX} className="me-1" /> Cambiar Selección
                                            </CButton>
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    )}

                    {/* NOMBRES */}
                    <div className="d-flex align-items-center gap-2 mb-3">
                        <span className="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                            NOMBRES Y APELLIDOS
                        </span>
                        {isLockedByCandidate && (
                            <span className="badge bg-secondary bg-opacity-25 text-muted small">
                                (Datos cargados automáticamente)
                            </span>
                        )}
                        <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,110,253,0.2), transparent)' }} />
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
                                disabled={isLockedByCandidate}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
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
                                disabled={isLockedByCandidate}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
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
                                disabled={isLockedByCandidate}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
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
                                disabled={isLockedByCandidate}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
                            />
                        </CCol>
                    </CRow>

                    {/* DATOS DE CONTACTO Y ACCESO */}
                    <div className="d-flex align-items-center gap-2 mb-3">
                        <span className="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                            DATOS DE IDENTIFICACIÓN Y CONTACTO
                        </span>
                        <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,110,253,0.2), transparent)' }} />
                    </div>
                    <CRow className="g-3">
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Cédula (V-) <span className="text-danger">*</span></label>
                            <CFormInput
                                placeholder="V-12345678"
                                value={dni}
                                onChange={handleDniChange}
                                disabled={isLockedByCandidate}
                                maxLength={10}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
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
                                    className="input-premium bg-light-custom border-light-custom text-contrast"
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
                                    className={`input-premium bg-light-custom border-light-custom text-contrast ${errors.phone ? 'is-invalid' : ''}`}
                                />
                            </CInputGroup>
                            {errors.phone && <div className="invalid-feedback d-block small mt-1">{errors.phone}</div>}
                        </CCol>
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Email <span className="text-danger">*</span></label>
                            <CFormInput
                                type="email"
                                placeholder="usuario@correo.com"
                                value={email}
                                onChange={(e) => {
                                    setEmail(e.target.value);
                                    if (errors.email) setErrors(prev => ({ ...prev, email: null }));
                                }}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
                                invalid={!!errors.email}
                            />
                            {errors.email && <div className="invalid-feedback d-block small mt-1">{errors.email}</div>}
                        </CCol>
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Rol en el Sistema</label>
                            <CFormSelect
                                value={role}
                                onChange={(e) => setRole(e.target.value)}
                                disabled={isAssignExisting}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
                            >
                                <option value="superadmin">Superadmin</option>
                                <option value="admin">Administrador</option>
                                <option value="secretaria">Secretaria</option>
                                <option value="docente">Docente</option>
                            </CFormSelect>
                        </CCol>
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Estado de la cuenta</label>
                            <CFormSelect
                                value={status}
                                onChange={(e) => setStatus(e.target.value)}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
                            >
                                <option value="active">Activo</option>
                                <option value="inactive">Inactivo</option>
                                <option value="suspended">Suspendido</option>
                            </CFormSelect>
                        </CCol>
                        <CCol md={6}>
                            <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                {initial || (isAssignExisting && selectedCandidate?.id)
                                    ? 'Nueva Contraseña (opcional)'
                                    : 'Contraseña de Acceso'}
                            </label>
                            <CFormInput
                                type="password"
                                placeholder={isAssignExisting && selectedCandidate?.id ? 'Mantener contraseña actual o cambiar' : 'Mínimo 4 caracteres'}
                                value={password}
                                onChange={(e) => {
                                    setPassword(e.target.value);
                                    if (errors.password) setErrors(prev => ({ ...prev, password: null }));
                                }}
                                className="input-premium bg-light-custom border-light-custom text-contrast"
                                invalid={!!errors.password}
                                required={!initial && !(isAssignExisting && selectedCandidate?.id)}
                            />
                            {errors.password && <div className="invalid-feedback d-block small mt-1">{errors.password}</div>}
                        </CCol>
                    </CRow>
                </CModalBody>
                <CModalFooter className="border-0 p-4 pt-0 bg-light-custom bg-opacity-10">
                    <CButton color="light" onClick={onClose} className="px-4 fw-bold text-muted-custom bg-transparent border-0 hover-lift">
                        CANCELAR
                    </CButton>
                    <CButton
                        type="submit"
                        className="btn-premium px-4"
                        disabled={saving}
                    >
                        {saving ? <CSpinner size="sm" /> : <CIcon icon={cilSave} className="me-2" />}
                        {initial ? 'GUARDAR CAMBIOS' : (isAssignExisting ? 'ASIGNAR ROL DOCENTE' : 'REGISTRAR ACCESO')}
                    </CButton>
                </CModalFooter>
            </CForm>
        </CModal>
    );
};

export default UserForm;
