//
//  Coin.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/19/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    
    // MARK: - Initialization
    init() {
        let coinSize = CGSize(width: 20, height: 20)
        super.init(texture: nil, color: .yellow, size: coinSize)
        
        self.name = GameConstants.StringConstants.coinName
        
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        // self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }
    
}
