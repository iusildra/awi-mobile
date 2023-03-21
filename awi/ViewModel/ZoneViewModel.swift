//
//  Zone.swift
//  awi
//
//  Created by Lucas NOUGUIER on 20/03/2023.
//

import Foundation
import Combine

enum ZoneError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case NB_VOLUNTEERS(Int)
    
    var description: String {
        switch self {
        case .NONE:
            return "No Errors"
        case .NAME(let name):
            return "Given name is not valid: \(name)"
        case .NB_VOLUNTEERS(let nb):
            return "Given number is not valid: \(nb)"
        }
    }
}

class ZoneViewModel: ObservableObject, Subscriber, ZoneObserver {
    typealias Input = ZoneIntentState
    typealias Failure = Never
    
    private(set) var zone: Zone
    @Published var name: String
    @Published var nbRequiredVolunteers: Int
    @Published var festivalId: String
    
    @Published var creationState: CreateZoneIntentState = .READY {
        didSet {
            print("state: \(self.creationState.description)")
        }
    }
    @Published var deletionState: DeleteZoneIntentState = .READY {
        didSet {
            print("state: \(self.deletionState.description)")
        }
    }
    @Published var error: ZoneError = .NONE
    var delegate: ZoneViewModelDelegate?
    
    init(zone: Zone) {
        self.zone = zone
        self.name = zone.name
        self.nbRequiredVolunteers = zone.nbVolunteers
        self.festivalId = zone.festivalId
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: ZoneIntentState) -> Subscribers.Demand {
        switch input {
        case .READY:
            break
        case .CHANGING_NAME(let name):
            self.zone.name = name
            if self.zone.name != name {
                self.error = .NAME(name)
            }
        case .CHANGING_NB_VOLUNTEERS(let nb):
            self.zone.nbVolunteers = nb
            if self.zone.nbVolunteers != nb {
                self.error = .NB_VOLUNTEERS(nb)
            }
        case .LIST_UPDATED:
            self.delegate?.zoneViewModelChanged()
        }
        return .none
    }
    
    func changedNbVolunteers(nbVolunteers: Int, id: Int) {
        
    }
    
    func changedName(name: String, id: Int) {
        
    }
}
