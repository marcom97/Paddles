//
//  GameScene.swift
//  Paddles
//
//  Created by Marco Matamoros on 2016-09-05.
//  Copyright © 2016 Blue Stars. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Category {
    static let paddle:UInt32 = 0b1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var scaleFactor : CGFloat?
    private var upPaddle : SKSpriteNode?
    private var downPaddle : SKSpriteNode?
    private var leftPaddle : SKSpriteNode?
    private var rightPaddle : SKSpriteNode?
    private var paddleForTouch : [UITouch : SKSpriteNode]?
    private var background : SKSpriteNode?
    private var ball : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        scaleFactor = self.size.width/view.frame.width
        upPaddle = self.childNode(withName: "uPaddle") as? SKSpriteNode
        downPaddle = self.childNode(withName: "dPaddle") as? SKSpriteNode
        leftPaddle = self.childNode(withName: "lPaddle") as? SKSpriteNode
        rightPaddle = self.childNode(withName: "rPaddle") as? SKSpriteNode
        ball = self.childNode(withName: "ball") as? SKSpriteNode
        paddleForTouch = [:]
        background = self.childNode(withName: "background") as? SKSpriteNode
        
        physicsWorld.contactDelegate = self
        
        scaleFactor! > CGFloat(1) ? self.size.height = view.frame.height * scaleFactor! : ()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & Category.paddle != 0) && (secondBody.categoryBitMask & Category.paddle != 0) {
            if (contact.contactPoint.x < (upPaddle?.size.width)! || contact.contactPoint.x > (upPaddle?.size.width)!) {
                print(contact.contactPoint)
            }
        }
    }
    
    func movePaddleFor(_ touch: UITouch){
        if let paddle = paddleForTouch?[touch]{
            let location = touch.location(in: self)
            let lastLocation = touch.previousLocation(in: self)
            
            if (paddle.name == "uPaddle" || paddle.name == "dPaddle"){
                var displacement = paddle.position.x + (location.x - lastLocation.x)
                displacement = max(displacement, paddle.size.height/2)
                displacement = min(displacement, size.width - paddle.size.height/2)
                paddle.position.x = displacement
            }
                
            else {
                var displacement = paddle.position.y + (location.y - lastLocation.y)
                displacement = max(displacement, paddle.size.height/2)
                displacement = min(displacement, size.height - paddle.size.height/2)
                paddle.position.y = displacement
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.nodes(at: location).first as? SKSpriteNode {
                if (node.name?.substring(from: (node.name?.index((node.name?.startIndex)!, offsetBy: 1))!) == "Paddle") {
                    paddleForTouch?[touch] = node
                }
            }
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            movePaddleFor(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            paddleForTouch?[touch] = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            paddleForTouch?[touch] = nil
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        upPaddle?.position.y = self.size.height - (upPaddle?.size.width)!/2
        downPaddle?.position.y = (downPaddle?.size.width)!/2
        
        let heightChange = (self.size.height - oldSize.height)/2
        
        background?.position.y += heightChange
        leftPaddle?.position.y += heightChange
        rightPaddle?.position.y += heightChange
        ball?.position.y += heightChange
        
        background?.setScale(scaleFactor!)
        
    }
    
}
