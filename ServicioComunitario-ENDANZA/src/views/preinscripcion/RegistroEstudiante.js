import React, { useState, useEffect } from 'react';
import {
    CCard,
    CCardBody,
    CForm,
    CFormInput,
    CFormSelect,
    CButton,
    CRow,
    CCol,
    CBadge,
    CSpinner
} from '@coreui/react';
import { cilSave, cilEducation, cilArrowLeft, cilPlus, cilTrash, cilUser } from '@coreui/icons';
import CIcon from '@coreui/icons-react';
import { capitalizeWords } from '../../utils/formatters';

const RegistroEstudiante = ({
    representative,
    existingStudents = [],
    initialStudents = null,
    onChangeStudents,
    onBack,
    onSave,
    loading = false
}) => {
    const [newStudents, setNewStudents] = useState(() => {
        if (initialStudents && initialStudents.length > 0) {
            return initialStudents;
        }
        return [
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
    });

    useEffect(() => {
        if (initialStudents && initialStudents.length > 0) {
            setNewStudents(initialStudents);
        }
    }, [initialStudents]);

    const updateStudents = (list) => {
        setNewStudents(list);
        if (onChangeStudents) {
            onChangeStudents(list);
        }
    };

    const handleAddNewStudent = () => {
        const updated = [...newStudents, {
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
        }];
        updateStudents(updated);
    };

    const handleRemoveNewStudent = (index) => {
        const list = [...newStudents];
        list.splice(index, 1);
        updateStudents(list);
    };

    const handleStudentChange = (index, field, value) => {
        const list = newStudents.map((s, i) => {
            if (i !== index) return s;
            const updated = { ...s, [field]: value };
            if (['firstName1', 'firstName2'].includes(field)) {
                updated.name = `${updated.firstName1 || ''} ${updated.firstName2 || ''}`.trim();
            }
            if (['lastName1', 'lastName2'].includes(field)) {
                updated.lastName = `${updated.lastName1 || ''} ${updated.lastName2 || ''}`.trim();
            }
            return updated;
        });
        updateStudents(list);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        const formattedList = newStudents.map(s => {
            const f1 = capitalizeWords(s.firstName1);
            const f2 = capitalizeWords(s.firstName2);
            const l1 = capitalizeWords(s.lastName1);
            const l2 = capitalizeWords(s.lastName2);
            return {
                ...s,
                firstName1: f1,
                firstName2: f2,
                lastName1: l1,
                lastName2: l2,
                name: `${f1} ${f2}`.trim() || capitalizeWords(s.name),
                lastName: `${l1} ${l2}`.trim() || capitalizeWords(s.lastName)
            };
        });
        updateStudents(formattedList);
        // Solo guardamos los nuevos. onSave los procesará.
        onSave(formattedList);
    };

    return (
        <div className="animate-fade-in">
            <div className="d-flex justify-content-between align-items-center mb-4">
                <h4 className="fw-bold text-warning d-flex align-items-center mb-0">
                    <div className="p-2 bg-warning bg-opacity-10 rounded-circle me-3">
                        <CIcon icon={cilEducation} size="lg" />
                    </div>
                    GESTIÓN DE ESTUDIANTES
                </h4>
                <div className="p-2 px-3 bg-light-custom rounded-pill small fw-bold text-muted-custom">
                    Representante: <span className="text-warning">{representative?.first_name} {representative?.last_name}</span>
                </div>
            </div>

            {/* Listado de Estudiantes ya inscritos */}
            {existingStudents.length > 0 && (
                <div className="mb-5">
                    <h6 className="small fw-bold text-uppercase ls-1 opacity-50 mb-3 px-1">
                        Estudiantes ya vinculados ({existingStudents.length})
                    </h6>
                    <CRow className="g-3">
                        {existingStudents.map((stud, idx) => (
                            <CCol md={6} key={idx}>
                                <CCard className="premium-card border-0 shadow-sm h-100" style={{ backgroundColor: 'rgba(0, 56, 118, 0.02)' }}>
                                    <CCardBody className="p-3 d-flex align-items-center">
                                        <div className="p-2 bg-primary bg-opacity-10 rounded text-primary me-3">
                                            <CIcon icon={cilUser} />
                                        </div>
                                        <div>
                                            <div className="fw-bold small">{stud.name} {stud.lastName}</div>
                                            <div className="text-muted-custom extra-small">{stud.gradeLevel} | {stud.status || 'Activo'}</div>
                                        </div>
                                    </CCardBody>
                                </CCard>
                            </CCol>
                        ))}
                    </CRow>
                </div>
            )}

            <div className="mb-4 d-flex align-items-center">
                <div className="flex-grow-1 border-bottom border-light-custom"></div>
                <span className="px-3 small fw-bold text-uppercase opacity-50">Inscribir Nuevos Estudiantes</span>
                <div className="flex-grow-1 border-bottom border-light-custom"></div>
            </div>

            <CForm onSubmit={handleSubmit}>
                {newStudents.map((student, idx) => (
                    <CCard key={idx} className="premium-card border-0 mb-4 shadow-sm position-relative overflow-visible">
                        {newStudents.length > 1 && (
                            <div
                                className="position-absolute"
                                style={{ top: '-15px', right: '-15px', zIndex: 10 }}
                            >
                                <CButton
                                    color="danger"
                                    onClick={() => handleRemoveNewStudent(idx)}
                                    className="rounded-circle p-2 shadow-sm text-white"
                                    size="sm"
                                >
                                    <CIcon icon={cilTrash} />
                                </CButton>
                            </div>
                        )}
                        <CCardBody className="p-4">
                            <div className="mb-3 d-flex align-items-center">
                                <CBadge color="warning" className="me-2">NUEVO #{idx + 1}</CBadge>
                                <span className="small fw-bold text-uppercase opacity-50">Carga de Datos</span>
                            </div>
                            <CRow className="g-4">
                                <CCol md={3}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">1er Nombre <span className="text-danger">*</span></label>
                                    <CFormInput
                                        placeholder="Ej: Sofía"
                                        value={student.firstName1}
                                        onChange={(e) => handleStudentChange(idx, 'firstName1', e.target.value)}
                                        className="input-premium py-2"
                                        required
                                    />
                                </CCol>
                                <CCol md={3}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">2do Nombre</label>
                                    <CFormInput
                                        placeholder="Ej: Isabella"
                                        value={student.firstName2}
                                        onChange={(e) => handleStudentChange(idx, 'firstName2', e.target.value)}
                                        className="input-premium py-2"
                                    />
                                </CCol>
                                <CCol md={3}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">1er Apellido <span className="text-danger">*</span></label>
                                    <CFormInput
                                        placeholder="Ej: Rodríguez"
                                        value={student.lastName1}
                                        onChange={(e) => handleStudentChange(idx, 'lastName1', e.target.value)}
                                        className="input-premium py-2"
                                        required
                                    />
                                </CCol>
                                <CCol md={3}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">2do Apellido</label>
                                    <CFormInput
                                        placeholder="Ej: Pérez"
                                        value={student.lastName2}
                                        onChange={(e) => handleStudentChange(idx, 'lastName2', e.target.value)}
                                        className="input-premium py-2"
                                    />
                                </CCol>
                                <CCol md={4}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Grado <span className="text-danger">*</span></label>
                                    <CFormSelect
                                        value={student.gradeLevel}
                                        onChange={(e) => handleStudentChange(idx, 'gradeLevel', e.target.value)}
                                        className="input-premium py-2"
                                        required
                                    >
                                        <option value="" disabled>Seleccione Grado</option>
                                        <option value="1er Grado">1er Grado</option>
                                        <option value="2do Grado">2do Grado</option>
                                        <option value="3er Grado">3er Grado</option>
                                        <option value="4to Grado">4to Grado</option>
                                        <option value="5to Grado">5to Grado</option>
                                        <option value="6to Grado">6to Grado</option>
                                    </CFormSelect>
                                </CCol>
                                <CCol md={4}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Fecha de Nacimiento <span className="text-danger">*</span></label>
                                    <CFormInput
                                        type="date"
                                        value={student.birthDate}
                                        onChange={(e) => handleStudentChange(idx, 'birthDate', e.target.value)}
                                        className="input-premium py-2"
                                        required
                                    />
                                </CCol>
                                <CCol md={4}>
                                    <label className="form-label small fw-bold text-uppercase text-muted-custom ls-1">Género <span className="text-danger">*</span></label>
                                    <CFormSelect
                                        value={student.gender}
                                        onChange={(e) => handleStudentChange(idx, 'gender', e.target.value)}
                                        className="input-premium py-2"
                                        required
                                    >
                                        <option value="" disabled>Seleccione Género</option>
                                        <option value="Femenino">Femenino</option>
                                        <option value="Masculino">Masculino</option>
                                    </CFormSelect>
                                </CCol>
                            </CRow>
                        </CCardBody>
                    </CCard>
                ))}

                <CButton
                    color="warning"
                    variant="ghost"
                    onClick={handleAddNewStudent}
                    className="w-100 py-3 mb-5 border-2 border-dashed fw-bold d-flex align-items-center justify-content-center hover-lift"
                    style={{ borderStyle: 'dashed', borderRadius: '16px' }}
                >
                    <CIcon icon={cilPlus} className="me-2" />
                    AGREGAR OTRO ESTUDIANTE AL MISMO REPRESENTANTE
                </CButton>

                <div className="d-flex justify-content-between mt-5 pt-4 border-top border-light-custom pb-5">
                    <CButton
                        type="button"
                        color="secondary"
                        variant="ghost"
                        onClick={() => onBack(newStudents)}
                        className="px-5 d-flex align-items-center fw-bold text-muted-custom transition-all"
                        disabled={loading}
                    >
                        <CIcon icon={cilArrowLeft} className="me-2" />
                        VOLVER A REPRESENTANTE
                    </CButton>
                    <CButton
                        type="submit"
                        className="btn-premium px-5 d-flex align-items-center fw-bold shadow-lg"
                        disabled={loading}
                    >
                        {loading ? (
                            <>
                                <CSpinner size="sm" className="me-2" />
                                PROCESANDO...
                            </>
                        ) : (
                            <>
                                COMPLETE EL REGISTRO
                                <CIcon icon={cilSave} className="ms-2" />
                            </>
                        )}
                    </CButton>
                </div>
            </CForm>

            <style>{`
                .extra-small { font-size: 0.75rem; }
            `}</style>
        </div>
    );
};

export default RegistroEstudiante;
