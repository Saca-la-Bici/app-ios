//
//  Saca_la_BiciApp.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configurar Firebase
        FirebaseApp.configure()
        
        // Configurar Google Sign-In con el clientID de Firebase
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("No se pudo obtener el clientID de Firebase")
        }
        
        // Configurar Delegados para Messaging y Notificaciones
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Solicitar permiso para notificaciones
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Error al solicitar permisos de notificación: \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Permiso de notificación no otorgado")
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pasar el token de APNs (Apple) a FCM (Firebase)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error al registrar para notificaciones remotas: \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("No se pudo obtener el token de FCM")
            return
        }
        
        print("FCM Token: \(fcmToken)")
        // Enviar el token al servidor si es necesario
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?, error: Error?) {
        if let error = error {
            print("Error al obtener el token de FCM: \(error.localizedDescription)")
        } else if let fcmToken = fcmToken {
            print("FCM Token: \(fcmToken)")
            // Enviar el token al servidor si es necesario
        }
    }
}

@main
struct SacalaBiciApp: App {
    // Register app delegate for Firebase setup
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
