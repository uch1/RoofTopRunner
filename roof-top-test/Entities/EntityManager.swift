//
//  EntityManager.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/16/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class EntityManager {
  var entities = Set<GKEntity>()
  let scene: SKScene

  lazy var componentSystems: [GKComponentSystem] = {
    let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
    return [moveSystem]
  }()

  init(scene: SKScene) {
    self.scene = scene
  }

  func add(_ entity: GKEntity) {
    entities.insert(entity)

    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }

    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.spriteNode {
      scene.addChild(spriteNode)
    }
  }

  func update(_ deltaTime: CFTimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }
  }
}
