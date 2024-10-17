//
//  ConsultarPerfilPropioViewModel.swift
//  Saca la Bici
//
//  Created by Diego Lira on 24/09/24.
//

import Foundation
import FirebaseAuth

class ConsultarPerfilPropioViewModel: ObservableObject {
    static let shared = ConsultarPerfilPropioViewModel()
    @Published var profile: Profile?
    @Published var isLoading: Bool = true
    @Published var error: Error?
    @Published var errorMessage: String?
    @Published var showAlert = false
    
    // Ahorros ambientales
       @Published var waterSaved: Float = 0.0
       @Published var co2Saved: Float = 0.0
       @Published var airCleaned: Float = 0.0
       @Published var gasSaved: Float = 0.0

       // Porcentajes
       @Published var percentageWater: Float = 0.0
       @Published var percentageCO2: Float = 0.0
       @Published var percentageAir: Float = 0.0
       @Published var percentageGas: Float = 0.0

       // Valores máximos (ahora publicados)
       @Published var maxWater: Float = 80
       @Published var maxCO2: Float = 30
       @Published var maxAir: Float = 5
       @Published var maxGas: Float = 30
    
    let consultarPerfilPropioRequirement = ConsultarPerfilPropioRequirement()
    
    @MainActor
    func consultarPerfilPropio() async throws {
        self.isLoading = true
        do {
            
            self.profile = try await consultarPerfilPropioRequirement.consultarPerfilPropio()
            self.profile?.tipoSangre = profile?.tipoSangre?.isEmpty == true ? "Sin seleccionar" : profile?.tipoSangre ?? "Sin seleccionar"
            
        } catch {
            self.showAlert = true
            self.errorMessage = "Hubo un error al ingresar a tu perfil, intente de nuevo más tarde"
            
            // Manejo del error en caso de que algo falle
            print("Error: \(error.localizedDescription)")
            throw error
        }
        self.isLoading = false
    }
    
    func calcularEstadisticas(kilometers: Float) {
            // Valores de referencia
            let versaGasConsume: Float = 9.0 // km por litro
            let emissionCO2: Float = 2.31 // kg de CO2 por litro de gasolina
            let NOx: Float = 0.05 // g de NOx por kilómetro

            // Cálculos de ahorro
            let water = (kilometers / versaGasConsume) * 3 // Agua ahorrada (L)
            let co2 = (kilometers / versaGasConsume) * emissionCO2 // CO2 no emitido (kg)
            let air = kilometers * NOx // Aire limpio (g)
            let gas = kilometers / versaGasConsume // Gasolina ahorrada (L)

            // Asignar los valores calculados a las variables de estado
            self.waterSaved = min(water, maxWater)
            self.co2Saved = min(co2, maxCO2)
            self.airCleaned = min(air, maxAir)
            self.gasSaved = min(gas, maxGas)
        }
    
}
