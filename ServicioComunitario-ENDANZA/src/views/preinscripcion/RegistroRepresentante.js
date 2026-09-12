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
import { cilUser, cilArrowRight, cilWarning, cilLockLocked, cilEducation } from '@coreui/icons';

// Importar servicio
import { searchRepresentantes, getDocentesList } from '../../services/representanteService';
import { capitalizeWords } from '../../utils/formatters';

const parseInitialData = (data) => {
    if (!data || Object.keys(data).length === 0) {
        return {
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
            id_representante: null,
            id_usuario_docente: null
        };
    }

    let fn1 = data.firstName1 || '';
    let fn2 = data.firstName2 || '';
    if (!fn1 && data.first_name) {
        const parts = String(data.first_name).trim().split(/\s+/);
        fn1 = parts[0] || '';
        fn2 = parts.slice(1).join(' ') || '';
    }

    let ln1 = data.lastName1 || '';
    let ln2 = data.lastName2 || '';
    if (!ln1 && data.last_name) {
        const parts = String(data.last_name).trim().split(/\s+/);
        ln1 = parts[0] || '';
        ln2 = parts.slice(1).join(' ') || '';
    }

    let pPrefix = data.phonePrefix || '0414';
    let pNum = data.phoneNumber || '';
    if (!pNum && data.phone) {
        const tel = data.phone;
        const prefijos = ['0414', '0424', '0416', '0426', '0412', '0422'];
        const matched = prefijos.find(p => tel.startsWith(p + '-') || tel.startsWith(p));
        if (matched) {
            pPrefix = matched;
            pNum = tel.replace(matched + '-', '').replace(matched, '').slice(0, 7);
        } else {
            pNum = tel.replace(/[^0-9]/g, '').slice(0, 7);
        }
    }

    return {
        dni: data.dni || 'V-',
        firstName1: fn1,
        firstName2: fn2,
        lastName1: ln1,
        lastName2: ln2,
        first_name: data.first_name || `${fn1} ${fn2}`.trim(),
        last_name: data.last_name || `${ln1} ${ln2}`.trim(),
        phonePrefix: pPrefix,
        phoneNumber: pNum,
        phone: data.phone || (pNum ? `${pPrefix}-${pNum}` : ''),
        email: data.email || '',
        password: data.password !== undefined ? data.password : '1234',
        parentesco: data.parentesco || 'Madre',
        parentesco_otro: data.parentesco_otro || '',
        id_representante: data.id_representante || null,
        id_usuario_docente: data.id_usuario_docente || null
    };
};

