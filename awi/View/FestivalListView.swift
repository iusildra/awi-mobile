import SwiftUI

struct FestivalListView: View {
    @State private var searchString = ""
    @ObservedObject var viewModel: FestivalListViewModel
    @StateObject var festivalListViewModel: FestivalListViewModel = FestivalListViewModel()
    
    init(viewModel: FestivalListViewModel){
        self.viewModel = viewModel
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
                            NavigationLink(destination: FestivalView(vm: vm)){
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
                }
                VStack {
                    HStack{
                        /*NavigationLink(destination: EditFestivalView(festivalListVM: self.festivalListViewModel)){
                            Text("Edit a festival")
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.cyan, lineWidth: 5)
                                )
                            EmptyView()
                        }*/
                    }
                    
                    Button(action: {
                        FestivalDAO.fetchFestival(list: festivalListViewModel)
                    }){
                        Text("Refresh")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 5)
                            )
                    }.padding()
                }
            }
        }
    }
}


struct FestivalListView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalListView(viewModel: FestivalListViewModel())
    }
}
