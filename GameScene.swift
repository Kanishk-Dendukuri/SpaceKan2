//
//  GameScene.swift
//  spacegame
//
//  Created by Kanishk Dendukuri on 1/25/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let defaults = UserDefaults()
    lazy var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
    
    
    
    var touchLocation = CGPoint()
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0{
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer:Timer!
    
    let meteorCategory:UInt32 = 0x1 << 1
    let playerCatergory:UInt32 = 0x1 << 0
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 700)
        starfield.advanceSimulationTime(40)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "rocket")
        player.position = CGPoint(x: 0, y: 0)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = playerCatergory
        player.physicsBody?.contactTestBitMask = meteorCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.zPosition = 1
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: -250, y: 570)
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor.white

        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(addMeteor), userInfo: nil, repeats: true)
    }
    
    @objc func addMeteor(){
        let meteor = SKSpriteNode(imageNamed: "astroid")
        let randomMeteorPosition = GKRandomDistribution(lowestValue: -300, highestValue: 300)
        
        meteor.position = CGPoint(x: randomMeteorPosition.nextInt(), y: 800)
        
        meteor.physicsBody = SKPhysicsBody(texture: meteor.texture!, size: meteor.texture!.size())
        meteor.physicsBody?.categoryBitMask = meteorCategory
        meteor.physicsBody?.contactTestBitMask = playerCatergory
        meteor.physicsBody?.collisionBitMask = 0
        meteor.zPosition = 1
        self.addChild(meteor)
        
        let moveAction = SKAction.moveTo(y: -self.size.height, duration: 3.5)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        score += 1
        meteor.run(combine)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        player.removeFromParent()
        
        if score > highScoreNumber{
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "startMenu") {
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
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchLocation = touch.location(in: self)
            player.position.x = touchLocation.x
            player.position.y = touchLocation.y
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            touchLocation = touch.location(in: self)
            player.position.x = touchLocation.x
            player.position.y = touchLocation.y
            
            
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
