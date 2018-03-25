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
  var redEnemy: Enemy!
  var yellowEnemy: Enemy!

  // Keeps track of whether or not the player has a finger that's touching the screen.
  var touchDown = false
  var isPlayerJumping = false
  var touchLocation: CGPoint!
  var cam: SKCameraNode!
  var enemyPreviousVelocity: CGVector = .zero
  var playerPreviousVelocity: CGVector = .zero
  
  /// On screen control to move player.
  let movePlayerStick = AnalogJoystick(diameters: (135, 100))
  
  // The multiplier that will be applied to player's gravity to create "heaviness".
  let fallMultiplier: CGFloat = 1.25
  // The multiplier that will be applied to player's gravity to elongate player jump.
  let lowJumpMultiplier: CGFloat = 1.085

  var lastUpdateTimeInterval: TimeInterval = 0
  var time: Double = 0.0

  var timeLabel: SKLabelNode!
  var restartButton: SKSpriteNode!
  var progressBar: SKShapeNode!

  let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
  let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)

  override func didMove(to view: SKView) {
    setupScene()
  }
  
  override func update(_ currentTime: TimeInterval) {
    lastUpdateTimeInterval = currentTime

    super.update(currentTime)
    // Make sure that the scene has already loaded.
    guard scene != nil else { return }
    guard let cam = cam else { return }

    redEnemy.update(self)
    yellowEnemy.update(self)

    // Get player bodies
    guard let playerPhysicsBody = player.physicsBody else { return }
    guard let enemyPhysicsBody = redEnemy.physicsBody else { return }

    // Move cam to player
    let duration = TimeInterval(0.4 * pow(0.9, abs(playerPhysicsBody.velocity.dx / 100) - 1) + 0.05)
    let xOffsetExpo = CGFloat(0.4 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100 - 1) - 0.04)
    let yOffsetExpo = CGFloat(0.4 * pow(0.9, -abs(playerPhysicsBody.velocity.dy) / 100 - 1) - 0.04)
    let scaleExpo = CGFloat(0.001 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100  - 1) + 3.16)
    var xOffset = xOffsetExpo.clamped(to: -1000...1500) * (playerPhysicsBody.velocity.dx > 0 ? 1 : -1)

    let scale = scaleExpo.clamped(to: 3...5.5)
    cam.setScale(scale)
    cam.run(SKAction.move(to: CGPoint(x: player.position.x + xOffset, y: player.position.y + (size.height / 2) + yOffsetExpo), duration: duration))

    enemyPreviousVelocity = enemyPhysicsBody.velocity
    playerPreviousVelocity = playerPhysicsBody.velocity
    applyGravityMultipliers(to: playerPhysicsBody)
    applyGravityMultipliers(to: enemyPhysicsBody)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    touchLocation = touch.location(in: cam)
    
    if touchLocation.x > cam.frame.width / 2 && !isPlayerJumping {
      guard let playerPhysicsBody = player.physicsBody else { return }

      playerPhysicsBody.applyImpulse(CGVector(dx: 0, dy: 80))
      isPlayerJumping = true
    }

    // Get UI node that was touched.
    let touchedNodes = cam.nodes(at: touchLocation)
    for node in touchedNodes {
      if node.name == "restartButton" {
        let scene = GameScene(size: size)
        scene.scaleMode = scaleMode
        let animation = SKTransition.fade(withDuration: 0.2)
        removeAllChildren()
        removeAllActions()
        view?.presentScene(scene, transition: animation)
      }
    }

    touchDown = true
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}

