//
//  EachCountryViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/20.
//

import UIKit
import Kingfisher

class EachCountryViewController: UIViewController {
    @IBOutlet weak var upperBackgroundView: UIView!
    @IBOutlet weak var countryName: UIButton!
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var lowerBackgroundView: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var hitTag: UIImageView!
    @IBOutlet weak var hitArticleTableView: UITableView!
    @IBOutlet weak var eachArticleTableView: UITableView!
    @IBOutlet weak var eachArticleTableViewConstraintY: NSLayoutConstraint!
    
    @IBOutlet var countryContainer: UIView!
    @IBOutlet var countryCollectionView: UICollectionView!
    @IBOutlet weak var countryPageControl: UIPageControl!
    
    let viewModel = EachCountryViewModel()
    let mainCountry = MainCountry()
    var selectOn = false
    var currentCountry = ""
    var hitArticle: Article?
    var eachArticleArr = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentCountry()
        addMultipleFonts()
        addCountryCollectionView()
        makeCircular(target: lowerBackgroundView, each: true)
        makeCircular(target: writeButton, each: false)
        // CountryCollectionView
        countryCollectionView.register(CountrySelectCollectionViewCell.nib(), forCellWithReuseIdentifier: "CountrySelectCollectionViewCell")
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self
        // HitArticleTableView
        hitArticleTableView.register(EachArticleTableViewCell.nib(), forCellReuseIdentifier: "EachArticleTableViewCell")
        hitArticleTableView.dataSource = self
        hitArticleTableView.delegate = self
        // EachArticleTableView
        eachArticleTableView.register(EachArticleTableViewCell.nib(), forCellReuseIdentifier: "EachArticleTableViewCell")
        eachArticleTableView.register(EachDefaultTableViewCell.nib(), forCellReuseIdentifier: "EachDefaultTableViewCell")
        eachArticleTableView.dataSource = self
        eachArticleTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let blockedUsers = UserDefaults.standard.stringArray(forKey: "blockedUsers")!
        viewModel.getHitArticle(country: currentCountry) { article in
            self.hitArticle = article
            self.hitArticleTableView.reloadData()
        }
        viewModel.getEachArticle(country: currentCountry) { articleArr in
            self.eachArticleArr = articleArr
            self.eachArticleArr = self.eachArticleArr.filter{!blockedUsers.contains($0.autherEmail)}
            self.eachArticleTableView.reloadData()
            self.makeTableViewHeight()
        }
    }
    
    @objc func tabDimView() {
        countryCollectionViewSlideAnimation()
    }
    
    @IBAction func selectCountryPressed(_ sender: UIButton) {
        countryCollectionViewSlideAnimation()
    }
    
    @IBAction func writeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWritting", sender: sender)
    }
}

//MARK: - UI Functions
extension EachCountryViewController {
    func setCurrentCountry() {
        countryName.setTitle(currentCountry, for: .normal)
        countryName.frame.size = CGSize(width: 20 * currentCountry.count, height: 41)
    }
    
