//
//  AcceptTermsViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit

class AcceptTermsViewController: UIViewController {
    @IBOutlet weak var PGBarComponentStack: UIStackView!
    @IBOutlet weak var PGBar: UIProgressView!
    @IBOutlet weak var planeX: NSLayoutConstraint!
    @IBOutlet weak var acceptAllBorder: UIView!
    @IBOutlet var acceptCheck: [UIButton]! {
        didSet {acceptCheck.sort{$0.tag < $1.tag}}
    }
    @IBOutlet var acceptCheckLabel: [UILabel]! {
        didSet {acceptCheckLabel.sort{$0.tag < $1.tag}}
    }
    @IBOutlet weak var goToNext: UIButton!
    
    var userEmail: String = ""
    var userPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeBorder(target: acceptAllBorder, radius: 12, color: "MintBlue", isFilled: false)
        setPlane(level: 2, stack: PGBarComponentStack)
        //button 입력 감지
        acceptCheck.forEach { button in
            button.addTarget(self, action: #selector(acceptCheckDidChange(_:)), for: .touchUpInside)
        }
        //lable 입력 감지
        acceptCheckLabel.forEach { label in
            let tap = UITapGestureRecognizer(target: self, action: #selector(acceptCheckLabelDidChange(_:)))
            label.addGestureRecognizer(tap)
        }
        goToNext.isEnabled = false
    }
    
    @IBAction func acceptAllPressed(_ sender: UIButton) {
        acceptCheck.forEach { button in
            checkOn(of: button)
        }
        movePlane(level: 2, planeX: planeX, view: self.view, bar: PGBar, isCompleted: true)
        shiftButton(for: goToNext, isOn: true)
    }
    
    @objc func acceptCheckDidChange(_ sender: UIButton) {
        if sender.isSelected == true {
            checkOff(of: sender)
        } else {
            checkOn(of: sender)
        }
        let state = checkState()
        movePlane(level: 2, planeX: planeX, view: self.view, bar: PGBar, isCompleted: state)
        shiftButton(for: goToNext, isOn: state)
    }
    
    @objc func acceptCheckLabelDidChange(_ sender: UITapGestureRecognizer) {
        let tappedLabel = sender.view as! UILabel
        let tappedLabelIndex = acceptCheckLabel.firstIndex(of: tappedLabel)!
        acceptCheckDidChange(acceptCheck[tappedLabelIndex])
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        signUpCancleAlert()
    }
    
    @IBAction func detail1Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail1", sender: sender)
    }
    
    @IBAction func detail2Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail2", sender: sender)
    }
    
    @IBAction func detail3Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail3", sender: sender)
    }
    
    @IBAction func detail4Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail4", sender: sender)
    }
    
    @IBAction func goToNextPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToEditProfile", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditProfile" {
            let destinationVC = segue.destination as! EditProfileViewController
            destinationVC.userEmail = userEmail
            destinationVC.userPW = userPW
        }
    }
}

//MARK: - UI Functions
extension AcceptTermsViewController {
    func checkOn(of button: UIButton) {
        UIView.transition(with: button as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {button.setImage(UIImage(named: "Check_ON"), for: .normal)}, completion: nil)
        button.isSelected = true
    }
    func checkOff(of button: UIButton) {
        UIView.transition(with: button as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {button.setImage(UIImage(named: "Check_OFF"), for: .normal)}, completion: nil)
        button.isSelected = false
    }
    
    func checkState() -> Bool {
        if acceptCheck[0].isSelected == true && acceptCheck[1].isSelected == true && acceptCheck[2].isSelected == true {
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
