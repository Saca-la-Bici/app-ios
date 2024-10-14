//
//  FAQDetailView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct FAQDetailView<PathType: Equatable>: View {
    
    // Parámetro
    var faq: FAQ
    var permisos: [String]
    
    // View model
    @ObservedObject var viewModel = FAQDetailViewModel()
    
    // Alertas
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false
    
    // Binding
    @Binding var path: [PathType]
    
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
                                    if let activityPath = PathType.self as? ActivitiesPaths.Type {
                                        if let updateFAQPath = activityPath.updateFAQ(faq: viewModel.faq ?? faq) as? PathType {
                                            path.append(updateFAQPath)
                                        }
                                    } else if let configPath = PathType.self as? ConfigurationPaths.Type {
                                        if let updateFAQPath = configPath.updateFAQ(faq: viewModel.faq ?? faq) as? PathType {
                                            path.append(updateFAQPath)
                                        }
                                    }
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
                                    viewModel.activeAlert = .deleteConfirmation
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
                    case .notFound:
                        return Alert(
                            title: Text("Oops!"),
                            message: Text(viewModel.errorMessage ?? "No se encontró la pregunta frecuente."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                                viewModel.errorMessage = nil
                            }
                        )
                    case .deleteConfirmation:
                        return Alert(
                            title: Text("¿Seguro quieres eliminar la pregunta?"),
                            message: Text("Una vez eliminada no se podrá recuperar."),
                            primaryButton: .destructive(Text("Eliminar")) {
                                Task {
                                    await viewModel.deleteFAQ(viewModel.faq?.IdPregunta ?? faq.IdPregunta)
                                }
                                viewModel.successMessage = nil
                            },
                            secondaryButton: .cancel(Text("Cancelar"))
                        )
                    case .success:
                        return Alert(
                            title: Text("Éxito"),
                            message: Text(viewModel.successMessage ?? "Pregunta editada correctamente."),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    FAQDetailView<ConfigurationPaths>(
        faq: FAQ(IdPregunta: 1, Pregunta: "Pregunta 1", Respuesta: "Respuesta 1", Tema: "Tema 1", Imagen: ""),
        permisos: [],
        path: .constant([])
    )
}
