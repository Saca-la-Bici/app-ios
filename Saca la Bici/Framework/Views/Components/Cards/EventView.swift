//
//  ProfileEvents.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        VStack {
            // Título y conteo de usuarios
            HStack {
                Text("Foro nacional de la bicicleta")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Image("Participantes")
                        .resizable()
                        .frame(width: 20, height: 10)
                    Text("245")
                        .font(.system(size: 14))
                }
            }

            // Imagen y detalles del evento (fecha, hora)
            HStack {
                // Imagen del evento (placeholder)
                Image(systemName: "rectangle.on.rectangle.angled")
                    .resizable()
                    .frame(width: 160, height: 110)
                    .background(Color.gray.opacity(0.3))  // Fondo gris claro
                    .cornerRadius(8)
                    .padding(.trailing, 10)
                
                // Detalles del evento
                VStack(alignment: .leading, spacing: 13) {
                    Text("Fecha")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text("Miércoles 26 junio 2024")
                        .font(.system(size: 11))
                    HStack {
                        Text("Hora")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        Text("13:00")
                            .font(.system(size: 11))
                    }
                    
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)  // Sombra
    }
}
