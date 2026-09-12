// src/components/AppHeaderDropdown.js - VERSIÓN CORREGIDA
import React, { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  CAvatar,
  CDropdown,
  CDropdownHeader,
  CDropdownItem,
  CDropdownMenu,
  CDropdownToggle,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import {
  cilUser,
  cilSettings,
  cilLockLocked,
  cilAccountLogout,
  cilEducation,
  cilPeople,
  cilSpeedometer,
  cilTask,
} from '@coreui/icons'

// ✅ IMPORTAR authService y authStorage
import { authService } from '../../services/authService'
import { getStoredToken, clearStoredAuth } from '../../utils/authStorage'

const AppHeaderDropdown = () => {
  const navigate = useNavigate()
  const [userData, setUserData] = React.useState(null)

  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const response = await authService.getProfile()

        if (response.success) {
          setUserData(response.user)
        }
      } catch (error) {
        console.error('❌ Error obteniendo datos del usuario:', error)
      }
    }

    if (getStoredToken()) {
      fetchUserData()
    }
  }, [])

  const handleLogout = async () => {
    try {
      await authService.logout()
      navigate('/login?logout=success')
    } catch (error) {
      console.error('❌ Error en logout:', error)
      clearStoredAuth()
      navigate('/login')
    }
  }

  const getUserName = () => {
    if (userData) {
      return `${userData.nombre || ''} ${userData.apellido || ''}`.trim() || userData.username || 'Usuario'
    }

    try {
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      return `${user.nombre || ''} ${user.apellido || ''}`.trim() || user.username || 'Usuario'
    } catch {
      return 'Usuario'
    }
  }

  // Comprobar roles del usuario
  const userRoles = userData?.roles || []
  const hasMultipleRoles = userRoles.length > 1
  const currentActiveRole = sessionStorage.getItem('activeRole') || (userRoles[0] || 'admin')

  const roleMeta = {
    admin: { label: 'Administrador', icon: cilSpeedometer, route: '#/dashboard' },
    superadmin: { label: 'Administrador', icon: cilSpeedometer, route: '#/dashboard' },
    docente: { label: 'Docente', icon: cilEducation, route: '#/docente/inicio' },
    representante: { label: 'Representante', icon: cilPeople, route: '#/inicio' },
    secretaria: { label: 'Secretaría', icon: cilTask, route: '#/dashboard' },
  }

  const handleSelectRole = (nextRole) => {
    if (nextRole === currentActiveRole) return
    sessionStorage.setItem('activeRole', nextRole)

    try {
      const stored = JSON.parse(sessionStorage.getItem('user') || '{}')
      stored.rol = nextRole
      stored.activeRole = nextRole
      stored.esAdmin = nextRole === 'admin' || nextRole === 'superadmin'
      stored.esDocente = nextRole === 'docente'
      stored.esRepresentante = nextRole === 'representante'
      stored.esSecretaria = nextRole === 'secretaria'
      stored.esEstudiante = nextRole === 'estudiante'
      sessionStorage.setItem('user', JSON.stringify(stored))
    } catch (e) {
      console.error('Error actualizando usuario en sessionStorage:', e)
    }

    const targetRoute = roleMeta[nextRole]?.route || '#/dashboard'
    window.location.hash = targetRoute
    window.location.reload()
  }

  return (
    <>
      <CDropdown variant="nav-item" alignment="end" className="premium-dropdown">
        <CDropdownToggle className="py-0 d-flex align-items-center dropdown-toggle-custom" caret={false}>
          <span className="user-name-text d-none d-md-inline fw-bold">
            {getUserName()}
          </span>
        </CDropdownToggle>

        <CDropdownMenu className="premium-dropdown-menu p-2 border-0 shadow-lg animate__animated animate__fadeIn">
          <CDropdownHeader className="dropdown-header-custom border-0 bg-transparent py-3 px-3 mb-2 rounded-3">
            <div className="d-flex align-items-center">
              <div className="header-icon-box me-3">
                <CIcon icon={cilUser} size="lg" />
              </div>
              <div>
                <span className="d-block fw-bold ls-1 text-uppercase mb-0" style={{ fontSize: '0.65rem', opacity: 0.6 }}>Cuenta Personal</span>
                <span className="d-block fw-bolder header-title-custom" style={{ fontSize: '0.9rem' }}>Mi Cuenta</span>
              </div>
            </div>
          </CDropdownHeader>

          <div className="dropdown-divider-custom mb-2"></div>

          <CDropdownItem
            href="#/perfil"
            className="dropdown-item-premium d-flex align-items-center py-2 px-3 rounded-3 mb-1"
          >
            <CIcon icon={cilUser} className="me-3 icon-accent" />
            <span className="fw-semibold">Perfil</span>
          </CDropdownItem>

          {/* Menú de alternancia de roles cuando el usuario tiene múltiples roles */}
          {hasMultipleRoles && (
            <>
              <div className="dropdown-divider-custom my-2"></div>
              <div className="px-3 py-1">
                <span className="d-block fw-bold ls-1 text-uppercase text-muted" style={{ fontSize: '0.65rem' }}>
                  Cambiar Rol de Sesión
                </span>
              </div>
              {userRoles.map((roleKey) => {
                const meta = roleMeta[roleKey] || { label: roleKey, icon: cilUser, route: '#/dashboard' }
                const isActive = (currentActiveRole === roleKey) || (roleKey === 'admin' && currentActiveRole === 'superadmin')
                return (
                  <CDropdownItem
                    key={roleKey}
                    component="button"
                    type="button"
                    onClick={() => handleSelectRole(roleKey)}
                    className="dropdown-item-premium d-flex align-items-center justify-content-between py-2 px-3 rounded-3 mb-1 role-switch-item"
                    style={{
                      cursor: isActive ? 'default' : 'pointer',
                      background: isActive ? 'rgba(242, 140, 15, 0.12)' : 'transparent',
                      border: isActive ? '1px solid rgba(242, 140, 15, 0.3)' : '1px solid transparent'
                    }}
                  >
                    <div className="d-flex align-items-center">
                      <CIcon
                        icon={meta.icon}
                        className={`me-3 ${isActive ? 'text-warning' : 'text-muted'}`}
                      />
                      <span className={`fw-semibold ${isActive ? 'text-warning' : ''}`} style={{ fontSize: '0.85rem' }}>
                        {meta.label}
                      </span>
                    </div>
                    {isActive ? (
                      <span className="badge bg-warning text-dark px-2 py-1 rounded-pill" style={{ fontSize: '0.65rem' }}>
                        Activo
                      </span>
                    ) : (
                      <span className="small text-muted" style={{ fontSize: '0.7rem' }}>
                        Cambiar
                      </span>
                    )}
                  </CDropdownItem>
                )
              })}
            </>
          )}

          <CDropdownItem
            onClick={handleLogout}
            className="dropdown-item-premium logout-item d-flex align-items-center py-2 px-3 rounded-3 mt-1"
          >
            <CIcon icon={cilAccountLogout} className="me-3 icon-danger" />
            <span className="fw-semibold">Cerrar Sesión</span>
          </CDropdownItem>
        </CDropdownMenu>
      </CDropdown>
    </>
  )
}

export default AppHeaderDropdown