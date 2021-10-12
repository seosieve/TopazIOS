//
//  CommunityViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase
import Kingfisher

class CommunityViewController: UIViewController {

    @IBOutlet weak var upperBackground: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var swipeSortConstraintY: NSLayoutConstraint!
    @IBOutlet weak var selectedSortMethod: UIButton!
    @IBOutlet weak var sortMethod1: UIButton!
    @IBOutlet weak var sortMethod2: UIButton!
    @IBOutlet weak var luggageCollectionView: UICollectionView!
    @IBOutlet weak var fullArticleTableView: UITableView!
    @IBOutlet weak var fullArticleTableViewConstraintY: NSLayoutConstraint!
    
    let viewModel = CommunityViewModel()
    
    var timer = Timer()
    var counter = 0
    let luggageImgArr = [UIImage(named: "Luggage1"), UIImage(named: "Luggage3"), UIImage(named: "Luggage2"), UIImage(named: "Luggage1"), UIImage(named: "Luggage2")]
    var collectionArticleArr = [Article]()
    var tableArticleArr = [Article]()
    var sortMethod = ["조회수순", "좋아요순", "업로드순"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        makeCircular(target: upperBackground, each: true)
        makeCircular(target: writeButton, each: false)
        addMultipleFonts()
        // CollectionView
        luggageCollectionView.dataSource = self
        luggageCollectionView.delegate = self
        // TableView
        fullArticleTableView.register(FullArticleTableViewCell.nib(), forCellReuseIdentifier: "FullArticleTableViewCell")
        fullArticleTableView.dataSource = self
        fullArticleTableView.delegate = self
        // CollectionView Animation
        viewModel.getCollectionArticle { articleArr in
            self.collectionArticleArr = articleArr
            self.luggageCollectionView.reloadData()
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.moveLuggage), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sortMethod = selectedSortMethod.currentTitle!
        viewModel.getTableArticle(sortMethod: sortMethod) { articleArr in
            self.tableArticleArr = articleArr
            self.fullArticleTableView.reloadData()
            self.makeTableViewHeight()
        }
    }
    
    @objc func moveLuggage() {
        UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction]) {
            let index = IndexPath.init(item: self.counter, section: 0)
            self.luggageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.luggageCollectionView.layoutIfNeeded()
            self.counter += 1
        }
    }
    
    @IBAction func sortMethodPressed(_ sender: UIButton) {
        swipeSortConstraintY.constant = -105
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        selectedSortMethod.setTitle(sender.currentTitle, for: .normal)
        let remainSortMethod = sortMethod.filter{$0 != sender.currentTitle}
        sortMethod1.setTitle(remainSortMethod[0], for: .normal)
        sortMethod2.setTitle(remainSortMethod[1], for: .normal)
        let sortMethod = selectedSortMethod.currentTitle!
        viewModel.getTableArticle(sortMethod: sortMethod) { articleArr in
            self.tableArticleArr = articleArr
            self.fullArticleTableView.reloadData()
            DispatchQueue.main.async {
                self.makeTableViewHeight()
            }
        }
        
    }
    
    @IBAction func swipeSortButtonPressed(_ sender: UIButton) {
        let constraint: CGFloat = swipeSortConstraintY.constant == 16 ? -105 : 16
        swipeSortConstraintY.constant = constraint
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func writeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWritting", sender: sender)
    }
    
    @IBAction func selectCountryPressed(_ sender: UIButton) {
        print("aa")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMainDetail" {
            let destinationVC = segue.destination as! MainDetailViewController
            if let indexPath = fullArticleTableView.indexPathForSelectedRow {
                destinationVC.article = tableArticleArr[indexPath.row]
            }
            if let indexPath = luggageCollectionView.indexPathsForSelectedItems?.last {
                let count = collectionArticleArr.count
                destinationVC.article = collectionArticleArr[indexPath.row % count]
            }
        }
    }
}

//MARK: - UI Functions
extension CommunityViewController {
    func makeCircular(target view: UIView, each: Bool) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        if each {
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    // TableView Shadow 생성
    func makeShadow(target view: UIView) {
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 24).cgPath
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: introduceLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 14)!, range: (introduceLabel.text! as NSString).range(of: "여행 캐리어"))
        introduceLabel.attributedText = attributedString
    }
    
    func makeTableViewHeight() {
        fullArticleTableView.layoutIfNeeded()
        let cellCount = tableArticleArr.count
        let cellHeight = 100
        fullArticleTableViewConstraintY.constant = CGFloat(cellCount * cellHeight)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionArticleArr.count == 0 {
            return collectionArticleArr.count
        } else {
            return Int.max
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = collectionArticleArr.count == 0 ? 1 : collectionArticleArr.count
        let luggage = luggageImgArr[indexPath.row % luggageImgArr.count]
        let collectionArticle = collectionArticleArr[indexPath.row % count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "luggageCell", for: indexPath) as! LuggageCollectionViewCell
        cell.luggageImage.image = luggage
        cell.luggageTag.text = collectionArticle.country[0]
        cell.luggageAuther.text = collectionArticle.auther
        cell.luggageTitle.text = collectionArticle.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMainDetail", sender: self)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArticleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableArticle = tableArticleArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullArticleTableViewCell", for: indexPath) as! FullArticleTableViewCell
        cell.selectionStyle = .none
        // make cell
        cell.title.text = tableArticle.title
        cell.auther.text = tableArticle.auther
        cell.country.text = tableArticle.country[0]
        let countryNumber = tableArticle.country.count
        let isCountryNumberOne = countryNumber == 1 ? true : false
        cell.countryNumber.isHidden = isCountryNumberOne
        cell.countryNumber.text = "+\(countryNumber-1)"
        cell.likes.setTitle(String(tableArticle.likes), for: .normal)
        cell.views.setTitle(String(tableArticle.views), for: .normal)
        makeCircle(target: cell.countryNumber, color: "MintBlue", width: 0)
        // Image Set
        viewModel.getImageUrl(imageUrl: tableArticle.imageUrl) { url in
            if let url = url {
                // 이미지가 있을 때 이미지 설정
                let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
                cell.mainImage.kf.setImage(with: url, options: [.processor(processor)])
            } else {
                // 이미지가 없을 때 default이미지 설정
                cell.mainImage.image = UIImage(named: "DefaultArticleImage")
            }
        }
        DispatchQueue.main.async {
            self.makeShadow(target: cell.shadowView)
            cell.mainView.roundCorners(topLeft: 6, bottomLeft: 24)
            cell.mainImage.roundCorners(topRight: 24, bottomRight: 6)
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMainDetail", sender: self)
    }
}
