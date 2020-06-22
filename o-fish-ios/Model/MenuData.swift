//
//  MenuData.swift
//
//  Created on 17/02/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

enum MenuType: Int {
    case countryPickerPriorityList = 0, ports, fisheries, species, emsTypes, activities, gear, violationCodes, violationDescriptions, overflow
}

class MenuData: EmbeddedObject, ObservableObject {
    @objc dynamic var type = MenuType.overflow.rawValue { willSet { objectWillChange.send() } }
    let data = List<String>()
}

class MenuDataList: Object {
    @objc dynamic var _id = ObjectId.generate()
    // TODO: This should be replaced with a Realm  query once available. This meta data
    // will be set up in Atlas by the web app and then synced to this app by Realm

    // Ecuador and Panama on top
    static let countryPickerPriorityList = ["EC", "PA"]
    static let ports = ["Other", "London", "Miami", "San Francisco"]
    static let fisheries = ["Tuna", "Groundfish", "Bluefish", "Other"]
    static let species = ["Tuna", "Swordfish", "Clownfish", "Other"]
    static let emsTypes = ["Automatic Identification System (AIS)", "Visible Infrared Radiometer Suite (VIRS)", "Other"]
    static let activities = ["Fishing", "Transiting", "Offloading", "Other"]
    static let gear = ["Trawl", "Long-line", "Nets", "Other"]
    static let violationCodes = ["Fish and Game code 7850(a)",
                                 "Fish and Game code 7145(a)",
                                 "T-14 29.85(a)(7)",
                                 "T-14 189(a)",
                                 "T-14 27.80(a)(2)"]
    static let violationDescriptions = ["No commercial license",
                                        "Fishing without a license",
                                        "Take/Possess undersize Dungeness crab",
                                        "Take in violation of Federal Regulations",
                                        "Use barbed hooks for Salmon"]

    var data = List<MenuData>()

    func getOptionId(menuType: MenuType, string: String) -> Int {
        return data[menuType.rawValue].data.firstIndex(of: string) ?? 0
    }

    func getOptionString(menuType: MenuType, index: Int) -> String {
        return data[menuType.rawValue].data[index]
    }

    func optionCount(_ menuType: MenuType) -> Int {
        return data[menuType.rawValue].data.count
    }

    required init() {
        let countryPickerPriorityList = MenuData()
        countryPickerPriorityList.type = MenuType.countryPickerPriorityList.rawValue
        countryPickerPriorityList.data.append(objectsIn: Self.countryPickerPriorityList)
        data.append(countryPickerPriorityList)

        let portData = MenuData()
        portData.type = MenuType.ports.rawValue
        portData.data.append(objectsIn: Self.ports)
        data.append(portData)

        let fisheriesData = MenuData()
        fisheriesData.type = MenuType.fisheries.rawValue
        fisheriesData.data.append(objectsIn: Self.fisheries)
        data.append(fisheriesData)

        let speciesData = MenuData()
        speciesData.type = MenuType.species.rawValue
        speciesData.data.append(objectsIn: Self.species)
        data.append(speciesData)

        let emsTypesData = MenuData()
        emsTypesData.type = MenuType.emsTypes.rawValue
        emsTypesData.data.append(objectsIn: Self.emsTypes)
        data.append(emsTypesData)

        let activitiesData = MenuData()
        activitiesData.type = MenuType.activities.rawValue
        activitiesData.data.append(objectsIn: Self.activities)
        data.append(activitiesData)

        let gearData = MenuData()
        gearData.type = MenuType.gear.rawValue
        gearData.data.append(objectsIn: Self.gear)
        data.append(gearData)

        let violationCodesData = MenuData()
        violationCodesData.type = MenuType.violationCodes.rawValue
        violationCodesData.data.append(objectsIn: Self.violationCodes)
        data.append(violationCodesData)

        let violationDescriptionsData = MenuData()
        violationDescriptionsData.type = MenuType.violationDescriptions.rawValue
        violationDescriptionsData.data.append(objectsIn: Self.violationDescriptions)
        data.append(violationDescriptionsData)
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}
