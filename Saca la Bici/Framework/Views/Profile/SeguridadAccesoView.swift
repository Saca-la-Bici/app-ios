//
//  SeguridadAccesoView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct SeguridadAccesoView: View {
    @ObservedObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel()
    
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        ZStack {
            if consultarPerfilPropioViewModel.isLoading == true {
                Spacer()
                ProgressView("Cargando datos...")
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ProfileImageView(imageUrlString: consultarPerfilPropioViewModel.profile?.imagen)
                        
                        Text(consultarPerfilPropioViewModel.profile?.nombre ?? "")
                            .font(.system(size: 15))
                        
                        Spacer().frame(height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Datos sobre tu cuenta")
                                .foregroundColor(.gray)
                                .font(.callout)
                                .bold()
                                .padding(.leading, 20)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .scaleEffect(1.5)
                                VStack(alignment: .leading) {
                                    Text("Fecha en la que se unió:")
                                    
                                    Spacer().frame(height: 10)
                                    
                                    Text(FechaManager.shared.formatDate(consultarPerfilPropioViewModel.profile?.fechaRegistro ?? ""))
                                }
                                .padding(.leading, 20)
                            }
                            .padding()
                            .padding(.horizontal, 5)
                            
                            if restablecerContraseñaViewModel.showRestablecer == true {
                                Divider()
                                
                                Spacer().frame(height: 20)
                                
                                Text("Seguridad y acceso a la cuenta")
                                    .foregroundColor(.gray)
                                    .font(.callout)
                                    .bold()
                                    .padding(.leading, 20)
                                
                                Spacer().frame(height: 20)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    BotonSection(icono: "person.badge.key",
                                                 titulo: "Restablece tu contraseña",
                                                 button: true,
                                                 path: $path,
                                                 nextPath: .password)
                                }
                                .padding(.horizontal, 15)
                            }
                            
                            Spacer().frame(height: 40)
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    // Acción para eliminar cuenta
                                }, label: {
                                    Text("Eliminar cuenta")
                                        .fontWeight(.bold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 100)
                                        .background(Color.red)
                                        .cornerRadius(25)
                                        .shadow(radius: 5)
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical)
                    .padding(.top, 20)
                }
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
            }
        }
        .navigationTitle("Tu Cuenta")
        .onAppear {
            Task {
                try await
                consultarPerfilPropioViewModel.consultarPerfilPropio()
            }
        }
        .alert(isPresented: .constant(consultarPerfilPropioViewModel.errorMessage != nil)) {
            Alert(
                title: Text("Oops!"),
                message: Text("Hubo un error al cargar los datos. Favor de intentar de nuevo."),
                dismissButton: .default(Text("Aceptar"), action: {
                    consultarPerfilPropioViewModel.errorMessage = nil
                })
            )
        }
    }
}

struct SeguridadAccesoView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            SeguridadAccesoView(path: $path)
        }
    }
}
