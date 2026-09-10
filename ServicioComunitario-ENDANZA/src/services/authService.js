// src/services/authService.js - VERSIÓN CORREGIDA
import { userAPI } from '../api/user.api.js'
import { setStoredAuth, clearStoredAuth, getStoredToken, getStoredRefreshToken, getStoredUser, isUserAuthenticated } from '../utils/authStorage.js'

export const authService = {
  async login(email, password) {
    try {
      console.log('🔐 [1] Iniciando login para:', email)
      
      // Limpiar sesión anterior
      clearStoredAuth()
      
      const data = await userAPI.login({ email, password })
      console.log('📥 [2] Respuesta de API:', data)

      if (data.accessToken && data.user) {
        console.log('✅ [3] Token válido detectado, guardando...')
        
        // ✅ MAPEO CORRECTO DE ROLES USANDO Id_rol
        const roleMap = {
          1: 'admin',
          2: 'docente',
          3: 'estudiante',
          4: 'representante',
          5: 'secretaria'
        }
        
        // ✅ Obtener el rol del Id_rol
        const roleId = data.user.Id_rol
        let roleName = roleMap[roleId] || 'estudiante'
        if (roleId === 1 || data.user.username === 'superroot' || data.user.email === 'superroot@gmail.com') {
          roleName = 'superadmin'
        }
        
        console.log(`🔄 Mapeando rol: Id_rol ${roleId} → ${roleName}`)
        
        // ✅ Crear objeto de usuario con el rol CORRECTO
        const userWithRole = {
          ...data.user,
          rol: roleName,
          esAdmin: roleName === 'admin' || roleName === 'superadmin',
          esSuperadministrador: roleName === 'superadmin',
          esDocente: roleName === 'docente',
          esEstudiante: roleName === 'estudiante',
          esRepresentante: roleName === 'representante',
          esSecretaria: roleName === 'secretaria'
        }
        
        // Guardar en sessionStorage (se destruye al cerrar la pestaña)
        setStoredAuth(data.accessToken, data.refreshToken, userWithRole)
        
        return { 
          success: true, 
          token: data.accessToken,
          refreshToken: data.refreshToken,
          user: userWithRole,
          message: data.message 
        }
      }
      
      console.warn('⚠️ [4] No hay token válido en respuesta')
      throw new Error(data.msg || data.message || 'Error en la autenticación')
      
    } catch (error) {
      console.error('❌ [5] Error:', error)
      
      return { 
        success: false, 
        message: error.data?.msg || error.data?.message || error.message || 'Error de conexión',
        status: error.status
      }
    }
  },

  async getProfile() {
    try {
      const data = await userAPI.getProfile()
      return { 
        success: true, 
        user: data.user 
      }
    } catch (error) {
      console.error('❌ Error obteniendo perfil:', error)
      return { 
        success: false, 
        message: error.message 
      }
    }
  },

  async logout() {
    try {
      await userAPI.logout()
    } catch (error) {
      console.error('❌ Error en logout:', error)
    } finally {
      clearStoredAuth()
    }
    return { success: true }
  },

  debugAuthState() {
    return {
      hasAccessToken: isUserAuthenticated(),
      accessTokenValue: getStoredToken()?.substring(0, 20) + '...',
      hasRefreshToken: !!getStoredRefreshToken(),
      hasUser: !!getStoredUser(),
      userValue: getStoredUser(),
      isAuthenticated: isUserAuthenticated()
    }
  }
}

export default authService