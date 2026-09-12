import React from "react";
import { CFormInput, CRow, CCol, CFormSelect, CInputGroup } from "@coreui/react";
import CIcon from "@coreui/icons-react";
import { cilUser, cilHeart, cilGroup } from "@coreui/icons";

const PHONE_PREFIXES = ["0414", "0424", "0416", "0426", "0412", "0422"];

const SectionHeader = ({ icon, title, color = "primary" }) => (
  <div className={`p-4 rounded-4 step-section-bg border mb-4 text-start border-${color} border-opacity-10`}>
    <h5 className={`mb-0 text-${color} d-flex align-items-center fw-bold text-uppercase ls-1`} style={{ fontSize: '0.9rem' }}>
      <span className={`p-2 bg-${color} bg-opacity-10 text-${color} rounded-circle me-3`}>
        <CIcon icon={icon} size="sm" />
      </span>
      {title}
    </h5>
  </div>
);

const PhoneInputGroup = ({ prefixName, numberName, prefixValue, numberValue, onChange, invalid, feedback }) => (
  <div>
    <CInputGroup>
      <CFormSelect
        name={prefixName}
        value={prefixValue || "0414"}
        onChange={onChange}
        className="input-premium py-2"
        style={{ maxWidth: '110px', flex: '0 0 110px' }}
      >
        {PHONE_PREFIXES.map(p => <option key={p} value={p}>{p}</option>)}
      </CFormSelect>
      <CFormInput
        name={numberName}
        value={numberValue || ""}
        onChange={onChange}
        placeholder="1234567"
        maxLength={7}
        className={`input-premium py-2 ${invalid ? 'is-invalid' : ''}`}
      />
    </CInputGroup>
    {invalid && <div className="invalid-feedback d-block small">{feedback}</div>}
  </div>
);

const NameLabel = ({ text, required }) => (
  <span className="fw-bold step-label text-uppercase ls-1 small mb-1">
    {text}{required && <span className="text-danger"> *</span>}
  </span>
);

