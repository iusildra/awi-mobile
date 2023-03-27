import SwiftUI

struct ContentView: View {
    @State var isConnected: Bool = false
    @State var volunteer: Volunteer = Volunteer(id: "test-test", username: "bloup", firstName: "blip", lastName: "bloup", email: "bloup@gmail.com",isAdmin: true )
    @State var token : String = ""
    @State var selectedTab = 0


    var body: some View {
        VStack {
            if isConnected {
                TabView(selection: $selectedTab) {
                    HomeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }.tag(0)
                    FestivalListView(viewModel: FestivalListViewModel())
                        .tabItem {
                            Image(systemName: "map")
                            Text("Festivals")
                        }.tag(1)
                    ZoneListView(viewModel: ZoneListViewModel())
                            .tabItem {
                                Image(systemName: "map")
                                Text("Zones")
                            }.tag(2)
                    ProfileView(volunteer : $volunteer, token: $token)
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profile")
                            }.tag(3)
                }
            }else{
                Auth(isConnected : $isConnected, volunteer: $volunteer, token: $token)
            }
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
