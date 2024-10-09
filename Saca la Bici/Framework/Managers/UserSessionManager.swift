//
//  UserSessionManager.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 27/09/24.
//

import Foundation
import FirebaseAuth
import Combine

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    
    @Published var permisos: [String] = []
    @Published var currentUserID: String?
    
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.currentUserID = user?.uid
        }
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func updatePermisos(newPermisos: [String]) {
        DispatchQueue.main.async {
            self.permisos = newPermisos
        }
    }

    func tienePermiso(_ permiso: String) -> Bool {
        return permisos.contains(permiso)
    }
    
    func puedeConsultarActividades() -> Bool {
        return tienePermiso("Consultar actividades")
    }
    
    func puedeModificarActividad() -> Bool {
        return tienePermiso("Modificar actividad")
    }
    
    func puedeIniciarRodada() -> Bool {
        return tienePermiso("Iniciar rodada")
    }
    
    func puedeRegistrarAnuncio() -> Bool {
        return tienePermiso("Registrar anuncio")
    }
    
    func puedeModificarAnuncio() -> Bool {
        return tienePermiso("Modificar anuncio")
    }
    
    func puedeEliminarAnuncio() -> Bool {
        return tienePermiso("Eliminar anuncio")
    }
    
    func puedeModificarRol() -> Bool {
        return tienePermiso("Modificar rol")
    }
    
    func puedeDesactivarUsuario() -> Bool {
        return tienePermiso("Desactivar usuario")
    }
    
    func canCreateFAQ() -> Bool {
        return tienePermiso("Registrar pregunta frecuente")
    }
    
}
