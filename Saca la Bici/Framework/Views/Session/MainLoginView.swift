//
//  MainLoginView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 15/09/24.
//

import SwiftUI
import AuthenticationServices

struct MainLoginView: View {
    // Para manejar las sesiones
    @EnvironmentObject var sessionManager: SessionManager
    
    // Estado para la pila de navegación
    @State private var path: [SessionPaths] = []
    
    // ViewModel para pasar a las otras vistas
    @StateObject var signUpViewModel = SignUpViewModel()
    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    Spacer()
                    Color(red: 0.961, green: 0.802, blue: 0.048)
                        .frame(height: 430)
                        .cornerRadius(25)
                }
                .edgesIgnoringSafeArea(.bottom)
                
                VStack(alignment: .center) {
                    
                    // Imagen del logo
                    Image("Logo_SacaLaBici")
                        .resizable()
                        .frame(width: 188.0, height: 147.0)
                        .padding(.top, 10) 
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .center, spacing: 10) {
                            Text("¡Explora y disfruta Querétaro!")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color.black)
                            
                            Text("Es genial tenerte aquí.")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundColor(Color.black)
                        }
                        
                        VStack {
                            MainViewButton(title: "Crea una cuenta",
                                           pathValue: .register,
                                             foregroundColor: .white,
                                             backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                                             hasOverlay: false,
                                             path: $path)
                            
                            MainViewButton(title: "Iniciar sesión",
                                           pathValue: .login,
                                             foregroundColor: .black,
                                             backgroundColor: .white,
                                             hasOverlay: true,
                                             path: $path)
                        }
                        
                        Spacer().frame(height: 10)
                        
                        Text("o continúa con")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity)
                        
                        // Botones para opciones de Google y Apple
                        VStack {
                            ExternalLoginButton(
                                action: {
                                    await signUpViewModel.GoogleLogin()
                                },
                                buttonText: "Continúa con Google",
                                imageName: "GoogleLogo",
                                systemImage: false
                            )
                            
                            Spacer().frame(height: 20)
                            
                            SignInWithAppleButton(
                                .signIn,
                                onRequest: { request in
                                    let hashedNonce = loginViewModel.prepareNonce()
                                    request.requestedScopes = [.fullName, .email]
                                    request.nonce = hashedNonce
                                },
                                onCompletion: { result in
                                    Task {
                                        await loginViewModel.AppleLogin(result: result)
                                    }
                                }
                            )
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 50)
                        }
                    }
                    .padding(.horizontal, 30.0)
                    .padding(.vertical, 20.0)
                    .background(.white)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.925, green: 0.925, blue: 0.925))
            .navigationDestination(for: SessionPaths.self) { value in
                switch value {
                case .login:
                    LoginView(path: $path)
                case .register:
                    SignUpStep1View(path: $path, signUpViewModel: signUpViewModel)
                case .continueRegistration:
                    SignUpStep2View(path: $path, signUpViewModel: signUpViewModel)
                case .finalizar:
                    SignUpStep3View(path: $path, signUpViewModel: signUpViewModel)
                case .olvidar:
                    PasswordRecoveryView<SessionPaths>(path: $path, showIniciarSesion: true)
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}
