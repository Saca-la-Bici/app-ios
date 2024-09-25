//
//  AnuncioViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import Alamofire

class AnuncioViewModel: ObservableObject {
    @Published var anuncios: [Anuncio] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isUserAuthenticated: Bool = false
    
    private let repository: AnuncioRepository
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init(repository: AnuncioRepository = AnuncioRepository()) {
        self.repository = repository
        self.observeAuthenticationState()
    }

    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    private func observeAuthenticationState() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.isUserAuthenticated = user != nil
            }
        }
    }
    
    func fetchAnuncios() {
        guard isUserAuthenticated else {
            self.errorMessage = "Usuario no autenticado. Por favor, inicia sesión."
            return
        }
        
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
                    self.handleError(error)
                }
            }
        }
    }

    func registrarAnuncio(titulo: String, contenido: String) {
        guard isUserAuthenticated else {
            self.errorMessage = "Usuario no autenticado. Por favor, inicia sesión."
            return
        }
        
        let nuevoAnuncio = Anuncio(id: UUID().uuidString,
                                   titulo: titulo, contenido: contenido, imagen: "", createdAt: "", fechaCaducidad: "")
        
        repository.postAnuncio(nuevoAnuncio) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.successMessage = message
                    print("Registro exitoso. Llamando a fetchAnuncios()")
                    self.fetchAnuncios()
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    func eliminarAnuncio(idAnuncio: String) {
        guard isUserAuthenticated else {
            self.errorMessage = "Usuario no autenticado. Por favor, inicia sesión."
            return
        }
        
        repository.eliminarAnuncio(idAnuncio: idAnuncio) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.successMessage = message
                    self.fetchAnuncios()
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func modificarAnuncio(anuncio: Anuncio, nuevoTitulo: String, nuevoContenido: String) {
        guard isUserAuthenticated else {
            self.errorMessage = "Usuario no autenticado. Por favor, inicia sesión."
            return
        }
        
        repository.modificarAnuncio(idAnuncio: anuncio.id, titulo: nuevoTitulo, contenido: nuevoContenido) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.successMessage = message
                    if let index = self?.anuncios.firstIndex(where: { $0.id == anuncio.id }) {
                        self?.anuncios[index].titulo = nuevoTitulo
                        self?.anuncios[index].contenido = nuevoContenido
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
            }
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

