import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HeaderView()

            FooterView()
        }
    }
}

struct HeaderView: View {
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

//        GeometryReader { geometry in
//            Text("FestiGames")
//                .frame(width: geometry.size.width, height: 80)
//                .foregroundColor(Color(red: 0.933, green: 0.933, blue: 0.933, opacity: 1.0))
//                .background(Color(red: 0.651, green: 0.294, blue: 0.165, opacity: 1))
//                .font(Font.custom("Inter-Bold", size: 24))
//        }.frame(height:80)
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
                GamesView()
                    .tabItem {
                        Image(systemName: "gamecontroller")
                        Text("Games")
                    }.tag(1)
                ZonesView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Zones")
                    }.tag(2)
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(3)
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
        FetchableList<GameModel, GameCardContent>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/game", displayCardFunc: GameCardContent.init)
    }
}
