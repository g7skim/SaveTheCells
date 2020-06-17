/*
Block.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import GameplayKit
final class Block {
    let node: GKGraphNode
    let placement: Placement
    var type: BlockType
    var holded: Bool
    

    init(position: Placement, node: GKGraphNode) {
        self.placement = position
        self.holded = false
        self.type = .standard
        self.node = node
    }
}

enum BlockType {
    case beginning
    case standard
    case fail
    case enemy
    case ending
}
