//
//  AnuncioRepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import Foundation

class AnuncioRepository {
    private let apiService: AnuncioAPIService
    
    init(apiService: AnuncioAPIService = AnuncioAPIService()) {
        self.apiService = apiService
    }
    
    func getAnuncios() async throws -> [Anuncio] {
        let anuncios = try await apiService.fetchAnuncios()
        let anunciosValidos = anuncios.filter { AnuncioRequirement.esValido(anuncio: $0) }
        return anunciosValidos
    }
    
    func postAnuncio(_ anuncio: Anuncio) async throws -> String {
        let message = try await apiService.registrarAnuncio(anuncio)
        return message
    }
    
    func eliminarAnuncio(idAnuncio: String) async throws -> String {
        let message = try await apiService.eliminarAnuncio(anuncioID: idAnuncio)
        return message
    }

    
    func modificarAnuncio(_ anuncio: Anuncio) async throws -> Anuncio {
        let updatedAnuncio = try await apiService.modificarAnuncio(anuncio, anuncioID: anuncio.id)
        return updatedAnuncio
    }


}
