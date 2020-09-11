//
//  SampleUserViewModel.swift
//
//  Created on 31/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

extension NameViewModel: Samplable {
    static var sample: NameViewModel {
        let name = NameViewModel()
        name.first = "Big"
        name.last = "Fish"
        return name
    }
}

extension UserViewModel: Samplable {
    static var sample: UserViewModel {
        let user = UserViewModel()
        user.name = .sample
        user.email = "john.doe@wildaid.org"
        return user
    }
}

extension DutyChangeViewModel: Samplable {
    static var sample: DutyChangeViewModel {
        let dutyChange = DutyChangeViewModel()
        dutyChange.user = .sample
        return dutyChange
    }
}

extension DutyState: Samplable {
    static var sample: DutyState {
        DutyState.shared.onDuty = true
        return DutyState.shared
    }
}
