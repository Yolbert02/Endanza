// src/utils/authStorage.js
// Manejo centralizado de autenticación con caducidad al cerrar la pestaña (sessionStorage)

export const getStoredToken = () => {
  return sessionStorage.getItem('accessToken') || localStorage.getItem('accessToken')
}

export const getStoredRefreshToken = () => {
  return sessionStorage.getItem('refreshToken') || localStorage.getItem('refreshToken')
}

export const getStoredUser = () => {
  try {
    const raw = sessionStorage.getItem('user') || localStorage.getItem('user')
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export const setStoredAuth = (accessToken, refreshToken, user) => {
  // Guardar en sessionStorage para que al cerrar la pestaña se destruya la sesión
  if (accessToken) sessionStorage.setItem('accessToken', accessToken)
  if (refreshToken) sessionStorage.setItem('refreshToken', refreshToken)
  if (user) sessionStorage.setItem('user', typeof user === 'string' ? user : JSON.stringify(user))

  // Limpiar localStorage para asegurar que no persista entre pestañas o navegadores cerrados
  localStorage.removeItem('accessToken')
  localStorage.removeItem('refreshToken')
  localStorage.removeItem('user')
}

export const clearStoredAuth = () => {
  sessionStorage.removeItem('accessToken')
  sessionStorage.removeItem('refreshToken')
  sessionStorage.removeItem('user')
  sessionStorage.removeItem('redirectAfterLogin')
  localStorage.removeItem('accessToken')
  localStorage.removeItem('refreshToken')
  localStorage.removeItem('user')
  localStorage.removeItem('redirectAfterLogin')
}

export const isUserAuthenticated = () => {
  return !!getStoredToken()
}

export default {
  getToken: getStoredToken,
  getRefreshToken: getStoredRefreshToken,
  getUser: getStoredUser,
  setAuth: setStoredAuth,
  clearAuth: clearStoredAuth,
  isAuthenticated: isUserAuthenticated
}
