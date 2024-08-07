//
//  MainDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit
import Lottie
import Kingfisher
import SwiftySound

class ArticleDetailViewController: UIViewController {
    // Head
    @IBOutlet var countryHead: [UIButton]! {
        didSet {countryHead.sort {$0.tag < $1.tag}}
    }
    @IBOutlet weak var likeBarItem: UIBarButtonItem!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailAutherImage: UIImageView!
    @IBOutlet weak var detailNickname: UILabel!
    @IBOutlet weak var detailstrWrittenDate: UILabel!
    @IBOutlet weak var detailMusicButton: UIButton!
    // Body
    @IBOutlet weak var detailMainText: UILabel!
    @IBOutlet weak var mainDetailImageTableView: UITableView!
    @IBOutlet weak var mainDetailImageTableViewConstraintY: NSLayoutConstraint!
    @IBOutlet weak var detailTailText: UILabel!
    // Tail
    @IBOutlet var countryTail: [UIButton]! {
        didSet {countryTail.sort {$0.tag < $1.tag}}
    }
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var views: UILabel!
    
    var article: Article?
    let viewModel = ArticleDetailViewModel()
    let userdefault = UserDefaults.standard
    var musicNameArr = ["", "", "", ""]
    var musicVolumeArr: [Float] = [0, 0, 0, 0]
    var musicPlayArr = [Sound?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDetailImageTableView.register(ArticleDetailImageTableViewCell.nib(), forCellReuseIdentifier: "MainDetailImageTableViewCell")
        mainDetailImageTableView.dataSource = self
        mainDetailImageTableView.delegate = self
        
        viewModel.increaseViews(currentID: article!.articleID)
        article?.views += 1
        views.text = "\(self.article!.views + 1)"
        makeArticleUI()
        makeTableViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayArr.forEach { music in
            music?.stop()
        }
    }

    @IBAction func likesBarItemPressed(_ sender: UIBarButtonItem) {
        if sender.tintColor == UIColor(named: "Gray1") {
            sender.tintColor = UIColor(named: "MintBlue")
            likesButton.backgroundColor = UIColor(named: "MintBlue")
            likes.textColor = UIColor(named: "MintBlue")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: true)
            article?.likes += 1
            likes.text = "\(Int(likes.text!)! + 1)"
        } else {
            sender.tintColor = UIColor(named: "Gray1")
            likesButton.backgroundColor = UIColor(named: "Gray2")
            likes.textColor = UIColor(named: "Gray4")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: false)
            article?.likes -= 1
            likes.text = "\(Int(likes.text!)! - 1)"
        }
    }
    
    @IBAction func likesButtonPressed(_ sender: UIButton) {
        if sender.backgroundColor == UIColor(named: "Gray2") {
            sender.backgroundColor = UIColor(named: "MintBlue")
            likeBarItem.tintColor = UIColor(named: "MintBlue")
            likes.textColor = UIColor(named: "MintBlue")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: true)
            article?.likes += 1
            likes.text = "\(Int(likes.text!)! + 1)"
        } else {
            sender.backgroundColor = UIColor(named: "Gray2")
            likeBarItem.tintColor = UIColor(named: "Gray1")
            likes.textColor = UIColor(named: "Gray4")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: false)
            article?.likes -= 1
            likes.text = "\(Int(likes.text!)! - 1)"
        }
    }
    
    @IBAction func detailBarButtonPressed(_ sender: UIBarButtonItem) {
        if userdefault.string(forKey: "nickname") == article?.auther {
            deleteAndModifyAlert()
        } else {
            blockAndReportAlert()
        }
    }
    
    @IBAction func detailMusicButtonPressed(_ sender: UIButton) {
        if sender.backgroundColor == UIColor(named: "MintBlue") {
            pauseMusic()
            sender.backgroundColor = UIColor(named: "Gray5")
            makeShadow(target: detailMusicButton, opacity: 0)
        } else {
            playMusic()
            sender.backgroundColor = UIColor(named: "MintBlue")
            makeShadow(target: detailMusicButton, radius: detailMusicButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToModify" {
            let destinationVC = segue.destination as! ModifyViewController
            destinationVC.article = article
            destinationVC.modifyDelegate = self
        } else if segue.identifier == "goToReport" {
            let destinationVC = segue.destination as! ReportViewController
            destinationVC.article = article
        }
    }
}

