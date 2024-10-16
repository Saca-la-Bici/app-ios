//
//  RegistrarActividadView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import SwiftUI
import PhotosUI

struct RegistrarActividadView: View {
    @Binding var path: [ActivitiesPaths]

    @ObservedObject var actividadViewModel = ActividadViewModel()

    var tipoActividad: String

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {

                    Spacer().frame(height: 10)

                    HStack {
                        Spacer()
                        // Para subir la imagen
                        ImagePickerView(
                            selectedItem: $actividadViewModel.selectedItem,
                            selectedImageData: $actividadViewModel.selectedImageData)
                        Spacer()
                    }

                    Spacer().frame(height: 30)

                    FechaPicker(label: "Fecha de la actividad",
                               selectedDate: $actividadViewModel.selectedDate,
                               title: false)

                    Spacer().frame(height: 20)

                    TextoLimiteField(
                        label: "Título",
                        placeholder: "Escribe el título de la actividad",
                        text: $actividadViewModel.tituloActividad,
                        maxLength: 50,
                        title: false
                    )

                    Spacer().frame(height: 20)

                    HoraPicker(label: "Hora del Evento", selectedTime: $actividadViewModel.selectedTime, title: false)

                    Spacer().frame(height: 20)

                    TextoLimiteField(
                        label: "Ubicación",
                        placeholder: "Escribe la ubicación de la actividad",
                        text: $actividadViewModel.ubicacionActividad,
                        maxLength: 150,
                        title: false
                    )

                    Spacer().frame(height: 40)

                    // Botón de continuar
                    CustomButton(
                        text: "Siguiente",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            Task {
                                await actividadViewModel.validarDatosBase()

                                if actividadViewModel.showAlert != true {
                                    if tipoActividad == "Rodada" {
                                        path.append(.rutas)
                                    } else if tipoActividad == "Evento" {
                                        path.append(.descripcionEvento)
                                    } else if tipoActividad == "Taller" {
                                        path.append(.descripcionTaller)
                                    }
                                }
                            }
                        },
                        tieneIcono: true,
                        icono: "chevron.right"
                    )

                    Spacer()

                }
                .padding()
            }
            .navigationTitle(actividadViewModel.navTitulo)
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .alert(isPresented: $actividadViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(actividadViewModel.messageAlert)
                )
            }
        }
        .onAppear {
            if tipoActividad == "Evento" {
                actividadViewModel.tipoActividad = "Evento"
            } else if tipoActividad == "Taller" {
                actividadViewModel.tipoActividad = "Taller"
            } else if tipoActividad == "Rodada" {
                actividadViewModel.tipoActividad = "Rodada"
            }

            actividadViewModel.setTitulo()
        }
    }
}

struct RegistrarActividadView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []

        var body: some View {
            RegistrarActividadView(path: $path, tipoActividad: "Rodada")
        }
    }
}
