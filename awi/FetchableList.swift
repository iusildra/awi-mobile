//
//  Fetchable.swift
//  awi
//
//  Created by Lucas NOUGUIER on 14/03/2023.
//

import Foundation
import SwiftUI

struct FetchableList<T: FestivalEntities, Content: View>: View {
    @State private var items: [T] = []
    @State private var isLoading = false
    private let apiRoute: String
    private let displayCard: (T) -> Content
    private let gridItems = [GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10)]
    
    init(apiRoute: String, displayCardFunc: @escaping  (T) -> Content) {
        self.apiRoute = apiRoute
        self.displayCard = displayCardFunc
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            displayCard(item)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        isLoading = true
        
        let url = URL(string: self.apiRoute)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isLoading = false }
            
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([T].self, from: data)
                    print(decodedResponse)
                    DispatchQueue.main.async {
                        items = decodedResponse
                    }
                    print("Data fetching completed!")
                } catch {
                    print("Fetch failed 1: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Fetch failed 2: \(error.localizedDescription)")
            }
        }.resume()
    }
}

protocol FestivalEntities: Codable, Identifiable, Hashable {
    var id: UUID { get }
    var name: String { get }
}