const DatosRepresentante = ({ formData, onChange, errores = {}, setErrores }) => {

  const handleRepChange = (val) => {
    if (val === 'Madre' || val === 'Padre') {
      onChange({ target: { name: 'quien_es_representante', value: val } });
      // Limpiar campos del representante "Otro"
      const fieldsToClear = [
        'nombres_Representante', 'apellidos_Representante', 'parentesco_Otro',
        'primer_nombre_Rep', 'segundo_nombre_Rep',
        'primer_apellido_Rep', 'segundo_apellido_Rep',
        'telefono_Rep', 'telefono_Rep_number'
      ];
      fieldsToClear.forEach(field => onChange({ target: { name: field, value: '' } }));
      onChange({ target: { name: 'telefono_Rep_prefix', value: '0414' } });

      if (setErrores) {
        const nuevosErrores = { ...errores };
        ['nombres_Representante', 'apellidos_Representante', 'parentesco_Otro', 'telefono_Rep'].forEach(k => delete nuevosErrores[k]);
        setErrores(nuevosErrores);
      }
    } else {
      onChange({ target: { name: 'quien_es_representante', value: val } });
    }
  };

  return (
    <div className="animate__animated animate__fadeIn">

      {/* ══════════ SECCIÓN MADRE ══════════ */}
      <SectionHeader icon={cilHeart} title="Información de la Madre" color="danger" />
      <CRow className="g-4 mb-5">
        {/* Nombres */}
        <CCol xs={12}>
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-danger bg-opacity-10 text-danger fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(220,53,69,0.2), transparent)' }} />
          </div>
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="1er Nombre" />}
            name="primer_nombre_Madre"
            value={formData.primer_nombre_Madre || ""}
            onChange={onChange}
            placeholder="Ej: María"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="2do Nombre" />}
            name="segundo_nombre_Madre"
            value={formData.segundo_nombre_Madre || ""}
            onChange={onChange}
            placeholder="Ej: Elena"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="1er Apellido" />}
            name="primer_apellido_Madre"
            value={formData.primer_apellido_Madre || ""}
            onChange={onChange}
            placeholder="Ej: Rodríguez"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="2do Apellido" />}
            name="segundo_apellido_Madre"
            value={formData.segundo_apellido_Madre || ""}
            onChange={onChange}
            placeholder="Ej: Pérez"
            className="input-premium py-2"
          />
        </CCol>

        {/* Datos de contacto */}
        <CCol xs={12}>
          <div className="d-flex align-items-center gap-2 mb-1 mt-1">
            <span className="badge bg-danger bg-opacity-10 text-danger fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              DATOS DE CONTACTO
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(220,53,69,0.2), transparent)' }} />
          </div>
        </CCol>
        <CCol md={4}>
          <CFormInput
            label={<NameLabel text="Cédula (V-)" />}
            name="cedula_Madre"
            value={formData.cedula_Madre || ""}
            onChange={onChange}
            placeholder="Ej: 12345678"
            maxLength={8}
            className={`input-premium py-2 ${errores.cedula_Madre ? 'is-invalid' : ''}`}
            feedback={errores.cedula_Madre}
            invalid={!!errores.cedula_Madre}
          />
        </CCol>
        <CCol md={4}>
          <CFormInput
            label={<NameLabel text="Ocupación / Profesión" />}
            name="ocupacion_Madre"
            value={formData.ocupacion_Madre || ""}
            onChange={onChange}
            placeholder="Ej: Abogada"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={4}>
          <label className="fw-bold step-label text-uppercase ls-1 small mb-1 d-block">Teléfono Móvil</label>
          <PhoneInputGroup
            prefixName="telefono_Madre_prefix"
            numberName="telefono_Madre_number"
            prefixValue={formData.telefono_Madre_prefix}
            numberValue={formData.telefono_Madre_number}
            onChange={onChange}
            invalid={!!errores.telefono_Madre}
            feedback={errores.telefono_Madre}
          />
        </CCol>
        <CCol md={6}>
          <CFormInput
            label={<NameLabel text="Lugar de Trabajo" />}
            name="trabajo_Madre"
            value={formData.trabajo_Madre || ""}
            onChange={onChange}
            placeholder="Empresa o Institución"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={6}>
          <CFormInput
            label={<NameLabel text="Dirección del Trabajo" />}
            name="direccion_Trabajo_Madre"
            value={formData.direccion_Trabajo_Madre || ""}
            onChange={onChange}
            placeholder="Dirección laboral detallada"
            className="input-premium py-2"
          />
        </CCol>
      </CRow>

      {/* ══════════ SECCIÓN PADRE ══════════ */}
      <SectionHeader icon={cilUser} title="Información del Padre" color="info" />
      <CRow className="g-4 mb-5">
        {/* Nombres */}
        <CCol xs={12}>
          <div className="d-flex align-items-center gap-2 mb-2">
            <span className="badge bg-info bg-opacity-10 text-info fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              NOMBRES
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,202,240,0.2), transparent)' }} />
          </div>
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="1er Nombre" />}
            name="primer_nombre_Padre"
            value={formData.primer_nombre_Padre || ""}
            onChange={onChange}
            placeholder="Ej: Juan"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="2do Nombre" />}
            name="segundo_nombre_Padre"
            value={formData.segundo_nombre_Padre || ""}
            onChange={onChange}
            placeholder="Ej: Carlos"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="1er Apellido" />}
            name="primer_apellido_Padre"
            value={formData.primer_apellido_Padre || ""}
            onChange={onChange}
            placeholder="Ej: López"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={3}>
          <CFormInput
            label={<NameLabel text="2do Apellido" />}
            name="segundo_apellido_Padre"
            value={formData.segundo_apellido_Padre || ""}
            onChange={onChange}
            placeholder="Ej: García"
            className="input-premium py-2"
          />
        </CCol>

        {/* Datos de contacto */}
        <CCol xs={12}>
          <div className="d-flex align-items-center gap-2 mb-1 mt-1">
            <span className="badge bg-info bg-opacity-10 text-info fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
              DATOS DE CONTACTO
            </span>
            <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(13,202,240,0.2), transparent)' }} />
          </div>
        </CCol>
        <CCol md={4}>
          <CFormInput
            label={<NameLabel text="Cédula (V-)" />}
            name="cedula_Padre"
            value={formData.cedula_Padre || ""}
            onChange={onChange}
            placeholder="Ej: 12345678"
            maxLength={8}
            className={`input-premium py-2 ${errores.cedula_Padre ? 'is-invalid' : ''}`}
            feedback={errores.cedula_Padre}
            invalid={!!errores.cedula_Padre}
          />
        </CCol>
        <CCol md={4}>
          <CFormInput
            label={<NameLabel text="Ocupación / Profesión" />}
            name="ocupacion_Padre"
            value={formData.ocupacion_Padre || ""}
            onChange={onChange}
            placeholder="Ej: Ingeniero"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={4}>
          <label className="fw-bold step-label text-uppercase ls-1 small mb-1 d-block">Teléfono Móvil</label>
          <PhoneInputGroup
            prefixName="telefono_Padre_prefix"
            numberName="telefono_Padre_number"
            prefixValue={formData.telefono_Padre_prefix}
            numberValue={formData.telefono_Padre_number}
            onChange={onChange}
            invalid={!!errores.telefono_Padre}
            feedback={errores.telefono_Padre}
          />
        </CCol>
        <CCol md={6}>
          <CFormInput
            label={<NameLabel text="Lugar de Trabajo" />}
            name="trabajo_Padre"
            value={formData.trabajo_Padre || ""}
            onChange={onChange}
            placeholder="Empresa o Institución"
            className="input-premium py-2"
          />
        </CCol>
        <CCol md={6}>
          <CFormInput
            label={<NameLabel text="Dirección del Trabajo" />}
            name="direccion_Trabajo_Padre"
            value={formData.direccion_Trabajo_Padre || ""}
            onChange={onChange}
            placeholder="Dirección laboral detallada"
            className="input-premium py-2"
          />
        </CCol>
      </CRow>

      {/* ══════════ ELECCIÓN DEL REPRESENTANTE ══════════ */}
      <SectionHeader icon={cilGroup} title="Designación del Representante Legal" color="warning" />
      <div className="p-4 rounded-4 bg-light-custom bg-opacity-10 border border-light mb-4">
        <label className="fw-bold step-label text-uppercase ls-1 small mb-3 d-block text-center">
          ¿Quién ejercerá como representante legal ante la institución? <span className="text-danger">*</span>
        </label>
        <div className="d-flex flex-column flex-md-row gap-3 justify-content-center">
          {['Madre', 'Padre', 'Otro'].map((option) => (
            <button
              key={option}
              type="button"
              className={`flex-fill py-3 fw-bold border-2 rep-choice-btn ${formData.quien_es_representante === option ? 'active' : ''}`}
              onClick={() => handleRepChange(option)}
            >
              <CIcon icon={option === 'Madre' ? cilHeart : option === 'Padre' ? cilUser : cilGroup} className="me-2" />
              {option.toUpperCase()}
            </button>
          ))}
        </div>
        {errores.quien_es_representante && (
          <div className="text-danger small text-center mt-2">{errores.quien_es_representante}</div>
        )}
      </div>

      {/* ══════════ CAMPOS CONDICIONALES PARA 'OTRO' ══════════ */}
      {formData.quien_es_representante === 'Otro' && (
        <div className="animate__animated animate__fadeInUp">
          <CRow className="g-4 mb-4">
            {/* Nombres del Representante */}
            <CCol xs={12}>
              <div className="d-flex align-items-center gap-2 mb-2">
                <span className="badge bg-warning bg-opacity-10 text-warning fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                  NOMBRES DEL REPRESENTANTE
                </span>
                <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
              </div>
            </CCol>
            <CCol md={3}>
              <CFormInput
                label={<NameLabel text="1er Nombre" required />}
                name="primer_nombre_Rep"
                value={formData.primer_nombre_Rep || ""}
                onChange={onChange}
                placeholder="Nombre"
                className={`input-premium py-2 ${errores.nombres_Representante ? 'is-invalid' : ''}`}
                feedback={errores.nombres_Representante}
                invalid={!!errores.nombres_Representante}
              />
            </CCol>
            <CCol md={3}>
              <CFormInput
                label={<NameLabel text="2do Nombre" />}
                name="segundo_nombre_Rep"
                value={formData.segundo_nombre_Rep || ""}
                onChange={onChange}
                placeholder="Segundo nombre"
                className="input-premium py-2"
              />
            </CCol>
            <CCol md={3}>
              <CFormInput
                label={<NameLabel text="1er Apellido" required />}
                name="primer_apellido_Rep"
                value={formData.primer_apellido_Rep || ""}
                onChange={onChange}
                placeholder="Apellido"
                className={`input-premium py-2 ${errores.apellidos_Representante ? 'is-invalid' : ''}`}
                feedback={errores.apellidos_Representante}
                invalid={!!errores.apellidos_Representante}
              />
            </CCol>
            <CCol md={3}>
              <CFormInput
                label={<NameLabel text="2do Apellido" />}
                name="segundo_apellido_Rep"
                value={formData.segundo_apellido_Rep || ""}
                onChange={onChange}
                placeholder="Segundo apellido"
                className="input-premium py-2"
              />
            </CCol>

            {/* Datos de contacto del Representante */}
            <CCol xs={12}>
              <div className="d-flex align-items-center gap-2 mb-1 mt-1">
                <span className="badge bg-warning bg-opacity-10 text-warning fw-bold px-3 py-1 rounded-pill" style={{ fontSize: '0.7rem', letterSpacing: '0.5px' }}>
                  DATOS DE CONTACTO
                </span>
                <div className="flex-grow-1" style={{ height: '1px', background: 'linear-gradient(to right, rgba(242,140,15,0.3), transparent)' }} />
              </div>
            </CCol>
            <CCol md={6}>
              <CFormInput
                label={<NameLabel text="Parentesco / Relación" required />}
                name="parentesco_Otro"
                value={formData.parentesco_Otro || ""}
                onChange={onChange}
                placeholder="Ej: Abuelo, Tío, Hermano mayor..."
                className={`input-premium py-2 ${errores.parentesco_Otro ? 'is-invalid' : ''}`}
                feedback={errores.parentesco_Otro}
                invalid={!!errores.parentesco_Otro}
              />
            </CCol>
            <CCol md={6}>
              <label className="fw-bold step-label text-uppercase ls-1 small mb-1 d-block">
                Teléfono Móvil <span className="text-danger">*</span>
              </label>
              <PhoneInputGroup
                prefixName="telefono_Rep_prefix"
                numberName="telefono_Rep_number"
                prefixValue={formData.telefono_Rep_prefix}
                numberValue={formData.telefono_Rep_number}
                onChange={onChange}
                invalid={!!errores.telefono_Rep}
                feedback={errores.telefono_Rep}
              />
            </CCol>
            <CCol md={6}>
              <CFormInput
                label={<NameLabel text="Lugar de Trabajo" />}
                name="trabajo_Rep"
                value={formData.trabajo_Rep || ""}
                onChange={onChange}
                placeholder="Empresa o Institución"
                className="input-premium py-2"
              />
            </CCol>
            <CCol md={6}>
              <CFormInput
                label={<NameLabel text="Dirección del Trabajo" />}
                name="direccion_Trabajo_Rep"
                value={formData.direccion_Trabajo_Rep || ""}
                onChange={onChange}
                placeholder="Dirección laboral detallada"
                className="input-premium py-2"
              />
            </CCol>
          </CRow>
        </div>
      )}

    </div>
  );
};

export default DatosRepresentante;