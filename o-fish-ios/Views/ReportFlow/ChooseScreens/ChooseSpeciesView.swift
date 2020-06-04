//
//  ChooseSpeciesView.swift
//
//  Created on 3/4/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ChooseSpeciesView: View {
    @Binding var selectedSpecies: String

    private let items: [String] = [
        "Tuna",
        "Swordfish",
        "Clownfish",
        "Other"
    ]

    var body: some View {
        TextPickerView(selectedItem: $selectedSpecies,
            items: items,
            title: "Species",
            searchBarPlaceholder: "Search Species")
    }
}

struct ChooseSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSpeciesView(selectedSpecies: .constant("Tuna"))
    }
}
