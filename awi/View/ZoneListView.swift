import SwiftUI

struct ZoneListView: View {
    @State private var searchString = ""
    @ObservedObject var viewModel: ZoneListViewModel
    @StateObject var zoneViewModel: ZoneListViewModel = ZoneListViewModel()
    
    init(viewModel: ZoneListViewModel){
        self.viewModel = viewModel
    }
    
    private var zoneListState : ZoneListState {
        return self.viewModel.zoneListState
    }
    
    func deleteItems(at offsets: IndexSet) {
        zoneViewModel.datavm.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                switch zoneListState {
                case .loading, .loaded:
                    Text("Chargement des zones...")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(2)
                case .loadingError:
                    Text("Error while loading zones")
                case .ready:
                    List {
                        ForEach(searchString == "" ? zoneViewModel.datavm : zoneViewModel.datavm.filter { $0.zone.name.contains(searchString) }, id: \.zone.id) {
                            vm in
                            NavigationLink(destination: ZoneView(vm: vm)){
                                Text(vm.name)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }.navigationTitle("Fiches Complètes 🍱")
                        
                    }
                    .overlay {
                        if zoneViewModel.fetching {
                            Text("Chargement des fiches techniques")
                                .foregroundColor(.blue)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2)
                        }
                    }
                    .searchable(text: $searchString)
                    .onAppear{
                        zoneViewModel.fetchData()
                    }
                }
                VStack {
                    HStack{
                        /*NavigationLink(destination: CreateSheetView()){
                            Text("Create a zone")
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
                        ZoneDAO.fetchZone(list: zoneViewModel)
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


struct ZoneListView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneListView(viewModel: ZoneListViewModel())
    }
}
