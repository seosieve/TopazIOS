//
//  CompleteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/18.
//

import UIKit
import Lottie

class CompleteViewController: UIViewController {
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeAnimationContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    let viewModel = CompleteViewModel()
    
    var userEmail: String = ""
    var userPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.alpha = 0
        addMultipleFonts()
        lottieAnimation(json: "SignUpComplete", container: completeAnimationContainer)
        
        viewModel.signIn(email: userEmail, password: userPW) {
            self.viewModel.addUserdefault(email: self.userEmail) {
                self.loginButtonAnimation()
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        instantiateVC()
    }
}


//MARK: - UI Functions
extension CompleteViewController {
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: completeLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 32)!, range: (completeLabel.text! as NSString).range(of: "회원가입"))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MintBlue")!, range: (completeLabel.text! as NSString).range(of: "회원가입"))
        completeLabel.attributedText = attributedString
    }
    
    func lottieAnimation(json: String, container: UIView) {
        let lottieView = AnimationView(name: json)
        container.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        lottieView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        lottieView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        lottieView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        lottieView.loopMode = .playOnce
        lottieView.play()
    }
    
    func loginButtonAnimation() {
        UIView.animate(withDuration: 0.4) {
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1
        }
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

