//
//  CompleteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/18.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var completeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        self.navigationController?.isNavigationBarHidden = true
        addMultipleFonts()
    }

    @IBAction func goToLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMain", sender: sender)
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
}

