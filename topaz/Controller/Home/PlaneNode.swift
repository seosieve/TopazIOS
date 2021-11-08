//
//  PlaneNode.swift
//  topaz
//
//  Created by 서충원 on 2021/11/08.
//

import SceneKit

class PlaneNode: SCNNode {
    override init() {
        super.init()
        let plane = SCNScene(named: "Assets.scnassets/Plane.scn")!
        let planeArr = plane.rootNode.childNodes
        planeArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
        
        let action = SCNAction.rotate(by: 520 * CGFloat(Double.pi / 360), around: SCNVector3(x: 1, y: 1, z: 1), duration: 8)
        let repeatAction = SCNAction.repeatForever(action)
        self.runAction(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
