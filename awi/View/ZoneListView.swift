import SwiftUI

struct ZoneListView: View {
    @State private var searchString = ""
    @ObservedObject var viewModel: ZoneListViewModel
    @StateObject var zoneListViewModel: ZoneListViewModel = ZoneListViewModel()
    @Binding private var token: String
    
    init(viewModel: ZoneListViewModel, token: Binding<String>){
        self.viewModel = viewModel
        self._token = token
    }
    
    private var zoneListState : ZoneListState {
        return self.viewModel.zoneListState
    }
    
    func deleteItems(at offsets: IndexSet) {
        zoneListViewModel.datavm.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                switch zoneListState {
                case .loading, .loaded:
                    Text("Zones loading...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                case .loadingError:
                    Text("Error while loading zones")
                case .ready:
                    List {
                        ForEach(searchString == "" ? zoneListViewModel.datavm : zoneListViewModel.datavm.filter { $0.zone.name.contains(searchString) }, id: \.zone.id) {
                            vm in
                            NavigationLink(destination: ZoneView(vm: vm, token: self.$token)){
                                Text(vm.name)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }.navigationTitle("Zones")
                        
                    }
                    .overlay {
                        if zoneListViewModel.fetching {
                            Text("Zones loading...")
                                .foregroundColor(.blue)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2)
                        }
                    }
                    .searchable(text: $searchString)
                    .onAppear{
                        ZoneDAO.fetchZone(list: self.viewModel)
                    }
                }
            }
        }
    }
}


/*struct ZoneListView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneListView(viewModel: ZoneListViewModel())
    }
}*/
