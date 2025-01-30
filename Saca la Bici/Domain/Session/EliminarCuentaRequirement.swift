//
//  EliminarCuentaRequirement.swift
//  Saca la Bici
//
//  Created by Diego Lira on 28/01/25.
//

import Foundation

class EliminarCuentaRequirement {
    
    private let profileRepository = ProfileRepository()
    
    let sessionRepository: SessionRepository
    
    // Inicializas la instancia con el repositorio que acaba se crearse
    init(sessionRepository: SessionRepository = SessionRepository.shared) {
        self.sessionRepository = sessionRepository
    }
    
    func GoogleLoginReauthentication() async -> Int? {
        return await sessionRepository.GoogleLoginReauthentication()
    }
    
    func eliminarCuenta() async throws -> Bool {
        return try await profileRepository.eliminarCuenta()
    }
}
