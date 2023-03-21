//
// Created by Richard Martin on 16/03/2023.
//

import SwiftUI

struct Auth: View {

    @Binding var isConnected: Bool
    @Binding var volunteer: Volunteer
    @Binding var token: String

    @State var SignUp: Bool = false
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    var SignInIsDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    var SignUpIsDisabled: Bool {
        username.isEmpty || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty
    }
    @State var isSignedIn: Bool = false
    var result : String = ""

    var body: some View {
        VStack {
            Spacer()
            Image("FestiGames")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            Spacer().frame(height: 20)
            if SignUp {
                TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)
                        .padding(.bottom, 20)
                TextField("Firstname", text: $firstName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)
                        .padding(.bottom, 20)
                TextField("Lastname", text: $lastName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)
                        .padding(.bottom, 20)
            }
            TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
            SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10.0)
                    .padding(.bottom, 20)
            if SignUp {
                SecureField("Password confirmation", text: $passwordConfirmation)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10.0)
                        .padding(.bottom, 20)
                Button(action: {
                    self.isSignedIn = true
                }) {
                    Text("Sign up")
                }
                        .disabled(SignUpIsDisabled)
                        .padding(15)
                        .background(SignUpIsDisabled ? .gray : .green)
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
            }else {
                Button(action: {
                    login()
                }) {
                    Text("Sign in")
                }
                        .disabled(SignInIsDisabled)
                        .padding(15)
                        .background(SignInIsDisabled ? .gray : .green)
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                self.SignUp.toggle()
            }) {
                Text(SignUp ? "Already have an account ? Sign in" : "Don't have an account ? Sign up")
            }
                    .padding(15)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
        }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))


    }

    struct SignUpPayload: Codable {
        let username: String
        let email: String
        let password: String
        let firstName: String
        let lastName: String
    }

    struct SignInPayload: Codable {
        let email: String
        let password: String
    }

    struct SignInResponse: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let email: String
        let sub: String
        let isAdmin: Bool
        let access_token: String
    }

    func login() -> Void {

        let url = URL(string: "https://awi-mano-api.cluster-ig4.igpolytech.fr/auth/signin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = try! JSONEncoder().encode(SignInPayload(email: email.lowercased(), password: password))
        print(String(data: parameters, encoding: .utf8)!)

        request.httpBody = parameters
        print("Data fetching started!")
        URLSession.shared.dataTask(with: request) { data, response, error in


                    if let data = data {
                        do {
//                            print(String(data: data, encoding: .utf8)!)
                            let decodedResponse = try JSONDecoder().decode(SignInResponse.self, from: data)
                            print(decodedResponse)
//                            TODO : fix isAdmin
                            volunteer = Volunteer(id: decodedResponse.sub, username: decodedResponse.username,firstName: decodedResponse.firstName,lastName: decodedResponse.lastName,email: decodedResponse.email, isAdmin: true)
                            token = decodedResponse.access_token
                            print("Data fetching completed!")
                        } catch {
                            print("Fetch failed 1: \(error.localizedDescription)")
                        }
                    } else if let error = error {
                        print("Fetch failed 2: \(error.localizedDescription)")
                    }
                }.resume()
        self.isConnected = true

    }
}
