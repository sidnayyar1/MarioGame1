//
//  GameScene.swift
//  ZombieConga1
//
//  Created by Mervat Mustafa on 2020-06-08.
//  Copyright © 2020 Mervat Mustafa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  let mario = SKSpriteNode(imageNamed: "mario1")
  var lastUpdateTime: TimeInterval = 0
  var dt: TimeInterval = 0
  let MarioMovePointsPerSec: CGFloat = 480.0
  var velocity = CGPoint.zero
    let marioMove: SKAction
  let playableRect: CGRect
  var lastTouchLocation: CGPoint?
 let marioAnimation: SKAction
  let jumpSound: SKAction = SKAction.playSoundFileNamed(
    "jumpSound.wav", waitForCompletion: false)
  let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "loselifeSound.wav", waitForCompletion: false)
  var invincible = false
    //declare coin
    var coin = 0
    
    var finalScore = 0

  var lives = 7
  var gameOver = false
  let cameraNode = SKCameraNode()
  let cameraMovePointsPerSec: CGFloat = 200.0

  let livesLabel = SKLabelNode(fontNamed: "Chalkduster")
     let CoinLabel = SKLabelNode(fontNamed: "Chalkduster")
    
  override init(size: CGSize) {
    let maxAspectRatio:CGFloat = 16.0/9.0
    let playableHeight = size.width / maxAspectRatio
    let playableMargin = (size.height-playableHeight)/2.0
    playableRect = CGRect(x: 0, y: playableMargin,
                          width: size.width,
                          height: playableHeight)
    
    // 1
    var textures:[SKTexture] = []
    // 2
    for i in 1...12 {
      textures.append(SKTexture(imageNamed: "mario\(i)"))
    }
    // 3
    textures.append(textures[11])
    textures.append(textures[10])
    textures.append(textures[9])
    textures.append(textures[8])
    textures.append(textures[7])
    textures.append(textures[6])
    textures.append(textures[5])
    textures.append(textures[4])
    textures.append(textures[3])
    textures.append(textures[2])

    // 4
    marioAnimation = SKAction.animate(with: textures,
      timePerFrame: 0.1)
  marioMove = SKAction.moveBy(x: 0 + mario.size.width, y: 0, duration: 1.5)
    super.init(size: size)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    
  var cameraRect : CGRect {
     let x = cameraNode.position.x - size.width/2
         + (size.width - playableRect.width)/2
     let y = cameraNode.position.y - size.height/2
         + (size.height - playableRect.height)/2
     return CGRect(
       x: x,
       y: y,
       width: playableRect.width,
       height: playableRect.height)
   }
    
    
    //this function is to create a playable area in rectangle shape
  func debugDrawPlayableArea() {
    let shape = SKShapeNode()
    let path = CGMutablePath()
    path.addRect(playableRect)
    shape.path = path
    shape.strokeColor = SKColor.blue
    shape.lineWidth = 4.0
    addChild(shape)
  }
  // this function is to move camera
    
    
    
    
    func moveCamera() {
       let backgroundVelocity =
         CGPoint(x: cameraMovePointsPerSec, y: 0)
       let amountToMove = backgroundVelocity * CGFloat(dt)
       cameraNode.position += amountToMove
       
       enumerateChildNodes(withName: "bakground") { node, _ in
         let background = node as! SKSpriteNode
         if background.position.x + background.size.width <
             self.cameraRect.origin.x {
           background.position = CGPoint(
             x: background.position.x + background.size.width*2,
             y: background.position.y)
         }
       }
       
     }
    
    
    
    
    // this function gives different layout of the background.
    
    
    func backgroundNode() -> SKSpriteNode {
       // 1
       let backgroundNode = SKSpriteNode()
       backgroundNode.anchorPoint = CGPoint.zero
       backgroundNode.name = "bakground"
       backgroundNode.zPosition = -1

       // 2
       let background1 = SKSpriteNode(imageNamed: "bakground")
       background1.anchorPoint = CGPoint.zero
       background1.position = CGPoint(x: 0, y: 0)
       backgroundNode.addChild(background1)
       
       // 3
       let background2 = SKSpriteNode(imageNamed: "bakground")
       background2.anchorPoint = CGPoint.zero
       background2.position =
         CGPoint(x: background1.size.width, y: 0)
       backgroundNode.addChild(background2)

       // 4
       backgroundNode.size = CGSize(
         width: background1.size.width + background2.size.width,
         height: background1.size.height)
       return backgroundNode
     }
    
    
    
    
    
    
    //this function is for the enemy
    func spawnEnemy() {
      let enemy = SKSpriteNode(imageNamed: "Enemy")
      enemy.position = CGPoint(
        // assigning position of the enemy
        x: cameraRect.maxX + enemy.size.width/2,
        y: cameraRect.minY + 80)
      enemy.zPosition = 50
      enemy.name = "Enemy"
      enemy.setScale(0.7)
      addChild(enemy)
      // this line below let the enemy move with action move function
      let actionMove =
        SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: 4.0)
      let actionRemove = SKAction.removeFromParent()
      enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    
    
    
    //this function is for movement of the mario
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
      let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                 y: velocity.y * CGFloat(dt))
      sprite.position += amountToMove
    }
    
    
    
    
    
    func spawnCoin() {
      // 1
      let coin = SKSpriteNode(imageNamed: "coin")
      coin.position = CGPoint(
        x: CGFloat.random(min: playableRect.minX,
                          max: playableRect.maxX),
        y: CGFloat.random(min: playableRect.minY,
                          max: playableRect.maxY))
        coin.name = "coin"
      //coin.setScale(0)
      addChild(coin)
      // 2
//      let appear = SKAction.scale(to: 1.0, duration: 0.5)
//      let wait = SKAction.wait(forDuration: 5.0)
//      let disappear = SKAction.scale(to: 0, duration: 0.5)
//      let removeFromParent = SKAction.removeFromParent()
//      let actions = [appear, wait, disappear, removeFromParent]
//      cat.run(SKAction.sequence(actions))
        let actionMove =
               SKAction.moveBy(x: -(size.width + coin.size.width), y: 0, duration: 1.5)
             let actionRemove = SKAction.removeFromParent()
             coin.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    
    
    
    
    //This override function helps in running the application
  override func didMove(to view: SKView) {

   playBackgroundMusic(filename: "BgSound.wav")
  
    for i in 0...1 {
      let background = backgroundNode()
      background.anchorPoint = CGPoint.zero
      background.position =
        CGPoint(x: CGFloat(i)*background.size.width, y: 0)
      background.name = "bakground"
      background.zPosition = -1
      addChild(background)
    }
    
    mario.position = CGPoint(x: 400, y: 300)
    mario.zPosition = 100
    addChild(mario)
    // this line below move the animation and mario
    
    mario.run(SKAction.repeatForever(marioAnimation))
    mario.run(SKAction.repeatForever(marioMove))
    
    run(SKAction.repeatForever(
      SKAction.sequence([SKAction.run() { [weak self] in
                      self?.spawnEnemy()
                    },
                    SKAction.wait(forDuration: 2.0)])))
    
    addChild(cameraNode)
    camera = cameraNode
    cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
    
    livesLabel.text = "Lives: X"
    livesLabel.fontColor = SKColor.black
    livesLabel.fontSize = 100
    livesLabel.zPosition = 150
    livesLabel.horizontalAlignmentMode = .left
    livesLabel.verticalAlignmentMode = .bottom
    livesLabel.position = CGPoint(
        x: -playableRect.size.width/2 + CGFloat(20),
        y: -playableRect.size.height/2 + CGFloat(20))
    cameraNode.addChild(livesLabel)
    
    CoinLabel.text = "Coins: X"
    CoinLabel.fontColor = SKColor.black
                   CoinLabel.fontSize = 100
                  CoinLabel.zPosition = 150
    CoinLabel.horizontalAlignmentMode = .right
    CoinLabel.verticalAlignmentMode = .top
    CoinLabel.position = CGPoint(x: -playableRect.size.width/2 + CGFloat(20),
                                 y: -playableRect.size.width/2 + CGFloat(20))
                          cameraNode.addChild(CoinLabel)
    
    
    run(SKAction.repeatForever(
    SKAction.sequence([SKAction.run() { [weak self] in
                        self?.spawnCoin()
                      },
                       SKAction.wait(forDuration: 0.5)])))
    
  }
    
    
    
    
    //this function is mario when it gets hit by enemy
  func marioHit(enemy: SKSpriteNode) {
  invincible = true
  let blinkTimes = 10.0
  let duration = 3.0
  let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
    let slice = duration / blinkTimes
    let remainder = Double(elapsedTime).truncatingRemainder(
      dividingBy: slice)
    node.isHidden = remainder > slice / 2
  }
  let setHidden = SKAction.run() { [weak self] in
    self?.mario.isHidden = false
    self?.invincible = false
  }
  mario.run(SKAction.sequence([blinkAction, setHidden]))
  
  run(enemyCollisionSound)
  
  lives -= 1
    
  }
    
    
    
    
    func checkCollisions() {
        var hitCoins: [SKSpriteNode] = []
        enumerateChildNodes(withName: "coin") { node, _ in
          let coin = node as! SKSpriteNode
          if coin.frame.intersects(self.mario.frame) {
            hitCoins.append(coin)
          }
        }
        for cat in hitCoins {
          coinHit(enemy: cat)
        }
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodes(withName: "Enemy") { node, _ in
          let enemy = node as! SKSpriteNode
          if node.frame.insetBy(dx: 20, dy: 20).intersects(
            self.mario.frame) {
            hitEnemies.append(enemy)
          }
        }
        for enemy in hitEnemies {
          marioHit(enemy: enemy)
        }
      }
    
    
    func coinHit(enemy: SKSpriteNode) {
        
     //   run(coinCollisionSound)
       enemy.removeFromParent()
       coin += 1
        print(coin)
        
        finalScore = coin
          
      }
    
    
    
    
    
    
    
    
    
    func sceneTouched(touchLocation:CGPoint) {
    let actionJump : SKAction
    actionJump = SKAction.moveBy(x: 0, y: 350, duration: 0.7)
    let jumpSequence = SKAction.sequence([actionJump, actionJump.reversed()])
    mario.run(jumpSequence)
    
        
    }
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>,
         with event: UIEvent?) {
       guard let touch = touches.first else {
         return
       }
       let touchLocation = touch.location(in: self)
       sceneTouched(touchLocation: touchLocation)
     }
    
    
    
    

    
    
    
    
  override func update(_ currentTime: TimeInterval) {
  
    if lastUpdateTime > 0 {
      dt = currentTime - lastUpdateTime
    } else {
      dt = 0
    }
    lastUpdateTime = currentTime
  
    
      move(sprite: mario, velocity: velocity)
    moveCamera()
    livesLabel.text = "Lives: \(lives)"
    CoinLabel.text = "Coins: \(coin)"
    checkCollisions()
    
    if lives <= 0 && !gameOver {
      gameOver = true
      print("You lose!")
        print("Your Final Score is " + String(finalScore))
      backgroundMusicPlayer.stop()
        
        let gameOver = GameOverScene(size: size, won: false)
       // let gameOverScene = Gam(size: size, won: false)
        //gameOverScene.scaleMode = scaleMode
        gameOver.scaleMode = scaleMode
        // 2
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        // 3
        view?.presentScene(gameOver, transition: reveal)
      
    } else if finalScore>=3 {
            
    let gameOver = GameOverScene(size: size, won: true)
          // let gameOverScene = Gam(size: size, won: false)
           //gameOverScene.scaleMode = scaleMode
           gameOver.scaleMode = scaleMode
           // 2
           let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
           // 3
           view?.presentScene(gameOver, transition: reveal)
    }
    
  }
   
  
  
    
    
    
}
