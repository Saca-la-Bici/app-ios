//
//  ActividadIndividualView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import SwiftUI

struct ActividadIndividualView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject var actividadIndividualViewModel = ActividadIndividualViewModel()
    var id: String
    @State private var isJoined = false
    
    var body: some View {
        ZStack {
            if actividadIndividualViewModel.isLoading {
                ProgressView("Cargando actividad...")
            } else {
                ScrollView {
                    
                    Spacer().frame(height: 10)
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 150)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            
                        }, label: {
                            Text("Materiales")
                                .padding(.leading, 15)
                                .bold()
                                .font(.title2)
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                                .scaleEffect(1.5)
                                .padding(.trailing, 25)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    
                    ActividadInfoView(
                        fecha: actividadIndividualViewModel.fecha,
                        hora: actividadIndividualViewModel.hora,
                        duracion: actividadIndividualViewModel.duracion,
                        ubicacion: actividadIndividualViewModel.ubicacion,
                        tipo: actividadIndividualViewModel.tipo,
                        distancia: actividadIndividualViewModel.distancia,
                        rentaBicicletas: "Click aquí"
                    )
                }
                .navigationTitle(actividadIndividualViewModel.titulo)
            }
        }
        .alert(isPresented: $actividadIndividualViewModel.showAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(actividadIndividualViewModel.messageAlert),
                dismissButton: .default(Text("OK")) {
                    path.removeLast()
                }
            )
        }
        .onAppear {
            Task {
                await actividadIndividualViewModel.consultarActividadIndividual(actividadID: id)
            }
        }
    }
}

struct ActividadIndividualHeader: View {
    var level: String
    var attendees: Int
    var body: some View {
        Text(level)
            .font(.caption)
            .foregroundColor(.white)
            .padding(6)
            .background(level == "Nivel 1" ? Color.green : (level == "Nivel 2" ? Color.orange : Color.gray))
            .cornerRadius(8)
    
        HStack(spacing: 4) {
            Image(systemName: "person.2")
            Text("\(attendees)")
        }
    }
}

struct ActividadIndividualView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []
        var id = "662fr3"

        var body: some View {
            ActividadIndividualView(path: $path, id: id)
        }
    }
}
