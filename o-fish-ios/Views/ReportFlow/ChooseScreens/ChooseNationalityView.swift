//
//  ChooseNationalityView.swift
//
//  Created on 11/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

private class CountryHelper {

    static let shared = CountryHelper()

    private func pickerDataFromCountry(code: String) -> CountryPickerData? {
        if let name = Locale.autoupdatingCurrent.localizedString(forRegionCode: code) {
            return CountryPickerData(code: code, title: name)
        }
        return nil
    }

    private func prioritySettingsCountryCodes() -> [String] {
        var priorityCodes = [String]()
        for code in Settings.shared.menuData.countryPickerPriorityList {
            priorityCodes.append(code)
        }
        return priorityCodes
    }

    private func allCountryCodes() -> [String] {
        Locale.isoRegionCodes
    }

    func countriesData() -> [CountryPickerData] {
        var codes = allCountryCodes()
        let priorityCodes = prioritySettingsCountryCodes()

        priorityCodes.forEach { code in codes.removeAll { code == $0 } }

        var result = [CountryPickerData]()
        for code in codes {
            if let data = pickerDataFromCountry(code: code) {
                result.append(data)
            }
        }
        result = result.sorted { $0.title < $1.title }

        var priorityData = [CountryPickerData]()
        for code in priorityCodes {
            if let data = pickerDataFromCountry(code: code) {
                priorityData.append(data)
            }
        }
        result.insert(contentsOf: priorityData, at: 0)
        return result
    }
}

struct ChooseNationalityView: View {
    let countries: [CountryPickerData] = CountryHelper.shared.countriesData()

    @Binding var selectedItem: CountryPickerData

    var body: some View {
        CountryPickerView(selectedItem: $selectedItem,
            items: countries,
            title: "Flag State",
            searchBarPlaceholder: "Search Flag State")
    }
}

struct ChooseNationalityView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseNationalityView(selectedItem: .constant(CountryPickerData(code: "FR",
                                                                        title: "France")))
    }
}
