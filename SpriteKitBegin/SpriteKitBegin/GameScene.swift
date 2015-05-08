//
//  GameScene.swift
//  SpriteKitBegin
//
//  Created by Mariana Medeiro on 04/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!


func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = 1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Monster      : UInt32 = 0b1
    static let Projectile   : UInt32 = 0b10
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
    #endif

extension CGPoint {
    func length () -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

var level = 1
var monstersDestroyed = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let player = SKSpriteNode(imageNamed: "playerHommer")
    let labelLevel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
    let labelNumberOfMonsters = SKLabelNode(fontNamed: "Helvetica Neue Thin")
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //imagem de fundo
        var bgImage = SKSpriteNode(imageNamed: "sala")
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(bgImage)
        
        //label nivel, dimensiona/configura a label; e altera o nivel de acordo com a quantidade de monstros que o usuario acerta (func projectileDidCollideWithMonster)!!
        labelLevel.text = "Level: \(level)"
        labelLevel.fontSize = 30
        labelLevel.fontColor = SKColor.blackColor()
        labelLevel.position = CGPoint(x: size.width/2, y: size.height/1.1)
        addChild(labelLevel)
        
        labelNumberOfMonsters.text = "Level: \(level)"
        labelNumberOfMonsters.fontSize = 30
        labelNumberOfMonsters.fontColor = SKColor.blackColor()
        labelNumberOfMonsters.position = CGPointMake(20, 200)
        //addChild(labelNumberOfMonsters)
       
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        
        backgroundColor = SKColor(red: 255/255, green: 204/255, blue: 1/255, alpha: 1.0)
        player.position = CGPoint(x: size.width * 0.11, y: size.height * 0.5)
        
        self.addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
                ])
            ))
        
       // playBackgroundMusic("background-music-aac.caf")
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch in (touches as! Set<UITouch>) {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // 1 - choose one of the touches to work with
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "donnut")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) {return}
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        
        runAction(SKAction.playSoundFileNamed("baby.mp3", waitForCompletion: false))
    }
    
    func projectileDidCollideWithMonster(projetile: SKSpriteNode, monster: SKSpriteNode) {
        println("Hit")
        
        projetile.removeFromParent()
        monster.removeFromParent()
        monstersDestroyed++
        
        
            if (monstersDestroyed == level) {
                level++
                labelLevel.text = "Nivel: \(level)"
 //               labelNumberOfMonsters.text = "Die: \ (monstersDestroyed)"
                monstersDestroyed = 0;
               
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //1
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //2
        if((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
    
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func addMonster () {
        
        //Create Sprite
        var monster = SKSpriteNode(imageNamed: "meg")
        
        //Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        //Add the monster to the scene
        addChild(monster)

        
        //Determine speed of the monster
        var actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
       //aumento da velocidade de acordo com o nivel
        if (level > 2) {
            actualDuration = random(min: CGFloat(2.5), max: CGFloat(3.0))
            
        }
        
        if (level > 5) {
            actualDuration = random(min: CGFloat(2.0), max: CGFloat(2.0))
        }
        
        if (level > 8) {
            actualDuration = random(min: CGFloat(1.8), max: CGFloat(1.0))
        }
        
        if (level > 11) {
            actualDuration = random(min: CGFloat(1.5), max: CGFloat(1.0))
        }
        
        if (level > 14) {
            actualDuration = random(min: CGFloat(1.3), max: CGFloat(1.0))
        }
        
        if (level > 17) {
            actualDuration = random(min: CGFloat(1.0), max: CGFloat(1.0))
        }
        
        if (level > 20) {
            actualDuration = random(min: CGFloat(0.8), max: CGFloat(1.0))
        }
        
        if (level > 23) {
            actualDuration = random(min: CGFloat(0.7), max: CGFloat(1.0))
        }
        
        if (level > 26) {
            actualDuration = random(min: CGFloat(0.6), max: CGFloat(1.0))
        }
        
        if (level > 29) {
            actualDuration = random(min: CGFloat(0.5), max: CGFloat(1.0))
        }
        
        if (level > 32) {
            actualDuration = random(min: CGFloat(0.4), max: CGFloat(1.0))
        }
        
        if (level > 35) {
            actualDuration = random(min: CGFloat(0.3), max: CGFloat(1.0))
        }
        
        
        //Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
            level = 1
        
            if (level > highScore) {
                NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "high")
            }
        }
        
        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.dynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
    }
}
