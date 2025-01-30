//
//  EliminarCuenta.swift
//  Saca la Bici
//
//  Created by Diego Lira on 27/01/25.
//
import Foundation
import SwiftUI
import AuthenticationServices

struct EliminarCuentaView: View {
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel()
    
    @StateObject private var eliminarCuentaViewModel = EliminarCuentaViewModel()
    @State private var mensajeResultado = ""
    @State private var mostrarMensaje = false
    @State private var mostrarConfirmacionEliminacion = false
    
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
                        
                        Spacer().frame(height: 10)
                        
                        if !restablecerContraseñaViewModel.showNuevaContraseñaFields {
                            
                            Text("""
                                Por motivos de seguridad, antes de eliminar tu cuenta debes reautenticarte.
                                Por favor, elige el método que prefieras para confirmar tu identidad.
                                """)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            
                            if eliminarCuentaViewModel.passwordUser == true {
                                
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
                                
                                Spacer().frame(height: 5)
                                
                                CustomButton(
                                    text: "Reautenticar con Contraseña",
                                    backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                                    action: {
                                        Task {
                                            await restablecerContraseñaViewModel.verificarContraseña()
                                        }
                                    }
                                )
                            }
                            
                            if (eliminarCuentaViewModel.googleUser == true || eliminarCuentaViewModel.appleUser == true)
                                && eliminarCuentaViewModel.passwordUser == true {
                                
                                Spacer().frame(height: 5)
                                
                                Text("o continúa con")
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            if eliminarCuentaViewModel.googleUser == true {
                                
                                Spacer().frame(height: 10)
                                
                                ExternalLoginButton(
                                    action: {
                                        Task {
                                            await restablecerContraseñaViewModel.GoogleLoginReauthentication()
                                        }
                                    },
                                    buttonText: "Reautenticar con Google",
                                    imageName: "GoogleLogo",
                                    systemImage: false
                                )
                            }
                            
                            if eliminarCuentaViewModel.appleUser == true {
                                Spacer().frame(height: 20)
                                
                                ExternalLoginButton(
                                    action: {
                                        Task {
                                            await restablecerContraseñaViewModel.reauthenticateWithApple()
                                        }
                                    },
                                    buttonText: "Reautenticar con Apple",
                                    imageName: "applelogo",
                                    systemImage: true
                                )
                            }
                        } else {
                            
                            Text("¡Listo! Ya verificamos tu identidad")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)

                                Text("""
                                     Al eliminar tu cuenta, perderás acceso a todas tus actividades, \
                                     datos y configuración. Esta acción es permanente y no se puede deshacer.
                                     """)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.bottom, 24)
                            
                            CustomButton(
                                text: "Eliminar Cuenta",
                                backgroundColor: Color(.red),
                                foregroundColor: Color(.white),
                                action: {
                                    mostrarConfirmacionEliminacion = true
                                }
                            ).alert("¿Estás seguro?", isPresented: $mostrarConfirmacionEliminacion) {
                                Button("Cancelar", role: .cancel) {}
                                Button("Eliminar", role: .destructive) {
                                    Task {
                                        mensajeResultado = await eliminarCuentaViewModel.eliminarCuenta()
                                    }
                                }
                            } message: {
                                Text("""
                                        Se eliminará tu cuenta y todos tus datos de forma permanente. 
                                        Esta acción no se puede deshacer. 
                                        ¿Deseas continuar?
                                        """)
                            }
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
        .navigationTitle("Eliminar Cuenta")
        .onAppear {
            Task {
                try await
                consultarPerfilPropioViewModel.consultarPerfilPropio()
            }
            eliminarCuentaViewModel.checarProveedores()
        }
    }
}

struct EliminarCuentaPreview_Previews: PreviewProvider {
    static var previews: some View {
        @State var path: [ConfigurationPaths] = []
        
        EliminarCuentaView(path: $path)
    }
}
