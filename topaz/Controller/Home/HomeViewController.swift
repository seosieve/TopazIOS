//
//  HomeViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase
import FirebaseAuth
import SceneKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var IceBreakingLabel: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var alarmButton: UIBarButtonItem!
    @IBOutlet weak var friendslistButton: UIBarButtonItem!
    @IBOutlet weak var sceneView: SCNView!
    
    let userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeNicknameLabel()
        
        
        let scene = SCNScene()
        
        let earthNode = EarthNode()
        earthNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(earthNode)
        
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light?.type = .omni
        lightNode1.position = SCNVector3(x: 5, y: 15, z: 5)
        scene.rootNode.addChildNode(lightNode1)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .omni
        lightNode2.position = SCNVector3(x: -3, y: -15, z: -3)
        scene.rootNode.addChildNode(lightNode2)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 1.5, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light?.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
//        scene.rootNode.addChildNode(lightNode)
        
        
        let stars = SCNParticleSystem(named: "Assets.scnassets/Stars.scnp", inDirectory: nil)!
        scene.rootNode.addParticleSystem(stars)
        

        sceneView.scene = scene
        sceneView.showsStatistics = false
//        sceneView.backgroundColor = UIColor(named: "Gray4")
        sceneView.allowsCameraControl = true
        sceneView.pointOfView = cameraNode
        

        
        
        
        
    }
}

//MARK: - UI Functions
extension HomeViewController {
    func addMultipleFonts(_ range: String) {
        let attributedString = NSMutableAttributedString(string: IceBreakingLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 22)!, range: (IceBreakingLabel.text! as NSString).range(of: range))
        IceBreakingLabel.attributedText = attributedString
    }
    
    func makeNicknameLabel() {
        let nickname = userdefault.string(forKey: "nickname") ?? ""
        IceBreakingLabel.text = "\(nickname)님, 꼭 멀리가야만\n좋은 여행은 아니에요!"
        addMultipleFonts(nickname)
        let nicknameCount = nickname.count
        switch nicknameCount {
        case 1:
            nicknameConstraintW.constant = CGFloat(23)
        case 2:
            nicknameConstraintW.constant = CGFloat(45)
        case 3:
            nicknameConstraintW.constant = CGFloat(67)
        case 4:
            nicknameConstraintW.constant = CGFloat(89)
        default:
            nicknameConstraintW.constant = CGFloat(0)
        }
        print("현재 로그인된 계정은 \(nickname)입니다.")
    }
}

