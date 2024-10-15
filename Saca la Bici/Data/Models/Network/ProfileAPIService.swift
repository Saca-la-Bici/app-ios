//
//  ProfileAPIService.swift
//  Saca la Bici
//
//  Created by Diego Lira on 25/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class ProfileAPIService {
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
        self.firebaseTokenManager = firebaseTokenManager
    }
    
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())
    
    func consultarPerfilPropio(url: URL) async throws -> Profile {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
                    throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
                }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let profile = try await session.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(Profile.self)
                .value
            
            return profile
        } catch {
            print("Error al obtener perfil: \(error.localizedDescription)")
            throw error
        }
        
    }
    
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String, url: URL) async throws -> String {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        // Cuerpo de la solicitud (datos del perfil a modificar)
        let parameters: [String: Any] = [
            "nombre": nombre,
            "username": username,
            "tipoSangre": tipoSangre,
            "numeroEmergencia": numeroEmergencia
        ]
        
        do {
            // Realiza la solicitud PATCH a la API
            let response = try await session.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .serializingString()
                .value
            
            return response  // Retorna la respuesta del servidor en caso de éxito
            
        } catch {
            print("Error al modificar perfil: \(error.localizedDescription)")
            throw error  // Propaga el error para que pueda manejarse a nivel superior
        }
    }
    
}
