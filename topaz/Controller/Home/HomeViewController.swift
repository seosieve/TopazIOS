//
//  HomeViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNavigationBackground(view: self)
        navigationController?.isNavigationBarHidden = true
        print("aaaaa")
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser == nil {
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
//            let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
//
//            mainVC.modalPresentationStyle = .fullScreen
//            mainVC.modalTransitionStyle = .crossDissolve
//            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
}
