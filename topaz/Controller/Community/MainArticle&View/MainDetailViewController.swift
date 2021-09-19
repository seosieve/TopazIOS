//
//  MainDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit

class MainDetailViewController: UIViewController {

    var article: Article? {
        didSet{
            print(article)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
      
    }
}
