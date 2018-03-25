//
//  Enemy.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/13/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

/// The Enemy SKSpriteNode that handles enemy logic.
class Enemy: SKSpriteNode {
  /// How fast the enemy was moving on the last update.
  var previousVelocity: CGVector = .zero
  /// How far the enemy can see.
  var viewDistance: CGSize = CGSize(width: 100, height: 0)
  /// The logic the enemy will execute on each frame.
  var logic: EnemyLogic?
  /// Tracks whether or not an SKAction is running on the Enemy.
  var isAbilityActionRunning: Bool = false
  
  init(position: CGPoint, size: CGSize, color: SKColor) {
    super.init(texture: nil, color: color, size: size)
    self.position = position
    self.zPosition = 10
    name = "enemy"

    physicsBody = SKPhysicsBody(rectangleOf: size)
    if let physicsBody = physicsBody {
      physicsBody.affectedByGravity = true
      physicsBody.categoryBitMask = PhysicsCategory.player
      physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
      physicsBody.usesPreciseCollisionDetection = true
      physicsBody.density = 2
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Update state.
  func update(_ scene: GameScene) {
    // Grab player.
    guard let player = scene.player else { return }
    guard let logic = logic else { return }
    logic(self, player, scene)
  }
}
