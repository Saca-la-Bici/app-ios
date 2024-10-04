//
//  RutasService.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 03/10/24.
//

import Foundation

struct RutasService {
    static let shared = RutasService()
    
    func getRutasList(completion: @escaping ([RutasBase]?) -> Void) {
        guard let url = URL(string: "http://3.145.117.182:8080/mapa/consultarRutas") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let rutas = try JSONDecoder().decode([RutasBase].self, from: data)
                completion(rutas)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func sendRoute(
        titulo: String,
        distancia: String,
        tiempo: String,
        nivel: String,
        start: CoordenadasBase,
        stopover: CoordenadasBase,
        end: CoordenadasBase,
        completion: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: "http://3.145.117.182:8080/mapa/registrarRuta") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let coordinatesArray: [[String: Any]] = [
            ["latitud": start.latitud, "longitud": start.longitud, "tipo": "inicio"],
            ["latitud": stopover.latitud, "longitud": stopover.longitud, "tipo": "descanso"],
            ["latitud": end.latitud, "longitud": end.longitud, "tipo": "final"]
        ]

        let body: [String: Any] = [
            "titulo": titulo,
            "distancia": distancia,
            "tiempo": tiempo,
            "nivel": nivel,
            "coordenadas": coordinatesArray
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()
    }
}
