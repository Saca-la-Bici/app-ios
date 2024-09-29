//
//  ActivityCardView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct ActivityCardView: View {
    var activityTitle: String
    var activityType: String
    var level: String?
    var date: String?
    var time: String?
    var duration: String?
    var location: String?
    var attendees: Int?
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    
    @State private var isJoined: Bool = false
    @State private var isStarted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título y Nivel
            HStack {
                Text(activityTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let level = level {
                    Text(level)
                        .font(.caption)
                        .padding(6)
                        .background(level == "Nivel 1" ? Color.green : (level == "Nivel 2" ? Color.orange : Color.gray))
                        .cornerRadius(8)
                }
                
                if let attendees = attendees {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text("\(attendees)")
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Fecha
            if let date = date {
                HStack {
                    Text("Fecha")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Hora
            if let time = time {
                HStack {
                    Text("Hora")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Duración
            if let duration = duration {
                HStack {
                    Text("Duración")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Imagen Placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
                .cornerRadius(8)
            
            // Ubicación
            if let location = location {
                HStack {
                    Text("Ubicación")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Botones según tipo de actividad y permisos
            if activityType.lowercased() == "rodada" && userSessionManager.puedeIniciarRodada() {
                // Botones para Rodada
                VStack(spacing: 8) {
                    // Botón de Iniciar/Parar Rodada
                    Button(action: {
                        isStarted.toggle()
                        // Aquí puedes agregar lógica adicional para iniciar o parar la rodada
                    }, label: {
                        HStack {
                            Image(systemName: isStarted ? "pause.circle" : "play.circle")
                            Text(isStarted ? "Parar" : "Iniciar")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isStarted ? Color.red : ColorManager.shared.colorFromHex("#88B598"))
                        .cornerRadius(8)
                    })
                    
                    // Botón de Asistencia
                    Button(action: {
                        // Lógica de asistencia
                        // Implementa aquí la funcionalidad de asistencia
                    }, label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.headline)
                            Text("Asistencia")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(8)
                    })
                }
            } else {
                // Botón de Unirse para otras actividades o si no tiene permiso para iniciar rodada
                Button(action: {
                    isJoined.toggle()
                    // Aquí puedes agregar lógica adicional para unirse o cancelar asistencia
                }, label: {
                    HStack {
                        Image(systemName: isJoined ? "xmark.circle" : "plus.circle")
                        Text(isJoined ? "Cancelar asistencia" : "Unirse")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        isJoined
                            ? Color.red
                            : (userSessionManager.puedeIniciarRodada() && activityType.lowercased() != "rodada"
                                ? ColorManager.shared.colorFromHex("#88B598") // Verde si puede iniciar rodada y no es rodada
                                : Color.yellow) // Amarillo para los demás casos
                    )
                    .cornerRadius(8)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
