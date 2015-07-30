
import Foundation
import UIKit


class MainScene: CCNode
{
    
    func play()
    {
        Gamestate.currentLevel = 1
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func levelSelect()
    {
        let levelSelectScene = CCBReader.loadAsScene("LevelSelect")
        CCDirector.sharedDirector().presentScene(levelSelectScene)
    }
    
}