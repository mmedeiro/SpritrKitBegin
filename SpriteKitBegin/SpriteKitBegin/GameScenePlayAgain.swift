//
//  GameScenePlayAgain.swift
//  SpriteKitBegin
//
//  Created by Mariana Medeiro on 06/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import Foundation
import SpriteKit

class GameScenePlayAgain: SKScene {
    init(size: CGSize, again: Bool) {
        super.init(size: size)
        
        //1
        backgroundColor = SKColor.whiteColor()
        
        //2
        var messageAgain = again ? "Clique para jogar novamente" : ""
        
        //3
        let labelAgain = SKLabelNode(fontNamed: "Chalkduster")
        labelAgain.text = messageAgain
        labelAgain.fontSize = 40
        labelAgain.fontColor = SKColor.blackColor()
        labelAgain.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(labelAgain)
        
        //4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock(){
                //5
                
//                
//                                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//                                let scene = GameScene(size: size)
//                                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    //6
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
}

}
