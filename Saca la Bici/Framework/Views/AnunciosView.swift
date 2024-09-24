//
//  AnunciosView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct Anuncio: Identifiable {
    var id = UUID()
    var title: String
    var message: String
    var icon: String
    var backgroundColor: Color
}

struct ConsultarAnuncio: View {
    let anuncios = [
        Anuncio(title: "Conteo Ciclista Querétaro 2024",
                message: "✨¡Habemus resultados del conteo ciclista Querétaro!🚴‍♂️🚴‍♀️ Conócelos con nosotrxs hoy martes 27 de agosto a las 18:00 hrs.",
                icon: "A",
                backgroundColor: Color(UIColor.systemGray6)),
        
        Anuncio(title: "Rodada 28 de agosto",
                message: "Miércoles de Saca la Bici # 712; nos vemos este miércoles en la noche, llueva, truene o relampague. 💪☔🚴‍♂️🚴‍♀️🤘",
                icon: "A",
                backgroundColor: Color(UIColor.systemGray6)),
        
        Anuncio(title: "Por si alguien se lo perdió ...",
                message: "📌 Resultados de Conteo Ciclista QRO: https://www.youtube.com/watch?v=wYPZf1yKCSI",
                icon: "A",
                backgroundColor: Color(UIColor.systemGray6))
    ]
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Image("logoB&N")
                        .resizable()
                        .frame(width: 44, height: 35)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "bell")
                        .foregroundColor(.black)
                        .padding(.trailing)
                }
                .padding()
                
                // Aquí centramos el texto "Anuncios"
                Text("Anuncios")
                    .font(.title3)
                    .bold()
            }
            
            // Lista de anuncios
            List(anuncios) { anuncio in
                HStack(alignment: .top) {
                    Text(anuncio.icon)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.purple)
                        .clipShape(Circle())
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(anuncio.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(anuncio.message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(anuncio.backgroundColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 0.5)
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .listStyle(PlainListStyle())
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    ConsultarAnuncio()
}
