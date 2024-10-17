//
//  UIApplicationExtensions.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 15/09/24.
//

import UIKit
import SwiftUI
import Foundation
import DurationPicker

// https://medium.com/@kennjthn12/authentication-using-google-sign-in-with-swift-31039941dabf
final class GetViewController {
    static let shared = GetViewController()
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

extension UIApplication {
    func hideKeyboard() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DurationPickerView: UIViewRepresentable {
    @Binding var selectedDuration: TimeInterval

    func makeUIView(context: Context) -> DurationPicker {
        let picker = DurationPicker()
        picker.pickerMode = .hourMinute
        picker.minuteInterval = 5
        picker.addTarget(context.coordinator, action: #selector(context.coordinator.durationChanged(_:)), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: DurationPicker, context: Context) {
        // Solo actualiza si la duración seleccionada ha cambiado para evitar demasiadas actualizaciones
        if uiView.duration != selectedDuration {
            uiView.setDuration(selectedDuration, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinador para manejar eventos del DurationPicker
    class Coordinator: NSObject {
        var parent: DurationPickerView

        init(_ parent: DurationPickerView) {
            self.parent = parent
        }

        // Método que se llama cuando la duración cambia
        @objc func durationChanged(_ sender: DurationPicker) {
            // Evitar cambios innecesarios para mejorar el rendimiento
            let newDuration = sender.duration
            if parent.selectedDuration != newDuration {
                DispatchQueue.main.async {
                    self.parent.selectedDuration = newDuration
                }
            }
        }
    }
}
