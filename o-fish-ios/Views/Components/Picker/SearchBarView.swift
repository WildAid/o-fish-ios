//
//  SearchBarView.swift
//
//  Created on 3/3/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var searchText: String
    var placeholder: String
    @State private var errorText = ""
    @State private var showingAlert = false
    var onCommit: () -> Void = {}
    var clickedDelete: () -> Void = {}
    var onEditingChanged: (Bool) -> Void = { _ in }

    private enum Dimension {
        static let inset: CGFloat = 7.0
        static let bottomInset: CGFloat = 4.0
        static let heightTextField: CGFloat = 36.0
        static let cornerRadius: CGFloat = 10.0
        static let padding: CGFloat = 16.0
        static let topPadding: CGFloat = 15.0
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                GlassIconView()

                TextField(LocalizedStringKey(placeholder),
                    text: $searchText,
                    onEditingChanged: onEditingChanged,
                    onCommit: onCommit)
                    .font(.body)

                if searchText.isEmpty {
                    Button(action: {
                        //TODO: use microphone to input search string
                        print("Microphone button tapped")
                    }) {
                        Image(systemName: "mic.fill")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text("\(errorText)"), dismissButton: .default(Text("Ok")))
                    }
                } else {
                    Button(action: {
                        self.searchText = ""
                        self.clickedDelete()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
                .padding(EdgeInsets(top: Dimension.inset, leading: Dimension.bottomInset, bottom: Dimension.inset, trailing: Dimension.inset))
                .frame(height: Dimension.heightTextField)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(Dimension.cornerRadius)
                .padding([.horizontal, .top], Dimension.padding)
            Divider()
                .padding(.top, Dimension.topPadding)
                .frame(height: 1.0)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""), placeholder: "Search")
    }
}
