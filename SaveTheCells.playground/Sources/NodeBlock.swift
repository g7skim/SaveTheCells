/*
NodeBlock.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
protocol Localizable: class {
    var placement: Placement! { get set }
}

final class NodeBlock: SKSpriteNode, Localizable {

    // MViews
    private var assetNode: NodeLocalized!
    private var selectedNode: NodeLocalized!

    // Constants
    private let animationDuration: Double = 0.5
    private let scale: CGFloat

    // Variable
    var placement: Placement!
    var block: Block!
    var icons: IconsSet

    var holded: Bool = false {
        didSet {
            updateSelectedState()
        }
    }

    // Initalizers
    init(block: Block, placement: Placement, size: CGSize, icons: IconsSet, scale: CGFloat) {
        self.scale = scale
        self.placement = placement
        self.block = block
        self.icons = icons
        super.init(texture: nil, color: .clear, size: size)
        texture = SKTexture(imageNamed: "PinkBlock")
        setupSelectedNode()
        setupAsset()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Public
    func update(with block: Block, icons: IconsSet) {
        self.block = block
        self.icons = icons
    }


    func updatePhase(_ phase: GamePhase) {
        switch phase {
        case .initial:
            setupForInitialMode()
        case .prepare:
            setupForPrepareMode()
        case .play:
            setupForPlayMode()
        case .ending:
            setupForEndMode()
        }
    }

    // Logic
    private func updateSelectedState() {
        if holded {
            let music = SKAction.playSoundFileNamed("Step2.mp3", waitForCompletion: true)
            run(music)
            let texture = SKTexture(imageNamed: "GreenBlockP")
            showSelectedNode(duration: 0, texture: texture)
        } else {
            let music = SKAction.playSoundFileNamed("StepReleased.mp3", waitForCompletion: true)
            run(music)
            hideSelectedNode(duration: 0)
        }
    }

    // Animations
    private func hideAsset(with duration: Double, completion: (() -> Void)? = nil) {
        let faderOut = SKAction.fadeOut(withDuration: duration)
        let scale = SKAction.scale(to: size, duration: 0)
        let actions = SKAction.sequence([faderOut, scale])
        assetNode.run(actions, completion: {
            completion?()
        })
    }

    private func showAsset(with duration: Double, with texture: SKTexture) {
        let showTexture = SKAction.setTexture(texture, resize: true)
        let scale = assetNode.scaleToFit(size: size, texture: texture)
        let rescale = SKAction.scale(to: scale, duration: 0)
        let faderIn = SKAction.fadeIn(withDuration: duration)
        let actions = SKAction.sequence([showTexture, rescale, faderIn])
        assetNode.run(actions)
    }

    private func showSelectedNode(duration: Double, texture: SKTexture) {
        let showTexture = SKAction.setTexture(texture)
        let faderIn = SKAction.fadeIn(withDuration: duration)
        let actions = SKAction.sequence([showTexture, faderIn])
        selectedNode.run(actions)
    }

    private func hideSelectedNode(duration: Double) {
        let faderOut = SKAction.fadeOut(withDuration: duration)
        selectedNode.run(faderOut)
    }

    // Setup
    private func setupSelectedNode() {
        selectedNode = NodeLocalized(color: .clear, size: size)
        selectedNode.placement = placement
        selectedNode.position = .zero
        addChild(selectedNode)
    }

    private func setupAsset() {
        assetNode = NodeLocalized(color: .clear, size: size)
        assetNode.placement = placement
        assetNode.position = .zero
        assetNode.isUserInteractionEnabled = false
        addChild(assetNode)
        hideAsset(with: 0)
    }

    private func setupForInitialMode() {
        hideAsset(with: animationDuration)
        hideSelectedNode(duration: animationDuration)
    }

    private func setupForPrepareMode() {
        switch block.type {
        case .standard:
            return
        case .beginning, .ending, .fail:
            hideAsset(with: animationDuration)
        case .enemy:
            let images = ["Virus1", "Virus2", "Virus3", "Virus4"]
            let random = images.randomElement()!
            let texture = SKTexture(imageNamed: random)
            showAsset(with: animationDuration, with: texture)
        }
    }

    private func setupForPlayMode() {
        switch block.type {
        case .standard:
            return
        case .beginning, .ending, .fail:
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                if let imageString = self.imageAsset(for: self.block.type) {
                    let texture = SKTexture(imageNamed: imageString)
                    self.showAsset(with: self.animationDuration, with: texture)
                }
            }
        case .enemy:
            hideAsset(with: animationDuration)
        }
    }

    private func setupForEndMode() {
        guard block.type != .standard else { return }
        if let imageString = imageAsset(for: block.type) {
            showAsset(with: animationDuration, with: SKTexture(imageNamed: imageString))
        }
        if block.type == .enemy && holded {
            selectedNode.texture = SKTexture(imageNamed: "RedBlock")
        }
    }

    private func imageAsset(for type: BlockType) -> String? {
        var imageAsset: String
        let virus = ["Virus1", "Virus2", "Virus3", "Virus4"]
        switch block.type {
        case .standard:
            return nil
        case .beginning:
            imageAsset = icons.cell
        case .ending:
            imageAsset = icons.house
        case .fail:
            imageAsset = icons.house
        case .enemy:
            imageAsset = virus.randomElement()!
        }
        return imageAsset
    }
}
