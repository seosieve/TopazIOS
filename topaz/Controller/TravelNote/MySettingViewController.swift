//
//  SettingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/06.
//

import UIKit
import FirebaseAuth

class MySettingViewController: UIViewController {
    @IBOutlet weak var blockUserListControl: UIControl!
    @IBOutlet weak var mySettingStackView: UIStackView!
    @IBOutlet weak var withdrawControl: UIControl!
    
    let viewModel = MySettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeShadow(target: blockUserListControl, height: 5, opacity: 0.1, shadowRadius: 5)
        makeShadow(target: mySettingStackView, height: 5, opacity: 0.1, shadowRadius: 5)
        makeShadow(target: withdrawControl, height: 5, opacity: 0.1, shadowRadius: 5)
    }
    
    
    @IBAction func blockUserListPressed(_ sender: UIControl) {
        self.performSegue(withIdentifier: "goToBlockUserList", sender: sender)
    }
    
    @IBAction func termsOfUsePressed(_ sender: UIControl) {
        self.performSegue(withIdentifier: "goToTermsOfUse", sender: sender)
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIControl) {
        self.performSegue(withIdentifier: "goToPrivacyPolicy", sender: sender)
    }
    
    @IBAction func teamTopazPressed(_ sender: UIControl) {
        self.performSegue(withIdentifier: "goToTeamTopaz", sender: sender)
    }
    
    
    @IBAction func logoutPressed(_ sender: UIControl) {
        logoutAlert()
    }
    @IBAction func withdrawPressed(_ sender: UIControl) {
        withdrawAlert()
    }
}

//MARK: - UI Functions
extension MySettingViewController {
    func logoutAlert() {
        let alert = UIAlertController(title: "로그아웃 하시겠어요?", message: "로그아웃 후 topaz를 이용하시려면 다시 로그인을 해 주세요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .default) { action in
            self.viewModel.signOut {
                self.instantiateVC()
            }
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        logout.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }
    
    func withdrawAlert() {
        let alert = UIAlertController(title: "정말 서비스를 탈퇴하시겠어요?", message: "정말 붙잡고 싶지만 언젠간 꼭 다시 만나길 바랄게요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let withdraw = UIAlertAction(title: "서비스 탈퇴", style: .default) { action in
            self.viewModel.withdraw {
                self.instantiateVC()
            }
        }
        alert.addAction(cancel)
        alert.addAction(withdraw)
        withdraw.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}
