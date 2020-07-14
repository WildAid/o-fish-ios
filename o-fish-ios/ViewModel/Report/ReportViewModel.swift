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
        self.reportingOfficer.email = RealmConnection.emailAddress
        self.reportingOfficer.name.first = RealmConnection.firstName
        self.reportingOfficer.name.last = RealmConnection.lastName
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
        do {
            guard let realm = RealmConnection.realm else {
                print("Realm not avaialable")
                return
            }
            try realm.write {
                if isNewReport { report = Report(id: id) }
                guard let report = report else {
                    print("Realm report not avaialable")
                    return
                }
                report.location = location.save()
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
                notes.forEach { item in
                    if !item.isEmpty {
                        guard let modelItem = item.save() else { return }
                        report.notes.append(modelItem)
                    }
                }
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
    public static func ==(lhs: ReportViewModel, rhs: ReportViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
