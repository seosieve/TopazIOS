//
//  MainDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit

class MainDetailViewController: UIViewController {
    // Head
    @IBOutlet weak var country1: UIButton!
    @IBOutlet weak var country2: UIButton!
    @IBOutlet weak var country3: UIButton!
    @IBOutlet weak var country1Tail: UIButton!
    @IBOutlet weak var country2Tail: UIButton!
    @IBOutlet weak var country3Tail: UIButton!
    @IBOutlet weak var likeBarItem: UIBarButtonItem!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailAutherImage: UIImageView!
    @IBOutlet weak var detailNickname: UILabel!
    @IBOutlet weak var detailstrWrittenDate: UILabel!
    @IBOutlet weak var backgroundMusicButton: UIButton!
    // Body
    @IBOutlet weak var detailMainText: UILabel!
    @IBOutlet weak var mainDetailImageTableView: UITableView!
    @IBOutlet weak var detailTailText: UILabel!
    // Tail
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var views: UILabel!
    
    var article: Article?
    let viewModel = MainDetailViewModel()
    lazy var currentLikes = article!.likes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeArticleUI()
        
        mainDetailImageTableView.register(MainDetailImageTableViewCell.nib(), forCellReuseIdentifier: "MainDetailImageTableViewCell")
        mainDetailImageTableView.dataSource = self
        mainDetailImageTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeTableViewHeight()
    }
    @IBAction func likesBarItemPressed(_ sender: UIBarButtonItem) {
        if sender.tintColor == UIColor(named: "Gray1") {
            sender.tintColor = UIColor(named: "MintBlue")
            likesButton.backgroundColor = UIColor(named: "MintBlue")
            likes.textColor = UIColor(named: "MintBlue")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: true)

        } else {
            sender.tintColor = UIColor(named: "Gray1")
            likesButton.backgroundColor = UIColor(named: "Gray2")
            likes.textColor = UIColor(named: "Gray4")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: false)
        }
    }
    
    @IBAction func likesButtonPressed(_ sender: UIButton) {
        if sender.backgroundColor == UIColor(named: "Gray2") {
            sender.backgroundColor = UIColor(named: "MintBlue")
            likeBarItem.tintColor = UIColor(named: "MintBlue")
            likes.textColor = UIColor(named: "MintBlue")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: true)
        } else {
            sender.backgroundColor = UIColor(named: "Gray2")
            likeBarItem.tintColor = UIColor(named: "Gray1")
            likes.textColor = UIColor(named: "Gray4")
            viewModel.increaseLikes(currentID: article!.articleID, isIncrease: false)
        }
    }
}

//MARK: - UI Functions
extension MainDetailViewController {
    func makeArticleUI() {
        // 여행국가 설정
        let countryCount = article?.country.count
        switch countryCount {
        case 1:
            country1.setTitle(article!.country[0], for: .normal)
            makeCircle(target: country1, width: 1)
            makeCircle(target: country1Tail, width: 1)
        case 2:
            country1.setTitle(article!.country[0], for: .normal)
            country2.setTitle(article!.country[1], for: .normal)
            makeCircle(target: country1, width: 1)
            makeCircle(target: country2, width: 1)
            makeCircle(target: country1Tail, width: 1)
            makeCircle(target: country2Tail, width: 1)
        default:
            country1.setTitle(article!.country[0], for: .normal)
            country2.setTitle(article!.country[1], for: .normal)
            country3.setTitle(article!.country[2], for: .normal)
            makeCircle(target: country1, width: 1)
            makeCircle(target: country2, width: 1)
            makeCircle(target: country3, width: 1)
            makeCircle(target: country1Tail, width: 1)
            makeCircle(target: country2Tail, width: 1)
            makeCircle(target: country3Tail, width: 1)
        }
        country1Tail.setTitle(country1.currentTitle, for: .normal)
        country2Tail.setTitle(country2.currentTitle, for: .normal)
        country3Tail.setTitle(country3.currentTitle, for: .normal)
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
        viewModel.getUserImage(email: article!.autherEmail) { image in
            self.detailAutherImage.image = image
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
        viewModel.increaseViews(currentID: article!.articleID)
        likes.text = "\(self.article!.likes)"
        views.text = "\(self.article!.views + 1)"
    }
    
    func setGradient() {
        let color1 = UIColor(named: "MintBlue")!
        let color2 = UIColor(named: "SkyBlue")!
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = backgroundMusicButton.bounds
        backgroundMusicButton.layer.addSublayer(gradient)
        backgroundMusicButton.setImage(UIImage(named: "MusicIcon"), for: .normal)
        makeCircle(target: backgroundMusicButton, color: "MintBlue", width: 0)
    }
    
    func makeTableViewHeight() {
        mainDetailImageTableView.layoutIfNeeded()
        mainDetailImageTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = mainDetailImageTableView.contentSize.height
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article!.imageText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainDetailImageTableViewCell", for: indexPath) as! MainDetailImageTableViewCell
        cell.selectionStyle = .none
        makeBorder(target: cell.experienceLabelBorder, radius: 12, isFilled: true)
        viewModel.getExperienceImage(articleID: article!.articleID, index: indexPath.row) { image in
            cell.experienceImage.image = image
        }
        if article!.imageText[indexPath.row] == "" {
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
        makeBorder(target: cell.experienceImage, radius: 12, color: "Gray6", isFilled: false)
        return cell
    }
}
