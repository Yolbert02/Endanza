import React from "react"
import {
  CForm,
  CRow,
  CCol,
  CFormInput,
  CFormSelect,
  CFormLabel,
  CInputGroup,
  CInputGroupText,
} from "@coreui/react"

const PHONE_PREFIXES = ["0414", "0424", "0416", "0426", "0412", "0422"];

const PhoneField = ({ label, name, value, onChange, error, placeholder = "1234567" }) => {
  const val = value || "";
  const matchedPrefix = PHONE_PREFIXES.find(p => val.startsWith(p + '-') || val.startsWith(p)) || "0414";
  const numberPart = val.startsWith(matchedPrefix + '-')
    ? val.slice(matchedPrefix.length + 1)
    : val.startsWith(matchedPrefix)
      ? val.slice(matchedPrefix.length)
      : val.replace(/[^0-9]/g, '').slice(0, 7);

  const handlePrefixChange = (e) => {
    const newPrefix = e.target.value;
    const combined = numberPart ? `${newPrefix}-${numberPart}` : '';
    onChange({ target: { name, value: combined } });
  };

  const handleNumberChange = (e) => {
    const digits = e.target.value.replace(/[^0-9]/g, '').slice(0, 7);
    const combined = digits ? `${matchedPrefix}-${digits}` : '';
    onChange({ target: { name, value: combined } });
  };

  return (
    <div>
      <CFormLabel className="fw-bold">{label}</CFormLabel>
      <CInputGroup>
        <CFormSelect
          value={matchedPrefix}
          onChange={handlePrefixChange}
          style={{ maxWidth: '110px', flex: '0 0 110px' }}
          className="input-premium py-2"
        >
          {PHONE_PREFIXES.map(p => <option key={p} value={p}>{p}</option>)}
        </CFormSelect>
        <CFormInput
          type="tel"
          value={numberPart}
          onChange={handleNumberChange}
          placeholder={placeholder}
          maxLength={7}
          className={`input-premium py-2 ${error ? 'is-invalid' : ''}`}
        />
      </CInputGroup>
      {error && <div className="invalid-feedback d-block small mt-1">{error}</div>}
    </div>
  );
};

const CedulaField = ({ label, name, value, onChange, error, placeholder = "12345678" }) => {
  const handleChange = (e) => {
    const clean = e.target.value.replace(/[^0-9]/g, '').slice(0, 8);
    onChange({ target: { name, value: clean } });
  };

  return (
    <div>
      <CFormLabel className="fw-bold">{label}</CFormLabel>
      <CInputGroup>
        <CInputGroupText className="bg-light-custom text-muted fw-bold">V-</CInputGroupText>
        <CFormInput
          type="text"
          name={name}
          value={value ? String(value).replace(/^V-?/i, '') : ''}
          onChange={handleChange}
          placeholder={placeholder}
          maxLength={8}
          className={`input-premium py-2 ${error ? 'is-invalid' : ''}`}
        />
      </CInputGroup>
      {error && <div className="invalid-feedback d-block small mt-1">{error}</div>}
    </div>
  );
};

