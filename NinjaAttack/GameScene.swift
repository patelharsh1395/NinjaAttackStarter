

import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}


class GameScene: SKScene {
      let player = SKSpriteNode(imageNamed: "soldier")
      let player2 = SKSpriteNode(imageNamed: "player2")
  
  
  var counter = 0;
  
  var timer: Timer?
      var totalTime = 60

      private func startOtpTimer() {
             self.totalTime = 60
             self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
         }

     @objc func updateTimer() {
             print(self.totalTime)
             //self.lblTimer.text = self.timeFormatted(self.totalTime) // will show timer
             if totalTime != 0 {
                 totalTime -= 1  // decrease counter timer
             } else {
                 if let timer = self.timer {
                     timer.invalidate()
                     self.timer = nil
                 }
             }
         }
     func timeFormatted(_ totalSeconds: Int) -> String {
         let seconds: Int = totalSeconds % 60
         let minutes: Int = (totalSeconds / 60) % 60
         return String(format: "%02d:%02d", minutes, seconds)
     }
  
      var monstersDestroyed = 0
  var score = 0;
  
      override func didMove(to view: SKView) {
        // 2
        backgroundColor = SKColor.white
        // 3
//        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        player.position = CGPoint(x: size.height * 0.2, y: size.width * 0.1)
        player2.position = CGPoint(x: size.height * 1.5, y: size.width * 0.1)
        // 4
        addChild(player)
        addChild(player2)
        physicsWorld.gravity = .zero
               physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addMonster),
            SKAction.wait(forDuration: 1.0)
            ])
        ))
        
        
        
       
        

        
       
      }
  
      func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
      }

      func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
      }

      func addMonster() {
        
        
        if(counter == 0)
        {
          counter+=1;
          startOtpTimer();
        }
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        // Determine where to spawn the monster along the Y axis
//        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        let actualY = random(min: monster.size.width/2, max: size.width - monster.size.height/2)
               
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
//        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
         monster.position = CGPoint(x: actualY, y:size.width + monster.size.width/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
     //   let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
//        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY),
//                                       duration: TimeInterval(actualDuration))
        
        
        
        
        
//         let actionMove = SKAction.move(to: CGPoint(x:actualY, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
//        //                                       duration: TimeInterval(actualDuration))
//        let actionMoveDone = SKAction.removeFromParent()
        
//        ******
        let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/4)
        
        let  actualDuration = random(min: CGFloat(4.0), max: CGFloat(8.0))
              // Create the actions
                      let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height * 8.0 ),
                              duration: TimeInterval(actualDuration))
                      let actionMoveDone = SKAction.removeFromParent()
        
        
        
        
//       let loseAction = SKAction.run() { [weak self] in
//          guard let `self` = self else { return }
//          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//        let gameOverScene = GameOverScene(size: self.size, won: self.score)
//          self.view?.presentScene(gameOverScene, transition: reveal)
//        }
    //   monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
          monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5

        
      }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in (touches as! Set<UITouch>)
      {
        let location = touch.location(in: self)
        if location.x < self.frame.size.width / 2 {
            if player.contains(location)
            {
              player.position = location
            }
        } else {
           if player2.contains(location)
           {
             player2.position = location
           }
        }
        
      }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in (touches as! Set<UITouch>)
      {
//        let location = touch.location(in: self)
//
//        if player.contains(location)
//        {
//          player.position = location
//        }
        
        let location = touch.location(in: self)
        if location.x < self.frame.size.width / 2 {
            if player.contains(location)
            {
              player.position = location
            }
        } else {
           if player2.contains(location)
           {
             player2.position = location
           }
        }
      }
    }
  
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       // 1 - Choose one of the touches to work with
       guard let touch = touches.first else {
         return
       }
      //run(SKAction.playSoundFileNamed("Loud_Bang.mp3", waitForCompletion: false))

       let touchLocation = touch.location(in: self)
       
      
      
      
       // 2 - Set up initial location of projectile
       let projectile = SKSpriteNode(imageNamed: "bomb")
      if touchLocation.x < self.frame.size.width / 2 {
           projectile.position = player.position
      } else {
          projectile.position = player2.position
      }
      
      
//      let projectile2 = SKSpriteNode(imageNamed: "bomb")
//            projectile.position = player2.position
        
       
       // 3 - Determine offset of location to projectile
     // var offset : CGPoint;
     
      let offset = touchLocation - projectile.position
       
       // 4 - Bail out if you are shooting down or backwards
       //if offset.x < 0 { return }
       
       // 5 - OK to add now - you've double checked position
       addChild(projectile)
       
       // 6 - Get the direction of where to shoot
       let direction = offset.normalized()
       
       // 7 - Make it shoot far enough to be guaranteed off screen
       let shootAmount = direction * 1000
       
       // 8 - Add the shoot amount to the current position
       let realDest = shootAmount + projectile.position
       
       // 9 - Create the actions
       let actionMove = SKAction.move(to: realDest, duration: 2.0)
       let actionMoveDone = SKAction.removeFromParent()
       projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
      
      projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
      projectile.physicsBody?.isDynamic = true
      projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
      projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
      projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
      projectile.physicsBody?.usesPreciseCollisionDetection = true
     }
    


      
}
extension GameScene: SKPhysicsContactDelegate {
  
  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster:SKSpriteNode) {
    print("Hit")
    run(SKAction.playSoundFileNamed("Glass_Break.mp3", waitForCompletion: false))
    projectile.removeFromParent()
    monster.removeFromParent()
    score += 1;
    monstersDestroyed += 1
    if totalTime < 30 {
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: score);
      view?.presentScene(gameOverScene, transition: reveal)
    }
  }
  //**
  func didBegin(_ contact: SKPhysicsContact) {
    // 1
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
   
    // 2
    if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let monster = firstBody.node as? SKSpriteNode,
        let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithMonster(projectile: projectile, monster: monster)
      }
    }
  }


}
