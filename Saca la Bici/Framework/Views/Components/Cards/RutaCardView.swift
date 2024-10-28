//
//  RutaCardView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 15/10/24.
//

import SwiftUI

struct RutaCardView: View {
    let ruta: Ruta
    let isSelected: Bool
    
    var onDelete: () -> Void
    
    @ObservedObject private var userSessionManager = UserSessionManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(ruta.titulo)
                    .font(.headline)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(ColorManager.shared.colorFromHex("#7DA68D"))
                }
            }
            
            HStack {
                Text("\(ruta.nivel)")
                    .font(.subheadline)
                    .padding(6)
                    .background(levelColor(for: ruta.nivel))
                    .cornerRadius(8)
                
                Spacer()
                
                Text("Distancia: \(ruta.distancia)")
                    .font(.subheadline)
            }
            
            Text("Tiempo: \(ruta.tiempo)")
                .font(.subheadline)
        }
        .padding()
        .background(isSelected ? ColorManager.shared.colorFromHex("#7DA68D").opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
        .contentShape(Rectangle())
        .contextMenu {
            if userSessionManager.puedeEliminarRuta() {
                Button(role: .destructive, action: {
                    onDelete()
                }, label: {
                    Label("Eliminar", systemImage: "trash")
                })
            }
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
