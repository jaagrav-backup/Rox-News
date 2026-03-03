//
//  Generables.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 03/03/26.
//

import FoundationModels

@Generable
struct Summary {
    @Guide(description: "Summarised text given from the provided prompt of news")
    var text: String
}
