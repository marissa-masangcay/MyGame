//
//  Character.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

//import Cocoa

enum State {
    case Jumping
    case Running
    case Walking
    case Idle
}

class Character: CCSprite {
    
    var state: State = .Idle
    let jumpPower: CGFloat = 2000
    
    func jump()
    {
        physicsBody.applyImpulse(ccp(0.0, jumpPower))
        animationManager.runAnimationsForSequenceNamed("jump")
    }
    
    

}
