//
//  SessionManager.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isFireBaseAuthenticated: Bool = false
    @Published var isProfileComplete: Bool = false
    @Published var isErrorLogin: Bool = false
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    var signUpRequirement: SignUpRequirementProtocol
        
    init(signUpRequirement: SignUpRequirementProtocol = SignUpRequirement.shared) {
            self.signUpRequirement = signUpRequirement
            setupAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    private func setupAuthStateListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isFireBaseAuthenticated = user != nil
                if let user = user {
                    if self?.isExternalSignIn(user: user) == true {
                        self?.isAuthenticated = true
                        self?.checkProfileCompleteness()
                    }
                } else {
                    self?.isProfileComplete = false
                    self?.isLoading = false
                }
            }
        }
    }

    private func removeAuthStateListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateListenerHandle = nil
        }
    }
    
    private func isExternalSignIn(user: FirebaseAuth.User) -> Bool {
        for userInfo in user.providerData {
            if userInfo.providerID == "google.com" {
                return true
            } else if userInfo.providerID == "apple.com" {
                return true
            }
        }
        return false
    }
    
    func actualizarEstadoPerfilCompleto(_ completo: Bool) {
        DispatchQueue.main.async {
            self.isProfileComplete = completo
        }
    }
    
    func checkProfileCompleteness() {
        self.isLoading = true
        Task {
            do {
                let response = try await signUpRequirement.checarPerfilBackend()
                
                DispatchQueue.main.async {
                    if response.StatusCode == 500 {
                        self.isErrorLogin = true
                        self.errorMessage = "Hubo un error interno en el servidor. Inténtalo más tarde."
                    } else {
                        self.isProfileComplete = response.perfilRegistrado!
                        self.isErrorLogin = false
                        self.errorMessage = nil
                    }
                    self.isLoading = false // Finaliza la carga
                }
            } catch let urlError as URLError {
                DispatchQueue.main.async {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        self.errorMessage = "No tienes conexión a Internet. Verifica tu conexión e intenta nuevamente."
                    case .timedOut:
                        self.errorMessage = "La solicitud ha excedido el tiempo de espera. Inténtalo de nuevo más tarde."
                    default:
                        self.errorMessage = "Hubo un error al iniciar sesión. Inténtelo más tarde."
                    }
                    self.isErrorLogin = true
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Hubo un error al iniciar sesión. Inténtelo más tarde."
                    self.isErrorLogin = true
                    self.isLoading = false
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isProfileComplete = false
            isAuthenticated = false
            isFireBaseAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
