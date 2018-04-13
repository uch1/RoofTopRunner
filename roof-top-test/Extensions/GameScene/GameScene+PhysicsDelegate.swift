//
//  GameScene+PhysicsDelegate.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/23/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        //guard let playerPhysicsBody = player.physicsBody else { return }
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let nodeA = bodyA.node
        let nodeB = bodyB.node
        
        let objectCategory = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch objectCategory {
            
        case PhysicsCategory.player.bitMask | PhysicsCategory.obstacle.bitMask:
            
            isPlayerJumping = false
            if state != .gameOver {
                health -= 5
            }
            print("The fallen obstacle hit the player. Player's Health: \(health)")
    
            
        case PhysicsCategory.player.bitMask | PhysicsCategory.enemy.bitMask:
            isPlayerJumping = false
            //print("player is jumping away from the enemy")
            
        case PhysicsCategory.player.bitMask | PhysicsCategory.ground.bitMask:
            isPlayerJumping = false
            //print("player is jumping from the ground")
            
        case PhysicsCategory.player.bitMask | PhysicsCategory.coin.bitMask:
            coinsCollected += 1
            // bodyA might be coin if not must be bodyB
            if bodyA.categoryBitMask == PhysicsCategory.coin.bitMask {
                nodeA?.removeFromParent()
                print("Player collects coin. NodeA removed coins from parent.")
            } else {
                nodeB?.removeFromParent()
                print("Player collects coin. NodeB removed coins from parent.")
            }
            
        default:
            return
        }
    }
    
    
}
