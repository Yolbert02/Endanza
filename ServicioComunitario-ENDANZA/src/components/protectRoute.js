// src/components/ProtectedRoute.js
import React from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { CSpinner } from '@coreui/react'
import { getStoredToken, getStoredUser, clearStoredAuth } from '../utils/authStorage'

// Mapa de rutas permitidas por rol (incluye superadmin y secretaria)
const routePermissions = {
  // Rutas de administración
  '/dashboard': ['admin', 'superadmin', 'secretaria'],
  '/students': ['admin', 'superadmin', 'secretaria'],
  '/students/*': ['admin', 'superadmin', 'secretaria'],
  '/inscripcion': ['representante'],
  '/aulas': ['admin', 'superadmin', 'secretaria'],
  '/notas': ['admin', 'superadmin', 'docente', 'secretaria'],
  '/boletin': ['admin', 'superadmin', 'secretaria'],
  '/horario': ['admin', 'superadmin', 'secretaria'],

  // Rutas de docente
  '/docente/*': ['docente'],

  // Rutas de representante
  '/inicio': ['representante'],
  '/inicio-boletines': ['representante'],
  '/inicio-horarios': ['representante'],
  '/perfilRepresentanteEstudiante/*': ['representante'],
  '/boletin-estudiante/*': ['representante'],
  '/horario-estudiante/*': ['representante'],

  // Rutas compartidas
  '/profile': ['representante', 'admin', 'superadmin', 'docente', 'secretaria'],
  '/perfil': ['admin', 'superadmin', 'docente', 'representante', 'secretaria'],
}

const ProtectedRoute = ({
  children,
  allowedRoles = []
}) => {
  const location = useLocation()

  const [isLoading, setIsLoading] = React.useState(true)
  const [userRole, setUserRole] = React.useState('')

  React.useEffect(() => {
    const loadUserData = () => {
      try {
        const user = getStoredUser() || {}
        setUserRole(user.rol || '')
      } catch (error) {
        console.error('Error loading user data:', error)
      } finally {
        setIsLoading(false)
      }
    }
    loadUserData()
  }, [])

  if (isLoading) {
    return (
      <div className="d-flex justify-content-center align-items-center min-vh-100">
        <CSpinner color="primary" variant="grow" />
      </div>
    )
  }

  // Verificar autenticación
  const token = getStoredToken()
  const isAuthenticated = !!token

  if (!isAuthenticated) {
    clearStoredAuth()
    return <Navigate to="/login" replace />
  }

  // Determinar los roles permitidos para esta ruta
  let allowedRolesForRoute = allowedRoles

  if (allowedRolesForRoute.length === 0) {
    const path = location.pathname

    allowedRolesForRoute = routePermissions[path] || []

    if (allowedRolesForRoute.length === 0) {
      if (path.startsWith('/students/')) {
        allowedRolesForRoute = routePermissions['/students/*'] || []
      } else if (path.startsWith('/perfilRepresentanteEstudiante/')) {
        allowedRolesForRoute = routePermissions['/perfilRepresentanteEstudiante/*'] || []
      } else if (path.startsWith('/boletin-estudiante/')) {
        allowedRolesForRoute = routePermissions['/boletin-estudiante/*'] || []
      } else if (path.startsWith('/horario-estudiante/')) {
        allowedRolesForRoute = routePermissions['/horario-estudiante/*'] || []
      } else if (path.startsWith('/docente/')) {
        allowedRolesForRoute = routePermissions['/docente/*'] || []
      }
    }
  }

  // Verificar permisos: si no tiene permisos o el rol es inválido, redirigir directo sin carteles
  if (allowedRolesForRoute.length > 0 && !allowedRolesForRoute.includes(userRole)) {
    console.warn(`🚨 Acceso no autorizado a ${location.pathname} para rol "${userRole}". Redirigiendo a pantalla adecuada...`)
    
    // Redirigir según el rol que tenga, o a login si no tiene rol válido
    if (userRole === 'admin' || userRole === 'superadmin' || userRole === 'secretaria') {
      return <Navigate to="/dashboard" replace />
    } else if (userRole === 'docente') {
      return <Navigate to="/docente/inicio" replace />
    } else if (userRole === 'representante') {
      return <Navigate to="/inicio" replace />
    } else {
      clearStoredAuth()
      return <Navigate to="/login" replace />
    }
  }

  return children
}

export default ProtectedRoute