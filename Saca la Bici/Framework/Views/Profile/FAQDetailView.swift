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
    var permisos: [String]
    
    // View model
    @ObservedObject var viewModel = FAQDetailViewModel()
    
    // Alertas
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false
    
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
    
    // Binding
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20.0) {
                    
                    // Pregunta
                    Text(viewModel.faq?.Pregunta ?? "")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Respuesta
                    Text(viewModel.faq?.Respuesta ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    
                    Spacer().frame(height: 20)
                    
                    // Seccion de admin
                    if permisos.contains("Modificar pregunta frecuente") || permisos.contains("Eliminar pregunta frecuente") || true {
                        
                        Text("Herramientas de administrador")
                            .font(.callout)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Editar
                        if permisos.contains("Modificar pregunta frecuente") || true {
                            
                            CustomButton(
                                text: "Editar Pregunta",
                                backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                                action: {
                                    path.append(.updateFAQ(faq: viewModel.faq ?? faq))
                                }
                            )
                        }
                        
                        // Eliminar
                        if permisos.contains("Eliminar pregunta frecuente") || true {
                            
                            CustomButton(
                                text: "Eliminar Pregunta",
                                backgroundColor: Color(.red),
                                foregroundColor: Color(.white),
                                action: {
                                    showDeleteConfirmation = true
                                }
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Pregunta")
                .frame(maxWidth: .infinity)
                .onAppear {
                    Task {
                        await viewModel.getFAQ(faq.IdPregunta)
                    }
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("¿Seguro quieres eliminar la pregunta?"),
                        message: Text("Una vez eliminada no se podrá recuperar."),
                        primaryButton: .destructive(Text("Eliminar")) {
                            Task {
                                await viewModel.deleteFAQ(viewModel.faq?.IdPregunta ?? faq.IdPregunta)
                            }
                            viewModel.successMessage = nil
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
            }
        }
    }
}

#Preview {
    FAQDetailView(
        faq: FAQ(IdPregunta: 1, Pregunta: "Pregunta 1", Respuesta: "Respuesta 1", Tema: "Tema 1", Imagen: ""),
        permisos: [],
        path: .constant([])
    )
}
