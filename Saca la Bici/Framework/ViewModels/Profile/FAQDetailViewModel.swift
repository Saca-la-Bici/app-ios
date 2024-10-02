//
//  FAQDetailViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 30/09/24.
//

import Alamofire
import Foundation

@MainActor
class FAQDetailViewModel: ObservableObject {
    
    // Variables
    @Published var faq: FAQ?
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    // Inicializar
    init(repository: FAQRepository = FAQRepository()) {
        self.repository = repository
    }
    
}
