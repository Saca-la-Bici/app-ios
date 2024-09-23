//
//  CoordinatorView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import SwiftUI

struct SessionCoordinatorView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    @State private var isAppLoading = false
    @State private var pendingErrorMessage: String?

    var body: some View {
        ZStack {
            if isAppLoading || sessionManager.isLoading {
                LoadingView()
            }
            else if sessionManager.isAuthenticated {
                if sessionManager.isProfileComplete {
                    MenuView()
                } else {
                    if sessionManager.isErrorLogin {
                        MainLoginView()
                    } else {
                        CompletarDatosStep1View()
                    }
                }
            } else {
                MainLoginView()
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Reintentar")) {
                    sessionManager.checkProfileCompleteness()
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
        .onReceive(sessionManager.$errorMessage) { errorMessage in
            if let message = errorMessage {
                if isAppLoading || sessionManager.isLoading {
                    pendingErrorMessage = message
                } else {
                    alertMessage = message
                    showErrorAlert = true
                }
            }
        }
        .onChange(of: isAppLoading) {
            checkAndShowPendingError()
        }

        .onChange(of: sessionManager.isLoading) {
            checkAndShowPendingError()
        }
        .onAppear {
            triggerAppLoading()
        }
    }
    
    private func checkAndShowPendingError() {
        if !isAppLoading && !sessionManager.isLoading, let message = pendingErrorMessage {
            alertMessage = message
            showErrorAlert = true
            pendingErrorMessage = nil
        }
    }
    
    private func triggerAppLoading() {
        isAppLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isAppLoading = false
        }
    }
}
