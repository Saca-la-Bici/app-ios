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

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Agregar lo que va en rutas")

                    CustomButton(
                        text: "Siguiente",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            path.append(.descripcionRodada)
                        },
                        tieneIcono: true,
                        icono: "chevron.right"
                    )
                }
                .padding()
            }
        }
        .navigationTitle(actividadViewModel.navTitulo)
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
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
            RodadaRutaView(path: $path)
        }
    }
}
