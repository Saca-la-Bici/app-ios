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
    var rentaBicicletas: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            detailRow(title: "Fecha", value: FechaManager.shared.formatDate(fecha))
            detailRow(title: "Hora", value: hora)
            detailRow(title: "Duración", value: duracion)
            detailRow(title: "Ubicación", value: ubicacion)
            if tipo == "Rodada" {
                detailRow(title: "Distancia", value: distancia)
                detailRow(title: "Renta Bicicletas", value: rentaBicicletas)
            }
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
}
