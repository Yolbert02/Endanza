// src/Hooks/useUserRole.js - VERSIÓN QUE FUNCIONABA
import { useState, useEffect, useCallback } from 'react'
import { userAPI } from '../api/user.api.js'

const useUserRole = () => {
  const getCachedUser = () => {
    try {
      const cached = localStorage.getItem('user')
      return cached ? JSON.parse(cached) : null
    } catch {
      return null
    }
  }

  const cached = getCachedUser()
  const [userRole, setUserRole] = useState(cached?.rol || null)
  const [userId, setUserId] = useState(cached?.id || null)
  const [userData, setUserData] = useState(cached)
  const [isLoading, setIsLoading] = useState(!cached && !!localStorage.getItem('accessToken'))
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
      const token = localStorage.getItem('accessToken')
      if (!token) return null

      console.log('🔍 useUserRole - Obteniendo datos del usuario desde backend...')

      const response = await userAPI.getProfile()

      if (response._ok === false) {
        if (response._status === 401) {
          localStorage.removeItem('accessToken')
          localStorage.removeItem('user')
          localStorage.removeItem('refreshToken')
          return null
        }
        throw new Error(`Error del servidor: ${response._status}`)
      }

      if (!response.user) throw new Error('Respuesta inválida del servidor')

      const roleId = response.user.Id_rol
      let roleName = roleMap[roleId] || 'estudiante'

      // Identificar superadmin: todos los admins (Id_rol=1) son superadmin en este sistema
      // También se identifica por usuario o correo específico
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

      localStorage.setItem('user', JSON.stringify(completeUserData))

      return completeUserData

    } catch (err) {
      console.error('❌ useUserRole - Error:', err)
      return null
    }
  }, [])

  const getUserData = useCallback(async (forceRefresh = false) => {
    try {
      if (localStorage.getItem('accessToken')) {
        console.log('🔄 useUserRole - Forzando obtención de datos frescos')
        return await fetchUserFromBackend()
      }

      const cachedUser = localStorage.getItem('user')
      if (cachedUser) {
        const parsedUser = JSON.parse(cachedUser)
        console.log('📦 useUserRole - Usando datos cacheados')
        return parsedUser
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
        if (isMounted) setIsLoading(true)

        const userData = await getUserData(true)

        if (isMounted && userData) {
          setUserData(userData)
          setUserRole(userData.rol)
          setUserId(userData.id)

          console.log('✅ useUserRole - Datos cargados exitosamente:', {
            id: userData.id,
            rol: userData.rol,
            tipo_rol: userData.tipo_rol
          })
        }
      } catch (err) {
        console.error('❌ Error:', err)
      } finally {
        if (isMounted) setIsLoading(false)
      }
    }

    if (localStorage.getItem('accessToken')) {
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