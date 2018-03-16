//
//  GameScene.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  var ground: Ground!
  var player: Player!
  var enemy: Enemy!

  // Keeps track of whether or not the player has a finger that's touching the screen.
  var touchDown = false
  var isPlayerJumping = false
  var touchLocation: CGPoint!
  var cam: SKCameraNode!
  var previousEnemyVelocity: CGVector = .zero

  /// On screen control to move player.
  let movePlayerStick = AnalogJoystick(diameters: (125, 75))

  // The multiplier that will be applied to player's gravity to create "heaviness".
  let fallMultiplier: CGFloat = 1.2
  // The multiplier that will be applied to player's gravity to elongate player jump.
  let lowJumpMultiplier: CGFloat = 1.05

  override func didMove(to view: SKView) {
    ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
    addChild(ground)

    player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(player)

    enemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(enemy)

    addGroundObstacles()
    cam = SKCameraNode()
    cam.setScale(3.5)

    // Setup joystick to control player movement.
    movePlayerStick.position = CGPoint(x: -size.width / 2 + movePlayerStick.radius * 1.5, y: -size.height / 2 + movePlayerStick.radius * 1.5)
    movePlayerStick.stick.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
    movePlayerStick.substrate.color = #colorLiteral(red: 0.06148975343, green: 0.01091015339, blue: 0.2903404832, alpha: 0.7)
    movePlayerStick.trackingHandler = { [unowned self] data in
      //      self.player.physicsBody?.applyImpulse(CGVector(dx: data.velocity.x * 0.1, dy: 0))
      self.player.physicsBody?.applyForce(CGVector(dx: data.velocity.x * 2, dy: 0))
    }
    cam.addChild(movePlayerStick)
    physicsWorld.contactDelegate = self

    self.camera = cam

    addChild(cam!)
  }

  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    // Make sure that the scene has already loaded.
    guard scene != nil else { return }
    guard let cam = cam else { return }

    // Get player bodies
    guard let playerPhysicsBody = player.physicsBody else { return }
    guard let enemyPhysicsBody = enemy.physicsBody else { return }

    // Move cam to player
    let duration = Double(0.01 / positionDifference(from: cam, to: player).x) / 900
    cam.run(SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y + (size.height / 2)), duration: duration))

    let difference = positionDifference(from: enemy, to: player)
    let enemyCurrentVelocity = enemyPhysicsBody.velocity
    let enemyIsFarFromPlayer = abs(difference.x) > 50
    let enemyHasStopped = abs(enemyCurrentVelocity.dx) <= 80
    let enemyHasHitObstacle = abs(enemyCurrentVelocity.dx) - abs(previousEnemyVelocity.dx) < 80
    let enemyYVelocityIsTooHigh = abs(enemyCurrentVelocity.dy) > 400
    let enemyXVelocityIsTooHigh = abs(enemyCurrentVelocity.dx) > 900

    // Calculate forces.
    let angle = atan2(difference.x, difference.y)
    let dx: CGFloat = enemyIsFarFromPlayer && enemyHasStopped && !enemyYVelocityIsTooHigh && enemyHasHitObstacle ? 1500 : 0.0
    let dy: CGFloat = cos(angle) * 350
    let enemyMoveForce = CGVector(dx: dx, dy: dy)
    let enemyStopForce = CGVector(dx: -enemyCurrentVelocity.dx / 2.5, dy: 0)

    if enemyXVelocityIsTooHigh && !enemyIsFarFromPlayer {
      enemyPhysicsBody.applyForce(enemyStopForce)
    } else {
      enemyPhysicsBody.applyForce(enemyMoveForce)
      previousEnemyVelocity = enemyPhysicsBody.velocity
    }

    applyGravityMultipliers(to: playerPhysicsBody)
    applyGravityMultipliers(to: enemyPhysicsBody)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    touchLocation = touch.location(in: cam)

    if touchLocation.x > cam.frame.width / 2 && !isPlayerJumping {
      guard let playerPhysicsBody = player.physicsBody else { return }
      playerPhysicsBody.applyImpulse(CGVector(dx: 0, dy: 60))
      isPlayerJumping = true
    }
    //    movePlayerStick.position = touchLocation
    touchDown = true
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}

private extension GameScene {
  func addGroundObstacles() {
    makeObstacles(at: player.position, amount: 1000, size: CGSize(width: 50, height: 50), spacing: 1)
    makeObstacles(at: player.position.applying(CGAffineTransform(translationX: 0, y: 50)), amount: 250, size: CGSize(width: 50, height: 120), spacing: 2)
    //    makeObstacles(at: player.position, amount: 250, size: CGSize(width: 240, height: 60), spacing: 5)
  }

  func makeObstacles(at origin: CGPoint, amount: Int, size: CGSize, spacing: CGFloat) {
    for i in 0...amount {
      let obstacleSize = CGSize(width: size.width + CGFloat(i), height: size.height + CGFloat(i))
      let obstaclePosition = CGPoint(x: origin.x + CGFloat(obstacleSize.width * CGFloat(i) * spacing), y: origin.y)

      let obstacle = Obstacle(position: obstaclePosition, size: obstacleSize)
      addChild(obstacle)
    }
  }

  func positionDifference(from: SKNode, to: SKNode) -> CGPoint {
    let dx = from.position.x - to.position.x
    let dy = from.position.y - to.position.y
    return CGPoint(x: dx, y: dy)
  }

  func applyGravityMultipliers(to physicsBody: SKPhysicsBody) {
    if physicsBody.velocity.dy < 0 {
      physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (fallMultiplier - 1)))
    } else if physicsBody.velocity.dy > 0 && !touchDown {
      physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (lowJumpMultiplier - 1)))
    }
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    guard let playerPhysicsBody = player.physicsBody else { return }

    let contactTestBitMask = contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask
    switch contactTestBitMask {
    case playerPhysicsBody.contactTestBitMask:
      isPlayerJumping = false
    default:
      return
    }
  }
}
