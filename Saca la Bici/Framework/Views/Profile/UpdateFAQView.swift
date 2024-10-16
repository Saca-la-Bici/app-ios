//
//  UpdateFAQView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 01/10/24.
//

import SwiftUI

struct UpdateFAQView<PathType: Equatable>: View {
    
    // FAQ
    var faq: FAQ
    
    // View Model
    @ObservedObject var viewModel = UpdateFAQViewModel()
    
    // Binding
    @Binding var path: [PathType]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
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
                    
                    // Respuesta
                    
                    Text("Descripción")
                        .font(.callout)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
                    
                    TextoLimiteMultilineField(
                        placeholder: "Escribe la respuesta aquí ...",
                        text: $viewModel.respuesta,
                        maxLength: 400,
                        showCharacterCount: true
                    )
                    
                    Spacer()
                    
                }
                .navigationTitle("Editar pregunta")
                .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                if viewModel.pregunta.trimmingCharacters(in: .whitespaces).isEmpty ||
                                    viewModel.respuesta.trimmingCharacters(in: .whitespaces).isEmpty {
                                    viewModel.errorMessage = "Debe ingresar una pregunta y una respuesta"
                                    viewModel.activeAlert = .error
                                } else {
                                    Task {
                                        await viewModel.updateFAQ(
                                            idPregunta: faq.IdPregunta,
                                            pregunta: viewModel.pregunta,
                                            respuesta: viewModel.respuesta,
                                            tema: viewModel.temaSelected
                                        )
                                    }
                                }

                            }, label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                .padding()
                .onAppear {
                    viewModel.temaSelected = faq.Tema
                    viewModel.pregunta = faq.Pregunta
                    viewModel.respuesta = faq.Respuesta
                }
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
                            message: Text(viewModel.successMessage ?? "Pregunta editada correctamente."),
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

struct UpdateFAQView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            UpdateFAQView(faq: FAQ(
                IdPregunta: 1234,
                Pregunta: "Pregunta",
                Respuesta: "Respuesta",
                Tema: "Rodadas",
                Imagen: ""),
                          path: $path)
        }
    }
}
