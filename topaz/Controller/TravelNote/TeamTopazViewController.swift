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
    @IBOutlet var teamMemberControl: [UIControl]! {
        didSet {teamMemberControl.sort{$0.tag < $1.tag}}
    }
    @IBOutlet var teamMemberSubView: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircular(target: upperBackgroundView, radius: 24)
        makeShadow(target: upperBackgroundView, radius: 24, height: 6, opacity: 0.2, shadowRadius: 4)
        makeBorder(target: teamTopazButton, radius: 12, color: "MintBlue", isFilled: false)
        teamMemberControl.forEach { control in
            makeBorder(target: control, radius: 20, isFilled: true)
            makeShadow(target: control, radius: 20, height: 4, shadowRadius: 4)
        }
        teamMemberSubView.forEach { view in
            makeCircular(target: view, radius: 20)
        }
        memberControlAnimation()
    }
    
    @IBAction func teamTopazButtonPressed(_ sender: UIButton) {
        openUrl(urlStr: "https://seosieve.notion.site/TOPAZ-c5da4c845f5d4209845e6f595c3e7d19")
    }
    
    @IBAction func teamMemberControlPressed(_ sender: UIControl) {
        switch sender.tag {
        case 1:
            openUrl(urlStr: "https://www.github.com/seosieve")
        case 2:
            openUrl(urlStr: "https://www.behance.net/seobobot")
        default:
            openUrl(urlStr: "https://www.behance.net/pcs2354")
        }
    }
}

//MARK: - UI Functions
extension TeamTopazViewController {
    func makeCircular(target view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func memberControlAnimation() {
        for index in 0...2 {
            teamMemberControl[index].transform = CGAffineTransform(translationX: 300, y: 0)
            UIView.animate(withDuration: 1.5, delay: 0.2 * Double(index), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseIn) {
                self.teamMemberControl[index].transform = CGAffineTransform.identity
            }
        }
    }
    
    func openUrl(urlStr: String) {
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
}

