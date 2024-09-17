import SwiftUI
import SwiftData

struct MenuView: View {
    @State private var selectedTab = 3

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // Contenido del TabView personalizado
                VStack {
                    if selectedTab == 0 {
                       ResultView()
                    } else if selectedTab == 1 {
                        ResultView()
                    } else if selectedTab == 2 {
                        ResultView()
                    } else {
                        ResultView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Custom Tab Bar
                HStack {
                    Spacer()
                    CustomTabBarButton(imageName: "bicycle", text: "Actividades", isSelected: selectedTab == 0)
                        .onTapGesture {
                            selectedTab = 0
                        }
                    Spacer()
                    CustomTabBarButton(imageName: "map", text: "Mapa", isSelected: selectedTab == 1)
                        .onTapGesture {
                            selectedTab = 1
                        }
                    Spacer()
                    CustomTabBarButton(imageName: "megaphone", text: "Anuncios", isSelected: selectedTab == 2)
                        .onTapGesture {
                            selectedTab = 2
                        }
                    Spacer()
                    CustomTabBarButton(imageName: "person", text: "Perfil", isSelected: selectedTab == 3)
                        .onTapGesture {
                            selectedTab = 3
                        }
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(Color(red: 242.0 / 255.0, green: 240.0 / 255.0, blue: 234.0 / 255.0))
            }
            .navigationBarHidden(true)
        }
    }
}

struct CustomTabBarButton: View {
    var imageName: String
    var text: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .foregroundColor(isSelected ? Color.yellow : Color.black)
                .padding(10)
                .background(isSelected ? Color.black : Color.clear)
                .cornerRadius(35)
                .frame(width: 80, height: 30)
            
            Text(text)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(isSelected ? Color.black : Color.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
