//
//  UserProfileSessionAPIService.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 23/09/24.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import Alamofire
import GoogleSignIn

class UserProfileSessionAPIService {
    static let shared = UserProfileSessionAPIService()
    
    // Crear una sesión personalizada con tiempos de espera ajustados
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())

    // Función para checar el perfil desde el backend
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
                    // Re-lanzar para manejar específicamente en el SessionManager
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

    // Función para completar el perfil del usuario
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
            "username": UserDatos.username,
            "nombre": "\(nombre)",
            "fechaNacimiento": fechaNacimientoString,
            "correoElectronico": "\(correoElectronico)",
            "tipoSangre": UserDatos.tipoSangre,
            "numeroEmergencia": UserDatos.numeroEmergencia,
            "firebaseUID": "\(firebaseUID)"
        ]
        
        let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        let statusCode = response.response?.statusCode
        
        switch response.result {
        case .success:
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

    // Función para verificar si el nombre de usuario existe
    func verificarUsernameExistente(username: String, URLUsername: URL) async -> Bool? {
        
        let parameters: Parameters = [
            "username": username
        ]
        
        // Prepara los headers para enviar al backend
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
            
        let taskRequest = session.request(URLUsername, method: .get, parameters: parameters,
                                          encoding: URLEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto Response
                let response = try JSONDecoder().decode(Response.self, from: data)
            
                return response.usernameExistente
                
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

    // Función para obtener el correo electrónico desde el backend
    func obtenerEmailDesdeBackend(username: String, URLUsername: URL) async throws -> String? {
        
        let parameters: Parameters = [
            "username": username
        ]
        
        // Prepara los headers para enviar al backend
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
            
        let taskRequest = session.request(URLUsername, method: .get, parameters: parameters,
                                          encoding: URLEncoding.default, headers: headers).validate()
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
}
