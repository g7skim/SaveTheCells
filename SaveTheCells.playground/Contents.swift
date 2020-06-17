import UIKit
import SpriteKit
import PlaygroundSupport

/*
 Save the Cells the puzzle game
 In this game, you will help the cells find a way home.
 Avoid green viruses since they can beat you.
 Just touch the cell and drag it into a house icon.
 Try different difficulty levels.
 And remember, stay home - save cells.

 I made all graphic for this game using the free Figma Tool.
 Sounds were made by using Apple Logic Pro X from the student software pack.
 */

let view = SKView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
let scene = SceneMenu(mode: .initial, size: CGSize(width: 500, height: 500))
scene.scaleMode = .aspectFill
view.presentScene(scene)
PlaygroundPage.current.liveView = view

