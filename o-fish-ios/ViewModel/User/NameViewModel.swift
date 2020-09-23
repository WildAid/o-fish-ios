//
//  NameViewModel.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class NameViewModel: ObservableObject {
    var name: Name?

    @Published var first = ""
    @Published var last = ""

    var fullName: String {
       "\(first) \(last)"
    }

    convenience init(name: Name?) {
        self.init()
        if let name = name {
            self.first = name.first
            self.last = name.last
        }

    }

    func save(existingObject: Bool = false) -> Name? {
        if name == nil || !existingObject {
            name = Name()
        }
        guard let name = name else { return nil }
        name.first = self.first
        name.last = self.last
        return name
    }
}
