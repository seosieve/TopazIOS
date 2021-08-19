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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Bold", size: 32)!, range: (titleLabel.text! as NSString).range(of: "topaz"))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Gray1")!, range: (titleLabel.text! as NSString).range(of: "topaz"))
        titleLabel.attributedText = attributedString

        loginButton.layer.cornerRadius = 6
        loginButton.layer.masksToBounds = true
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 6
        signUpButton.layer.borderColor = UIColor(named: "MintBlue")?.cgColor
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToHome", sender: sender)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: sender)
    }
    @IBAction func findPasswordButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToFindPassword", sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
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
