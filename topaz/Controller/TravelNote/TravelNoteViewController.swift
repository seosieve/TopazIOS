//
//  TravelNoteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import FirebaseAuth
import Lottie
import Kingfisher

class TravelNoteViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var nicknameConstraintW: NSLayoutConstraint!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var myProfileEditButton: UIButton!
    @IBOutlet weak var myProfileContainer: UIView!
    
    let viewModel = TravelNoteViewModel()
    let userdefault = UserDefaults.standard
    
    var imageUrl: String?
    var exp: Int?
    var collectibles: [String]?
    var topazAlbumUrl: [String]?
    let backgroundView = UIView()
    let lottieView = AnimationView(name: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        loadingAnimation(backgroundView, lottieView, view: self.view)
        makeCircular(target: myProfileContainer, each: true)
        makeCircle(target: profileImage, color: "Gray6", width: 1)
        makeBorder(target: myProfileEditButton, radius: 12, isFilled: false)
        viewModel.getUserDataBase(email: userdefault.string(forKey: "email")!) { imageUrl, exp, collectibles, topazAlbumUrl in
            self.imageUrl = imageUrl
            self.exp = exp
            self.collectibles = collectibles
            self.topazAlbumUrl = topazAlbumUrl
            self.makeUserProfile()
            self.makeUserImage()
            self.backgroundView.removeFromSuperview()
            self.lottieView.removeFromSuperview()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyProfileEdit" {
            let destinationVC = segue.destination as! MyProfileEditViewController
            destinationVC.imageUrl = imageUrl
            destinationVC.delegate = self
        }
    }
}

//MARK: - UI Functions
extension TravelNoteViewController {
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
