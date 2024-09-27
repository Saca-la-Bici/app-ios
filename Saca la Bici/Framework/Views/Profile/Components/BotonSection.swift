//
//  BotonSection.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct BotonSection: View {
    var icono: String
    var titulo: String
    var button: Bool
    @Binding var path: [ConfigurationPaths]
    var nextPath: ConfigurationPaths?
    
    var body: some View {
        HStack {
            Button {
                if nextPath != nil {
                    path.append(nextPath!)
                }
            } label: {
                Image(systemName: icono)
                Text(titulo)
                Spacer()
                if button == true {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                        .scaleEffect(1.5)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
