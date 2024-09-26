//
//  ActividadesRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Foundation

class GetRodadasUseCase {
    private let repository: ActividadesRepository
    
    init(repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [Rodada] {
        return try await repository.getRodadas()
    }
}

class GetEventosUseCase {
    private let repository: ActividadesRepository
    
    init(repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> [Evento] {
        return try await repository.getEventos()
    }
}
