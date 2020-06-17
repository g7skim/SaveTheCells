/*
SceneMenu.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
import GameplayKit
public final class SceneMenu: SKScene {

    public enum GameMode {
        case initial
        case final
    }

    // Views
    var menuItem: NodeButton!

    // Constants and variables
    private let fallingDuration: TimeInterval = 2
    private var timer: Timer!
    private var AreaToFill: CGFloat = 0
    private var currentPosition: CGPoint = .zero
    private let mode: GameMode
    private lazy var scale = size.height / 500

    public init(mode: GameMode, size: CGSize) {
        self.mode = mode
        super.init(size: size)
        if mode == .initial {
            setupButton()
            setupTimer()
            let texture = SKTexture(imageNamed: "SickPink")
            setupCell(with: texture)

        } else {
            fillScreenWithViruses()
            let texture = SKTexture(imageNamed: "HealthyPink")
            setupCell(with: texture)
            setupRestart()
        }
        setupWorld()
        setupLogo()
        setupBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Scene's life cycle
    override public func didMove(to view: SKView) {
        if mode == .final {
            let music = SKAction.playSoundFileNamed("Boo.mp3", waitForCompletion: true)
            let loopSound:SKAction = SKAction.repeatForever(music)
            run(loopSound)
            physicsBody = nil
        } else {
            let music = SKAction.playSoundFileNamed("Boo.mp3", waitForCompletion: true)
            let loopSound:SKAction = SKAction.repeatForever(music)
            run(loopSound)
        }
    }

    // Logic
    private func incrementFilledSize(with size: CGSize) {
        let area = size.width * size.height
        AreaToFill += area
    }

    private func isFilled() -> Bool {
        let areaOfCreen = size.height * size.width
        return (AreaToFill / areaOfCreen) > 1
    }

    // Event handlers
    @objc
    private func gameStarted() {
        timer.invalidate()

        removeChildren(in: [menuItem])
        setupLevelBlock()
    }

    @objc
    private func fallingViruses() {
        guard !isFilled() else {
            timer.invalidate()
            return
        }

        let virus = createVirus()
        incrementFilledSize(with: virus.size)
        addChild(virus)
    }

    @objc
    private func gameReStarted() {
        setupLevelBlock()
    }

    // Setup
    private func setupCell(with texture: SKTexture) {
        let size = CGSize(width: 250 * scale, height: 250 * scale)
        let cell = SKSpriteNode(texture: texture, color: .clear, size: size)
        cell.position = CGPoint(x: frame.midX, y: frame.midY)
        cell.zPosition = 0
        addChild(cell)
    }

    private func setupRestart() {
        let size = CGSize(width: 260 * scale, height: 60 * scale)
        let texture = SKTexture(imageNamed: "Badge")
        menuItem = NodeButton(size: size, texture: texture)
        menuItem.position = CGPoint(x: frame.midX, y: frame.minY + 70 * scale)
        menuItem.zPosition = 0
        menuItem.setTarget(self, action: #selector(gameReStarted))
        menuItem.setTitle("Save other cells")
        menuItem.setFontSize(28 * scale)
        addChild(menuItem)
    }


    private func fillScreenWithViruses() {
        currentPosition = CGPoint(x: frame.minX, y: frame.minY)
        while true {
            let virus = createVirus()
            virus.position = currentPosition
            incrementFilledSize(with: virus.size)
            var newX = currentPosition.x + virus.size.width
            var newY = currentPosition.y
            if newX > frame.maxX {
                newX = 0
                newY += virus.size.height
                if newY > frame.maxY {
                    break
                }
            }
            currentPosition = CGPoint(x: newX, y: newY)
            addChild(virus)
        }
    }

    private func setupLevelBlock() {
        let menuBackground = SKSpriteNode(color: UIColor.black, size: self.size)
        menuBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(menuBackground)
        let size = CGSize(width: 320 * scale, height: 250 * scale)
        let handlerForLevel = HandlerForLevel(levels: [.insane, .hard, .medium, .easy], scale: scale, size: size)
        handlerForLevel.delegate = self
        handlerForLevel.zPosition = 1
        handlerForLevel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(handlerForLevel)
    }

    private func setupLogo() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        label.text = "#stayhome"
        label.fontSize = 50 * scale
        label.zPosition = 1
        label.position = CGPoint(x: frame.midX, y: frame.maxY - 80 * scale)
        addChild(label)
    }

    private func setupWorld() {
        view?.showsFPS = false
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = true
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    }

    private func setupButton() {
        let size = CGSize(width: 300 * scale, height: 70 * scale)
        let texture = SKTexture(imageNamed: "Badge")
        menuItem = NodeButton(size: size, texture: texture)
        menuItem.position = CGPoint(x: frame.midX, y: frame.minY + 80 * scale)
        menuItem.zPosition = 0
        menuItem.setTarget(self, action: #selector(gameStarted))
        menuItem.setTitle("Save the cells!")
        menuItem.setFontSize(28 * scale)
        addChild(menuItem)
    }

    private func setupBackground() {
        let size = CGSize(width: 500 * scale, height: 500)
        let texture = SKTexture(imageNamed: "Background")
        menuItem = NodeButton(size: size, texture: texture)
        menuItem.position = CGPoint(x: frame.midX, y: frame.midY)
        menuItem.zPosition = -3
        addChild(menuItem)
    }

    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: fallingDuration,
                                     target: self,
                                     selector: #selector(fallingViruses),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func createVirus() -> SKSpriteNode {
        let images = ["Virus1", "Virus2", "Virus3", "Virus4"]
        let random = images.randomElement()!
        let virus = SKSpriteNode(imageNamed: random)
        let size = CGSize(width: 10 * scale, height: 80 * scale)
        virus.size = size
        virus.zRotation = CGFloat.random(in: 0 ... 360)
        virus.zPosition = CGFloat.random(in: -1 ... 1)
        virus.aspectFillToSize(fillSize: size)
        let xPosition = GKRandomDistribution(lowestValue: Int(frame.minX),
                                             highestValue: Int(frame.maxX))
        virus.position = CGPoint(x: CGFloat(xPosition.nextInt()),
                                 y: frame.maxY - 1)
        virus.physicsBody = SKPhysicsBody(rectangleOf: virus.size)
        virus.physicsBody?.mass = 0.04
        return virus
    }
}

extension SceneMenu: DelegateHandlerForLevel {
    func didSelectLevel(_ level: DifficultyLevels) {
        let sceneGame = SceneGame(parameters: level.parameters(), size: size)
        scene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(sceneGame, transition: transition)
    }
}
