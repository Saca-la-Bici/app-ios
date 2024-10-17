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
    
    // ID para edicion
    var id: String?
    
    // Variable para comprobar si se está agregando o editando
    var isEditing: Bool

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {

                    Spacer().frame(height: 10)

                    HStack {
                        Spacer()
                        
                        // Si no hay imagen seleccionada ni URL de imagen existente:
                        if actividadViewModel.selectedImageData == nil && actividadViewModel.existingImageURL == nil {
                            
                            ImagePickerView(selectedItem: $actividadViewModel.selectedItem, selectedImageData: $actividadViewModel.selectedImageData)
                            
                        }
                        // Si hay una imagen seleccionada por el usuario (nueva)
                        else if let data = actividadViewModel.selectedImageData, let uiImage = UIImage(data: data) {
                            
                            // Mostrar la imagen seleccionada
                            VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(10)
                                    Button(action: {
                                        actividadViewModel.selectedImageData = nil
                                    }, label: {
                                        Text("Eliminar Imagen")
                                            .foregroundColor(.red)
                                            .padding(.top, 5)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            
                        }
                        // Hay una imagen del S3
                        else if let imageURL = actividadViewModel.existingImageURL {
                            // Mostrar la imagen existente
                            VStack {
                                AsyncImage(url: imageURL) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 200)
                                            .cornerRadius(10)
                                    } else if phase.error != nil {
                                        // Error al cargar la imagen
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200, height: 200)
                                            .cornerRadius(10)
                                    } else {
                                        // Placeholder mientras se carga la imagen
                                        ProgressView()
                                            .frame(width: 200, height: 200)
                                    }
                                }
                                
                                HStack {
                                    // Usar el componente ImagePickerView para cambiar la imagen existente
                                    PhotosPicker(
                                        selection: $actividadViewModel.selectedItem,
                                        matching: .images,
                                        photoLibrary: .shared(),
                                        label: {
                                            Text("Cambiar Imagen")
                                                .foregroundColor(.blue)
                                                .padding(.top, 5)
                                        }
                                    )
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        // Eliminar la imagen existente
                                        actividadViewModel.selectedImageData = nil
                                        actividadViewModel.existingImageURL = nil
                                        actividadViewModel.existingImageData = nil
                                    }, label: {
                                        Text("Eliminar Imagen")
                                            .foregroundColor(.red)
                                            .padding(.top, 5)
                                    })
                                }
                            }
                            .onChange(of: actividadViewModel.selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       UIImage(data: data) != nil {
                                        actividadViewModel.selectedImageData = data
                                        actividadViewModel.existingImageURL = nil
                                        actividadViewModel.existingImageData = nil
                                    }
                                }
                            }
                        }
                        
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

                            if actividadViewModel.isEditing {
                                if actividadViewModel.showAlert != true {
                                    if tipoActividad == "Rodada" {
                                        path.append(.editarRodadaRuta(id: actividadViewModel.idActividad))
                                    } else if tipoActividad == "Evento" {
                                        path.append(.editarDescripcionEvento(id: actividadViewModel.idActividad))
                                    } else if tipoActividad == "Taller" {
                                        path.append(.editarDescripcionEvento(id: actividadViewModel.idActividad))
                                    }
                                }
                            } else {
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
            .zIndex(1)
            .blur(radius: actividadViewModel.isLoading ? 10 : 0)
            
            if actividadViewModel.isLoading {
                ProgressView()
                    .zIndex(2)
            }
        }
        .onAppear {
            Task {
                // Resetar campos
                actividadViewModel.reset()
                
                // Modo edición
                if isEditing {
                    
                    actividadViewModel.isEditing = true
                    actividadViewModel.idActividad = id ?? ""
                    
                    await actividadViewModel.getActividad()
                    print("ID: \(actividadViewModel.idActividad)")
                }
                
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
}

struct RegistrarActividadView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []

        var body: some View {
            RegistrarActividadView(path: $path, tipoActividad: "Rodada", isEditing: false)
        }
    }
}
