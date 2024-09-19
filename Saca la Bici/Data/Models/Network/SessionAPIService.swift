//
//  LoginAPIService.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation
import FirebaseAuth
import Alamofire
import FirebaseCore
import GoogleSignIn

// Singleton
class SessionAPIService {
    // Se usa la libería de Alamofire y se usa static let para que sea inmutable y si se crean varias instancias que sea igual para todas dichas instancias.
    static let shared = SessionAPIService()
    
    // Crear una sesión personalizada con tiempos de espera ajustados
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 5 segundos para el recurso
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
                "username" : UserDatos.username,
                "nombre" : UserDatos.nombre,
                "fechaNacimiento" : fechaNacimientoString,
                "correoElectronico" : UserDatos.email,
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
            case .success(_):
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
        } catch {
            print("Error al registrar en Firebase: \(error.localizedDescription)")
            return nil
        }
    }
    
    func iniciarSesion(UserDatos: User, URLUsername: URL) async -> Int? {
        do {
            var usuarioOEmail = UserDatos.emailorUsername
            
            // Verificar si el input es un nombre de usuario (no contiene '@')
            if !usuarioOEmail.contains("@") {
                // Obtener el correo electrónico desde tu backend
                if let userEmail = try await obtenerEmailDesdeBackend(username: usuarioOEmail, URLUsername: URLUsername) {
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
            
            print(headers)
            // Falta hacer la llamada al back para mostrar info despues de iniciar sesion.
            
            return 200 // Código de éxito, o el código que desees manejar
        }
        catch {
            // Manejo de errores de inicio de sesión
            print("Error al iniciar sesión: \(error.localizedDescription)")
            return nil // Error, devuelve nil o el código de error correspondiente
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
    
    func checarPerfilBackend(url: URL) async throws -> Response {
        var emptyResponse = Response(StatusCode: 500)
        
        guard let idToken = await obtenerIDToken() else {
                throw URLError(.badServerResponse)
            }
        
        // Prepara los headers con el token para enviar al backend
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)", // Incluye el token en el header de autorización
            "Content-Type": "application/json"
        ]
            
        let taskRequest = session.request(url, method: .get, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        let statusCode = response.response?.statusCode
            
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto Response
                var response = try JSONDecoder().decode(Response.self, from: data)
                response.StatusCode = statusCode
                
                return response
            } catch {
                emptyResponse.StatusCode = statusCode
                return emptyResponse
            }
        case let .failure(error):
            debugPrint(error.localizedDescription)
            
            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
            }
            
            if let afError = error.asAFError {
                switch afError {
                case .sessionTaskFailed(let urlError as URLError):
                    // Re-throw para manejar específicamente en el SessionManager
                    throw urlError
                default:
                    // Otros errores de Alamofire
                    throw afError
                }
            } else {
                throw error
            }
        }
    }
    
    @MainActor
    func GoogleLogin(url: URL) async -> Int? {
        // Obtener el UIViewController desde SwiftUI
        guard let presentingViewController = getViewController.shared.topViewController() else {
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
    
    func completarPerfil(url: URL, UserDatos: UserExterno) async -> Int? {
        guard let idToken = await obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        // Obtener el usuario actual
        guard let currentUser = Auth.auth().currentUser else {
            print("No hay usuario autenticado")
            return nil
        }
        
        // Obtener el UID de Firebase Authentication
        let firebaseUID = currentUser.uid
        
        // Obtener nombre y correo electrónico desde Firebase
        let nombre = currentUser.displayName ?? "Nombre no disponible"
        let correoElectronico = currentUser.email ?? "Correo no disponible"
        
        // Prepara los headers con el token para enviar al backend
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)", // Incluye el token en el header de autorización
            "Content-Type": "application/json"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaNacimientoString = dateFormatter.string(from: UserDatos.fechaNacimiento)
        
        let parameters: Parameters = [
            "username" : UserDatos.username,
            "nombre" : "\(nombre)",
            "fechaNacimiento" : fechaNacimientoString,
            "correoElectronico" : "\(correoElectronico)",
            "tipoSangre": UserDatos.tipoSangre,
            "numeroEmergencia": UserDatos.numeroEmergencia,
            "firebaseUID": "\(firebaseUID)"
        ]
        
        let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        let statusCode = response.response?.statusCode
        
        switch response.result {
        case .success(_):
            return statusCode
            
        case let .failure(error):
            debugPrint(error.localizedDescription)
                
            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
            }
            
            return statusCode
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
    
    
    func obtenerEmailDesdeBackend(username: String, URLUsername: URL) async throws -> String? {
        
        let parameters: Parameters = [
            "username" : username
        ]
        
        // Prepara los headers con el token para enviar al backend
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
            
        let taskRequest = session.request(URLUsername, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto Response
                let response = try JSONDecoder().decode(Response.self, from: data)
            
                return response.correoElectronico
                
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
}
