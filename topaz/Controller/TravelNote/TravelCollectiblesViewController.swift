//
//  TravelCollectiblesViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/03.
//

import UIKit

class TravelCollectiblesViewController: UIViewController {
    @IBOutlet weak var travelCollectiblesContainer: UIView!
    @IBOutlet weak var travelCollectiblesCollectionView: UICollectionView!
    @IBOutlet weak var collectiblesPageControl: UIPageControl!
    
    @IBOutlet var collectiblesDetailContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionViewLayout(travelCollectiblesCollectionView)
        travelCollectiblesCollectionView.register(travelCollectiblesCollectionViewCell.nib(), forCellWithReuseIdentifier: "CollectiblesCollectionViewCell")
        travelCollectiblesCollectionView.dataSource = self
        travelCollectiblesCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeBorder(target: travelCollectiblesContainer, radius: 12, isFilled: true)
        makeShadow(target: travelCollectiblesContainer, radius: 12, height: 3, opacity: 0.2, shadowRadius: 4)
    }

}

//MARK: - UI Functions
extension TravelCollectiblesViewController {
    func makeCollectionViewLayout(_ collectionView: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 98, height: 122)
        let width = UIScreen.main.bounds.width
        let spacing = (width - 334) / 3
        let inset = spacing / 2
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func addCollectiblesView() {
        // Background Dim
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let dimView = UIView()
        dimView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        dimView.tag = 100
        self.tabBarController?.view.addSubview(dimView)
        // collectiblesView
        collectiblesDetailContainer.frame = CGRect(x: 0, y: 0, width: width - 48, height: 580)
        collectiblesDetailContainer.center = CGPoint(x: width/2, y: height/2)
        self.tabBarController?.view.addSubview(collectiblesDetailContainer)
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TravelCollectiblesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectiblesCollectionViewCell", for: indexPath) as! travelCollectiblesCollectionViewCell
        if indexPath.row == 0 {
            cell.collectiblesIcon.image = UIImage(named: "WelcomeSnowBall")
            cell.collectiblesName.text = "웰컴 스노우볼"
        } else {
            cell.collectiblesIcon.image = UIImage(named: "UnacquiredCollectibles")
            cell.collectiblesName.text = "미획득 수집품"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        addCollectiblesView()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0.0 {
            self.collectiblesPageControl.currentPage = 1
        } else {
            self.collectiblesPageControl.currentPage = 0
        }
    }
}
