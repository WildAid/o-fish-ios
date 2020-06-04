//
//  SummaryViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

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

    func save() -> Summary? {
        if summary == nil {
            summary = Summary()
        }
        guard let summary = summary else { return nil }
        summary.safetyLevel = safetyLevel.save()
        summary.violations.removeAll()
        self.violations.forEach { item in
            if !item.isEmpty {
                guard let itemModel = item.save() else { return }
                summary.violations.append(itemModel)
            }
        }
        summary.seizures = seizures.save()
        return summary
    }
}
