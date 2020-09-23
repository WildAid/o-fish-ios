//
//  UserViewModel.swift
//
//  Created on 25/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

class UserViewModel: ObservableObject {
    var user: User?

    @Published var name = NameViewModel()
    @Published var email = ""

    convenience init(_ user: User?) {
        self.init()
        if let user = user {
            self.user = user
            name = NameViewModel(name: user.name)
            email = user.email
        } else {
            self.user = User()
        }
    }

    func save(existingObject: Bool = false) -> User? {
        if user == nil || !existingObject {
            user = User()
        }
        guard let user = user else { return nil }
        user.name = name.save(existingObject: existingObject)
        user.email = email
        return user
    }
}