//MARK: - UI Functions
extension ArticleDetailViewController {
    func makeArticleUI() {
        // 음악 설정
        makeCircle(target: detailMusicButton, color: "MintBlue", width: 0)
        makeShadow(target: detailMusicButton, radius: detailMusicButton.frame.size.height/2, width: 2, height: 2, opacity: 0.3)
        if article!.musicName == ["", "", "", ""] {
            detailMusicButton.isHidden = true
        } else {
            detailMusicButton.isHidden = false
            musicNameArr = article!.musicName
            musicVolumeArr = article!.musicVolume
            let isOn = detailMusicButton.backgroundColor == UIColor(named: "MintBlue") ? true : false
            setMusic(isOn: isOn)
        }
        // 여행국가 설정
        let countryCount = article!.country.count
        for index in 0...2 {
            countryHead[index].setTitle(nil, for: .normal)
            countryTail[index].setTitle(nil, for: .normal)
            makeCircle(target: countryHead[index], width: 0)
            makeCircle(target: countryTail[index], width: 0)
        }
        for index in 0...countryCount-1 {
            countryHead[index].setTitle(article!.country[index], for: .normal)
            countryTail[index].setTitle(countryHead[index].currentTitle, for: .normal)
            makeCircle(target: countryHead[index], width: 1)
            makeCircle(target: countryTail[index], width: 1)
        }
        // Head부분 설정
        viewModel.isClickedLikes(currentID: article!.articleID) { isClicked in
            if isClicked {
                self.likeBarItem.tintColor = UIColor(named: "MintBlue")
                self.likesButton.backgroundColor = UIColor(named: "MintBlue")
                self.likes.textColor = UIColor(named: "MintBlue")
            } else {
                self.likeBarItem.tintColor = UIColor(named: "Gray1")
                self.likesButton.backgroundColor = UIColor(named: "Gray2")
                self.likes.textColor = UIColor(named: "Gray4")
            }
        }
        detailTitle.text = article!.title
        detailNickname.text = article!.auther
        detailstrWrittenDate.text = article!.strWrittenDate
        viewModel.getUserImage(email: article!.autherEmail) { url in
            self.detailAutherImage.kf.setImage(with: url)
            makeCircle(target: self.detailAutherImage)
        }
        // Body부분 설정
        detailMainText.text = article!.mainText
        if article!.tailText == "" {
            detailTailText.isHidden = true
        }
        detailTailText.text = article!.tailText
        // Tail부분 설정
        makeCircle(target: likesButton)
        likes.text = "\(self.article!.likes)"
    }
    
    func makeTableViewHeight() {
        // Maximum Size Constraint 설정
        let cellCount = CGFloat(article?.imageText.count ?? 0)
        let cellHeight = view.frame.height
        mainDetailImageTableViewConstraintY.constant = cellCount * cellHeight
        // VisibleCells를 통해 Constraint 재설정
        mainDetailImageTableView.layoutIfNeeded()
        let cells = mainDetailImageTableView.visibleCells
        var contentSizeHeight: CGFloat = 0.0
        for cell in cells {
            contentSizeHeight += cell.frame.height
        }
        mainDetailImageTableViewConstraintY.constant = contentSizeHeight
    }
    
