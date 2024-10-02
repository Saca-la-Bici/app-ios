//
//  FAQAPIService.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class FAQAPIService {
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
            self.firebaseTokenManager = firebaseTokenManager
        }
    
    private func getIDToken() async throws -> String? {
        do {
            guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
            }
            
            return idToken
        } catch {
            print("Error al obtener IDToken: \(error)")
            throw error
        }
    }
    
    // Fetch FAQs
    func fetchFAQs(url: URL) async throws -> FAQResponse {
        
        let idToken = try await getIDToken()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken!)",
            "Content-Type": "application/json"
        ]
        
        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(FAQResponse.self)
                .value
            
            return response
        } catch {
            print("Error al obtener FAQs: \(error)")
            throw error
        }
    }
    
    // Fetch one FAQ
    func fetchFAQ(url: URL) async throws -> FAQResponse {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(FAQResponse.self)
                .value
            
            return response
        } catch {
            print("Error al obtener FAQ: \(error)")
            throw error
        }
        
    }
    
    // Add FAQ
    func addFAQ(url: URL, faq: FAQ) async throws -> String {
        
        let idToken = try await getIDToken()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken!)",
            "Content-Type": "application/json"
        ]
        
        
        let params: Parameters = [
            "IdPregunta": faq.IdPregunta,
            "Pregunta": faq.Pregunta,
            "Respuesta": faq.Respuesta,
            "Tema": faq.Tema,
            "Imagen": faq.Imagen
        ]
        
        do {
            let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .serializingDecodable(FAQResponse.self)
                .value
            
            return response.msg
        } catch {
            print("Error al añadir FAQ: \(error)")
            throw error
        }
        
    }
    
    // Update FAQ
    func updateFAQ(url: URL, faq: FAQ) async throws -> String {
        
        let idToken = try await getIDToken()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken!)",
            "Content-Type": "application/json"
        ]
        
        let params: Parameters = [
            "Pregunta": faq.Pregunta,
            "Respuesta": faq.Respuesta,
            "Tema": faq.Tema,
            "Imagen": faq.Imagen
        ]
        
        do {
            let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .serializingDecodable(UpdateFAQResponse.self)
                .value
            
            return response.msg
        } catch {
            print("Error al modificar FAQ: \(error)")
            throw error
        }
    }
    
}

