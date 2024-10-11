//
//  FAQView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI
import Combine

struct FAQView: View {

    @ObservedObject private var userSessionManager = UserSessionManager.shared
    
    // View Model
    @StateObject var viewModel = FAQViewModel()
    
    // Variables
    @State private var searchText: String = ""
    
    // Binding
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        
        ZStack {
            // Wrapper
            VStack(alignment: .leading, spacing: 20.0) {
                
                Spacer().frame(height: 10)
                
                // Nombre de usuario PENDIENTE
                HStack {
                    Text("¿Cómo te podemos ayudar hoy?")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if userSessionManager.canCreateFAQ() {
                        Spacer()
                        Button(action: {
                            path.append(.addFAQ)
                        }, label: {
                            Image(systemName: "plus")
                                .padding()
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 15)
                
                // Input de búsqueda
                TextField("¿Cuál es tu duda?", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 15)
                
                // Preguntas frecuentes
                
                // Si hay preguntas frecuentes
                if viewModel.isLoading == true {
                    VStack {
                        Spacer()
                        ProgressView("Cargando Preguntas Frecuentes...")
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.filteredFAQs.isEmpty {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("No hay preguntas frecuentes disponibles.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredFAQs) { tema in
                            Section(header: Text(tema.tema)) {
                                ForEach(tema.faqs) { faq in
                                    FAQCard(
                                        faq: faq,
                                        permisos: userSessionManager.permisos,
                                        path: $path,
                                        nextPath: .faqDetail(faq: faq, permisos: userSessionManager.permisos)
                                    )
                                    .listRowBackground(Color(UIColor.systemGray5))
                                    .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Ayuda")
            .onAppear {
                Task {
                    await viewModel.getFAQs()
                    viewModel.searchText.removeAll()
                }
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
                }
            }
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            FAQView(path: $path)
        }
    }
}
