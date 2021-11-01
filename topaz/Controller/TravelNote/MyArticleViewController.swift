//
//  MyArticleViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit
import Kingfisher

class MyArticleViewController: UIViewController {
    
    @IBOutlet weak var myArticleTableView: UITableView!
    @IBOutlet weak var myArticleTableViewConstraintY: NSLayoutConstraint!
    @IBOutlet weak var myArticleTableViewConstraintT: NSLayoutConstraint!
    
    let viewModel = MyArticleViewModel()
    var myArticleArr = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        myArticleTableView.alpha = 0
        myArticleTableView.register(EachArticleTableViewCell.nib(), forCellReuseIdentifier: "EachArticleTableViewCell")
        myArticleTableView.register(EachDefaultTableViewCell.nib(), forCellReuseIdentifier: "EachDefaultTableViewCell")
        myArticleTableView.dataSource = self
        myArticleTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyArticle { articleArr in
            self.myArticleArr = articleArr
            self.myArticleTableView.reloadData()
            self.makeTableViewHeight()
            self.myArticleTableView.alpha = 1
        }
    }
}

//MARK: - UI Functions
extension MyArticleViewController {
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
    
    func makeTableViewHeight() {
        myArticleTableView.layoutIfNeeded()
        let cellCount = myArticleArr.count
        if cellCount == 0 {
            myArticleTableViewConstraintY.constant = 300
        } else {
            let cellHeight = 100
            myArticleTableViewConstraintY.constant = CGFloat(cellCount * cellHeight)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MyArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myArticleArr.count == 0 {
            return 1
        } else {
            return myArticleArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myArticleArr.count == 0 {
            myArticleTableViewConstraintT.constant = 200
            return 300
        } else {
            myArticleTableViewConstraintT.constant = 20
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myArticleArr.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EachDefaultTableViewCell", for: indexPath) as! EachDefaultTableViewCell
            cell.selectionStyle = .none
            cell.defaultText.text = "아직 작성한 여행경험이 없어요"
            return cell
        } else {
            let myArticle = myArticleArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EachArticleTableViewCell", for: indexPath) as! EachArticleTableViewCell
            cell.selectionStyle = .none
            cell.title.text = myArticle.title
            cell.auther.text = myArticle.auther
            cell.boardingTime.text = myArticle.strWrittenDate
            cell.likes.setTitle(String(myArticle.likes), for: .normal)
            cell.views.setTitle(String(myArticle.views), for: .normal)
            viewModel.getImageUrl(imageUrl: myArticle.imageUrl) { url in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myArticleArr.count != 0 {
            let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
            let articleDetailVC = storyboard.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailViewController
            if let indexPath = myArticleTableView.indexPathForSelectedRow {
                articleDetailVC.article = myArticleArr[indexPath.row]
            }
            self.navigationController?.pushViewController(articleDetailVC, animated: true)
        }
    }
}
