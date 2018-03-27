//
//  MoveBehavior.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/17/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveBehavior: GKBehavior {
  init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
    super.init()
    if targetSpeed > 0 {
      setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
    }
  }
}
