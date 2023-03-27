import SwiftUI

class FestivalListViewModel: ObservableObject, FestivalViewModelDelegate {
    func completeListViewModelChanged() {}
    
  
    var data: [Festival]
    var datavm: [FestivalViewModel]
    @Published var fetching : Bool = false
    @Published var festivalListState : FestivalListState = .ready{
        didSet{
            print("state: \(self.festivalListState)")
            switch self.festivalListState { // state has changed
            case .loaded(let data):
                print(data)
                if data.count == 0 {
                    self.festivalListState = .loadingError("No festivals fetched")
                }
            default:
                return
            }
        }
    }
    
    init(){
        self.datavm = []
        self.data = []
        FestivalListViewIntent(list : self ).load(url: API_FESTIVAL)
        FestivalDAO.fetchFestival(list: self )
    }
    
    func festivalViewModelChanged() { objectWillChange.send() }
}
