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
                        showCharacterCount: true
                    )

                    Spacer().frame(height: 20)

                    DuracionPicker(label: "Duración", selectedDuration: $actividadViewModel.selectedTimeDuration, title: false)
                }
                .padding()
            }
        }
        .navigationTitle(actividadViewModel.navTitulo)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await actividadViewModel.registrarActividad()
                            
                            if actividadViewModel.showAlertDescripcion != true {
                                actividadViewModel.reset()
                                path = []
                            }
                        }
                    }, label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.yellow)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }

        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .alert(isPresented: $actividadViewModel.showAlertDescripcion) {
            Alert(
                title: Text("Oops!"),
                message: Text(actividadViewModel.messageAlert)
            )
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
            DescripcionActividadView(path: $path)
        }
    }
}
