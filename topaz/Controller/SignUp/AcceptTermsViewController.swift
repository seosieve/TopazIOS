//
//  AcceptTermsViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit

class AcceptTermsViewController: UIViewController {
    @IBOutlet weak var PGBarComponentStack: UIStackView!
    @IBOutlet weak var PGBar: UIProgressView!
    @IBOutlet weak var planeX: NSLayoutConstraint!
    @IBOutlet weak var acceptAllBorder: UIView!
    @IBOutlet var acceptCheck: [UIButton]!
    @IBOutlet weak var goToNext: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeBorder(target: acceptAllBorder, color: "MintBlue", isFilled: false)
        setPlane(level: 2, stack: PGBarComponentStack)
        //button 입력 감지
        acceptCheck.forEach { button in
            button.addTarget(self, action: #selector(acceptCheckDidChange(_:)), for: .touchUpInside)
        }
        goToNext.isEnabled = true
    }
    
    @IBAction func acceptAllPressed(_ sender: UIButton) {
        acceptCheck.forEach { button in
            checkOn(of: button)
        }
        movePlane(level: 2, planeX: planeX, view: self.view, bar: PGBar, isCompleted: true)
        shiftButton(for: goToNext, isOn: true)
    }
    
    @objc func acceptCheckDidChange(_ sender: UIButton) {
        if sender.isSelected == true {
            checkOff(of: sender)
        } else {
            checkOn(of: sender)
        }
        let state = checkState()
        movePlane(level: 2, planeX: planeX, view: self.view, bar: PGBar, isCompleted: state)
        shiftButton(for: goToNext, isOn: state)
    }
    
    @IBAction func Detail1Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail1", sender: sender)
    }
    
    @IBAction func Detail2Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail2", sender: sender)
    }
    
    @IBAction func Detail3Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail3", sender: sender)
    }
    
    @IBAction func Detail4Pressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDetail4", sender: sender)
    }
    
    @IBAction func goToNextPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToEditProfile", sender: sender)
    }
}

//MARK: - UI Functions
extension AcceptTermsViewController {
    func checkOn(of button: UIButton) {
        UIView.transition(with: button as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {button.setImage(UIImage(named: "Check_ON"), for: .normal)}, completion: nil)
        button.isSelected = true
    }
    func checkOff(of button: UIButton) {
        UIView.transition(with: button as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {button.setImage(UIImage(named: "Check_OFF"), for: .normal)}, completion: nil)
        button.isSelected = false
    }
    
    func checkState() -> Bool {
        if acceptCheck.allSatisfy(\.isSelected) {
            return true
        } else {
            return false
        }
    }
}
