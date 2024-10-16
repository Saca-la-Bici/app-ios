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
            
            Text("\(ruta.nivel)")
                .font(.subheadline)
            Text("Distancia: \(ruta.distancia)")
                .font(.subheadline)
            Text("Tiempo: \(ruta.tiempo)")
                .font(.subheadline)
        }
        .padding()
        .background(isSelected ? ColorManager.shared.colorFromHex("#7DA68D").opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
        .contentShape(Rectangle())
    }
}
