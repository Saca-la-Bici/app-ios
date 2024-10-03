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
    
    // Función para obtener el ID Token de Firebase usando async/await
    private func obtenerIDToken() async -> String? {
        // Verificar si hay un usuario autenticado
        guard let user = Auth.auth().currentUser else {
            print("No hay un usuario autenticado.")
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            // Obtener el ID Token del usuario actual
            user.getIDTokenForcingRefresh(true) { idToken, error in
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
    
    func consultarPerfilPropio(url: URL) async throws -> Profile {
        
        // Cuando tenga cuenta AKKA ya lo este corriendo con el api
        print("Estoy apunto de checar el IDTOKEN")
        guard let idToken = await obtenerIDToken() else {
                    print("No encontre el IDTOKEN")
                    throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
                }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let profile = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(Profile.self)
                .value
            
            return profile
        } catch {
            print("Error al obtener perfil: \(error.localizedDescription)")
            throw error
        }
        
    }
    
}
