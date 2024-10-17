import SwiftUI
import MapboxMaps
import CoreLocation

struct MapViewContainer: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    @Binding var message: String

    private var viewModel: MapViewModel

    init(routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>, isAddingRoute: Binding<Bool>, message: Binding<String>) {
        self._routeCoordinates = routeCoordinates
        self._distance = distance
        self._isAddingRoute = isAddingRoute
        self._message = message
        self.viewModel = MapViewModel(routeCoordinates: routeCoordinates, distance: distance, isAddingRoute: isAddingRoute, message: message)
    }
    
    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(styleURI: .streets)
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 14)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        context.coordinator.setMapView(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        if routeCoordinates.count == 7 {
            DispatchQueue.main.async {
                context.coordinator.getRouteIfNeeded()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        private var viewModel: MapViewModel

        init(viewModel: MapViewModel) {
            self.viewModel = viewModel
        }

        func setMapView(_ mapView: MapView) {
            viewModel.mapView = mapView
            viewModel.setupAnnotationManagers()
        }
        
        @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
            viewModel.handleMapTap(sender)
        }

        func getRouteIfNeeded() {
            if viewModel.routeCoordinates.count == 7 {
                viewModel.getRoute()
            }
        }
    }
}
