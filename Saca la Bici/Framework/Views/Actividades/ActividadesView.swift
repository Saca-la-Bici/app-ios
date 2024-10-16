//
//  ActividadesView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 29/09/24.
//

import SwiftUI

struct ActividadesView: View {
    @State private var selectedTab: String = "Rodadas"
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    @StateObject var actividadViewModel = ActividadViewModel()
    @StateObject var rodadasViewModel = RodadasViewModel()
    @StateObject var talleresViewModel = TalleresViewModel()
    @StateObject var eventosViewModel = EventosViewModel()
    
    @State private var path: [ActivitiesPaths] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // Encabezado
                ZStack {
                    HStack {
                        Image("logoB&N")
                            .resizable()
                            .frame(width: 44, height: 35)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button(action: {
                            path.append(.faqs)
                        }, label: {
                            Image(systemName: "questionmark.circle")
                                .padding(.trailing, 8)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        if userSessionManager.puedeIniciarRodada() {
                            Button(action: {
                                actividadViewModel.showRegistrarActividadSheet = true
                            }, label: {
                                Image(systemName: "plus") // Solo para admin
                                    .padding(.trailing, 8)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    .padding()
                    
                    Text("Actividades")
                        .font(.title3)
                        .bold()
                }
                
                // Picker para seleccionar la vista
                Picker("Select View", selection: $selectedTab) {
                    Text("Rodadas")
                        .tag("Rodadas")
                    Text("Eventos")
                        .tag("Eventos")
                    Text("Talleres")
                        .tag("Talleres")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom)
                
                // Mostrar las actividades según la pestaña seleccionada
                Group {
                    if selectedTab == "Rodadas" {
                        RodadasView(path: $path, actividadViewModel: actividadViewModel, rodadasViewModel: rodadasViewModel,
                                    eventosViewModel: eventosViewModel, talleresViewModel: talleresViewModel)
                    } else if selectedTab == "Eventos" {
                        EventosView(path: $path, actividadViewModel: actividadViewModel, rodadasViewModel: rodadasViewModel,
                                    eventosViewModel: eventosViewModel, talleresViewModel: talleresViewModel)
                    } else if selectedTab == "Talleres" {
                        TalleresView(path: $path, actividadViewModel: actividadViewModel, rodadasViewModel: rodadasViewModel,
                                     eventosViewModel: eventosViewModel, talleresViewModel: talleresViewModel)
                    }
                }
                .transition(.opacity)
            }
            .actionSheet(isPresented: $actividadViewModel.showRegistrarActividadSheet) {
                ActionSheet(title: Text("Elige el tipo de actividad:"), buttons: [
                    .default(Text("Registrar rodada")) {
                        actividadViewModel.reset()
                        path.append(.rodada)
                    },
                    .default(Text("Registrar evento")) {
                        actividadViewModel.reset()
                        path.append(.evento)
                    },
                    .default(Text("Registrar taller")) {
                        actividadViewModel.reset()
                        path.append(.taller)
                    },
                    .cancel()
                ])
            }
            .navigationDestination(for: ActivitiesPaths.self) { value in
                switch value {
                case .evento:
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Evento", isEditing: false)
                case .rodada:
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Rodada", isEditing: false)
                case .taller:
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Taller", isEditing: false)
                case .rutas:
                    RodadaRutaView(path: $path, actividadViewModel: actividadViewModel, isEditing: false)
                case .descripcionRodada:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: false)
                case .descripcionEvento:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: false)
                case .descripcionTaller:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: false)
                case .detalle(let id):
                    ActividadIndividualView(path: $path, id: id)
                case .faqs:
                    FAQView<ActivitiesPaths>(path: $path)
                case .faqDetail(let faq, let permisos):
                    FAQDetailView<ActivitiesPaths>(faq: faq, permisos: permisos, path: $path)
                case .addFAQ:
                    AddFAQView<ActivitiesPaths>(path: $path)
                case .updateFAQ(let faq):
                    UpdateFAQView<ActivitiesPaths>(faq: faq, path: $path)
                case .decalogo:
                    DecalogosView()
                case .editarEvento(let id):
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Evento", id: id, isEditing: true)
                case .editarRodada(let id):
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Rodada", id: id, isEditing: true)
                case .editarTaller(let id):
                    RegistrarActividadView(path: $path, actividadViewModel: actividadViewModel, tipoActividad: "Taller", id: id, isEditing: true)
                case .editarRodadaRuta:
                    RodadaRutaView(path: $path, actividadViewModel: actividadViewModel, isEditing: true)
                case .editarDescripcionRodada:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: true)
                case .editarDescripcionEvento:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: true)
                case .editarDescripcionTaller:
                    DescripcionActividadView(path: $path, actividadViewModel: actividadViewModel, isEditing: true)
                }
            }
        }
    }
}
