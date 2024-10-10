//
//  ActividadInfoView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import SwiftUI

struct ActividadInfoView: View {
    var fecha: String
    var hora: String
    var duracion: String
    var ubicacion: String
    var tipo: String
    var distancia: String = ""
    var rentaBicicletasAction: () -> Void  
    var nivel: String = ""
    var descripcion: String

    var body: some View {
        VStack(alignment: .leading) {
            detailRow(title: "Fecha", value: FechaManager.shared.formatDate(fecha))

            if !nivel.isEmpty {
                HStack {
                    Text("Hora")
                        .bold()
                        .foregroundColor(.gray)
                    Text(hora)

                    Spacer().frame(width: 40)

                    Text(nivel)
                        .font(.caption)
                        .padding(6)
                        .background(
                            levelColor(for: nivel)
                        )
                        .cornerRadius(8)
                }
                .padding(.vertical, 3)
            } else {
                detailRow(title: "Hora", value: hora)
            }

            detailRow(title: "Duración", value: duracion)
            detailRow(title: "Ubicación", value: ubicacion)

            if tipo == "Rodada" {
                detailRow(title: "Distancia", value: distancia)
                HStack {
                    Text("Renta Bicicletas")
                        .bold()
                        .foregroundColor(.gray)
                    Button(action: rentaBicicletasAction) {
                        Text("Click aquí")
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
            }

            VStack(alignment: .leading) {
                Text("Descripción")
                    .bold()
                    .foregroundColor(.gray)

                Spacer().frame(height: 10)

                Text(descripcion)
            }
            .padding(.vertical, 3)
        }
        .padding(.horizontal)
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .bold()
                .foregroundColor(.gray)
            Text(value)
        }
        .padding(.vertical, 3)
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
