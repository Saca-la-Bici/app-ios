//
//  UserSessionManager.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 27/09/24.
//

import SwiftUI

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    
    @Published var rol: String = "Usuario"
    
    private init() {}
    
    func updateRol(newRol: String) {
        DispatchQueue.main.async {
            self.rol = newRol
        }
    }
    
    func isAdmin() -> Bool {
        return rol == "Administrador"
    }
    
    func isUser() -> Bool {
        return rol == "Usuario"
    }
    
    func isStaff() -> Bool {
        return rol == "Staff"
    }
}
