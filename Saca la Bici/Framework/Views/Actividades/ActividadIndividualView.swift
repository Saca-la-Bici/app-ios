//
//  ActividadIndividualView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseInAppMessaging

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
                    
                    if actividadIndividualViewModel.tipo == "Rodada" {
                        HStack {
                            Button(action: {
                                // Acción para Materiales
                            }, label: {
                                Text("Decálogo del Ciclista")
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
                    }

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

                    if actividadIndividualViewModel.usuarioVerificado == false {
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
                    }
                    
                    if actividadIndividualViewModel.tipo == "Rodada" &&
                        actividadIndividualViewModel.usuarioVerificado == false &&
                        actividadIndividualViewModel.isJoined == true {
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
                                        }
                                    } else {
                                        Task {
                                            await actividadIndividualViewModel.verificarAsistencia(
                                                IDRodada: id,
                                                codigoAsistencia: actividadIndividualViewModel.codigoAsistenciaField, adminOrStaff: false)
                                        }
                                    }
                                },
                                codigoAsistenciaField: $actividadIndividualViewModel.codigoAsistenciaField,
                                codigoAsistencia: actividadIndividualViewModel.codigoAsistencia,
                                showAlertSheet: $actividadIndividualViewModel.showAlertSheet
                            )
                            .presentationDetents([.fraction(0.35)])
                            .alert(isPresented: $actividadIndividualViewModel.showAlertSheet) {
                                switch actividadIndividualViewModel.alertTypeSheet {
                                case .success:
                                    return Alert(
                                        title: Text("Éxito"),
                                        message: Text(actividadIndividualViewModel.messageAlert),
                                        dismissButton: .default(Text("Aceptar")) {
                                            showVerificarAsistenciaSheet.toggle()
                                            actividadIndividualViewModel.codigoAsistenciaField = ""
                                            InAppMessaging.inAppMessaging().triggerEvent("medal_earned")
                                            actividadIndividualViewModel.usuarioVerificado = true
                                        }
                                    )
                                case .error:
                                    return Alert(
                                        title: Text("Oops!"),
                                        message: Text(actividadIndividualViewModel.messageAlert),
                                        dismissButton: .default(Text("Aceptar"))
                                    )
                                case .errorInscrito:
                                    return Alert(
                                        title: Text("Oops!"),
                                        message: Text(actividadIndividualViewModel.messageAlert),
                                        dismissButton: .default(Text("Aceptar")) {
                                            showVerificarAsistenciaSheet.toggle()
                                            actividadIndividualViewModel.codigoAsistenciaField = ""
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
                        }
                    }
                    
                    if actividadIndividualViewModel.usuarioVerificado == true {
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 22))
                                .foregroundColor(ColorManager.shared.colorFromHex("#7DA68D"))

                            Text("¡Ya verificaste tu asistencia para esta rodada!")
                                .foregroundColor(.primary)
                                .font(.system(size: 18, weight: .bold))
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                                .shadow(radius: 5)
                        )
                        .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 10)
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