const editForm = ({ formData, onInputChange, activeTab, errors = {} }) => {
  // Opciones para selects
  const sexoOptions = [
    { value: "", label: "Seleccionar sexo" },
    { value: "Masculino", label: "Masculino" },
    { value: "Femenino", label: "Femenino" }
  ]

  const tipoSangreOptions = [
    { value: "", label: "Seleccionar tipo" },
    { value: "O+", label: "O+" },
    { value: "O-", label: "O-" },
    { value: "A+", label: "A+" },
    { value: "A-", label: "A-" },
    { value: "B+", label: "B+" },
    { value: "B-", label: "B-" },
    { value: "AB+", label: "AB+" },
    { value: "AB-", label: "AB-" }
  ]

  const estatusOptions = [
    { value: "", label: "Seleccionar estatus" },
    { value: "Activo", label: "Activo" },
    { value: "Inactivo", label: "Inactivo" },
    { value: "Graduado", label: "Graduado" },
    { value: "Retirado", label: "Retirado" }
  ]

  return (
    <CForm className="animate__animated animate__fadeIn">
      {/* SECCIÓN 0: DATOS PERSONALES */}
      {activeTab === 0 && (
        <>
          <h5 className="mb-3 text-primary form-section-border pb-2">Información de Identidad</h5>
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES Y APELLIDOS DEL ESTUDIANTE
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,110,253,0.2), transparent)' }} />
          </div>
          <CRow className="mb-3">
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="EstudiantePrimerNombre"
                value={formData.EstudiantePrimerNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Juan"
                className={`input-premium h-auto py-2 ${errors.EstudiantePrimerNombre || errors.NombreEstudiante ? 'is-invalid' : ''}`}
              />
              {(errors.EstudiantePrimerNombre || errors.NombreEstudiante) && (
                <div className="invalid-feedback">{errors.EstudiantePrimerNombre || errors.NombreEstudiante}</div>
              )}
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="EstudianteSegundoNombre"
                value={formData.EstudianteSegundoNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Carlos"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="EstudiantePrimerApellido"
                value={formData.EstudiantePrimerApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Pérez"
                className={`input-premium h-auto py-2 ${errors.EstudiantePrimerApellido || errors.ApellidoEstudiante ? 'is-invalid' : ''}`}
              />
              {(errors.EstudiantePrimerApellido || errors.ApellidoEstudiante) && (
                <div className="invalid-feedback">{errors.EstudiantePrimerApellido || errors.ApellidoEstudiante}</div>
              )}
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="EstudianteSegundoApellido"
                value={formData.EstudianteSegundoApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Gómez"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={4}>
              <CFormLabel className="fw-bold">Fecha de Nacimiento</CFormLabel>
              <CFormInput
                type="date"
                name="FechaNacimiento"
                value={formData.FechaNacimiento || ""}
                onChange={onInputChange}
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={4}>
              <CFormLabel className="fw-bold">Sexo</CFormLabel>
              <CFormSelect
                name="Sexo"
                value={formData.Sexo || ""}
                onChange={onInputChange}
                options={sexoOptions}
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={4}>
              <CFormLabel className="fw-bold">Tipo de Sangre</CFormLabel>
              <CFormSelect
                name="TipoSangre"
                value={formData.TipoSangre || ""}
                onChange={onInputChange}
                options={tipoSangreOptions}
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CFormLabel className="fw-bold">Estatus Académico</CFormLabel>
              <CFormSelect
                name="Estatus"
                value={formData.Estatus || ""}
                onChange={onInputChange}
                options={estatusOptions}
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">Grado</CFormLabel>
              <CFormInput
                type="text"
                name="Grado"
                value={formData.Grado || ""}
                onChange={onInputChange}
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">Sección</CFormLabel>
              <CFormInput
                type="text"
                name="Seccion"
                value={formData.Seccion || ""}
                onChange={onInputChange}
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>
        </>
      )}

      {/* SECCIÓN 1: CONTACTO */}
      {activeTab === 1 && (
        <>
          <h5 className="mb-3 text-primary form-section-border pb-2">Datos de Ubicación y Contacto</h5>
          <CRow className="mb-3">
            <CCol md={12}>
              <CFormLabel className="fw-bold">Dirección de Habitación</CFormLabel>
              <CFormInput
                type="text"
                name="Direccion"
                value={formData.Direccion || ""}
                onChange={onInputChange}
                placeholder="Dirección completa"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={4}>
              <CFormLabel className="fw-bold">Ciudad</CFormLabel>
              <CFormInput
                type="text"
                name="Ciudad"
                value={formData.Ciudad || ""}
                onChange={onInputChange}
                placeholder="Ciudad"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={4}>
              <CFormLabel className="fw-bold">Estado</CFormLabel>
              <CFormInput
                type="text"
                name="Estado"
                value={formData.Estado || ""}
                onChange={onInputChange}
                placeholder="Estado"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={4}>
              <PhoneField
                label="Teléfono Principal"
                name="Telefono"
                value={formData.Telefono || ""}
                onChange={onInputChange}
                error={errors.Telefono}
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={8}>
              <CFormLabel className="fw-bold">Correo Electrónico</CFormLabel>
              <CFormInput
                type="email"
                name="Email"
                value={formData.Email || ""}
                onChange={onInputChange}
                placeholder="correo@ejemplo.com"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>
        </>
      )}

      {/* SECCIÓN 2: PADRE */}
      {activeTab === 2 && (
        <>
          <h5 className="mb-3 text-primary form-section-border pb-2">Información del Padre / Representante</h5>
          
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES Y APELLIDOS DEL PADRE
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,110,253,0.2), transparent)' }} />
          </div>
          <CRow className="mb-3">
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="PadrePrimerNombre"
                value={formData.PadrePrimerNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Juan"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="PadreSegundoNombre"
                value={formData.PadreSegundoNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Carlos"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="PadrePrimerApellido"
                value={formData.PadrePrimerApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Pérez"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="PadreSegundoApellido"
                value={formData.PadreSegundoApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Gómez"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CedulaField
                label="Cédula del Padre"
                name="PadreCedula"
                value={formData.PadreCedula || ""}
                onChange={onInputChange}
                error={errors.PadreCedula}
              />
            </CCol>
            <CCol md={6}>
              <PhoneField
                label="Teléfono del Padre"
                name="PadreTelefono"
                value={formData.PadreTelefono || ""}
                onChange={onInputChange}
                error={errors.PadreTelefono}
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CFormLabel className="fw-bold">Email del Padre</CFormLabel>
              <CFormInput
                type="email"
                name="PadreEmail"
                value={formData.PadreEmail || ""}
                onChange={onInputChange}
                placeholder="correo@ejemplo.com"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={6}>
              <CFormLabel className="fw-bold">Ocupación</CFormLabel>
              <CFormInput
                type="text"
                name="PadreOcupacion"
                value={formData.PadreOcupacion || ""}
                onChange={onInputChange}
                placeholder="Ocupación o profesión"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>
        </>
      )}

      {/* SECCIÓN 3: MADRE */}
      {activeTab === 3 && (
        <>
          <h5 className="mb-3 text-primary form-section-border pb-2">Información de la Madre / Representante</h5>
          
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-danger bg-opacity-10 text-danger fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES Y APELLIDOS DE LA MADRE
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(220,53,69,0.2), transparent)' }} />
          </div>
          <CRow className="mb-3">
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="MadrePrimerNombre"
                value={formData.MadrePrimerNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: María"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="MadreSegundoNombre"
                value={formData.MadreSegundoNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Elena"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="MadrePrimerApellido"
                value={formData.MadrePrimerApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Rodríguez"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="MadreSegundoApellido"
                value={formData.MadreSegundoApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Pérez"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CedulaField
                label="Cédula de la Madre"
                name="MadreCedula"
                value={formData.MadreCedula || ""}
                onChange={onInputChange}
                error={errors.MadreCedula}
              />
            </CCol>
            <CCol md={6}>
              <PhoneField
                label="Teléfono de la Madre"
                name="MadreTelefono"
                value={formData.MadreTelefono || ""}
                onChange={onInputChange}
                error={errors.MadreTelefono}
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CFormLabel className="fw-bold">Email de la Madre</CFormLabel>
              <CFormInput
                type="email"
                name="MadreEmail"
                value={formData.MadreEmail || ""}
                onChange={onInputChange}
                placeholder="correo@ejemplo.com"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={6}>
              <CFormLabel className="fw-bold">Ocupación</CFormLabel>
              <CFormInput
                type="text"
                name="MadreOcupacion"
                value={formData.MadreOcupacion || ""}
                onChange={onInputChange}
                placeholder="Ocupación o profesión"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>
        </>
      )}

      {/* SECCIÓN 4: REPRESENTANTE LEGAL */}
      {activeTab === 4 && (
        <>
          <h5 className="mb-3 text-primary form-section-border pb-2">Asignación de Representante Legal</h5>
          <CRow className="mb-4">
            <CCol md={(!["Madre", "Padre", "Tío", "Abuelo", "Hermano", ""].includes(formData.RepresentanteParentesco)) ? 6 : 12}>
              <CFormLabel className="fw-bold">¿Quién es el Representante Legal?</CFormLabel>
              <CFormSelect
                name="RepresentanteSelection"
                value={
                  ["Madre", "Padre", "Tío", "Abuelo", "Hermano", ""].includes(formData.RepresentanteParentesco)
                    ? (formData.RepresentanteParentesco || "")
                    : "Otro"
                }
                onChange={(e) => {
                  const selection = e.target.value;
                  const updatedData = { ...formData };

                  if (selection === "Madre") {
                    updatedData.RepresentanteParentesco = "Madre";
                    const fn1 = formData.MadrePrimerNombre || formData.RepresentantePrimerNombre || "";
                    const fn2 = formData.MadreSegundoNombre || formData.RepresentanteSegundoNombre || "";
                    const ln1 = formData.MadrePrimerApellido || formData.RepresentantePrimerApellido || "";
                    const ln2 = formData.MadreSegundoApellido || formData.RepresentanteSegundoApellido || "";
                    const ced = formData.MadreCedula || formData.RepresentanteCedula || "";
                    const tel = formData.MadreTelefono || formData.RepresentanteTelefono || "";
                    const ema = formData.MadreEmail || formData.RepresentanteEmail || "";
                    const ocu = formData.MadreOcupacion || formData.RepresentanteOcupacion || "";
                    const fullN = `${fn1} ${fn2}`.trim();
                    const fullL = `${ln1} ${ln2}`.trim();

                    updatedData.RepresentantePrimerNombre = fn1;
                    updatedData.MadrePrimerNombre = fn1;
                    updatedData.RepresentanteSegundoNombre = fn2;
                    updatedData.MadreSegundoNombre = fn2;
                    updatedData.RepresentantePrimerApellido = ln1;
                    updatedData.MadrePrimerApellido = ln1;
                    updatedData.RepresentanteSegundoApellido = ln2;
                    updatedData.MadreSegundoApellido = ln2;
                    updatedData.RepresentanteNombre = fullN;
                    updatedData.MadreNombre = fullN;
                    updatedData.RepresentanteApellido = fullL;
                    updatedData.MadreApellido = fullL;
                    updatedData.RepresentanteCedula = ced;
                    updatedData.MadreCedula = ced;
                    updatedData.RepresentanteTelefono = tel;
                    updatedData.MadreTelefono = tel;
                    updatedData.RepresentanteEmail = ema;
                    updatedData.MadreEmail = ema;
                    updatedData.RepresentanteOcupacion = ocu;
                    updatedData.MadreOcupacion = ocu;
                  } else if (selection === "Padre") {
                    updatedData.RepresentanteParentesco = "Padre";
                    const fn1 = formData.PadrePrimerNombre || formData.RepresentantePrimerNombre || "";
                    const fn2 = formData.PadreSegundoNombre || formData.RepresentanteSegundoNombre || "";
                    const ln1 = formData.PadrePrimerApellido || formData.RepresentantePrimerApellido || "";
                    const ln2 = formData.PadreSegundoApellido || formData.RepresentanteSegundoApellido || "";
                    const ced = formData.PadreCedula || formData.RepresentanteCedula || "";
                    const tel = formData.PadreTelefono || formData.RepresentanteTelefono || "";
                    const ema = formData.PadreEmail || formData.RepresentanteEmail || "";
                    const ocu = formData.PadreOcupacion || formData.RepresentanteOcupacion || "";
                    const fullN = `${fn1} ${fn2}`.trim();
                    const fullL = `${ln1} ${ln2}`.trim();

                    updatedData.RepresentantePrimerNombre = fn1;
                    updatedData.PadrePrimerNombre = fn1;
                    updatedData.RepresentanteSegundoNombre = fn2;
                    updatedData.PadreSegundoNombre = fn2;
                    updatedData.RepresentantePrimerApellido = ln1;
                    updatedData.PadrePrimerApellido = ln1;
                    updatedData.RepresentanteSegundoApellido = ln2;
                    updatedData.PadreSegundoApellido = ln2;
                    updatedData.RepresentanteNombre = fullN;
                    updatedData.PadreNombre = fullN;
                    updatedData.RepresentanteApellido = fullL;
                    updatedData.PadreApellido = fullL;
                    updatedData.RepresentanteCedula = ced;
                    updatedData.PadreCedula = ced;
                    updatedData.RepresentanteTelefono = tel;
                    updatedData.PadreTelefono = tel;
                    updatedData.RepresentanteEmail = ema;
                    updatedData.PadreEmail = ema;
                    updatedData.RepresentanteOcupacion = ocu;
                    updatedData.PadreOcupacion = ocu;
                  } else if (selection === "Otro") {
                    updatedData.RepresentanteParentesco = "OTRO_VALOR"; // Flag para mostrar input
                  } else {
                    updatedData.RepresentanteParentesco = selection;
                  }

                  onInputChange({ target: { name: 'multiple', value: updatedData } });
                }}
                className="input-premium h-auto py-2"
                options={[
                  { value: "", label: "Seleccionar parentesco" },
                  { value: "Madre", label: "Madre" },
                  { value: "Padre", label: "Padre" },
                  { value: "Tío", label: "Tío(a)" },
                  { value: "Abuelo", label: "Abuelo(a)" },
                  { value: "Hermano", label: "Hermano(a) Mayor" },
                  { value: "Otro", label: "Otro" }
                ]}
              />
            </CCol>

            {/* Campo dinámico para 'Otro' parentesco */}
            {(!["Madre", "Padre", "Tío", "Abuelo", "Hermano", ""].includes(formData.RepresentanteParentesco)) && (
              <CCol md={6} className="animate__animated animate__fadeIn">
                <CFormLabel className="fw-bold">Especifique el Parentesco</CFormLabel>
                <CFormInput
                  type="text"
                  name="RepresentanteParentesco"
                  value={formData.RepresentanteParentesco === "OTRO_VALOR" ? "" : formData.RepresentanteParentesco}
                  onChange={onInputChange}
                  placeholder="Ej: Primo, Padrino..."
                  className="input-premium h-auto py-2"
                />
              </CCol>
            )}
          </CRow>

          <h5 className="mb-3 text-primary form-section-border pb-2">Información del Representante</h5>
          
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-warning bg-opacity-10 text-warning fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES Y APELLIDOS DEL REPRESENTANTE
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
          </div>
          <CRow className="mb-3">
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="RepresentantePrimerNombre"
                value={formData.RepresentantePrimerNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Carlos"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Nombre</CFormLabel>
              <CFormInput
                type="text"
                name="RepresentanteSegundoNombre"
                value={formData.RepresentanteSegundoNombre || ""}
                onChange={onInputChange}
                placeholder="Ej: Alberto"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">1er Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="RepresentantePrimerApellido"
                value={formData.RepresentantePrimerApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Mendoza"
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormLabel className="fw-bold">2do Apellido</CFormLabel>
              <CFormInput
                type="text"
                name="RepresentanteSegundoApellido"
                value={formData.RepresentanteSegundoApellido || ""}
                onChange={onInputChange}
                placeholder="Ej: Ruiz"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CedulaField
                label="Cédula de Identidad"
                name="RepresentanteCedula"
                value={formData.RepresentanteCedula || ""}
                onChange={onInputChange}
                error={errors.RepresentanteCedula}
              />
            </CCol>
            <CCol md={6}>
              <PhoneField
                label="Teléfono de Contacto"
                name="RepresentanteTelefono"
                value={formData.RepresentanteTelefono || ""}
                onChange={onInputChange}
                error={errors.RepresentanteTelefono}
              />
            </CCol>
          </CRow>

          <CRow className="mb-3">
            <CCol md={6}>
              <CFormLabel className="fw-bold">Ocupación / Profesión</CFormLabel>
              <CFormInput
                type="text"
                name="RepresentanteOcupacion"
                value={formData.RepresentanteOcupacion || ""}
                onChange={onInputChange}
                placeholder="Ej: Docente, Comerciante..."
                className="input-premium h-auto py-2"
              />
            </CCol>
            <CCol md={6}>
              <CFormLabel className="fw-bold">Correo Electrónico</CFormLabel>
              <CFormInput
                type="email"
                name="RepresentanteEmail"
                value={formData.RepresentanteEmail || ""}
                onChange={onInputChange}
                placeholder="correo@ejemplo.com"
                className="input-premium h-auto py-2"
              />
            </CCol>
          </CRow>
        </>
      )}
      <style>{`
        .form-section-border { border-bottom: 2px solid var(--neutral-100) !important; }
        [data-coreui-theme="dark"] .form-section-border { border-bottom-color: rgba(255,255,255,0.05) !important; }
      `}</style>
    </CForm>
  )
}

export default editForm