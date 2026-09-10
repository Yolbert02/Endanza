// src/Hooks/useUserRole.js - VERSIÓN CON SESIÓN POR PESTAÑA
import { useState, useEffect, useCallback } from 'react'
import { userAPI } from '../api/user.api.js'
import { getStoredToken, getStoredUser, clearStoredAuth, setStoredAuth } from '../utils/authStorage.js'

const useUserRole = () => {
  const cached = getStoredUser()
  const [userRole, setUserRole] = useState(cached?.rol || null)
  const [userId, setUserId] = useState(cached?.id || null)
  const [userData, setUserData] = useState(cached)
  const [isLoading, setIsLoading] = useState(!cached && !!getStoredToken())
  const [error, setError] = useState(null)

  const roleMap = {
    1: 'admin',
    2: 'docente',
    3: 'estudiante',
    4: 'representante',
    5: 'secretaria'
  }

  const fetchUserFromBackend = useCallback(async () => {
    try {
      const token = getStoredToken()
      if (!token) return null

      console.log('🔍 useUserRole - Obteniendo datos del usuario desde backend...')

      const response = await userAPI.getProfile()

      if (response._ok === false) {
        if (response._status === 401) {
          clearStoredAuth()
          if (window.location.hash !== '#/login' && !window.location.hash.startsWith('#/login')) {
            window.location.hash = '#/login'
          }
          return null
        }
        throw new Error(`Error del servidor: ${response._status}`)
      }

      if (!response.user) throw new Error('Respuesta inválida del servidor')

      const roleId = response.user.Id_rol
      let roleName = roleMap[roleId] || 'estudiante'

      // Identificar superadmin: todos los admins (Id_rol=1) son superadmin en este sistema
      if (roleId === 1 || response.user.username === 'superroot' || response.user.correo === 'superroot@gmail.com' || response.user.email === 'superroot@gmail.com') {
        roleName = 'superadmin'
      }

      console.log(`🔄 useUserRole - Usuario ID: ${roleId} → Rol: ${roleName}`)

      const completeUserData = {
        ...response.user,
        rol: roleName,
        Id_rol: roleId,
        esAdmin: roleName === 'admin' || roleName === 'superadmin',
        esSuperadministrador: roleName === 'superadmin',
        esSecretaria: roleName === 'secretaria',
        esDocente: roleName === 'docente',
        esEstudiante: roleName === 'estudiante',
        esRepresentante: roleName === 'representante'
      }

      // Actualizar usuario en sessionStorage
      const currentToken = getStoredToken()
      setStoredAuth(currentToken, null, completeUserData)

      return completeUserData

    } catch (err) {
      console.error('❌ useUserRole - Error:', err)
      return null
    }
  }, [])

  const getUserData = useCallback(async (forceRefresh = false) => {
    try {
      if (getStoredToken()) {
        console.log('🔄 useUserRole - Forzando obtención de datos frescos')
        return await fetchUserFromBackend()
      }

      const cachedUser = getStoredUser()
      if (cachedUser) {
        console.log('📦 useUserRole - Usando datos cacheados')
        return cachedUser
      }

      return null
    } catch (err) {
      console.error('❌ useUserRole - Error en getUserData:', err)
      throw err
    }
  }, [fetchUserFromBackend])

  useEffect(() => {
    let isMounted = true

    const loadUserData = async () => {
      try {
        if (isMounted && !cached) setIsLoading(true)

        const freshData = await getUserData(true)

        if (isMounted && freshData) {
          setUserData(freshData)
          setUserRole(freshData.rol)
          setUserId(freshData.id)

          console.log('✅ useUserRole - Datos cargados exitosamente:', {
            id: freshData.id,
            rol: freshData.rol,
            tipo_rol: freshData.tipo_rol
          })
        }
      } catch (err) {
        console.error('❌ Error:', err)
      } finally {
        if (isMounted) setIsLoading(false)
      }
    }

    if (getStoredToken()) {
      loadUserData()
    } else {
      setIsLoading(false)
    }

    return () => { isMounted = false }
  }, [getUserData])

  return {
    userRole,
    userId,
    userData,
    isLoading,
    error,
    isAdmin: userRole === 'admin' || userRole === 'superadmin',
    isSuperadministrador: userRole === 'superadmin' || userData?.username === 'superroot' || userData?.correo === 'superroot@gmail.com' || userData?.email === 'superroot@gmail.com',
    isAdministrador: userRole === 'admin' || userRole === 'superadmin',
    isSecretaria: userRole === 'secretaria',
    isDocente: userRole === 'docente',
    isEstudiante: userRole === 'estudiante',
    isRepresentante: userRole === 'representante',
    isAuthenticated: !!userRole && !!userId,
    roleId: userData?.Id_rol || null,
    roleName: userData?.tipo_rol || null,
    refreshUserData: getUserData
  }
}

export default useUserRole