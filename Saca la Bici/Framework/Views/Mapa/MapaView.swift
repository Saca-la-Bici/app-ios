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
                            NavigationLink(destination: RegisterRouteView(routeCoordinates: $routeCoordinates,
                                distance: $distance,
                                isAddingRoute: $isAddingRoute)) {
                                ZStack {
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 50, height: 50)
                                        .shadow(radius: 8)
                                    
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold))
                                }
                            }
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Mapa")
        }
    }
}
