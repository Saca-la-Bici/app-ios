import SwiftUI
import MapboxMaps
import CoreLocation
import MapboxDirections

struct MapViewContainer: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    @Binding var message: String
    let locationManager = CLLocationManager()

    let directions: Directions = {
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            fatalError("No esta Mapbox en el .plist")
        }
        return Directions(credentials: Credentials(accessToken: accessToken))
    }()

    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(styleURI: .streets)
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 14)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        context.coordinator.mapView = mapView
        context.coordinator.setupAnnotationManagers()
        
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        if routeCoordinates.count == 7 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                context.coordinator.getRoute()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, routeCoordinates: $routeCoordinates, distance: $distance, isAddingRoute: $isAddingRoute, message: $message)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapViewContainer
        var routeCoordinates: Binding<[CLLocationCoordinate2D]>
        var distance: Binding<Double>
        var isAddingRoute: Binding<Bool>
        var message: Binding<String>
        var mapView: MapView?
        var pointAnnotationManager: PointAnnotationManager?
        var polylineAnnotationManager: PolylineAnnotationManager?

        init(_ parent: MapViewContainer, routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>, isAddingRoute: Binding<Bool>, message: Binding<String>) {
            self.parent = parent
            self.routeCoordinates = routeCoordinates
            self.distance = distance
            self.isAddingRoute = isAddingRoute
            self.message = message
        }

        func setupAnnotationManagers() {
            guard let mapView = mapView else { return }
            pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        }

        @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
            guard isAddingRoute.wrappedValue else {
                print("No está permitido registrar puntos en este modo.")
                return
            }
            
            guard let mapView = mapView else { return }
            let location = sender.location(in: mapView)
            let coordinate = mapView.mapboxMap.coordinate(for: location)
            
            if routeCoordinates.wrappedValue.count < 7 {
                routeCoordinates.wrappedValue.append(coordinate)
                let index = routeCoordinates.wrappedValue.count - 1
                addMarker(at: coordinate, index: index)
                
                let pointName = getPointName(for: index)
                message.wrappedValue = "\(pointName) registrado con éxito."
                print("Punto \(pointName) agregado: \(coordinate)")
                
                if routeCoordinates.wrappedValue.count == 7 {
                    print("Se han seleccionado los 7 puntos. Calculando ruta...")
                }
            } else {
                print("Solo se permiten siete puntos.")
            }
        }

        func getPointName(for index: Int) -> String {
            switch index {
            case 0:
                return "Inicio"
            case 1, 2:
                return "Punto de referencia \(index)"
            case 3:
                return "Descanso"
            case 4, 5:
                return "Punto de referencia \(index - 2)"
            case 6:
                return "Fin"
            default:
                return "Punto desconocido"
            }
        }

        func undoLastPoint() {
            if !routeCoordinates.wrappedValue.isEmpty {
                let removedPoint = routeCoordinates.wrappedValue.removeLast()
                print("Punto deshecho: \(removedPoint)")
                message.wrappedValue = "Último punto deshecho con éxito."
            }
        }

        func addMarker(at coordinate: CLLocationCoordinate2D, index: Int) {
            guard let pointAnnotationManager = pointAnnotationManager else {
                print("PointAnnotationManager no está inicializado.")
                return
            }

            var pointAnnotation = PointAnnotation(coordinate: coordinate)

            switch index {
            case 0:
                // Icono de inicio 
                pointAnnotation.image = .init(image: UIImage(named: "start-icon")!, name: "start-icon")
                pointAnnotation.iconSize = 0.05
            case 3:
                // Icono de descanso
                pointAnnotation.image = .init(image: UIImage(named: "rest-icon")!, name: "rest-icon")
                pointAnnotation.iconSize = 0.05
            case 6:
                // Icono de fin
                pointAnnotation.image = .init(image: UIImage(named: "end-icon")!, name: "end-icon")
                pointAnnotation.iconSize = 0.05
            default:
                pointAnnotation.iconColor = StyleColor(.gray)
            }

            pointAnnotationManager.annotations.append(pointAnnotation)
        }

        func makePointAnnotation(at coordinate: CLLocationCoordinate2D, color: UIColor) -> PointAnnotation {
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            pointAnnotation.iconColor = StyleColor(color)
            return pointAnnotation
        }

        func getRoute() {
            print("Iniciando cálculo de ruta...")
            guard routeCoordinates.wrappedValue.count == 7 else {
                print("Número incorrecto de puntos para calcular la ruta.")
                return
            }
            
            // Verificar coordenadas
            for (index, coordinate) in routeCoordinates.wrappedValue.enumerated() {
                print("Coordenada \(index): \(coordinate.latitude), \(coordinate.longitude)")
            }
            
            let waypoints = routeCoordinates.wrappedValue.map { Waypoint(coordinate: $0) }
            let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)

            parent.directions.calculate(options) { [self] (_, result) in
                switch result {
                case .failure(let error):
                    print("Error calculando la ruta: \(error.localizedDescription)")
                case .success(let response):
                    guard let route = response.routes?.first else {
                        print("No se encontró ninguna ruta.")
                        return
                    }
                    
                    if let geometry = route.shape {
                        DispatchQueue.main.async {
                            self.drawRoute(geometry.coordinates)
                            self.distance.wrappedValue = route.distance / 1000
                            print("Ruta calculada correctamente con \(routeCoordinates.wrappedValue.count) puntos.")
                            print("Distancia calculada: \(self.distance.wrappedValue) km")
                        }
                    }
                }
            }
        }

        func drawRoute(_ routeCoordinates: [CLLocationCoordinate2D]) {
            guard let polylineAnnotationManager = polylineAnnotationManager else {
                print("PolylineAnnotationManager no está inicializado.")
                return
            }
            
            polylineAnnotationManager.annotations = []
            
            // Verifica puntos
            guard routeCoordinates.count >= 7 else {
                print("Error: Las coordenadas de la ruta están incompletas.")
                return
            }

            // Segmento del inicio hasta el descanso
            let firstSegment = Array(routeCoordinates.prefix(through: 3))
            var polyline1 = PolylineAnnotation(lineCoordinates: firstSegment)
            polyline1.lineColor = StyleColor(.green)
            polyline1.lineWidth = 2.5

            // Segmento del descanso hasta el fin
            let secondSegment = Array(routeCoordinates.suffix(from: 3))
            var polyline2 = PolylineAnnotation(lineCoordinates: secondSegment)
            polyline2.lineColor = StyleColor(.red)
            polyline2.lineWidth = 2.5
            
            // Añade anotaciones del mapa
            polylineAnnotationManager.annotations.append(polyline1)
            polylineAnnotationManager.annotations.append(polyline2)
            
            print("Ruta dibujada correctamente con \(routeCoordinates.count) puntos.")
        }
    }
}
