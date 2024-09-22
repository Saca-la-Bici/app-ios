//
//  AnuncioViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import SwiftUI
import Foundation

class AnuncioViewModel: ObservableObject {
    @Published var anuncios: [Anuncio] = []
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    
    private let repository: AnuncioRepository
    
    init(repository: AnuncioRepository = AnuncioRepository()) {
        self.repository = repository
    }
    
    // Función para obtener los anuncios
    func fetchAnuncios() {
        repository.getAnuncios { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let anuncios):
                    print("Anuncios obtenidos: \(anuncios.count)")
                    self.anuncios = anuncios.map { anuncio in
                        var anuncioModificado = anuncio
                        anuncioModificado.icon = "A"
                        anuncioModificado.backgroundColor = Color(UIColor.systemGray6)
                        return anuncioModificado
                    }.reversed()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Función para registrar un anuncio
    func registrarAnuncio(titulo: String, contenido: String) {
        let nuevoAnuncio = Anuncio(id: UUID().uuidString, IDUsuario: 1, titulo: titulo, contenido: contenido, imagen: "", createdAt: "", fechaCaducidad: "")

        repository.postAnuncio(nuevoAnuncio) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.successMessage = message
                    print("Registro exitoso. Llamando a fetchAnuncios()")
                    self.fetchAnuncios()
                case .failure(let error):
                    self.errorMessage = "Error al registrar el anuncio: \(error.localizedDescription)"
                }
            }
        }
    }

    // Función para eliminar un anuncio
       func eliminarAnuncio(idAnuncio: String) {
           repository.eliminarAnuncio(idAnuncio: idAnuncio) { result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let message):
                       self.successMessage = message
                       self.fetchAnuncios()
                   case .failure(let error):
                       self.errorMessage = error.localizedDescription
                   }
               }
           }
       }
    
    // Función para modificar un anuncio
       func modificarAnuncio(anuncio: Anuncio, nuevoTitulo: String, nuevoContenido: String) {
           repository.modificarAnuncio(idAnuncio: anuncio.id, titulo: nuevoTitulo, contenido: nuevoContenido) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let message):
                       self?.successMessage = message
                       // Actualiza la lista de anuncios localmente
                       if let index = self?.anuncios.firstIndex(where: { $0.id == anuncio.id }) {
                           self?.anuncios[index].titulo = nuevoTitulo
                           self?.anuncios[index].contenido = nuevoContenido
                       }
                   case .failure(let error):
                       self?.errorMessage = "Error al modificar el anuncio: \(error.localizedDescription)"
                   }
               }
           }
       }
}
