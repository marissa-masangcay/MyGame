//
//  GameOver.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import UIKit


class GameOver: CCNode{
    
    func restartLevel()
    {
        Gamestate.currentLevel = Gamestate.currentLevel
        var gameplay = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplay)
    
    }
    
    func loadMenu()
    {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
}