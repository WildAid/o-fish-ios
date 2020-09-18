//
//  ReportViewModel.swift
//
//  Created on 10/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class ReportViewModel: ObservableObject, Identifiable {
    // Not making this private as it's used by the unit tests
    var report: Report?

    var id = ObjectId.generate().stringValue
    @Published var draft = false
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
        draft = report.draft.value ?? false
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
        guard let realm = app.currentUser()?.agencyRealm() else {
            print("Realm not available")
            return
        }
        guard let report = isNewReport ? Report(id: id) : report else {
            print("report not set")
            return
        }
        do {
            try realm.write {
                report.draft.value = draft
                report.location.removeAll()
                report.location.append(location.longitude)
                report.location.append(location.latitude)
                report.date = date as NSDate
                report.reportingOfficer = reportingOfficer.save()
                report.vessel = vessel.save()
                report.captain = captain.save()
                report.crew.removeAll()
                report.crew.append(objectsIn: crew.compactMap {
                    $0.isEmpty ? nil : $0.save()
                })
                report.inspection = inspection.save()
                report.notes.removeAll()
                report.notes.append(objectsIn: notes.compactMap {
                    $0.isEmpty ? nil : $0.save()
                })
                self.report = report
                if isNewReport {
                    realm.add(report)
                }
            }
        } catch let error {
            print("Couldn't write report to Realm: \(error.localizedDescription)")
        }
    }

    func discard() {
        guard let realm = app.currentUser()?.agencyRealm() else {
            print("Realm not available")
            return
        }
        PhotoViewModel.delete(reportID: id, realm: realm)
        guard let report = report else {
            print("Deleting, but report not set")
            return
        }
        print("Report has already been saved to Realm and so deleting it")
        do {
            try realm.write {
                realm.delete(report)
            }
            self.report = nil
        } catch let error {
            print("Couldn't delete report from Realm: \(error.localizedDescription)")
        }
    }
}

extension ReportViewModel: Equatable {
    public static func == (lhs: ReportViewModel, rhs: ReportViewModel) -> Bool { lhs.id == rhs.id }
}
