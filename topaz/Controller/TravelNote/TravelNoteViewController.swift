//
//  TravelNoteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase
import Lottie
import Kingfisher

class TravelNoteViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var myProfileEditButton: UIButton!
    @IBOutlet weak var travelClass: UILabel!
    @IBOutlet var expContainer: [UIView]!
    @IBOutlet var expProgress: [UIView]! {
        didSet {expProgress.sort{$0.tag < $1.tag}}
    }
    @IBOutlet var expressHandle: [UIView]! {
        didSet {expressHandle.sort{$0.tag < $1.tag}}
    }
    @IBOutlet weak var travelClassDetail: UILabel!
    @IBOutlet weak var myProfileContainer: UIView!
    @IBOutlet weak var travelAlbumButton: UIButton!
    @IBOutlet weak var travelAlbumUnderLine: UIView!
    @IBOutlet weak var travelTicketButton: UIButton!
    @IBOutlet weak var travelTicketUnderLine: UIView!
    @IBOutlet weak var travelCollectiblesButton: UIButton!
    @IBOutlet weak var travelCollectiblesUnderLine: UIView!
    
    let viewModel = TravelNoteViewModel()
    var travelPageViewController: TravelPageViewController!
    let userdefault = UserDefaults.standard
    
    var imageUrl: String?
    let backgroundView = UIView()
    let lottieView = LottieAnimationView(name: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        loadingAnimation(backgroundView, lottieView, view: self.view)
        makeTravelNoteUI()
        makeUserProfile()
        viewModel.getUserImage() { imageUrl in
            self.imageUrl = imageUrl
            self.makeUserImage()
        }
        addUserClassSnapshot()
        self.backgroundView.removeFromSuperview()
        self.lottieView.removeFromSuperview()
    }
    
    @IBAction func myArticlePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMyArticle", sender: sender)
    }
    
    @IBAction func mySettingPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMySetting", sender: sender)
    }
    
    @IBAction func myProfileEditButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMyProfileEdit", sender: sender)
    }
    
    @IBAction func travelAlbumButtonPressed(_ sender: UIButton) {
        travelPageViewController.moveFromIndex(index: 0, forward: false)
        transferTravel(index: 0)
    }
    
    @IBAction func travelTicketButtonPressed(_ sender: UIButton) {
        if travelAlbumButton.titleLabel?.textColor == UIColor(named: "Gray1") {
            travelPageViewController.moveFromIndex(index: 1)
        } else {
            travelPageViewController.moveFromIndex(index: 1, forward: false)
        }
        transferTravel(index: 1)
    }
    
    @IBAction func travelCollectiblesButtonPressed(_ sender: UIButton) {
        travelPageViewController.moveFromIndex(index: 2)
        transferTravel(index: 2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyProfileEdit" {
            let destinationVC = segue.destination as! MyProfileEditViewController
            destinationVC.imageUrl = imageUrl
            destinationVC.delegate = self
        } else if segue.identifier == "goToPageVC" {
            let destinationVC = segue.destination as! TravelPageViewController
            travelPageViewController = destinationVC
            destinationVC.travelDelegate = self
        }
    }
}

//MARK: - UI Functions
extension TravelNoteViewController {
    func makeTravelNoteUI() {
        makeCircular(target: myProfileContainer, each: true)
        makeCircle(target: profileImage, color: "Gray6", width: 1)
        expContainer.forEach { container in
            makeCircle(target: container)
        }
        expProgress.forEach { progress in
            makeCircle(target: progress)
        }
        expressHandle.forEach { handle in
            makeCircle(target: handle)
        }
        makeBorder(target: myProfileEditButton, radius: 12, isFilled: false)
    }
    
    func makeCircular(target view: UIView, each: Bool) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        if each {
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    func addMultipleFonts(label: UILabel, _ range: String) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Regular", size: 12)!, range: (label.text! as NSString).range(of: range))
        label.attributedText = attributedString
    }
    
