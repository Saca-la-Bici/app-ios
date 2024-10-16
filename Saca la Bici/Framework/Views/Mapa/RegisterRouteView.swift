import SwiftUI
import MapboxMaps
import CoreLocation
import FirebaseAuth

struct RegisterRouteView: View {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    
    @State private var title: String = ""
    @State private var duration: String = ""
    @State private var selectedLevel: Int = 1
    @State private var isSubmitting: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var message: String = "" 

    let levels = ["Nivel 1", "Nivel 2", "Nivel 3", "Nivel 4", "Nivel 5"]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        TextField("Título", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        TextField("Duración (ej. 4h)", text: $duration)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Picker("Selecciona el nivel", selection: $selectedLevel) {
                            ForEach(1..<6) { level in
                                Text("Nivel \(level)").tag(level)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        Text("Distancia: \(distance, specifier: "%.2f") km")
                            .padding()
                    }
                    
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(.green)
                            .bold()
                            .padding()
                    }
                    
                    MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute, message: $message)
                        .frame(height: 400)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                if !routeCoordinates.isEmpty {
                    routeCoordinates.removeLast()
                    message = "Último punto deshecho."
                }
            }) {
                Text("Deshacer último punto")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!routeCoordinates.isEmpty ? Color.orange : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            .disabled(routeCoordinates.isEmpty)
            
            Button(action: {
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
                    Auth.auth().currentUser?.getIDToken { idToken, error in
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
                                isSubmitting = false
                                if success {
                                    alertMessage = "Ruta registrada exitosamente."
                                } else {
                                    alertMessage = "Error al registrar la ruta, verifica todos los campos."
                                }
                                showAlert = true
                            }
                        }
                    }
                    
                } else {
                    alertMessage = "Debe seleccionar exactamente 7 puntos para registrar la ruta."
                    showAlert = true
                }
            }) {
                Text(isSubmitting ? "Registrando..." : "Registrar Ruta")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(routeCoordinates.count == 7 ? Color.yellow : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
            .disabled(routeCoordinates.count != 7 || isSubmitting)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registro de Ruta"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding(.top)
        .navigationTitle("Agrega una ruta")
        .onAppear {
            isAddingRoute = true
        }
        .onDisappear {
            isAddingRoute = false
        }
    }
}
