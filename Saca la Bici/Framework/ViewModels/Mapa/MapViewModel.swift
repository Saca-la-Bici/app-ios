import Foundation
import CoreLocation
import MapboxMaps
import MapboxDirections
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    @Binding var isAddingRoute: Bool
    @Binding var message: String
    
    @Published var mapView: MapView?
    
    private let directions: Directions
    private var pointAnnotationManager: PointAnnotationManager?
    private var polylineAnnotationManager: PolylineAnnotationManager?
    
    init(routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>, isAddingRoute: Binding<Bool>, message: Binding<String>) {
        self._routeCoordinates = routeCoordinates
        self._distance = distance
        self._isAddingRoute = isAddingRoute
        self._message = message
        
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            fatalError("No está Mapbox en el .plist")
        }
        self.directions = Directions(credentials: Credentials(accessToken: accessToken))
        
        super.init()
    }
    
    func setupAnnotationManagers() {
        guard let mapView = mapView else { return }
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        setupLocation()
    }
    
    private func setupLocation() {
        guard let mapView = mapView else { return }
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions
    }

    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        guard isAddingRoute else {
            print("No está permitido registrar puntos en este modo.")
            return
        }
        
        guard let mapView = mapView else { return }
        let location = sender.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: location)
        
        if routeCoordinates.count < 7 {
            routeCoordinates.append(coordinate)
            let index = routeCoordinates.count - 1
            addMarker(at: coordinate, index: index)
            
            let pointName = getPointName(for: index)
            message = "\(pointName) registrado con éxito."
            print("Punto \(pointName) agregado: \(coordinate)")
            
            if routeCoordinates.count == 7 {
                print("Se han seleccionado los 7 puntos. Calculando ruta...")
                getRoute()
            }
        } else {
            print("Solo se permiten siete puntos.")
        }
    }

    private func addMarker(at coordinate: CLLocationCoordinate2D, index: Int) {
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

    private func getPointName(for index: Int) -> String {
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

    func getRoute() {
        print("Iniciando cálculo de ruta...")
        guard routeCoordinates.count == 7 else {
            print("Número incorrecto de puntos para calcular la ruta.")
            return
        }
        
        let waypoints = routeCoordinates.map { Waypoint(coordinate: $0) }
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)

        directions.calculate(options) { [weak self] (_, result) in
            guard let self = self else { return }
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
                        self.distance = route.distance / 1000
                        print("Ruta calculada correctamente con \(self.routeCoordinates.count) puntos.")
                        print("Distancia calculada: \(self.distance) km")
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
        
        guard routeCoordinates.count >= 7 else {
            print("Error: Las coordenadas de la ruta están incompletas.")
            return
        }

        var polyline = PolylineAnnotation(lineCoordinates: routeCoordinates)
        polyline.lineColor = StyleColor(.blue)
        polyline.lineWidth = 3.0
        
        polylineAnnotationManager.annotations.append(polyline)
        
        print("Ruta dibujada correctamente.")
    }
}
