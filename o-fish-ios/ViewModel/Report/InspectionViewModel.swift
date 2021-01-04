//
//  InspectionViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class InspectionViewModel: ObservableObject, Identifiable {
    private var inspection: Inspection?

    @Published var id = UUID().uuidString
    @Published var activity = ActivityViewModel()
    @Published var fishery = FisheryViewModel()
    @Published var gearType = GearTypeViewModel()
    @Published var actualCatch = [CatchViewModel]()
    @Published var summary: SummaryViewModel = SummaryViewModel()
    @Published var attachments = AttachmentsViewModel()

    convenience init(_ inspection: Inspection?) {
        self.init()
        if let inspection = inspection {
            self.inspection = inspection
            activity = ActivityViewModel(inspection.activity)
            fishery = FisheryViewModel(inspection.fishery)
            summary = SummaryViewModel(inspection.summary)
            gearType = GearTypeViewModel(inspection.gearType)
            for index in inspection.actualCatch.indices {
                actualCatch.append(CatchViewModel(inspection.actualCatch[index]))
            }
            attachments = AttachmentsViewModel(inspection.attachments)
        } else {
            self.inspection = Inspection()
        }
    }

    func save(_ realm: DataProvider) -> Inspection? {
        if inspection == nil {
            inspection = Inspection()
        }
        guard let inspection = inspection else { return nil }

        inspection.activity = activity.save()
        inspection.fishery = fishery.save()
        inspection.summary = summary.save(realm)
        inspection.gearType = gearType.save()
        inspection.actualCatch.forEach {
            realm.delete($0)
        }
        inspection.actualCatch.append(objectsIn: actualCatch.compactMap {
            $0.isEmpty ? nil : $0.save()
        })
        inspection.attachments = attachments.save()

        return inspection
    }
}
