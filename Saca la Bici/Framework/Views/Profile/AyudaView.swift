//
//  AyudaView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI
import Combine

struct AyudaView: View {
    
    // Sesión
    @EnvironmentObject var sessionManager: SessionManager
    
    // View Model
    @StateObject var viewModel = AyudaViewModel()
    
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
                ForEach(viewModel.temasFAQs) { tema in
                    Section(header: Text(tema.tema)) {
                        ForEach(tema.faqs) { faq in
                            HStack {
                                Text(faq.Pregunta)
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
            .onAppear {
                Task {
                    await viewModel.getFAQs()
                    print("FAQs cargados \(viewModel.temasFAQs.count)")
                }
            }
        
        Spacer()
    }
}

#Preview {
    AyudaView()
}
