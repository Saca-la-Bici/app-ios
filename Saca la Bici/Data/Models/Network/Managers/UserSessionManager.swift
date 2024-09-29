//
//  UserSessionManager.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 27/09/24.
//

import SwiftUI

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    
    @Published var permisos: [String] = []
    
    private init() {}
    
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
    
    func puedeIniciarRodada() -> Bool {
        return tienePermiso("Iniciar rodada")
    }
}
