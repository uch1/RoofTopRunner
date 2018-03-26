//
//  ObjectHelper.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/19/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit

class ObjectHelper {
    
    static func handleChild(sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstant.StringConstant.enemyName:
            PhysicsHelper.addPhysicsBody(to: sprite, with: name)
        default:
            let components = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            if let rows = Int(components[0]), let columns = Int(components[1]) {
                calculateGridWith(rows: rows, columns: columns, parent: sprite)
            }
        }
    }
    
    static func calculateGridWith(rows: Int, columns: Int, parent: SKSpriteNode) {
        for x in 0..<columns {
            for y in 0..<rows {
                let position = CGPoint(x: x, y: y)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coinWidth = parent.size.width/CGFloat(columns)
        let coinHeight = coinWidth
        let coin = SKSpriteNode(color: .yellow, size: .init(width: coinWidth, height: coinHeight))
        coin.name = GameConstant.StringConstant.coinName
        
        parent.color = UIColor.clear
        
        let coinXPosition = position.x  * coin.size.width + coin.size.width/2
        let coinYPosition = position.y * coin.size.height + coin.size.height/2
        coin.position = CGPoint(x: coinXPosition, y: coinYPosition)
        
        PhysicsHelper.addPhysicsBody(to: coin, with: GameConstant.StringConstant.coinName)
        
        parent.addChild(coin)
    }
    
}















