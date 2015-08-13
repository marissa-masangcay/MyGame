//
//  LevelSelect.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import UIKit


class LevelSelect: CCNode{
    
    var levelLoaded: CCNode?
    
    
    func loadLevel(sender: CCButton) {
        Gamestate.resetGame = false
        Gamestate.startFromBeginning = false
        let buttonName = sender.name
        Gamestate.currentLevel = buttonName.toInt()!
        var gameplay = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplay)
    }
    
    func returnToMenu()
    {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
    
    
}