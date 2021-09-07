//
//  HomeViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var IceBreakingLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            instantiateVC()
        }
        removeNavigationBackground(view: self)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        makeIceBreakingLabel()
        print(Auth.auth().currentUser?.email)
        
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
        IceBreakingLabel.text = "삥빵뽕삐님, 꼭 멀리가야만\n좋은 여행은 아니에요!"
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

