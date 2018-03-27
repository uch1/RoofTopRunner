//
//  SpriteComponent.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/16/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
  let spriteNode: SKSpriteNode

  init(entity: GKEntity, color: SKColor, size: CGSize) {
    spriteNode = SKSpriteNode(texture: nil, color: color, size: size)
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

