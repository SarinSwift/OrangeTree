//
//  GameScene.swift
//  OrangeTree
//
//  Created by Sarin Swift on 9/19/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    // we don't create an SKSpriteNode here because there's nothing visible on the screen that will be displayed
    // SKNode acts like an empty node where you can give it a physics body
    var boundary = SKNode()
    
    var numOfLevels: UInt32 = 2
    
    // This loads the sks files
    static func Load(level: Int) -> GameScene? {
        return GameScene(fileNamed: "Level-\(level)")
    }
    
    
    override func didMove(to view: SKView) {
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
        
        // put together the shapeNode
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        // setting the contact delegate
        physicsWorld.contactDelegate = self
        
        // setting up the boundaries
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        boundary.position = .zero
        addChild(boundary)
        
        // Add the sun  to scene to change to next level
        let sun = SKSpriteNode(imageNamed: "Sun")
        sun.name = "sun"
        sun.position.x = size.width - (sun.size.width * 0.75)
        sun.position.y = size.height - (sun.size.height * 0.75)
        addChild(sun)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get location of touch on the screen
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // check if the touch was on the orange tree
        if atPoint(location).name == "tree" {
            // create the orange
            // add it to the scene at the touch location
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            // stores the location of touch for later
            touchStart = location
        }
        
        for node in nodes(at: location) {
            if node.name == "sun" {
                let n = Int(arc4random() % numOfLevels + 1)
                if let scene = GameScene.Load(level: n) {
                    scene.scaleMode = .aspectFill
                    if let view = view {
                        view.presentScene(scene)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the location of the touch
        let touches = touches.first!
        let location = touches.location(in: self)
        
        // update the position of the orange to the current location
        orange?.position = location
        
        // draw the firing vector
        let path = UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        shapeNode.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get location of where touch ended
        let touches = touches.first!
        let location = touches.location(in: self)
        
        // get difference between start and end point
        let dx = (touchStart.x - location.x) * 0.5
        let dy = (touchStart.y - location.y) * 0.5
        let vector = CGVector(dx: dx, dy: dy)
        
        // set orange dynamic again and apply the impulse
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        
        // removes the line when touches end
        shapeNode.path = nil
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    // calls this when the physicsWorld detects 2 nodes colliding
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        // need to check that the bodies collided hard enough
        if contact.collisionImpulse > 15 {
            if nodeA?.name == "skull" {
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                removeSkull(node: nodeB!)
            }
        }
    }
    
    // removes the skull node from the scene
    func removeSkull(node: SKNode) {
        node.removeFromParent()
    }
}











