//
//  FindPasswordViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/10.
//

import UIKit

class FindPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldBorder: UIView!
    @IBOutlet weak var emailSendingButton: UIButton!
    @IBOutlet weak var sendingButtonYConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailWarningMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        
        // Do any additional setup after loading the view.
        emailTextFieldBorder.layer.cornerRadius = 6
        emailTextFieldBorder.layer.borderWidth = 1
        emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
        
        //Navigation Bar line과 Background 제거
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.contains("호르몬동") {
            emailSendingButton.backgroundColor = UIColor(named: "MintBlue")
            emailSendingButton.setTitleColor(UIColor(named: "White"), for: .normal)
            emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
            emailWarningMessage.alpha = 0
            sendingButtonYConstraint.constant = 360
            
        } else {
            emailSendingButton.backgroundColor = UIColor(named: "Gray6")
            emailSendingButton.setTitleColor(UIColor(named: "Gray4"), for: .normal)
            emailTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            emailWarningMessage.alpha = 1
            sendingButtonYConstraint.constant = 380
        }
        return true
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
