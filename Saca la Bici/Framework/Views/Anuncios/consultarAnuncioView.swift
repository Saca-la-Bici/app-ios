//
//  consultarAnuncio.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 04/09/24.
//

import SwiftUI

struct consultarAnuncio: View {
    @StateObject private var viewModel = AnuncioViewModel()
    @State private var showAddAnuncioView = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Image("logoB&N")
                            .resizable()
                            .frame(width: 44, height: 35)
                            .padding(.leading)

                        Spacer()

                        Image(systemName: "bell")
                            .foregroundColor(.black)
                            .padding(.trailing)

                        Button(action: {
                            showAddAnuncioView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .padding(.trailing)
                        }
                    }
                    .padding()

                    Text("Anuncios")
                        .font(.title3)
                        .bold()
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.anuncios) { anuncio in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text(anuncio.icon)
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Color.purple)
                                            .clipShape(Circle())

                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(anuncio.titulo)
                                                .font(.headline)
                                                .fontWeight(.bold)

                                            Text(anuncio.contenido)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 16)
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .onAppear {
                viewModel.fetchAnuncios()
            }
            .sheet(isPresented: $showAddAnuncioView) {
                AnadirAnuncioView(viewModel: viewModel)
            }
            .alert(isPresented: Binding<Bool>(
                get: {
                    viewModel.successMessage != nil || viewModel.errorMessage != nil
                },
                set: { _ in
                    viewModel.successMessage = nil
                    viewModel.errorMessage = nil
                }
            )) {
                Alert(
                    title: Text("Anuncio"),
                    message: Text(viewModel.successMessage ?? viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    consultarAnuncio()
}
