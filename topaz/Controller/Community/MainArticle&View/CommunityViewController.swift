//
//  CommunityViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit
import Firebase

class CommunityViewController: UIViewController {

    @IBOutlet weak var upperBackground: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var luggageCollectionView: UICollectionView!
    @IBOutlet weak var fullArticleTableView: UITableView!
    
    let viewModel = CommunityViewModel()
    
    var timer = Timer()
    var counter = 0
    let luggageImgArr = [UIImage(named: "Luggage1"), UIImage(named: "Luggage3"), UIImage(named: "Luggage2"), UIImage(named: "Luggage3"), UIImage(named: "Luggage1")]
    
    var articleArr = [Article]()
    
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
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.changeLuggage), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getArticle { article in
            self.articleArr = article
            self.fullArticleTableView.reloadData()
            DispatchQueue.main.async {
                self.makeTableViewHeight()
            }
        }
    }
    
    @IBAction func countryDetailPressed(_ sender: UIButton) {
        fullArticleTableView.reloadData()
    }
    
    @objc func changeLuggage() {
        UIView.animate(withDuration: 4) {
            let index = IndexPath.init(item: self.counter, section: 0)
            self.luggageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.luggageCollectionView.layoutIfNeeded()
            self.counter += 1
        }
    }
    
    @IBAction func writeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWritting", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMainDetail" {
            let destinationVC = segue.destination as! MainDetailViewController
            if let indexPath = fullArticleTableView.indexPathForSelectedRow {
                destinationVC.article = articleArr[indexPath.row]
            }
        }
    }
}

//MARK: - UI Functions
extension CommunityViewController {
    // 각각 edge에 맞는 Radius적용
    func makeCircular(target view: UIView, each: Bool) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
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
    // 반응형 TableView height
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: introduceLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 14)!, range: (introduceLabel.text! as NSString).range(of: "여행 캐리어"))
        introduceLabel.attributedText = attributedString
    }
    
    func makeTableViewHeight() {
        fullArticleTableView.layoutIfNeeded()
        fullArticleTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = fullArticleTableView.contentSize.height
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemToShow = luggageImgArr[indexPath.row % luggageImgArr.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "luggageCell", for: indexPath) as! luggageCollectionViewCell
        cell.luggageImage.image = itemToShow
        return cell
    }
    
}

class luggageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var luggageImage: UIImageView!
    

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullArticleTableViewCell", for: indexPath) as! FullArticleTableViewCell
        cell.selectionStyle = .none
        let articleForRow = articleArr[indexPath.row]
        cell.title.text = articleForRow.title
        cell.auther.text = articleForRow.auther
        cell.country.text = articleForRow.country[0]
        let countryNumber = articleForRow.country.count
        if countryNumber == 1 {
            cell.countryNumber.isHidden = true
        } else {
            cell.countryNumber.isHidden = false
            cell.countryNumber.text = "+\(countryNumber-1)"
        }
        cell.likes.setTitle(String(articleForRow.likes), for: .normal)
        cell.views.setTitle(String(articleForRow.views), for: .normal)
        
        makeCircle(target: cell.countryNumber, color: "MintBlue", width: 0)
        viewModel.getArticleImage(articleID: articleForRow.articleID, imageText: articleForRow.imageText) { image in
            cell.mainImage.image = image
        }
        
        DispatchQueue.main.async {
            self.makeShadow(target: cell.shadowView)
            cell.mainView.roundCorners(topLeft: 6, bottomLeft: 24)
            cell.mainImage.roundCorners(topRight: 24, bottomRight: 6)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMainDetail", sender: self)
    }
}

