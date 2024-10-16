//
//  FirebaseTokenManager.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 27/09/24.
//

import Foundation
import FirebaseAuth

final class FirebaseTokenManager {
    
    static let shared = FirebaseTokenManager()
    
    private init() {}
    
    func obtenerIDToken() async -> String? {
        return await withCheckedContinuation { continuation in
            // Verificar si currentUser es nil antes de solicitar el ID Token
            guard let currentUser = Auth.auth().currentUser else {
                print("Error: No hay un usuario autenticado.")
                continuation.resume(returning: nil)
                return
            }

            // Obtener el ID Token del usuario actual
            currentUser.getIDTokenForcingRefresh(true) { idToken, error in
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
