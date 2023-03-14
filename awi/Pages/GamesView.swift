//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct GameModel: Decodable, Hashable {
    let id: UUID
    let name: String
    let type: String
}

struct GameCardContent: View, Hashable {
    let title: String
    let subtitle: String
    
    init(game: GameModel) {
        self.title = game.name
        self.subtitle = game.type
    }
    
    var body: some View {
        createCustomCard(content:
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.subheadline)
            })
    }
}


struct GamesView: View {
    var body: some View {
        VStack {
            Text("Games");
            Spacer()
            FetchableList<GameModel, GameCardContent>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/game", displayCardFunc: GameCardContent.init)
        }
    }
}
