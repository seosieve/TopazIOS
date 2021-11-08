//
//  CloudsNode.swift
//  topaz
//
//  Created by 서충원 on 2021/11/08.
//

import SceneKit

class CloudsNode: SCNNode {
    override init() {
        super.init()
        let clouds = SCNScene(named: "Assets.scnassets/Clouds.scn")!
        let cloudsArr = clouds.rootNode.childNodes
        cloudsArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
        
        let action = SCNAction.rotate(by: 180 * CGFloat(Double.pi / 360), around: SCNVector3(x: 0, y: 1, z: 0), duration: 8)
        let repeatAction = SCNAction.repeatForever(action)
        self.runAction(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
