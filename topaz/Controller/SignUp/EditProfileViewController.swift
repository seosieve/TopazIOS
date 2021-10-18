//
//  EditProfileViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit
import Firebase
import FirebaseAuth
import Lottie

class EditProfileViewController: UIViewController {
    @IBOutlet weak var PGBarComponentStack: UIStackView!
    @IBOutlet weak var PGBar: UIProgressView!
    @IBOutlet weak var planeX: NSLayoutConstraint!
    @IBOutlet weak var profileAdd: UIButton!
    @IBOutlet weak var profileAddText: UIButton!
    
    @IBOutlet weak var nicknameDot: UIView!
    @IBOutlet weak var nicknameTextFieldBorder: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var introduceTextFieldBorder: UIView!
    @IBOutlet weak var introduceTextField: UITextField!
    @IBOutlet weak var nicknameWarning: UILabel!
    @IBOutlet weak var nicknameWarningY: NSLayoutConstraint!
    
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var goToNext: UIButton!
    
    var userEmail: String = ""
    var userPW: String = ""
    
    var imagePicker = UIImagePickerController()
    let viewModel = EditProfileViewModel()
    var userImage = UIImage(named: "DefaultUserImage")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeBorder(target: nicknameTextFieldBorder, radius: 6, isFilled: false)
        makeBorder(target: introduceTextFieldBorder, radius: 6, isFilled: false)
        makeCircle(target: profileAdd, color: "MintBlue", width: 3)
        makeCircle(target: nicknameDot, color: "WarningRed", width: 0)
        imagePicker.delegate = self
        // TextField 입력 감지
        self.nicknameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        nicknameTextField.delegate = self
        introduceTextField.delegate = self
        
        setPlane(level: 3, stack: PGBarComponentStack)
        goToNext.isEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nicknameTextField.endEditing(true)
        introduceTextField.endEditing(true)
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
    
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        let safeNickname = viewModel.isNicknameValid(nicknameTextField.text ?? "")
        if safeNickname {
            //닉네임 글자가 4자 이하일 때, 한글일 때
            check.alpha = 1
            correctAnimation()
            //이메일 양식에 맞지만 이미 가입된 닉네임일 때
            viewModel.isExist(nickname: nicknameTextField.text ?? "") {
                self.check.alpha = 0
                self.nicknameWarning.text = "이미 사용중인 닉네임입니다."
                self.incorrectAnimation()
            }
        } else {
            //닉네임 글자가 4자 초과일 때, 영어일 때
            check.alpha = 0
            nicknameWarning.text = "네 글자 이하의 한글 닉네임을 사용해주세요."
            incorrectAnimation()
        }
        let state = checkState()
        movePlane(level: 3, planeX: planeX, view: self.view, bar: PGBar, isCompleted: state)
        shiftButton(for: goToNext, isOn: state)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        signUpCancleAlert()
    }
    
    @IBAction func goToNext(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = true
        loadingAnimation(view: self.view)
        let nickname = nicknameTextField.text!
        let introduce = introduceTextField.text ?? ""
        let makeUserGroup = DispatchGroup()
        
        makeUserGroup.enter()
        DispatchQueue.global().async {
            self.viewModel.createUser(email: self.userEmail, password: self.userPW) {
                print("createUser Success")
                makeUserGroup.leave()
            }
        }
        makeUserGroup.enter()
        DispatchQueue.global().async {
            self.viewModel.addUserInfo(self.userEmail, nickname, introduce) {
                print("addUserInfo Success")
                makeUserGroup.leave()
            }
        }
        makeUserGroup.enter()
        DispatchQueue.global().async {
            self.viewModel.addUserImage(email: self.userEmail, image: self.userImage) {
                print("addUserImage Success")
                makeUserGroup.leave()
            }
        }
        makeUserGroup.notify(queue: .main) {
            self.performSegue(withIdentifier: "goToComplete", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComplete" {
            let destinationVC = segue.destination as! CompleteViewController
            destinationVC.userEmail = userEmail
            destinationVC.userPW = userPW
        }
    }
}

//MARK: - UI Functions
extension EditProfileViewController {
    func correctAnimation() {
        self.nicknameWarning.alpha = 0
        self.nicknameWarningY.constant = -9.5
        self.nicknameTextFieldBorder.layer.borderColor = UIColor(named: "Gray5")?.cgColor
    }
    
    func incorrectAnimation() {
        self.nicknameWarning.alpha = 1
        self.nicknameWarningY.constant = 14.5
        self.nicknameTextFieldBorder.layer.borderColor = UIColor(named: "WarningRed")?.cgColor
    }
    
    func checkState() -> Bool {
        if check.alpha == 1 {
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
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            introduceTextField.becomeFirstResponder()
        } else {
            introduceTextField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            userImage = viewModel.resizeImage(image: img, newWidth: 100)
            profileAdd.setImage(userImage, for: .normal)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
