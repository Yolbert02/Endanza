import { useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import useUserRole from './useUserRole'
import { getStoredToken, clearStoredAuth } from '../utils/authStorage'

// Configuración de permisos por ruta
const routePermissions = {
  '/dashboard': ['admin', 'superadmin', 'secretaria'],
  '/students': ['admin', 'superadmin', 'secretaria'],
  '/students/:id': ['admin', 'superadmin', 'secretaria'],
  '/inscripcion': ['representante'],
  '/aulas': ['admin', 'superadmin', 'secretaria'],
  '/notas': ['admin', 'superadmin', 'secretaria'],
  '/boletin': ['admin', 'superadmin', 'secretaria'],
  '/horario': ['admin', 'superadmin', 'secretaria'],
  '/docente/inicio': ['docente'],
  '/docente/horario': ['docente'],
  '/inicio': ['representante'],
  '/perfilRepresentanteEstudiante/:id': ['representante'],
  '/boletin-estudiante/:id': ['representante'],
  '/horario-estudiante/:id': ['representante'],
  '/profile': ['representante', 'admin', 'superadmin', 'docente', 'secretaria'],
  '/perfil': ['admin', 'superadmin', 'docente', 'representante', 'secretaria'],
}

const useRouteGuard = () => {
  const navigate = useNavigate()
  const location = useLocation()
  const { userRole, isLoading } = useUserRole()

  useEffect(() => {
    if (isLoading) {
      return
    }

    const token = getStoredToken()
    if (!token) {
      clearStoredAuth()
      navigate('/login', { replace: true })
      return
    }

    if (!userRole) {
      clearStoredAuth()
      navigate('/login', { replace: true })
      return
    }
    
    const path = location.pathname
    console.log(`\n🔍 RouteGuard - Verificando acceso a: ${path}`)
    console.log(`👤 Rol del usuario: ${userRole}`)
    
    // Buscar coincidencia exacta
    let allowedRoles = routePermissions[path]
    
    // Si no hay coincidencia exacta, buscar rutas con parámetros
    if (!allowedRoles) {
      console.log('🔎 Buscando rutas con parámetros...')
      
      // Rutas de admin con parámetros
      if (path.startsWith('/students/') && path.split('/').length === 3) {
        allowedRoles = routePermissions['/students/:id']
        console.log(`🎯 Ruta admin detectada: /students/:id → ${path}`)
      }
      // Rutas de representante con parámetros
      else if (path.startsWith('/perfilRepresentanteEstudiante/') && path.split('/').length === 3) {
        allowedRoles = routePermissions['/perfilRepresentanteEstudiante/:id']
        console.log(`🎯 Ruta representante DETECTADA: /perfilRepresentanteEstudiante/:id → ${path}`)
        console.log(`📋 Roles permitidos:`, allowedRoles)
      }
      else if (path.startsWith('/boletin-estudiante/') && path.split('/').length === 3) {
        allowedRoles = routePermissions['/boletin-estudiante/:id']
        console.log(`🎯 Ruta boletín DETECTADA: /boletin-estudiante/:id → ${path}`)
        console.log(`📋 Roles permitidos:`, allowedRoles)
      }
      else if (path.startsWith('/horario-estudiante/') && path.split('/').length === 3) {
        allowedRoles = routePermissions['/horario-estudiante/:id']
        console.log(`🎯 Ruta horario DETECTADA: /horario-estudiante/:id → ${path}`)
        console.log(`📋 Roles permitidos:`, allowedRoles)
      }
    }
    
    console.log(`🔐 Resultado - allowedRoles:`, allowedRoles)
    
    // Si la ruta no tiene restricciones, permitir acceso
    if (!allowedRoles) {
      console.log(`✅ Ruta sin restricciones: ${path}`)
      return
    }
    
    // Verificar si el usuario tiene permiso
    if (!allowedRoles.includes(userRole)) {
      console.warn(`🚨 ACCESO DENEGADO a ${path} para rol ${userRole}`)
      
      switch(userRole) {
        case 'admin':
        case 'secretaria':
          navigate('/dashboard', { replace: true })
          break
        case 'docente':
          navigate('/docente/inicio', { replace: true })
          break
        case 'representante':
          console.log('🔄 Redirigiendo a /inicio')
          navigate('/inicio', { replace: true })
          break
        default:
          navigate('/login', { replace: true })
      }
    } else {
      console.log(`✅ ACCESO PERMITIDO a ${path} para rol ${userRole}`)
    }
  }, [location.pathname, userRole, isLoading, navigate])
}

export default useRouteGuard