    func addCountryCollectionView() {
        let width = self.view.bounds.width
        countryContainer.frame = CGRect(x: 0, y: -246, width: width, height: 246)
        self.view.insertSubview(countryContainer, belowSubview: upperBackgroundView)
    }
    
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
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 14)!, range: (introduceLabel.text! as NSString).range(of: "여행 경험"))
        introduceLabel.attributedText = attributedString
    }
    
    func makeTableViewHeight() {
        eachArticleTableView.layoutIfNeeded()
        let cellCount = eachArticleArr.count
        if cellCount == 0 {
            eachArticleTableViewConstraintY.constant = 300
        } else {
            let cellHeight = 100
            eachArticleTableViewConstraintY.constant = CGFloat(cellCount * cellHeight)
        }
    }
    
    func countryCollectionViewSlideAnimation() {
        if selectOn {
            // Background Dim
            guard let dimView = self.view.viewWithTag(100) else { return }
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                dimView.removeFromSuperview()
            }, completion: nil)
            // CountryCollectionView
            UIView.animate(withDuration: 0.5) {
                self.countryContainer.frame.origin.y = -246
            }
            // selectCountryButton
            UIView.animate(withDuration: 0.6) {
                self.selectCountryButton.transform = self.selectCountryButton.transform.rotated(by: .pi)
            }
            selectOn = false
        } else {
            // Background Dim
            let safeAreaY = self.view.safeAreaLayoutGuide.layoutFrame.minY
            let width = self.view.bounds.width
            let height = self.view.bounds.height
            let dimView = UIView()
            dimView.frame = CGRect(x: 0, y: safeAreaY, width: width, height: height-safeAreaY)
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            dimView.tag = 100
            let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabDimView))
            dimView.addGestureRecognizer(tapGestureReconizer)
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.view.insertSubview(dimView, belowSubview: self.countryContainer)
            }, completion: nil)
            // CountryCollectionView
            UIView.animate(withDuration: 0.5) {
                self.countryContainer.frame.origin.y = safeAreaY
            }
            // selectCountryButton
            UIView.animate(withDuration: 0.6) {
                self.selectCountryButton.transform = self.selectCountryButton.transform.rotated(by: .pi)
            }
            selectOn = true
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension EachCountryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCountry.countryName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountrySelectCollectionViewCell", for: indexPath) as! CountrySelectCollectionViewCell
        cell.countryImage.image = mainCountry.countryImage[indexPath.row]!
        cell.CountryName.text = mainCountry.countryName[indexPath.row]
        makeBorder(target: cell.countryImage, radius: 6, color: "Gray6", isFilled: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mainCountry.countryName[indexPath.row] == "메인" {
            self.navigationController?.popViewController(animated: true)
        } else if mainCountry.countryName[indexPath.row] == currentCountry {
            countryCollectionViewSlideAnimation()
        } else {
            let blockedUsers = UserDefaults.standard.stringArray(forKey: "blockedUsers")!
            currentCountry = mainCountry.countryName[indexPath.row]
            setCurrentCountry()
            viewModel.getHitArticle(country: currentCountry) { article in
                self.hitArticle = article
                self.hitArticleTableView.reloadData()
            }
            viewModel.getEachArticle(country: currentCountry) { articleArr in
                self.eachArticleArr = articleArr
                self.eachArticleArr = self.eachArticleArr.filter{!blockedUsers.contains($0.autherEmail)}
                self.eachArticleTableView.reloadData()
                self.makeTableViewHeight()
            }
            countryCollectionViewSlideAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0.0 {
            self.countryPageControl.currentPage = 1
        } else {
            self.countryPageControl.currentPage = 0
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension EachCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hitArticleTableView {
            let hitArticle = hitArticle == nil ? 0 : 1
            hitTag.alpha = CGFloat(hitArticle)
            return hitArticle
        } else {
            if eachArticleArr.count == 0 {
                return 1
            } else {
                return eachArticleArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == hitArticleTableView {
            return 100
        } else {
            if eachArticleArr.count == 0 {
                return 300
            } else {
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hitArticleTableView {
            let blockedUsers =  UserDefaults.standard.stringArray(forKey: "blockedUsers")!
            let cell = tableView.dequeueReusableCell(withIdentifier: "EachArticleTableViewCell", for: indexPath) as! EachArticleTableViewCell
            cell.selectionStyle = .none
            
            if blockedUsers.contains(hitArticle!.autherEmail) {
                cell.title.text = "차단된 사용자의 게시글이에요."
                cell.auther.text = hitArticle!.auther
                cell.boardingTime.text = hitArticle!.strWrittenDate
                cell.likes.setTitle(String(hitArticle!.likes), for: .normal)
                cell.views.setTitle(String(hitArticle!.views), for: .normal)
                cell.isUserInteractionEnabled = false
                cell.mainImage.image = UIImage()
            } else {
                cell.title.text = hitArticle!.title
                cell.auther.text = hitArticle!.auther
                cell.boardingTime.text = hitArticle!.strWrittenDate
                cell.likes.setTitle(String(hitArticle!.likes), for: .normal)
                cell.views.setTitle(String(hitArticle!.views), for: .normal)
                cell.isUserInteractionEnabled = true
                viewModel.getImageUrl(imageUrl: hitArticle!.imageUrl) { url in
                    if let url = url {
                        // 이미지가 있을 때 이미지 설정
                        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
                        cell.mainImage.kf.setImage(with: url, options: [.processor(processor)])
                    } else {
                        // 이미지가 없을 때 default이미지 설정
                        cell.mainImage.image = UIImage(named: "DefaultArticleImage")
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.makeShadow(target: cell.shadowView)
                cell.mainView.roundCorners(topLeft: 6, bottomLeft: 24)
                cell.mainImage.roundCorners(topRight: 24, bottomRight: 6)
            }
            cell.layoutIfNeeded()
            return cell
        } else {
            if eachArticleArr.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EachDefaultTableViewCell", for: indexPath) as! EachDefaultTableViewCell
                cell.selectionStyle = .none
                return cell
            } else {
                let eachArticle = eachArticleArr[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "EachArticleTableViewCell", for: indexPath) as! EachArticleTableViewCell
                cell.selectionStyle = .none
                cell.title.text = eachArticle.title
                cell.auther.text = eachArticle.auther
                cell.boardingTime.text = eachArticle.strWrittenDate
                cell.likes.setTitle(String(eachArticle.likes), for: .normal)
                cell.views.setTitle(String(eachArticle.views), for: .normal)
                viewModel.getImageUrl(imageUrl: eachArticle.imageUrl) { url in
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == hitArticleTableView {
            let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
            let articleDetailVC = storyboard.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailViewController
            articleDetailVC.article = hitArticle!
            self.navigationController?.pushViewController(articleDetailVC, animated: true)
        } else {
            if eachArticleArr.count != 0 {
                let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
                let articleDetailVC = storyboard.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailViewController
                if let indexPath = eachArticleTableView.indexPathForSelectedRow {
                    articleDetailVC.article = eachArticleArr[indexPath.row]
                }
                self.navigationController?.pushViewController(articleDetailVC, animated: true)
            }
        }
    }
}
