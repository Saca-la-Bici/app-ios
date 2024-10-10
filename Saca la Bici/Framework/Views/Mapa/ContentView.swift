import SwiftUI
import MapboxMaps

struct ContentView: View {
    @State private var isAddingRoute = false
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var distance: Double = 0.0

    var body: some View {
        NavigationView {
            ZStack {
                MapViewContainer(routeCoordinates: $routeCoordinates, distance: $distance)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: RegisterRouteView()) {
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
