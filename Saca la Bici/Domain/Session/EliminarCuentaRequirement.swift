//
//  EliminarCuentaRequirement.swift
//  Saca la Bici
//
//  Created by Diego Lira on 28/01/25.
//

import Foundation

class EliminarCuentaRequirement {
    
    private let profileRepository = ProfileRepository()
    
    func eliminarCuenta() async throws -> Bool {
        do {
            return try await profileRepository.eliminarCuenta()
        } catch {
            throw error
        }
    }
}
