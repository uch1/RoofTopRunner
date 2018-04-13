//
//  MoveComponent.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/17/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MoveComponent : GKAgent2D, GKAgentDelegate {

  let entityManager: EntityManager

  init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
    self.entityManager = entityManager
    super.init()
    delegate = self
    self.maxSpeed = maxSpeed
    self.maxAcceleration = maxAcceleration
    self.radius = radius
    self.mass = 0.01
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func agentWillUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }

    position = float2(spriteComponent.spriteNode.position)
  }

  func agentDidUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }

    spriteComponent.spriteNode.position = CGPoint(position)
  }

  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    var targetMoveComponent: GKAgent2D

    // Reset behavior
    behavior = MoveBehavior(targetSpeed: maxSpeed, seek: GKAgent(), avoid: [])
  }
}
