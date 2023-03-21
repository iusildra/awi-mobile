import Foundation

struct VolunteerDTO {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let isAdmin: Bool
}

protocol VolunteerObserver {
    func changedUsername(username: String, id: String)
    func changedFirstName(firstName: String, id: String)
    func changedLastName(lastName: String, id: String)
    func changedEmail(email: String, id: String)
    func changedPermission(isAdmin: Bool, id: String)
}

enum VolunteerPropertyChanged {
    case USERNAME
    case FIRST_NAME
    case LAST_NAME
    case EMAIL
    case PERMISSION
}

class Volunteer: ObservableObject {
    private var observers: [VolunteerObserver] = []
    let id: String
    var username: String {
        didSet {
            if username.count < 1 { username = oldValue }
            else { notifyObservers(change: .USERNAME)}
        }
    }
    var firstName: String {
        didSet {
            if firstName.count < 1 { username = oldValue }
            else { notifyObservers(change: .FIRST_NAME)}
        }
    }
    var lastName: String {
        didSet {
            if lastName.count < 1  { username = oldValue }
            else { notifyObservers(change: .LAST_NAME)}
        }
    }
    var email: String {
        didSet {
            let range = NSRange(location: 0, length: email.utf16.count)
            let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
            if (email.count < 1 || (regex.firstMatch(in: email, range:range) != nil))  { email = oldValue }
            else { notifyObservers(change: .EMAIL)}
        }
    }
    var isAdmin: Bool {
        didSet {
            notifyObservers(change: .PERMISSION)
        }
    }
    
    init(id: String, username: String, firstName: String, lastName: String, email: String, isAdmin: Bool) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isAdmin = isAdmin
    }
    
    func addObserver(o: VolunteerObserver) {
        self.observers.append(o)
    }
    
    func notifyObservers(change: VolunteerPropertyChanged) {
        for observer in observers {
            switch change {
            case .USERNAME:
                observer.changedUsername(username: self.username, id: self.id)
            case .FIRST_NAME:
                observer.changedFirstName(firstName: self.firstName, id: self.id)
            case .LAST_NAME:
                observer.changedLastName(lastName: self.lastName, id: self.id)
            case .EMAIL:
                observer.changedEmail(email: self.email, id: self.id)
            case .PERMISSION:
                observer.changedPermission(isAdmin: self.isAdmin, id: self.id)
            }
        }
    }
}
