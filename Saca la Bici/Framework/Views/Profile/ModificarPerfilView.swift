//
//  ModificarPerfilView.swift
//  Saca la Bici
//
//  Created by Diego Lira on 09/10/24.
//

import SwiftUI

struct ModificarPerfilView: View {
    @State private var nombre = "Fernando Pérez López"
    @State private var nombreUsuario = "FerpXx_123"
    @State private var genero = "Hombre"
    @State private var presentacion = "Disfruto el ciclismo de montaña."
    @State private var nivel = "Experto"
    @State private var tipoSangre = "Sin seleccionar"
    let generos = ["Hombre", "Mujer", "Otro", "Prefiero no decir"]
    let niveles = ["Fácil", "Intermedio", "Experto"]
    let tiposSangre = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "No seleccionado"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Parte superior fija
                VStack {
                    // Imagen de perfil
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                    
                    // Botón para editar la foto
                    Text("Editar foto")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.top, 5)
                }
                .padding(.top, 20)
                
                // ScrollView para los campos de texto
                ScrollView {
                    VStack(spacing: 15) {
                        TextoLimiteField(label: "Nombre", placeholder: "Nombre", text: $nombre, maxLength: 30)
                        TextoLimiteField(label: "Nombre de usuario", placeholder: "Nombre de usuario", text: $nombreUsuario, maxLength: 20)
                        DropdownField(label: "Género", options: generos, selectedOption: $genero)
                        TextoLimiteField(label: "Presentación", placeholder: "Presentación", text: $presentacion, maxLength: 100)
                        DropdownField(label: "Nivel", options: niveles, selectedOption: $nivel)
                        DropdownField(label: "Tipo de sangre", options: tiposSangre, selectedOption: $tipoSangre)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
