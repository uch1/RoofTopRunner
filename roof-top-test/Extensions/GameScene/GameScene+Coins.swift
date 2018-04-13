//
//  GameScene+Coins.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/20/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    /* Makes a particle effect at the position of a coin that is picked up. */
    
    func makeCoinPoofAtPoint(point: CGPoint) {
        if let poof = SKEmitterNode(fileNamed: "CoinPoof") {
            addChild(poof)
            poof.position = point
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            poof.run(seq)
        }
    }
    
    // MARK: Make coins
    
    func startMakingCoins() {
        // MARK: Make Coins
        let makeCoin = SKAction.run {
            print("Make Coins!")
            self.makeCoinBlock(node: self, posX: self.player.position.x + 1000)
        }
        
        let coinDelay = SKAction.wait(forDuration: 2)
        let coinSequence = SKAction.sequence([coinDelay, makeCoin])
        let repeatCoins = SKAction.repeatForever(coinSequence)
        run(repeatCoins)
    }
    
    func getCoin() -> SKSpriteNode {
        //let coinSize = CGSize(width: 21, height: 21)
        //let coin = SKSpriteNode(color: UIColor.yellow, size: coinSize)
        let coin = SKSpriteNode(imageNamed: GameConstant.ImageName.coinImage)
        coin.size = CGSize(width: 40, height: 40)
        coin.name = GameConstant.StringConstant.coinName
        return coin
    }
    
    func makeCoin() -> SKSpriteNode {
        let coin = getCoin()
        
        let coinSize = CGSize(width: 21, height: 0)
        coin.position.x = view!.frame.size.width
        coin.position.y = CGFloat(arc4random() % 14) * coinSize.width + 100
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        
        // Coins collide with nothing and contact only with players.
        coin.physicsBody?.categoryBitMask   = PhysicsCategory.coin.bitMask
        coin.physicsBody?.collisionBitMask  = PhysicsCategory.none.bitMask
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.player.bitMask
        
        return coin
    }
    
    func makeCoinBlock(node: SKNode, posX: CGFloat) {
        let blockNode = SKNode()
        blockNode.name = "coinblock"
        
        let block = getCoinBlock()
        
        for row in 0 ..< block.count {
            for col in 0 ..< block[row].count {
                if block[row][col] == 1 {
                    let coin = makeCoin()
                    coin.position = CGPoint(x: 60 * CGFloat(col) + (60/2), y: 60 * CGFloat(-row) - (60/2))
                    blockNode.addChild(coin)
                }
            }
        }
        
        let coinSize: CGFloat = 21
        let w = CGFloat(block[0].count) * coinSize
        let h = CGFloat(block.count) * coinSize
        
        let rangeY: CGFloat = 500 // view!.frame.height / 2
        let y = CGFloat(arc4random() % UInt32(rangeY)) + rangeY
        
        /*
         let testSprite = SKSpriteNode(color: UIColor(white: 1, alpha: 0.5), size: CGSize(width: w, height: h))
         testSprite.anchorPoint = CGPoint(x: 0, y: 1)
         blockNode.addChild(testSprite)
         */
        
        blockNode.position.x = posX
        blockNode.position.y = y
        
        node.addChild(blockNode)
    }
    
    
    func getCoinBlock() -> [[Int]] {
        
        let a = [
            [0,0,1,1,0,0],
            [0,0,1,1,0,0],
            [0,0,1,1,0,0],
            [0,0,1,1,0,0]
        ]
        
        let b = [
            [0,0,1,1,0,0],
            [0,0,1,1,0,0]
        ]
        
        let c = [
            [0,0,1,1,1,0],
            [0,0,1,1,1,0],
            [0,0,1,1,1,0]
        ]
        
        let d = [
            [0,1,1,1,0,0],
            [0,0,1,1,1,0],
            [0,0,0,1,1,1]
        ]
        
        let blockOfCoins = [a, b, c, d]
        let randomCoins = Int(arc4random() % UInt32(blockOfCoins.count))
    
        return blockOfCoins[randomCoins]
    }
    
}










