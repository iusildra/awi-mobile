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
    
    init(data: [Zone]) {
        self.datavm = data.map{ZoneViewModel(zone:$0)}
        self.data = data
        ZoneListViewIntent(list: self).zonesLoaded()
    }
    
    init(){
        self.datavm = []
        self.data = []
        ZoneListViewIntent(list : self ).load(url: API_ZONE)
        ZoneDAO.fetchZone(list: self)
       
    }
    
    func zoneViewModelChanged() { objectWillChange.send() }
}
