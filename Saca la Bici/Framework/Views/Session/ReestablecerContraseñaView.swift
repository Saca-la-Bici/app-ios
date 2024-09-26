//
//  ReestablecerContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import SwiftUI

struct RestablecerContrasenaView: View {
    
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()

    var body: some View {
        ScrollView {
            // Encabezado con botón de regresar y título
            HStack {
                Button(action: {
                    // Acción para regresar
                }, label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                Spacer()
                Text("Seguridad y acceso a la cuenta")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack(spacing: 8) {
                Image("Avatar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text("Guadalupe Rojas")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            .padding(.vertical)
            .padding(.top, 50)
            
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
                        }
                    }
                )
            }
        }
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

#Preview{
    RestablecerContrasenaView()
}
