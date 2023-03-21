//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct ProfileView: View {

    @Binding var volunteer: Volunteer
    @Binding var token: String

    var body: some View {
        VStack {
            Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            Text("Username: \(volunteer.username)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            Text("Firstname: \(volunteer.firstName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            Text("Lastname: \(volunteer.lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            Text("Email: \(volunteer.email)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            Text("Token: \(token)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

            Spacer()
        }
    }
}