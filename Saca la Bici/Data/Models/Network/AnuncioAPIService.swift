//
//  AnuncioAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class AnuncioAPIService {
    
    // Función para obtener los anuncios existentes
    func fetchAnuncios(url: URL, completion: @escaping (Result<[Anuncio], Error>) -> Void) {
        obtenerIDToken { idToken in
            guard let idToken = idToken else {
                completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]

            AF.request(url, method: .get, headers: headers)
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
    }

    
    // Función para registrar un nuevo anuncio
    func registrarAnuncio(_ anuncio: Anuncio, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "http://192.168.0.5:3000/anuncios/registrar"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        obtenerIDToken { idToken in
            guard let idToken = idToken else {
                completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]

            let params: [String: Any] = [
                "titulo": anuncio.titulo,
                "contenido": anuncio.contenido,
                "imagen": ""
            ]

            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
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


    
    // Función para eliminar un anuncio
    func eliminarAnuncio(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        obtenerIDToken { idToken in
            guard let idToken = idToken else {
                completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]

            AF.request(url, method: .delete, headers: headers)
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
    }

    
    // Función para modificar anuncio
    func modificarAnuncio(url: URL, titulo: String, contenido: String, completion: @escaping (Result<String, Error>) -> Void) {
        obtenerIDToken { idToken in
            guard let idToken = idToken else {
                completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]

            let params: [String: Any] = [
                "titulo": titulo,
                "contenido": contenido,
                "imagen": "path/test"
            ]

            AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
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

    
    // Función para obtener el ID Token del usuario autenticado
        func obtenerIDToken(completion: @escaping (String?) -> Void) {
            guard let user = Auth.auth().currentUser else {
                completion(nil)
                return
            }
            
            user.getIDToken { idToken, error in
                if let error = error {
                    print("Error al obtener el ID Token: \(error)")
                    completion(nil)
                    return
                }
                
                completion(idToken)
            }
        }
}
