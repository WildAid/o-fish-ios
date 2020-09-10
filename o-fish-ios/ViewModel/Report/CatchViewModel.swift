//
//  CatchViewModel.swift
//
//  Created on 14/03/2020.
//

import Foundation

class CatchViewModel: ObservableObject, Identifiable {
    private var catchModel: Catch?

    @Published var id = UUID().uuidString
    @Published var fish = ""
    @Published var number = 0
    @Published var weight = 0.0
    @Published var unit: UnitSpecification = .notSelected
    @Published var attachments = AttachmentsViewModel()

    enum UnitSpecification: String {
        case notSelected = ""

        case pound = "lbs"
        case kilograms = "kg"
        case tons = "Tons"
        case tonnes = "Tonnes"

        static var allCases: [CatchViewModel.UnitSpecification] {
            let locale = Locale.current
            var cases = [kilograms, tonnes, pound, tons]
            if locale.regionCode == "US" {
                cases = [pound, tonnes, kilograms, tons]
            }
            return cases
        }
    }

    var weightString: String {
        if weight > 0 {
            return "\(weight)"
        } else {
            return ""
        }
    }

    var isEmpty: Bool {
        fish.isEmpty && number == 0 && weight == 0 && unit == .notSelected
    }

    var isComplete: Bool {
        var result = false

        result = !fish.isEmpty
        result = result && ((weight != 0 && unit != .notSelected) || !(number == 0))
        result = result && !(weight != 0 && unit == .notSelected)

        return result
    }

    convenience init(_ fishCatch: Catch?) {
        self.init()
        if let fishCatch = fishCatch {
            catchModel = fishCatch
            fish = fishCatch.fish
            number = fishCatch.number
            weight = fishCatch.weight
            unit = UnitSpecification(rawValue: fishCatch.unit) ?? .notSelected
            attachments = AttachmentsViewModel(fishCatch.attachments)
        } else {
            catchModel = Catch()
        }
    }

    func save() -> Catch? {
        if catchModel == nil {
            catchModel = Catch()
        }
        guard let catchModel = catchModel else { return nil }
        catchModel.fish = fish
        catchModel.number = number
        catchModel.weight = weight
        catchModel.unit = unit.rawValue
        catchModel.attachments = attachments.save()
        return catchModel
    }
}
