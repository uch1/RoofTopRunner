//
//  Monster.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/16/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Monster: GKEntity {
  init(position: CGPoint, color: SKColor, size: CGSize, entityManager: EntityManager) {
    super.init()
    let spriteComponent = SpriteComponent(entity: self, color: color, size: size)
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 50, maxAcceleration: 1, radius: Float(size.width / 2), entityManager: entityManager))
    spriteComponent.spriteNode.position = position
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
