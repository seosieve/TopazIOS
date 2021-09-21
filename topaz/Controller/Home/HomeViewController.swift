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
    @IBOutlet weak var nicknameBackground: UIView!
    
    let userdefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
           print("\(key) = \(value) \n")
         }
        if Auth.auth().currentUser == nil {
            instantiateVC()
        }
        if Auth.auth().currentUser != nil {
            let nickname = userdefault.string(forKey: "nickname")!
            IceBreakingLabel.text = "\(nickname)님, 꼭 멀리가야만\n좋은 여행은 아니에요!"
            addMultipleFonts(nickname)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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

