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
    @State private var hasLaunchedOnce = false

    var body: some View {
        Group {
            if isAppLoading || sessionManager.isLoading {
                LoadingView()
            }
            else if sessionManager.isAuthenticated {
                if sessionManager.isProfileComplete {
                    NavigationStack {
                        MenuView()
                    }
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
                alertMessage = message
                showErrorAlert = true
            }
        }
        .onAppear {
            triggerAppLoading()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            triggerAppLoading()
        }
    }
    
    private func triggerAppLoading() {
        isAppLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isAppLoading = false
        }
    }
}
