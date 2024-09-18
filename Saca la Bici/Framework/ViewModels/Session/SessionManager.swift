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
    
    private func checkProfileCompleteness() {
        Task {
            let isComplete = await signUpRequirement.checarPerfilBackend()
            DispatchQueue.main.async {
                self.isProfileComplete = isComplete
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
