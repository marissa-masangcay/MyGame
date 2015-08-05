//
//  Gameplay.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


//Implement a continue button
//Use battery icon


import Foundation
import UIKit
import CoreMotion

class Gameplay: CCNode {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var levelNode: CCNode!
    weak var contentNode: CCNode!
    weak var timerLabel: CCLabelTTF!
   

    var mainCharacter: Character!
    var currentLevel: CCNode?
    
    var gameOver = false
    
    var timer = NSTimer()
    var gameOverTimer = NSTimer()

    let spawnRate: Double = 2.0
    var characterRemoved: Bool = false
    
    
    var currentLevelGamePlay: Int = 1
    var levelToContinue: Int = 1
    
    
    var levelTimes : [Int] = [10, 7, 13]
    
    
    let manager = CMMotionManager()
    let queue = NSOperationQueue.mainQueue()
    let screen = UIScreen.mainScreen().applicationFrame.size
    
    
    var timeLeft: Float = 100 {
        didSet {
            timeLeft = max(min(timeLeft, 100), 0)
            timerLabel.string = "\(Int(timeLeft))"
        }
    }
    
    
    
    // MARK: ViewLifeCycle
    func didLoadFromCCB()
    {
        currentLevelGamePlay = Gamestate.currentLevel

        gamePhysicsNode.collisionDelegate = self
        gamePhysicsNode.debugDraw = false
        userInteractionEnabled = true
    
        setupDeviceMotion()
        loadLevel()
        
        self.schedule("spawnNewObstacles", interval: spawnRate)
        

    }
    
    
    func loadLevel()
    {
        
        var levelLoaded: String = ("Levels/Level\(Gamestate.currentLevel)")
        
        timeLeft = Float(levelTimes[Gamestate.currentLevel-1])
        
        currentLevel = CCBReader.load(levelLoaded) as! Level
        currentLevel!.position = ccp(0, 0)
        levelNode.addChild(currentLevel)
        levelNode = currentLevel
        
        mainCharacter = CCBReader.load("MainCharacter") as! Character
        mainCharacter.positionInPoints = ccp(150, 150)
        levelNode.addChild(mainCharacter)
        
        
    }
    
    
    override func onEnter()
    {
        super.onEnter()
        
        contentSizeInPoints = currentLevel!.contentSizeInPoints
        let actionFollow = CCActionFollow(target: mainCharacter, worldBoundary: levelNode.boundingBox())
        runAction(actionFollow)
    }
    
    
    func triggerGameOver() {
        var scene = CCBReader.loadAsScene("GameOver")
        CCDirector.sharedDirector().presentScene(scene)
        
        Gamestate.resetGame = false
        Gamestate.startFromBeginning = false
    }
    
    
    func restart() {
        Gamestate.currentLevel = Gamestate.currentLevel
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    

    func triggerLevelCompleted()
    {
        var scene = CCBReader.loadAsScene("LevelCompleted")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    
    func spawnNewObstacles()
    {
        let randomXPosition = Int(arc4random_uniform(300))
        
        // create and add a new obstacle
        let obstacle = CCBReader.load("Obstacle")
        obstacle.positionInPoints = CGPoint(x: randomXPosition, y: (Int(mainCharacter.position.y)+Int(screen.height)))
        gamePhysicsNode.addChild(obstacle)
        
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
        self.addChild(characterExplosion)
        //Remove the character from the level
        character.removeFromParent()
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
        self.addChild(enemyExplosion)
        //finally, remove the enemy from the level
        enemy.removeFromParent()
    }

    // MARK: TouchHandling
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        if gameOver { return }
        mainCharacter.jump()
    }
    
    
    override func update(delta: CCTime) {
        
        if gameOver { return }
        
        timeLeft -= Float(delta)
        if timeLeft < 1 {
            triggerGameOver()
        }
        
        timerLabel.positionInPoints = ccp(screen.width/2, (mainCharacter.position.y+150))
        
        if(timerLabel.position.y>levelNode.boundingBox().height)
        {
            timerLabel.position = ccp(timerLabel.position.x, levelNode.boundingBox().height-20)
        }
        
        
        var newX = mainCharacter.position.x
        var newY = mainCharacter.position.y
        
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
        
//        println("time left \(timeLeft)")
//        println()
        
    }
   
    
    
    func setupDeviceMotion() {
        //make sure device has motion capabilities
        if manager.deviceMotionAvailable
        {
            //set the number of times the device should update motion data (in seconds)
            manager.deviceMotionUpdateInterval = 0.1
            //setup callback for everytime the motion data is updated
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion: CMDeviceMotion!, error: NSError!) -> Void in
                ///checking device attitude will allow us to check devices current orientation in 3D space
                var attitude = motion.attitude
                
                
//                println("roll: \(attitude.roll)")
//                println("velocity: \(self.mainCharacter.physicsBody.velocity)")
//                println()
                
                //TODO: Fine tune multiplier and clamping parameters
                let multiplier: Double = 600.00
                let velocityY = self.mainCharacter.physicsBody.velocity.y
                var velocityX = Float(attitude.roll * multiplier)
                
                let minVelocityX: Float = -400.00
                let maxVelocityX: Float = 400.00
                velocityX = clampf(Float(velocityX), minVelocityX, maxVelocityX)
                
                self.mainCharacter.physicsBody.velocity = ccp(CGFloat(velocityX), velocityY)
            })
        }
    }

}

// MARK: CCPhysicsCollisionDelegate
extension Gameplay: CCPhysicsCollisionDelegate {
    
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, slime: SlimeEnemy!, character: Character!)
    {
        let energy = pair.totalKineticEnergy
        
        if energy > 50000 {
            slimeEnemyRemoved(slime)
        }
        else{
            characterRemoved(character)
            scheduleOnce("triggerGameOver", delay: 0.5)
            
        }
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, obstacle: Obstacle!, character: Character!) -> ObjCBool
    {
        characterRemoved(character)
        scheduleOnce("triggerGameOver", delay: 0.5)
        return true
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, flag: Flag!, character: Character!) -> ObjCBool
    {
        triggerLevelCompleted()
        return true
        
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, halfHeart: HalfHeart!, character: Character!) -> ObjCBool
    {
        timeLeft += Float(1.0)
        character.animationManager.runAnimationsForSequenceNamed("jump")
        halfHeart.removeFromParent()
        return true
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, fullHeart: FullHeart!, character: Character!) -> ObjCBool
    {
        timeLeft += Float(2.0)
        character.animationManager.runAnimationsForSequenceNamed("jump")
        fullHeart.removeFromParent()
        return true
    }
    
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, spikes: Spikes!, character: Character!)
    {
        characterRemoved(character)
        scheduleOnce("triggerGameOver", delay: 0.5)
    }
    
    
    
    
    
    
    
    
}
