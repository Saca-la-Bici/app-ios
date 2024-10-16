import SwiftUI
import MapboxMaps

struct ContentView: View {
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
