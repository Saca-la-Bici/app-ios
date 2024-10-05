//
//  HoraPicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import SwiftUI

struct HoraPicker: View {
    var label: String
    @Binding var selectedTime: Date
    @State private var showingSheet = false
    var title: Bool

    // Formateador de la hora para mostrar en el botón
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
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

            Button(action: {
                showingSheet = true
            }, label: {
                HStack {
                    Text(timeFormatter.string(from: selectedTime))
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
                    Text("Selecciona la hora")
                        .font(.headline)
                        .padding()

                    DatePicker(
                        "",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()

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
        }
        .frame(maxWidth: .infinity)
    }
}
