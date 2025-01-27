//
//  ActivityCardSMView.swift
//  Saca la Bici
//
//  Created by Diego Lira on 16/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActivityCardSMView: View {
    let id: String
    let activityTitle: String
    let activityType: String
    let level: String?
    let date: String?
    let time: String?
    let duration: String?
    let imagen: String?
    let location: String?
    let attendees: Int?
    
    let colorManager = ColorManager()
    
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        ZStack {
            // Contenido de la tarjeta
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
                            .background(
                                levelColor(for: level)
                            )
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
                    infoRow(title: "Fecha", value: date)
                }
                    
                if let time = time {
                    infoRow(title: "Hora", value: time)
                }
                    
                if let duration = duration {
                    infoRow(title: "Duración", value: duration)
                }
                    
                if let location = location {
                    infoRow(title: "Ubicación", value: location)
                }
                    
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
            )
            .shadow(radius: 5)
            .onTapGesture {
                path.append(.detalle(id: id))
            }
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    private func levelColor(for level: String) -> Color {
        switch level {
        case "Nivel 1":
            return Color(red: 129.0 / 255.0, green: 199.0 / 255.0, blue: 132.0 / 255.0)
        case "Nivel 2":
            return Color(red: 56.0 / 255.0, green: 142.0 / 255.0, blue: 60.0 / 255.0)
        case "Nivel 3":
            return Color(red: 253.0 / 255.0, green: 216.0 / 255.0, blue: 53.0 / 255.0)
        case "Nivel 4":
            return Color(red: 255.0 / 255.0, green: 152.0 / 255.0, blue: 0.0 / 255.0)
        case "Nivel 5":
            return Color(red: 244.0 / 255.0, green: 67.0 / 255.0, blue: 54.0 / 255.0)
        default:
            return Color.gray
        }
    }
}
