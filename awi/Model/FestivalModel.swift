import Foundation

struct FestivalDTO: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let year: Int
    let active: Bool
    let duration: Int
}

protocol FestivalObserver {
    func changedActive(active: Bool, id: String)
    func changedDuration(duration: Int, id: String)
    func changedName(name: String, id: String)
    func changedYear(year: Int, id: String)
}

enum FestivalPropertyChange {
    case NAME
    case YEAR
    case ACTIVE
    case DURATION
}

class Festival: ObservableObject {
    private(set) var observers: [FestivalObserver] = []
    let id: String
    var active: Bool {
        didSet {
            notifyObservers(change: .ACTIVE)
        }
    }
    var duration: Int {
        didSet {
            if duration <= 0 { duration = oldValue }
            notifyObservers(change: .DURATION)
        }
    }
    var name: String {
        didSet {
            if (name.count < 1) { name = oldValue }
            notifyObservers(change: .NAME)
        }
    }
    var year: Int {
        didSet {
            if year < Calendar.current.component(.year, from: Date.now) {
                year = oldValue
            }
            notifyObservers(change: .YEAR)
        }
    }
    
    private init(id: String, name: String, year: Int, active: Bool, duration: Int) {
        self.id = id
        self.name = name
        self.year = year
        self.active = active
        self.duration = duration
    }
    
    func addObserver(o: FestivalObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: FestivalPropertyChange) {
        for observer in observers {
            switch change {
            case .ACTIVE:
                observer.changedActive(active: self.active, id: self.id)
            case .DURATION:
                observer.changedDuration(duration: self.duration, id: self.id)
            case .NAME:
                observer.changedName(name: self.name, id: self.id)
            case .YEAR:
                observer.changedYear(year: self.year, id: self.id)
            }
        }
    }
}
