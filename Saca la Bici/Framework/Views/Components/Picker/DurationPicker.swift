//
//  DuracionPicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 01/10/24.
//

import SwiftUI

struct DuracionPicker: View {
    var label: String
    @Binding var selectedDuration: TimeInterval
    @State private var showingSheet = false
    var title: Bool
    var disabled: Bool = false

    // Formateador para mostrar la duración seleccionada
    private var durationFormatter: String {
        let hours = Int(selectedDuration) / 3600
        let minutes = (Int(selectedDuration) % 3600) / 60
        return String(format: "%2d horas %2d minutos", hours, minutes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if title {
                Text(label)
                    .font(.title3)
                    .bold()
            } else {
                Text(label)
                    .font(.caption)
            }

            if !disabled {
                Button(action: {
                    showingSheet = true
                }, label: {
                    HStack {
                        Text(durationFormatter)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                })
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingSheet) {
                    VStack {
                        Text("Selecciona la duración")
                            .font(.headline)
                            .padding()

                        // Reemplaza con tu DurationPickerView
                        DurationPickerView(selectedDuration: $selectedDuration)

                        Button("Hecho") {
                            showingSheet = false
                        }
                        .padding(.top, 10)
                        .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .presentationDetents([.medium, .fraction(0.45)])
                }
            } else {
                HStack {
                    Text(durationFormatter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
