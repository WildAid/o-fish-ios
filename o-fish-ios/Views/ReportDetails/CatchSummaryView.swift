//
//  CatchSummaryView.swift
//
//  Created on 30/03/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct CatchSummaryView: View {
    var catchList: [CatchViewModel]

    private enum Dimensions {
        static let spacing: CGFloat = 16.0
        static let bottomPadding: CGFloat = 24.0
    }

    var body: some View {
        VStack(spacing: Dimensions.spacing) {
            TitleLabel(title: NSLocalizedString("Catch", comment: "") + " (\(catchList.count))")
                .padding(.top, Dimensions.spacing)
            ForEach(catchList.indices, id: \.self) { index in
                VStack(spacing: Dimensions.spacing) {
                    CatchItemView(fish: self.catchList[index])
                    if self.catchList.count > index + 1 { Divider() }
                }
            }
        }
            .padding(.bottom, Dimensions.bottomPadding)
    }
}

struct CatchSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        var catchList: [CatchViewModel] = []
        let catch1 = CatchViewModel()
        let catch2 = CatchViewModel()

        catch1.fish = "Turbot"
        catch1.number = 12
        catch2.fish = "Dolphin"
        catch2.weight = 23.5
        catch2.unit = .kilograms
        catchList.append(.sample)
        catchList.append(catch1)
        catchList.append(catch2)
        return CatchSummaryView(catchList: catchList)
    }
}
