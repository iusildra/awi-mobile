import Foundation

enum FestivalListState : CustomStringConvertible{
    case ready
    case loading(String)
    case loaded([FestivalDTO])
    case loadingError(String)
    

    var description: String{
        switch self {
        case .ready                   : return "ready"
        case .loading                 : return "loading"
        case .loaded(let complete)    : return "loaded: \(complete.count) festivals"
        case .loadingError(let error) : return "loadingError: Error loading -> \(error)"
        }
    }
}

class FestivalListViewIntent{
    var festivalListVM : FestivalListViewModel
    
    init(list: FestivalListViewModel){
        self.festivalListVM = list
    }

    func festivalsLoaded(){
        self.festivalListVM.festivalListState = .ready
    }
    
    func httpJsonLoaded(result: [FestivalDTO]){
        self.festivalListVM.festivalListState = .loaded(result)
    }
    
    func httpJsonLoadError(error: Error){
        self.festivalListVM.festivalListState = .loadingError("\(error)")
    }

    func load(url : String){
        self.festivalListVM.festivalListState = .loading(url)
    }
    

}
