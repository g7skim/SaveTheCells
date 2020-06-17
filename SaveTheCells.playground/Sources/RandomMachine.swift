/*
RandomMachine.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import GameplayKit
final class RandomMachine {

    func prepareGame(for platform: Platform, numberOfEnemies: Int) -> [[Block]] {
        var gkgraph: GKGridGraph<GKGridGraphNode>
        var readyBlocks:[[Block]] = []
        while true {
            let blocks = createBlocks(for: platform)
            gkgraph = GKGridGraph(nodes: blocks.flatMap{ $0 }.map { $0.node })
            if let randomizeBlocks = RandomMachine().randomize(blocks: blocks.flatMap{ $0 }, numberOfEnemies: numberOfEnemies, gkgraph: gkgraph) {
                readyBlocks = randomizeBlocks
                break
            }
        }
        return readyBlocks
    }

    func createBlocks(for platform: Platform) -> [[Block]] {
        var blocks: [[Block]] = []
        for i in 0 ..< platform.horizontals {
            var blockHorizontal: [Block] = []
            for j in 0 ..< platform.verticals {
                let position = Placement(horizontal: i, vertical: j)
                let node = GKGraphNode()
                if i != 0 {
                    let top = blocks[i - 1][j].node
                    node.addConnections(to: [top], bidirectional: true)
                }
                if j != 0 {
                    let left = blockHorizontal[j - 1].node
                    node.addConnections(to: [left], bidirectional: true)
                }
                let block = Block(position: position, node: node)
                blockHorizontal.append(block)
            }
            blocks.append(blockHorizontal)
        }
        return blocks
    }

    func randomize(blocks: [Block], numberOfEnemies: Int, gkgraph: GKGridGraph<GKGridGraphNode>) -> [[Block]]? {
        var mutableBlocks = blocks
        let mutableGraph = gkgraph
        var finalBlocks: [Block] = []
        for _ in 0 ..< numberOfEnemies {
            let block = mutableBlocks.randomFalling()
            block.type = .enemy
            mutableGraph.remove([block.node])
            finalBlocks.append(block)
        }

        var complete: Bool = false

        while !complete {
            let beginning = mutableBlocks.randomFalling()
            let ending = mutableBlocks.randomFalling()
            let path = mutableGraph.findPath(from: beginning.node, to: ending.node)
            if path.isEmpty {
                complete = true
                return nil
            } else if path.count < 6 || path.count > 12 {
                mutableBlocks.append(beginning)
                mutableBlocks.append(ending)
                continue
            } else {
                beginning.type = .beginning
                ending.type = .ending
                finalBlocks.append(contentsOf: [beginning, ending])
                complete = true
            }
        }

        finalBlocks.append(contentsOf: mutableBlocks)
        return finalBlocks.sortBlocks()
    }
}
