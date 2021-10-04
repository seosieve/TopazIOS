//
//  MyProfileEditViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit

protocol EditDelegate {
    func profileChange(_ dataChanged: Bool, _ imageChanged: Bool)
}

class MyProfileEditViewController: UIViewController {
    @IBOutlet weak var profileAdd: UIButton!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var nicknameWarning: UILabel!
    @IBOutlet weak var nicknameWarningY: NSLayoutConstraint!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var nicknameBorder: UIView!
    @IBOutlet weak var introduce: UITextView!
    @IBOutlet weak var introduceBorder: UIView!
    
    @IBOutlet weak var profileEditComplete: UIBarButtonItem!
    
    let viewModel = MyProfileEditViewModel()
    let imagePicker = UIImagePickerController()
    var changedImage: UIImage? = nil
    
    let email = UserDefaults.standard.string(forKey: "email")!
    let originalNickname = UserDefaults.standard.string(forKey: "nickname")!
    let originalIntroduce = UserDefaults.standard.string(forKey: "introduce")!
    
    var delegate: EditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        makeCircle(target: profileAdd, color: "MintBlue", width: 3)
        makeBorder(target: nicknameBorder, radius: 6, isFilled: false)
        makeBorder(target: introduceBorder, radius: 6, isFilled: false)
        nickname.text = originalNickname
        introduce.text = originalIntroduce
        viewModel.getUserImage(email: email) { image in
            self.profileAdd.setImage(image, for: .normal)
        }
        
        imagePicker.delegate = self
        nickname.delegate = self
        introduce.delegate = self
        //nickname 입력감지
        nickname.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
    }
    
    @IBAction func profileAddPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "프로필 이미지를 선택해주세요", message: "앨범에서 선택 또는 카메라 사용이 가능합니다.", preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "앨범에서 선택", style: .default) { (action) in
            self.useLibrary()
        }
        let camera = UIAlertAction(title: "카메라 촬영", style: .default) { (action) in
            self.useCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func profileEditCompletePressed(_ sender: UIBarButtonItem) {
        //현재는 userDefault로 계속 뷰가 바뀌는데 그거 수정하기 Delegate? 등으로
        let makeUserGroup = DispatchGroup()
        let data = changedImage?.pngData()
        let nickname = nickname.text!
        let introduce = introduce.text!
        var dataChanged = false
        var imageChanged = false
        
        if nickname != originalNickname || introduce != originalIntroduce {
            makeUserGroup.enter()
            DispatchQueue.global().async {
                self.viewModel.addUserInfo(self.email, nickname, introduce) {
                    UserDefaults.standard.set(nickname, forKey: "nickname")
                    UserDefaults.standard.set(introduce, forKey: "introduce")
                    print("addUserInfo Success")
                    dataChanged = true
                    makeUserGroup.leave()
                }
            }
        }
        if data != nil {
            makeUserGroup.enter()
            DispatchQueue.global().async {
                self.viewModel.addUserImage(userEmail: self.email, data: data!) {
                    print("addUserImage Success")
                    imageChanged = true
                    makeUserGroup.leave()
                }
            }
        }
        makeUserGroup.notify(queue: .main) {
            self.delegate?.profileChange(dataChanged, imageChanged)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nickname.endEditing(true)
        introduce.endEditing(true)
    }
    
    @objc func nicknameDidChange(_ sender: UITextField) {
        let safeNickname = viewModel.isNicknameValid(nickname.text ?? "")
        if safeNickname {
            //닉네임 글자가 4자 이하일 때, 한글일 때
            check.alpha = 1
            profileEditComplete.isEnabled = true
            correctAnimation()
            //이메일 양식에 맞지만 이미 가입된 닉네임일 때
            viewModel.isExist(nickname: nickname.text ?? "") {
                if self.nickname.text != self.originalNickname {
                    self.check.alpha = 0
                    self.nicknameWarning.text = "이미 사용중인 닉네임입니다."
                    self.incorrectAnimation()
                    self.profileEditComplete.isEnabled = false
                }
            }
        } else {
            //닉네임 글자가 4자 초과일 때, 영어일 때
            check.alpha = 0
            nicknameWarning.text = "네 글자 이하의 한글 닉네임을 사용해주세요."
            incorrectAnimation()
            profileEditComplete.isEnabled = false
        }
    }
}

//MARK: - UI Functions
extension MyProfileEditViewController {
    func correctAnimation() {
        self.nicknameWarning.alpha = 0
        self.nicknameWarningY.constant = -9.5
        self.nicknameBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
    }
    func incorrectAnimation() {
        self.nicknameWarning.alpha = 1
        self.nicknameWarningY.constant = 14.5
        self.nicknameBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
    }
}

//MARK: - UITextFieldDelegate
extension MyProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " { return false }
        guard let str = nickname.text else { return true }
        let length = str.count + string.count - range.length
        print(length)
        return length <= 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        introduce.becomeFirstResponder()
    }
}

//MARK: - UITextViewDelegate
extension MyProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            introduce.resignFirstResponder()
        }
        guard let str = introduce.text else { return true }
        let length = str.count + text.count - range.length
        print(length)
        return length <= 30
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Gray4") {
            textView.text = nil
            textView.textColor = UIColor(named: "Gray1")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "30자 이하의 소개를 작성해주세요."
            textView.textColor = UIColor(named: "Gray4")
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MyProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func useCamera() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func useLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            changedImage = viewModel.resizeImage(image: img, newWidth: 100)
            profileAdd.setImage(changedImage, for: .normal)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
