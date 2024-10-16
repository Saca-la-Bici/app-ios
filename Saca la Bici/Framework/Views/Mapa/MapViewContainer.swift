import SwiftUI
import MapboxMaps
import CoreLocation

struct MapViewContainer: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    @Binding var message: String
    
    @ObservedObject private var viewModel: MapViewModel
    
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
        
        viewModel.mapView = mapView
        viewModel.setupAnnotationManagers()
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        if routeCoordinates.count == 7 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.getRoute() // Método accesible
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel)
    }
    
    class Coordinator: NSObject {
        var viewModel: MapViewModel
        
        init(_ viewModel: MapViewModel) {
            self.viewModel = viewModel
        }
        
        @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
            viewModel.handleMapTap(sender)
        }
    }
}
