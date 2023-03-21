import SwiftUI

class ZoneListViewModel: ObservableObject, ZoneViewModelDelegate {
    func completeListViewModelChanged() {}
    
  
    var data: [Zone]
    var datavm: [ZoneViewModel]
    @Published var fetching : Bool = false
    @Published var zoneListState : ZoneListState = .ready{
        didSet{
            print("state: \(self.zoneListState)")
            switch self.zoneListState { // state has changed
            case .loaded(let data):
                print(data)
                if data.count == 0 {
                    self.zoneListState = .loadingError("No zones fetched")
                }
            default:
                return
            }
        }
    }
    
    init(){
        self.datavm = []
        self.data = []
        ZoneListViewIntent(list : self ).load(url: API_ZONE)
        self.fetching = true
        let surl = API_ZONE
            guard let url = URL(string: surl) else { print(CREATE_URL_ERROR); return }

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data,response,error in
                guard let data = data else{return}
                do{
                    let dataDTO : [ZoneDTO] = try JSONDecoder().decode([ZoneDTO].self, from: data)
                    for zone in dataDTO{
                        let zone = Zone(id: zone.id, name: zone.name, festivalId: zone.festival_id, nbVolunteers: zone.nb_volunteers)
                        self.data.append(zone)
                        let vm = ZoneViewModel(zone: zone)
                        vm.delegate = self
                        self.datavm.append(vm)
                    }
                    DispatchQueue.main.async {
                        ZoneListViewIntent(list : self ).zonesLoaded()
                        self.fetching = false
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        self.fetching = false
                        self.zoneListState = .loadingError("\(error)")
                        print("error")
                    }
                    print("Error: \(error)")
                }

            }.resume()
       
    }
    
    func zoneViewModelChanged() { objectWillChange.send() }
    
    func fetchData(){
        self.datavm = []
        self.data = []
        fetching = true
        
        let surl = API_ZONE
            guard let url = URL(string: surl) else { print(CREATE_URL_ERROR); return }

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data,response,error in
                guard let data = data else{return}
                do{
                    let dataDTO : [ZoneDTO] = try JSONDecoder().decode([ZoneDTO].self, from: data)
                    
                    for zone in dataDTO{
                        let zone = Zone(id: zone.id, name: zone.name, festivalId: zone.festival_id, nbVolunteers: zone.nb_volunteers)
                        self.data.append(zone)
                        let vm = ZoneViewModel(zone: zone)
                        vm.delegate = self
                        self.datavm.append(vm)
                    }
                    DispatchQueue.main.async {
                        ZoneListViewIntent(list : self ).zonesLoaded()
                        self.fetching = false
                    }
                    
                }catch{
                    DispatchQueue.main.async {
                        self.fetching = false
                        self.zoneListState = .loadingError("\(error)")
                        print("error")
                    }
                    print("Error: \(error)")
                }

            }.resume()
       
    }
}
