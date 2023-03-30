import SwiftUI

struct FestivalListView: View {
    @State private var searchString = ""
    @ObservedObject var viewModel: FestivalListViewModel
    @StateObject var festivalListViewModel: FestivalListViewModel = FestivalListViewModel()
    @Binding private var token: String
    
    init(viewModel: FestivalListViewModel, token: Binding<String>){
        self.viewModel = viewModel
        self._token = token
    }
    
    private var festivalListState : FestivalListState {
        return self.viewModel.festivalListState
    }
    
    func deleteItems(at offsets: IndexSet) {
        festivalListViewModel.datavm.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                switch festivalListState {
                case .loading, .loaded:
                    Text("Festivals loading...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                case .loadingError:
                    Text("Error while loading festivals")
                case .ready:
                    List {
                        ForEach(searchString == "" ? festivalListViewModel.datavm : festivalListViewModel.datavm.filter { $0.festival.name.contains(searchString) }, id: \.festival.id) {
                            vm in
                            NavigationLink(destination: FestivalView(vm: vm, listVM: self.festivalListViewModel, token: self.$token)){
                                Text(vm.name)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                            }
                        }.navigationTitle("Festivals")

                    }
                    .overlay {
                        if festivalListViewModel.fetching {
                            Text("Festivals loading...")
                                    .foregroundColor(.blue)

                            ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(2)
                        }
                    }
                    .searchable(text: $searchString)
                    .onAppear{
                        FestivalDAO.fetchFestival(list: festivalListViewModel)
                    }
                            .refreshable(
                                action: {
                                    FestivalDAO.fetchFestival(list: festivalListViewModel)
                                }
                            )
                }

                    HStack {
                        NavigationLink("Add a festival", destination : CreateFestivalView(token: $token))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                        }.padding()
            }
        }
    }
}
