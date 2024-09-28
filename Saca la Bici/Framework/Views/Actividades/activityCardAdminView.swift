//
//  activityCardAdminView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct ActivityCardAdminView: View {
    var activityTitle: String
    var activityType: String 
    var level: String?
    var date: String?
    var time: String?
    var duration: String?
    var location: String?
    var attendees: Int?

    @State private var isJoined: Bool = false
    @State private var isStarted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(activityTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
                            .foregroundColor(.primary)
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
                        .foregroundColor(.primary)
                }
            }
            
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
                        .foregroundColor(.primary)
                }
            }
            
            if activityType == "Rodada" {
                Button(action: {
                    isStarted.toggle()
                }, label: {
                    HStack {
                        Image(systemName: isStarted ? "pause.circle" : "play.circle")
                        Text(isStarted ? "Parar" : "Iniciar")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isStarted ? Color.red : Color(hex: "#88B598")) 
                    .cornerRadius(8)
                })
                
                Button(action: {
  
                }, label: {
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.headline)
                        Text("Asistencia")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(8)
                })
            } else {
                Button(action: {
                    isJoined.toggle()
                }, label: {
                    HStack {
                        Image(systemName: isJoined ? "xmark.circle" : "plus.circle")
                        Text(isJoined ? "Cancelar asistencia" : "Unirse")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isJoined ? Color.red : Color(hex: "#88B598"))
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

// Extensión para usar colores hexadecimales en SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ActivityCardAdminView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityCardAdminView(
                activityTitle: "Rodada Nocturna",
                activityType: "Rodada",
                level: "Nivel 1",
                date: "Sábado 24 agosto 2024",
                time: "19:00",
                duration: "1 hrs",
                location: "Centro histórico",
                attendees: 67
            )
            
            ActivityCardAdminView(
                activityTitle: "Día Mundial del Medio Ambiente",
                activityType: "Evento",
                date: "Jueves 5 junio 2025",
                time: "13:00",
                location: "Epigmenio González",
                attendees: 32
            )
        }
    }
}
