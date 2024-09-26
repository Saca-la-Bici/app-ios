//
//  LoginAPIService.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import Alamofire
import GoogleSignIn

class SessionAPIService: NSObject {
    // Se usa la libería de Alamofire y se usa static let para que sea inmutable y si se crean varias instancias que sea igual para todas dichas instancias.
    static let shared = SessionAPIService()
    
    // Crear una sesión personalizada con tiempos de espera ajustados
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())

    func registrarUsuario(url: URL, UserDatos: UserNuevo) async -> Int? {
        do {
            // Crear el usuario en Firebase Authentication
            let authResult = try await Auth.auth().createUser(withEmail: UserDatos.email, password: UserDatos.password)
            
            // Obtener el UID de Firebase Authentication
            let firebaseUID = authResult.user.uid
                       
            // Obtener el ID Token del usuario autenticado
            let idToken = try await authResult.user.getIDToken()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let fechaNacimientoString = dateFormatter.string(from: UserDatos.fechaNacimiento)
            
            let parameters: Parameters = [
                "username": UserDatos.username,
                "nombre": UserDatos.nombre,
                "fechaNacimiento": fechaNacimientoString,
                "correoElectronico": UserDatos.email,
                "tipoSangre": UserDatos.tipoSangre,
                "numeroEmergencia": UserDatos.numeroEmergencia,
                "firebaseUID": firebaseUID
            ]
                       
            // Preparar los headers con el ID Token para enviarlo al backend
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]
            
            let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            let response = await taskRequest.serializingData().response
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success:
                return statusCode
                
            case let .failure(error):
                // Eliminar el usuario de Firebase porque falló el backend
                try await authResult.user.delete()
                
                debugPrint(error.localizedDescription)
                    
                // Imprimir el cuerpo de la respuesta en caso de error
                if let data = response.data {
                    let errorResponse = String(decoding: data, as: UTF8.self)
                    print("\(errorResponse)")
                }
                
                return statusCode
            }
        } catch let error as NSError {
            // Convertir el error a AuthErrorCode para manejar casos específicos
            if let authError = AuthErrorCode(rawValue: error.code) {
                switch authError {
                case .weakPassword:
                    print("Error: La contraseña es demasiado corta. Debe tener al menos 6 caracteres.")
                    return 406
                case .invalidEmail:
                    print("Error: El correo electrónico proporcionado no es válido.")
                    return 405
                default:
                    // Manejar otros errores de Firebase Authentication
                    print("Error al registrar en Firebase: \(error.localizedDescription)")
                }
            } else {
                // Manejar errores que no son de Firebase Authentication
                print("Error desconocido al registrar en Firebase: \(error.localizedDescription)")
            }
            return nil
        }
    }
    
    func iniciarSesion(UserDatos: User, URLUsername: URL, url: URL) async -> Int? {
        do {
            var usuarioOEmail = UserDatos.emailorUsername
            
            // Verificar si el input es un nombre de usuario (no contiene '@')
            if !usuarioOEmail.contains("@") {
                // Obtener el correo electrónico desde tu backend
                if let userEmail = try await UserProfileSessionAPIService().obtenerEmailDesdeBackend(
                    username: usuarioOEmail, URLUsername: URLUsername) {
                    usuarioOEmail = userEmail
                } else {
                    print("Nombre de usuario no encontrado")
                    return nil
                }
            }
            
            // Iniciar sesión en Firebase Authentication con el correo y la contraseña
            let authResult = try await Auth.auth().signIn(withEmail: usuarioOEmail, password: UserDatos.password)
            
            // Obtener el ID Token del usuario autenticado
            let idToken = try await authResult.user.getIDToken()
            
            // Preparar los headers con el ID Token para enviarlo al backend si es necesario
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]
            
            /* Para checar si el backend esta funcionando.
             Despues esto se cambia por la función de consultar actividades */
            
            let taskRequest = session.request(url, method: .get, headers: headers).validate()
            let response = await taskRequest.serializingData().response
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success:
                    return statusCode
            case let .failure(error):
                // Ya que dio error, sacas al usuario de la sesion de Firebase
                try Auth.auth().signOut()
                debugPrint(error.localizedDescription)
                
                // Imprimir el cuerpo de la respuesta en caso de error
                if let data = response.data {
                    let errorResponse = String(decoding: data, as: UTF8.self)
                    print("\(errorResponse)")
                }
                
                return statusCode
            }
        } catch {
            // Manejo de errores de inicio de sesión
            print("Error al iniciar sesión: \(error.localizedDescription)")
            return 1 // Error, devuelve nil o el código de error correspondiente
        }
    }
    
    func probarToken(url: URL) async -> Response? {
        // Obtener el ID Token usando async/await
        guard let idToken = await obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        // Prepara los headers con el token para enviar al backend
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)", // Incluye el token en el header de autorización
            "Content-Type": "application/json"
        ]
        
        let taskRequest = session.request(url, method: .get, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto Response
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                return nil
            }
        case let .failure(error):
            debugPrint(error.localizedDescription)
            
            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
            }
            return nil
        }
    }
    
    @MainActor
    func GoogleLogin(url: URL) async -> Int? {
        // Obtener el UIViewController desde SwiftUI
        guard let presentingViewController = GetViewController.shared.topViewController() else {
            print("No se pudo obtener el UIViewController para presentar la interfaz de Google Sign-In")
            return nil
        }
        
        // Mantener una referencia fuerte al presentingViewController
        let strongPresentingViewController = presentingViewController

        do {
            // Matas la sesion antigua por cualquier cosa.
            try Auth.auth().signOut()
            
            // Iniciar el proceso de inicio de sesión con Google
            let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: strongPresentingViewController)
            
            // Obtener el ID token y el access token de Google
            guard let idToken = signInResult.user.idToken?.tokenString else {
                print("No se pudo obtener el ID token de Google")
                return nil
            }
            let accessToken = signInResult.user.accessToken.tokenString
            
            // Crear credenciales de Firebase con los tokens de Google
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Iniciar sesión en Firebase con las credenciales
            _ = try await Auth.auth().signIn(with: credential)
            
            return(200)
            
        } catch let error as GIDSignInError {
            // Manejar errores específicos de GIDSignIn
            if error.code == .canceled {
                // El usuario canceló el inicio de sesión
                return -1
            } else {
                // Otros errores de GIDSignIn
                print("Error durante el inicio de sesión con Google: \(error.localizedDescription)")
                return 500
            }
        } catch {
            // Manejar otros errores
            print("Error inesperado durante el inicio de sesión con Google: \(error.localizedDescription)")
            return 500
        }
    }
    
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Credenciales inválidas")
            return 500
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("No se pudo obtener el token de identidad")
            return 500
        }
        
        // Crear credencial de Firebase
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                                    rawNonce: nonce,
                                                                    fullName: appleIDCredential.fullName)
        
        do {
            // Iniciar sesión en Firebase con las credenciales
            _ = try await Auth.auth().signIn(with: credential)
            return 200
        } catch {
            print("Error al autenticar con Firebase: \(error.localizedDescription)")
            return 500
        }
    }
    
    // Función para obtener el ID Token de Firebase usando async/await
    private func obtenerIDToken() async -> String? {
        return await withCheckedContinuation { continuation in
            // Obtener el ID Token del usuario actual
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error al obtener el ID Token: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                } else if let idToken = idToken {
                    continuation.resume(returning: idToken)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    // Función para reautenticar al usuario
    func reauthenticateUser(currentPassword: String) async -> Bool {
        // Obtener el usuario actual
        guard let user = Auth.auth().currentUser, let email = user.email else {
            print("Usuario no encontrado")
            return false
        }

        // Crear las credenciales usando el proveedor de correo electrónico y contraseña
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        do {
            try await user.reauthenticate(with: credential)
            return true
        } catch {
            print("Reauthentication failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func restablecerContraseña(newPassword: String) async -> Bool {
        // Obtener el usuario actual
        guard let user = Auth.auth().currentUser else {
            print("Usuario no encontrado")
            return false
        }
        
        do {
            try await user.updatePassword(to: newPassword)
            return true
        } catch {
            print("Restablcer contraseña fallida: \(error.localizedDescription)")
            return false
        }
    }
    
    func emailRestablecerContraseña(URLUsername: URL, emailOrUsername: String) async -> Bool {
        
        var email = emailOrUsername
        
        do {
            // Verificar si el input es un nombre de usuario (no contiene '@')
            if !emailOrUsername.contains("@") {
                // Obtener el correo electrónico desde tu backend
                if let userEmail = try await UserProfileSessionAPIService().obtenerEmailDesdeBackend(
                    username: emailOrUsername, URLUsername: URLUsername) {
                    email = userEmail
                } else {
                    print("Nombre de usuario no encontrado")
                    return false
                }
            }
            
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return true
        } catch {
            print("Restablecer contraseña fallida: \(error.localizedDescription)")
            return false
        }
    }
}
