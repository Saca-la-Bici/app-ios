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
    
    // Enum para manejar las alertas activas
    enum ActiveAlert: Identifiable {
        case error
        case success

        var id: Int {
            hashValue
        }
    }
    
    // Estado de alerta
    @State var activeAlert: ActiveAlert?
    
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
                    
                    // NOTA: Es un TextField porque aún no se han definido las categorías de FAQs
                    
                    TextoLimiteMultiline(
                        placeholder: "Escribe la respuesta aquí ...",
                        text: $viewModel.respuesta,
                        maxLength: 275,
                        showCharacterCount: true
                    )
                    
                    CustomButton(
                        text: "Registrar Pregunta",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            if viewModel.pregunta.isEmpty || viewModel.respuesta.isEmpty {
                                viewModel.errorMessage = "Debe ingresar una pregunta y una respuesta"
                                activeAlert = .error
                            } else {
                                Task {
                                    await viewModel.addFAQ(
                                        tema: viewModel.temaSelected,
                                        pregunta: viewModel.pregunta,
                                        respuesta: viewModel.respuesta
                                    )
                                    
                                    activeAlert = .success
                                    
                                }
                            }
                        }
                    )
                    
                    Spacer()
                    
                }
                .navigationTitle("Añadir pregunta")
                .padding()
                .alert(item: $activeAlert) { alertType in
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
