//
//  CatchItemView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchItemView: View {
    @ObservedObject var fish: CatchViewModel

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack(spacing: Dimensions.spacing) {
                LabeledText(label: "Species", text: "\(fish.fish)")
                LabeledText(label: "Weight", text: "\(fish.weightString) \(fish.unit.rawValue)").opacity(fish.weight > 0 ? 1 : 0)
                LabeledText(label: "Count", text: "\(fish.number)").opacity(fish.number > 0 ? 1 : 0)
            }

            if !fish.attachments.notes.isEmpty || !fish.attachments.photoIDs.isEmpty {
                AttachmentsView(attachments: fish.attachments, isEditable: false)
            }
        }
    }
}

struct CatchItemView_Previews: PreviewProvider {
    static var previews: some View {
        let catch1 = CatchViewModel()
        let catch2 = CatchViewModel()

        catch1.fish = "Turbot"
        catch1.number = 12
        catch2.fish = "Dolphin"
        catch2.weight = 23.5
        catch2.unit = .kilograms
        return VStack {
        CatchItemView(fish: catch1)
            CatchItemView(fish: catch2)
            CatchItemView(fish: .sample)
        }
    }
}
