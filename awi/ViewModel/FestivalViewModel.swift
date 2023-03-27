//
//  FestivalViewModel.swift
//  awi
//
//  Created by Lucas NOUGUIER on 26/03/2023.
//

import Foundation
import Combine

enum FestivalError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case YEAR(Int)
    case DURATION(Int)
    case DAYS([FestivalDay])
    case ZONES([Zone])
    
    var description: String {
        switch self {
        case .NONE: return "No errors"
        case .NAME(let name): return "Given name is not valid: \(name)"
        case .YEAR(let year): return "Given year is not valid: \(year)"
        case .DURATION(let duration): return "Given duration is not valid: \(duration)"
        case .DAYS(let days): return "Given days aren't valid: \(days)"
        case .ZONES(let zones): return "Given zones aren't valid: \(zones)"
        }
    }
}

class FestivalViewModel: ObservableObject, Subscriber, FestivalObserver {
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func changedActive(active: Bool, id: String) {
        
    }
    
    func changedDuration(duration: Int, id: String) {
        
    }
    
    func changedName(name: String, id: String) {
        
    }
    
    func changedYear(year: Int, id: String) {
        
    }
    
    func changedZones(zones: [Zone], id: String) {
        
    }
    
    func changedDays(days: [FestivalDay], id: String) {
        
    }
    
    typealias Input = FestivalIntentState
    typealias Failure = Never
    
    private(set) var festival: Festival
    @Published var name: String
    @Published var year: Int
    @Published var active: Bool
    @Published var duration: Int
    @Published var days: [FestivalDay]
    @Published var zones: [Zone]
    
    @Published var creationState: CreateFestivalIntentState = .READY {
        didSet {
            print("creation state: \(self.creationState.description)")
        }
    }
    @Published var deletionState: DeleteFestivalIntentState = .READY {
        didSet {
            print("deletion state: \(self.deletionState.description)")
        }
    }
    @Published var error: FestivalError = .NONE
    var delegate: FestivalViewModelDelegate?
    
    init(festival: Festival) {
        self.festival = festival
        self.name = festival.name
        self.year = festival.year
        self.active = festival.active
        self.duration = festival.duration
        self.days = festival.days
        self.zones = festival.zones
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: FestivalIntentState) -> Subscribers.Demand {
        switch input {
        case .READY: break
        case .CHANGING_NAME(let name):
            self.festival.name = name
            if self.festival.name != name { self.error = .NAME(name) }
        case .CHANGING_YEAR(let year):
            self.festival.year = year
            if self.festival.year != year { self.error = .YEAR(year)}
        case .CHANGING_ACTIVE(let active):
            self.festival.active = active
        case .CHANGING_DURATION(let duration):
            self.festival.duration = duration
            if self.festival.duration != duration { self.error = .DURATION(duration)}
        case .CHANGING_DAYS(let days):
            self.festival.days = days
            if self.festival.days != days { self.error = .DAYS(days)}
        case .CHANGING_ZONES(let zones):
            self.festival.zones = zones
            if self.festival.zones != zones { self.error = .ZONES(zones)}
        case .LIST_UPDATED: break
        }
        return .none
    }
}
