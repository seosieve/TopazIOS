//
//  CompleteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/18.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var completeLabel: UILabel!
    
    let viewModel = CompleteViewModel()
    
    var userEmail: String = ""
    var userPW: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        addMultipleFonts()
    }
    
    @IBAction func goToLoginPressed(_ sender: UIButton) {
        viewModel.signIn(email: userEmail, password: userPW) {
            self.viewModel.addUserdefault(email: self.userEmail) {
                self.instantiateVC()
            }
        }
    }
}


//MARK: - UI Functions
extension CompleteViewController {
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: completeLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 32)!, range: (completeLabel.text! as NSString).range(of: "회원가입"))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MintBlue")!, range: (completeLabel.text! as NSString).range(of: "회원가입"))
        completeLabel.attributedText = attributedString
    }
    
    func instantiateVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC")
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
}

