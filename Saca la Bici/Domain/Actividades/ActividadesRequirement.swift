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
    
    func execute() async throws -> (rodadas: [Rodada], permisos: [String]) {
        return try await repository.getRodadas() 
    }
}

class GetEventosUseCase {
    private let repository: ActividadesRepository
    
    init(repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> (eventos: [Evento], permisos: [String]) {
        return try await repository.getEventos()
    }
}

class GetTalleresUseCase {
    private let repository: ActividadesRepository
    
    init(repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    func execute() async throws -> (talleres: [Taller], permisos: [String]) {
        return try await repository.getTalleres()
    }
}
