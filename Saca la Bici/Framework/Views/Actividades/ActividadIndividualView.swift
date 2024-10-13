//
//  ActividadIndividualView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

struct ActividadIndividualView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject var actividadIndividualViewModel = ActividadIndividualViewModel()
    var id: String

    @ObservedObject private var userSessionManager = UserSessionManager.shared

    @State private var safariURL: URL?
    @State private var showVerificarAsistenciaSheet = false

    var body: some View {
        ZStack {
            if actividadIndividualViewModel.isLoading {
                ProgressView("Cargando actividad...")
            } else {
                ScrollView {
                    Spacer().frame(height: 10)

                    // Mostrar imagen si está disponible
                    if !actividadIndividualViewModel.imagen.isEmpty {
                        GeometryReader { geometry in
                            WebImage(url: URL(string: actividadIndividualViewModel.imagen))
                                .resizable()
                                .scaledToFill()
                                .frame(width: min(geometry.size.width, 370), height: 300)
                                .cornerRadius(8)
                                .clipped()
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 300)
                        .padding(.horizontal)
                    }

                    HStack {
                        Button(action: {
                            // Acción para Materiales
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
                        rentaBicicletasAction: {
                            safariURL = URL(string: "http://rentabici.sacalabici.org")
                        },
                        nivel: actividadIndividualViewModel.nivel,
                        descripcion: actividadIndividualViewModel.descripcion
                    )
                    .padding()

                    Spacer().frame(height: 20)

                    CustomButton(
                        text: actividadIndividualViewModel.isJoined ? "Cancelar asistencia" : "Unirse",
                        backgroundColor: actividadIndividualViewModel.isJoined ? .red : Color(red: 0.961, green: 0.802, blue: 0.048),
                        foregroundColor: .white,
                        action: {
                            Task {
                                if actividadIndividualViewModel.isJoined {
                                    await actividadIndividualViewModel.cancelarAsistencia(actividadID: id)
                                } else {
                                    await actividadIndividualViewModel.inscribirActividad(actividadID: id)
                                }
                            }
                        },
                        tieneIcono: true,
                        icono: actividadIndividualViewModel.isJoined ? "xmark" : "plus"
                    )
                    .padding()
                    
                    if actividadIndividualViewModel.tipo == "Rodada" {
                        Spacer().frame(height: 10)
                        
                        CustomButton(
                            text: "Verificar Asistencia",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            foregroundColor: .white,
                            action: {
                                showVerificarAsistenciaSheet.toggle()
                            },
                            tieneIcono: true,
                            icono: "calendar.badge.checkmark"
                        )
                        .padding()
                        .sheet(isPresented: $showVerificarAsistenciaSheet) {
                            VerificarAsistenciaSheet(
                                verificarAction: {
                                    if userSessionManager.puedeVerificarAsistencia() {
                                        Task {
                                            await actividadIndividualViewModel.verificarAsistencia(
                                                IDRodada: id, codigoAsistencia: actividadIndividualViewModel.codigoAsistencia, adminOrStaff: true)
                                            if actividadIndividualViewModel.showAlertSheet != true {
                                                showVerificarAsistenciaSheet.toggle()
                                            }
                                        }
                                    } else {
                                        Task {
                                            await actividadIndividualViewModel.verificarAsistencia(
                                                IDRodada: id,
                                                codigoAsistencia: actividadIndividualViewModel.codigoAsistenciaField, adminOrStaff: false)
                                            if actividadIndividualViewModel.showAlertSheet != true {
                                                showVerificarAsistenciaSheet.toggle()
                                            }
                                        }
                                    }
                                },
                                codigoAsistenciaField: $actividadIndividualViewModel.codigoAsistenciaField,
                                codigoAsistencia: actividadIndividualViewModel.codigoAsistencia
                            )
                            .presentationDetents([.fraction(0.3)])
                            .alert(isPresented: $actividadIndividualViewModel.showAlertSheet) {
                                Alert(
                                    title: Text("Oops!"),
                                    message: Text(actividadIndividualViewModel.messageAlert),
                                    dismissButton: .default(Text("Aceptar")))
                            }
                        }
                    }
                }
                .navigationTitle(actividadIndividualViewModel.titulo)
                .sheet(item: $safariURL) { url in
                    SafariView(url: url)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Image(systemName: "person.2")
                    Text("\(actividadIndividualViewModel.personasInscritas)")
                        .foregroundColor(.primary)
                }
            }
        }
        .alert(isPresented: $actividadIndividualViewModel.showAlert) {
            switch actividadIndividualViewModel.alertType {
            case .success:
                return Alert(
                    title: Text("Éxito"),
                    message: Text(actividadIndividualViewModel.messageAlert),
                    dismissButton: .default(Text("Aceptar"))
                )
            case .error:
                return Alert(
                    title: Text("Oops!"),
                    message: Text(actividadIndividualViewModel.messageAlert),
                    dismissButton: .default(Text("Aceptar"))
                )
            case .errorIndividual:
                return Alert(
                    title: Text("Oops!"),
                    message: Text(actividadIndividualViewModel.messageAlert),
                    dismissButton: .default(Text("Aceptar")) {
                        path.removeLast()
                    }
                )
            case .none:
                return Alert(
                    title: Text("Información"),
                    message: Text(actividadIndividualViewModel.messageAlert),
                    dismissButton: .default(Text("Aceptar"))
                )
            }
        }
        .onAppear {
            Task {
                await actividadIndividualViewModel.consultarActividadIndividual(actividadID: id)
            }
        }
    }
}
