//
//  TelefonoEmergenciaField.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI
import Combine

struct TelefonoEmergenciaField: View {
    @Binding var countryCode: String
    @Binding var phoneNumber: String
    var maxCountryCodeLength: Int = 3
    var maxPhoneNumberLength: Int = 12
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Número de Emergencia")
                .font(.caption)
            
            HStack {
                Text("+")
                    .font(.title2)
                    .padding(.leading, 10)
                
                TextField("País", text: $countryCode)
                    .keyboardType(.numberPad)
                    .frame(width: 60)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .onReceive(Just(countryCode)) { _ in
                        if countryCode.count > maxCountryCodeLength {
                            countryCode = String(countryCode.prefix(maxCountryCodeLength))
                        }
                    }
                
                TextField("Teléfono", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .onReceive(Just(phoneNumber)) { _ in
                        if phoneNumber.count > maxPhoneNumberLength {
                            phoneNumber = String(phoneNumber.prefix(maxPhoneNumberLength))
                        }
                    }
            }
        }
    }
}
