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
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var nicknameBackground: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var myProfileEditButton: UIButton!
    
    let viewModel = TravelNoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        makeCircle(target: profileImage, color: "MintBlue", width: 0)
        if Auth.auth().currentUser != nil {
            viewModel.getUserImage(view: profileImage)
        }
    }

}
