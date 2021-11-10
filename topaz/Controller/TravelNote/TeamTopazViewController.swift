//
//  TeamTopazViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/10.
//

import UIKit

class TeamTopazViewController: UIViewController {
    @IBOutlet weak var upperBackgroundView: UIView!
    @IBOutlet weak var teamTopazButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircular(target: upperBackgroundView)
        makeBorder(target: teamTopazButton, radius: 12, isFilled: false)
        

        
    }
    
    
    

}

//MARK: - UI Functions
extension TeamTopazViewController {
    func makeCircular(target view: UIView) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}

