/*
NodePlatform.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/


import SpriteKit
protocol NodePlatformDelegate: class {
    func gameplayEnded(with result: Bool)
}

final class NodePlatform: SKSpriteNode {

    // Constants and variables
    private let scale: CGFloat
    private lazy var distance: CGFloat = 0
    private let parameters: Parameters
    private let gameplay: Gameplay
    private var icons: IconsSet
    private var sortedBlocks: [[NodeBlock]] = []
    private var blocks: [NodeBlock] {
        return sortedBlocks.flatMap { $0 }
    }

    // Delegates
    weak var delegate: NodePlatformDelegate?

    // Initializers
    init(parameters: Parameters, size: CGSize, icons: IconsSet, scale: CGFloat) {
        self.scale = scale
        self.parameters = parameters
        self.gameplay = Gameplay(parameters: parameters)
        self.icons = icons
        super.init(texture: nil, color: .clear, size: size)
        isUserInteractionEnabled = true
        gameplay.delegate = self
        gameplay.beforeGame()
        setupPlatform()
        changeBlockMode(to: .initial)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Gameplat logic
    func beforeGame(with icons: IconsSet) {
        gameplay.beforeGame()
        blocks.forEach {
            $0.update(with: gameplay.block(for: $0.placement), icons: icons)
        }
        changeBlockMode(to: .initial)
    }

    func displayEnemies() {
        changeBlockMode(to: .prepare)
    }

    func turnOnPlayMode() {
        changeBlockMode(to: .play)
    }

    private func changeBlockMode(to phase: GamePhase) {
        blocks.forEach { $0.updatePhase(phase) }
    }

    // Event handlers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let placement = touch.location(in: self)
        guard let block = atPoint(placement) as? Localizable else { return }
        gameplay.selectingBegan(in: block.placement)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let placement = touch.location(in: self)
        guard let block = atPoint(placement) as? Localizable else { return }
        gameplay.selectionContinue(to: block.placement)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameplay.selected()
    }

    // Platform setup
    private func setupPlatform() {
        let platform = parameters.platform
        for horizontal in 0 ..< platform.horizontals {
            var horizontalBlock: [NodeBlock] = []
            for vertical in 0 ..< platform.verticals {
                let size = sizeForNode()
                let placement =  Placement(horizontal: horizontal, vertical: vertical)
                let block = gameplay.block(for: placement)
                let node = NodeBlock(block: block, placement: placement, size: size, icons: icons, scale: scale)
                node.position = position(for: placement, size: size)
                addChild(node)
                horizontalBlock.append(node)
            }
            sortedBlocks.append(horizontalBlock)
        }
    }

    private func sizeForNode() -> CGSize {
        let platform = parameters.platform
        let width = (size.height - distance * CGFloat(platform.horizontals + 1)) / CGFloat(platform.horizontals)
        return CGSize(width: width, height: width)
    }

    private func position(for placement: Placement, size: CGSize) -> CGPoint {
        let x = frame.minX + CGFloat(placement.horizontal) * (size.width + distance) + distance + size.width * 0.5
        let y = frame.minY + CGFloat(placement.vertical) * (size.height + distance) + distance + size.height * 0.5
        return CGPoint(x: x, y: y)
    }
}

extension NodePlatform: GameDelegate {
    func gameplayEnded(with result: Bool) {
        blocks.forEach { $0.updatePhase(.ending) }
        delegate?.gameplayEnded(with: result)
    }

    func changeSelectedBlockStatus(at position: Placement, to value: Bool) {
        sortedBlocks[position.horizontal][position.vertical].holded = value
    }
}
