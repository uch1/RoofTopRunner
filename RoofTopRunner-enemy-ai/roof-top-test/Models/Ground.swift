//
//  Ground.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    init(position: CGPoint, size: CGSize) {
        super.init(texture: nil, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), size: size)
        name = "ground"
        
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOf: size)
        if let physicsBody = physicsBody {
            physicsBody.affectedByGravity = false
            physicsBody.isDynamic = false
            
            
            physicsBody.categoryBitMask = PhysicsCategory.ground
            physicsBody.contactTestBitMask = PhysicsCategory.player
            physicsBody.collisionBitMask = PhysicsCategory.player | PhysicsCategory.obstacles | PhysicsCategory.enemy
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
