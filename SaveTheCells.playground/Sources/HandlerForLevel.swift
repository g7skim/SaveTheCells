/*
HandlerForLevel.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
protocol DelegateHandlerForLevel: class {
    func didSelectLevel(_ level: DifficultyLevels)
}

final class HandlerForLevel: SKSpriteNode {

    private let scale: CGFloat
    weak var delegate: DelegateHandlerForLevel?

    init(levels: [DifficultyLevels], scale: CGFloat, size: CGSize) {
        self.scale = scale
        let texture = SKTexture(imageNamed: "Results")
        super.init(texture: texture, color: .clear, size: size)
        setupButtons(levels: levels)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButtons(levels: [DifficultyLevels]) {
        let gap: CGFloat = 10
        let itemHeight = (size.height - gap * CGFloat(levels.count + 1)) / CGFloat(levels.count)

        for (index, level) in levels.enumerated() {
            let width = size.width - 30 * scale
            let itemSize = CGSize(width: width, height: itemHeight)
            let texture = SKTexture(imageNamed: "Badge")
            let menuItem = NodeButton(size: itemSize, texture: texture)
            menuItem.level = level
            menuItem.setTarget(self, action: #selector(buttonTapped))
            let y = frame.minY + CGFloat(index) * (itemSize.height + gap) + gap + itemSize.height * 0.5
            menuItem.position = CGPoint(x: frame.midX, y: y)
            menuItem.setTitle(level.rawValue)
            menuItem.setFontSize(15 * scale)
            addChild(menuItem)
        }
    }

    @objc
    private func buttonTapped(_ menuItem: NodeButton) {
        delegate?.didSelectLevel(menuItem.level)
    }

}
