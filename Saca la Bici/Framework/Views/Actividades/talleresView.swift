//
//  talleresView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct TalleresView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject private var viewModel = TalleresViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.talleres.isEmpty {
                    Text("Actualmente no hay talleres disponibles, pero vuelve más tarde para ver nuevas actividades.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(viewModel.talleres) { taller in
                        ActivityCardView(
                            path: $path,
                            id: taller.id,
                            activityTitle: taller.actividad.titulo,
                            activityType: "Taller",
                            date: FechaManager.shared.formatDate(taller.actividad.fecha),
                            time: taller.actividad.hora,
                            duration: taller.actividad.duracion,
                            imagen: taller.actividad.imagen,
                            location: taller.actividad.ubicacion,
                            attendees: taller.actividad.personasInscritas
                        )
                    }
                }
                Spacer().frame(height: 5)
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.isLoading = true
            viewModel.fetchTalleres()
        }
    }
}
