import SwiftUI
import MapboxMaps

struct MapaView: View {
    @State private var isAddingRoute = false
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var distance: Double = 0.0
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute, message: $message)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 9) {
                            // Botón de agregar ruta
                            NavigationLink(destination: RegisterRouteView(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute)) {
                                ZStack {
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 50, height: 50) // Tamaño más pequeño
                                        .shadow(radius: 8)
                                    
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold)) // Fuente más pequeña
                                }
                            }
                            
                            // Botón adicional (similar al de sobre que se ve en la imagen)
                            Button(action: {
                                // Acción del botón de sobre
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 50, height: 50) // Tamaño más pequeño
                                        .shadow(radius: 8)
                                    
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold)) // Fuente más pequeña
                                }
                            }
                        }
                        .padding(.top, 50) // Ajusta este valor para moverlo más arriba
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Mapa")
        }
    }
}
