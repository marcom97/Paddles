//
//  GameScene.swift
//  Paddles
//
//  Created by Marco Matamoros on 2016-09-05.
//  Copyright © 2016 Blue Stars. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var scaleFactor : CGFloat?
    private var upPaddle : SKSpriteNode?
    private var downPaddle : SKSpriteNode?
    private var background : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        scaleFactor = self.size.width/view.frame.width
        
        upPaddle = self.childNode(withName: "upPaddle") as? SKSpriteNode
        downPaddle = self.childNode(withName: "downPaddle") as? SKSpriteNode
        background = self.childNode(withName: "background") as? SKSpriteNode
        
        scaleFactor! > CGFloat(1) ? self.size.height = view.frame.height * scaleFactor! : ()

        
//        upPaddle?.position.y = view.convert(CGPoint(x: 0, y: (view.frame.size.height - (upPaddle?.size.height)!/2) * scaleFactor!), to: self).y
//        downPaddle?.position.y = view.convert(CGPoint(x: 0, y: (upPaddle?.size.height)!/2 * scaleFactor!), to: self).y

        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        upPaddle?.position.y = self.size.height/2 - (upPaddle?.size.width)!/2
        downPaddle?.position.y = -self.size.height/2 + (downPaddle?.size.width)!/2
        
        background?.setScale(scaleFactor!)

    }
    
    func convert(_ point:CGPoint) -> CGPoint{
        return self.view!.convert(CGPoint(x: point.x * scaleFactor!, y: self.view!.frame.height - point.y * scaleFactor!), to: self)
    }
}
