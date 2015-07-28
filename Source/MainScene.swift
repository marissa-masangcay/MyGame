//import Foundation
//import UIKit
//import CoreMotion
//
//
//enum State {
//    case Jumping
//    case Running
//    case Walking
//}

class MainScene: CCNode {
}
//    var state: State = .Jumping
//    
//    weak var mainCharacter: Character!
//    weak var slimeEnemy: SlimeEnemy!
//    
//    var sinceTouch: CCTime = 0
//    
//    let manager = CMMotionManager()
//    let queue = NSOperationQueue.mainQueue()
//    
//    let screen = UIScreen.mainScreen().applicationFrame.size
//
//    
//    func didLoadFromCCB()
//    {
//        userInteractionEnabled = true
//        setupDeviceMotion()
//        CCBReader.load("Character")
//        CCBReader.load("SlimeEnemy")
//    }
//
//    
//    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
//    {
//        mainCharacter.jump()
//    }
//   
//    override func update(delta: CCTime) {
//        let velocityY = clampf(Float(mainCharacter.physicsBody.velocity.y), -200, 200)
//        mainCharacter.physicsBody.velocity = ccp(0, CGFloat(velocityY))
//        
//        var newX = mainCharacter.position.x
//        var newY = mainCharacter.position.y
//
//        
//        
//        if(newX>contentSize.width)
//        {
//            mainCharacter.position = CGPoint(x: -350, y: mainCharacter.position.y)
//        }
//        
//        if(newX<(-350))
//        {
//            mainCharacter.position = CGPoint(x: self.contentSize.width, y: mainCharacter.position.y)
//        }
//        
//        if(newY>self.contentSize.height)
//        {
//            mainCharacter.position = CGPoint(x: mainCharacter.position.x, y: self.contentSize.height)
//        }
////        
////        if(mainCharacter.ccPhysicsCollisionBegin(<#pair: CCPhysicsCollisionPair!#>, Character: Character!, enemy: SlimeEnemy!))
////        {
////            println("Collided with enemy")
////        }
//    }
//    
////    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, MainCharacter: character!, SlimeEnemy: enemy!) {
////        println("Something collided with a slime!")
////    }
//    
//    
//    func setupDeviceMotion() {
//        //make sure device has motion capabilities
//        if manager.deviceMotionAvailable {
//            //set the number of times the device should update motion data (in seconds)
//            manager.deviceMotionUpdateInterval = 0.01
//            //setup callback for everytime the motion data is updated
//            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion: CMDeviceMotion!, error: NSError!) -> Void in
//                ///checking device attitude will allow us to check devices current orientation in 3D space
//                    var attitude = motion.attitude
//                    self.mainCharacter.position.x += CGFloat(attitude.roll * 3)
//            })
//        }
//   }
//}