//
//  ViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/09.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "goToHome", sender: self)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        removeNavigationBackground(view: self)
        makeBorder(target: loginButton, isFilled: true)
        makeBorder(target: signUpButton, color: "MintBlue", isFilled: false)
        addMultipleFonts()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let idErrorMessage = "There is no user record corresponding to this identifier. The user may have been deleted."
        let PWErrorMessage = "The password is invalid or the user does not have a password."
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let errorMessage = error?.localizedDescription {
                if errorMessage == idErrorMessage {
                    self.popUpToast("존재하지 않는 아이디입니다.")
                } else if errorMessage == PWErrorMessage {
                    self.popUpToast("비밀번호가 일치하지 않습니다.")
                } else {
                    self.popUpToast("로그인 중 오류가 발생했습니다. 다시 회원가입을 진행해주세요.")
                }
            } else {
                self.performSegue(withIdentifier: "goToHome", sender: sender)
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeVC")
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
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

