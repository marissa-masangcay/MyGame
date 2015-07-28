//
//  Character.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

//import Cocoa

class Character: CCSprite {
    
    var jumpPower: CGFloat = 2000
    var center: CGPoint?
    
    
    func jump()
    {
        physicsBody.applyImpulse(ccp(0.0, jumpPower))
        animationManager.runAnimationsForSequenceNamed("jump")
    }
    
    

}
