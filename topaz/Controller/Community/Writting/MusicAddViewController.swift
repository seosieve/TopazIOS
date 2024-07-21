//
//  MusicAddViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit
import SwiftySound

protocol MusicAddDelegate {
    func musicAdd(musicNameArr: [String], musicVolumeArr: [Float], musicHandler: @escaping () -> ())
}

class MusicAddViewController: UIViewController {
    @IBOutlet weak var musicAddViewContainer: UIView!
    @IBOutlet weak var musicSettingContainer: UIView!
    @IBOutlet weak var splitDashLine: UIView!
    @IBOutlet var progressBarContainer: [UIView]! {
        didSet {progressBarContainer.sort {$0.tag < $1.tag}}
    }
    @IBOutlet var progressBarProgress: [UIView]! {
        didSet {progressBarProgress.sort {$0.tag < $1.tag}}
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
    
    var musicAddDelegate: MusicAddDelegate?
    var musicPageViewController: MusicPageViewController!
    var backgroundMusicFileName = ""
    var soundEffectFileName = [String]()
    var backgroundMusic: Sound?
    var soundEffectArr = [Sound?]()
    var musicNameArr = ["", "", "", ""]
    var musicVolumeArr: [Float] = [0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        makeModalCircular(target: musicAddViewContainer)
        musicSettingContainer.alpha = 0
        musicAnimationContainerConstraintY.constant = -187
        makeSettingBackground()
        setLoopAnimation(json: "Music", container: musicAnimationContainer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeMusicInput()
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        // sender make draggable
        let translation = sender.translation(in: self.view)
        let x = sender.view!.center.x
        if sender.view!.center.y + translation.y > 170 {
            sender.view!.center = CGPoint(x: x, y: 170)
        } else if sender.view!.center.y + translation.y < 60 {
            sender.view!.center = CGPoint(x: x, y: 60)
        } else {
            sender.view!.center = CGPoint(x: x, y: sender.view!.center.y + translation.y)
        }
        sender.setTranslation(.zero, in: self.view)
        // 부가요소들 또한 같이 움직이게 설정
        let index = sender.view!.tag
        progressBarProgress[index-1].constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = 1.1 * (180 - sender.view!.center.y)
            }
        }
        // 소수점값에 따라 Sound volume 조절
        let volumeFloat = Float(0.009 * (170 - sender.view!.center.y))
        if index == 1 {
            backgroundMusic?.volume = volumeFloat
        } else {
            if sender.view?.subviews.first?.alpha != 0 {
                soundEffectArr[index-2]?.volume = volumeFloat
            }
        }
    }
    
