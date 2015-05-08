//
//  PlayGame.swift
//  SpriteKitBegin
//
//  Created by Mariana Medeiro on 07/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import SpriteKit
import AVFoundation

var backgroundMusicPlayerFistScene: AVAudioPlayer!

func playBackgroundMusicStart(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayerFistScene = AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayerFistScene == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayerFistScene.numberOfLoops = -1
    backgroundMusicPlayerFistScene.prepareToPlay()
    backgroundMusicPlayerFistScene.play()
}

class PlayGame: SKScene {
    
    let imgWelcome = SKSpriteNode (imageNamed: "IMG_0654")
    let imgWelcome2 = SKSpriteNode (imageNamed: "initial2")
    
    
    override func didMoveToView(view: SKView) {
        //1
        backgroundColor = SKColor(red: 255/255, green: 204/255, blue: 1/255, alpha: 1.0)
        
        
        //3
        let lblWelcome = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        lblWelcome.text = "Donuts for Meg "
        lblWelcome.fontSize = 50
        lblWelcome.fontColor = SKColor.blackColor()
        lblWelcome.position = CGPointMake(398, 200)
        addChild(lblWelcome)
        
        //label para jogar novamente
        let lblPlayGame = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        lblPlayGame.text = "Press To Start"
        lblPlayGame.fontSize = 30
        //lblPlayGame.fontColor = SKColor(red: 229/255, green: 99/255, blue: 159/255, alpha: 1.0)
        lblPlayGame.fontColor = SKColor.blackColor()
        lblPlayGame.position = CGPointMake(490, 90)
        lblPlayGame.physicsBody = SKPhysicsBody(rectangleOfSize: lblPlayGame.frame.size)
        lblPlayGame.physicsBody?.dynamic = false
        lblPlayGame.name = "PlayAgain"
        addChild(lblPlayGame)
    
        imgWelcome.position = CGPointMake(100, 160)
        addChild(imgWelcome)
        imgWelcome2.position = CGPointMake(610, 300)
        addChild(imgWelcome2)
        
        let anima = SKAction.scaleYTo(-1, duration: 2.0)
        let anima2 = SKAction.scaleYTo(1, duration: 2.0)
        let anima3 = SKAction.scaleXTo(-1, duration: 1.0)
        let anima4 = SKAction.scaleXTo(1, duration: 1.0)
        
//        imgWelcome.runAction(anima3, completion: { () -> Void in
//            self.imgWelcome.runAction(anima4)
//        })
        
        imgWelcome2.runAction(anima, completion: { () -> Void in
            self.imgWelcome2.runAction(anima2)
        })

       playBackgroundMusicStart("backMusic.mp3")
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var space = touches.first as! UITouch
        var spaceTouch = space.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(spaceTouch) {
            // var oi = childNodeWithName("funcc")?.position = CGPointMake(350, 150)
            if body.node!.name == "PlayAgain"{
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
                println("entrou")
                
            } } }
    
}

