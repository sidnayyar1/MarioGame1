//
//  GameViewController.swift
//  MarioGame1
//
//  Created by Sidharth Nayyar on 6/15/20.
//  Copyright © 2020 Sidharth Nayyar. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let scene =
      GameScene(size:CGSize(width: 2048, height: 1536))
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .aspectFill
    skView.presentScene(scene)
  }
  override var prefersStatusBarHidden: Bool {
return true
}
    
}
