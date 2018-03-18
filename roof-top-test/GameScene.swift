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
  var dropperEnemy: Enemy!
  var monster: Monster!
  
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

  var entityManager: EntityManager!

  var lastUpdateTimeInterval: TimeInterval = 0
  var time: Double = 0.0

  var distanceLabel: SKLabelNode!
  var restartButton: SKSpriteNode!

  override func didMove(to view: SKView) {
    entityManager = EntityManager(scene: self)
    ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
    addChild(ground)
    
    player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(player)
    
    enemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(enemy)

    dropperEnemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 1.5), size: CGSize(width: 40, height: 40))
    dropperEnemy.color = #colorLiteral(red: 1, green: 0.8337777597, blue: 0, alpha: 1)
    dropperEnemy.physicsBody!.isDynamic = false
    addChild(dropperEnemy)

    //    monster = Monster(position: CGPoint(x: player.position.x - 100, y: size.height), color: #colorLiteral(red: 1, green: 0.8337777597, blue: 0, alpha: 1), size: CGSize(width: 40, height: 40), entityManager: entityManager)
    //    entityManager.add(monster)

    let spawnFallingObjects = SKAction.run { [unowned self] in
      let obstacleSize = CGSize(width: 50, height: 50)
      let obstaclePosition = CGPoint(x: self.dropperEnemy.position.x, y: self.dropperEnemy.position.y - 50)
      let obstacle = Obstacle(position: obstaclePosition, size: obstacleSize)
      obstacle.color = #colorLiteral(red: 0.9882352941, green: 0.6314190156, blue: 0, alpha: 1)
      self.addChild(obstacle)

      let difference = self.positionDifference(from: obstacle, to: self.player)
      let angle = atan2(difference.y, difference.x)
      obstacle.physicsBody!.applyImpulse(CGVector(dx: -cos(angle) * 300, dy: sin(angle) * 1000))
    }
    run(SKAction.repeatForever(SKAction.sequence([spawnFallingObjects, .wait(forDuration: 1)])))

    addGroundObstacles()
    cam = SKCameraNode()
    distanceLabel = SKLabelNode()
    distanceLabel.position = CGPoint(x: 0, y: size.height / 5)

    restartButton = SKSpriteNode(color: #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.5), size: CGSize(width: 88, height: 44))
    restartButton.name = "restartButton"
    restartButton.position = CGPoint(x: -size.width / 2 + restartButton.frame.width, y: size.height / 2 - restartButton.frame.height)
    cam.addChild(distanceLabel)
    cam.addChild(restartButton)
    cam.setScale(3.5)
    
    // Setup joystick to control player movement.
    movePlayerStick.position = CGPoint(x: -size.width / 2 + movePlayerStick.radius * 1.5, y: -size.height / 2 + movePlayerStick.radius * 1.5)
    movePlayerStick.stick.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
    movePlayerStick.substrate.color = #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.5)
    movePlayerStick.trackingHandler = { [unowned self] data in
      //      self.player.physicsBody?.applyImpulse(CGVector(dx: data.velocity.x * 0.1, dy: 0))
      self.player.physicsBody?.applyForce(CGVector(dx: data.velocity.x * 2, dy: 0))
    }
    cam.addChild(movePlayerStick)
    physicsWorld.contactDelegate = self
    
    self.camera = cam
    
    addChild(cam!)
    SKAction.sequence([spawnFallingObjects, .wait(forDuration: 1)])
    let timeAction = SKAction.run { [unowned self] in
      self.time += 0.01
      self.distanceLabel.text = String(format: "%.2f", self.time)
    }

    run(SKAction.repeatForever(SKAction.sequence([timeAction, .wait(forDuration: 0.01)])))
  }
  
  override func update(_ currentTime: TimeInterval) {
    let deltaTime = currentTime - lastUpdateTimeInterval
    lastUpdateTimeInterval = currentTime

    super.update(currentTime)
    // Make sure that the scene has already loaded.
    guard scene != nil else { return }
    guard let cam = cam else { return }

    entityManager.update(deltaTime)
    
    // Get player bodies
    guard let playerPhysicsBody = player.physicsBody else { return }
    guard let enemyPhysicsBody = enemy.physicsBody else { return }
    
    // Move cam to player
    let duration = TimeInterval(0.4 * pow(0.9, abs(playerPhysicsBody.velocity.dx / 100) - 1) + 0.05)
    let xOffsetExpo = CGFloat(0.4 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100 - 1) - 0.04)
    let scaleExpo = CGFloat(0.001 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100  - 1) + 3.16)
    let xOffset = xOffsetExpo.clamped(to: -1000...1500) * (playerPhysicsBody.velocity.dx > 0 ? 1 : -1)
    let scale = scaleExpo.clamped(to: 3...5.5)
    cam.setScale(scale)
    cam.run(SKAction.move(to: CGPoint(x: player.position.x + xOffset, y: player.position.y + (size.height / 2)), duration: duration))
    
    // Distance between the enemy and the player as CGPoint.
    let enemyPositionDifferenceToPlayer = positionDifference(from: enemy, to: player)
    // The velocity of the enemy before any action is taken.
    let enemyCurrentVelocity = enemyPhysicsBody.velocity
    // Check enemy conditions.
    let enemyIsNearPlayer = abs(enemyPositionDifferenceToPlayer.x) < 100
    let enemyIsAbovePlayer = enemyPositionDifferenceToPlayer.x < 2
    let enemyIsAheadOfPlayer = playerPhysicsBody.velocity.dx * enemyPositionDifferenceToPlayer.x < 0
    let enemyHasStopped = abs(enemyCurrentVelocity.dx) <= 80
    let enemyHasHitObstacle = abs(enemyCurrentVelocity.dx) - abs(previousEnemyVelocity.dx) < 80
    let enemyYVelocityTooFast = abs(enemyCurrentVelocity.dy) > 400
    let enemyXVelocityTooFast = abs(enemyCurrentVelocity.dx) > 6000
    let enemyThinksPlayerTooFast = abs(enemyCurrentVelocity.dx) > 6000
    let enemyShouldJump = enemyHasStopped && !enemyYVelocityTooFast && enemyHasHitObstacle
    // Calculate forces.
    let angle = atan2(enemyPositionDifferenceToPlayer.y, enemyPositionDifferenceToPlayer.x)
    let vx: CGFloat = cos(angle) * 350
    let vy: CGFloat = enemyShouldJump ? 1500 : 0.0
    let enemyMoveForce = CGVector(dx: vx, dy: vy)
    let enemyStopForce = CGVector(dx: -enemyCurrentVelocity.dx / 10, dy: 0)
    
    if enemyXVelocityTooFast && enemyIsAheadOfPlayer && !enemyIsNearPlayer {
      enemyPhysicsBody.applyForce(enemyStopForce)
    }

    if enemyThinksPlayerTooFast && enemyIsAheadOfPlayer && !enemyIsNearPlayer{
      enemy.run(SKAction.scale(to: 6, duration: 0.2))
    } else if !enemyIsAheadOfPlayer {
      enemy.run(SKAction.scale(to: 1, duration: 0.2))
    }

    self.dropperEnemy.run(SKAction.move(to: CGPoint(x: self.player.position.x + self.player.physicsBody!.velocity.dx, y: self.player.position.y + 500), duration: 0.8))
    enemyPhysicsBody.applyForce(enemyMoveForce)
    previousEnemyVelocity = enemyPhysicsBody.velocity
    
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
    // Get UI node that was touched.
    let touchedNodes = cam.nodes(at: touchLocation)
    for node in touchedNodes {
      if node.name == "restartButton" {
        let scene = GameScene(size: size)
        let animation = SKTransition.crossFade(withDuration: 0.5) // ...Add transition if you like
        view?.presentScene(scene, transition: animation)
      }
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
    makeObstacles(at: player.position.applying(CGAffineTransform(translationX: 3100, y: 100)), amount: 250, size: CGSize(width: 3000, height: 120), spacing: 1.1)
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
    let dx = to.position.x - from.position.x
    let dy = to.position.y - from.position.y
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
