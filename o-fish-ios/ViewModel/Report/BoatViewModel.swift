//
//  BoatViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import RealmSwift

class BoatViewModel: ObservableObject, Identifiable {
    private var boat: Boat?

    @Published var id = UUID().uuidString
    @Published var name = ""
    @Published var homePort = ""
    @Published var nationality = ""
    @Published var permitNumber = ""
    @Published var ems: [EMSViewModel] = []
    @Published var lastDelivery = DeliveryViewModel()
    @Published var attachments = AttachmentsViewModel()

    var isEmpty: Bool {
        name.isEmpty && homePort.isEmpty && nationality.isEmpty && permitNumber.isEmpty
    }

    convenience init(_ boat: Boat?) {
        self.init()
        if let boat = boat {
            self.boat = boat
            name = boat.name
            homePort = boat.homePort
            nationality = boat.nationality
            permitNumber = boat.permitNumber
            for index in boat.ems.indices {
                ems.append(EMSViewModel(boat.ems[index]))
            }
            lastDelivery = DeliveryViewModel(boat.lastDelivery)
            attachments = AttachmentsViewModel(boat.attachments)
        } else {
            self.boat = Boat()
        }
    }

    func save(_ realm: DataProvider) -> Boat? {
        if boat == nil {
            boat = Boat()
        }
        guard let boat = boat else { return nil }
        boat.name = name
        boat.homePort = homePort
        boat.nationality = nationality
        boat.permitNumber = permitNumber
        boat.lastDelivery = lastDelivery.save()
        boat.ems.forEach {
            realm.delete($0)
        }
        boat.ems.append(objectsIn: ems.compactMap {
            $0.isEmpty ? nil : $0.save()
        })
        boat.attachments = attachments.save()
        return boat
    }
}
