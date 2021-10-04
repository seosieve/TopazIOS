//
//  FindPasswordViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/10.
//

import UIKit
import Firebase
import FirebaseAuth
import Lottie

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldBorder: UIView!
    @IBOutlet weak var sendingButton: UIButton!
    @IBOutlet weak var sendingButtonY: NSLayoutConstraint!
    @IBOutlet weak var emailWarningMessage: UILabel!
    @IBOutlet weak var cloudAnimationContainer: UIView!
    
    let collection = Firestore.firestore().collection("UserDataBase")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        lottieAnimation(json: "Login", container: cloudAnimationContainer)
        makeBorder(target: emailTextFieldBorder, radius: 6, isFilled: false)
        makeBorder(target: sendingButton, radius: 12, isFilled: true)
        sendingButton.isEnabled = false
        // TextField 입력 감지
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.delegate = self

    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        collection.whereField("email", isEqualTo: sender.text ?? "").getDocuments { querySnapshot, error in
            if querySnapshot!.documents.count != 0 {
                shiftButton(for: self.sendingButton, isOn: true)
                self.correctAnimation()
            } else {
                shiftButton(for: self.sendingButton, isOn: false)
                self.incorrectAnimation()
            }
        }
    }
        
    @IBAction func emailSendingButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "메일이 전송되었습니다. 비밀번호 변경 후 다시 로그인해주세요.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            Auth.auth().sendPasswordReset(withEmail: "royalcircle97@naver.com") { error in
                if let error = error {
                    print("패스워드 재설정 메일 송신 에러 : \(error)")
                }
            }
            // Navigation Controller에서 dismiss
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        alert.view.tintColor = UIColor(named: "Gray2")

        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
    }
}
//MARK: - UI Functions
extension FindPasswordViewController {
    func lottieAnimation(json: String, container: UIView) {
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
    
    // email이 가입되었을 때 애니메이션
    func correctAnimation() {
        UIView.animate(withDuration: 1) {
            self.emailTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
            self.emailWarningMessage.alpha = 0
            self.sendingButtonY.constant = 360
        }
    }
    // email이 가입되어있지 않을 때 애니메이션
    func incorrectAnimation() {
        UIView.animate(withDuration: 1) {
            self.emailTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
            self.emailWarningMessage.alpha = 1
            self.sendingButtonY.constant = 384
        }
    }
}

//MARK: - UITextFieldDelegate
//return 눌렀을 때 키보드 down
extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
}
