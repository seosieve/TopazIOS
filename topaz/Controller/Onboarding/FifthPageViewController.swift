//
//  FifthPageViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/30.
//

import UIKit
import Lottie

class FifthPageViewController: UIViewController {
    @IBOutlet weak var animationContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieAnimation(json: "FifthOnboarding", container: animationContainer)
    }
}

//MARK: - UI Functions
extension FifthPageViewController {
    func lottieAnimation(json: String, container: UIView) {
        let lottieView = LottieAnimationView(name: json)
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
}
