//
//  DescripcionActividadView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import SwiftUI
import DurationPicker

struct DescripcionActividadView: View {
    @Binding var path: [ActivitiesPaths]

    @ObservedObject var actividadViewModel = ActividadViewModel()
    
    // ID para edicion
    var id: String?
    
    // Variable para comprobar si se está agregando o editando
    var isEditing: Bool

    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 40)

                    TextoLimiteMultilineField(
                        label: "Descripción",
                        placeholder: "Escribe la descripción de la actividad",
                        text: $actividadViewModel.descripcionActividad,
                        maxLength: 450,
                        title: false,
                        showCharacterCount: true,
                        disabled: actividadViewModel.isLoading
                    )

                    Spacer().frame(height: 20)

                    DuracionPicker(
                        label: "Duración",
                        selectedDuration: $actividadViewModel.selectedTimeDuration,
                        title: false,
                        disabled: actividadViewModel.isLoading
                    )
                }
                .padding()
            }.zIndex(1)
                .blur(radius: actividadViewModel.isLoading ? 10 : 0)
            
            if actividadViewModel.isLoading {
                ProgressView()
                    .zIndex(2)
            }
            
        }
        .navigationTitle(actividadViewModel.navTitulo)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Si no está cargando, mostrar botón para confirmar
                    if !actividadViewModel.isLoading {
                        Button(action: {
                            Task {
                                if isEditing {
                                    await actividadViewModel.modificarActividad()
                                } else {
                                    await actividadViewModel.registrarActividad()
                                }
                            }
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                        })
                        .buttonStyle(PlainButtonStyle())
                    }

                }
            }

        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .alert(item: $actividadViewModel.activeAlert) { alertType in
            switch alertType {
            case .error:
                return Alert(
                    title: Text("Oops!"),
                    message: Text(actividadViewModel.messageAlert)
                )
            case .success:
                return Alert(
                    title: Text("¡Éxito!"),
                    message: Text(actividadViewModel.messageAlert),
                    dismissButton: .default(Text("OK")) {
                        actividadViewModel.reset()
                        path.removeAll()
                    }
                )
            case .delete:
                return Alert(title: Text("XD"))
            }
            
        }
        
        .onAppear {
            actividadViewModel.setGuardarBoton()
        }
        
    }
}

struct DescripcionActividadView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []

        var body: some View {
            DescripcionActividadView(path: $path, isEditing: false)
        }
    }
}
