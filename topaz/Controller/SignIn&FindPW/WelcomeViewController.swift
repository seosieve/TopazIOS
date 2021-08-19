//
//  ViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/09.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
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
        performSegue(withIdentifier: "goToHome", sender: sender)
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
        attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Bold", size: 32)!, range: (titleLabel.text! as NSString).range(of: "topaz"))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Gray1")!, range: (titleLabel.text! as NSString).range(of: "topaz"))
        titleLabel.attributedText = attributedString
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
