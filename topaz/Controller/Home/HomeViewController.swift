//
//  HomeViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var IceBreakingLabel: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var alarmButton: UIBarButtonItem!
    @IBOutlet weak var friendslistButton: UIBarButtonItem!
    
    let userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        if Auth.auth().currentUser == nil {
            print("로그인된 유저 없음")
            instantiateVC()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNicknameLabel()
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
        let nickname = userdefault.string(forKey: "nickname")!
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
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

