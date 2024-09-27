//
//  ReestablecerContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import SwiftUI

struct RestablecerContrasenaView: View {
    
    @Binding var path: [ConfigurationPaths]
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Image("Profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text("Guadalupe Rojas")
                    .font(.system(size: 15))
                
                if restablecerContraseñaViewModel.showNuevaContraseñaFields == false {
                    
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
                }
                
                if restablecerContraseñaViewModel.showNuevaContraseñaFields == true {
                    
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
                                
                                if restablecerContraseñaViewModel.showAlert == false {
                                    path.removeLast()
                                }
                            }
                        }
                    )
                }
            }
            .padding(.vertical)
            .padding(.top, 20)
        }
        .navigationTitle("Restablecer Contraseña")
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .alert(isPresented: $restablecerContraseñaViewModel.showAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(restablecerContraseñaViewModel.messageAlert)
            )
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
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
