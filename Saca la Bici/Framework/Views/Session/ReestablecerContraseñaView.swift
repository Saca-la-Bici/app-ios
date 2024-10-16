//
//  ReestablecerContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import SwiftUI

struct RestablecerContrasenaView: View {
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
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
                        
                        if !restablecerContraseñaViewModel.showNuevaContraseñaFields {
                            
                            // Campo de Contraseña Actual
                            PasswordField(
                                password: $restablecerContraseñaViewModel.currentPassword,
                                isPasswordVisible: $restablecerContraseñaViewModel.showCurrentPassword,
                                text: "Contraseña actual"
                            )
                            
                            // ¿Olvidaste tu contraseña?
                            Button(action: {
                                path.append(.olvidar)
                            }, label: {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.caption)
                                    .underline()
                            })
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer().frame(height: 40)
                            
                            CustomButton(
                                text: "Verificar",
                                backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                                action: {
                                    Task {
                                        await restablecerContraseñaViewModel.verificarContraseña()
                                    }
                                }
                            )
                        } else {
                            
                            PasswordField(
                                password: $restablecerContraseñaViewModel.newPassword,
                                isPasswordVisible: $restablecerContraseñaViewModel.showNewPassword,
                                text: "Nueva Contraseña"
                            )
                            
                            Spacer().frame(height: 20)

                            // Campo de Confirmar Nueva Contraseña
                            PasswordField(
                                password: $restablecerContraseñaViewModel.confirmPassword,
                                isPasswordVisible: $restablecerContraseñaViewModel.showConfirmPassword,
                                text: "Confirmar Nueva Contraseña"
                            )
                            
                            Spacer().frame(height: 40)
                            
                            CustomButton(
                                text: "Restablecer Contraseña",
                                backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                                action: {
                                    Task {
                                        await restablecerContraseñaViewModel.restablecerContraseña()
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    .padding(.top, 20)
                    .alert(isPresented: $restablecerContraseñaViewModel.showAlert) {
                        if !restablecerContraseñaViewModel.alertSuccess {
                            return Alert(
                                title: Text("Oops!"),
                                message: Text(restablecerContraseñaViewModel.messageAlert)
                            )
                        } else if restablecerContraseñaViewModel.alertTiempo == true {
                            return Alert(
                                title: Text("Oops!"),
                                message: Text(restablecerContraseñaViewModel.messageAlert),
                                dismissButton: .default(Text("OK")) {
                                    path.removeLast()
                                }
                            )
                        } else if consultarPerfilPropioViewModel.errorMessage != nil {
                            return Alert(
                                title: Text("Oops!"),
                                message: Text("Hubo un error al cargar los datos. Favor de intentar de nuevo."),
                                dismissButton: .default(Text("Aceptar"), action: {
                                    consultarPerfilPropioViewModel.errorMessage = nil
                                }))
                        } else {
                            return Alert(
                                title: Text("¡Éxito!"),
                                message: Text(restablecerContraseñaViewModel.messageAlert),
                                dismissButton: .default(Text("OK")) {
                                    path.removeLast()
                                }
                            )
                        }
                    }
                }
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
            }
        }
        .navigationTitle("Restablecer Contraseña")
        .onAppear {
            Task {
                try await
                consultarPerfilPropioViewModel.consultarPerfilPropio()
            }
        }
    }
}

struct RestablecerContrasenaView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            RestablecerContrasenaView(path: $path)
        }
    }
}
