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
        let earth = SCNScene(named: "Assets.scnassets/Earth.scn")!
        let earthArr = earth.rootNode.childNodes
        earthArr.forEach { childNode in
            self.addChildNode(childNode as SCNNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
