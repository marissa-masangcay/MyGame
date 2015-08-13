//
//  Level.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Level: CCNode {
    
    weak var flag: CCNode!
    weak var slimeEnemyNode: CCNode!

    var levelNumber: Int = Gamestate.currentLevel
    var timeOfLevel: Float = 10
    
    
    

}
