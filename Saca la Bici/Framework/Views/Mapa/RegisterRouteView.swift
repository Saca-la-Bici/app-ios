import SwiftUI
import MapboxMaps

struct RegisterRouteView: View {
    @State private var title: String = ""
    @State private var duration: String = ""
    @State private var selectedLevel: Int = 1
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var distance: Double = 0.0
    
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
                    
                    MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance)
                        .frame(height: 300)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            // Botón de registrar ruta
            Button(action: {
                print("Ruta registrada: \(routeCoordinates)")
            }) {
                Text("Registrar Ruta")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
        .navigationTitle("Agrega una ruta")
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