const RegistroRepresentante = ({ onNext, initialData = {}, onChange, loading = false }) => {
    const [formData, setFormData] = useState(() => parseInitialData(initialData));

    const [searchTerm, setSearchTerm] = useState('');
    const [filteredReps, setFilteredReps] = useState([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    const [errors, setErrors] = useState({});
    const [searching, setSearching] = useState(false);
    const [representanteSeleccionado, setRepresentanteSeleccionado] = useState(null);

    // Estado para docente de la institución (Rol Dual)
    const [esDocente, setEsDocente] = useState(() => !!initialData?.id_usuario_docente);
    const [docentesList, setDocentesList] = useState([]);
    const [loadingDocentes, setLoadingDocentes] = useState(false);
    const [selectedDocenteId, setSelectedDocenteId] = useState(() => initialData?.id_usuario_docente ? String(initialData.id_usuario_docente) : '');
    const [docenteSeleccionado, setDocenteSeleccionado] = useState(null);

    // Sincronizar si cambia initialData
    useEffect(() => {
        if (initialData && Object.keys(initialData).length > 0) {
            const parsed = parseInitialData(initialData);
            setFormData(parsed);
            if (initialData.id_representante) {
                setRepresentanteSeleccionado({
                    first_name: parsed.first_name,
                    last_name: parsed.last_name,
                    dni: parsed.dni
                });
                setSearchTerm(`${parsed.first_name} ${parsed.last_name}`.trim());
            }
        } else {
            setFormData(parseInitialData(null));
            setRepresentanteSeleccionado(null);
            setSearchTerm('');
            setErrors({});
        }
    }, [initialData]);

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

    // Cargar docentes cuando se activa el switch de rol dual
    useEffect(() => {
        if (esDocente && docentesList.length === 0) {
            setLoadingDocentes(true);
            getDocentesList()
                .then(docs => {
                    setDocentesList(docs || []);
                    if (formData.id_usuario_docente) {
                        const found = (docs || []).find(d => String(d.id) === String(formData.id_usuario_docente));
                        if (found) setDocenteSeleccionado(found);
                    }
                })
                .catch(err => console.error("Error cargando docentes:", err))
                .finally(() => setLoadingDocentes(false));
        }
    }, [esDocente]);

    const handleDocenteChange = (docenteId) => {
        setSelectedDocenteId(docenteId);
        if (!docenteId) {
            setDocenteSeleccionado(null);
            const cleared = {
                ...formData,
                id_usuario_docente: null,
                password: '1234'
            };
            setFormData(cleared);
            if (onChange) onChange(cleared);
            return;
        }

        const doc = docentesList.find(d => String(d.id) === String(docenteId));
        if (!doc) return;

        setDocenteSeleccionado(doc);

        const [fName1, ...fNameRest] = (doc.nombre || '').trim().split(' ');
        const [lName1, ...lNameRest] = (doc.apellido || '').trim().split(' ');
        const fName2 = fNameRest.join(' ');
        const lName2 = lNameRest.join(' ');

        let pPrefix = '0414';
        let pNumber = '';
        if (doc.phone && doc.phone.includes('-')) {
            const parts = doc.phone.split('-');
            pPrefix = parts[0];
            pNumber = parts[1];
        } else if (doc.phone) {
            pNumber = doc.phone;
        }

        const newDocData = {
            ...formData,
            dni: doc.cedula || 'V-',
            firstName1: fName1 || '',
            firstName2: fName2 || '',
            lastName1: lName1 || '',
            lastName2: lName2 || '',
            first_name: doc.nombre || '',
            last_name: doc.apellido || '',
            phonePrefix: pPrefix,
            phoneNumber: pNumber,
            phone: doc.phone || '',
            email: doc.email || '',
            password: '', // Sin contraseña requerida, usa la de docente
            id_usuario_docente: doc.id,
            id_representante: null
        };

        setFormData(newDocData);
        if (onChange) onChange(newDocData);
        setErrors({});
    };

    const handleToggleDocente = (checked) => {
        setEsDocente(checked);
        if (!checked) {
            setSelectedDocenteId('');
            setDocenteSeleccionado(null);
            const cleared = {
                ...formData,
                id_usuario_docente: null,
                password: '1234'
            };
            setFormData(cleared);
            if (onChange) onChange(cleared);
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

        const newRepData = {
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
            id_representante: rep.id_representante,
            id_usuario_docente: null
        };
        setFormData(newRepData);
        if (onChange) onChange(newRepData);

        setRepresentanteSeleccionado({
            first_name: rep.first_name,
            last_name: rep.last_name,
            dni: rep.dni
        });

        setSearchTerm(`${rep.first_name} ${rep.last_name}`);
        setShowSuggestions(false);
    };

    const limpiarSeleccion = () => {
        const clearedData = {
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
            id_representante: null,
            id_usuario_docente: null
        };
        setFormData(clearedData);
        if (onChange) onChange(clearedData);
        setRepresentanteSeleccionado(null);
        setDocenteSeleccionado(null);
        setSelectedDocenteId('');
        setEsDocente(false);
        setSearchTerm('');
    };

    const handleDniChange = (e) => {
        let value = e.target.value.toUpperCase();
        if (!value.startsWith('V-')) {
            value = 'V-' + value.replace(/V-|\s/g, '');
        }
        if (value === 'V') value = 'V-';
        const docValue = value.substring(2);
        const cleanedDocValue = docValue.replace(/[^0-9]/g, '').slice(0, 8);
        const updated = { ...formData, dni: 'V-' + cleanedDocValue };
        setFormData(updated);
        if (onChange) onChange(updated);
        if (errors.dni) setErrors(prev => ({ ...prev, dni: null }));
    };

    const validate = () => {
        const newErrors = {};
        if (!formData.first_name.trim()) newErrors.first_name = 'El nombre es obligatorio';
        if (!formData.last_name.trim()) newErrors.last_name = 'El apellido es obligatorio';
        
        // Validar cédula: debe tener entre 7 y 8 dígitos (sin el prefijo V-)
        const dniDigits = formData.dni.replace(/V-/i, '').trim();
        if (!dniDigits) {
            newErrors.dni = 'La cédula es obligatoria';
        } else if (dniDigits.length < 7 || dniDigits.length > 8) {
            newErrors.dni = 'La cédula debe tener entre 7 y 8 dígitos';
        }
        
        if (!formData.email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) newErrors.email = 'Email inválido';

        // Validar contraseña solo si es nuevo representante y no es docente vinculado
        const isDocenteLinked = !!formData.id_usuario_docente;
        if (!representanteSeleccionado && !isDocenteLinked && !formData.password.trim()) {
            newErrors.password = 'La contraseña es obligatoria para nuevos representantes';
        } else if (!representanteSeleccionado && !isDocenteLinked && formData.password.trim().length < 4) {
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
        if (onChange) onChange(newData);
        if (errors[field]) setErrors(prev => ({ ...prev, [field]: null }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!validate()) return;

        const f1 = capitalizeWords(formData.firstName1);
        const f2 = capitalizeWords(formData.firstName2);
        const l1 = capitalizeWords(formData.lastName1);
        const l2 = capitalizeWords(formData.lastName2);

        const formattedData = {
            ...formData,
            firstName1: f1,
            firstName2: f2,
            lastName1: l1,
            lastName2: l2,
            first_name: `${f1} ${f2}`.trim(),
            last_name: `${l1} ${l2}`.trim()
        };

        setFormData(formattedData);
        // Pasar los datos al componente padre
        onNext(formattedData);
    };

    const isFieldDisabled = !!representanteSeleccionado || !!docenteSeleccionado;

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
                            disabled={!!docenteSeleccionado}
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

            {/* Opción de Rol Dual: ¿Es docente de la institución? */}
            {!representanteSeleccionado && (
                <CCard
                    className="premium-card border-0 mb-4 shadow-sm"
                    style={{
                        backgroundColor: esDocente ? 'rgba(50, 31, 219, 0.04)' : 'rgba(0, 0, 0, 0.02)',
                        borderLeft: esDocente ? '4px solid #321fdb' : 'none',
                        transition: 'all 0.3s ease'
                    }}
                >
                    <CCardBody className="p-4">
                        <div className="d-flex justify-content-between align-items-center">
                            <div className="d-flex align-items-center gap-3">
                                <div
                                    className={`p-2 rounded-circle ${esDocente ? 'bg-primary text-white' : 'bg-secondary bg-opacity-10 text-muted'}`}
                                    style={{ width: '40px', height: '40px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
                                >
                                    <CIcon icon={cilEducation} size="lg" />
                                </div>
                                <div>
                                    <h6 className="fw-bold mb-1 text-body">¿El representante es docente de la institución?</h6>
                                    <p className="small text-muted mb-0">
                                        Si ya forma parte del personal docente, vinculará su cuenta existente sin requerir nuevas credenciales (Rol Dual).
                                    </p>
                                </div>
                            </div>
                            <div className="form-check form-switch ms-3">
                                <input
                                    className="form-check-input"
                                    type="checkbox"
                                    id="switchDocente"
                                    checked={esDocente}
                                    onChange={(e) => handleToggleDocente(e.target.checked)}
                                    style={{ width: '2.5em', height: '1.3em', cursor: 'pointer' }}
                                />
                            </div>
                        </div>

                        {esDocente && (
                            <div className="mt-4 pt-3 border-top border-light-custom animate__animated animate__fadeIn">
                                <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">
                                    Seleccionar Docente <span className="text-danger">*</span>
                                </label>
                                {loadingDocentes ? (
                                    <div className="d-flex align-items-center gap-2 text-muted py-2">
                                        <CSpinner size="sm" color="primary" />
                                        <small>Cargando lista de docentes...</small>
                                    </div>
                                ) : (
                                    <CFormSelect
                                        className="input-premium py-2"
                                        value={selectedDocenteId}
                                        onChange={(e) => handleDocenteChange(e.target.value)}
                                    >
                                        <option value="">-- Seleccione un docente --</option>
                                        {docentesList.map((doc) => (
                                            <option key={doc.id} value={doc.id}>
                                                {doc.nombre} {doc.apellido} ({doc.cedula || 'Sin cédula'}) - {doc.email}
                                            </option>
                                        ))}
                                    </CFormSelect>
                                )}

                                {docenteSeleccionado && (
                                    <CAlert color="success" className="mt-3 mb-0 py-2 px-3 small d-flex justify-content-between align-items-center">
                                        <div>
                                            <CIcon icon={cilEducation} className="me-2" />
                                            <strong>Docente vinculado:</strong> {docenteSeleccionado.nombre} {docenteSeleccionado.apellido}.
                                            Los datos personales se han autocompletado y mantendrá su contraseña habitual de docente.
                                        </div>
                                        <CButton
                                            color="secondary"
                                            variant="outline"
                                            size="sm"
                                            onClick={limpiarSeleccion}
                                            className="ms-2"
                                        >
                                            Limpiar
                                        </CButton>
                                    </CAlert>
                                )}
                            </div>
                        )}
                    </CCardBody>
                </CCard>
            )}

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
                                : docenteSeleccionado
                                ? 'Datos del docente vinculado (no modificables)'
                                : 'Complete los datos del nuevo representante'}
                        </span>
                        <div className="flex-grow-1 border-bottom border-light-custom"></div>
                    </div>

                    <CForm onSubmit={handleSubmit}>
                        {/* ── SECCIÓN NOMBRES ── */}
                        <div className="d-flex align-items-center gap-2 mb-3">
                            <span
                                className="badge fw-bold px-3 py-1 rounded-pill"
                                style={{ fontSize: '0.7rem', letterSpacing: '0.5px', background: 'rgba(242,140,15,0.15)', color: '#C35604' }}
                            >
                                NOMBRES Y APELLIDOS
                            </span>
                            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
                        </div>
                        <CRow className="g-3 mb-4">
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
                                />
                            </CCol>
                            {(errors.first_name || errors.last_name) && (
                                <CCol xs={12}>
                                    <div className="text-danger small">
                                        {errors.first_name || errors.last_name}
                                    </div>
                                </CCol>
                            )}
                        </CRow>

                        {/* ── SECCIÓN DATOS DE CONTACTO ── */}
                        <div className="d-flex align-items-center gap-2 mb-3">
                            <span
                                className="badge fw-bold px-3 py-1 rounded-pill"
                                style={{ fontSize: '0.7rem', letterSpacing: '0.5px', background: 'rgba(242,140,15,0.15)', color: '#C35604' }}
                            >
                                DATOS DE CONTACTO
                            </span>
                            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
                        </div>
                        <CRow className="g-3">
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
                                    maxLength={10}
                                />
                                {errors.dni && <div className="text-danger small mt-1">{errors.dni}</div>}
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
                                        disabled={isFieldDisabled}
                                    >
                                        <option value="0414">0414</option>
                                        <option value="0424">0424</option>
                                        <option value="0416">0416</option>
                                        <option value="0426">0426</option>
                                        <option value="0412">0412</option>
                                        <option value="0422">0422</option>
                                    </CFormSelect>
                                    <CFormInput
                                        placeholder="1234567"
                                        value={formData.phoneNumber}
                                        onChange={(e) => handleFormChange('phoneNumber', e.target.value.replace(/\D/g, ''))}
                                        className="input-premium py-2"
                                        maxLength={7}
                                        readOnly={isFieldDisabled}
                                        disabled={isFieldDisabled}
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
                                    readOnly={isFieldDisabled}
                                    disabled={isFieldDisabled}
                                />
                            </CCol>

                            {/* Campo de contraseña - SOLO para nuevos representantes */}
                            {!representanteSeleccionado && !docenteSeleccionado && (
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

                            {docenteSeleccionado && (
                                <CCol md={12}>
                                    <div className="p-3 rounded-4 bg-primary bg-opacity-10 border border-primary border-opacity-25">
                                        <CIcon icon={cilEducation} className="me-2 text-primary" />
                                        <span className="text-primary fw-semibold">
                                            Cuenta de docente vinculada. Se mantendrán las credenciales de acceso actuales de su cuenta docente.
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
                                disabled={loading}
                                className="btn-premium px-5 d-flex align-items-center fw-bold"
                            >
                                {loading ? (
                                    <>
                                        <CSpinner size="sm" className="me-2" />
                                        CARGANDO...
                                    </>
                                ) : (
                                    <>
                                        {representanteSeleccionado
                                            ? 'CONTINUAR PARA AGREGAR ESTUDIANTES'
                                            : docenteSeleccionado
                                            ? 'CONTINUAR CON DOCENTE VINCULADO'
                                            : 'CONTINUAR A ESTUDIANTE'}
                                        <CIcon icon={cilArrowRight} className="ms-2" />
                                    </>
                                )}
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