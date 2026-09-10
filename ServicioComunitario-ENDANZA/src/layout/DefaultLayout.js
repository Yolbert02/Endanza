// src/layout/DefaultLayout.js
import React, { useEffect, useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { AppContent, AppSidebar, AppFooter, AppHeader } from '../components/index'
import { getFilteredNav } from '../_nav'
import useUserRole from '../Hooks/useUserRole'
import { CSpinner } from '@coreui/react'

const DefaultLayout = () => {
  const navigate = useNavigate()
  const location = useLocation()

  const {
    userRole,
    userData,
    isLoading,
    error,
    refreshUserData,
    isSuperadministrador,
    isAdministrador,
    isDocente,
    isRepresentante
  } = useUserRole()

  const [filteredNavigation, setFilteredNavigation] = useState([])

  // Si el usuario no tiene cédula válida, redirigirlo a su perfil obligatoriamente
  useEffect(() => {
    if (userData && !isLoading) {
      const currentCedula = userData.cedula
      const needsCedula =
        userData.must_change_cedula === true ||
        !currentCedula ||
        String(currentCedula || '').trim() === '' ||
        String(currentCedula || '').trim().toUpperCase().startsWith('V-1000')

      if (needsCedula && location.pathname !== '/perfil' && location.pathname !== '/profile') {
        console.log('⚠️ Usuario sin cédula -> Redirigiendo a /perfil')
        navigate('/perfil', { replace: true })
      }
    }
  }, [userData, isLoading, location.pathname, navigate])

  // Filtrar navegación cuando cambia el rol
  useEffect(() => {
    if (userRole) {
      console.log('🎯 DefaultLayout - Filtrando navegación para rol:', userRole)
      const filteredNav = getFilteredNav(userRole)
      console.log('📋 DefaultLayout - Navegación filtrada:', filteredNav)
      setFilteredNavigation(filteredNav)
    }
  }, [userRole])

  // Mostrar errores
  useEffect(() => {
    if (error) {
      console.error('❌ DefaultLayout - Error:', error?.message || error)
    }
  }, [error])

  if (isLoading) {
    return (
      <div className="d-flex flex-column justify-content-center align-items-center min-vh-100 bg-light">
        <CSpinner color="primary" variant="grow" size="lg" />
        <p className="mt-3 text-muted">Cargando permisos de usuario...</p>
      </div>
    )
  }

  // Si no hay datos de usuario ni permisos, redirigir directamente al login sin mostrar carteles
  if (!userData && !isLoading) {
    navigate('/login', { replace: true })
    return null
  }

  return (
    <div>
      {/* Pasa la navegación filtrada al AppSidebar */}
      <AppSidebar navigation={filteredNavigation} />
      <div className="wrapper d-flex flex-column min-vh-100">
        <AppHeader
          onRoleRefresh={refreshUserData}
          userData={userData}
        />
        <div className="body flex-grow-1">
          {/* Pasa información del usuario al AppContent */}
          <AppContent
            userRole={userRole}
            userId={userData?.id}
            isSuperadministrador={isSuperadministrador}
            isAdministrador={isAdministrador}
            isDocente={isDocente}
            isRepresentante={isRepresentante}
          />


        </div>
        <AppFooter />
      </div>
    </div>
  )
}

export default DefaultLayout