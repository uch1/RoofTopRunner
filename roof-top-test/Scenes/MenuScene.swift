//
//  MenuScene.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 4/2/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    //var playButton: MSButtonNode!
    var playButton: SKSpriteNode!
    var playButtonTextLabel: SKLabelNode!
    //var menuBackground: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        layoutView()
    }
    
    func layoutView() {
        // Menu Background
        let background = SKSpriteNode(imageNamed: GameConstant.ImageName.desert)
        background.size = size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = GameConstant.ZPosition.menuBackgroundZ
        
        addChild(background)
        
        // Game Title
        let gameTitleLabel = SKLabelNode(fontNamed: GameConstant.FontName.chalkboardSE)
        gameTitleLabel.text = GameConstant.StringConstant.gameTitle
        gameTitleLabel.fontSize = 60
        gameTitleLabel.fontColor = .white
        
        gameTitleLabel.zPosition = GameConstant.ZPosition.hudZ
        gameTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 10)
        
        addChild(gameTitleLabel)
        
        // Play Button & Text Label
        
        //playButton = MSButtonNode(coder)
        playButton = SKSpriteNode(imageNamed: GameConstant.ImageName.playButtonImage)
        playButton.size = CGSize(width: 80, height: 80)
        
        let playButtonXPosition: CGFloat = frame.midX
        let playButtonYPosition: CGFloat = frame.midY / 2 
        playButton.position = CGPoint(x: playButtonXPosition, y: playButtonYPosition)
        playButton.zPosition = GameConstant.ZPosition.hudZ
        //playButton.color = .red
        
        addChild(playButton)
        
        playButtonTextLabel = SKLabelNode(fontNamed: GameConstant.FontName.chalkboardSE)
        playButtonTextLabel.fontSize = CGFloat(20)
        playButtonTextLabel.text = GameConstant.StringConstant.playButtonText
        playButtonTextLabel.position = CGPoint(x: playButton.size.width / 2 - 30, y: playButton.size.height / 2 + 40)
        playButtonTextLabel.zPosition = GameConstant.ZPosition.hudZ
        playButtonTextLabel.color = UIColor.white
        
        //addChild(playButtonTextLabel)
        //playButton.addChild(playButtonTextLabel)
        // Help & Options Button
        let helpOptionsButton = SKSpriteNode()
        helpOptionsButton.size = CGSize(width: 60, height: 60)
        
        let helpOptionsXPosition: CGFloat = frame.size.width / 2 - 70
        let helpOptionsYPosition: CGFloat = frame.size.height / 2 - 60
        helpOptionsButton.position = CGPoint(x: helpOptionsXPosition, y: helpOptionsYPosition)
        helpOptionsButton.zPosition = GameConstant.ZPosition.hudZ
        helpOptionsButton.color = .blue
        
        //addChild(helpOptionsButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPosition = touch.location(in: self)
        let touchableNode = self.atPoint(touchPosition)
        
        if touchableNode == playButton {
            guard let view = self.view else { return }
            
            let transition = SKTransition.fade(withDuration: 1)
            let gameScene = GameScene(size: self.size)
            view.presentScene(gameScene, transition: transition)
        }
    }
    
    func presentGameScene() {
        
    }
}





















