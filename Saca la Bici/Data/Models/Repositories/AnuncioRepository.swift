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
    
    func getAnuncios(completion: @escaping (Result<[Anuncio], Error>) -> Void) {
        apiService.fetchAnuncios(url: URL(string: "\(Api.base)\(Api.Routes.anuncios)/consultar")!) { result in
            switch result {
            case .success(let anuncios):
                let anunciosValidos = anuncios.filter { AnuncioRequirement.esValido(anuncio: $0) }
                completion(.success(anunciosValidos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postAnuncio(_ anuncio: Anuncio, completion: @escaping (Result<String, Error>) -> Void) {
            // Llamamos a la función de `apiService` sin manejar la URL aquí,
            // ya que la URL está dentro del `apiService`.
            apiService.registrarAnuncio(anuncio) { result in
                // Pasamos el resultado a través del completion handler
                switch result {
                case .success(let message):
                    completion(.success(message))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
        func eliminarAnuncio(idAnuncio: String, completion: @escaping (Result<String, Error>) -> Void) {
            apiService.eliminarAnuncio(url: URL(string: "\(Api.base)\(Api.Routes.anuncios)/eliminar/\(idAnuncio)")!) { result in
                completion(result)
            }
        }
    
    func modificarAnuncio(idAnuncio: String, titulo: String, contenido: String, completion: @escaping (Result<String, Error>) -> Void) {
            apiService.modificarAnuncio(url: URL(string: "\(Api.base)\(Api.Routes.anuncios)/modificar/\(idAnuncio)")!,
                                        titulo: titulo, contenido: contenido, completion: completion)
        }
}
