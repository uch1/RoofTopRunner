//
//  PhysicsCategories.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

struct PhysicsCategory {
  static let none: UInt32 = 0
  static let player: UInt32 = 0b0001
  static let ground: UInt32 = 0b0010
  static let obstacles: UInt32 = 0b0100
  static let sleeper: UInt32 = 0b1000
}
