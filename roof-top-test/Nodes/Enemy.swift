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
  
  init(position: CGPoint, size: CGSize) {
    super.init(texture: nil, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), size: size)
    self.position = position
    name = "enemy"

    physicsBody = SKPhysicsBody(rectangleOf: size)
    if let physicsBody = physicsBody {
      physicsBody.affectedByGravity = true
      physicsBody.categoryBitMask = PhysicsCategory.player
      physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
      physicsBody.usesPreciseCollisionDetection = true
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Update state.
  func update(_ scene: GameScene) {
    // Grab player.
    guard let player = scene.player else { return }
    // Grab physics bodies.
    guard let physicsBody = physicsBody else { return }
    guard let playerPhysicsBody = player.physicsBody else { return }

    // Distance between the enemy and the player as CGPoint.
    let positionDifferenceToPlayer = Useful.differenceBetween(self, and: player)
    // The velocity of the enemy before any action is taken.
    let currentVelocity = physicsBody.velocity

    // Analyze player.
    let isNearPlayer = abs(positionDifferenceToPlayer.x) < 100
    let isAbovePlayer = positionDifferenceToPlayer.x < 2
    let isAheadOfPlayer = playerPhysicsBody.velocity.dx * positionDifferenceToPlayer.x < 0
    // Analyze environment.
    let obstaclesAhead = scene.nodes(at: CGPoint(x: position.x + frame.width + viewDistance.width, y: position.y + viewDistance.height))
    let isObstacleAhead = obstaclesAhead.first != nil
    // Analyze self.
    let hasStopped = abs(currentVelocity.dx) <= 80
    let hasHitObstacle = abs(currentVelocity.dx) - abs(previousVelocity.dx) < 80
    let yVelocityIsTooFast = abs(currentVelocity.dy) > 300
    let xVelocityIsTooFast = abs(currentVelocity.dx) > 6000
    let thinksPlayerTooFast = abs(currentVelocity.dx) > 5000
    let shouldJump = !yVelocityIsTooFast && ((hasStopped && hasHitObstacle) || isObstacleAhead)

    // Calculate forces to apply.
    let angle = atan2(positionDifferenceToPlayer.y, positionDifferenceToPlayer.x)
    let vx: CGFloat = cos(angle) * 350
    let vy: CGFloat = shouldJump ? 1500 : 0.0
    let moveForce = CGVector(dx: vx, dy: vy)
    let stopForce = CGVector(dx: -currentVelocity.dx / 10, dy: 0)

    // Stop accelerating once ahead of player.
    if xVelocityIsTooFast && isAheadOfPlayer && !isNearPlayer {
      physicsBody.applyForce(stopForce)
    }
    // Move towards player.
    physicsBody.applyForce(moveForce)

    // Capture player if the position to.
    if thinksPlayerTooFast && isAheadOfPlayer && !isNearPlayer {
      run(SKAction.scale(to: 6, duration: 0.2))
    } else if !isAheadOfPlayer {
      run(SKAction.scale(to: 1, duration: 0.2))
    }
  }
}
