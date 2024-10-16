import Foundation
import CoreLocation

struct RouteDetails {
    let titulo: String
    let distancia: String
    let tiempo: String
    let nivel: String
    let start: CLLocationCoordinate2D
    let stopover1: CLLocationCoordinate2D
    let stopover2: CLLocationCoordinate2D
    let descanso: CLLocationCoordinate2D
    let stopover3: CLLocationCoordinate2D
    let stopover4: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
}

class RouteAPIService {
    static let shared = RouteAPIService()
    let baseURL = "http://18.220.205.53:8080/mapa/registrarRuta"

    // Enviar la ruta al servidor
    func sendRoute(routeDetails: RouteDetails, idToken: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Error: URL inválida")
            completion(false)
            return
        }

        // Validar coordenadas y distancia
        if routeDetails.distancia.isEmpty || routeDetails.distancia == "NaN" ||
           routeDetails.start.latitude.isNaN || routeDetails.start.longitude.isNaN ||
           routeDetails.stopover1.latitude.isNaN || routeDetails.stopover1.longitude.isNaN ||
           routeDetails.stopover2.latitude.isNaN || routeDetails.stopover2.longitude.isNaN ||
           routeDetails.descanso.latitude.isNaN || routeDetails.descanso.longitude.isNaN ||
           routeDetails.stopover3.latitude.isNaN || routeDetails.stopover3.longitude.isNaN ||
           routeDetails.stopover4.latitude.isNaN || routeDetails.stopover4.longitude.isNaN ||
           routeDetails.end.latitude.isNaN || routeDetails.end.longitude.isNaN {
            print("Error: Coordenadas o distancia inválidas (NaN)")
            completion(false)
            return
        }

        // Solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")  
        request.timeoutInterval = 60.0

        // JSON con los datos de la ruta
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

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud HTTP: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta: \(httpResponse.statusCode)")

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Respuesta del servidor: \(responseString)")
                }

                if httpResponse.statusCode == 200 {
                    print("Ruta registrada exitosamente.")
                    completion(true)
                } else {
                    print("Error en la respuesta del servidor: Código \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("No se recibió una respuesta HTTP válida.")
                completion(false)
            }
        }

        task.resume()
    }
}
