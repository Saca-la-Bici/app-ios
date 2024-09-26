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
    
    // Función para obtener los anuncios existentes
    func fetchAnuncios(url: URL) async throws -> [Anuncio] {

        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let anuncios = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable([Anuncio].self)
                .value
            
            return anuncios
        } catch {
            print("Error al obtener anuncios: \(error.localizedDescription)")
            throw error
        }
    }

    // Función para registrar un nuevo anuncio
    func registrarAnuncio(url: URL, _ anuncio: Anuncio) async throws -> String {
        
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        let params: [String: Any] = [
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido,
            "imagen": ""
        ]
        
        let responseMessage = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .serializingDecodable(ResponseMessage.self)
            .value
        
        return responseMessage.message
    }
    
    // Función para eliminar un anuncio
    func eliminarAnuncio(url: URL, anuncioID: String) async throws -> String {
        
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        print("Token: ", idToken)

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
    func modificarAnuncio(url: URL, _ anuncio: Anuncio, anuncioID: String) async throws -> Anuncio {
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        let params: [String: Any] = [
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido,
            "imagen": ""
        ]
        
        let responseData = try await AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .serializingDecodable(Anuncio.self)
            .value
        
        return responseData
    }


    
    // Función para obtener el ID Token de forma asincrónica
    private func obtenerIDToken() async -> String? {
        return await withCheckedContinuation { continuation in
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error al obtener el ID Token: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                } else {
                    continuation.resume(returning: idToken)
                }
            }
        }
    }
}
