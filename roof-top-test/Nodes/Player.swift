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
    name = "player"
    
    physicsBody = SKPhysicsBody(rectangleOf: size)
    if let physicsBody = physicsBody {
      physicsBody.affectedByGravity = true
      physicsBody.categoryBitMask = PhysicsCategory.player
      physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
      physicsBody.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player
      physicsBody.usesPreciseCollisionDetection = true
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
