//
//  ViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/09.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cloudAnimationContainer: UIView!
    
    let viewModel = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        removeNavigationBackground(view: self)
        cloudsAnimation(json: "Login", container: cloudAnimationContainer)
        makeBorder(target: loginButton, radius: 12, isFilled: true)
        makeBorder(target: signUpButton, radius: 12, color: "MintBlue", isFilled: false)
        addMultipleFonts()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        viewModel.signIn(email: email, password: password) { message in
            if message != nil {
                self.popUpToast(message!)
            } else {
                loadingAnimation(view: self.view)
                self.viewModel.addUserdefault(email: email) {
                    self.instantiateVC()
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: sender)
    }
    @IBAction func findPWButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFindPW", sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
}

//MARK: - UI Functions
extension WelcomeViewController {
    // 한 레이블에 여러 폰트 넣기
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 20)!, range: (titleLabel.text! as NSString).range(of: "색다른 여행"))
        titleLabel.attributedText = attributedString
    }
    
    func cloudsAnimation(json: String, container: UIView) {
        let lottieView = AnimationView(name: json)
        container.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        lottieView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        lottieView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        lottieView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.play()
    }
    
    func popUpToast(_ errorMessage: String) {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: errorMessage, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 15)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
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

//MARK: - UITextFieldDelegate
extension WelcomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}

