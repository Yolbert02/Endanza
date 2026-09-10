// helpFetch.js - Versión corregida
export const helpFetch = () => {
  // En producción usa la API real, en desarrollo usa localhost
  const URL = import.meta.env.VITE_API_URL || 
    (window.location.hostname === 'localhost' ? 'http://localhost:3001' : 'https://api.endanzatachira.org.ve')

  const customFetch = async (endpoint, options = {}) => {
    options.method = options.method || 'GET'

    const defaultHeaders = {
      'Content-Type': 'application/json',
    }

    const token = localStorage.getItem('accessToken')
    if (token) {
      defaultHeaders.Authorization = `Bearer ${token}`
    }

    options.headers = {
      ...defaultHeaders,
      ...(options.headers || {}),
    }

    if (options.body) {
      options.body = JSON.stringify(options.body)
    }

    console.log(`🌐 ${options.method} ${URL}${endpoint}`)

    try {
      const response = await fetch(`${URL}${endpoint}`, options)
      
      console.log(`📡 Response status: ${response.status} ${response.statusText}`)
      
      const text = await response.text()
      
      if (!text || text.trim() === '') {
        console.log('✅ Response vacía')
        return { ok: response.ok, _ok: response.ok, _status: response.status }
      }
      
      let data
      try {
        data = JSON.parse(text)
        console.log(`✅ JSON Response:`, data)
      } catch (jsonError) {
        console.log(`⚠️ Response no es JSON:`, text)
        data = { text, ok: response.ok, _ok: response.ok, _status: response.status }
      }
      
      if (!data._ok) data._ok = response.ok
      if (!data._status) data._status = response.status
      if (!data._statusText) data._statusText = response.statusText
      
      return data
      
    } catch (error) {
      console.error(`❌ Network error:`, error.message)
      return {
        ok: false,
        message: 'Error de conexión con el servidor',
        _ok: false,
        _status: 0,
        _statusText: 'Network Error'
      }
    }
  }

  const get = (endpoint, options = {}) => customFetch(endpoint, { ...options, method: 'GET' })
  const post = (endpoint, body, options = {}) => customFetch(endpoint, { ...options, method: 'POST', body })
  const put = (endpoint, body, options = {}) => customFetch(endpoint, { ...options, method: 'PUT', body })
  const del = (endpoint, options = {}) => {
    // Si endpoint ya incluye el ID, no agregar más
    return customFetch(endpoint, { ...options, method: 'DELETE' })
  }

  const checkConnection = async () => {
    try {
      const response = await fetch(`${URL}/api/health`)
      if (response.ok) {
        const data = await response.json()
        console.log('🔌 Backend connected:', data.message)
        return true
      }
      return false
    } catch (error) {
      console.error('🔌 Connection check failed:', error)
      return false
    }
  }

  return { 
    get, 
    post, 
    put, 
    delete: del,  // ← Exportar como 'delete'
    customFetch, 
    checkConnection, 
    URL 
  }
}