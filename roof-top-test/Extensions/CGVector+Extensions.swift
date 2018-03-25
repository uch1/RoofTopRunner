//
//  CGVector+Extensions.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/21/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import SpriteKit

func - (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}
