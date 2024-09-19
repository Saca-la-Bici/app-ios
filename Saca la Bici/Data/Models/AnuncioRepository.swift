//
//  AnuncioRepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

class AnuncioRepository {
    private let apiService: AnuncioAPIService
    
    init(apiService: AnuncioAPIService = AnuncioAPIService()) {
        self.apiService = apiService
    }
    
    func getAnuncios(completion: @escaping (Result<[Anuncio], Error>) -> Void) {
        apiService.fetchAnuncios { result in
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
        apiService.registrarAnuncio(anuncio) { result in
            completion(result) 
        }
    }
}
