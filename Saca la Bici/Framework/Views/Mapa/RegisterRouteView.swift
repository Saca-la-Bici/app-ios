import SwiftUI
import MapboxMaps

struct RegisterRouteView: View {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    
    @State private var title: String = ""
    @State private var duration: String = ""
    @State private var selectedLevel: Int = 1
    
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
                        
                        Text("Distancia: \(distance, specifier: "%.2f") km ")
                            .padding()
                    }
                    
                    MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute)
                        .frame(height: 400)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Button(action: {
                print("Ruta registrada: \(routeCoordinates)")
            }) {
                Text("Registrar Ruta")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(routeCoordinates.count == 3 ? Color.yellow : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
            .disabled(routeCoordinates.count != 3)
        }
        .padding(.top)
        .navigationTitle("Agrega una ruta")
        .onAppear {
            // Habilitar agregar ruta
            isAddingRoute = true
        }
        .onDisappear {
            // Deshabilitar agregar ruta cuando se sale de la pantalla
            isAddingRoute = false
        }
    }
}
