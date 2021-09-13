//
//  WrittingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import UIKit

class WrittingViewController: UIViewController {

    @IBOutlet weak var resisterButton: UIButton!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircle(target: resisterButton, color: "MintBlue", width: 0)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        button.removeFromSuperview()
    }
    
    @IBAction func addCountryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddCountry", sender: sender)
        print("aa")
    }
    
    
}
