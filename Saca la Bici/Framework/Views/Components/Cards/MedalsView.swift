//
//  ProfileMedals.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct MedalsView: View {
    @StateObject private var viewModel = MedalsViewModel()
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando medallas...")
                    .padding()
            } else if viewModel.errorMessage != nil {
                Text("Hubo un error al cargar las medallas")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            } else {
                if viewModel.medallas.isEmpty {
                    // Mostrar mensaje cuando no hay medallas
                    Text("Aún no has desbloqueado ninguna medalla")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    // Mostrar la cuadrícula de medallas
                    ScrollView {
                        LazyVGrid(columns: columnas, spacing: 20) {
                            ForEach(viewModel.medallas) { medalla in
                                VStack {
                                    AsyncImage(url: URL(string: medalla.imagen)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 60, height: 60)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    Text(medalla.nombre)
                                        .font(.system(size: 10))
                                        .foregroundColor(medalla.estado ? .black : .gray)
                                }
                                .padding()
                                .background(medalla.estado ? Color.white : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMedallas()
        }
    }
}
