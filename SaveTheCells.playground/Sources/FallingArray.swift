/*
FallingArray.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import Foundation
extension Array {
    mutating func randomFalling() -> Element {
        let index = Int.random(in: 0 ..< count)
        let virus = remove(at: index)
        return virus
    }
}

extension Array where Element == Block {
    func sortBlocks() -> [[Block]] {
        guard let limitMaximum = self.max(by: { $1.placement > $0.placement })?.placement else {
            return []
        }
        var sortedBlocks: [[Block]] = []
        for horizontal in 0 ... limitMaximum.horizontal {
            var horizontalBlock: [Block] = []
            for vertical in 0 ... limitMaximum.vertical {
                let position = Placement(horizontal: horizontal, vertical: vertical)
                let block = first(where: { $0.placement == position })!
                horizontalBlock.append(block)
            }
            sortedBlocks.append(horizontalBlock)
        }

        return sortedBlocks
    }
}
