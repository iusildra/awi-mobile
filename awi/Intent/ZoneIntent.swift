//
//  Zone.swift
//  awi
//
//  Created by Lucas NOUGUIER on 20/03/2023.
//

import Foundation
import Combine

enum ZoneIntentState: Equatable, CustomStringConvertible {
    case READY
    case CHANGING_NAME(String)
    case CHANGING_NB_VOLUNTEERS(Int)
    case LIST_UPDATED
    
    var description: String {
        switch self {
        case .READY:
            return "Ready"
        case .CHANGING_NAME(let name):
            return "Changing name to \(name)"
        case .CHANGING_NB_VOLUNTEERS(let nb):
            return "Changing number of required volunteers to \(nb)"
        case .LIST_UPDATED:
            return "List updated"
        }
    }
}

enum CreateZoneIntentState: CustomStringConvertible {
    case READY
    case CREATING
    case CREATED
    case ERROR(String)
    
    var description: String {
        switch self {
        case .READY: return "Ready"
        case .CREATING: return "Creating zone"
        case .CREATED: return "Created"
        case .ERROR(let error): return "ZoneCreatingError: Error loading -> \(error)"
        }
    }
}

enum DeleteZoneIntentState: CustomStringConvertible {
    case READY
    case DELETING(String)
    case DELETED(String)
    case ERROR(String)
    
    var description: String {
        switch self {
        case .READY: return "Ready"
        case .DELETING(let id): return "Deleting zone \(id)"
        case .DELETED(let id): return "Deleted zone \(id)"
        case .ERROR(let error): return "ZoneDeletinggError: Error loading -> \(error)"
        }
    }
}

class ZoneIntent {
    private var state = PassthroughSubject<ZoneIntentState, Never>()
    
    var zoneVM: ZoneViewModel
    
    init(vm: ZoneViewModel) {
        self.zoneVM = vm
    }
    
    func intentToChange(name: String) {
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(nbVolunteers: Int) {
        self.state.send(.CHANGING_NB_VOLUNTEERS(nbVolunteers))
        self.state.send(.LIST_UPDATED)
    }
    
    func deleted() {
        self.zoneVM.deletionState = .READY
    }
    func deleting(id: Int) {
        self.zoneVM.deletionState = .DELETING("\(id)")
    }
    func deletingError(error: Error) {
        self.zoneVM.deletionState = .ERROR("\(error)")
    }
    func zoneDeleted(id: Int) {
        DispatchQueue.main.async {
            self.zoneVM.deletionState = .DELETED("\(id)")
        }
    }
    
    func created() {
        self.zoneVM.creationState = .READY
    }
    
    func creating() {
        self.zoneVM.creationState = .CREATING
    }
    func creatingError(error: Error) {
        self.zoneVM.creationState = .ERROR("\(error)")
    }
    func zoneCreated() {
        DispatchQueue.main.async {
            self.zoneVM.creationState = .CREATED
        }
    }
    
    func addObserver(vm: ZoneViewModel) {
        self.state.subscribe(vm)
    }
    
}
