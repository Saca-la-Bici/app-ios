//
//  RutasAPIService.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 15/10/24.
//

import Alamofire
import Foundation

class RutasAPIService {
    
    static let shared = RutasAPIService()
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
            self.firebaseTokenManager = firebaseTokenManager
        }
    
    let session = Session(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 7.5 // Tiempo de espera de 7.5 segundos para la solicitud
        configuration.timeoutIntervalForResource = 15 // Tiempo de espera de 15 segundos para el recurso
        return configuration
    }())
    
    func getRutas(url: URL) async -> RutasResponse? {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            print("No se pudo obtener el ID Token")
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        let taskRequest = session.request(url, method: .get, headers: headers).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                // Intentar decodificar la respuesta JSON en un objeto RutasResponse
                let response = try JSONDecoder().decode(RutasResponse.self, from: data)
                
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
}
