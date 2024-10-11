//
//  eventosView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct EventosView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject private var viewModel = EventosViewModel()
    
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
                    ForEach(viewModel.eventos) { evento in
                        ActivityCardView(
                            path: $path,
                            id: evento.id,
                            activityTitle: evento.actividad.titulo,
                            activityType: "Evento",
                            date: FechaManager.shared.formatDate(evento.actividad.fecha),
                            time: evento.actividad.hora,
                            duration: evento.actividad.duracion,
                            imagen: evento.actividad.imagen,
                            location: evento.actividad.ubicacion,
                            attendees: evento.actividad.personasInscritas
                        )
                    }
                }
                Spacer().frame(height: 5)
            }
            .padding(.horizontal)
        }
    }
}
