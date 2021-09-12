//
//  File.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit

//Border 생성
func makeBorder(target view: UIView, color: String = "Gray5", isFilled Fill: Bool) {
    if Fill == true {
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
    } else {
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: color)?.cgColor
    }
}

func makeCircle(target view: UIView, color: String, width: Int) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.size.height/2
    view.layer.borderWidth = CGFloat(width)
    view.layer.borderColor = UIColor(named: color)?.cgColor
}

//Navigation Bar line과 Background 제거
func removeNavigationBackground(view: UIViewController) {
    view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    view.navigationController?.navigationBar.shadowImage = UIImage()
}

//Button Tern ON & OFF
func shiftButton(for button: UIButton, isOn: Bool) {
    if isOn == true {
        UIView.animate(withDuration: 0.4) {
            button.backgroundColor = UIColor(named: "MintBlue")
            button.setTitleColor(UIColor(named: "White"), for: .normal)
            button.isEnabled = true
        }
        
    } else {
        UIView.animate(withDuration: 0.4) {
            button.backgroundColor = UIColor(named: "Gray6")
            button.setTitleColor(UIColor(named: "Gray4"), for: .normal)
            button.isEnabled = false
        }
    }
}

// airplane setting
func setPlane(level: Int, stack: UIStackView) {
    stack.subviews.forEach { (view) in
        view.layer.cornerRadius = 4
    }
    for num in 0...level-1 {
        stack.subviews[num].backgroundColor = UIColor(named: "MintBlue")
    }
}
// airplane progressBar Animation
func movePlane(level:Int, planeX: NSLayoutConstraint, view: UIView, bar: UIProgressView, isCompleted state: Bool) {
    if state == true {
        planeX.constant = CGFloat(90*level)
        UIView.animate(withDuration: 0.4) {
            view.layoutIfNeeded()
            bar.setProgress(0.33*Float(level), animated: true)
        }
    } else {
        if level == 1 {
            planeX.constant = 20
        } else {
            planeX.constant = CGFloat(90*(level-1))
        }
        UIView.animate(withDuration: 0.4) {
            view.layoutIfNeeded()
            bar.setProgress(0.01+(0.33*Float(level-1)), animated: true)
        }
    }
}





