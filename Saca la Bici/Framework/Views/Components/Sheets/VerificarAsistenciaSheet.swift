//
//  VerificarAsistenciaSheet.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 13/10/24.
//

import SwiftUI

struct VerificarAsistenciaSheet: View {
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    var verificarAction: () -> Void
    @Binding var codigoAsistenciaField: String
    var codigoAsistencia: String
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            if userSessionManager.puedeVerificarAsistencia() {
                Text("Código de Verificación: \(codigoAsistencia)")
                    .font(.headline)
                    .padding()
                
                CustomButton(
                    text: "Verificar Asistencia",
                    backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                    foregroundColor: .white,
                    action: {
                        verificarAction()
                    },
                    tieneIcono: true,
                    icono: "checkmark.circle"
                )
                .padding()
            } else {
                Text("Ingresa el código de verificación")
                    .font(.headline)
                    .padding()
                
                FourNumberField(text: $codigoAsistenciaField, placeholder: "Código de 4 dígitos")
                     .padding()
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                
                CustomButton(
                    text: "Verificar",
                    backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                    foregroundColor: .white,
                    action: {
                        verificarAction()
                    },
                    tieneIcono: true,
                    icono: "checkmark.circle"
                )
                .padding()
            }
        }
        .padding()
    }
}
