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
        let url = "http://192.168.0.5:3000/anuncios/consultar"
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Anuncio].self) { response in
                switch response.result {
                case .success(let anuncios):
                    completion(.success(anuncios))
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let message = try JSONDecoder().decode(ResponseMessage.self, from: data)
                            print("Server error: \(message.message)")
                        } catch {
                            print("Decoding error message failed: \(error.localizedDescription)")
                        }
                    }
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    
    // Función para registrar un nuevo anuncio
    func registrarAnuncio(_ anuncio: Anuncio, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://192.168.0.5:3000/anuncios/registrar"
        let params: [String: Any] = [
            "IDUsuario": 1,  // fijo por ahora
            "titulo": anuncio.titulo,
            "contenido": anuncio.contenido,
            "imagen": ""
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
    
    // Función para eliminar un anuncio
        func eliminarAnuncio(idAnuncio: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = "http://192.168.0.5:3000/anuncios/eliminar/\(idAnuncio)"
            
            AF.request(url, method: .delete)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        completion(.success("Anuncio eliminado exitosamente"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    // Función para modificar anuncio
    func modificarAnuncio(idAnuncio: String, titulo: String, contenido: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = "http://192.168.0.5:3000/anuncios/modificar/\(idAnuncio)"
            
            let params: [String: Any] = [
                "IDUsuario": 1,
                "titulo": titulo,
                "contenido": contenido,
                "imagen": "path/test"
            ]
            
            AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        completion(.success("Anuncio modificado exitosamente."))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}

