//
//  GameOverScene.swift
//  SpriteKitBegin
//
//  Created by Mariana Medeiro on 04/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var nivel : Int?
    init(size: CGSize, won: Bool) {
        super.init(size: size)
    
            
        //1
        backgroundColor = SKColor(red: 255/255, green: 204/255, blue: 1/255, alpha: 1.0)
        
        
        //2
        var message = won ? "Ganhooooou 🎉" : "You Looooose!"

        
        
        //3
        let label = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(330, 320)
        addChild(label)
        
        //label para jogar novamente
        let labelAgain = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        labelAgain.text = " Don't worry, tap to play again "
        labelAgain.fontSize = 30
        labelAgain.fontColor = SKColor.blackColor()
        labelAgain.position = CGPointMake(330, 270)
        labelAgain.physicsBody = SKPhysicsBody(rectangleOfSize: labelAgain.frame.size)
        labelAgain.physicsBody?.dynamic = false
        labelAgain.name = "PlayAgain"
        addChild(labelAgain)
        
        //label Score
        let lblScore = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        lblScore.fontSize = 20
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPointMake(60, 150)
        lblScore.text = "Score: \(level)"
        addChild(lblScore)
        
        //imagem
        let loseImage = SKSpriteNode(imageNamed: "gameLose")
        
        loseImage.position = CGPointMake(330, 90)
        addChild(loseImage)

        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var local = touches.first as! UITouch
        var localT = local.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(localT) {
            // var oi = childNodeWithName("funcc")?.position = CGPointMake(350, 150)
            if body.node!.name == "PlayAgain"{
                level = 1
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                 let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
                println("entrou")
                
            } } }

    //6
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    
}


