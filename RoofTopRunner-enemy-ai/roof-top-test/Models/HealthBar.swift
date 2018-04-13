//
//  HealthBar.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 4/12/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class HealthBar: SKSpriteNode {
    
    // Background Health Bar Image
    var backgroundBar: SKSpriteNode!
    var backgroundBarTexture: SKTexture!
    
    // Health Bar Image
    var healthBar: SKSpriteNode!
    var healthBarTexture: SKTexture!
    
    let maxHealth: CGFloat = 200
    
    var health: CGFloat = 1.0 {
        didSet {
            /* Cap Health */
            if health > 1.0 { health = 1.0 }
            
            healthBar.xScale = health
            print("***** \(healthBar.xScale) *****")
        }
    }
    
    init() {
        
        let size = CGSize(width: 150, height: 30)
        
        backgroundBarTexture = SKTexture(imageNamed: GameConstant.ImageName.healthBarBackgroundImage)
        super.init(texture: backgroundBarTexture, color: .clear, size: size)
        
        anchorPoint.x = 0
        zPosition = GameConstant.ZPosition.backgroundBarZ
        
        setupBackgroundBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundBar() {
        
        healthBar = SKSpriteNode(imageNamed: GameConstant.ImageName.healthBarImage)
        healthBar.size = CGSize(width: 150, height: 30)
        healthBar.zPosition = GameConstant.ZPosition.healthBarZ
        healthBar.anchorPoint.x = 0
        addChild(healthBar)
        
        
//        healthBarTexture = SKTexture(imageNamed: GameConstant.ImageName.healthBarImage)
//        healthBar = SKSpriteNode(texture: healthBarTexture, color: .clear, size: size)
//        healthBar.zPosition = GameConstant.ZPosition.healthBarZ
//        healthBar.anchorPoint.x = 0
//        addChild(healthBar)
    }
    
}











