//
//  SettingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/06.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    @IBAction func logoutPressed(_ sender: UIControl) {
        let alert = UIAlertController(title: "로그아웃 하시겠어요?", message: "로그아웃 후 topaz를 이용하시려면 다시 로그인을 해 주세요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .default) { action in
            do { try Auth.auth().signOut() }
            catch let signOutError as NSError { print(signOutError) }
            self.instantiateVC()
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UI Functions
extension SettingViewController {
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}
