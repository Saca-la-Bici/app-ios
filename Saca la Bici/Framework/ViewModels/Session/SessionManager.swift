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
    @Published var isProfileComplete: Bool = false
    @Published var isErrorLogin: Bool = false
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
                self?.isAuthenticated = user != nil
                if let user = user {
                    if self?.isExternalSignIn(user: user) == true {
                        self?.checkProfileCompleteness()
                    } else {
                        // For email/password sign-in, assume profile is complete
                        self?.isProfileComplete = true
                    }
                } else {
                    self?.isProfileComplete = false
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
        Task {
            do {
                let response = try await signUpRequirement.checarPerfilBackend()
                
                if response.StatusCode == 500 {
                    DispatchQueue.main.async {
                        self.isErrorLogin = true
                        self.errorMessage = "Hubo un error interno en el servidor. Inténtalo más tarde."
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isProfileComplete = response.perfilRegistrado!
                        self.isErrorLogin = false
                        self.errorMessage = nil
                    }
                }
            } catch let urlError as URLError {
                DispatchQueue.main.async {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        self.errorMessage = "No tienes conexión a Internet. Verifica tu conexión e intenta nuevamente."
                        self.isErrorLogin = true
                    case .timedOut:
                        self.errorMessage = "La solicitud ha excedido el tiempo de espera. Inténtalo de nuevo más tarde."
                        self.isErrorLogin = true
                    default:
                        self.errorMessage = "Hubo un error al iniciar sesión. Inténtelo más tarde."
                        self.isErrorLogin = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Hubo un error al iniciar sesión. Inténtelo más tarde."
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isProfileComplete = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
