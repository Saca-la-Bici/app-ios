//
//  talleresView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct TalleresView: View {
    @StateObject private var viewModel = TalleresViewModel()
    
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
                    ForEach(viewModel.talleres) { taller in
                        ActivityCardView(
                            activityTitle: taller.actividad.titulo,
                            activityType: "Taller",
                            date: FechaManager.shared.formatDate(taller.actividad.fecha),
                            time: taller.actividad.hora,
                            location: taller.actividad.ubicacion,
                            attendees: taller.actividad.personasInscritas
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
