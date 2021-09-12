//
//  HomeViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var IceBreakingLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            instantiateVC()
        }
        if Auth.auth().currentUser != nil {
            makeIceBreakingLabel()
        }
        removeNavigationBackground(view: self)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSetting", sender: sender)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
}

//MARK: - UI Functions
extension HomeViewController {
    func makeIceBreakingLabel() {
        let email = Auth.auth().currentUser!.email!
        db.collection("UserDataBase").document(email).getDocument { document, error in
            if let document = document {
                let nickname = document.get("nickname") as! String
                self.IceBreakingLabel.text = "\(nickname)님, 꼭 멀리가야만\n좋은 여행은 아니에요!"
                self.addMultipleFonts(nickname)
            } else {
                if let error = error {
                    print("유저 닉네임 탐색 오류 : \(error)")
                }
            }
        }
    }
    
    func addMultipleFonts(_ range: String) {
        let attributedString = NSMutableAttributedString(string: IceBreakingLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 22)!, range: (IceBreakingLabel.text! as NSString).range(of: range))
        IceBreakingLabel.attributedText = attributedString
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

