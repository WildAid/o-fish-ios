//
//  VesselRecordHeaderView.swift
//
//  Created on 3/25/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselRecordHeaderView: View {

    @ObservedObject var report: ReportViewModel
    @ObservedObject var onDuty: DutyState
    var boardings: Int
    var warnings: Int
    var citations: Int

    @State private var vesselImages: [AnyView] = []

    private let photoQueryManager = PhotoQueryManager.shared

    private enum Dimensions {
        static let mainSpacing: CGFloat = 24.0
        static let padding: CGFloat = 16.0
        static let imageSize: CGFloat = 168.0
    }

    /// Interface

    var body: some View {
        VStack(spacing: .zero) {
           topView

            VStack {
                Text(report.vessel.name)
                    .font(Font.title3.weight(.semibold))
                    .bold()
                    .foregroundColor(.text)
                Text(NSLocalizedString("Permit #", comment: "") + report.vessel.permitNumber)
                    .font(.subheadline)
            }
                .padding(.vertical, Dimensions.mainSpacing)

            HStack(spacing: .zero) {
                ColumnText(title: "\(boardings)",
                    subtitle: NSLocalizedString((boardings > 1 ? "Boardings" : "Boarding"), comment: "").uppercased())
                ColumnText(title: "\(warnings)",
                    subtitle: NSLocalizedString((warnings > 1 ? "Warnings" : "Warning"), comment: "").uppercased())
                ColumnText(title: "\(citations)",
                    subtitle: NSLocalizedString((citations > 1 ? "Citations" : "Citation"), comment: "").uppercased())
            }
                .padding(.horizontal, Dimensions.padding)

            BoardVesselButton(onDuty: onDuty, report: report)
        }
            .onAppear(perform: onAppear)
    }

    private var topView: some View {
        Group {
            if vesselImages.isEmpty {
                ZStack {
                    Rectangle()
                        .fill(Color.appGray)
                    Image("BoatIcon")
                }
            } else {
                if vesselImages.count == 1 {
                    vesselImages[0]
                        .frame(height: Dimensions.imageSize)
                        .clipped()
                } else {
                    PageView(views: vesselImages)
                }
            }
        }
            .frame(height: Dimensions.imageSize)
            .compositingGroup()
    }

    private func view(for photo: PhotoViewModel) -> AnyView {
        AnyView(
            PhotoVesselView(photo: photo)
        )
    }

    /// Actions

    private func onAppear() {
        let permitNumber = report.vessel.permitNumber
        let photoIds = photoQueryManager.lastVesselImagesId(permitNumber: permitNumber)
        let limit = 10
        let limitedPhotoIds = Array(photoIds.prefix(limit))

        let photos = photoQueryManager.photoViewModels(imagesId: limitedPhotoIds)

        let views: [AnyView] = photos.map { photo in
            view(for: photo)
        }

        vesselImages = views
    }
}

struct VesselRecordHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VesselRecordHeaderView(report: .sample,
                               onDuty: .sample,
                               boardings: 5,
                               warnings: 0,
                               citations: 2)
    }
}
