import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            FooterView()
        }
    }
}

struct HeaderView: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            if let image = UIImage(named: "FestiGames") {
                Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
            }else {
                Text("FESTIGAMES")
            }
            Spacer()
            Button(action: {
                print("Button tapped")
            }) {
                Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
            }
            Spacer().frame(width: 20)
        }
                .padding()
                .foregroundColor(.white)
                .background(Color(red: 0.651, green: 0.294, blue: 0.165, opacity: 1.0))
    }
}

struct FooterView: View {
    @State var selectedTab = 0
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                ZonesView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Zones")
                    }.tag(1)
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(1)
            }
    }
}

func createCustomCard<Content: View>(content: Content) -> some View {
    content
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FetchableList_Preview: PreviewProvider {
    static var previews: some View {
        Text("Hello")
        //DisplayList<ZoneModel>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/zone", displayCardFunc: ZoneCardContent.init)
    }
}
