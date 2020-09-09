//
//  DeliveryViewModel.swift
//
//  Created on 14/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class DeliveryViewModel: ObservableObject, Identifiable {
    private var delivery: Delivery?

    @Published var id = UUID().uuidString
    @Published var date: Date?
    @Published var location = ""
    @Published var business = ""
    @Published var attachments = AttachmentsViewModel()

    var isEmpty: Bool { date == nil && location.isEmpty && business.isEmpty && attachments.isEmpty }

    convenience init(_ delivery: Delivery?) {
        self.init()
        if let delivery = delivery {
            self.delivery = delivery

            // TODO: Remove this when the legacy documents have been removed from the Atlas data
            if delivery.date == NSDate(timeIntervalSince1970: 0) {
                date = nil
            } else {
                date = delivery.date as Date
            }
            location = delivery.location
            business = delivery.business
            attachments = AttachmentsViewModel(delivery.attachments)
        } else {
            self.delivery = Delivery()
        }
    }

    func save() -> Delivery? {
        if isEmpty {
            print("No delivery to save")
            delivery = nil
        } else {
            if delivery == nil {
                delivery = Delivery()
            }
            guard let delivery = delivery else { return nil }
            if let deliveryDate = date {
                delivery.date = deliveryDate as NSDate
            }
            delivery.location = location
            delivery.business = business
            delivery.attachments = attachments.save()
        }
        return delivery
    }
}
