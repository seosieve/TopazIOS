//
//  CountryDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2023/06/21.
//

import UIKit

class CountryDetailViewController: UIViewController {
    
    @IBOutlet weak var CountryDetailViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        makeModalCircular(target: CountryDetailViewContainer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
