//
//  BusinessPickerData.swift
//
//  Created on 20/07/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

struct BusinessPickerData {
    var business: String
    var location: String
}

extension BusinessPickerData: Equatable {
    static func ==(lhs: BusinessPickerData, rhs: BusinessPickerData) -> Bool {
        lhs.business == rhs.business && lhs.location == rhs.location
    }
}

extension BusinessPickerData: SearchableDataProtocol {
    static let notSelected = BusinessPickerData(business: "", location: "")

    var id: String {
        business
    }

    var searchKey: String {
        business + location
    }
}
