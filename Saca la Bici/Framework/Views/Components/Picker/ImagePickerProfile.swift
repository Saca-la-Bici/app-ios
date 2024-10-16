import PhotosUI
import SwiftUI

struct ImagePickerProfile: View {
    @Binding var selectedItem: PhotosPickerItem? // Item seleccionado del álbum
    @Binding var selectedImageData: Data? // Imagen seleccionada en formato Data
    var imageUrlString: String? // URL de la imagen desde el backend
    
    @State private var isPhotoPickerPresented = false // Estado para mostrar el PhotosPicker
    
    var body: some View {
        VStack {
            // Imagen de perfil o imagen seleccionada
            if let selectedImageData = selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                // Si el usuario selecciona una nueva imagen, mostrarla
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
            } else if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
                // Mostrar la imagen de perfil desde el backend
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    case .failure:
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Si no hay ninguna imagen, mostrar marcador de posición
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
            }

            // PhotosPicker para seleccionar la imagen
            Button {
                isPhotoPickerPresented = true // Muestra el PhotosPicker
            } label: {
                Text("Cambiar foto de perfil")
                    .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                    .padding(.top, 15)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onTapGesture {
            isPhotoPickerPresented = true // Abre el PhotosPicker tocando la imagen
        }
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   UIImage(data: data) != nil {
                    selectedImageData = data
                }
            }
        }
    }
}
