import Foundation

enum ZoneListState : CustomStringConvertible{
    case ready
    case loading(String)
    case loaded([ZoneDTO])
    case loadingError(String)
    

    var description: String{
        switch self {
        case .ready                   : return "ready"
        case .loading                 : return "loading"
        case .loaded(let complete)    : return "loaded: \(complete.count) zones"
        case .loadingError(let error) : return "loadingError: Error loading -> \(error)"
        }
    }
}

class ZoneListViewIntent{
    var zoneListVM : ZoneListViewModel
    
    init(list: ZoneListViewModel){
        self.zoneListVM = list
    }

    func zonesLoaded(){
        self.zoneListVM.zoneListState = .ready
    }
    
    func httpJsonLoaded(result: [ZoneDTO]){
        self.zoneListVM.zoneListState = .loaded(result)
    }
    
    func httpJsonLoadError(error: Error){
        self.zoneListVM.zoneListState = .loadingError("\(error)")
    }

    func load(url : String){
        self.zoneListVM.zoneListState = .loading(url)
    }
    

}
