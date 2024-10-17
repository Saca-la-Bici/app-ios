//
//  RodadaRutaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 01/10/24.
//

import SwiftUI

struct RodadaRutaView: View {
    @Binding var path: [ActivitiesPaths]
    @ObservedObject var actividadViewModel = ActividadViewModel()
    
    // Variable para comprobar si se está agregando o editando
    var isEditing: Bool

    var body: some View {
        ZStack {
            if actividadViewModel.isLoading {
                ProgressView()
            } else if actividadViewModel.rutas.isEmpty {
                Text("Actualmente no hay rutas registradas. Por favor, registra una ruta para registrar una rodada.")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    VStack {
                        Spacer().frame(height: 10)

                        Text("Selecciona la ruta de la rodada:")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer().frame(height: 15)

                        ForEach(actividadViewModel.rutas) { ruta in
                            RutaCardView(ruta: ruta,
                                         isSelected: actividadViewModel.selectedRuta?.id == ruta.id,
                                         onDelete: {
                                actividadViewModel.alertTypeRuta = .delete(ruta: ruta)
                            })
                            .onTapGesture {
                                actividadViewModel.selectedRuta = ruta
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding()
                }
            }

            VStack {
                Spacer()
                if !actividadViewModel.rutas.isEmpty {
                    CustomButton(
                        text: "Siguiente",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            if isEditing {
                                path.append(.editarDescripcionRodada(id: actividadViewModel.idActividad))
                            } else {
                                path.append(.descripcionRodada)
                            }
                        },
                        tieneIcono: true,
                        icono: "chevron.right"
                    )
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .navigationTitle(actividadViewModel.navTitulo)
        .alert(item: $actividadViewModel.alertTypeRuta) { alertType in
            switch alertType {
            case .delete(let ruta):
                return Alert(
                    title: Text("¿Seguro quieres eliminar la ruta?"),
                    message: Text("Una vez eliminada no se podrá recuperar."),
                    primaryButton: .destructive(Text("Eliminar")) {
                        Task {
                            await actividadViewModel.eliminarActividad(IDRuta: ruta._id)
                        }
                    },
                    secondaryButton: .cancel()
                )
            case .validation:
                return Alert(
                    title: Text(actividadViewModel.tituloAlertaRuta),
                    message: Text(actividadViewModel.messageAlert),
                    dismissButton: .default(Text("Aceptar")) {
                        actividadViewModel.showAlert = false
                        
                        if actividadViewModel.reloadRutas == true {
                            Task {
                                await actividadViewModel.validarDatosBase()
                                actividadViewModel.reloadRutas = false
                            }
                        }
                    }
                )
            }
        }
    }
}

struct RodadaRutaView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []

        var body: some View {
            RodadaRutaView(path: $path, isEditing: false)
        }
    }
}
