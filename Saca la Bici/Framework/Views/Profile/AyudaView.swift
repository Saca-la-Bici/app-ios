//
//  AyudaView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI
import Combine

struct AyudaView: View {
    
    // Datos de prueba
    private let temasFAQ: [TemaFAQ] = [
        TemaFAQ(
            tema: "Tema 1",
            faqs: [
                FAQ(
                    idPregunta: 1,
                    pregunta: "Pregunta 1",
                    respuesta: "Respuesta 1",
                    tema: "Tema 1",
                    imagen: ""),
                FAQ(
                    idPregunta: 2,
                    pregunta: "Pregunta 2",
                    respuesta: "Respuesta 2",
                    tema: "Tema 1",
                    imagen: "")
            ]),
        TemaFAQ(
            tema: "Tema 2",
            faqs: [
                FAQ(
                    idPregunta: 3,
                    pregunta: "Pregunta 3",
                    respuesta: "Respuesta 3",
                    tema: "Tema 2",
                    imagen: ""),
                FAQ(
                    idPregunta: 4,
                    pregunta: "Pregunta 4",
                    respuesta: "Respuesta 4",
                    tema: "Tema 2",
                    imagen: "")
            ])
    ]
    
    // Sesión
    @EnvironmentObject var sessionManager: SessionManager
    
    // View Model
    // @StateObject var viewModel = AyudaViewModel()
    
    // Variables
    @State private var searchText: String = ""
    
    var body: some View {
        
        // Wrapper
        VStack(alignment: .leading, spacing: 20.0) {
            
            // Nombre de usuario PENDIENTE
            Text("¿Cómo te podemos ayudar hoy, Guadalupe?")
                .font(.title2)
                .multilineTextAlignment(.leading)
            
            // Input de búsqueda
            TextField("¿Cuál es tu duda?", text: $searchText)
                .textInputAutocapitalization(.never)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            // Preguntas frecuentes
            List {
                ForEach(temasFAQ) { tema in
                    Section(header: Text(tema.tema)) {
                        ForEach(tema.faqs) { faq in
                            HStack {
                                Text(faq.pregunta)
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(Color(.black))
                                    .scaleEffect(1)
                            }
                        }
                    }
                }
            }
            
        }.padding()
        
        Spacer()
    }
}

#Preview {
    AyudaView()
}
