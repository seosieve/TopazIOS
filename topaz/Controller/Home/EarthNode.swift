//
//  EarthNode.swift
//  topaz
//
//  Created by 서충원 on 2021/10/06.
//

import SceneKit

class EarthNode: SCNNode {
    override init() {
        super.init()
        let earthBound = SCNScene(named: "Assets.scnassets/earth_isolate.scn")!
        let earthBoundArr = earthBound.rootNode.childNodes
        earthBoundArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
        
        let earth = SCNScene(named: "Assets.scnassets/Earth.scn")!
        let earthArr = earth.rootNode.childNodes
        earthArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
        
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 360), around: SCNVector3(x: 0, y: 1, z: 0), duration: 8)
        let repeatAction = SCNAction.repeatForever(action)
        self.runAction(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
