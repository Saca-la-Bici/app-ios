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
    
    @Published var emailOrUsername: String = ""
    @Published var buttonLabel: String = "Enviar enlace"
    
    // Creas dos variables más por si se comete un error
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    @Published var alertSuccess = false
    
    var restablecerContraseñaRequirement: RestablecerContraseñaRequirement
    
    init(restablecerContraseñaRequirement: RestablecerContraseñaRequirement = RestablecerContraseñaRequirement.shared) {
        self.restablecerContraseñaRequirement = restablecerContraseñaRequirement
    }
    
    // Función para validar que la contraseña contenga al menos una minúscula, una mayúscula y un número
    func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    @MainActor
    func verificarContraseña () async {
        if currentPassword.isEmpty {
            self.showAlert = true
            self.messageAlert = "Por favor ingresa tu contraseña actual."
            self.alertSuccess = false
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
    
    @MainActor
    func restablecerContraseña () async {
        if self.newPassword.isEmpty || self.confirmPassword.isEmpty {
            self.messageAlert = "Alguna de las dos contraseñas está vacía. Favor de intentarlo de nuevo."
            self.showAlert = true
            self.alertSuccess = false
            return
        }
        
        if self.newPassword != self.confirmPassword {
            self.messageAlert = "Las contraseñas no son iguales. Favor de intentarlo de nuevo."
            self.showAlert = true
            self.alertSuccess = false
            return
        }
        
        if self.newPassword.count < 8 {
            self.messageAlert = "La contraseña es demasiado corta. Debe tener al menos 8 caracteres."
            self.showAlert = true
            self.alertSuccess = false
            return
        }
        
        if !isValidPassword(self.newPassword) {
            self.messageAlert = "La contraseña debe contener al menos una letra minúscula, una letra mayúscula, un número y un carácter especial."
            self.showAlert = true
            self.alertSuccess = false
            return
        }
        
        let contraseñaNueva = await restablecerContraseñaRequirement.restablecerContraseña(newPassword: self.newPassword)
        
        if contraseñaNueva == true {
            self.showAlert = true
            self.messageAlert = "La contraseña ha sido restablecida. Ahora usa tu nueva contraseña para iniciar sesión."
            self.alertSuccess = true
            return
        } else {
            self.showAlert = true
            self.messageAlert = "Hubo un error al restablecer la contraseña. Por favor intente de nuevo."
            self.alertSuccess = false
            return
        }
    }
    
    @MainActor
    func emailRestablecerContraseña() async {
        if self.emailOrUsername.isEmpty {
            self.messageAlert = "Correo o username vacío. Favor de intentarlo de nuevo."
            self.showAlert = true
            self.alertSuccess = false
            return
        }
        
        let emailSent = await restablecerContraseñaRequirement.emailRestablecerContraseña(emailOrUsername: self.emailOrUsername)
        
        if emailSent == true {
            self.showAlert = true
            self.messageAlert = "¡El enlace ha sido enviado!"
            self.alertSuccess = true
        } else {
            self.showAlert = true
            self.messageAlert = "Hubo un error al enviar el enlace. Favor de intentarlo de nuevo."
            self.alertSuccess = false
        }
    }
    
}
