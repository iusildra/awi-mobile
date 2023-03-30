import Foundation

struct FestivalDayDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let festival_id: String
    let date: String
    let open_at: String
    let close_at: String
}

protocol FestivalDayObserver {
    func changedDate(date: String, id: Int)
    func changedOpening(start: String, id: Int)
    func changedClosing(end: String, id: Int)
}

enum FestivalDayPropertyChange {
    case DATE
    case OPENING
    case CLOSING
}

class FestivalDay: ObservableObject, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(openAt)
        hasher.combine(closeAt)
    }
    
    static func == (lhs: FestivalDay, rhs: FestivalDay) -> Bool {
        lhs.id == rhs.id && lhs.date == rhs.date && lhs.openAt == rhs.openAt && lhs.closeAt == rhs.closeAt
    }
    
    private var observers: [FestivalDayObserver] = []
    let id: Int
    var date: String {
        didSet {
            notifyObservers(change: .DATE)
        }
    }
    var openAt: String {
        didSet {
            notifyObservers(change: .OPENING)
        }
    }
    var closeAt: String {
        didSet {
            notifyObservers(change: .CLOSING)
        }
    }
    
    init(id: Int, date: String, openAt: String, closedAt: String) {
        self.id = id
        self.date = date
        self.openAt = openAt
        self.closeAt = closedAt
    }
    
    func addObserver(o: FestivalDayObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: FestivalDayPropertyChange) {
        for observer in self.observers {
            switch change {
            case .DATE:
                observer.changedDate(date: self.date, id: self.id)
            case .OPENING:
                observer.changedOpening(start: self.openAt, id: self.id)
            case .CLOSING:
                observer.changedClosing(end: self.closeAt, id: self.id)
            }
        }
    }
}
