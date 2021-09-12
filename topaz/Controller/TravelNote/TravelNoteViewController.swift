//
//  TravelNoteViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase

class TravelNoteViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    let viewModel = TravelNoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircle(target: profileImage, color: "MintBlue", width: 0)
        if Auth.auth().currentUser != nil {
            viewModel.getUserImage(view: profileImage)
        }
    }

}
