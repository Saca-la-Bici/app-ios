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

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    private func setupAuthStateListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }

    private func removeAuthStateListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateListenerHandle = nil
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
