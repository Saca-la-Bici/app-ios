//
//  Saca_la_BiciApp.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Configurar GIDSignIn con el clientID de Firebase
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("No se pudo obtener el clientID de Firebase")
        }
        
      return true
  }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var sessionManager = SessionManager()
    
    init() {
        let appearance = UINavigationBarAppearance()
        
        let darkerYellow = UIColor(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: darkerYellow,
            .underlineStyle: 0
        ]
        if let backImage = UIImage(systemName: "chevron.left")?.withTintColor(darkerYellow, renderingMode: .alwaysOriginal) {
            appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        }
        appearance.titleTextAttributes = [.foregroundColor: darkerYellow]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        UINavigationBar.appearance().tintColor = darkerYellow
    }
    
  var body: some Scene {
    WindowGroup {
      NavigationView {
          SessionCoordinatorView()
              .environmentObject(sessionManager)
      }
    }
  }
}
