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

    convenience init(_ delivery: Delivery?) {
        self.init()
        if let delivery = delivery {
            self.delivery = delivery
            date = delivery.date as Date
            location = delivery.location
            business = delivery.business
            attachments = AttachmentsViewModel(delivery.attachments)
        } else {
            self.delivery = Delivery()
        }
    }

    func save() -> Delivery? {
        if delivery == nil {
            delivery = Delivery()
        }
        guard let delivery = delivery else { return nil }
        if let deliveryDate = date {
            delivery.date = deliveryDate as NSDate
        } else {
            delivery.date = NSDate()
        }
        delivery.location = location
        delivery.business = business
        delivery.attachments = attachments.save()
        return delivery
    }

    var isEmtpy: Bool { date == nil && location.isEmpty && business.isEmpty }
}
