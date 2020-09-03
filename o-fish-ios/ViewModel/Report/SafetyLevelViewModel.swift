//
//  SafetyLevelViewModel.swift
//
//  Created on 09/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class SafetyLevelViewModel: ObservableObject, Identifiable {
    private var safetyLevel: SafetyLevel?

    @Published var level: LevelColor = .green
    @Published var reason = ""
    @Published var attachments = AttachmentsViewModel()

    enum LevelColor: String {
        case red = "Red"
        case amber = "Amber"
        case green = "Green"
    }

    convenience init(_ safetyLevel: SafetyLevel?) {
        self.init()
        if let safetyLevel = safetyLevel {
            self.safetyLevel = safetyLevel
            level = LevelColor(rawValue: safetyLevel.level) ?? .green
            reason = safetyLevel.amberReason
            attachments = AttachmentsViewModel(safetyLevel.attachments)
        } else {
            self.safetyLevel = SafetyLevel()
        }
    }

    func save() -> SafetyLevel? {
        if safetyLevel == nil {
            safetyLevel = SafetyLevel()
        }
        guard let safetyLevel = safetyLevel else { return nil }

        safetyLevel.level = level.rawValue
        safetyLevel.amberReason = reason
        safetyLevel.attachments = attachments.save()
        return safetyLevel
    }
}
