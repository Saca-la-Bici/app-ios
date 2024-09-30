//
//  FAQDetailView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct FAQDetailView: View {
    
    // Parámetro
    var faq: FAQ
    
    // Binding
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            
            // Pregunta
            Text(faq.Pregunta)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Respuesta
            Text(faq.Respuesta)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color(red: 0.937, green: 0.937, blue: 0.937))
                .cornerRadius(10)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        
        Spacer()
    }
}

#Preview {
    FAQDetailView(
        faq: FAQ(IdPregunta: 1, Pregunta: "Pregunta 1", Respuesta: "Respuesta 1", Tema: "Tema 1", Imagen: ""),
        path: .constant([])
    )
}
