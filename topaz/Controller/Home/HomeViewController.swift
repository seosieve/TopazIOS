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
    @IBOutlet weak var mainTopazLogo: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var upperBackgroundView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iceBreakingLabel: UILabel!
    @IBOutlet weak var iceBreakingLabelBorder: UIView!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var placeRecommendButton: UIButton!
    @IBOutlet weak var continentButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet var collectiblesContainer: UIView!
    @IBOutlet weak var collectiblesCompleteButton: UIButton!
    
    let userdefault = UserDefaults.standard
    let continent = Continent()
    let time = Time()
    var continentCount = 0
    let viewModel = HomeViewModel()
    let scene = SCNScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        addCollectiblesViewIfNeeded()
        let currentTime = time.convertTime(detectCurrentTime())
        makeViewByTime(currentTime)
        makeEarthScene(currentTime)
        makeShadow(target: placeRecommendButton, radius: 18)
        makeCircle(target: continentButton, color: "White", width: 2)
        makeShadow(target: continentButton, radius: 20, opacity: 0.8)
        goForwardButton.transform = goForwardButton.transform.rotated(by: .pi)
        makeCircle(target: goBackButton)
        makeShadow(target: goBackButton, radius: 16, opacity: 0.8)
        makeCircle(target: goForwardButton)
        makeShadow(target: goForwardButton, radius: 16, opacity: 0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 닉네임 변경하면 바로 바꾸기 위해 viewWillAppear에 배치
        makeNicknameLabel()
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 2 {
            print("pinch gesture recognize")
        }
    }
    
    @objc func panGesture(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        if gestureRecognize.numberOfTouches == 2 {
            print("aa")
        }
        let point = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(point, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            let continentTitle = result.node.geometry!.name!
            if continent.continentName.contains(continentTitle) {
                continentButton.setTitle(continentTitle, for: .normal)
                continentCount = continent.continentName.firstIndex(of: continentTitle)!
                print(continentTitle)
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSearch", sender: sender)
    }
    
    @IBAction func placeRecommendButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPlaceRecommend", sender: sender)
    }
    
    @IBAction func continentButtonPressed(_ sender: UIButton) {
        //아직 미구현
//        self.performSegue(withIdentifier: "goToContinent", sender: sender)
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        if continentCount == 0 {
            continentCount = 5
        } else {
            continentCount -= 1
        }
        let continentTitle = continent.continentName[continentCount]
        continentButton.setTitle(continentTitle, for: .normal)
    }
    
    @IBAction func goForwardButtonPressed(_ sender: UIButton) {
        if continentCount == 5 {
            continentCount = 0
        } else {
            continentCount += 1
        }
        let continentTitle = continent.continentName[continentCount]
        continentButton.setTitle(continentTitle, for: .normal)
    }
    
    @IBAction func collectiblesCompleteButtonPressed(_ sender: UIButton) {
        viewModel.addCollectibles()
        guard let dimView = self.tabBarController?.view.viewWithTag(100) else { return }
        UIView.transition(with: (self.tabBarController?.view)!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            dimView.removeFromSuperview()
            self.collectiblesContainer.removeFromSuperview()
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.topViewController as! ContinentRecommendViewController
            destinationVC.bySearchButton = true
        } else if segue.identifier == "goToContinent" {
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.topViewController as! ContinentRecommendViewController
            destinationVC.continent = continentButton.currentTitle!
        }
    }
}

