//
//  VesselItemView.swift
//
//  Created on 3/23/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct VesselItemView: View {

    var report: ReportViewModel

    @State private var vesselImage: PhotoViewModel?
    private let photoQueryManager = PhotoQueryManager.shared

    private struct Dimensions {
        static let leadingSpacing: CGFloat = 4.0
        static let imageCornerRadius: CGFloat = 6
        static let imageSize: CGFloat = 64.0
        static let padding: CGFloat = 16.0
        static let heightDivider: CGFloat = 1.0
    }

    var body: some View {

        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: .zero) {
                topView()
                    .cornerRadius(Dimensions.imageCornerRadius)
                    .padding(.trailing, Dimensions.padding)

                VStack(spacing: .zero) {
                    HStack {
                        Text(report.vessel.name)
                            .foregroundColor(.text)
                            .font(.body)
                        Spacer()
                        StatusSymbolView(risk: report.inspection.summary.safetyLevel.level)
                    }
                    VStack(spacing: Dimensions.leadingSpacing) {
                        CaptionLabel(title: NSLocalizedString("Permit #", comment: "") + report.vessel.permitNumber, color: .gray)
                        CaptionLabel(title: NSLocalizedString("Last Boarding", comment: "") + " " + (report.date as Date).justLongDate(),
                                     color: .gray)
                        CaptionLabel(title: "\(report.crew.count + 1)" + " " +  NSLocalizedString("Crew Members", comment: ""),
                                     color: .gray)
                    }
                        .font(.subheadline)
                }
            }
                .padding(.bottom, Dimensions.padding)
            Divider()
                .frame(height: Dimensions.heightDivider)
        }
            .padding([.horizontal, .top], Dimensions.padding)
            .onAppear(perform: onAppear)
    }

    func topView() -> AnyView {
        if let image = vesselImage {
            return imageView(for: image)
        } else {
            return AnyView(VesselIconView(imageSize: Dimensions.imageSize))
        }
    }

    private func imageView(for photo: PhotoViewModel, imageSize: CGFloat = Dimensions.imageSize) -> AnyView {
        AnyView(
            Group {
                if photo.thumbNail != nil || photo.picture != nil {
                    Image(uiImage: photo.thumbNail ?? photo.picture ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                } else if photo.pictureURL != "" {
                    RemoteImageView(
                        imageURL: photo.pictureURL,
                        height: imageSize,
                        width: imageSize)
                }
            }
        )
    }

    /// Actions

    private func onAppear() {
        let permitNumber = self.report.vessel.permitNumber
        let photoIds = self.photoQueryManager.lastVesselImagesId(permitNumber: permitNumber)
        let limit = 1
        let limitedPhotoIds = Array(photoIds.prefix(limit))

        let photos = self.photoQueryManager.photoViewModels(imagesId: limitedPhotoIds)

        self.vesselImage = photos.first
    }

}

struct VesselItemView_Previews: PreviewProvider {
    static var previews: some View {
        VesselItemView(report: .sample)
    }
}
