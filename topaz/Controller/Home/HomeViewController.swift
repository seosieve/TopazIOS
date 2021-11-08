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
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var IceBreakingLabel: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var alarmButton: UIBarButtonItem!
    @IBOutlet weak var friendslistButton: UIBarButtonItem!
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet var collectiblesContainer: UIView!
    @IBOutlet weak var collectiblesCompleteButton: UIButton!
    
    let userdefault = UserDefaults.standard
    let viewModel = HomeViewModel()
    let scene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        backgroundView.setHomeBackgroundGradient()
        addCollectiblesView()
        makeEarthScene()
        blockUserGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 닉네임 변경하면 바로 바꾸기 위해 viewWillAppear에 배치
        makeNicknameLabel()
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 1 {
            print("pinch gesture recognize")
        }
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        if(sender.state == .ended) {
            let earthNode = scene.rootNode.childNode(withName: "earth", recursively: true)!
            let currentPivot = earthNode.pivot
            let changePivot = SCNMatrix4Invert(earthNode.transform)
            earthNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            earthNode.transform = SCNMatrix4Identity
            print("aa")
        }
    }
    
    @IBAction func collectiblesCompleteButtonPressed(_ sender: UIButton) {
        viewModel.addCollectibles()
        guard let dimView = self.tabBarController?.view.viewWithTag(100) else { return }
        UIView.transition(with: (self.tabBarController?.view)!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            dimView.removeFromSuperview()
            self.collectiblesContainer.removeFromSuperview()
        }, completion: nil)
    }
}

//MARK: - UI Functions
extension HomeViewController {
    func addCollectiblesView() {
        let collectibles = userdefault.stringArray(forKey: "collectibles")!
        if !collectibles.contains("welcomeSnowBall") {
            // Background Dim
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            let dimView = UIVisualEffectView()
            dimView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            dimView.tag = 100
            self.tabBarController?.view.addSubview(dimView)
            UIView.animate(withDuration: 1.0) {
                dimView.effect = UIBlurEffect(style: .systemChromeMaterialDark)
            }
            // collectiblesView
            collectiblesContainer.frame = CGRect(x: 0, y: 0, width: width - 40, height: 1.5 * (width - 40))
            collectiblesContainer.center = CGPoint(x: width/2, y: height/2)
            self.tabBarController?.view.addSubview(collectiblesContainer)
            makeBorder(target: collectiblesContainer, radius: 28, isFilled: true)
            makeBorder(target: collectiblesCompleteButton, radius: 12, isFilled: true)
            collectiblesContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            collectiblesContainer.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.collectiblesContainer.alpha = 1
                self.collectiblesContainer.transform = CGAffineTransform.identity
            }
        }
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
    
    func addMultipleFonts(_ range: String) {
        let attributedString = NSMutableAttributedString(string: IceBreakingLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 22)!, range: (IceBreakingLabel.text! as NSString).range(of: range))
        IceBreakingLabel.attributedText = attributedString
    }
    
    func makeEarthScene() {
        
        let earthNode = EarthNode()
        earthNode.position = SCNVector3(x: 0, y: 0, z: 0)
        earthNode.name = "earth"
        scene.rootNode.addChildNode(earthNode)
        
        let cloudsNode = CloudsNode()
        cloudsNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cloudsNode)
        
        let planeNode = PlaneNode()
        planeNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(planeNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 1.5, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        
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
        lightNode3.light?.color = UIColor(named: "MintBlue")!
        lightNode3.position = SCNVector3(x: 10, y: 5, z: 10)
        scene.rootNode.addChildNode(lightNode3)
    
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.pointOfView = cameraNode
        sceneView.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.sceneView.alpha = 1
        }
    }
    
    func blockUserGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        sceneView.addGestureRecognizer(pinch)
        sceneView.addGestureRecognizer(pan)
    }
}

//MARK: - UIView
extension UIView {
    func setHomeBackgroundGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradient"
        let topColor = UIColor(named: "White")!
        let bottomColor = UIColor(named: "LightMintBlue")!
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}


