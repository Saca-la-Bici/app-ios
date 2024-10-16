//
//  RouteDetails.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 16/10/24.
//

import CoreLocation

struct RouteDetails {
    let titulo: String
    let distancia: String
    let tiempo: String
    let nivel: String
    let start: CLLocationCoordinate2D
    let stopover1: CLLocationCoordinate2D
    let stopover2: CLLocationCoordinate2D
    let descanso: CLLocationCoordinate2D
    let stopover3: CLLocationCoordinate2D
    let stopover4: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
}
