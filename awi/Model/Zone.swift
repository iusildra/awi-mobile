import Foundation

struct ZoneDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let festival_id: String
    let nb_volunteers: Int
}

protocol ZoneObserver {
    func changedName(name: String, id: Int)
    func changedNbVolunteers(nbVolunteers: Int, id: Int)
}

enum ZonePropertyChange {
    case NAME
    case NB_VOLUNTEERS
}

class Zone: ObservableObject {
    private var observers: [ZoneObserver] = []
    let id: Int
    var name: String {
        didSet {
            if(name.count < 1) { name = oldValue }
            else { notifyObservers(change: .NAME) }
        }
    }
    let festivalId: String
    var nbVolunteers: Int {
        didSet {
            if nbVolunteers == 0 { nbVolunteers = oldValue }
            else { notifyObservers(change: .NB_VOLUNTEERS) }
        }
    }
    
    init(id: Int, name: String, festivalid: String, nbVolunteers: Int) {
        self.id = id
        self.name = name
        self.festivalId = festivalid
        self.nbVolunteers = nbVolunteers
    }
    
    func addObserver(o: ZoneObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: ZonePropertyChange) {
        for observer in observers {
            switch change {
            case .NAME:
                observer.changedName(name: self.name, id: self.id)
            case .NB_VOLUNTEERS:
                observer.changedNbVolunteers(nbVolunteers: self.nbVolunteers, id: self.id)
            }
        }
    }
    
    
}


