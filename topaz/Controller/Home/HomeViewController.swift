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
        makeEarthScene()
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        sceneView.addGestureRecognizer(pinchRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 닉네임 변경하면 바로 바꾸기 위해 viewWillAppear에 배치
        makeNicknameLabel()
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 1 {
            print("pinch recognize")
            let push = UNMutableNotificationContent()
            push.title = "test Title"
            push.subtitle = "test subTitle"
            push.body = "test body"
            push.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "test", content: push, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
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
    
    func makeEarthScene() {
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
        
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light?.type = .omni
        lightNode3.light?.intensity = 200
        lightNode3.position = SCNVector3(x: 10, y: 5, z: 10)
        scene.rootNode.addChildNode(lightNode3)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 1.5, z: 5)
        scene.rootNode.addChildNode(cameraNode)
    
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.pointOfView = cameraNode
    }
}


