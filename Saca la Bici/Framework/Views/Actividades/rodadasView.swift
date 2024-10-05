//
//  rodadasView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct RodadasView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject private var viewModel = RodadasViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(viewModel.rodadas) { rodada in
                        ActivityCardView(
                            path: $path,
                            id: rodada.id,
                            activityTitle: rodada.actividad.titulo,
                            activityType: "Rodada", 
                            level: rodada.ruta.nivel,
                            date: FechaManager.shared.formatDate(rodada.actividad.fecha),
                            time: rodada.actividad.hora,
                            duration: rodada.actividad.duracion,
                            imagen: rodada.actividad.imagen,
                            location: rodada.actividad.ubicacion,
                            attendees: rodada.actividad.personasInscritas
                        )
                    }
                }
                
                Spacer().frame(height: 5)
            }
            .padding(.horizontal)
        }
    }
}
