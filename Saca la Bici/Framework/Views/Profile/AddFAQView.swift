//
//  AddFAQView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct AddFAQView: View {
    
    // View Model
    @ObservedObject var viewModel = AddFAQViewModel()
    
    // Binding
    @Binding var path: [ConfigurationPaths]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer().frame(height: 5)
                    
                    Text("Categoría")
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
                    
                    Text("Título")
                        .font(.callout)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextoLimiteField(
                        placeholder: "Escribe el título de la pregunta ...",
                        text: $viewModel.pregunta,
                        maxLength: 100
                    )
                    
                    Text("Descripción")
                        .font(.callout)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextoLimiteMultiline(
                        placeholder: "Escribe la respuesta aquí ...",
                        text: $viewModel.respuesta,
                        maxLength: 275,
                        showCharacterCount: true
                    )
                    
                    Spacer()
                    
                }
                .navigationTitle("Añadir pregunta")
                .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                if viewModel.pregunta.isEmpty || viewModel.respuesta.isEmpty {
                                    viewModel.errorMessage = "Debe ingresar una pregunta y una respuesta"
                                    viewModel.activeAlert = .error
                                } else {
                                    Task {
                                        await viewModel.addFAQ(
                                            tema: viewModel.temaSelected,
                                            pregunta: viewModel.pregunta,
                                            respuesta: viewModel.respuesta
                                        )
                                    }
                                }
                            }, label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.yellow)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                .padding()
                .alert(item: $viewModel.activeAlert) { alertType in
                    switch alertType {
                    case .error:
                        return Alert(
                            title: Text("Oops!"),
                            message: Text(viewModel.errorMessage ?? "Error desconocido."),
                            dismissButton: .default(Text("OK")) {
                                viewModel.errorMessage = nil
                            }
                        )
                    case .success:
                        return Alert(
                            title: Text("Éxito"),
                            message: Text(viewModel.successMessage ?? "Pregunta frecuente agregada correctamente."),
                            dismissButton: .default(Text("OK")) {
                                viewModel.successMessage = nil
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
        }
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
