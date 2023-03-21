import Foundation

struct TimeslotDTO: Decodable, Hashable, Identifiable {
    let id: Int
    let start: Date
    let end: Date
    let festival_day_id: Int
}

protocol TimeslotObserver {
    func changedStart(start: Date, id: Int)
    func changedEnd(end: Date, id: Int)
}

enum TimeslotPropertyChange {
    case START
    case END
}

class Timeslot: ObservableObject {
    private var observers: [TimeslotObserver] = []
    let id: Int
    var start: Date {
        didSet {
            if start < Date.now { start = oldValue }
            notifyObservers(change: .START)
        }
    }
    var end: Date {
        didSet {
            if end < start { end = oldValue }
            notifyObservers(change: .END)
        }
    }
    let festivalDayId: Int
    
    init(id: Int, start: Date, end: Date, festivalDayId: Int) {
        self.id = id
        self.start = start
        self.end  = end
        self.festivalDayId = festivalDayId
    }
    
    func addObserver(o: TimeslotObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: TimeslotPropertyChange) {
        for observer in observers {
            switch change {
            case .END:
                observer.changedStart(start: self.start, id: self.id)
            case .START:
                observer.changedEnd(end: self.end, id: self.id)
            }
        }
    }
}
