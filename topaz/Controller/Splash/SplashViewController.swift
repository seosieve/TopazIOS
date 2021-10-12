//
//  SplashViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/30.
//

import UIKit
import Lottie
import FirebaseAuth

class SplashViewController: UIViewController {
    @IBOutlet weak var animationContainer: UIView!
    
    let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        lottieAnimation(json: "Splash", container: animationContainer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if user == nil {
                // Onboarding으로 이동
                self.transferVC(storyBoard: "Onboarding", identifier: "OnboardingVC")
            } else {
                // Home으로 이동
                self.viewModel.addUserdefault(email: user!.email!) {
                    self.transferVC(storyBoard: "Home", identifier: "HomeVC")
                }
            }
        }
    }
}

//MARK: - UI Functions
extension SplashViewController {
    func transferVC(storyBoard: String, identifier: String) {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: .main)
        let VC = storyBoard.instantiateViewController(withIdentifier: identifier)
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
    func lottieAnimation(json: String, container: UIView) {
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
}
