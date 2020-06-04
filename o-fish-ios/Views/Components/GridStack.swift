//
//  GridStack.swift
//
//  Created on 24/04/2020.
//  Copyright © 2020 WildAid. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {
    private let rows: Int
    private let columns: Int
    private let content: (Int, Int) -> Content

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: 6, columns: 4) { row, col in
            Text("R\(row) C\(col)")
        }
    }
}
