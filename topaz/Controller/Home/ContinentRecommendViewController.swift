//
//  ContinentRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/12/29.
//

import UIKit

class ContinentRecommendViewController: UIViewController {
    @IBOutlet weak var continentRecommendViewContainer: UIView!
    @IBOutlet weak var continentTitleLabel: UILabel!
    
    var continent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: continentRecommendViewContainer)
        continentTitleLabel.text = "\(continent)로 떠나실래요?"
    }
    @IBAction func cancleButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
