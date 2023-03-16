//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct TableModel: Decodable, Hashable, Identifiable {
    let id: Int
    let number: Int
}

struct RoomModel: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let tables: [TableModel]
}

struct ZoneModel: Decodable, Hashable, Identifiable {
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

struct MultiLayerTable: View {
    let zones: [ZoneModel]
    
    init(zones: [ZoneModel]) {
        self.zones = zones
    }
    
    var body: some View {
        List {
            ForEach(zones) { zone in
                Section(header: Text(zone.name)) {
                    ForEach(zone.rooms) { room in
                        Section(header: Text(room.name)) {
                            ForEach(room.tables) { table in
                                TableCell(table: table)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TableCell: View {
    let table: TableModel
    
    var body: some View {
        HStack {
            Text("Table \(table.number)")
            Spacer()
            Image(systemName: "person.2.fill")
        }
    }
}


struct ZonesView: View {
    var body: some View {
        VStack {
            DisplayList<ZoneModel, ZoneCardContent>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/zone", displayCardFunc: NavigableCard(itemView: ZoneCardContent, detailledView: MultiLayerTable, label: <#T##String#>, navTitle: <#T##String#>))
        }
    }
}
