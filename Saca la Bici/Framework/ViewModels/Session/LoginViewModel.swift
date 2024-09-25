//
//  LoginViewModel.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

// Tipo observable para que la interfaz sepa de cambios
class LoginViewModel: ObservableObject {
    
    @Published var emailOrUsername: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var textTest: String = "Resultado de Firebase"
    @Published var LoginViewActive: Bool = false
    
    // Creas dos variables más por si se comete un error
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    // Variable para almacenar el nonce raw
    private var rawNonce: String?
    
    // Llamas el requerimiento de user con sus funciones
    var loginRequirement: LoginRequirementProtocol
        
    init(loginRequirement: LoginRequirementProtocol = LoginRequirement.shared) {
        self.loginRequirement = loginRequirement
    }
    
    @MainActor
    func iniciarSesion() async {
        
        if self.emailOrUsername.isEmpty || self.password.isEmpty {
            self.messageAlert = "Correo vacío o Contraseña vacía"
            self.showAlert = true
            return
        }
        
        let UserData = User(emailorUsername: self.emailOrUsername, password: self.password)
        
        let responseStatus = await self.loginRequirement.iniciarSesion(UserDatos: UserData)
        
        if responseStatus == 1 {
            self.messageAlert = "El usuario o contraseña ingresada es incorrecta. Favor de intentarlo de nuevo."
            self.showAlert = true
        } else if responseStatus != 200 {
            self.messageAlert = "Hubo un error al procesar el inicio se sesión.  Favor de intentarlo de nuevo."
            self.showAlert = true
        }
    }
    
    @MainActor
    func probarToken() async {
        let responseAPI = await self.loginRequirement.probarToken()
        // Verificar si responseAPI tiene un valor (unwrap opcional)
        if let response = responseAPI {
            // Asignar el mensaje al textTest
            self.textTest = response.message ?? ""
        } else {
            // Si no hay respuesta, manejar el caso de error
            self.textTest = "Error: No se recibió una respuesta válida"
        }
    }
    
    @MainActor
    func GoogleLogin() async {
        let responseStatus = await self.loginRequirement.GoogleLogin()
        
        if responseStatus == 500 {
            self.messageAlert = "Error al iniciar sesión con Google. Favor intentarlo de nuevo"
            self.showAlert = true
            // No mostrar error si se cancelo.
        } else if responseStatus == -1 {
            self.showAlert = false
        }
    }
    
    // Función para preparar el nonce y devolver el nonce hasheado
    func prepareNonce() -> String {
        let nonce = AppleCryptoHelpers.randomNonceString()
        let hashedNonce = AppleCryptoHelpers.sha256(nonce)
        self.rawNonce = nonce
        return hashedNonce
    }
    
    @MainActor
    // Función para manejar la autenticación con Apple
    func AppleLogin(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            defer {
                self.rawNonce = nil // Limpiar el nonce después de usarlo
            }
            
            guard let nonce = rawNonce else {
                self.messageAlert = "Estado inválido"
                self.showAlert = true
                return
            }
            
            let responseStatus = await loginRequirement.AppleLogin(authorization: authorization, nonce: nonce)
            
            if responseStatus == 200 {
                // Autenticación exitosa
                self.showAlert = false
            } else if responseStatus == -1 {
                // El usuario canceló el inicio de sesión
                self.showAlert = false
            } else {
                // Error en la autenticación
                self.messageAlert = "Error al iniciar sesión con Apple. Favor intentar de nuevo"
                self.showAlert = true
            }
            
        case .failure(let error):
            if (error as NSError).code == ASAuthorizationError.canceled.rawValue {
                // El usuario canceló la autenticación
                self.showAlert = false
            } else {
                print("Error en Sign in with Apple: \(error.localizedDescription)")
                self.messageAlert = "Error al iniciar sesión con Apple. Favor intentar de nuevo"
                self.showAlert = true
            }
        }
    }
}

