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
            extraParams["ruta"] = actividad.ruta
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
        
        let parameters: [String: String] = [
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
    
    func modificarActividad(url: URL, id: String, datosActividad: ModificarActividadModel) async throws -> ActionResponse {
        
        // Obtener token de Firebase
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        print("ID Token: \(idToken)")
        
        // Subdiccionario de Informacion
        let informacion: [String: String] = [
            "titulo": datosActividad.titulo,
            "fecha": datosActividad.fecha,
            "hora": datosActividad.hora,
            "ubicacion": datosActividad.ubicacion,
            "descripcion": datosActividad.descripcion,
            "duracion": datosActividad.duracion,
            "tipo": datosActividad.tipo,
            "personasInscritas": String(datosActividad.personasInscritas),
            "estado": String(datosActividad.estado),
            "foro": datosActividad.foro ?? ""
        ]
        
        // Array de usuarios inscritos
        let usuariosInscritos: [String] = datosActividad.usuariosInscritos ?? []
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in

                // Añadir cada campo dentro de 'informacion'
                for (key, value) in informacion {
                    multipartFormData.append(Data(value.utf8), withName: "informacion[\(key)]")
                }

                // Añadir la imagen (si existe)
                if let imageData = datosActividad.imagen {
                    multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                
                // Añadir usuarios inscritos
                for (index, usuario) in usuariosInscritos.enumerated() {
                    if let usuarioData = usuario.data(using: .utf8) {
                        multipartFormData.append(usuarioData, withName: "usuariosInscritos[\(index)]")
                    }
                }
                
                // Añadir ruta
                if let rutaData = datosActividad.ruta?.data(using: .utf8) {
                    multipartFormData.append(rutaData, withName: "ruta")
                }
                
            }, to: url, method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: ActionResponse.self) { response in
                switch response.result {
                case .success(let actionResponse):
                    continuation.resume(returning: actionResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func eliminarActividad(url: URL, id: String, tipo: String ) async throws -> EliminarActividadResponse {
        
        // Obtener token de Firebase
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]

        // Parametros
        let parameters: Parameters = [
            "id": id,
            "tipo": tipo
        ]
        
        do {
            
            let response = try await AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .serializingDecodable(EliminarActividadResponse.self)
                .value
            
            return response
            
        } catch {
            print("Error al eliminar actividad: \(error)")
            throw error
        }
        
    }
}