//MARK: - UI Functions
extension HomeViewController {
    func addCollectiblesViewIfNeeded() {
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
        iceBreakingLabel.text = "\(nickname)님, 꼭 멀리가야만\n좋은 여행은 아니에요!"
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
        let attributedString = NSMutableAttributedString(string: iceBreakingLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 22)!, range: (iceBreakingLabel.text! as NSString).range(of: range))
        iceBreakingLabel.attributedText = attributedString
    }
    
    func detectCurrentTime() -> Int {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "H"
        let strDate = dateFormatter.string(from: date)
        return Int(strDate)!
    }
    
    func makeViewByTime(_ currentTime: String) {
        switch currentTime {
        case "Morning":
            self.view.backgroundColor = UIColor(named: "White")
            mainTopazLogo.image = UIImage(named: "TopazLogo-Home")
            searchButton.tintColor = UIColor(named: "Gray1")
            upperBackgroundView.backgroundColor = UIColor(named: "White")
            backgroundImage.image = UIImage(named: "MainBackgroundImage-Morning")
            iceBreakingLabel.textColor = UIColor(named: "Gray2")
            iceBreakingLabelBorder.backgroundColor = UIColor(named: "LightMintBlue")
            makeCircle(target: placeRecommendButton, color: "MintBlue", width: 1)
            placeRecommendButton.setTitleColor(UIColor(named: "MintBlue"), for: .normal)
        case "Evening":
            self.view.backgroundColor = UIColor(named: "EveningOrange")
            mainTopazLogo.image = UIImage(named: "TopazLogo-White")
            searchButton.tintColor = UIColor(named: "White")
            upperBackgroundView.backgroundColor = UIColor(named: "EveningOrange")
            backgroundImage.image = UIImage(named: "MainBackgroundImage-Evening")
            iceBreakingLabel.textColor = UIColor(named: "White")
            iceBreakingLabelBorder.backgroundColor = UIColor(named: "White")?.withAlphaComponent(0.3)
            makeCircle(target: placeRecommendButton, color: "EveningOrange", width: 1)
            placeRecommendButton.setTitleColor(UIColor(named: "EveningOrange"), for: .normal)
        default:
            self.view.backgroundColor = UIColor(named: "NightBlue")
            mainTopazLogo.image = UIImage(named: "TopazLogo-White")
            searchButton.tintColor = UIColor(named: "White")
            upperBackgroundView.backgroundColor = UIColor(named: "NightBlue")
            backgroundImage.image = UIImage(named: "MainBackgroundImage-Night")
            iceBreakingLabel.textColor = UIColor(named: "White")
            iceBreakingLabelBorder.backgroundColor = UIColor(named: "MintBlue")?.withAlphaComponent(0.3)
            makeCircle(target: placeRecommendButton, color: "NightBlue", width: 1)
            placeRecommendButton.setTitleColor(UIColor(named: "NightBlue"), for: .normal)
        }
    }
    
    func makeEarthScene(_ currentTime: String) {
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
        
        let mainLightNode1 = SCNNode()
        mainLightNode1.light = SCNLight()
        mainLightNode1.light?.type = .omni
        mainLightNode1.light?.intensity = 600
        mainLightNode1.position = SCNVector3(x: 10, y: 0, z: 10)
        scene.rootNode.addChildNode(mainLightNode1)
        
        let mainLightNode2 = SCNNode()
        mainLightNode2.light = SCNLight()
        mainLightNode2.light?.type = .omni
        mainLightNode2.light?.intensity = 600
        mainLightNode2.position = SCNVector3(x: -10, y: 0, z: -10)
        scene.rootNode.addChildNode(mainLightNode2)
        
        let subLightNode1 = SCNNode()
        subLightNode1.light = SCNLight()
        subLightNode1.light?.type = .omni
        subLightNode1.position = SCNVector3(x: -10, y: 30, z: 10)
        scene.rootNode.addChildNode(subLightNode1)
        
        let subLightNode2 = SCNNode()
        subLightNode2.light = SCNLight()
        subLightNode2.light?.type = .omni
        subLightNode2.position = SCNVector3(x: 10, y: -30, z: -10)
        scene.rootNode.addChildNode(subLightNode2)
        
        let colorLightNode = SCNNode()
        colorLightNode.light = SCNLight()
        colorLightNode.light?.type = .omni
        colorLightNode.light?.intensity = 100
        switch currentTime {
        case "Morning":
            colorLightNode.light?.color = UIColor(named: "MintBlue")!
        case "Evening":
            colorLightNode.light?.color = UIColor(named: "WarningRed")!
        default:
            colorLightNode.light?.color = UIColor(named: "MintBlue")!
            colorLightNode.light?.intensity = 200
            mainLightNode2.removeFromParentNode()
            mainLightNode1.removeFromParentNode()
        }
        colorLightNode.position = SCNVector3(x: -5, y: 5, z: 1)
        scene.rootNode.addChildNode(colorLightNode)
    
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.cameraControlConfiguration.allowsTranslation = true
        sceneView.cameraControlConfiguration.panSensitivity = 0.15
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.15
        blockUserGesture()
        addTapRecognizer()
        sceneView.alpha = 0
        backgroundImage.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.sceneView.alpha = 1
            self.backgroundImage.alpha = 1
        }
    }
    
    func blockUserGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        //FIX - 드래그(pan) 1손가락만 되게하고 2손가락 disable, rotate만 완전 막으면 완벽할듯 - enable찾기
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        sceneView.addGestureRecognizer(pinch)
//        sceneView.addGestureRecognizer(pan)
    }
    
    func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
    }
}






    


