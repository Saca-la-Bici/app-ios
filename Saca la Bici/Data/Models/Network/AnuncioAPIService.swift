//
//  AnuncioAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class AnuncioAPIService {
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
            self.firebaseTokenManager = firebaseTokenManager
        }
    
    // Función para obtener los anuncios existentes
    func fetchAnuncios(url: URL) async throws -> AnunciosResponse {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        print(idToken)
        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(AnunciosResponse.self)
                .value
            
            return response
        } catch {
            print("Error al obtener anuncios: \(error.localizedDescription)")
            throw error
        }
    }

    // Función para registrar un nuevo anuncio
    func registrarAnuncio(url: URL, _ anuncio: Anuncio, imagenData: Data?) async throws -> String {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        let params: [String: String] = [
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                // Añadir los parámetros de texto
                for (key, value) in params {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                // Añadir la imagen si existe
                if let data = imagenData {
                    multipartFormData.append(data, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            }, to: url, headers: headers)
            .validate()
            .responseDecodable(of: ResponseMessage.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value.message)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Función para eliminar un anuncio
    func eliminarAnuncio(url: URL, anuncioID: String) async throws -> String {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        _ = try await AF.request(url, method: .delete, headers: headers)
            .validate()
            .serializingData()
            .value
        
        return "Anuncio eliminado exitosamente"
    }
    
    // Función para modificar un anuncio existente
    func modificarAnuncio(url: URL, _ anuncio: Anuncio, anuncioID: String, imagenData: Data?) async throws -> Anuncio {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]

        let params: [String: String] = [
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                // Añadir los parámetros de texto
                for (key, value) in params {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                // Añadir la imagen (ya sea nueva o existente)
                if let data = imagenData {
                    multipartFormData.append(data, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                // Si imagenData es nil, no se añade ninguna imagen, y el servidor debe eliminar la imagen existente
            }, to: url, method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: Anuncio.self) { response in
                switch response.result {
                case .success(let anuncio):
                    continuation.resume(returning: anuncio)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
