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
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.gray.opacity(0.1))
                        
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
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
                        selectedItem = nil
                    }, label: {
                        Text("Eliminar Imagen")
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }

        }
    }
}
