//
//  FourNumberField.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 13/10/24.
//

import SwiftUI
import Combine

struct FourNumberField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FourNumberField

        init(parent: FourNumberField) {
            self.parent = parent
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if self.parent.text.count > 4 {
                self.parent.text = String(self.parent.text.prefix(4))
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        
        // Observa los cambios en el texto y limita a 4 caracteres
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        textField.becomeFirstResponder()
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

extension FourNumberField.Coordinator {
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Limitar el texto a 4 caracteres
        if let text = textField.text, text.count > 4 {
            textField.text = String(text.prefix(4))
            parent.text = textField.text ?? ""
        } else {
            parent.text = textField.text ?? ""
        }
    }
}
