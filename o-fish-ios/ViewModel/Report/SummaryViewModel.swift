//
//  SummaryViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class SummaryViewModel: ObservableObject, Identifiable {
    private var summary: Summary?

    @Published var id = UUID().uuidString
    @Published var safetyLevel = SafetyLevelViewModel()
    @Published var violations = [ViolationViewModel]()
    @Published var seizures = SeizuresViewModel()

    convenience init(_ summary: Summary?) {
        self.init()
        if let summary = summary {
            self.summary = summary
            safetyLevel = SafetyLevelViewModel(summary.safetyLevel)
            for index in summary.violations.indices {
                violations.append(ViolationViewModel(summary.violations[index]))
            }
            seizures = SeizuresViewModel(summary.seizures)
        } else {
            self.summary = Summary()
        }
    }

    func save(_ realm: Realm) -> Summary? {
        if summary == nil {
            summary = Summary()
        }
        guard let summary = summary else { return nil }
        summary.safetyLevel = safetyLevel.save()
        summary.violations.forEach {
            realm.delete($0)
        }
        summary.violations.append(objectsIn: violations.compactMap {
            $0.isEmpty ? nil : $0.save()
        })
        summary.seizures = seizures.save()
        return summary
    }
}
