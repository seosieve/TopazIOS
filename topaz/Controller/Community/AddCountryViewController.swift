//
//  AddCountryViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/13.
//

import UIKit

class AddCountryViewController: UIViewController {
    
    @IBOutlet weak var countryCollectionView: UICollectionView!
    @IBOutlet weak var countryPageControl: UIPageControl!
    
    
    let countryImageArr = [UIImage(named: "England"), UIImage(named: "France"), UIImage(named: "Germany"), UIImage(named: "India"), UIImage(named: "Japan"), UIImage(named: "Philippine"), UIImage(named: "Taiwan"), UIImage(named: "Thailand"), UIImage(named: "USA")]
    let countryNameArr = ["영국", "프랑스", "독일", "인도", "일본", "필리핀", "대만", "태국", "미국"]
    var selectedCountryArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircular(target: countryCollectionView, each: true)
        
        countryCollectionView.register(CountryCollectionViewCell.nib(), forCellWithReuseIdentifier: "CountryCollectionViewCell")
        countryCollectionView.allowsMultipleSelection = true
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self

    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UI Functions
extension AddCountryViewController {
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
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AddCountryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCollectionViewCell", for: indexPath) as! CountryCollectionViewCell
        cell.configure(image: countryImageArr[indexPath.row]!, text: countryNameArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        print("You Tapped\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0.0 {
            self.countryPageControl.currentPage = 1
        } else {
            self.countryPageControl.currentPage = 0
        }
    }
}
