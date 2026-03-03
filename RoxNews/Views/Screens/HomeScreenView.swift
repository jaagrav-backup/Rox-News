//
//  HomeScreenView.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject var articleManager = ArticleManager.shared
    @StateObject var filtersManager = FiltersManager.shared
    @State var showFilterSheet = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $filtersManager.selectedPage) {
                Tab("Everything", systemImage: "newspaper.fill", value: .all) {
                    ArticleListView()
                }
                Tab("Top Headlines", systemImage: "bolt.horizontal", value: .headlines) {
                    ArticleListView()
                }
            }
            .navigationTitle("Rox News")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {
                        showFilterSheet = true
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FiltersView(showFilterSheet: $showFilterSheet)
            }
            .onChange(of: filtersManager.selectedPage) { oldValue, newValue in
                Task {
                    print("called form home")
                    await articleManager.fetchArticles()
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
