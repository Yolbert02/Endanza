// src/services/profileService.js
import { userAPI } from '../api/user.api.js'

export const profileService = {
  // Obtener perfil del usuario
  async getProfile() {
    try {
      const response = await userAPI.getProfile()
      
      if (response._ok === false) {
        throw new Error(response.message || 'Error al obtener perfil')
      }
      
      // Mapear datos del backend al formato del frontend
      const userData = response.user
      
      return {
        success: true,
        user: {
          id: userData.id,
          nombre: userData.nombre || '',
          apellido: userData.apellido || '',
          email: userData.email || '',
          telefono: userData.telefono || '',
          cedula: userData.cedula || '',
          fechaNacimiento: userData.fecha_nacimiento || '',
          genero: userData.genero || '',
          foto_usuario: userData.foto_usuario || null,
          Id_rol: userData.Id_rol,
          rol: userData.tipo_rol || 'Usuario',
          is_active: userData.is_active,
          ultimoAcceso: userData.last_login || new Date().toLocaleString(),
          created_at: userData.created_at,
          direccion: {
            Id_direccion: userData.Id_direccion,
            nombre_direccion: userData.nombre_direccion,
            ciudad: userData.nombre_ciudad,
            parroquia: userData.nombre_parroquia,
            municipio: userData.nombre_municipio,
            estado: userData.nombre_estado,
            pais: userData.nombre_pais
          }
        }
      }
    } catch (error) {
      console.error('❌ Error en getProfile:', error)
      return {
        success: false,
        message: error.message || 'Error al obtener perfil'
      }
    }
  },

  // Actualizar perfil
  async updateProfile(profileData) {
    try {
      console.log('📤 Actualizando perfil con datos:', profileData)
      
      // Mapear datos del frontend al formato del backend
      const backendData = {
        nombre: profileData.nombre,
        apellido: profileData.apellido,
        email: profileData.email,
        telefono: profileData.telefono,
        cedula: profileData.cedula,
        fecha_nacimiento: profileData.fechaNacimiento || null,
        genero: profileData.genero || null,
        direccion: profileData.direccion || null
      }

      const response = await userAPI.updateProfile(backendData)
      
      console.log('📥 Respuesta de actualización:', response)

      if (response._ok === false) {
        throw new Error(response.msg || 'Error al actualizar perfil')
      }

      return {
        success: true,
        message: response.msg || 'Perfil actualizado exitosamente',
        user: response.user
      }
    } catch (error) {
      console.error('❌ Error en updateProfile:', error)
      
      // Manejar errores específicos
      let errorMessage = error.message || 'Error al actualizar perfil'
      
      if (errorMessage.includes('Email already exists')) {
        errorMessage = 'El correo electrónico ya está registrado'
      } else if (errorMessage.includes('Cedula already exists')) {
        errorMessage = 'La cédula ya está registrada'
      }
      
      return {
        success: false,
        message: errorMessage
      }
    }
  },

  // Cambiar contraseña
  async changePassword(passwordData) {
    try {
      console.log('🔐 Enviando solicitud de cambio de contraseña...')
      
      // Validar que los datos existan
      if (!passwordData.currentPassword || !passwordData.newPassword) {
        throw new Error('La contraseña actual y la nueva son requeridas')
      }

      // Validar longitud mínima (6 caracteres como en el backend)
      if (passwordData.newPassword.length < 6) {
        throw new Error('La nueva contraseña debe tener al menos 6 caracteres')
      }

      const response = await userAPI.changePassword({
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword
      })

      console.log('📥 Respuesta de cambio de contraseña:', response)

      if (response._ok === false) {
        throw new Error(response.msg || 'Error al cambiar contraseña')
      }

      return {
        success: true,
        message: response.msg || 'Contraseña actualizada exitosamente'
      }
    } catch (error) {
      console.error('❌ Error en changePassword:', error)
      
      // Manejar errores específicos del backend
      let errorMessage = error.message || 'Error al cambiar contraseña'
      
      if (errorMessage.includes('Current password is incorrect')) {
        errorMessage = 'La contraseña actual es incorrecta'
      } else if (errorMessage.includes('New password must be at least 6 characters')) {
        errorMessage = 'La nueva contraseña debe tener al menos 6 caracteres'
      } else if (errorMessage.includes('User not found')) {
        errorMessage = 'Usuario no encontrado'
      }
      
      return {
        success: false,
        message: errorMessage
      }
    }
  },

  // Cambiar contraseña con seguridad (pregunta de seguridad)
  async changePasswordWithSecurity(data) {
    try {
      console.log('🔐 Enviando solicitud de cambio de contraseña con seguridad...')
      
      // Validar datos requeridos
      if (!data.username || !data.securityAnswer || !data.newPassword) {
        throw new Error('Usuario, respuesta de seguridad y nueva contraseña son requeridos')
      }

      // Validar longitud mínima
      if (data.newPassword.length < 6) {
        throw new Error('La nueva contraseña debe tener al menos 6 caracteres')
      }

      const response = await userAPI.changePasswordWithSecurity({
        username: data.username,
        respuesta_de_seguridad: data.securityAnswer,
        newPassword: data.newPassword
      })

      console.log('📥 Respuesta de cambio de contraseña con seguridad:', response)

      if (response._ok === false) {
        throw new Error(response.msg || 'Error al cambiar contraseña')
      }

      return {
        success: true,
        message: response.msg || 'Contraseña actualizada exitosamente'
      }
    } catch (error) {
      console.error('❌ Error en changePasswordWithSecurity:', error)
      
      // Manejar errores específicos
      let errorMessage = error.message || 'Error al cambiar contraseña'
      
      if (errorMessage.includes('Invalid username or security answer')) {
        errorMessage = 'Usuario o respuesta de seguridad incorrectos'
      } else if (errorMessage.includes('New password must be at least 6 characters')) {
        errorMessage = 'La nueva contraseña debe tener al menos 6 caracteres'
      }
      
      return {
        success: false,
        message: errorMessage
      }
    }
  },

  // Método de utilidad para refrescar el perfil después de actualizaciones
  async refreshProfile() {
    try {
      const response = await this.getProfile()
      if (response.success) {
        // Actualizar localStorage con datos frescos
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}')
        const updatedUser = { ...currentUser, ...response.user }
        localStorage.setItem('user', JSON.stringify(updatedUser))
      }
      return response
    } catch (error) {
      console.error('❌ Error refrescando perfil:', error)
      return {
        success: false,
        message: error.message || 'Error al refrescar perfil'
      }
    }
  }
}

export default profileService