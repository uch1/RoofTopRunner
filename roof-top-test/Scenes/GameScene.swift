//
//  GameScene.swift
//  roof-top-test
//
//  Created by Willie Johnson on 3/8/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import SpriteKit
import GameplayKit

/* Tracking enum for game state */
enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    var ground: Ground!
    var player: Player!
    var enemy: Enemy!
    var coin: Coin!
    var dropperEnemy: Enemy!
    var monster: Monster!
    // Height of ground
    var groundHeight: CGFloat = 40
    var contentNode: SKNode!
    
    // Keeps track of whether or not the player has a finger that's touching the screen.
    var touchDown = false
    var isPlayerJumping = false
    var touchLocation: CGPoint!
    var cam: SKCameraNode!
    var previousEnemyVelocity: CGVector = .zero
    
    /// On screen control to move player.
    let movePlayerStick = AnalogJoystick(diameters: (135, 100))
    
    // The multiplier that will be applied to player's gravity to create "heaviness".
    let fallMultiplier: CGFloat = 1.2
    // The multiplier that will be applied to player's gravity to elongate player jump.
    let lowJumpMultiplier: CGFloat = 1.05
    
    var entityManager: EntityManager!
    
    var lastUpdateTimeInterval: TimeInterval = 0
    var time: Double = 0.0
    
    var timeLabel: SKLabelNode!
    var restartButton: SKSpriteNode!
    var restartButtonLabel: SKLabelNode!
    var coinCollectionLabel: SKLabelNode!
    var healthBar: SKSpriteNode!
    
    var health: CGFloat = 1.0 {
        didSet {
            /* Cap health */
            if health > 1.0 { health = 1.0}
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            healthBar.xScale = health
        }
    }
    
    var coinsCollected: Int = 0 {
        didSet {
            coinCollectionLabel.text = "Coins: \(coinsCollected)"
        }
    }
    
    
//    // Size of node
//    let coinSize = CGSize(width: 20, height: 20)
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        cam = SKCameraNode()
        cam.setScale(3.5)
        
        self.camera = cam
        addChild(cam!)
        
        startMakingCoins()
        setupGameLabels()
        setupGround()
        setupPlayer()
        addGroundObstacles()
        setupEnemy()
        setupDropperEnemy()
        setupJoystickControl()
        
        entityManager = EntityManager(scene: self)
        
//        ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
//        addChild(ground)
        
//        let playerHeight: CGFloat = 100
//        player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: playerHeight/2.0, height: playerHeight))
//        addChild(player)
        
//        enemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 80))
//        addChild(enemy)
        
//        coin = Coin()
//        coin.position = CGPoint(x: 250, y: 300)
//        addChild(<#T##node: SKNode##SKNode#>)
        

        //    monster = Monster(position: CGPoint(x: player.position.x - 100, y: size.height), color: #colorLiteral(red: 1, green: 0.8337777597, blue: 0, alpha: 1), size: CGSize(width: 40, height: 40), entityManager: entityManager)
        //    entityManager.add(monster)
        

