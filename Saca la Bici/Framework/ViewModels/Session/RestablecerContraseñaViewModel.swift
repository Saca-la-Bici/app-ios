//
//  RestablecerContraseñaViewModel.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import Foundation

class RestablecerContraseñaViewModel: ObservableObject {
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var showCurrentPassword = false
    @Published var showNewPassword = false
    @Published var showConfirmPassword = false
    @Published var showNuevaContraseñaFields = false
    
    // Creas dos variables más por si se comete un error
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    var restablecerContraseñaRequirement: RestablecerContraseñaRequirement
    
    init(restablecerContraseñaRequirement: RestablecerContraseñaRequirement = RestablecerContraseñaRequirement.shared) {
        self.restablecerContraseñaRequirement = restablecerContraseñaRequirement
    }
    
    @MainActor
    func verificarContraseña () async {
        if currentPassword.isEmpty {
            self.showAlert = true
            self.messageAlert = "Por favor ingresa tu contraseña actual."
            return
        }
        
        let usuarioReautenticado = await restablecerContraseñaRequirement.reauthenticateUser(currentPassword: self.currentPassword)
        
        if usuarioReautenticado == true {
            self.showNuevaContraseñaFields = true
        } else {
            self.showAlert = true
            self.messageAlert = "La contraseña ingresada no es correcta. Por favor intenta de nuevo."
            return
        }
    }
    
}
