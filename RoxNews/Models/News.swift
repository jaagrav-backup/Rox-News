//
//  Item.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import Foundation

struct Source: Decodable {
    var name: String
}

struct Article: Decodable {
    var author: String? = nil
    var title: String
    var description: String? = "Poop"
    var url: String
    var urlToImage: String? = nil
    var publishedAt: String
    var content: String? = nil
    var source: Source? = nil
}

struct ArticlesAPIResponse: Decodable {
    var articles: [Article]
}