    @IBAction func musicDeleteButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            // backgroundMusicDeleteButton 클릭시 전달
            let VC = musicPageViewController.pageList[0] as! BackgroundMusicViewController
            VC.deleteBackgroundMusic(name: backgroundMusicFileName)
            self.deleteBackgroundMusic()
        } else {
            // soundEffectDeleteButton 클릭시 전달
            let VC = musicPageViewController.pageList[1] as! SoundEffectViewController
            let soundEffectFileName = soundEffectFileName[sender.tag - 2]
            VC.deleteSoundEffect(name: soundEffectFileName)
            self.deleteSoundEffect(soundEffectFileName)
        }
    }
    
    @IBAction func backgroundMusicButtonPressed(_ sender: UIButton) {
        musicPageViewController.moveFromIndex(index: 0, forward: false)
        transferMusic(index: 0)
    }
    
    @IBAction func soundEffectButtonPressed(_ sender: UIButton) {
        musicPageViewController.moveFromIndex(index: 1)
        transferMusic(index: 1)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        makeMusicOutput()
        backgroundMusic = nil
        soundEffectArr = [Sound?]()
        musicAddDelegate?.musicAdd(musicNameArr: musicNameArr, musicVolumeArr: musicVolumeArr) {
            self.dismiss(animated: true, completion: nil)
        }
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
    func makeSettingBackground() {
        progressBarContainer.forEach { container in
            container.layer.cornerRadius = container.frame.size.width/2
            container.alpha = 0
        }
        progressBarHandle.forEach { handle in
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.drag))
            handle.addGestureRecognizer(panGesture)
        }
        progressBarCover.forEach { cover in
            makeCircle(target: cover)
            makeShadow(target: cover, radius: 12, height: 2)
            cover.alpha = 0
        }
        progressBarProgress.forEach { progress in
            progress.layer.cornerRadius = progress.frame.size.width/2
            progress.alpha = 0
        }
        musicDeleteButton.forEach { button in
            button.isEnabled = false
            button.alpha = 0
        }
        splitDashLine.createDottedLine()
    }
    
    func makeMusicInput() {
        if musicNameArr[0] != "" {
            let VC = musicPageViewController.pageList[0] as! BackgroundMusicViewController
            VC.addBackgroundMusic(name: musicNameArr[0])
            addBackgroundMusic(musicNameArr[0], isFirst: true)
        }
        let VC = musicPageViewController.pageList[1] as! SoundEffectViewController
        for index in 1...3 {
            if musicNameArr[index] != "" {
                VC.addSoundEffect(name: musicNameArr[index])
                addSoundEffect(musicNameArr[index], isFirst: true)
            }
        }
    }
    
    func coverAnimation(_ backgroundMusic: String, _ soundEffect: [String]) {
        if backgroundMusic == "" && soundEffect.count == 0 {
            musicAnimationContainerConstraintY.constant = -187
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.musicSettingContainer.alpha = 0
            }
        } else {
            // constant가 이미 0이어도 계속 실행되지 않게 처리
            if musicAnimationContainerConstraintY.constant != 0 {
                musicAnimationContainerConstraintY.constant = 0
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.musicSettingContainer.alpha = 1
                }
            }
        }
    }
    
    func playBackgroundMusic(fileName: String, isFirst: Bool = false) {
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
            self.backgroundMusic = Sound(url: url)
            self.backgroundMusic!.play(numberOfLoops: -1)
            let volume = isFirst ? self.musicVolumeArr[0] : 0.5
            self.backgroundMusic?.volume = volume
        }
    }
    
    func playSoundEffect(fileName: String, index: Int, isFirst: Bool) {
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
            let sound = Sound(url: url)!
            sound.play(numberOfLoops: -1)
            self.soundEffectArr.append(sound)
            let volume = isFirst ? self.musicVolumeArr[index] : 0.5
            sound.volume = volume
        }
    }
    
    func makeMusicOutput() {
        musicNameArr = ["", "", "", ""]
        musicVolumeArr = [0, 0, 0, 0]
        musicNameArr[0] = backgroundMusicFileName
        for (index, soundEffect) in soundEffectFileName.enumerated() {
            musicNameArr[index+1] = soundEffect
        }
        if musicNameArr[0] != "" {
            musicVolumeArr[0] = backgroundMusic?.volume ?? 0
        }
        for (index, soundEffect) in soundEffectArr.enumerated() {
            musicVolumeArr[index+1] = soundEffect?.volume ?? 0
        }
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
extension MusicAddViewController: DeliverBackgroundMusicDelegate {
    // BackgroundMusicCollectionView 클릭시 전달
    func deliverBackgroundMusic(backgroundMusic: String) {
        if backgroundMusic != "" {
            addBackgroundMusic(backgroundMusic)
        } else {
            deleteBackgroundMusic()
        }
    }
    
    func addBackgroundMusic(_ backgroundMusic: String, isFirst: Bool = false) {
        backgroundMusicFileName = backgroundMusic
        coverAnimation(backgroundMusicFileName, soundEffectFileName)
        let originX = progressBarContainer[0].center.x
        let originY = isFirst ? (-111 * musicVolumeArr[0]) + 170 : 114.0
        let progressBarConstant = isFirst ? 1.1 * (180 - originY) : 70
        progressBarHandle[0].center = CGPoint(x: originX, y: CGFloat(originY))
        progressBarProgress[0].constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = CGFloat(progressBarConstant)
            }
        }
        progressBarThumbnail[0].image = UIImage(named: "\(backgroundMusic)Icon")
        UIView.animate(withDuration: 0.3) {
            self.progressBarContainer[0].alpha = 1
            self.progressBarCover[0].alpha = 1
            self.progressBarProgress[0].alpha = 1
            self.musicDeleteButton[0].alpha = 1
            self.musicDeleteButton[0].isEnabled = true
        }
        playBackgroundMusic(fileName: backgroundMusic, isFirst: isFirst)
    }
    
    func deleteBackgroundMusic() {
        backgroundMusic = nil
        backgroundMusicFileName = ""
        coverAnimation(backgroundMusicFileName, soundEffectFileName)
        UIView.animate(withDuration: 0.3) {
            self.progressBarContainer[0].alpha = 0
            self.progressBarCover[0].alpha = 0
            self.progressBarProgress[0].alpha = 0
            self.musicDeleteButton[0].alpha = 0
            self.musicDeleteButton[0].isEnabled = false
        }
    }
}

