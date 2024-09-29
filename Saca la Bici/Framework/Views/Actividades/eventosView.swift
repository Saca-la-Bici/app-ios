//
//  eventosView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct EventosView: View {
    @StateObject private var viewModel = EventosViewModel()
    
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
                    ForEach(viewModel.eventos) {evento in
                        ActivityCardView(
                            activityTitle: evento.actividad.titulo,
                            date: formatDate(evento.actividad.fecha),
                            time: evento.actividad.hora,
                            location: evento.actividad.ubicacion,
                            attendees: evento.actividad.personasInscritas
                        )
                    }
                    .padding(.horizontal)
                }
            }
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

struct EventosView_Previews: PreviewProvider {
    static var previews: some View {
        EventosView()
    }
}
