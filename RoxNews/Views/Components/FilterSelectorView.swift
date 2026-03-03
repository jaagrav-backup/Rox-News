//
//  FilterSelectorView.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 02/03/26.
//

import SwiftUI

struct FilterSelectorView: View {
    var filterName: String = ""
    
    @Binding var selectedValue: String
    var list: [String]
    
    var body: some View {
        Picker(filterName, selection: $selectedValue) { // The label is used for accessibility and some styles
            ForEach(list, id: \.self) { value in
                Text(value)
                    .tag(value) // Tag matches the type of the bound state variable
            }
        }
    }
}
