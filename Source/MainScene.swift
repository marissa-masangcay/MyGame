
import Foundation
import UIKit


class MainScene: CCNode
{
    
     var mainCharacter: Character!
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        mainCharacter.jump()
    }
    
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
    
    func viewGuidelines()
    {
        let guidelinesScene = CCBReader.loadAsScene("Guidelines")
        CCDirector.sharedDirector().presentScene(guidelinesScene)
    }
    
}