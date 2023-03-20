import Foundation

struct ZoneDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
}

protocol ZoneObserver {
    func changedName(name: String, id: Int)
}

enum ZonePropertyChange {
    case NAME
}

class Zone: ObservableObject {
    private var observers: [ZoneObserver] = []
    let id: Int
    var name: String {
        didSet {
            if(name.count < 1) { name = oldValue }
            notifyObservers(change: .NAME)
        }
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func addObserver(o: ZoneObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: ZonePropertyChange) {
        for observer in observers {
            switch change {
            case .NAME:
                observer.changedName(name: self.name, id: self.id)
            }
        }
    }
    
    
}


