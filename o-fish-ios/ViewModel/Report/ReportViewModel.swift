//
//  ReportViewModel.swift
//
//  Created on 10/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class ReportViewModel: ObservableObject, Identifiable {
    private var report: Report?

    var id = ObjectId.generate().stringValue
    @Published var location = LocationViewModel()
    @Published var date = Date()
    @Published var reportingOfficer = UserViewModel()
    @Published var vessel = BoatViewModel()
    @Published var captain = CrewMemberViewModel()
    @Published var crew = [CrewMemberViewModel]()
    @Published var inspection = InspectionViewModel()
    @Published var notes = [AnnotatedNoteViewModel]()

    init() {
        self.captain.isCaptain = true
        guard let user = app.currentUser() else {
            return
        }
        self.reportingOfficer.email = user.emailAddress
        self.reportingOfficer.name.first = user.firstName
        self.reportingOfficer.name.last = user.lastName
    }

    convenience init (_ report: Report) {
        self.init()
        self.report = report
        id = report._id.stringValue
        location = LocationViewModel(report.location)
        if let reportDate = report.date {
            date = reportDate as Date
        }
        reportingOfficer = UserViewModel(report.reportingOfficer)
        vessel = BoatViewModel(report.vessel)
        captain = CrewMemberViewModel(report.captain, isCaptain: true)
        for index in report.crew.indices {
            crew.append(CrewMemberViewModel(report.crew[index]))
        }
        inspection = InspectionViewModel(report.inspection)
        for index in report.notes.indices {
            notes.append(AnnotatedNoteViewModel(report.notes[index]))
        }
    }

    func removeCrewMemberFromLinkedViolations(_ crewMember: CrewMemberViewModel) {
        let violationsWithThisCrew = violationsLinkedToCrewMember(id: crewMember.id)
        violationsWithThisCrew.forEach { $0.crewMember = CrewMemberViewModel() }
    }

    func violationsLinkedToCrewMember(id: String) -> [ViolationViewModel] {
        inspection.summary.violations.filter { $0.crewMember.id == id }
    }

    func replaceCaptainInLinkedViolations(with newCaptain: CrewMemberViewModel) {
        let violationsWithCaptain = inspection.summary.violations.filter { $0.crewMember.isCaptain }
        violationsWithCaptain.forEach { $0.crewMember = newCaptain }
    }

    func save() {
        let isNewReport = (report == nil)
        guard let realm = app.currentUser()?.agencyRealm(),
              let report = isNewReport ? Report(id: id) : report else {
            print("Realm not available")
            return
        }
        do {
            try realm.write {
                report.location.append(location.longitude)
                report.location.append(location.latitude)
                report.date = date as NSDate
                report.reportingOfficer = reportingOfficer.save()
                report.vessel = vessel.save()
                report.captain = captain.save()
                report.crew.removeAll()
                crew.forEach { item in
                    if !item.isEmpty {
                        guard let modelItem = item.save() else { return }
                        report.crew.append(modelItem)
                    }
                }
                report.inspection = inspection.save()
                report.notes.append(objectsIn: notes.compactMap {
                    $0.isEmpty ? nil : $0.save()
                })
                if isNewReport {
                    realm.add(report)
                }
            }
        } catch {
            print("Couldn't add report to Realm")
        }
    }

    func discard() {
        PhotoViewModel.delete(reportID: id)
    }
}

extension ReportViewModel: Equatable {
    public static func == (lhs: ReportViewModel, rhs: ReportViewModel) -> Bool { lhs.id == rhs.id }
}
