//
//  ActividadesAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class APIService {
    
    func fetchRodadas(url: URL) async throws -> [RodadasResponse] {
        
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: [RodadasResponse].self) { response in
                    switch response.result {
                    case .success(let rodadas):
                        continuation.resume(returning: rodadas)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchEventos(url: URL) async throws -> [EventosResponse] {
        
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: [EventosResponse].self) { response in
                    switch response.result {
                    case .success(let eventos):
                        continuation.resume(returning: eventos)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchTalleres(url: URL) async throws -> [TalleresResponse] {
        
        guard let idToken = await obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: [TalleresResponse].self) { response in
                    switch response.result {
                    case .success(let talleres):
                        continuation.resume(returning: talleres)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
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
