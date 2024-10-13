import SwiftUI
import MapboxMaps

struct ContentView: View {
    @State private var isAddingRoute = false
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var distance: Double = 0.0

    var body: some View {
        NavigationView {
            ZStack {
                // Pasamos la variable isAddingRoute a MapViewContainer para controlar si se pueden registrar puntos
                MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        // Cambiamos isAddingRoute a true cuando se presiona el botón para registrar la ruta
                        NavigationLink(destination: RegisterRouteView(routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute)) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Mapa")
        }
    }
}
