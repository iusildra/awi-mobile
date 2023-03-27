//
//  FestivalIntent.swift
//  awi
//
//  Created by Lucas NOUGUIER on 26/03/2023.
//

import Foundation
import Combine

enum FestivalIntentState: Equatable, CustomStringConvertible {
    case READY
    case CHANGING_NAME(String)
    case CHANGING_YEAR(Int)
    case CHANGING_ACTIVE(Bool)
    case CHANGING_DURATION(Int)
    case CHANGING_DAYS([FestivalDay])
    case CHANGING_ZONES([Zone])
    case LIST_UPDATED
    
    var description: String {
        switch self {
        case .READY: return "READY"
        case .CHANGING_NAME(let name): return "Changing name to \(name)"
        case . CHANGING_YEAR(let year): return "Changing year to \(year)"
        case .CHANGING_ACTIVE(let active): return "Changing is active to \(active)"
        case .CHANGING_DURATION(let duration): return "Changing duration to \(duration) days"
        case .CHANGING_DAYS(let days): return "Changing days to \(days)"
        case .CHANGING_ZONES(let zones): return "Changing zones to \(zones)"
        case .LIST_UPDATED: return "List updated"
        }
    }
}

enum CreateFestivalIntentState: CustomStringConvertible {
    case READY
    case CREATING
    case CREATED
    case ERROR(String)
    
    var description: String {
        switch self {
        case .READY: return "Ready"
        case .CREATING: return "Creating festival"
        case .CREATED: return "Festival created"
        case .ERROR(let error): return "FestivalCreatingError: Error loading -> \(error)"
        }
    }
}

enum DeleteFestivalIntentState: CustomStringConvertible {
    case READY
    case DELETING
    case DELETED
    case ERROR(String)
    
    var description: String {
        switch self {
        case .READY: return "Ready"
        case .DELETING: return "Deleting festival"
        case .DELETED: return "Festival deleted"
        case .ERROR(let error): return "FestivalDeletingError: Error loading \(error)"
        }
    }
}

class FestivalIntent {
    private var state = PassthroughSubject<FestivalIntentState, Never>()
    
    var festivalVM: FestivalViewModel
    
    init(vm: FestivalViewModel) {
        self.festivalVM = vm
    }
    
    func intentToChange(name: String) {
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(year: Int) {
        self.state.send(.CHANGING_YEAR(year))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(active: Bool) {
        self.state.send(.CHANGING_ACTIVE(active))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(duration: Int) {
        self.state.send(.CHANGING_DURATION(duration))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(days: [FestivalDay]) {
        self.state.send(.CHANGING_DAYS(days))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(zones: [Zone]) {
        self.state.send(.CHANGING_ZONES(zones))
        self.state.send(.LIST_UPDATED)
    }
    
    func deleted() {
        self.festivalVM.deletionState = .READY
    }
    func deleting(id: Int) {
        self.festivalVM.deletionState = .DELETING
    }
    func deletingError(error: Error) {
        self.festivalVM.deletionState = .ERROR("\(error)")
    }
    func zoneDeleted(id: Int) {
        DispatchQueue.main.async {
            self.festivalVM.deletionState = .DELETED
        }
    }
    
    func created() {
        self.festivalVM.creationState = .READY
    }
    
    func creating() {
        self.festivalVM.creationState = .CREATING
    }
    func creatingError(error: Error) {
        self.festivalVM.creationState = .ERROR("\(error)")
    }
    func zoneCreated() {
        DispatchQueue.main.async {
            self.festivalVM.creationState = .CREATED
        }
    }
    
    func addObserver(vm: FestivalViewModel) {
        self.state.subscribe(vm)
    }
}
