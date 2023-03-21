//
// Created by Richard Martin on 21/03/2023.
//

import Foundation

struct SignInDTO {
    let email: String
    let password: String
}

struct SignUpDTO {
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

protocol SignInObserver {
    func changedEmail(email: String)
    func changedPassword(password: String)
}

protocol SignUpObserver {
    func changedEmail(email: String)
    func changedPassword(password: String)
    func changedUsername(username: String)
    func changedFirstName(firstName: String)
    func changedLastName(lastName: String)
}

enum SignInPropertyChange {
    case EMAIL
    case PASSWORD
}

enum SignUpPropertyChange {
    case EMAIL
    case PASSWORD
    case USERNAME
    case FIRSTNAME
    case LASTNAME
}


class SignIn : ObservableObject {
    private var observers: [SignInObserver] = []

    var email: String = "" {
        didSet {
            if (email.count < 1) {
                email = oldValue
            }else{
                notifyObservers(change: .EMAIL)
            }
        }
    }

    var password: String = "" {
        didSet {
            if (password.count < 1) {
                password = oldValue
            }else{
                notifyObservers(change: .PASSWORD)
            }
        }
    }

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    func addObserver(o: SignInObserver) {
        self.observers.append(o)
    }

    func notifyObservers(change: SignInPropertyChange) {
        for observer in observers {
            switch change {
            case .EMAIL:
                observer.changedEmail(email: self.email)
            case .PASSWORD:
                observer.changedPassword(password: self.password)
            }
        }
    }

}

class SignUp : ObservableObject {
    private var observers: [SignUpObserver] = []

    var email: String = "" {
        didSet {
            if (email.count < 1) {
                email = oldValue
            }else{
                notifyObservers(change: .EMAIL)
            }
        }
    }

    var password: String = "" {
        didSet {
            if (password.count < 1) {
                password = oldValue
            }else{
                notifyObservers(change: .PASSWORD)
            }
        }
    }

    var username: String = "" {
        didSet {
            if (username.count < 1) {
                username = oldValue
            }else{
                notifyObservers(change: .USERNAME)
            }
        }
    }

    var firstName: String = "" {
        didSet {
            if (firstName.count < 1) {
                firstName = oldValue
            }else{
                notifyObservers(change: .FIRSTNAME)
            }
        }
    }

    var lastName: String = "" {
        didSet {
            if (lastName.count < 1) {
                lastName = oldValue
            }else{
                notifyObservers(change: .LASTNAME)
            }
        }
    }

    init(email: String, password: String, username: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }

    func addObserver(o: SignUpObserver) {
        self.observers.append(o)
    }

    func notifyObservers(change: SignUpPropertyChange) {
        for observer in observers {
            switch change {
            case .EMAIL:
                observer.changedEmail(email: self.email)
            case .PASSWORD:
                observer.changedPassword(password: self.password)
            case .USERNAME:
                observer.changedUsername(username: self.username)
            case .FIRSTNAME:
                observer.changedFirstName(firstName: self.firstName)
            case .LASTNAME:
                observer.changedLastName(lastName: self.lastName)
            }
        }
    }
}