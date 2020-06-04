//
//  NoteFieldView.swift
//
//  Created on 5/21/20.
//

import SwiftUI

struct NoteFieldView: View {
    @Binding var note: Note
    var isEditable = true
    var delete: ((String) -> Void)?

    private enum Dimensions {
        static let noSpacing: CGFloat = 0.0
        static let spacing: CGFloat = 43.0
        static let fontSize: CGFloat = 20.0
        static let topPadding: CGFloat = 14.0
        static let height: CGFloat = 70.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {

            if isEditable {
                CaptionLabel(title: "Note")
                HStack(alignment: .top, spacing: Dimensions.spacing) {
                    MultilineTextView(text: $note.text)
                    Button(action: deleteAction) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: Dimensions.fontSize))
                            .foregroundColor(Color.red)
                    }
                        .padding(.top, Dimensions.topPadding)
                }
                    .frame(height: Dimensions.height)
            } else {
                if !note.isEmpty {
                    CaptionLabel(title: "Note")
                    HStack(spacing: Dimensions.spacing) {
                        Text(note.text)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                }
            }

            Divider()
                .opacity(isEditable ? 1 : 0)
                .padding(.top, isEditable ? Dimensions.padding : Dimensions.noSpacing )
        }
    }

    private func deleteAction() {
        delete?(note.id)
    }
}

struct NoteFieldView_Previews: PreviewProvider {
    static var previews: some View {
        let note  = Note(id: "123",
                         text: """
                                This is
                                multiline
                                note
                               """)

        return VStack {
            NoteFieldView(note: .constant(note),
                          isEditable: true)
            Spacer()
            NoteFieldView(note: .constant(note),
                          isEditable: false)

        }
    }
}
