//
//  Collection+EnumeratedArray.swift
//
//  Created on 09/04/2020.
//

extension Collection {
    func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
        Array(self.enumerated())
    }
}
