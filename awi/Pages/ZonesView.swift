//
// Created by Richard Martin on 14/03/2023.
//

import SwiftUI

struct ZoneCardContent: View, Hashable {
    let zone: ZoneDTO
    
    init(zone: ZoneDTO) {
        self.zone = zone
    }
    
    var body: some View {
        createCustomCard(content:
            VStack(alignment: .leading, spacing: 10) {
                Text(zone.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                
            })
    }
}

struct ZonesView: View {
    var body: some View {
        VStack {
            //NavigableList<ZoneModel, ZoneCardContent>(apiRoute: "https://awi-mano-api.cluster-ig4.igpolytech.fr/zone", displayCardFunc: ZoneCardContent.init)
        }
    }
}
