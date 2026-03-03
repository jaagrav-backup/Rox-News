//
//  FiltersView.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 02/03/26.
//

import SwiftUI

struct FiltersView: View {
    @StateObject var articleManager = ArticleManager.shared
    @StateObject var filtersManager = FiltersManager.shared
    
    @Binding var showFilterSheet: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section("Select") {
                    switch filtersManager.selectedPage {
                    case .headlines:
                        FilterSelectorView(filterName: "Category", selectedValue: $filtersManager.selectedCategory, list: ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"])
                    case .all:
                        FilterSelectorView(filterName: "Company", selectedValue: $filtersManager.selectedCompany, list: ["Nvidia", "Microsoft", "Apple", "Google", "OpenAI", "Anthropic", "IBM", "AMD"])
                    }
                }
                Section("Page") {
                    Stepper(value: $filtersManager.pageNumber) {
                        Text("Page Number: \(filtersManager.pageNumber)")
                    }
                    Stepper(value: $filtersManager.pageSize) {
                        Text("Page Size: \(filtersManager.pageSize)")
                    }
                }
                .onChange(of: filtersManager.pageNumber) { oldValue, newValue in
                    if newValue == 0 {
                        filtersManager.pageNumber = 1
                    } else if newValue == 5 {
                        filtersManager.pageNumber = 1
                    }
                }
                .onChange(of: filtersManager.pageSize) { oldValue, newValue in
                    if newValue == 0 {
                        filtersManager.pageSize = 1
                    } else if newValue == 11 {
                        filtersManager.pageSize = 1
                    }
                }
            }
            .navigationTitle("Modify filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showFilterSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showFilterSheet = false
                    }
                }
            }
            .onChange(of: showFilterSheet) { oldValue, newValue in
                if !showFilterSheet {
                    Task {
                        print("called from filters")
                        await articleManager.fetchArticles()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

