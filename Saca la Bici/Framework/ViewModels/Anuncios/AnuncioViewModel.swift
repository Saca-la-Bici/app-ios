//
//  AnuncioViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import SwiftUI
import Foundation
import Alamofire

@MainActor
class AnuncioViewModel: ObservableObject {
    @Published var anuncios: [Anuncio] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    @Published var registrarAnuncio: Bool = false
    @Published var modificarAnuncio: Bool = false
    @Published var eliminarAnuncio: Bool = false
    
    private let repository: AnuncioRepository
    
    init(repository: AnuncioRepository = AnuncioRepository()) {
        self.repository = repository
    }
    
    func fetchAnuncios() async {
        do {
            // Llamas la función con el Rol y anuncios
            let response = try await repository.getAnuncios()
            
            // Sacas los anuncios
            var anuncios = response.anuncio
            anuncios = anuncios.map { anuncio in
                var anuncioModificado = anuncio
                anuncioModificado.icon = "A"
                anuncioModificado.backgroundColor = Color(UIColor.systemGray6)
                return anuncioModificado
            }.reversed()
            self.anuncios = Array(anuncios)
            
            if response.permisos.contains("Registrar anuncio") {
                self.registrarAnuncio = true
            }
            
            if response.permisos.contains("Modificar anuncio") {
                self.modificarAnuncio = true
            }
            
            if response.permisos.contains("Eliminar anuncio") {
                self.eliminarAnuncio = true
            }
            
        } catch {
            self.handleError(error)
        }
    }
    
    func registrarAnuncio(titulo: String, contenido: String) async {
        let nuevoAnuncio = Anuncio(
            id: UUID().uuidString,
            titulo: titulo,
            contenido: contenido,
            imagen: "",
            createdAt: "",
            fechaCaducidad: ""
        )
        
        do {
            let message = try await repository.postAnuncio(nuevoAnuncio)
            self.successMessage = message
            await fetchAnuncios()
        } catch {
            self.handleError(error)
        }
    }
    
    func eliminarAnuncio(idAnuncio: String) async {
        do {
            let message = try await repository.eliminarAnuncio(idAnuncio: idAnuncio)
            self.successMessage = message
            await fetchAnuncios()
        } catch {
            self.handleError(error)
        }
    }
    
    func modificarAnuncio(anuncio: Anuncio, nuevoTitulo: String, nuevoContenido: String) async {
        do {
            var anuncioModificado = anuncio
            anuncioModificado.titulo = nuevoTitulo
            anuncioModificado.contenido = nuevoContenido

            // Asegúrate de pasar el ID del anuncio a modificar
            let updatedAnuncio = try await repository.modificarAnuncio(anuncioModificado, idAnuncio: anuncio.id)
            
            self.successMessage = "Anuncio modificado exitosamente."

            if let index = self.anuncios.firstIndex(where: { $0.id == anuncio.id }) {
                self.anuncios[index] = updatedAnuncio
            }
        } catch {
            self.handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        if let afError = error as? AFError {
            switch afError.responseCode {
            case 401:
                self.errorMessage = "No autorizado. Por favor, inicia sesión nuevamente."
            default:
                self.errorMessage = "Error: \(afError.errorDescription ?? "Desconocido")"
            }
        } else {
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
    }
}
