//
//  ArticleManager.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ArticleManager: ObservableObject {
    static let shared = ArticleManager()
    
    @Published var list: [Article] = []
    @Published var isLoading = true
    @Published var isError = false
    
    var filtersManager = FiltersManager.shared
    
    init() {
        Task {
            await fetchArticles()
        }
    }
    
    func fetchArticles() async {
        return withAnimation {
            switch filtersManager.selectedPage {
            case .all:
                Task {
                    list = try await fetchAllArticlesList()
                }
            case .headlines:
                Task {
                    list = try await fetchTopHeadlinesList()
                }
            }
        }
    }
    
    func fetchAllArticlesList() async throws -> [Article] {
        print("Filters Everything: \(self.filtersManager.selectedCompany), \(self.filtersManager.pageNumber), \(self.filtersManager.pageSize)")
        withAnimation {
            isError = false
            isLoading = true
        }
        do {
            let resp = try await APIManager.get(endpoint: "/everything?q=\(self.filtersManager.selectedCompany)&pageSize=\(self.filtersManager.pageSize)&page=\(self.filtersManager.pageNumber)", type: ArticlesAPIResponse.self)
            
            withAnimation {
                isLoading = false
            }
            
            return resp.articles
        } catch {
            withAnimation {
                isLoading = false
                isError = true
            }
            print(error)
            throw error
        }
    }
    
    func fetchTopHeadlinesList() async throws -> [Article] {
        print("Filters Top Headlines: \(self.filtersManager.selectedCategory), \(self.filtersManager.pageNumber), \(self.filtersManager.pageSize)")
        withAnimation {
            isError = false
            isLoading = true
        }
        do {
            let resp = try await APIManager.get(endpoint: "/top-headlines?pageSize=\(self.filtersManager.pageSize)&category=\(self.filtersManager.selectedCategory)&page=\(self.filtersManager.pageNumber)", type: ArticlesAPIResponse.self)
            
            withAnimation {
                isLoading = false
            }
            
            return resp.articles
        } catch {
            withAnimation {
                isLoading = false
                isError = true
            }
            print(error)
            throw error
        }
    }
}
