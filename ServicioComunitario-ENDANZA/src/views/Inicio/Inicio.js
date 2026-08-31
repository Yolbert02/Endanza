import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom'
import {
    CCol,
    CContainer,
    CRow,
    CSpinner
} from '@coreui/react';
import CIcon from '@coreui/icons-react'
import { cilSchool, cilPeople } from '@coreui/icons'
import { getMyStudents } from 'src/services/studentsService'
import { profileService } from 'src/services/profileService'

// Importar los nuevos componentes
import WelcomeBanner from './components/WelcomeBanner'
import StudentSelectionCard from './components/StudentSelectionCard'
import CedulaAlertModal from './components/CedulaAlertModal'

const InicioParent = () => {
    const navigate = useNavigate();
    const [children, setChildren] = useState([])
    const [loading, setLoading] = useState(true)
    const [showCedulaAlert, setShowCedulaAlert] = useState(false)

    useEffect(() => {
        fetchChildren()
        checkCedulaStatus()
    }, [])

    /**
     * Verifica si el representante tiene cédula registrada.
     * Si no la tiene, muestra el modal de alerta.
     * Usa sessionStorage para no repetir el aviso en la misma sesión.
     */
    const checkCedulaStatus = async () => {
        // Solo mostrar una vez por sesión
        const alreadyShown = sessionStorage.getItem('cedula_alert_shown')
        if (alreadyShown) return

        try {
            // Primero intentar desde localStorage para evitar una petición extra
            const userLocal = JSON.parse(localStorage.getItem('user') || '{}')
            const cedula = userLocal.cedula || ''

            if (!cedula || cedula.trim() === '' || cedula.trim() === 'V-') {
                // Confirmar con el backend por si el localStorage está desactualizado
                const profileResp = await profileService.getProfile()
                const cedulaBackend = profileResp?.user?.cedula || ''

                if (!cedulaBackend || cedulaBackend.trim() === '' || cedulaBackend.trim() === 'V-') {
                    setShowCedulaAlert(true)
                    sessionStorage.setItem('cedula_alert_shown', 'true')
                }
            }
        } catch (err) {
            // Si falla la verificación, no interrumpir la carga normal
            console.warn('⚠️ No se pudo verificar estado de cédula:', err)
        }
    }

    const fetchChildren = async () => {
        setLoading(true)
        try {
            const data = await getMyStudents()
            console.log("📥 Estudiantes del representante:", data)
            setChildren(data)
        } catch (error) {
            console.error("Error loading children:", error)
        } finally {
            setLoading(false)
        }
    }

    const handleViewProfile = (studentId) => {
        console.log("🔍 Navegando a:", `/perfilRepresentanteEstudiante/${studentId}`)
        navigate(`/perfilRepresentanteEstudiante/${studentId}`, {
            state: { studentsList: children }
        })
    }

    return (
        <CContainer fluid className="mt-4 pb-5">
            {/* Modal de aviso de cédula obligatoria */}
            <CedulaAlertModal
                visible={showCedulaAlert}
                onClose={() => setShowCedulaAlert(false)}
            />

            <CRow>
                <CCol>
                    <WelcomeBanner
                        title="¡Bienvenido!"
                        subtitle="Gestione la actividad académica de sus hijos desde este panel central."
                        icon={cilPeople}
                        bgIcon={cilSchool}
                        colorClass="warning"
                    />

                    <h4 className="mb-4 fw-bold section-title text-uppercase ls-1 d-flex align-items-center">
                        <CIcon icon={cilSchool} className="me-2 text-warning" />
                        Estudiantes a su cargo
                    </h4>

                    <CRow className="g-4">
                        {loading ? (
                            <CCol className="text-center py-5">
                                <CSpinner color="warning" />
                                <p className="mt-3">Cargando estudiantes...</p>
                            </CCol>
                        ) : children.length > 0 ? (
                            children.map((child) => (
                                <CCol key={child.id} lg={6}>
                                    <StudentSelectionCard
                                        child={child}
                                        colorClass="warning"
                                        buttonText="VER PERFIL ACADÉMICO"
                                        onClick={handleViewProfile}
                                    />
                                </CCol>
                            ))
                        ) : (
                            <CCol className="text-center py-5">
                                <p className="text-muted">No tiene estudiantes registrados</p>
                            </CCol>
                        )}
                    </CRow>
                </CCol>
            </CRow>
        </CContainer>
    )
}

export default InicioParent