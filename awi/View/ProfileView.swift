//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct ProfileView: View {

    @Binding var volunteer: Volunteer
    @Binding var token: String

    @State var Edit : Bool = true

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        Edit.toggle()
                    }, label: {
                        Text(Edit ? "Edit" : "Save")

                    })

                }

                VStack {
                    Text("Username")
                            .font(.caption)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Username", text: $volunteer.username)
                            .disabled(Edit)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                }

                VStack {
                    Text("Firstname")
                            .font(.caption)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Firstname", text: $volunteer.firstName)
                            .disabled(Edit)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                }

                VStack {
                    Text("Lastname")
                            .font(.caption)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Lastname", text: $volunteer.lastName)
                            .disabled(Edit)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                }

                VStack {
                    Text("Email")
                            .font(.caption)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Email", text: $volunteer.email)
                            .disabled(Edit)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                }

                Spacer()
            }
                    .navigationTitle("Profile")
                    .padding(20)

        }
    }
}