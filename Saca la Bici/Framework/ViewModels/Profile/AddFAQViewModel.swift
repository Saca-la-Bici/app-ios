//
//  AddFAQViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Foundation

class AddFAQViewModel: ObservableObject {
    
    // Variables
    @Published var tema: String = ""
    @Published var pregunta: String = ""
    @Published var respuesta: String = ""
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
}
