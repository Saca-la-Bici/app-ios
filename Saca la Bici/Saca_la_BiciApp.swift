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
import Alamofire
import FirebaseAuth

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
        enviarTokenAlServidor(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?, error: Error?) {
        if let error = error {
            print("Error al obtener el token de FCM: \(error.localizedDescription)")
        } else if let fcmToken = fcmToken {
            enviarTokenAlServidor(fcmToken)
        }
    }

    // Manejar cuando el usuario toca una notificación
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if userInfo["anuncioID"] != nil {
            DispatchQueue.main.async {
                NotificationManager.shared.selectedTab = 2
            }
        }

        completionHandler()
    }
    
    // Método para enviar el token de FCM al servidor
    func enviarTokenAlServidor(_ token: String) {
        let url = URL(string: "\(Api.base)\(Api.Routes.session)/actualizarTokenNotificacion")!
        
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDToken { idToken, error in
                if let error = error {
                    print("Error al obtener el ID Token: \(error.localizedDescription)")
                    return
                }
                
                guard let idToken = idToken else {
                    print("No se pudo obtener el ID Token")
                    return
                }
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(idToken)",
                    "Content-Type": "application/json"
                ]
                
                let parameters: Parameters = [
                    "fcmToken": token
                ]
                
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .validate()
                    .response { response in
                        switch response.result {
                        case .success:
                            print("Token de FCM enviado exitosamente al servidor.")
                        case .failure(let error):
                            print("Error al enviar el token de FCM al servidor: \(error.localizedDescription)")
                        }
                    }
            }
        } else {
            print("No hay un usuario autenticado para enviar el token.")
        }
    }
}

@main
struct SacalaBiciApp: App {
    // Registrar el AppDelegate para configurar Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var sessionManager = SessionManager()
    
    init() {
        // Configuración de la apariencia de la navegación
        let appearance = UINavigationBarAppearance()
        
        let darkerYellow = UIColor(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0, alpha: 1.0)
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: darkerYellow,
            .underlineStyle: 0
        ]
        
        if let backImage = UIImage(systemName: "chevron.left")?.withTintColor(darkerYellow, renderingMode: .alwaysOriginal) {
            appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 212.0 / 255.0, green: 177.0 / 255.0, blue: 9.0 / 255.0, alpha: 1.0)
        
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
