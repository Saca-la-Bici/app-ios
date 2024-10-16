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
    
    @FocusState var showkeyboard: Bool
    @Binding var showAlertSheet: Bool
    
    var body: some View {
        VStack {
            if userSessionManager.puedeVerificarAsistencia() {
                HStack {
                    Text("Código de Verificación: ")
                        .font(.system(size: 16)) // Tamaño normal para el texto
                    Text(codigoAsistencia)
                        .font(.system(size: 34, weight: .bold)) // Tamaño grande y negrita para el número
                }
                .padding(.vertical, 20) // Espaciado vertical

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
                
                CodigoNumericoView(codigo: $codigoAsistenciaField, limite: 4)
                     .padding()
                     .focused($showkeyboard)
                
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
        .onAppear {
            if !showAlertSheet {
                showkeyboard = true
            }
        }
        .onChange(of: showAlertSheet) {
            if showAlertSheet {
                // Si la alerta está activa, ocultar el teclado
                showkeyboard = false
            } else {
                // Si la alerta se ha cerrado, mostrar el teclado nuevamente
                showkeyboard = true
            }
        }
        .padding()
    }
}
