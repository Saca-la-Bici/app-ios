//
//  UIApplicationExtensions.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 15/09/24.
//

import UIKit
import SwiftUI
import Foundation

// https://medium.com/@kennjthn12/authentication-using-google-sign-in-with-swift-31039941dabf
final class getViewController {
    static let shared = getViewController()
    private init() {}
    
    @MainActor
    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseController = base ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow }?.rootViewController

        if let nav = baseController as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = baseController as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }

        if let presented = baseController?.presentedViewController {
            return topViewController(base: presented)
        }

        return baseController
    }
}
