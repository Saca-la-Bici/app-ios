//
//  SignUpViewModel.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    // States
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmVisible: Bool = false
    
    @Published var selectedMonth: String = "Enero"
    @Published var selectedDay: String = "1"
    @Published var selectedYear: String = "2023"
    @Published var selectedBloodType = "Selecciona tu tipo de sangre"
    @Published var countryCode = ""
    @Published var phoneNumber = ""
    @Published var nombreCompleto: String = ""

   
    // Arrays
    let months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    let bloodTypes = ["Selecciona tu tipo de sangre", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    let days = Array(1...31).map { "\($0)" }
    let years = Array(1900...2023).reversed().map { "\($0)" }
    
    // Creas dos variables más por si se comete un error
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    // Llamas el requerimiento de user con sus funciones
    var signUpRequirement: SignUpRequirementProtocol
        
    init(signUpRequirement: SignUpRequirementProtocol = SignUpRequirement.shared) {
        self.signUpRequirement = signUpRequirement
    }
    
    func validarDatosStep1() {
        if self.email.isEmpty || self.username.isEmpty {
            self.messageAlert = "Correo o username vacío. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
    }
    
    func validarDatosStep2() {
        if (self.countryCode.isEmpty || self.phoneNumber.isEmpty || self.selectedBloodType == "Selecciona tu tipo de sangre") {
            self.messageAlert = "Tipo de sangre o número de emergencia vacío. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
    }
    
    @MainActor
    func registrarUsuario() async {
        if (self.password.isEmpty || self.confirmPassword.isEmpty) {
            self.messageAlert = "Alguna de las dos contraseñas está vacía. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
        
        if (self.password != self.confirmPassword) {
            self.messageAlert = "Las contraseñas no son iguales. Favor de intentar de nuevo."
            self.showAlert = true
            return
        }
        
        let numeroEmergencia = "+" + self.countryCode + self.phoneNumber
        
        let usuarioNuevo = UserNuevo(username: self.username, password: self.confirmPassword, email: self.email, tipoSangre: self.selectedBloodType, numeroEmergencia: numeroEmergencia)
        
        let responseCode = await self.signUpRequirement.registrarUsuario(UserDatos: usuarioNuevo)
        
        if (responseCode != 201){
            self.messageAlert = "Hubo un error al registrar al usuario."
            self.showAlert = true
        }
    }
   
}
