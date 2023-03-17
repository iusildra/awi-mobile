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
        GeometryReader { geometry in
            Text(title)
                .frame(width: geometry.size.width, height: 80)
                .foregroundColor(Color(red: 0.933, green: 0.933, blue: 0.933, opacity: 1.0))
                .background(Color(red: 0.651, green: 0.294, blue: 0.165, opacity: 1))
                .font(Font.custom("Inter-Bold", size: 24))
        }.frame(height:80)
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
        DisplayList<ZoneModel>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/zone", displayCardFunc: ZoneCardContent.init)
    }
}
