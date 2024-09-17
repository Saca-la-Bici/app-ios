//
//  SignUPAPIService.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation
import FirebaseAuth
import Alamofire
import FirebaseCore
import GoogleSignIn

// Singleton
class SignUpAPIService {
    // Se usa la libería de Alamofire y se usa static let para que sea inmutable y si se crean varias instancias que sea igual para todas dichas instancias.
    static let shared = SignUpAPIService()
    
    // Crear una sesión personalizada con tiempos de espera ajustados
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 5 segundos para el recurso
        return configuration
    }())
    
    func registrarUsuario(url: URL, UserDatos: UserNuevo, urlStatus: URL) async -> Int? {
        do {
            // Crear el usuario en Firebase Authentication
            let authResult = try await Auth.auth().createUser(withEmail: UserDatos.email, password: UserDatos.password)
            
            // Obtener el UID de Firebase Authentication
            let firebaseUID = authResult.user.uid
                       
            // Obtener el ID Token del usuario autenticado
            let idToken = try await authResult.user.getIDToken()
            
            let parameters: Parameters = [
                "username" : UserDatos.username,
                "nombre" : "Juan Pérez",
                "edad" : 20,
                "correoElectronico" : UserDatos.email,
                "tipoSangre": UserDatos.tipoSangre,
                "numeroEmergencia": UserDatos.numeroEmergencia,
                "firebaseUID": firebaseUID
            ]
                       
            // Preparar los headers con el ID Token para enviarlo al backend
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(idToken)",
                "Content-Type": "application/json"
            ]
            
            let taskRequest = session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            let response = await taskRequest.serializingData().response
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(_):
                return statusCode
                
            case let .failure(error):
                // Eliminar el usuario de Firebase porque falló el backend
                try await authResult.user.delete()
                
                debugPrint(error.localizedDescription)
                    
                // Imprimir el cuerpo de la respuesta en caso de error
                if let data = response.data {
                    let errorResponse = String(decoding: data, as: UTF8.self)
                    print("\(errorResponse)")
                }
                
                return statusCode
            }
        } catch {
            print("Error al registrar en Firebase: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Función para obtener el ID Token de Firebase usando async/await
        private func obtenerIDToken() async -> String? {
            return await withCheckedContinuation { continuation in
                // Obtener el ID Token del usuario actual
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print("Error al obtener el ID Token: \(error.localizedDescription)")
                        continuation.resume(returning: nil)
                    } else if let idToken = idToken {
                        continuation.resume(returning: idToken)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
}

