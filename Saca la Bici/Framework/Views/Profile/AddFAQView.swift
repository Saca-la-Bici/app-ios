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
    
    // View Model
    @ObservedObject var viewModel = AddFAQViewModel()
    
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

            
            Picker("Tema", selection: $viewModel.temaSelected) {
                ForEach(viewModel.temasList, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.wheel)
                .frame(height: 100)
            
            // Pregunta
            
            Text("Pregunta")
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
            
            TextField("Pregunta", text: $viewModel.pregunta)
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
            
            TextField("Respuesta", text: $viewModel.respuesta, axis: .vertical)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            Button(action: {
                Task {
                    await viewModel.addFAQ(
                        tema: viewModel.temaSelected,
                        pregunta: viewModel.pregunta,
                        respuesta: viewModel.respuesta
                    )
                }
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
