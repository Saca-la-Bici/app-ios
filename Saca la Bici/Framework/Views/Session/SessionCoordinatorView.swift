//
//  CoordinatorView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import SwiftUI

struct SessionCoordinatorView: View {
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        if sessionManager.isAuthenticated {
            if sessionManager.isProfileComplete {
                NavigationStack {
                    MenuView()
                }
            } else {
                CompletarDatosStep1View()
            }
        } else {
            MainLoginView()
        }
    }
}

#Preview {
    SessionCoordinatorView()
}

