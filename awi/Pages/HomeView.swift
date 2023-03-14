//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            Text("Welcome to FestiGames");
            Spacer().frame(height: 40)
            Text("An app to help you find the games you want to play at FestiGames 2023")
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.allCases[1])

            Spacer()
        }
    }
}
