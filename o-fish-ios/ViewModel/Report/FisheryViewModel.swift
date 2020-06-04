//
//  FisheryViewModel.swift
//
//  Created on 08/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import Foundation

class FisheryViewModel: ObservableObject, Identifiable {
    private var fishery: Fishery?

    @Published var id = UUID().uuidString
    @Published var name = ""
    @Published var attachments = AttachmentsViewModel()

    convenience init(_ fishery: Fishery?) {
        self.init()
        if let fishery = fishery {
            self.fishery = fishery
            name = fishery.name
            attachments = AttachmentsViewModel(fishery.attachments)
        } else {
            self.fishery = Fishery()
        }
    }

    func save() -> Fishery? {
        if fishery == nil {
            fishery = Fishery()
        }
        guard let fishery = fishery else { return nil }

        fishery.name = name
        fishery.attachments = attachments.save()
        return fishery
    }
}
