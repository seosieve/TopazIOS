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
    @IBOutlet var collectionArray: [UIButton]! {
        didSet {collectionArray.sort {$0.tag < $1.tag}}
    }
    
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
        makeCircle(target: profileImage, color: "Gray6", width: 1)
        makeBorder(target: myProfileEditButton, radius: 12, isFilled: false)
        collectionArray.forEach { collection in
            makeCircle(target: collection, color: "MintBlue", width: 0)
            makeShadow(target: collection, radius: collection.frame.size.height/2, width: 3, height: 3, opacity: 0.2)
        }
        viewModel.getUserDataBase(email: userdefault.string(forKey: "email")!) { imageUrl, exp, collectibles, topazAlbumUrl in
            self.imageUrl = imageUrl
            self.exp = exp
            self.collectibles = collectibles
            self.topazAlbumUrl = topazAlbumUrl
            self.makeUserProfile()
            self.makeUserImage {
                self.backgroundView.removeFromSuperview()
                self.lottieView.removeFromSuperview()
            }
        }
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
    
    func makeUserImage(userImageHandler: @escaping () -> ()) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: 96, height: 96))
        let url = URL(string: imageUrl!)!
        profileImage.kf.setImage(with:url, options: [.processor(processor)])
        userImageHandler()
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
            loadingAnimation(backgroundView, lottieView, view: self.view)
            makeUserImage{
                self.backgroundView.removeFromSuperview()
                self.lottieView.removeFromSuperview()
            }
        }
    }
}
