//
//  Player.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    init(position: CGPoint, size: CGSize) {
        super.init(texture: nil, color: #colorLiteral(red: 0.5294117647, green: 0.8, blue: 0.8980392157, alpha: 1), size: size)
        self.position = position
        name = GameConstant.StringConstant.playerName
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        
        
        physicsBody?.categoryBitMask = PhysicsCategory.player.bitMask
        physicsBody?.collisionBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask
        physicsBody?.contactTestBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.enemy.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.coin.bitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
