    func deleteAndModifyAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "수정하기", style: .default) { action in
            self.performSegue(withIdentifier: "goToModify", sender: action)
        }
        let delete = UIAlertAction(title: "삭제하기", style: .default) { action in
            self.deleteConfirmAlert()
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        modify.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        delete.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteConfirmAlert() {
        let alert = UIAlertController(title: "정말 글을 삭제하시겠어요?", message: "한 번 삭제된 글은 다시 되돌릴 수 없으니 신중하게 결정해주세요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .default) { action in
            // 삭제시 Animation
            let backgroundView = UIView()
            let lottieView = LottieAnimationView(name: "Loading")
            loadingAnimation(backgroundView, lottieView, view: self.view)
            // 유저 경험치 감소
            self.viewModel.minusUserExp()
            // storage 사진 삭제
            let articleID = self.article!.articleID
            let imageCount = self.article!.imageText.count
            for index in 0..<imageCount {
                self.viewModel.deleteExperienceImage(articleID: articleID, index: index)
            }
            // Article 삭제
            self.viewModel.deleteArticle(articleID: articleID) {
                backgroundView.removeFromSuperview()
                lottieView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        delete.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }
    
    func blockAndReportAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let block = UIAlertAction(title: "차단하기", style: .default) { action in
            let blockedUsers = self.userdefault.stringArray(forKey: "blockedUsers")!
            if blockedUsers.count < 10 {
                self.blockConfirmAlert()
            } else {
                self.popUpToast()
            }
            
        }
        let report = UIAlertAction(title: "신고하기", style: .default) { action in
            self.performSegue(withIdentifier: "goToReport", sender: action)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        block.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        report.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        cancle.setValue(UIColor(named: "Gray2"), forKey: "titleTextColor")
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
    }
    
    func blockConfirmAlert() {
        let alert = UIAlertController(title: "정말 유저를 차단하시겠어요?", message: "유저를 차단하면 해당 유저의 글이 더이상 보이지 않아요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let block = UIAlertAction(title: "차단", style: .default) { action in
            let autherEmail = self.article!.autherEmail
            self.viewModel.blockUser(autherEmail: autherEmail) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(cancel)
        alert.addAction(block)
        block.setValue(UIColor(named: "WarningRed"), forKey: "titleTextColor")
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }
    
    func popUpToast() {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "차단은 최대 10명까지 가능합니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func setMusic(isOn: Bool = true) {
        DispatchQueue.global().async {
            self.musicPlayArr = [Sound?]()
            for (index,musicName) in self.musicNameArr.enumerated() {
                if musicName != "" {
                    let url = Bundle.main.url(forResource: musicName, withExtension: "mp3")!
                    let sound = Sound(url: url)!
                    self.musicPlayArr.append(sound)
                    sound.play(numberOfLoops: -1)
                    let volume = isOn ? self.musicVolumeArr[index] : 0
                    sound.volume = volume
                }
            }
        }
    }
    
    func playMusic() {
        DispatchQueue.global().async {
            for (index,sound) in self.musicPlayArr.enumerated() {
                sound?.resume()
                sound?.fadeInResume(vol: self.musicVolumeArr[index])
            }
        }
    }
    
    func pauseMusic() {
        DispatchQueue.global().async {
            for sound in self.musicPlayArr {
                sound?.fadeOutPause()
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article!.imageText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainDetailImageTableViewCell", for: indexPath) as! ArticleDetailImageTableViewCell
        cell.selectionStyle = .none
        makeBorder(target: cell.experienceLabelBorder, radius: 12, isFilled: true)
        makeBorder(target: cell.experienceImage, radius: 12, color: "Gray6", isFilled: false)
        // image load
        viewModel.getImageUrl(url: article!.imageUrl[indexPath.row]) { url in
            cell.experienceImage.kf.setImage(with: url)
        }
        if article!.imageText[indexPath.row] == "" {
            // imageText에 아무런 글자도 없을 때 셀 간 간격 좁힘
            cell.experienceLabelBorder.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                }
                if constraint.firstAttribute == .top {
                    constraint.constant = 0
                }
                if constraint.firstAttribute == .bottom {
                    constraint.constant = 0
                }
            }
            cell.experienceLabelBorder.isHidden = true
            cell.experienceLabel.text = nil
        } else {
            // imageText에 글자가 있을 때
            cell.experienceLabelBorder.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = 50
                }
                if constraint.firstAttribute == .top {
                    constraint.constant = 8
                }
                if constraint.firstAttribute == .bottom {
                    constraint.constant = 16
                }
            }
            cell.experienceLabelBorder.isHidden = false
            cell.experienceLabel.text = article!.imageText[indexPath.row]
        }
        return cell
    }
}

//MARK: - ModifyArticleDelegate
extension ArticleDetailViewController: ModifyArticleDelegate {
    func modifyArticle(modifyArticleHandler: @escaping () -> ()) {
        viewModel.getArticle(articleID: article!.articleID) { article in
            self.article = article
            self.makeArticleUI()
            self.mainDetailImageTableView.reloadData()
            self.makeTableViewHeight()
            modifyArticleHandler()
        }
    }
    
    func cancle() {
        if detailMusicButton.backgroundColor == UIColor(named: "MintBlue") {
            musicPlayArr.forEach { music in
                music?.play()
            }
        } else {
            musicPlayArr.forEach { music in
                music?.pause()
            }
        }
    }
}
