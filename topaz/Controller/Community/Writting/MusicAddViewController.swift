//
//  MusicAddViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

class MusicAddViewController: UIViewController {
    @IBOutlet weak var musicAddViewContainer: UIView!
    @IBOutlet weak var musicSettingContainer: UIView!
    @IBOutlet var progressBarContainer: [UIView]!
    @IBOutlet weak var splitDashLine: UIView!
    @IBOutlet var musicDeleteButton: [UIButton]! {
        didSet {musicDeleteButton.sort {$0.tag < $1.tag}}
    }
    @IBOutlet weak var musicAnimationContainer: UIView!
    @IBOutlet weak var musicAnimationContainerConstraintY: NSLayoutConstraint!
    @IBOutlet weak var backgroundMusicButton: UIButton!
    @IBOutlet weak var backgroundMusicUnderLine: UIView!
    @IBOutlet weak var soundEffectButton: UIButton!
    @IBOutlet weak var soundEffectUnderLine: UIView!
    
    var musicPageViewController: MusicPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: musicAddViewContainer)
        musicSettingContainer.alpha = 1
        makeSettingBackground()
        musicAnimationContainerConstraintY.constant = -187
        setLoopAnimation(json: "Music", container: musicAnimationContainer)
    }
    
    @IBAction func backgroundMusicButtonPressed(_ sender: UIButton) {
        musicPageViewController.moveFromIndex(index: 0)
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
            
            let a = destinationVC.pageList[1] as! SoundEffectViewController
            
        }
    }
}
//MARK: - UI Functions
extension MusicAddViewController {
    func makeSettingBackground() {
        progressBarContainer.forEach { container in
            container.layer.cornerRadius = container.frame.size.width/2
        }
        splitDashLine.createDottedLine()
    }
}

//MARK: - transferMusicDelegate
extension MusicAddViewController: transferMusicDelegate {
    func makeModalCircular(target view: UIView) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
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