    func addUserClassSnapshot() {
        let email = userdefault.string(forKey: "email")!
        let database = Firestore.firestore()
        let collection = database.collection("UserDataBase")
            collection.document(email).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("스냅샷 리스너 에러 : \(error)")
            } else {
                if let document = documentSnapshot {
                    let exp = document.get("exp") as! Int
                    self.makeUserClass(exp: exp)
                }
            }
        }
    }
    
    func makeUserClass(exp: Int) {
        let maxWidth = expProgress[0].superview!.frame.width
        
        if exp < 100 {
            travelClass.text = "이코노미 클래스"
            travelClassDetail.text = "비즈니스 클래스까지 \(100 - exp)%"
            addMultipleFonts(label: travelClassDetail, "까지")
            expProgress[0].isHidden = false; expressHandle[0].isHidden = false
            expProgress[1].isHidden = true
            expProgress[2].isHidden = true
            expProgress[0].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    if exp <= 8 {
                        constraint.constant = 8
                    } else {
                        constraint.constant = CGFloat(exp) * (maxWidth / 99)
                    }
                }
            }
        } else if 100 <= exp && exp < 200 {
            travelClass.text = "비즈니스 클래스"
            travelClassDetail.text = "퍼스트 클래스까지 \(200 - exp)%"
            addMultipleFonts(label: travelClassDetail, "까지")
            expProgress[0].isHidden = false; expressHandle[0].isHidden = true
            expProgress[1].isHidden = false; expressHandle[1].isHidden = false
            expProgress[2].isHidden = true
            expProgress[0].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
            expProgress[1].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    if exp - 100 <= 8 {
                        constraint.constant = 8
                    } else {
                        constraint.constant = CGFloat(exp - 100) * (maxWidth / 99)
                    }
                }
            }
        } else if 200 <= exp && exp < 300 {
            travelClass.text = "퍼스트 클래스"
            travelClassDetail.text = "마스터 클래스까지 \(300 - exp)%"
            addMultipleFonts(label: travelClassDetail, "까지")
            expProgress[0].isHidden = false; expressHandle[0].isHidden = true
            expProgress[1].isHidden = false; expressHandle[1].isHidden = true
            expProgress[2].isHidden = false
            expProgress[0].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
            expProgress[1].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
            expProgress[2].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    if exp - 200 <= 8 {
                        constraint.constant = 8
                    } else {
                        constraint.constant = CGFloat(exp - 200) * (maxWidth / 99)
                    }
                }
            }
        } else {
            travelClass.text = "마스터 클래스"
            travelClassDetail.text = "토파즈의 지배자"
            expProgress[0].isHidden = false; expressHandle[0].isHidden = true
            expProgress[1].isHidden = false; expressHandle[1].isHidden = true
            expProgress[2].isHidden = false
            expProgress[0].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
            expProgress[1].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
            expProgress[2].constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = maxWidth
                }
            }
        }
    }
    
    func makeUserProfile() {
        if Auth.auth().currentUser != nil {
            nickname.text = userdefault.string(forKey: "nickname")!
            email.text = userdefault.string(forKey: "email")!
            introduce.text = userdefault.string(forKey: "introduce")!
            makeNicknameLabel()
        }
    }
    
    func makeNicknameLabel() {
        let nicknameCount = nickname.text!.count
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
    }
    
    func makeUserImage() {
        let url = URL(string: imageUrl!)!
        profileImage.kf.setImage(with: url)
    }
}

//MARK: - EditDelegate
extension TravelNoteViewController: EditDelegate {
    func profileChange(url: String, _ dataChanged: Bool, _ imageChanged: Bool) {
        self.imageUrl = url
        if dataChanged {
            makeUserProfile()
        }
        if imageChanged {
            makeUserImage()
        }
    }
}

//MARK: - transferTravelDelegate
extension TravelNoteViewController: transferTravelDelegate {
    func transferTravel(index: Int) {
        let activeFont = UIFont(name: "NotoSansKR-Bold", size: 16)!
        let inactiveFont = UIFont(name: "NotoSansKR-Regular", size: 16)!
        let activeColor = UIColor(named: "Gray1")!
        let inactiveColor = UIColor(named: "Gray4")!
        var font = [inactiveFont, inactiveFont, inactiveFont]
        var color = [inactiveColor, inactiveColor, inactiveColor]
        var alpha: [CGFloat] = [0, 0, 0]
        font[index] = activeFont
        color[index] = activeColor
        alpha[index] = 1
        travelAlbumButton.titleLabel?.font = font[0]
        travelTicketButton.titleLabel?.font = font[1]
        travelCollectiblesButton.titleLabel?.font = font[2]
        travelAlbumButton.setTitleColor(color[0], for: .normal)
        travelTicketButton.setTitleColor(color[1], for: .normal)
        travelCollectiblesButton.setTitleColor(color[2], for: .normal)
        travelAlbumUnderLine.alpha = alpha[0]
        travelTicketUnderLine.alpha = alpha[1]
        travelCollectiblesUnderLine.alpha = alpha[2]
    }
}
