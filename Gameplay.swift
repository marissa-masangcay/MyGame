//
//  Gameplay.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


import Foundation
import UIKit
import CoreMotion


enum State {
    case Jumping
    case Running
    case Walking
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!

    
    var state: State = .Jumping
    var mainCharacter: Character!
    var sinceTouch: CCTime = 0
    var levelToLoad: CCNode?
    var numCollisions: Int = 0
    var currentLevel: String = ""
    
    
    let manager = CMMotionManager()
    let queue = NSOperationQueue.mainQueue()
    let screen = UIScreen.mainScreen().applicationFrame.size
    
    
    func didLoadFromCCB()
    {
        userInteractionEnabled = true
        
        loadLevel()
        
        gamePhysicsNode.collisionDelegate = self
        
        setupDeviceMotion()
    }
    
    func loadLevel()
    {
        var levelLoaded: String = "Levels/Level3"
        levelToLoad = CCBReader.load(levelLoaded) as! Level
        levelToLoad!.position = ccp(0, 0)
        levelNode.addChild(levelToLoad)
        levelNode.contentSize = levelToLoad!.contentSize
        levelNode = levelToLoad
        
        mainCharacter = CCBReader.load("MainCharacter") as! Character
        mainCharacter.positionInPoints = ccp(150, 150)
        levelNode.addChild(mainCharacter)
        
    }
    
    
    override func onEnter() {
        super.onEnter()
        contentSizeInPoints = levelToLoad!.contentSizeInPoints
        let actionFollow = CCActionFollow(target: mainCharacter, worldBoundary: levelNode.boundingBox())
        runAction(actionFollow)
    }
    
    
    func characterRemoved(character: Character)
    {
        // load particle effect
        let characterExplosion = CCBReader.load("CharacterExplosion") as! CCParticleSystem
        // make the particle effect clean itself up, once it is completed
        characterExplosion.autoRemoveOnFinish = true;
        // place the particle effect on the characters position
        characterExplosion.position = character.position;
        // add the particle effect to the same node the character is on
        character.parent.addChild(characterExplosion)
        // finally, remove the character from the level
        character.removeFromParent()
    }
    
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, slime: SlimeEnemy!, character: Character!)
    {
        let energy = pair.totalKineticEnergy
        
        if energy > 5000 {
            slimeEnemyRemoved(slime)
        }
        else{
            characterRemoved(character)
        }
        

    }
    
    func slimeEnemyRemoved(enemy: SlimeEnemy)
    {
        //load particle effect
        let enemyExplosion = CCBReader.load("EnemyExplosion") as! CCParticleSystem
        //make the particle effect clean itself up, once it is completed
        enemyExplosion.autoRemoveOnFinish = true;
        //place the particle effect on the enemys position
        enemyExplosion.position = enemy.position;
        //add the particle effect to the same node the character is on
        enemy.parent.addChild(enemyExplosion)
        //finally, remove the enemy from the level
        enemy.removeFromParent()
    }

    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        mainCharacter.jump()
    }
    
    
    override func update(delta: CCTime) {
        
        var newX = mainCharacter.position.x
        var newY = mainCharacter.position.y
        
        var contentSizeWidth = contentSize.width
        var contentSizeHeight = contentSize.height
        
        if(newX>levelNode.boundingBox().width)
        {
            mainCharacter.position = CGPoint(x: 0, y: mainCharacter.position.y)
        }

        if(newX<0)
        {
            mainCharacter.position = CGPoint(x: levelNode.boundingBox().width, y: mainCharacter.position.y)
        }
        
        if(newY>levelNode.boundingBox().height)
        {
            mainCharacter.position = CGPoint(x: mainCharacter.position.x, y: levelNode.boundingBox().height-35)
        }
    }
   
    
    
    func setupDeviceMotion() {
        //make sure device has motion capabilities
        if manager.deviceMotionAvailable {
            //set the number of times the device should update motion data (in seconds)
            manager.deviceMotionUpdateInterval = 0.01
            //setup callback for everytime the motion data is updated
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion: CMDeviceMotion!, error: NSError!) -> Void in
                ///checking device attitude will allow us to check devices current orientation in 3D space
                var attitude = motion.attitude
                self.mainCharacter.position.x += CGFloat(attitude.roll * 3)
            })
        }
    }


}