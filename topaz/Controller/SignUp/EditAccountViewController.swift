//
//  SignUpViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/10.
//

import UIKit
import Firebase

class EditAccountController: UIViewController {
    @IBOutlet weak var emailTextFieldBorder: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var PWTextFieldBorder: UIView!
    @IBOutlet weak var PWConfirmTextField: UITextField!
    @IBOutlet weak var PWConfirmTextFieldBorder: UIView!
    @IBOutlet weak var PGBarComponentStack: UIStackView!
    @IBOutlet weak var PGBar: UIProgressView!
    @IBOutlet weak var planeX: NSLayoutConstraint!
    
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var PWWarning: UILabel!
    @IBOutlet weak var PWConfirmWarning: UILabel!
    
    @IBOutlet weak var emailWarningY: NSLayoutConstraint!
    @IBOutlet weak var PWWarningY: NSLayoutConstraint!
    
    
    @IBOutlet var check: [UIImageView]!
    @IBOutlet weak var goToNext: UIButton!
    
    let viewModel = EditAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeBorder(target: emailTextFieldBorder, radius:6, isFilled: false)
        makeBorder(target: PWTextFieldBorder, radius:6, isFilled: false)
        makeBorder(target: PWConfirmTextFieldBorder, radius:6, isFilled: false)
        emailTextField.isSecureTextEntry = false
        PWTextField.isSecureTextEntry = false
        // TextField 입력 감지
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        PWTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        PWConfirmTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.delegate = self
        PWTextField.delegate = self
        PWConfirmTextField.delegate = self
        
        setPlane(level: 1, stack: PGBarComponentStack)
        goToNext.isEnabled = true
        //goToNext.isEnabled = false 나중에 바꾸기 꼭
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        PWTextField.endEditing(true)
        PWConfirmTextField.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            let validEmail = viewModel.isEmailValid(sender.text ?? "")
            if validEmail {
                //이메일 양식에 맞을 때
                check[0].alpha = 1
                correctAnimation(index: 0)
                //이메일 양식에 맞지만 이미 가입된 이메일일 때
                viewModel.isExist(email: sender.text ?? "") {
                    self.check[0].alpha = 0
                    self.emailWarning.text = "이미 가입된 이메일입니다."
                    self.incorrectAnimation(index: 0)
                }
            } else {
                //이메일 양식에 맞지 않을 때
                check[0].alpha = 0
                emailWarning.text = "이메일 주소가 올바르지 않습니다."
                incorrectAnimation(index: 0)
            }
        } else if sender == PWTextField {
            let safePassword = viewModel.isPWValid(sender.text ?? "")
            if 8 < sender.text!.count && sender.text!.count < 20 {
                //비밀번호 글자 수가 맞을 때
                check[1].alpha = 1
                correctAnimation(index: 1)
                if !safePassword {
                    //비밀번호 글자 수가 맞지만 숫자, 영문이 포함되어있지 않을 때
                    check[1].alpha = 0
                    PWWarning.text = "숫자, 영문을 포함해주세요."
                    incorrectAnimation(index: 1)
                }
            } else {
                //비밀번호 글자 수가 맞지 않을 때
                check[1].alpha = 0
                PWWarning.text = "8~20자 이내로 입력해 주세요."
                incorrectAnimation(index: 1)
            }
        } else {
            if sender.text == PWTextField.text {
                check[2].alpha = 1
                correctAnimation(index: 2)
            } else {
                check[2].alpha = 0
                PWConfirmWarning.text = "비밀번호가 일치하지 않습니다."
                incorrectAnimation(index: 2)
            }
        }
        let state = checkState()
        movePlane(level: 1, planeX: planeX, view: self.view, bar: PGBar, isCompleted: state)
        shiftButton(for: goToNext, isOn: state)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        signUpCancleAlert()
    }
    
    @IBAction func goToNextPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAcceptTerms", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AcceptTermsViewController
        destinationVC.userEmail = emailTextField.text!
        destinationVC.userPW = PWTextField.text!
    }
}


//MARK: - UI Functions
extension EditAccountController {
    func correctAnimation(index: Int) {
        if index == 0 {
            self.emailWarning.alpha = 0
            self.emailWarningY.constant = -9.5
            self.emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
        } else if index == 1 {
            self.PWWarning.alpha = 0
            self.PWWarningY.constant = -9.5
            self.PWTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
        } else {
            self.PWConfirmWarning.alpha = 0
            self.PWConfirmTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
        }
    }
    
    func incorrectAnimation(index: Int) {
        UIView.animate(withDuration: 1, animations: {
            if index == 0 {
                self.emailWarning.alpha = 1
                self.emailWarningY.constant = 14.5
                self.emailTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            } else if index == 1 {
                self.PWWarning.alpha = 1
                self.PWWarningY.constant = 14.5
                self.PWTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            } else {
                self.PWConfirmWarning.alpha = 1
                self.PWConfirmTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            }
        })
    }
    
    func checkState() -> Bool {
        if check[0].alpha == 1 && check[1].alpha == 1 && check[2].alpha == 1 {
            return true
        } else {
            return false
        }
    }
    
    func signUpCancleAlert() {
        let alert = UIAlertController(title: "로그인 화면으로 이동합니다.", message: "현재까지 입력한 정보가 모두 사라집니다. 그래도 취소하시겠습니까?", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "아니오", style: .cancel)
        let delete = UIAlertAction(title: "예", style: .default) { action in
            self.instantiateVC()
        }
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        delete.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        alert.addAction(cancle)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    func instantiateVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
//return 눌렀을 때 키보드 down
extension EditAccountController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            PWTextField.becomeFirstResponder()
        } else if textField == PWTextField {
            PWConfirmTextField.becomeFirstResponder()
        } else {
            PWConfirmTextField.resignFirstResponder()
        }
        return true
    }
}

