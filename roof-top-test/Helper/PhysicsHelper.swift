//
//  PhysicsHelper.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/20/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class PhysicsHelper {
    
    // TODO: Create a function for bit mask
    static func addPhysicsBody(to sprite: SKSpriteNode, with name: String) {
        
        switch name {
        case GameConstant.StringConstant.playerName:
            
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
            
            sprite.physicsBody?.restitution = 0.0
            sprite.physicsBody?.allowsRotation = false
            sprite.physicsBody?.affectedByGravity = true
            sprite.physicsBody?.usesPreciseCollisionDetection = true
            
            /* BitMask */
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.player.bitMask
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.enemy.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.coin.bitMask
            
           
        case GameConstant.StringConstant.enemyName:
            
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
            sprite.physicsBody?.affectedByGravity = true
            sprite.physicsBody?.usesPreciseCollisionDetection = true
            
            /* BitMask */
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.enemy.bitMask
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.player.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.none.bitMask
            
            
            
        case GameConstant.StringConstant.groundName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
            
            sprite.physicsBody?.affectedByGravity = false
            sprite.physicsBody?.isDynamic = false
            
           /* BitMask */
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.ground.bitMask
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.player.bitMask
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.player.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask

        case GameConstant.StringConstant.obstacleName:
            
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
            
            sprite.physicsBody?.affectedByGravity = true
            
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.obstacle.bitMask
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.ground.bitMask | PhysicsCategory.player.bitMask | PhysicsCategory.obstacle.bitMask | PhysicsCategory.enemy.bitMask
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.player.bitMask


        case GameConstant.StringConstant.coinName:
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
            sprite.physicsBody?.affectedByGravity = false
            
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.coin.bitMask
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.none.bitMask
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.player.bitMask
            
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        }
    }
    
    static func setupPhysicsBodyBitMask(sprite: SKSpriteNode, category: PhysicsCategory, contact: PhysicsCategory, collision: PhysicsCategory) {
        sprite.physicsBody?.categoryBitMask = category.bitMask
        sprite.physicsBody?.contactTestBitMask = contact.bitMask
        sprite.physicsBody?.collisionBitMask = collision.bitMask
    }
    
}


