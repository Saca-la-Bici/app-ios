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
    
    func consultarMedallas(url: URL) async throws -> MedallasResponse {
            guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]
            
            do {
                let medallasResponse = try await session.request(url, method: .get, headers: headers)
                    .validate()
                    .serializingDecodable(MedallasResponse.self)
                    .value
                
                return medallasResponse
            } catch {
                print("Error al obtener medallas: \(error.localizedDescription)")
                throw error
            }
        }
    
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String, url: URL, imagen: Data?) async throws -> String {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "multipart/form-data"  // Necesitamos multipart para manejar archivos e información de texto
        ]
        
        let params: [String: String] = [
            "nombre": nombre,
            "username": username,
            "tipoSangre": tipoSangre,
            "numeroEmergencia": numeroEmergencia
        ]
        
        // Subir usando multipart/form-data
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                // Añadir los parámetros de texto
                for (key, value) in params {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                // Añadir la imagen si existe
                if let imagenData = imagen {
                    multipartFormData.append(imagenData, withName: "file", fileName: "imagen.jpg", mimeType: "image/jpeg")
                }
            }, to: url, method: .patch, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
