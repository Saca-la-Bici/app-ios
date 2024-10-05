//
//  ConsultarUsuariosAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class ConsultarUsuariosApiService {
    private let firebaseTokenManager: FirebaseTokenManager

    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
        self.firebaseTokenManager = firebaseTokenManager
    }

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
}
