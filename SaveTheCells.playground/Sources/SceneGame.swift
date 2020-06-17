/*
SceneGame.swift
SaveTheCells
Created by Evgenii Truuts on May 9,2020 for WWDC20 Swift Student Challenge.
Copyright © 2020 Evgenii Truuts. All rights reserved.
*/

import SpriteKit
import GameplayKit
final class SceneGame: SKScene {

    // Views
    private var nodePlatform: NodePlatform!
    private var nodeSummary: NodeSummary!
    private var sceneMenu: SceneMenu!
    private var menuBackground: SKSpriteNode!
    private let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var timer: Timer?
    private var types: [PlayMode] = [.CellPink, .CellBlue, .CellYellow, .CellPinkH, .CellBlueH, .CellYellowH].shuffled()
    private var counter: Int = 0
    private var roundCounter: Int = 0
    private var correct: Int = 0
    private var grade: Int = 0
    private let parameters: Parameters

    // Variables
    private lazy var scale = size.height / 500

    // Initializers
    init(parameters: Parameters, size: CGSize) {
        self.parameters = parameters
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Scene life cycle
    override func didMove(to view: SKView) {
        setupPlatform()
        setupLabel()
        roundCounter += 1
        animateLabel { [unowned self] in
            self.turnOnCountDown()
            self.nodePlatform?.displayEnemies()
        }
    }

    // Logic
    private func prepareNextRound() {
        roundCounter += 1
        let index = roundCounter % types.count
        nodePlatform.beforeGame(with: types[index].icons())
    }

    private func turnOnCountDown() {
        counter = parameters.prepareTime
        self.label.text = String(self.counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc
    private func updateCounter() {
        if counter == 1 {
            timer?.invalidate()
            animateLabel(soundString: "Start.mp3")
            nodePlatform.turnOnPlayMode()
        } else {
            animateLabel(soundString: "Round.mp3") {
                self.counter -= 1
                self.label.text = String(self.counter)
            }
        }
    }

    private func animateLabel(hangeTime: Double = 0.6, soundString: String? = nil, completion: (() -> Void)? = nil) {
        let duration = 0.2
        var actionsArray: [SKAction] = []
        let show = showAction(with: duration)
        actionsArray.append(show)
        if let soundString = soundString {
            let music = SKAction.playSoundFileNamed(soundString, waitForCompletion: false)
            actionsArray.append(music)
        }
        let skWait = SKAction.wait(forDuration: hangeTime)
        actionsArray.append(skWait)
        let hide = hideAction(with: duration)
        actionsArray.append(hide)
        let actions = SKAction.sequence(actionsArray)
        label.run(actions) {
            completion?()
        }
    }

    private func showAction(with duration: Double) -> SKAction {
        let scale = SKAction.scale(to: 1.3, duration: duration)
        let faderIn = SKAction.fadeIn(withDuration: duration)
        let actions = [scale, faderIn]
        let group = SKAction.group(actions)
        return group
    }

    private func hideAction(with duration: Double) -> SKAction {
        let scale = SKAction.scale(to: 0.5, duration: duration)
        let faderOut = SKAction.fadeOut(withDuration: duration)
        let actions = [scale, faderOut]
        let group = SKAction.group(actions)
        return group
    }

    private func displaySummary() {
        let size = CGSize(width: 360 * scale, height: 280 * scale)
        nodeSummary = NodeSummary(size: size,
                                  scale: scale,
                                  grade: grade,
                                  correct: correct,
                                  cellsInRound: parameters.cellsInRound)
        nodeSummary.delegate = self
        nodeSummary.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(nodeSummary)
    }

    private func handleRoundChange() {
        if roundCounter == parameters.cellsInRound {
            menuBackground = SKSpriteNode(color: UIColor.black, size: size)
            menuBackground.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(menuBackground)
            sceneMenu = SceneMenu(mode: .final, size: size)
            sceneMenu.scaleMode = .aspectFill
            displaySummary()
        } else {
            prepareNextRound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nodePlatform.displayEnemies()
                self.turnOnCountDown()
            }
        }
    }

    private func displayFinalScene() {
        let transition = SKTransition.fade(withDuration: 1)
        view?.presentScene(sceneMenu, transition: transition)
    }

    // Setup
    private func setupPlatform() {
        let size = CGSize(width: frame.width, height: frame.width)
        nodePlatform = NodePlatform(parameters: parameters,
                              size: size,
                              icons: types[0].icons(),
                              scale: scale)
        nodePlatform.delegate = self
        nodePlatform.position = CGPoint(x: frame.midX, y: frame.midX)
        addChild(nodePlatform)
    }
    
    private func setupLabel() {
        addChild(label)
        label.text = "GET READY"
        animateLabel(soundString: "Round.mp3")
        label.fontSize = 65 * scale
        label.position = CGPoint(x: frame.midX, y: frame.midY - 30)
        label.fontColor = .white
        label.setScale(1)
        label.run(SKAction.fadeOut(withDuration: 0))
    }
}

extension SceneGame: NodePlatformDelegate {
    func gameplayEnded(with result: Bool) {
        correct = result ? correct + 1 : correct
        let multiplayer = parameters.platform.horizontals * parameters.platform.verticals * parameters.numberOfEnemies
        grade = result ? grade + multiplayer : grade
        label.text = result ? "PASSED" : "FAILED"
        let music = result ? "Click.mp3" : "Fail.mp3"
        animateLabel(hangeTime: 2.6, soundString: music) {
            self.handleRoundChange()
        }
    }
}

extension SceneGame: NodeSummaryDelegate {
    func afterGame() {
        displayFinalScene()
    }
}
