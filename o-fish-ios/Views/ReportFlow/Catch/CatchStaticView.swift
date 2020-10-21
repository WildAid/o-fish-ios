//
//  CatchStaticView.swift
//
//  Created on 02/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchStaticView: View {
    let catchModel: CatchViewModel
    let index: Int

    var editClicked: ((CatchViewModel) -> Void)?

    private enum Dimensions {
        static let bottomPadding: CGFloat = 24.0
        static let spacing: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            HStack {
                TitleLabel(title: NSLocalizedString("Catch", comment: "") + " \(self.index)")
                Button(action: { self.editClicked?(self.catchModel) }) {
                    EditIconView()
                }
            }
            .padding(.top, Dimensions.spacing)
            HStack(spacing: Dimensions.spacing) {
                LabeledText(label: "Species",
                            text: catchModel.fish)
                if catchModel.weight != 0 {
                    LabeledText(label: "Weight",
                                text: "\(catchModel.weightString) \(catchModel.unit.rawValue)")
                }
                if catchModel.number != 0 {
                    LabeledText(label: "Count",
                                text: "\(catchModel.number)")
                }
            }
            AttachmentsView(attachments: catchModel.attachments, isEditable: false)
        }
        .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct CatchStaticView_Previews: PreviewProvider {
    static var previews: some View {
        let catch1 = CatchViewModel()
        let catch2 = CatchViewModel()

        catch1.fish = "Turbot"
        catch1.number = 12
        catch2.fish = "Dolphin"
        catch2.weight = 23.5
        catch2.unit = .kilograms

        return Group {
            CatchStaticView(catchModel: catch1, index: 1)
            CatchStaticView(catchModel: catch2, index: 2)
            CatchStaticView(catchModel: .sample, index: 3)
        }
    }
}
