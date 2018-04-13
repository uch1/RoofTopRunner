//
//  GameConstant.swift
//  roof-top-test
//
//  Created by Uchenna  Aguocha on 3/30/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameConstant {
    
    struct ZPosition {
        
        static let playerZ: CGFloat = 4
        static let enemyZ: CGFloat = 4
        static let coinZ: CGFloat = 5
        static let groundZ: CGFloat = 6
        static let healthBarZ: CGFloat = 11
        static let backgroundBarZ: CGFloat = 10
        static let hudZ: CGFloat =  10
        
        // Menu
        static let menuBackgroundZ: CGFloat = 1
        //static let playButton: CGFloat = 2
    }
    
    struct StringConstant {
        static let playerName = "Player"
        static let enemyName = "Enemy"
        static let coinName = "Coin"
        static let groundName = "Ground"
        static let obstacleName = "Obstacle"
        static let menuBackground = "Menu Background"
        static let playButton = "Play Button"
        static let gameTitle = "Rooftop Runners"
        static let playButtonText = "Play"
    }
    
    struct ImageName {
        static let desert = "Desert"
        static let playButtonImage = "b_7"
        static let healthBarBackgroundImage = "bar_1"
        static let healthBarImage = "bar_2"
        static let coinImage = "c"
    }
    
    struct FontName {
        static let futura = "Futura"
        static let chalkboardSE = "Chalkboard SE"
    }
    
}
