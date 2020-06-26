//
//  ChooseSpeciesView.swift
//
//  Created on 3/4/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct ChooseSpeciesView: View {
    @Binding var selectedSpecies: String

    private var items: [String] {
        var speciesList = [String]()
        for species in Settings.shared.menuData.species {
            speciesList.append(species)
        }
        return speciesList
    }

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
