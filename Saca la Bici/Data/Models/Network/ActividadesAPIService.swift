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
    
    func consultarActividadIndividual(url: URL, actividadID: String) async -> ActividadIndividualResponse? {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        let parameters: Parameters = [
            "id": actividadID
        ]
        
        let taskRequest = session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto ActividadIndividualResponse
                let response = try JSONDecoder().decode(ActividadIndividualResponse.self, from: data)
                
                return response
                
            } catch {
                debugPrint("Error de decodificación: \(error.localizedDescription)")
                return nil
            }
        case let .failure(error):
            debugPrint("Error en la solicitud: \(error.localizedDescription)")
            
            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
            }
            return nil
        }
    }
    
    func inscribirActividad(url: URL, actividadId: String, tipo: String) async throws -> ActionResponse {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "actividadId": actividadId,
            "tipo": tipo
        ]
        
        let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        
        let response = await taskRequest.serializingDecodable(ActionResponse.self).response
        
        switch response.result {
        case .success(let actionResponse):
            return actionResponse
        case .failure(let error):
            debugPrint("Error en inscribirActividad: \(error.localizedDescription)")
            if let data = response.data {
                let errorResponse = try? JSONDecoder().decode(ActionResponse.self, from: data)
                if let errorResponse = errorResponse {
                    throw NSError(
                        domain: "",
                        code: response.response?.statusCode ?? 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: errorResponse.message
                        ]
                    )
                }
            }
            throw error
        }
    }

    func cancelarAsistencia(url: URL, actividadId: String, tipo: String) async throws -> ActionResponse {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "actividadId": actividadId,
            "tipo": tipo
        ]

        let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()

        let response = await taskRequest.serializingDecodable(ActionResponse.self).response

        switch response.result {
        case .success(let actionResponse):
            return actionResponse
        case .failure(let error):
            debugPrint("Error en cancelarAsistencia: \(error.localizedDescription)")
            if let data = response.data {
                let errorResponse = try? JSONDecoder().decode(ActionResponse.self, from: data)
                if let errorResponse = errorResponse {
                    throw NSError(
                        domain: "",
                        code: response.response?.statusCode ?? 500,
                        userInfo: [
                            NSLocalizedDescriptionKey: errorResponse.message
                        ]
                    )
                }
            }
            throw error
        }
    }
    
    func verificarAsistencia(url: URL, IDRodada: String, codigo: String) async -> AsistenciaResponse? {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)", // Incluye el token en el header de autorización
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "IDRodada": IDRodada,
            "codigo": codigo
        ]
            
        let taskRequest = session.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        let response = await taskRequest.serializingData().response
            
        switch response.result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(AsistenciaResponse.self, from: data)
                
                return response
            } catch {
                return nil
            }
        case let .failure(error):
            debugPrint(error.localizedDescription)
            
            // Imprimir el cuerpo de la respuesta en caso de error
            if let data = response.data {
                let errorResponse = String(decoding: data, as: UTF8.self)
                print("\(errorResponse)")
                
                do {
                    let response = try JSONDecoder().decode(AsistenciaResponse.self, from: data)
                    
                    return response
                } catch {
                    return nil
                }
            }
            
            return nil
        }
    }
    
    func getActividades(url: URL) async throws -> [ActividadInscrita] {
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Token Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let actividadesResponse = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(ActividadesApiResponse.self)
                .value
            
            print("Pero NOOO falOOO!!!!!!")
            return actividadesResponse.actividadesInscritas
        } catch {
            print("Error al obtener actividades: \(error.localizedDescription)")
            throw error
        }
        
        ActividadInscrita(
                    id: "6700e026cc2be498b7754322",
                    informacion: [
                        Actividad(
                            id: "6700e026cc2be498b7754323",
                            titulo: "Rodada para conocer el Tec 🐏💙",
                            fecha: "2024-10-17T06:00:00.000Z",
                            hora: "20:30",
                            personasInscritas: 16,
                            ubicacion: "Prepa Tec, Epigmenio González 500, Tecnologico, 76159 Santiago de Querétaro, Qro.",
                            descripcion: "Rodada para conocer el nuevo edificio-plaza inagurado en el Tec de Monterrey, en camino al 50 aniversario del campus 🥳\\n¡Habrá divertidas dinámicas!",
                            estado: true,
                            duracion: "1 horas 30 minutos",
                            imagen: "1728110630129-tempFile.jpg",
                            tipo: "Rodada",
                            foro: "6700e026cc2be498b7754325",
                            usuariosInscritos: [
                                "lV17ope3tCdu1M0Pb5XPxpK6kSm1",
                                "yrxjip0wc7SpT4Pomt5eLSRZktE2",
                                "3WCQvp4Q40Wvj0xo4wIVmKRor9x1",
                                "1HIvrQp8cxWMmFhsWNdlDIWX3Vw1",
                                "i3U8THsjyPbS710KQ1oc5Nz5a9e2",
                                "IYw6N9i4MnNfe2HPVK3gAapHNBy1",
                                "K6M1sVG00aPik39oWC0jhkQ0ji23",
                                "NYszotiU7tPdXlZHcjtuTmnRzfP2",
                                "cnVpVzTygHVtQC0g5ajSYl9NwPJ3",
                                "jdFAQBGM3qaJQjkYblAZWTgmIVI2",
                                "ono7nZjRxHX00oWjk3gx89KFVMO2",
                                "jFHBpEGFyYXEohyBBCYhZju3ltm1",
                                "2USL1Uxazec82wbrwKP6c5WDEt03",
                                "MQHYCeVIUgMSdIUne9yMB24kbUq1",
                                "JyrT55TQmTVtCalmFpbBwfW1CCc2",
                                "Xfph2DhYsBQ1zuhiJC9KwqyC6lG3"
                            ],
                            fechaFin: "2024-10-17T22:00:00.000Z"
                        )
                    ],
                    ruta: Ruta(
                        id: "66ff205116524713c4b15365",
                        titulo: "Ruta Tec",
                        distancia: "4.95 km",
                        tiempo: "2 horas 0 minutos",
                        nivel: "Nivel 3",
                        coordenadas: [
                            Coordenada(
                                latitud: 20.58937473356663,
                                longitud: -100.41033982746183,
                                tipo: "start",
                                id: "6701e0cf49d321638527bbad"
                            ),
                            Coordenada(
                                latitud: 20.600246297344214,
                                longitud: -100.37680076763117,
                                tipo: "end",
                                id: "6701e0cf49d321638527bbb1"
                            )
                        ]
                    ),
                    ubicacion: [
                        Ubicacion(
                            latitud: 20.6125109,
                            longitud: -100.403457,
                            id: "670f05ebd1ead61812a2ab1f"
                        )
                    ],
                    codigoAsistencia: 8642,
                    usuariosVerificados: [
                        "K6M1sVG00aPik39oWC0jhkQ0ji23",
                        "jFHBpEGFyYXEohyBBCYhZju3ltm1",
                        "MQHYCeVIUgMSdIUne9yMB24kbUq1",
                        "Xfph2DhYsBQ1zuhiJC9KwqyC6lG3"
                    ]
                )
        
        
    }
    
}
