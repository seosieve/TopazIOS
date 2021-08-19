//
//  FindPasswordViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/10.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldBorder: UIView!
    @IBOutlet weak var sendingButton: UIButton!
    @IBOutlet weak var sendingButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailWarningMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        sendingButton.isEnabled = false
        
        emailTextFieldBorder.layer.cornerRadius = 6
        emailTextFieldBorder.layer.borderWidth = 1
        emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
        
        //Navigation Bar line과 Background 제거
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.contains("호르몬동") {
            // 하나의 함수로 만들자
            sendingButton.isEnabled = true
            sendingButton.backgroundColor = UIColor(named: "MintBlue")
            sendingButton.setTitleColor(UIColor(named: "White"), for: .normal)
            emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
            emailWarningMessage.alpha = 0
            sendingButtonYConstraint.constant = 360
            
        } else {
            //하나의 함수로 만들자
            sendingButton.backgroundColor = UIColor(named: "Gray6")
            sendingButton.setTitleColor(UIColor(named: "Gray4"), for: .normal)
            emailTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            emailWarningMessage.alpha = 1
            sendingButtonYConstraint.constant = 372
        }
        return true
    }
    
    @IBAction func emailSendingButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "메일이 전송되었습니다. 비밀번호 변경 후 다시 로그인해주세요.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            // Navigation Controller에서 dismiss
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
}
