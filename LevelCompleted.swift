//
//  LevelCompleted.swift
//  MyGame
//
//  Created by Marissa Masangcay on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


import Foundation
import UIKit

class LevelCompleted: CCNode{
    
    func playNextLevel()
    {
        Gamestate.currentLevel++
        var gameplay = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplay)
    }
    
    func restartLevel()
    {
        var gameplay = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplay)
    }
    
    func returnToMenu()
    {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
}
