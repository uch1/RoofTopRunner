//
//  PhysicsCategories.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

//struct PhysicsCategory {
//    static let none: UInt32        = 0       // 00000
//    static let player: UInt32      = 0b1     // 00001
//    static let enemy: UInt32       = 0b10    // 00010
//    static let ground: UInt32      = 0b100   // 00100
//    static let obstacle: UInt32   = 0b1000  // 01000
//    static let coin: UInt32        = 0b10000 // 10000
//}

enum PhysicsCategory: UInt32 {
    
    case none     = 0            // 00000
    case player   = 0b1          // 00001
    case enemy    = 0b10         // 00010
    case ground   = 0b100        // 00100
    case obstacle = 0b1000       // 01000
    case coin     = 0b10000      // 10000
    
    var bitMask: UInt32 {
        return self.rawValue
    }
}
