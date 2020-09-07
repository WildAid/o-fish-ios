//
//  SampleReportViewModel.swift
//
//  Created on 27/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

// Sample/Example data to be viewed in view previews and in tests

import Foundation

extension ReportViewModel: Samplable {
    static var sample: ReportViewModel {
        let report = ReportViewModel()
        report.location = LocationViewModel.sample
        report.reportingOfficer = .sample
        report.vessel = .sample
        report.captain = .sample
        report.crew = [.sample, .sample, .sample]
        report.inspection = .sample
        report.notes = [.sample, .sample]
        return report
    }
}

extension AttachmentsViewModel: Samplable {
    static var sample: AttachmentsViewModel {
        let attachments = AttachmentsViewModel()
        let note1 = Note(id: UUID().uuidString, text: "First Note")
        let note2 = Note(id: UUID().uuidString, text: "Second Note")
        let note3 = Note(id: UUID().uuidString, text: "Third Note")
        attachments.photoIDs = ["00000000", "00000001"]
        attachments.notes = [note1, note2, note3]
        return attachments
    }
}

extension AnnotatedNoteViewModel: Samplable {
    static var sample: AnnotatedNoteViewModel {
        let annotatedNote = AnnotatedNoteViewModel()
        annotatedNote.photoIDs = ["00000000", "00000001"]
        annotatedNote.note = "This is a note"
        return annotatedNote
    }
}

extension OffenceViewModel: Samplable {
    static var sample: OffenceViewModel {
        let offence = OffenceViewModel()
        offence.code = "WA-8273464"
        offence.explanation = "Doing something that you're not meant to do\nMultiline\nMultiline 2"
        return offence
    }
}

extension LocationViewModel: Samplable {
    static var sample: LocationViewModel {
        let location = LocationViewModel(LocationHelper.currentLocation)
        return location
    }
}

extension CrewMemberViewModel: Samplable {
    static var sample: CrewMemberViewModel {
        let crew = CrewMemberViewModel()
        crew.name = "Forrest Gump"
        crew.license = "1234567890"
        crew.attachments = .sample
        return crew
    }
}

extension FisheryViewModel: Samplable {
    static var sample: FisheryViewModel {
        let fishery = FisheryViewModel()
        fishery.name = "Kipper"
        fishery.attachments = .sample
        return fishery
    }
}

extension ActivityViewModel: Samplable {
    static var sample: ActivityViewModel {
        let activity = ActivityViewModel()
        activity.name = "Tickling"
        activity.attachments = .sample
        return activity
    }
}

extension SafetyLevelViewModel: Samplable {
    static var sample: SafetyLevelViewModel {
        let safetyLevel = SafetyLevelViewModel()
        safetyLevel.level = .amber
        safetyLevel.attachments = .sample
        safetyLevel.reason = "The captain had a gun stashed in the wheelhouse. He was unfriendly, argumentative, and uncooperative"
        return safetyLevel
    }
}

extension GearTypeViewModel: Samplable {
    static var sample: GearTypeViewModel {
        let gearType = GearTypeViewModel()
        gearType.name = "Pole"
        gearType.attachments = .sample
        return gearType
    }
}

extension EMSViewModel: Samplable {
    static var sample: EMSViewModel {
        let ems = EMSViewModel()
        ems.id = "123"
        ems.emsType = "Other"
        ems.emsDescription = "Makes odd noises"
        ems.registryNumber = "77777777"
        ems.attachments = .sample
        return ems
    }
}

extension DeliveryViewModel: Samplable {
    static var sample: DeliveryViewModel {
        let delivery = DeliveryViewModel()
        delivery.id = "123"
        delivery.location = """
                            42 Wallaby Way
                            Sydney NSW 2000
                            Australia
                            """
        delivery.business = "Oh My Cod"
        delivery.attachments = .sample
        return delivery
    }
}

extension BoatViewModel: Samplable {
    static var sample: BoatViewModel {
        let boat = BoatViewModel()
        boat.id = "123"
        boat.name = "Rainbow Warrior"
        boat.homePort = "London"
        boat.nationality = "Switzerland"
        boat.permitNumber = "77363622"
        boat.ems = [.sample]
        boat.lastDelivery = .sample
        boat.attachments = .sample
        return boat
    }
}

extension CatchViewModel: Samplable {
    static var sample: CatchViewModel {
        let thisCatch = CatchViewModel()
        thisCatch.fish = "Goldfish"
        thisCatch.number = 20
        thisCatch.weight = 30.5
        thisCatch.unit = .kilograms
        thisCatch.attachments = .sample
        return thisCatch
    }
}

extension SeizuresViewModel: Samplable {
    static var sample: SeizuresViewModel {
        let seizures = SeizuresViewModel()
        seizures.description = "Fine nets"
        seizures.attachments = .sample
        return seizures
    }
}

extension ViolationViewModel: Samplable {
    static var sample: ViolationViewModel {
        let violation = ViolationViewModel()
        violation.disposition = .warning
        violation.offence = .sample
        violation.crewMember = .sample
        violation.attachments = .sample
        return violation
    }
}

extension SummaryViewModel: Samplable {
    static var sample: SummaryViewModel {
        let summary = SummaryViewModel()
        summary.safetyLevel = .sample
        summary.violations = [.sample, .sample]
        summary.seizures = .sample
        return summary
    }
}

extension InspectionViewModel: Samplable {
    static var sample: InspectionViewModel {
        let inspection = InspectionViewModel()
        inspection.activity = .sample
        inspection.fishery = .sample
        inspection.gearType = .sample
        inspection.actualCatch = [.sample, .sample, .sample]
        inspection.summary = .sample
        inspection.attachments = .sample
        return inspection
    }
}

extension PhotoViewModel: Samplable {
    static var sample: PhotoViewModel {
        let photo = PhotoViewModel()
        photo.pictureURL = "https://fishingnews.co.uk/wp-content/uploads/2017/12/STG-1-cropped-820x547.jpg"
        photo.picture = nil
        return photo
    }
}
