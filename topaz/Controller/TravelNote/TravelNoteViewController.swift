//
//  TravelNoteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import FirebaseAuth

class TravelNoteViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var myProfileEditButton: UIButton!
    @IBOutlet weak var collection1: UIButton!
    @IBOutlet weak var collection2: UIButton!
    @IBOutlet weak var collection3: UIButton!
    @IBOutlet weak var collection4: UIButton!
    @IBOutlet weak var collection5: UIButton!
    
    let viewModel = TravelNoteViewModel()
    let userdefault = UserDefaults.standard
    //false로 바꾸고 데이터 받아오기
    var isProfileChange = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        makeCircle(target: profileImage, color: "Gray6", width: 1)
        makeBorder(target: myProfileEditButton, radius: 12, isFilled: false)
        makeCircle(target: collection1, color: "MintBlue", width: 0)
        makeCircle(target: collection2, color: "MintBlue", width: 0)
        makeCircle(target: collection3, color: "MintBlue", width: 0)
        makeCircle(target: collection4, color: "MintBlue", width: 0)
        makeCircle(target: collection5, color: "MintBlue", width: 0)
        makeShadow(target: collection1, radius: collection1.frame.size.height/2)
        makeShadow(target: collection2, radius: collection2.frame.size.height/2)
        makeShadow(target: collection3, radius: collection3.frame.size.height/2)
        makeShadow(target: collection4, radius: collection4.frame.size.height/2)
        makeShadow(target: collection5, radius: collection5.frame.size.height/2)
        
        makeProfile()
    }
    
    @IBAction func mySettingPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToMySetting", sender: sender)
    }
    
    @IBAction func myProfileEditButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMyProfileEdit", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyProfileEdit" {
            let destinationVC = segue.destination as! MyProfileEditViewController
            destinationVC.delegate = self
        }
    }
}
//MARK: - UI Functions
extension TravelNoteViewController {
    func makeProfile() {
        if Auth.auth().currentUser != nil {
            profileImage.image = UIImage(named: "DefaultUserImage")
            nickname.text = userdefault.string(forKey: "nickname")!
            email.text = userdefault.string(forKey: "email")!
            introduce.text = userdefault.string(forKey: "introduce")!
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
            viewModel.getUserImage(email: userdefault.string(forKey: "email")!) { image in
                self.profileImage.image = image
            }
        }
    }
}

//MARK: - EditDelegate
extension TravelNoteViewController: EditDelegate {
    func profileChange(_ dataChanged: Bool, _ imageChanged: Bool) {
        if dataChanged {
            makeProfile()
        }
        if imageChanged {
            viewModel.getUserImage(email: userdefault.string(forKey: "email")!) { image in
                self.profileImage.image = image
            }
        }
    }
}
