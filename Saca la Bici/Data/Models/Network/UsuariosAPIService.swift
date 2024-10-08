//
//  ConsultarUsuariosAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class UsuariosApiService {
    static let shared = UsuariosApiService()
    
    private let firebaseTokenManager: FirebaseTokenManager

    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
        self.firebaseTokenManager = firebaseTokenManager
    }
    
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())

    func consultarUsuarios(page: Int, limit: Int, roles: [String], url: String) async throws -> ConsultarUsuariosResponse {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: [String: String] = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]

        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "roles", value: roles.joined(separator: ","))
        ]

        guard let finalURL = components.url else {
            throw NSError(domain: "API", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "API", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error en la respuesta del servidor"])
        }

        let decoder = JSONDecoder()
        return try decoder.decode(ConsultarUsuariosResponse.self, from: data)
    }
    
    func modifyRole(url: URL, idRol: String) async -> Int? {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        // Prepara los headers con el token para enviar al backend
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)", // Incluye el token en el header de autorización
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "rolId": idRol
        ]
        
        let taskRequest = session.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        let statusCode = response.response?.statusCode
        
        switch response.result {
        case .success:
            print(statusCode ?? "0")
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
    
    func getUserRoles(url: URL) async -> [Rol]? {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
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
                // Decodifica el JSON en una lista de roles
                let roles = try JSONDecoder().decode([Rol].self, from: data)
                
                return roles
            } catch {
                print("Error decodificando los roles: \(error)")
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
