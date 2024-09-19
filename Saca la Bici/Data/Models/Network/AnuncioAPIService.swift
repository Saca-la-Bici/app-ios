//
//  AnuncioAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import Alamofire
import Foundation

class AnuncioAPIService {
    
    // Función para obtener los anuncios existentes
    func fetchAnuncios(completion: @escaping (Result<[Anuncio], Error>) -> Void) {
        let url = "http://localhost:7070/anuncios/consultar"
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Anuncio].self) { response in
                switch response.result {
                case .success(let anuncios):
                    completion(.success(anuncios))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Función para registrar un nuevo anuncio
    func registrarAnuncio(_ anuncio: Anuncio, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://localhost:7070/anuncios/registrar"
        let params: [String: Any] = [
            "IDUsuario": 1,  // fijo por ahora
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido,
            "imagen": "path/test"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseMessage.self) { response in
                switch response.result {
                case .success(let responseMessage):
                    completion(.success(responseMessage.message))  
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

