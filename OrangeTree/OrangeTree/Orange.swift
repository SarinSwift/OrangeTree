//
//  Orange.swift
//  OrangeTree
//
//  Created by Sarin Swift on 9/19/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import SpriteKit

class Orange: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Orange")
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

