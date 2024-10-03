//
//  ImagePicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var selectedImageData: Data?

    var body: some View {
        VStack {
            // Si no hay imagen seleccionada, muestra el PhotosPicker
            if selectedImageData == nil {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.gray.opacity(0.1))
                        
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           UIImage(data: data) != nil {
                            selectedImageData = data
                        }
                    }
                }
            }

            // Mostrar la imagen si existe
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                    
                    Button(action: {
                        selectedImageData = nil
                    }, label: {
                        Text("Eliminar Imagen")
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    })
                }
            }

        }
    }
}
