//
//  Onboarding1ViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/29.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {
    @IBOutlet weak var progressBackground: UIView!
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var progressConstraintY: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.alpha = 0
        makeCircle(target: progressBackground)
        makeCircle(target: progress)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        instantiateVC()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPageVC" {
            let destinationVC = segue.destination as! PageViewController
            destinationVC.pageDelegate = self
        }
    }
}

//MARK: - UI Functions
extension OnboardingViewController {
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

//MARK: - transferPageDelegate
extension OnboardingViewController: transferPageDelegate {
    func transferPage(currentPage: Int) {
        progressConstraintY.constant = 23*CGFloat(currentPage)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            if currentPage == 4 {
                self.loginButton.isEnabled = true
                self.loginButton.alpha = 1
            } else {
                self.loginButton.isEnabled = false
                self.loginButton.alpha = 0
            }
        }
    }
}


