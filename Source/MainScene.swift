
import Foundation
import UIKit


class MainScene: CCNode
{
    
    func play()
    {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func levelSelect()
    {
        let levelSelectScene = CCBReader.loadAsScene("LevelSelect")
        CCDirector.sharedDirector().presentScene(levelSelectScene)
    }
    
}