//        timeLabel = SKLabelNode(fontNamed: "Courier")
//        timeLabel.position = CGPoint(x: 0, y: size.height / 5)
//        cam.addChild(timeLabel)


        
//        // Setup joystick to control player movement.
//        movePlayerStick.position = CGPoint(x: -size.width / 2 + movePlayerStick.radius * 1.6, y: -size.height / 2 + movePlayerStick.radius * 1.5)
//        movePlayerStick.stick.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
//        movePlayerStick.substrate.color = #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.3)
//        movePlayerStick.trackingHandler = { [unowned self] data in
//            //      self.player.physicsBody?.applyImpulse(CGVector(dx: data.velocity.x * 0.1, dy: 0))
//            self.player.physicsBody?.applyForce(CGVector(dx: data.velocity.x * 5, dy: 0))
//        }
//        cam.addChild(movePlayerStick)

        
//        let timeAction = SKAction.run { [unowned self] in
//            self.time += Double(self.physicsWorld.speed / 100)
//            self.timeLabel.text = String(format: "%.2f", self.time)
//        }
//
//
//        run(SKAction.repeatForever(SKAction.sequence([timeAction, .wait(forDuration: 0.01)])))
        

    }
    
    func setupGround() {
        ground = Ground(position: CGPoint(x: size.width / 2, y: 0), size: CGSize(width: size.width * 1000, height: size.height / 4))
        addChild(ground)
    }
    
    func setupPlayer() {
        let playerHeight: CGFloat = 100
        player = Player(position: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: playerHeight/2.0, height: playerHeight))
        addChild(player)
    }
    
    func setupEnemy() {
        enemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 2), size: CGSize(width: 40, height: 80))
        addChild(enemy)
    }
    
    func setupJoystickControl() {
        /* Setup joystick to control player movement */
        movePlayerStick.position = CGPoint(x: -size.width / 2 + movePlayerStick.radius * 1.6, y: -size.height / 2 + movePlayerStick.radius * 1.5)
        movePlayerStick.stick.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        movePlayerStick.substrate.color = #colorLiteral(red: 0.6722276476, green: 0.6722276476, blue: 0.6722276476, alpha: 0.3)
        movePlayerStick.trackingHandler = { [unowned self] data in
            //      self.player.physicsBody?.applyImpulse(CGVector(dx: data.velocity.x * 0.1, dy: 0))
            self.player.physicsBody?.applyForce(CGVector(dx: data.velocity.x * 5, dy: 0))
        }
        cam.addChild(movePlayerStick)
    }
    
    func setupDropperEnemy() {
        /* Once this function is called, the dropper enemy and its action will be created */
        
        /* Dropper Enemy */
        dropperEnemy = Enemy(position: CGPoint(x: player.position.x - 100, y: size.height / 1.5), size: CGSize(width: 60, height: 60))
        dropperEnemy.color = #colorLiteral(red: 1, green: 0.8337777597, blue: 0, alpha: 1)
        dropperEnemy.physicsBody!.isDynamic = false
        addChild(dropperEnemy)
        
        /* Dropper Enemy's actions */
        let dropObstacle = SKAction.run { [unowned self] in
            self.dropperEnemy.run(SKAction.scale(to: 2, duration: 0.2))
            var randWidthModifier = GKRandomSource.sharedRandom().nextInt(upperBound: 100)
            let randHeightModifier = GKRandomSource.sharedRandom().nextInt(upperBound: 20)
            let randVelocityModifier = CGFloat(GKRandomSource.sharedRandom().nextUniform()) + 1
            
            let isSuperBlock = randWidthModifier == 100 && randHeightModifier == 20
            if isSuperBlock {
                randWidthModifier *= 5
            }
            
            let obstacleSize = CGSize(width: 100 + randWidthModifier, height: 100 + randHeightModifier)
            let obstaclePosition = CGPoint(x: self.dropperEnemy.position.x, y: self.dropperEnemy.position.y - obstacleSize.height)
            
            let obstacle = Obstacle(position: obstaclePosition, size: obstacleSize)
            obstacle.color = #colorLiteral(red: 0.8765190972, green: 0.5600395258, blue: 0, alpha: 1)
            self.addChild(obstacle)
            
            let difference = Useful.differenceBetween(obstacle, and: self.player)
            let angle = atan2(difference.y, difference.x)
            obstacle.physicsBody!.usesPreciseCollisionDetection = true
            obstacle.physicsBody!.mass = 0.2
            obstacle.physicsBody!.applyImpulse(CGVector(dx: -cos(angle) * (300 * randVelocityModifier), dy: sin(angle) * (1000 * randVelocityModifier)))
        }
        
        let shrinkAfterDrop = SKAction.run { [unowned self] in
            self.dropperEnemy.run(SKAction.scale(to: 1, duration: 0.2))
        }
        
        run(SKAction.repeatForever(SKAction.sequence([dropObstacle, shrinkAfterDrop, .wait(forDuration: 2)])))
    }
    
    func setupGameLabels() {
        /* Coin Collection Label */
        coinCollectionLabel = SKLabelNode()
        coinCollectionLabel.fontSize = 30
        coinCollectionLabel.fontColor = .yellow
        coinCollectionLabel.verticalAlignmentMode = .top
        coinCollectionLabel.horizontalAlignmentMode = .right
        coinCollectionLabel.position = CGPoint(x: size.width / 2 - 70, y: size.height/2 - 10)
        coinCollectionLabel.text = "Coins: 0"
        /* Add CoinCollectionLabel as a child of cam */
        cam.addChild(coinCollectionLabel)
        
        /* Restart Button Label */
        restartButton = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.48), size: CGSize(width: 88, height: 44))
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: -size.width / 2 + restartButton.frame.width, y: size.height / 2 - restartButton.frame.height)
        
        restartButtonLabel = SKLabelNode()
        restartButtonLabel.text = "Restart"
        restartButtonLabel.fontColor = UIColor.white
        restartButtonLabel.fontSize = 20
        restartButtonLabel.position.x = restartButton.position.x
        restartButtonLabel.position.y = restartButton.position.y - 10
        /* Add restart button and label as a child node of cam */
        cam.addChild(restartButton)
        cam.addChild(restartButtonLabel)
        
        /* Time Label */
        timeLabel = SKLabelNode(fontNamed: "Courier")
        timeLabel.position = CGPoint(x: 0, y: size.height / 5)
        
        cam.addChild(timeLabel)
        
        /* Time Action */
        let timeAction = SKAction.run { [unowned self] in
            self.time += Double(self.physicsWorld.speed / 100)
            self.timeLabel.text = String(format: "%.2f", self.time)
        }
        run(SKAction.repeatForever(SKAction.sequence([timeAction, .wait(forDuration: 0.01)])))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        super.update(currentTime)
        
        // Make sure that the scene has already loaded.
        guard scene != nil else { return }
        guard let cam = cam else { return }
        
        entityManager.update(deltaTime)
        
        enemy.update(self)
        
        // Get player bodies
        guard let playerPhysicsBody = player.physicsBody else { return }
        guard let enemyPhysicsBody = enemy.physicsBody else { return }
        
        // Move cam to player
        let duration = TimeInterval(0.4 * pow(0.9, abs(playerPhysicsBody.velocity.dx / 100) - 1) + 0.05)
        let xOffsetExpo = CGFloat(0.4 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100 - 1) - 0.04)
        let scaleExpo = CGFloat(0.001 * pow(0.9, -abs(playerPhysicsBody.velocity.dx) / 100  - 1) + 3.16)
        let xOffset = xOffsetExpo.clamped(to: -1000...1500) * (playerPhysicsBody.velocity.dx > 0 ? 1 : -1)
        let scale = scaleExpo.clamped(to: 3...5.5)
        cam.setScale(scale)
        cam.run(SKAction.move(to: CGPoint(x: player.position.x + xOffset, y: player.position.y + (size.height / 2)), duration: duration))
        
        self.dropperEnemy.run(SKAction.move(to: CGPoint(x: self.player.position.x + self.player.physicsBody!.velocity.dx, y: self.player.position.y + 500), duration: 0.8))
        previousEnemyVelocity = enemyPhysicsBody.velocity
        
        applyGravityMultipliers(to: playerPhysicsBody)
        applyGravityMultipliers(to: enemyPhysicsBody)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: cam)
        
        if touchLocation.x > cam.frame.width / 2 && !isPlayerJumping {
            guard let playerPhysicsBody = player.physicsBody else { return }
            print("Testing????")
            playerPhysicsBody.applyImpulse(CGVector(dx: 0, dy: 500))
            isPlayerJumping = true
        }
        
        // Get UI node that was touched.
        let touchedNodes = cam.nodes(at: touchLocation)
        for node in touchedNodes {
            if node.name == "restartButton" {
                let scene = GameScene(size: size)
                let animation = SKTransition.crossFade(withDuration: 0.5)
                view?.presentScene(scene, transition: animation)
            }
        }
        
        // movePlayerStick.position = touchLocation
        touchDown = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = false
    }
}






