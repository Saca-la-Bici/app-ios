//
//  AddFAQView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct AddFAQView: View {

    // Sesión
    @EnvironmentObject var sessionManager: SessionManager
    
    // Variables
    @State var tema: String = ""
    @State var pregunta: String = ""
    @State var respuesta: String = ""
    
    // Binding
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // Tema
            
            Text("Tema")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
            
            TextField("Tema", text: $tema)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            // Pregunta
            
            Text("Pregunta")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
            
            TextField("Pregunta", text: $pregunta)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            // Respuesta
            
            Text("Respuesta")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
            
            TextField("Respuesta", text: $respuesta, axis: .vertical)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            Button(action: {
                
            }, label: {
                Text("Registrar pregunta")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                    .cornerRadius(10)
            })
            
            Spacer()
            
        }.navigationTitle("Añadir pregunta")
        .padding()
    
        
    }
}

struct AddFAQView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            AddFAQView(path: $path)
        }
    }
}
