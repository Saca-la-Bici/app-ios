//
//  CoordinatorView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import SwiftUI

// Main view to manage navigation flow on different presentations mode
struct SessionCoordinatorView: View {
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        if sessionManager.isAuthenticated {
            NavigationStack {
                MenuView()
            }
        } else {
            MainLoginView()
        }
    }
}

#Preview {
    SessionCoordinatorView()
}

