//
//  OffenceViewModel.swift
//
//  Created on 13/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class OffenceViewModel: ObservableObject {
    private var offence: Offence?

    @Published var code = ""
    @Published var explanation = ""

    var isEmpty: Bool {
        code.isEmpty && explanation.isEmpty
    }

    convenience init(_ offence: Offence?) {
        self.init()
        if let offence = offence {
            self.offence = offence
            code = offence.code
            explanation = offence.explanation
        } else {
            self.offence = Offence()
        }
    }

    func save(clearModel: Bool = false) -> Offence? {
        if offence == nil || clearModel { offence = Offence() }
        guard let offence = offence else { return nil }
        offence.code = code
        offence.explanation = explanation
        return offence
    }
}
