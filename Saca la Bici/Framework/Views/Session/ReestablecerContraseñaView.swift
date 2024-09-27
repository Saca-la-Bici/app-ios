//
//  ReestablecerContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import SwiftUI

struct RestablecerContrasenaView: View {
    @ObservedObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
    @Binding var path: [ConfigurationPaths]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    Image("Profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text("Guadalupe Rojas")
                        .font(.system(size: 15))
                    
                    Spacer().frame(height: 40)
                    
                    if !restablecerContraseñaViewModel.showNuevaContraseñaFields {
                        
                        // Campo de Contraseña Actual
                        PasswordField(
                            password: $restablecerContraseñaViewModel.currentPassword,
                            isPasswordVisible: $restablecerContraseñaViewModel.showCurrentPassword,
                            text: "Contraseña actual"
                        )
                        
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
            .navigationTitle("Restablecer Contraseña")
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
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
