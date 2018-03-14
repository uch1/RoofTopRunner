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
  var touchDown: Bool = false
  var touchLocation: CGPoint!
  var cam: SKCameraNode!

  override func didMove(to view: SKView) {
    ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
    addChild(ground)

    player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: 40, height: 40))
    addChild(player)

    enemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 40))
    enemy.color = .red
    addChild(enemy)

    for i in 0..<250 {
      let obstacle = SKSpriteNode(color: .yellow, size: CGSize(width: 20 + i, height: 20 * i))
      obstacle.position = CGPoint(x: player.position.x + CGFloat(160 * i), y: player.position.y)
      obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
      if let physicsBody = obstacle.physicsBody {
        physicsBody.affectedByGravity = true
        physicsBody.categoryBitMask = PhysicsCategory.player
        physicsBody.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
      }

      addChild(obstacle)
    }

    cam = SKCameraNode()
    cam.setScale(2)
    self.camera = cam
    addChild(cam!)
  }

  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    // Make sure that the scene has already loaded.
    guard scene != nil else { return }
    if let cam = cam {
      cam.position = player.position
    }

    let dx = player.position.x - enemy.position.x
    let dy = player.position.y - enemy.position.y
    let angle = atan2(dy, dx)

    // Calculate velocity.
    let vx = cos(angle) * 2.0
    let vy = sin(angle) * 2.0

    enemy.physicsBody?.applyImpulse(CGVector(dx: vx, dy: vy))

    // Move player if user touches screen
    if touchDown {
      if touchLocation.x < size.width / 2 {
        player.physicsBody?.applyImpulse(CGVector(dx: -1, dy: 0))
      } else {
        player.physicsBody?.applyImpulse(CGVector(dx: 1, dy: 0))
      }
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    touchLocation = touch.location(in: view)

    
    if touchLocation.y > size.height / 2 {
      player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
    }

    touchDown = true
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}
