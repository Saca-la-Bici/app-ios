//
//  AdminRodadasView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import SwiftUI

struct RodadasAdminView: View {
    @StateObject private var viewModel = RodadasViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(viewModel.rodadas) { rodada in
                        ActivityCardAdminView(
                            activityTitle: rodada.actividad.titulo,
                            activityType: "Rodada",
                            level: rodada.ruta.nivel,
                            date: formatDate(rodada.actividad.fecha),
                            time: rodada.actividad.hora,
                            duration: rodada.actividad.duracion,
                            location: rodada.actividad.ubicacion,
                            attendees: rodada.actividad.personasInscritas
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchRodadas()
        }
    }
    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            return formatDateCustom(date)
        }
        
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: dateString) {
            return formatDateCustom(date)
        }
        
        return dateString
    }
    
    func formatDateCustom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "es_MX")
        return dateFormatter.string(from: date)
    }
}
