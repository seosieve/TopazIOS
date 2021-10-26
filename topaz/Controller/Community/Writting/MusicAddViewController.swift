//
//  MusicAddViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit
import SwiftySound

protocol deleteMusicDelegate {
    func deleteSoundEffect()
}

class MusicAddViewController: UIViewController {
    @IBOutlet weak var musicAddViewContainer: UIView!
    @IBOutlet weak var musicSettingContainer: UIView!
    @IBOutlet weak var splitDashLine: UIView!
    @IBOutlet var progressBarContainer: [UIView]! {
        didSet {progressBarContainer.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var progressBarProgress: [UIView]! {
        didSet {progressBarContainer.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var progressBarHandle: [UIView]! {
        didSet {progressBarHandle.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var progressBarCover: [UIView]! {
        didSet {progressBarCover.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var progressBarThumbnail: [UIImageView]! {
        didSet {progressBarThumbnail.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var musicDeleteButton: [UIButton]! {
        didSet {musicDeleteButton.sort {$0.tag < $1.tag}}
    }
    @IBOutlet weak var musicAnimationContainer: UIView!
    @IBOutlet weak var musicAnimationContainerConstraintY: NSLayoutConstraint!
    @IBOutlet weak var backgroundMusicButton: UIButton!
    @IBOutlet weak var backgroundMusicUnderLine: UIView!
    @IBOutlet weak var soundEffectButton: UIButton!
    @IBOutlet weak var soundEffectUnderLine: UIView!
    
    var deleteMusicDelegate: deleteMusicDelegate?
    var musicPageViewController: MusicPageViewController!
    var backgroundMusicFileName = ""
    var soundEffectFileName = [String]()
    var sound1: Sound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: musicAddViewContainer)
        musicSettingContainer.alpha = 0
        musicAnimationContainerConstraintY.constant = -187
        makeSettingBackground()
        setLoopAnimation(json: "Music", container: musicAnimationContainer)
        
        makeMusic1()
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if sender.view!.center.y + translation.y > 170 {
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: 170)
        } else if sender.view!.center.y + translation.y < 60 {
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: 60)
        } else {
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
        }
        sender.setTranslation(.zero, in: self.view)
       
        let index = sender.view!.tag
        progressBarProgress[index-1].constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = 1.1 * (180 - sender.view!.center.y)
            }
        }
        print(1.1 * (180 - sender.view!.center.y))
        print(100/(1.1 * (180 - sender.view!.center.y)))
        
        sound1!.volume = Float(100/(1.1 * (180 - sender.view!.center.y)))
    }
    
    @IBAction func backgroundMusicButtonPressed(_ sender: UIButton) {
        deleteMusicDelegate?.deleteSoundEffect()
        musicPageViewController.moveFromIndex(index: 0, forward: false)
        transferMusic(index: 0)
    }
    
    @IBAction func soundEffectButtonPressed(_ sender: UIButton) {
        musicPageViewController.moveFromIndex(index: 1)
        transferMusic(index: 1)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPageVC" {
            let destinationVC = segue.destination as! MusicPageViewController
            musicPageViewController = destinationVC
            destinationVC.musicDelegate = self
            let pageOneVC = destinationVC.pageList[0] as! BackgroundMusicViewController
            pageOneVC.backgroundMusicDelegate = self
            let pageTwoVC = destinationVC.pageList[1] as! SoundEffectViewController
            pageTwoVC.soundEffectDelegate = self
        }
    }
}
//MARK: - UI Functions
extension MusicAddViewController {
    func makeModalCircular(target view: UIView) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func makeSettingBackground() {
        progressBarContainer.forEach { container in
            container.layer.cornerRadius = container.frame.size.width/2
        }
        progressBarHandle.forEach { handle in
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.drag))
            handle.addGestureRecognizer(panGesture)
        }
        progressBarCover.forEach { cover in
            makeCircle(target: cover)
            makeShadow(target: cover, radius: 12, height: 2)
            cover.isHidden = true
        }
        progressBarProgress.forEach { progress in
            progress.layer.cornerRadius = progress.frame.size.width/2
            progress.isHidden = true
        }
        musicDeleteButton.forEach { button in
            button.isHidden = true
        }
        splitDashLine.createDottedLine()
    }
    
    func coverAnimation(backgroundMusic: String, soundEffect: [String]) {
        if backgroundMusic == "" && soundEffect.count == 0 {
            musicAnimationContainerConstraintY.constant = -187
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.musicSettingContainer.alpha = 0
            }
        } else {
            musicAnimationContainerConstraintY.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.musicSettingContainer.alpha = 1
            }
        }
    }
    
    func makeMusic1() {
        let sound = Bundle.main.url(forResource: "music1", withExtension: "mp3")
        sound1 = Sound(url: sound!)
        sound1!.play()
        
        
    }
    
 
}

//MARK: - transferMusicDelegate
extension MusicAddViewController: transferMusicDelegate {
    func transferMusic(index: Int) {
        let activeFont = UIFont(name: "NotoSansKR-Bold", size: 16)!
        let inactiveFont = UIFont(name: "NotoSansKR-Regular", size: 16)!
        let font = [inactiveFont, activeFont]
        let color = [UIColor(named: "Gray4")!, UIColor(named: "Gray2")!]
        
        backgroundMusicButton.titleLabel?.font = font[abs(index - 1)]
        backgroundMusicButton.setTitleColor(color[abs(index - 1)], for: .normal)
        backgroundMusicUnderLine.alpha = CGFloat(abs(index - 1))
        soundEffectButton.titleLabel?.font = font[index]
        soundEffectButton.setTitleColor(color[index], for: .normal)
        soundEffectUnderLine.alpha = CGFloat(index)
    }
}

//MARK: - deliverBackgroundMusicDelegate
extension MusicAddViewController: deliverBackgroundMusicDelegate {
    func deliverBackgroundMusic(backgroundMusic: String) {
        backgroundMusicFileName = backgroundMusic
        coverAnimation(backgroundMusic: backgroundMusicFileName, soundEffect: soundEffectFileName)
        if backgroundMusic == "" {
            progressBarCover[0].isHidden = true
            progressBarProgress[0].isHidden = true
            musicDeleteButton[0].isHidden = true
        } else {
            progressBarHandle[0].center = CGPoint(x: 56.0, y: 114.0)
            progressBarProgress[0].constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = 70
                }
            }
            progressBarCover[0].isHidden = false
            progressBarProgress[0].isHidden = false
            musicDeleteButton[0].isHidden = false
        }
        
    }
}

//MARK: - deliverSoundEffectDelegate
extension MusicAddViewController: deliverSoundEffectDelegate {
    func deliverSoundEffect(soundEffect: String, add: Bool) {
        print(soundEffect, add)
    }
}

//MARK: - UIView
extension UIView {
    func createDottedLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(named: "White")?.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4,4]
        let path = CGMutablePath()
        let point = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: self.frame.height)]
        path.addLines(between: point)
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
