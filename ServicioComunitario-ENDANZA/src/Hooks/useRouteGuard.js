import { useEffect } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import useUserRole from './useUserRole'

// Configuración de permisos por ruta
const routePermissions = {
  '/dashboard': ['admin', 'secretaria'],
  '/students': ['admin', 'secretaria'],
  '/students/:id': ['admin', 'secretaria'],
  '/inscripcion': ['representante'],
  '/aulas': ['admin', 'secretaria'],
  '/notas': ['admin', 'secretaria'],
  '/boletin': ['admin', 'secretaria'],
  '/horario': ['admin', 'secretaria'],
  '/docente/inicio': ['docente'],
  '/docente/horario': ['docente'],
  '/inicio': ['representante'],
  '/perfilRepresentanteEstudiante/:id': ['representante'],
  '/boletin-estudiante/:id': ['representante'], // 👈 ACTUALIZADO CON :id
  '/horario-estudiante/:id': ['representante'], // 👈 ACTUALIZADO CON :id
  '/profile': ['representante', 'admin', 'docente', 'secretaria'],
  '/perfil': ['admin', 'docente', 'representante', 'secretaria'],
}

const useRouteGuard = () => {
  const navigate = useNavigate()
  const location = useLocation()
  const { userRole, isLoading } = useUserRole()

  useEffect(() => {
    // 👇 LOG PARA VER SI EL EFECTO SE EJECUTA
    console.log(`🔄 RouteGuard useEffect EJECUTÁNDOSE para: ${location.pathname}`)
    
    if (isLoading) {
      console.log('⏳ RouteGuard: Esperando carga del rol...')
      return
    }

    const token = localStorage.getItem('accessToken')
    if (!token) {
      console.warn('🚫 RouteGuard: No hay token, redirigiendo a login')
      navigate('/login', { replace: true })
      return
    }

    if (!userRole) {
      console.warn('⚠️ RouteGuard: userRole es null pero hay token.')
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