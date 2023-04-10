//
//  startMenu.swift
//  spacegame
//
//  Created by Kanishk Dendukuri on 1/25/23.
//

import UIKit
import SpriteKit
import GameplayKit
class startMenu: SKScene {
    var starfield:SKEmitterNode!
    
    var startLabel = SKLabelNode(text: "Start Game")
    
    var scoreLabel:SKLabelNode!
    
    let defaults = UserDefaults()
    lazy var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
    
    
    override func didMove(to view: SKView){
        starfield = self.childNode(withName: "starfield") as! SKEmitterNode
        starfield.advanceSimulationTime(10)
        
        startLabel.fontSize = 50
        startLabel.fontColor = SKColor.white
        startLabel.zPosition = 1
        startLabel.position = CGPoint(x: 0, y: 0)
        addChild(startLabel)
        
        scoreLabel = SKLabelNode(text: "High Score: \(highScoreNumber)")
        scoreLabel.position = CGPoint(x: 0, y: 100)
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor.white
        self.addChild(scoreLabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                if let view = self.view as! SKView? {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: "GameScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        view.presentScene(scene)
                    }
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true
                }
            }
        }
    }
}
