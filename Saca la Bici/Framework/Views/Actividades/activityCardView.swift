//
//  activityCardView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct ActivityCardView: View {
    var activityTitle: String
    var level: String?
    var date: String?
    var time: String?
    var duration: String?
    var location: String?
    var attendees: Int?

    @State private var isJoined: Bool = false  // Estado para cambiar el botón
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Añadir espaciado
            HStack {
                Text(activityTitle)
                    .font(.headline)
                
                Spacer()
                
                if let level = level {
                    Text(level)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(level == "Nivel 1" ? Color.green : (level == "Nivel 2" ? Color.orange : Color.gray))
                        .cornerRadius(8)
                }
                
                if let attendees = attendees {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text("\(attendees)")
                    }
                }
            }
            
            if let date = date {
                HStack {
                    Text("Fecha")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.subheadline)
                }
            }
            
            if let time = time {
                HStack {
                    Text("Hora")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(time)
                        .font(.subheadline)
                }
            }
            
            if let duration = duration {
                HStack {
                    Text("Duración")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(duration)
                        .font(.subheadline)
                }
            }
            
            // Placeholder for image
            Rectangle()
                .fill(Color.gray)
                .frame(height: 100)
                .cornerRadius(8)
            
            if let location = location {
                HStack {
                    Text("Ubicación")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.subheadline)
                }
            }
            
            Button(action: {
                isJoined.toggle()  // Cambia el estado al pulsar el botón
            }) {
                HStack {
                    Image(systemName: isJoined ? "xmark.circle" : "plus.circle")
                    Text(isJoined ? "Cancelar asistencia" : "Unirse")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isJoined ? Color.red : Color.yellow)
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
