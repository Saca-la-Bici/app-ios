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
    
    func getAnuncios() async throws -> AnunciosResponse {
        let response = try await apiService.fetchAnuncios(url: URL(string: "\(Api.baseURL)\(Api.Routes.anuncios)/consultar")!)
        
        // Filtras los anuncios no válidos
        let anuncios = response.announcements
        let anunciosValidos = anuncios.filter { AnuncioRequirement.esValido(anuncio: $0) }
        
        // Vuelves a sacar el rol
        let anuncioResponse = AnunciosResponse(announcements: anunciosValidos, permisos: response.permisos)
        return anuncioResponse
    }
    
    func postAnuncio(_ anuncio: Anuncio, imagenData: Data?) async throws -> String {
        let message = try await apiService.registrarAnuncio(url:
                    URL(string: "\(Api.baseURL)\(Api.Routes.anuncios)/registrar")!, anuncio, imagenData: imagenData)
        return message
    }
    
    func eliminarAnuncio(idAnuncio: String) async throws -> String {
        let message = try await apiService.eliminarAnuncio(
            url: URL(string: "\(Api.baseURL)\(Api.Routes.anuncios)/eliminar/\(idAnuncio)")!, anuncioID: idAnuncio)
        return message
    }
    
    func modificarAnuncio(_ anuncio: Anuncio, idAnuncio: String, imagenData: Data?) async throws -> Anuncio {
        let updatedAnuncio = try await apiService.modificarAnuncio(
            url: URL(string: "\(Api.baseURL)\(Api.Routes.anuncios)/modificar/\(idAnuncio)")!, anuncio, anuncioID: anuncio.id, imagenData: imagenData)
        return updatedAnuncio
    }

}