//MARK: - deliverSoundEffectDelegate
extension MusicAddViewController: DeliverSoundEffectDelegate {
    // SoundEffectCollectionView 클릭시 전달
    func deliverSoundEffect(soundEffect: String, add: Bool) {
        if add {
            addSoundEffect(soundEffect)
        } else {
            deleteSoundEffect(soundEffect)
        }
    }
    
    func addSoundEffect(_ soundEffect: String, isFirst: Bool = false) {
        if soundEffectFileName.count == 3 { return }
        soundEffectFileName.append(soundEffect)
        coverAnimation(backgroundMusicFileName, soundEffectFileName)
        let index = soundEffectFileName.count
        let originX = progressBarContainer[index].center.x
        let originY = isFirst ? (-111 * musicVolumeArr[index]) + 170 : 114.0
        let progressBarConstant = isFirst ? 1.1 * (180 - originY) : 70
        progressBarHandle[index].center = CGPoint(x: originX, y: CGFloat(originY))
        progressBarProgress[index].constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = CGFloat(progressBarConstant)
            }
        }
        progressBarThumbnail[index].image = UIImage(named: "\(soundEffect)Icon")
        UIView.animate(withDuration: 0.3) {
            self.progressBarContainer[index].alpha = 1
            self.progressBarCover[index].alpha = 1
            self.progressBarProgress[index].alpha = 1
            self.musicDeleteButton[index].alpha = 1
            self.musicDeleteButton[index].isEnabled = true
        }
        playSoundEffect(fileName: soundEffect, index: index, isFirst: isFirst)
    }
    
    func deleteSoundEffect(_ soundEffect: String) {
        let removedIndex = soundEffectFileName.firstIndex(of: soundEffect)!
        soundEffectArr.remove(at: removedIndex)
        soundEffectFileName.remove(at: removedIndex)
        coverAnimation(backgroundMusicFileName, soundEffectFileName)
        let index = soundEffectFileName.count
        UIView.animate(withDuration: 0.3) {
            self.progressBarContainer[index+1].alpha = 0
            self.progressBarCover[index+1].alpha = 0
            self.progressBarProgress[index+1].alpha = 0
            self.musicDeleteButton[index+1].alpha = 0
            self.musicDeleteButton[index+1].isEnabled = false
        }
        if removedIndex != index {
            for index in removedIndex+1...index {
                progressBarHandle[index].center.y = progressBarHandle[index+1].center.y
                progressBarProgress[index].constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.constant = progressBarProgress[index+1].bounds.height
                    }
                }
                progressBarThumbnail[index].image = progressBarThumbnail[index+1].image
            }
        }
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