// MARK: Setup
private extension GameScene {
  func setupScene() {
    ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
    addChild(ground)

    player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(player)

    redEnemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 40), color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    addChild(redEnemy)
    redEnemy.logic = Logic.redEnemyLogic
    yellowEnemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 1.5), size: CGSize(width: 40, height: 40), color: #colorLiteral(red: 1, green: 0.8337777597, blue: 0, alpha: 1))
    yellowEnemy.physicsBody = nil
    yellowEnemy.logic = Logic.yellowEnemyLogic
    addChild(yellowEnemy)
    addGroundObstacles()
    cam = SKCameraNode()
    cam.zPosition = 1000

    setupUI()
    physicsWorld.contactDelegate = self

    self.camera = cam

    addChild(cam!)
    let timeAction = SKAction.run { [unowned self] in
      self.time += Double(self.physicsWorld.speed / 100)
      self.timeLabel.text = String(format: "%.2f", self.time)
    }

    run(SKAction.repeatForever(SKAction.sequence([timeAction, .wait(forDuration: 0.01)])))
  }

  func setupUI() {
    timeLabel = SKLabelNode(fontNamed: "Courier")
    timeLabel.position = CGPoint(x: 0, y: size.height / 5)
    timeLabel.zPosition = 0

    restartButton = SKSpriteNode(color: #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.5), size: CGSize(width: 88, height: 44))
    restartButton.name = "restartButton"
    restartButton.position = CGPoint(x: -size.width / 2 + restartButton.frame.width, y: size.height / 2 - restartButton.frame.height)
    restartButton.zPosition = 0

    progressBar = SKShapeNode(rectOf: CGSize(width: size.width, height: 22))
    progressBar.fillColor = #colorLiteral(red: 0.5294117647, green: 0.8, blue: 0.8980392157, alpha: 1)

    cam.addChild(timeLabel)
    cam.addChild(restartButton)
    cam.setScale(3.5)

    // Setup joystick to control player movement.
    movePlayerStick.position = CGPoint(x: -size.width / 2 + movePlayerStick.radius * 1.7, y: -size.height / 2 + movePlayerStick.radius * 1.7)
    movePlayerStick.stick.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    movePlayerStick.substrate.color = #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.3)
    movePlayerStick.trackingHandler = { [unowned self] data in
      //      self.player.physicsBody?.applyImpulse(CGVector(dx: data.velocity.x * 0.1, dy: 0))
      self.player.physicsBody?.applyForce(CGVector(dx: data.velocity.x * 2, dy: 0))
    }
    cam.addChild(movePlayerStick)
  }
}

private extension GameScene {
  func createBackground() {
    for i in 0...1000 {
      let node = SKSpriteNode(color: #colorLiteral(red: 0.8276178896, green: 0.4138089448, blue: 0, alpha: 1), size: CGSize(width: size.width * 0.9, height: size.height * 0.95))
      node.position = CGPoint(x: CGFloat(i) * node.frame.width + 50, y: node.frame.height)
      addChild(node)
    }
  }

  func addGroundObstacles() {
    makeObstacles(at: player.position, amount: 100, size: CGSize(width: 500, height: 100), spacing: 2)
    makeObstacles(at: player.position.applying(CGAffineTransform(translationX: 0, y: 130)), amount: 250, size: CGSize(width: 50, height: 120), spacing: 2)
    makeObstacles(at: player.position.applying(CGAffineTransform(translationX: 3100, y: 300)), amount: 250, size: CGSize(width: 3000, height: 120), spacing: 1.1)
  }
  
  func makeObstacles(at origin: CGPoint, amount: Int, size: CGSize, spacing: CGFloat) {
    for i in 0...amount {
      let obstacleSize = CGSize(width: size.width + CGFloat(i), height: size.height + CGFloat(i))
      let obstaclePosition = CGPoint(x: origin.x + CGFloat(obstacleSize.width * CGFloat(i) * spacing), y: origin.y + CGFloat(obstacleSize.height))
      let obstacle = Obstacle(position: obstaclePosition, size: obstacleSize, isDynamic: true)
      obstacle.physicsBody!.density = 0.05
      addChild(obstacle)
    }
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
    lightImpactFeedbackGenerator.prepare()
    mediumImpactFeedbackGenerator.prepare()
    heavyImpactFeedbackGenerator.prepare()
    guard let playerPhysicsBody = player.physicsBody else { return }

    let contactTestBitMask = contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask
    switch contactTestBitMask {
    case playerPhysicsBody.contactTestBitMask:
      isPlayerJumping = false
      let deltaVelocity = playerPhysicsBody.velocity - playerPreviousVelocity
      let speed = abs(deltaVelocity.dx) + abs(deltaVelocity.dy)

      if speed >= 50 && speed < 600 {
        lightImpactFeedbackGenerator.impactOccurred()
      } else if speed >= 600 && speed < 1000 {
        mediumImpactFeedbackGenerator.impactOccurred()
      } else if speed >= 1000 {
        heavyImpactFeedbackGenerator.impactOccurred()
      }
    default:
      return
    }
  }
}
