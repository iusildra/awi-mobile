//
//  Navigation.swift
//  awi
//
//  Created by Lucas NOUGUIER on 16/03/2023.
//

import Foundation
import SwiftUI

struct NavigableCard<Content: View>: View {
    let itemView: Content
    let detailledView: Content
    let label: String
    let navTitle: String
    
    init(itemView: Content, detailledView: Content, label: String, navTitle: String) {
        self.itemView = itemView
        self.detailledView = detailledView
        self.label = label
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationView {
            VStack {
                itemView
                
                NavigationLink(
                    destination: detailledView,
                    label: {
                        Text(label)
                    })
            }
            .navigationTitle(navTitle)
        }
    }
}
