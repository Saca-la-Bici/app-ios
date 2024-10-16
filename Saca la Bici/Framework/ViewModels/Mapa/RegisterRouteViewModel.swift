import Foundation
import CoreLocation
import FirebaseAuth
import SwiftUI

class RegisterRouteViewModel: ObservableObject {
    // Bindings desde la Vista
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    
    // Estado interno
    @Published var title: String = ""
    @Published var duration: String = ""
    @Published var selectedLevel: Int = 1
    @Published var isSubmitting: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var message: String = ""
    
    let levels = ["Nivel 1", "Nivel 2", "Nivel 3", "Nivel 4", "Nivel 5"]
    
    init(routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>, isAddingRoute: Binding<Bool>) {
        self._routeCoordinates = routeCoordinates
        self._distance = distance
        self._isAddingRoute = isAddingRoute
    }
    
    func undoLastPoint() {
        if !routeCoordinates.isEmpty {
            routeCoordinates.removeLast()
            message = "Último punto deshecho."
        }
    }
    
    func submitRoute() {
        if routeCoordinates.count == 7 {
            isSubmitting = true
            
            let routeDetails = RouteDetails(
                titulo: title,
                distancia: String(format: "%.2f", distance),
                tiempo: duration,
                nivel: levels[selectedLevel - 1],
                start: routeCoordinates[0],
                stopover1: routeCoordinates[1],
                stopover2: routeCoordinates[2],
                descanso: routeCoordinates[3],
                stopover3: routeCoordinates[4],
                stopover4: routeCoordinates[5],
                end: routeCoordinates[6]
            )
            
            // Token de Firebase
            Auth.auth().currentUser?.getIDToken { [weak self] idToken, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error al obtener el ID token: \(error.localizedDescription)")
                    self.isSubmitting = false
                    self.alertMessage = "Error al obtener el token de autenticación."
                    self.showAlert = true
                    return
                }
                
                guard let idToken = idToken else {
                    print("No se pudo obtener el ID token.")
                    self.isSubmitting = false
                    self.alertMessage = "No se pudo obtener el token de autenticación."
                    self.showAlert = true
                    return
                }

                RouteAPIService.shared.sendRoute(routeDetails: routeDetails, idToken: idToken) { success in
                    DispatchQueue.main.async {
                        self.isSubmitting = false
                        if success {
                            self.alertMessage = "Ruta registrada exitosamente."
                        } else {
                            self.alertMessage = "Error al registrar la ruta, verifica todos los campos."
                        }
                        self.showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Debe seleccionar exactamente 7 puntos para registrar la ruta."
            showAlert = true
        }
    }
}
