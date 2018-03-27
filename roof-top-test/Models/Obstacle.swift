//
//  Obstacle.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/15/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class Obstacle: SKSpriteNode {
  
  init(position: CGPoint, size: CGSize) {
    super.init(texture: nil, color: #colorLiteral(red: 0.9882352941, green: 0.4941176471, blue: 0, alpha: 1), size: size)
    self.position = position
    name = GameConstant.StringConstant.obstacleName

    physicsBody = SKPhysicsBody(rectangleOf: size)

    guard let physicsBody = physicsBody else { return }
    physicsBody.affectedByGravity = true
    
    physicsBody.categoryBitMask = PhysicsCategory.obstacle.bitMask
    physicsBody.collisionBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.player.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask
    physicsBody.contactTestBitMask = PhysicsCategory.player.bitMask
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
