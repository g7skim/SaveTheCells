/*
Gameplay.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import Foundation
protocol GameDelegate: class {
    func changeSelectedBlockStatus(at position: Placement, to value: Bool)
    func gameplayEnded(with result: Bool)
}

final class Gameplay {

    
    // Delegate
    weak var delegate: GameDelegate?

    // Private variables
    private var sortedBlocks: [[Block]] = []
    private var allBlocks: [Block] {
        return sortedBlocks.flatMap{ $0 }
    }
    private var selectedBlocks: [Block] = []
    private var currentPlacement: Placement?

    private let parameters: Parameters

    init(parameters: Parameters) {
        self.parameters = parameters
    }

    // Public
    func beforeGame() {
        selectedBlocks = []
        currentPlacement = nil
        sortedBlocks = RandomMachine().prepareGame(for: parameters.platform,
                                                   numberOfEnemies: parameters.numberOfEnemies)
    }

    func block(for position: Placement) -> Block {
        return sortedBlocks[position.horizontal][position.vertical]
    }

    func selectingBegan(in position: Placement) {
        let thisBlock = sortedBlocks[position.horizontal][position.vertical]
        guard thisBlock.type == .beginning else { return }
        currentPlacement = position
        thisBlock.holded = true
        selectedBlocks.append(thisBlock)
        delegate?.changeSelectedBlockStatus(at: position, to: true)
    }

    func selectionContinue(to placement: Placement) {
        let thisBlock = sortedBlocks[placement.horizontal][placement.vertical]
        guard let _currentPlacement = currentPlacement,
            _currentPlacement != placement,
            placement.canBeAchived(from: _currentPlacement) else {
                return
        }

        if thisBlock.holded {
            handleBackwardMove(at: placement)
        } else {
            let thisBlock = sortedBlocks[_currentPlacement.horizontal][_currentPlacement.vertical]
            guard thisBlock.type != .ending else { return }
            handleForwardMove(at: placement)
        }
    }

    func selected() {
        guard let finalPosition = currentPlacement else { return }
        let finalBlock = sortedBlocks[finalPosition.horizontal][finalPosition.vertical]
        if finalBlock.type == .ending {
            getResult()
        } else {
            for block in allBlocks {
                block.holded = false
                delegate?.changeSelectedBlockStatus(at: block.placement, to: false)
            }
            selectedBlocks = []
        }
    }

    // Checking result
    private func getResult() {
        let enemies = selectedBlocks.filter { $0.holded && $0.type == .enemy }
        let gameResult = enemies.isEmpty
        delegate?.gameplayEnded(with: gameResult)
    }

    // Handling move
    private func handleBackwardMove(at position: Placement) {
        selectedBlocks.removeLast()
        delegate?.changeSelectedBlockStatus(at: currentPlacement!, to: false)
        sortedBlocks[currentPlacement!.horizontal][currentPlacement!.vertical].holded = false
        currentPlacement = position
    }

    private func handleForwardMove(at position: Placement) {
        let thisBlock = sortedBlocks[position.horizontal][position.vertical]
        thisBlock.holded = true
        currentPlacement = position
        selectedBlocks.append(thisBlock)
        delegate?.changeSelectedBlockStatus(at: position, to: true)
    }
}
