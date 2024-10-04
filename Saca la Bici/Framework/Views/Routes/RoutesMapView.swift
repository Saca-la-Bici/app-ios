//
//  RoutesMapView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 25/09/24.
//


import SwiftUI
import MapboxMaps

struct RoutesMapView: View {
    @State private var mapView: MapView?
    @State private var showAddRouteView = false
    @State private var showRouteListView = false
    @State private var startPoint: CoordenadasBase? = nil
    @State private var stopoverPoint: CoordenadasBase? = nil
    @State private var endPoint: CoordenadasBase? = nil

    var body: some View {
        ZStack {
            MapViewRepresentable(mapView: $mapView)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 15) {
                        // Botón para agregar una nueva ruta
                        Button(action: {
                            showAddRouteView.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }

                        // Botón para ver la lista de rutas
                        Button(action: {
                            showRouteListView.toggle()
                        }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .background(Color.red)
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                }
                Spacer()
            }
        }
        .onAppear {
            setMapToQueretaro()
        }
        .sheet(isPresented: $showAddRouteView) {
            RegisterRouteView(startPoint: $startPoint, stopoverPoint: $stopoverPoint, endPoint: $endPoint)
        }
        .sheet(isPresented: $showRouteListView) {
            RoutesListView()
        }
    }

    private func setMapToQueretaro() {
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 12.0)
        mapView?.camera.ease(to: cameraOptions, duration: 1.5)
    }
}
