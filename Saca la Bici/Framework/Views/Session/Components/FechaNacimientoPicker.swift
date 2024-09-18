//
//  FechaNacimientoPicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct FechaNacimientoPicker: View {
    @Binding var selectedMonth: String
    @Binding var selectedDay: String
    @Binding var selectedYear: String
    
    var months: [String]
    var days: [String]
    var years: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fecha de Nacimiento")
                .font(.title3)
                .fontWeight(.bold)
            Text("Esta información no será pública")
                .font(.caption)
            
            Spacer().frame(height: 15)
            
            HStack {
                // Picker de Mes
                Picker(selection: $selectedMonth, label: Text("Mes")) {
                    ForEach(months, id: \.self) {
                        Text($0)
                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                            .background(Color.clear)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 180, maxHeight: 130)
                .cornerRadius(10)
                .padding(.top, -20)
                
                // Picker de Día
                Picker(selection: $selectedDay, label: Text("Día")) {
                    ForEach(days, id: \.self) {
                        Text($0)
                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                            .background(Color.clear)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 65, maxHeight: 130)
                .cornerRadius(10)
                .padding(.top, -20)
                
                // Picker de Año
                Picker(selection: $selectedYear, label: Text("Año")) {
                    ForEach(years, id: \.self) {
                        Text($0)
                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                            .background(Color.clear)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 95, maxHeight: 130)
                .cornerRadius(10)
                .padding(.top, -20)
            }
        }
    }
}
