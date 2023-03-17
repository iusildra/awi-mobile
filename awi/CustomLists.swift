//
//  Fetchable.swift
//  awi
//
//  Created by Lucas NOUGUIER on 14/03/2023.
//

import Foundation
import SwiftUI

struct FetchableList<T: Decodable, Content: View>: View {
    @State var items: [T] = []
    @State var isLoading = false
    let apiRoute: String
    let contentFactory: ([T]) -> Content
    
    init(apiRoute: String, isLoading: Bool = false, contentFactory: @escaping ([T]) -> Content) {
        self.apiRoute = apiRoute
        self.isLoading = isLoading
        self.contentFactory = contentFactory
    }
    
    func fetchData() {
        self.isLoading = true
        
        let url = URL(string: apiRoute)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([T].self, from: data)
                    print(decodedResponse)
                    DispatchQueue.main.async {
                        self.items = decodedResponse
                    }
                    print("Data fetching completed!")
                    self.isLoading = false
                } catch {
                    print("Fetch failed 1: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Fetch failed 2: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            if self.isLoading {
                ProgressView()
            } else {
                self.contentFactory(items)
            }
        }.onAppear{
            self.fetchData()
        }
    }
}

struct DisplayList<T: Decodable & Hashable, Content: View>: View {
    let itemList: FetchableList<T, Content>
    let itemViewFactory: (T) -> Content
    let gridItems = [GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10)]
    
    init(apiRoute: String, displayCardFunc: @escaping  (T) -> Content) {
        self.itemViewFactory = displayCardFunc
        self.itemList = FetchableList<T>(apiRoute: apiRoute, contentFactory: { (items: [T]) -> (any View) in viewContent(items: items) })
    }
    
    func viewContent(items: [T]) -> any View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    itemViewFactory(item)
                }
            }
            .padding()
        }
    }
    
    var body: some View {
        itemList
    }
}

struct NavigableList<T: Decodable & Hashable, Content: View>: View {
    let itemList: FetchableList<T, Content>
    let itemViewFactory: (T) -> Content
    let gridItems = [GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10)]
    
    init(apiRoute: String, displayCardFunc: @escaping  (T) -> Content) {
        self.itemViewFactory = displayCardFunc
        self.itemList = FetchableList<T, Content>(apiRoute: apiRoute, contentFactory: viewContent)
    }
    
    func viewContent(items: [T]) -> some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(itemList.items, id: \.self) { item in
                    itemViewFactory(item)
                }
            }
            .padding()
        }
    }
    
    var body: some View {
        itemList
    }
}
