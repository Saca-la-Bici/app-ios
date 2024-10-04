//
//  ProfileMedals.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct MedalsView: View {
    var body: some View {
        HStack {
            // Medalla 1
            VStack {
                Image("Medalla5Asistencias")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)  // Tamaño de la medalla
                Text("Asiste a 5 rodadas")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }
            .padding(.trailing, 30)

            // Medalla 2
            VStack {
                Image("MedallaNivelExperto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)  // Tamaño de la medalla
                Text("Nivel experto")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }
            .padding(.trailing, 30)

            // Medalla 3
            VStack {
                Image("Medalla50km")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)  // Tamaño de la medalla
                Text("Recorre 50km")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }

            // Flecha visible a la derecha
            VStack {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.black)
            }
            
        }
        .padding(.bottom, 40)
    }
}
