//
//  Enemy.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/13/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {

  init(position: CGPoint, size: CGSize) {
    super.init(texture: nil, color: .blue, size: size)
    self.position = position
    name = "enemy"

    physicsBody = SKPhysicsBody(rectangleOf: size)
    if let physicsBody = physicsBody {
      physicsBody.affectedByGravity = true
      physicsBody.categoryBitMask = PhysicsCategory.player
      physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
