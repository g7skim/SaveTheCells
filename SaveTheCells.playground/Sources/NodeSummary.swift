/*
NodeSummary.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
protocol NodeSummaryDelegate: class {
    func afterGame()
}

final class NodeSummary: SKSpriteNode {

    weak var delegate: NodeSummaryDelegate?
    var font = "AvenirNext-Heavy"
    private let scale: CGFloat

    init(size: CGSize, scale: CGFloat, grade: Int, correct: Int, cellsInRound: Int) {
        self.scale = scale
        let texture = SKTexture(imageNamed: "Results")
        super.init(texture: texture, color: .clear, size: size)
        setupCorrect(with: correct, cellsInRound: cellsInRound, grade: grade)
        setupDoneButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Event handlers
    @objc
    private func doneTapped() {
        delegate?.afterGame()
    }

    // Setup
    private func setupCorrect(with correct: Int, cellsInRound: Int, grade: Int) {
        let label = SKLabelNode(fontNamed: font)
        let music = SKAction.playSoundFileNamed("WWDC.mp3", waitForCompletion: true)
        let loopSound:SKAction = SKAction.repeatForever(music)
        run(loopSound)
        physicsBody = nil
        label.numberOfLines = 0
        label.fontSize = 22 * scale
        label.text = "Hi, WWDC20 \n \n You have saved \(correct) of \(cellsInRound) cells \n and got \(grade) points \n \n Stay home and save lives"
        label.position = CGPoint(x: frame.midX, y: frame.midY - 65 * scale)
        addChild(label)
    }

    private func setupDoneButton() {
        let size = CGSize(width: 160 * scale, height: 40 * scale)
        let texture = SKTexture(imageNamed: "Badge")
        let menuItem = NodeButton(size: size, texture: texture)
        menuItem.setTitle("Continue")
        menuItem.setFontSize(22 * scale)
        menuItem.position = CGPoint(x: frame.midX, y: frame.minY + 35 * scale)
        menuItem.setTarget(self, action: #selector(doneTapped))
        addChild(menuItem)
    }
}
