//
//  FiltersManager.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 03/03/26.
//

import Foundation
import Combine

class FiltersManager: ObservableObject {
    static let shared = FiltersManager()
    
    @Published var selectedPage: NewsType = .all
    @Published var selectedCategory: String = "General"
    @Published var selectedCompany: String = "Nvidia"
    @Published var pageNumber: Int = 1
    @Published var pageSize: Int = 8
}
