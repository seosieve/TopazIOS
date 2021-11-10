//
//  File.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit
import Lottie

//Border 생성
func makeBorder(target view: UIView, radius: Int, width: Int = 1, color: String = "Gray5", isFilled Fill: Bool) {
    if Fill {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.masksToBounds = true
    } else {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = CGFloat(width)
        view.layer.borderColor = UIColor(named: color)?.cgColor
    }
}

func makeCircle(target view: UIView, color: String = "MintBlue", width: Int = 0) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.size.height/2
    view.layer.borderWidth = CGFloat(width)
    view.layer.borderColor = UIColor(named: color)?.cgColor
}

func makeShadow(target view: UIView, radius: CGFloat = 0, width: Int = 0, height: Int = 0, opacity: Float = 0.5, shadowRadius: Int = 2) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowOffset = CGSize(width: width, height: height)
    view.layer.shadowRadius = CGFloat(shadowRadius)
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

func makeModalCircular(target view: UIView) {
    view.clipsToBounds = false
    view.layer.cornerRadius = 28
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
}

//Navigation Bar line과 Background 제거
func removeNavigationBackground(view: UIViewController) {
    view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    view.navigationController?.navigationBar.shadowImage = UIImage()
}

// 움직이지 않는 loop Animation Set
func setLoopAnimation(json: String, container: UIView) {
    let lottieView = AnimationView(name: json)
    container.addSubview(lottieView)
    lottieView.translatesAutoresizingMaskIntoConstraints = false
    lottieView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    lottieView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    lottieView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
    lottieView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    lottieView.loopMode = .loop
    lottieView.backgroundBehavior = .pauseAndRestore
    lottieView.play()
}

// Loading Animation View - 삭제불가
func loadingAnimation(view: UIView) {
    let backgroundView = UIView()
    backgroundView.frame = CGRect(x:0, y:0, width:view.bounds.width, height:view.bounds.height)
    backgroundView.backgroundColor = UIColor(named: "White")
    view.addSubview(backgroundView)
    let lottieView = AnimationView(name: "Loading")
    lottieView.frame = CGRect(x:0, y:0, width:60, height:60)
    lottieView.center = view.center
    lottieView.contentMode = .scaleAspectFill
    view.addSubview(lottieView)
    lottieView.loopMode = .loop
    lottieView.backgroundBehavior = .pauseAndRestore
    lottieView.play()
}
// Loading Animation View - 삭제가능
func loadingAnimation(_ background: UIView, _ animation: AnimationView, view: UIView) {
    background.frame = CGRect(x:0, y:0, width:view.bounds.width, height:view.bounds.height)
    background.backgroundColor = UIColor(named: "White")
    view.addSubview(background)
    animation.frame = CGRect(x:0, y:0, width:60, height:60)
    animation.center = view.center
    animation.contentMode = .scaleAspectFill
    view.addSubview(animation)
    animation.loopMode = .loop
    animation.backgroundBehavior = .pauseAndRestore
    animation.play()
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





