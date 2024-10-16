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
                    
                    if actividadViewModel.rutas.isEmpty {
                        
                    } else {
                        Spacer().frame(height: 10)
                        
                        Text("Selecciona la ruta de la rodada:")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer().frame(height: 15)
                        
                        ForEach(actividadViewModel.rutas) { ruta in
                            RutaCardView(ruta: ruta,
                                         isSelected: actividadViewModel.selectedRuta?.id == ruta.id)
                                .onTapGesture {
                                    actividadViewModel.selectedRuta = ruta
                                }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        CustomButton(
                            text: "Siguiente",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                actividadViewModel.validarRuta()
                                
                                if actividadViewModel.showAlert != true {
                                    path.append(.descripcionRodada)
                                }
                            },
                            tieneIcono: true,
                            icono: "chevron.right"
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle(actividadViewModel.navTitulo)
        .alert(isPresented: $actividadViewModel.showAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(actividadViewModel.messageAlert)
            )
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
