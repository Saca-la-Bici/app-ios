import Foundation
import CoreLocation

class RouteAPIService {
    static let shared = RouteAPIService()
    let baseURL = "http://18.220.205.53:8080/mapa/registrarRuta"

    func sendRoute(routeDetails: RouteDetails, idToken: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Error: URL inválida")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60.0

        let json: [String: Any] = [
            "titulo": routeDetails.titulo,
            "distancia": routeDetails.distancia,
            "tiempo": routeDetails.tiempo,
            "nivel": routeDetails.nivel,
            "coordenadas": [
                ["latitud": routeDetails.start.latitude, "longitud": routeDetails.start.longitude, "tipo": "inicio"],
                ["latitud": routeDetails.stopover1.latitude, "longitud": routeDetails.stopover1.longitude, "tipo": "referencia"],
                ["latitud": routeDetails.stopover2.latitude, "longitud": routeDetails.stopover2.longitude, "tipo": "referencia"],
                ["latitud": routeDetails.descanso.latitude, "longitud": routeDetails.descanso.longitude, "tipo": "descanso"],
                ["latitud": routeDetails.stopover3.latitude, "longitud": routeDetails.stopover3.longitude, "tipo": "referencia"],
                ["latitud": routeDetails.stopover4.latitude, "longitud": routeDetails.stopover4.longitude, "tipo": "referencia"],
                ["latitud": routeDetails.end.latitude, "longitud": routeDetails.end.longitude, "tipo": "final"]
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error al convertir los datos de la ruta a JSON: \(error.localizedDescription)")
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error en la solicitud HTTP: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }

        task.resume()
    }
}
