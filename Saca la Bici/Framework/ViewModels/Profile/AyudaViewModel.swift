//
//  AyudaViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Foundation

class AyudaViewModel: ObservableObject {
    
    // Arrays de preguntas frecuentes
    @Published var preguntasFrecuentes: [FAQ] = []
    @Published var temas: [TemaFAQ] = []
    
    // Vars
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    // Obtener preguntas frecuentes
    func fetchPreguntasFrecuentes() async {
        
    }
    
    
}
