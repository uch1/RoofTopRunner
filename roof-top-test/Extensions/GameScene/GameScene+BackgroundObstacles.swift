//
//  GameScene+BackgroundObstacles.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/25/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

// Make it private 
extension GameScene {
    
    func createBackground() {
        for i in 0...1000 {
            let node = SKSpriteNode(color: #colorLiteral(red: 0.8276178896, green: 0.4138089448, blue: 0, alpha: 1), size: CGSize(width: size.width * 0.9, height: size.height * 0.95))
            node.position = CGPoint(x: CGFloat(i) * node.frame.width + 50, y: node.frame.height)
            addChild(node)
        }
    }
    
    func addGroundObstacles() {

        makeObstacles(at: player.position, amount: 500, size: CGSize(width: 50, height: 50), spacing: 1)
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

    
    func applyGravityMultipliers(to physicsBody: SKPhysicsBody) {
        if physicsBody.velocity.dy < 0 {
            physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (fallMultiplier - 1)))
        } else if physicsBody.velocity.dy > 0 && !touchDown {
            physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (lowJumpMultiplier - 1)))
        }
    }
    
}
