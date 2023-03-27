import Foundation

struct FestivalDayDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let festival_id: String
    let date: Date
    let open_at: Date
    let close_at: Date
}

protocol FestivalDayObserver {
    func changedDate(date: Date, id: Int)
    func changedOpening(start: Date, id: Int)
    func changedClosing(end: Date, id: Int)
}

enum FestivalDayPropertyChange {
    case DATE
    case OPENING
    case CLOSING
}

class FestivalDay: ObservableObject, Equatable {
    static func == (lhs: FestivalDay, rhs: FestivalDay) -> Bool {
        lhs.id == rhs.id && lhs.date == rhs.date && lhs.openAt == rhs.openAt && lhs.closeAt == rhs.closeAt
    }
    
    private var observers: [FestivalDayObserver] = []
    let id: Int
    var date: Date {
        didSet {
            if date < Date.now { date = oldValue }
            notifyObservers(change: .DATE)
        }
    }
    var openAt: Date {
        didSet {
            if openAt < Date.now { openAt =  oldValue }
            notifyObservers(change: .OPENING)
        }
    }
    var closeAt: Date {
        didSet {
            if closeAt < openAt { closeAt = oldValue }
            notifyObservers(change: .CLOSING)
        }
    }
    
    init(id: Int, date: Date, openAt: Date, closedAt: Date) {
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
