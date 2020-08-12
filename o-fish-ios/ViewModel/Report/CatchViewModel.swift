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

    @Published var quantityType: [QuantityType] = [.notSelected]

    enum UnitSpecification: String {
        case notSelected = ""

        case pound = "lbs"
        case kilograms = "kg"
        case tons = "Tons"
        case tonnes = "Tonnes"

        static var allCases: [CatchViewModel.UnitSpecification] {
            let locale = Locale.current
            guard let languageCode = locale.languageCode,
                let regionCode = locale.regionCode else {return [kilograms, tonnes, pound, tons]}
            if languageCode == "en" && regionCode == "US" {
                return [pound, kilograms, tons, tonnes]
            } else {
                return [kilograms, tonnes, pound, tons]
            }
        }

    }

    enum QuantityType: String {
        case notSelected = ""
        case weight = "Weight"
        case count = "Count"

        static let separator = " & "
    }

    var weightString: String {
        if weight > 0 {
            return "\(weight)"
        } else {
            return ""
        }
    }

    var quantityTypeString: String {
        quantityType.map {
            $0.rawValue
        }.joined(separator: CatchViewModel.QuantityType.separator)
    }

    var isEmpty: Bool {
        fish.isEmpty && quantityType.contains(.notSelected) && number == 0 && weight == 0 && unit == .notSelected
    }

    var isComplete: Bool {
        var result = false

        result = !fish.isEmpty
        result = result && !(quantityType == [.notSelected])

        result = result && !(quantityType.contains(.weight) && weight == 0)
        result = result && !(quantityType.contains(.weight) && unit == .notSelected)
        result = result && !(quantityType.contains(.count) && number == 0)

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
