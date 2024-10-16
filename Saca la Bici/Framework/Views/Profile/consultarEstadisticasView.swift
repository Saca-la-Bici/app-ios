//
//  consultarEstadisticasView.swift
//  Saca la Bici
//
//  Created by Diego Lira on 16/10/24.
//

import SwiftUI

struct ConsultarEstadisticasView: View {
    @ObservedObject var viewModel = ConsultarPerfilPropioViewModel.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Agua ahorrada
                VStack(alignment: .leading) {
                    
                    Text("Ahorro de Recursos")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 15)
                    
                    HStack {
                        Text("Agua")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f L", (viewModel.maxWater)))
                            .font(.subheadline)
                    }

                    ProgressView(value: viewModel.waterSaved, total: viewModel.maxWater)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.vertical, 8)

                    Text("Ahorro de agua por usar la bicicleta: \(String(format: "%.2f L", viewModel.waterSaved))")
                        .font(.subheadline)
                }
                .padding()

                // CO2 no emitido
                VStack(alignment: .leading) {
                    HStack {
                        Text("CO₂")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f kg", viewModel.maxCO2))
                            .font(.subheadline)
                    }

                    ProgressView(value: viewModel.co2Saved, total: viewModel.maxCO2)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.vertical, 8)

                    Text("CO₂ no emitido por usar la bicicleta: \(String(format: "%.2f kg", viewModel.co2Saved))")
                        .font(.subheadline)
                }
                .padding()

                // Aire limpio
                VStack(alignment: .leading) {
                    HStack {
                        Text("Aire limpio")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f g", viewModel.maxAir))
                            .font(.subheadline)
                    }

                    ProgressView(value: viewModel.airCleaned, total: viewModel.maxAir)
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .padding(.vertical, 8)

                    Text("Aire limpio generado: \(String(format: "%.2f g", viewModel.airCleaned))")
                        .font(.subheadline)
                }
                .padding()

                // Gasolina ahorrada
                VStack(alignment: .leading) {
                    HStack {
                        Text("Gasolina")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f L", viewModel.maxGas))
                            .font(.subheadline)
                    }

                    ProgressView(value: viewModel.gasSaved, total: viewModel.maxGas)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .padding(.vertical, 8)

                    Text("Gasolina ahorrada por usar la bicicleta: \(String(format: "%.2f L", viewModel.gasSaved))")
                        .font(.subheadline)
                    
                    Text("Todos los datos se obtuvieron usando un coche Versa como base")
                        .font(.caption)
                        .padding(.top, 30)
                }
                .padding()
            }
            .padding()
        }
        .onAppear {
            viewModel.calcularEstadisticas(kilometers: Float(viewModel.profile?.kilometrosMes ?? 0))
        }
    }
}
