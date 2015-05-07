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
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        //1
        backgroundColor = SKColor.purpleColor()
        
        //2
        var message = won ? "Ganhooooou 🎉" : "Perdeeeeeu 😢 "
        
        //3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        //teste
        let labelAgain = SKLabelNode(fontNamed: "Chalkduster")
        labelAgain.text = "Clique para jogar novamente"
        labelAgain.fontSize = 40
        labelAgain.fontColor = SKColor.blackColor()
        labelAgain.position = CGPoint(x: size.width/4, y: size.height/2)
        
        
        //4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock(){
                //5
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }

    //6
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    
}


