// src/components/PermissionGuard.js
import React from 'react'
import { useNavigate } from 'react-router-dom'
import useUserRole from '../Hooks/useUserRole'
import { CAlert, CButton } from '@coreui/react'

const PermissionGuard = ({ 
  children, 
  requiredRole,
  requiredAnyOf = [],
  showForbidden = true,
  redirectTo = '/unauthorized'
}) => {
  const { userRole, isLoading, hasRole, hasAnyRole } = useUserRole()
  const navigate = useNavigate()
  
  if (isLoading) {
    return (
      <div className="text-center p-5">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Verificando permisos...</span>
        </div>
      </div>
    )
  }
  
  let hasPermission = false
  
  if (requiredRole) {
    hasPermission = hasRole(requiredRole)
  } else if (requiredAnyOf.length > 0) {
    hasPermission = hasAnyRole(requiredAnyOf)
  }
  
  if (!hasPermission) {
    if (!userRole) {
      navigate('/login', { replace: true })
    } else if (userRole === 'admin' || userRole === 'superadmin' || userRole === 'secretaria') {
      navigate('/dashboard', { replace: true })
    } else if (userRole === 'docente') {
      navigate('/docente/inicio', { replace: true })
    } else if (userRole === 'representante') {
      navigate('/inicio', { replace: true })
    } else {
      navigate('/login', { replace: true })
    }
    return null
  }
  
  return children
}

export default PermissionGuard