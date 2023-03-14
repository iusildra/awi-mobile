//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct TableModel: Decodable, Hashable {
    let id: Int
    let number: Int
}

struct RoomModel: Decodable, Hashable {
    let id: Int
    let name: String
    let tables: [TableModel]
}

struct ZoneModel: Decodable, Hashable {
    let id: Int
    let name: String
    let rooms: [RoomModel]
}

struct ZoneCardContent: View, Hashable {
    let zone: ZoneModel
    
    init(zone: ZoneModel) {
        self.zone = zone
    }
    
    var body: some View {
        createCustomCard(content:
            VStack(alignment: .leading, spacing: 10) {
                Text(zone.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("\(zone.rooms.count) rooms")
                    .font(.subheadline)
            Text("\(zone.rooms.reduce(0, {acc, room in acc + room.tables.count})) tables")
            })
    }
}


struct ZonesView: View {
    var body: some View {
        VStack {
            Text("Zones");
            Spacer()
            
            FetchableList<ZoneModel, ZoneCardContent>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/zone", displayCardFunc: ZoneCardContent.init)
        }
    }
}
