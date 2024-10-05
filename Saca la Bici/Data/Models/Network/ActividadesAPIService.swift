//
//  ActividadesAPIService.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Alamofire
import Foundation

class ActividadesAPIService {
    
    static let shared = ActividadesAPIService()
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
        self.firebaseTokenManager = firebaseTokenManager
    }
    
    // Crear una sesión personalizada con tiempos de espera ajustados
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())
    
    func fetchRodadas(url: URL) async throws -> RodadasApiResponse {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: RodadasApiResponse.self) { response in
                    switch response.result {
                    case .success(let rodadasApiResponse):
                        continuation.resume(returning: rodadasApiResponse)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchEventos(url: URL) async throws -> EventosApiResponse {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: EventosApiResponse.self) { response in
                    switch response.result {
                    case .success(let eventosApiResponse):
                        continuation.resume(returning: eventosApiResponse)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchTalleres(url: URL) async throws -> TalleresApiResponse {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: TalleresApiResponse.self) { response in
                    switch response.result {
                    case .success(let talleresApiResponse):
                        continuation.resume(returning: talleresApiResponse)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func registrarActividad(url: URL, actividad: DatosActividad) async throws -> Int? {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "multipart/form-data"
        ]

        let parameters: [String: String] = [
            "informacion[titulo]": actividad.titulo,
            "informacion[fecha]": actividad.fecha,
            "informacion[hora]": actividad.hora,
            "informacion[ubicacion]": actividad.ubicacion,
            "informacion[descripcion]": actividad.descripcion,
            "informacion[duracion]": actividad.duracion,
            "informacion[tipo]": actividad.tipo
        ]

        var extraParams = parameters
        if actividad.tipo == "Rodada" {
            extraParams["ruta"] = "66f59a62e3e99679a7509cf6"
        }

        let taskRequest = session.upload(multipartFormData: { multipartFormData in
            // Añadir los parámetros de texto
            for (key, value) in extraParams {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
            // Añadir la imagen si existe
            if let data = actividad.imagen {
                multipartFormData.append(data, withName: "file", fileName: "imagen.jpg", mimeType: "image/jpeg")
            }
        }, to: url, headers: headers)
        .validate()

        let response = await taskRequest.serializingData().response

        let statusCode = response.response?.statusCode

        switch response.result {
        case .success:
            return statusCode

        case let .failure(error):
            debugPrint(error.localizedDescription)

            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
            }

            if let afError = error.asAFError {
                switch afError {
                case .sessionTaskFailed(let urlError as URLError):
                    // Re-lanzar para manejar específicamente en el SessionManager
                    throw urlError
                default:
                    // Otros errores de Alamofire
                    throw afError
                }
            } else {
                throw error
            }
        }
    }
}
