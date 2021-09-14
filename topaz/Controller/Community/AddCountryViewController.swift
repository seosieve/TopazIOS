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
    @IBOutlet weak var country1: UIButton!
    @IBOutlet weak var country2: UIButton!
    @IBOutlet weak var country3: UIButton!
    
    
    let countryImageArr = [UIImage(named: "England"), UIImage(named: "France"), UIImage(named: "Germany"), UIImage(named: "India"), UIImage(named: "Japan"), UIImage(named: "Philippine"), UIImage(named: "Taiwan"), UIImage(named: "Thailand"), UIImage(named: "USA")]
    let countryNameArr = ["영국", "프랑스", "독일", "인도", "일본", "필리핀", "대만", "태국", "미국"]
    var selectedCountryArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircular(target: countryCollectionView, each: true)
        drawSelectedCountry()
        
        countryCollectionView.register(CountryCollectionViewCell.nib(), forCellWithReuseIdentifier: "CountryCollectionViewCell")
        countryCollectionView.allowsMultipleSelection = true
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self

    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        let destinationVC = self.presentingViewController as? WrittingViewController
        deliverCountry(VC: destinationVC)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func countryButtonPressed(_ sender: UIButton) {
        let countryTitle = sender.currentTitle
        selectedCountryArr = selectedCountryArr.filter{$0 != countryTitle}
        let countryIndex = countryNameArr.firstIndex(of: countryTitle!)!
        countryCollectionView.deselectItem(at: [0,countryIndex], animated: true)
        drawSelectedCountry()
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
    
    func drawSelectedCountry() {
        let arrCount = selectedCountryArr.count
        if arrCount == 0 {
            country1.isHidden = true; country1.isEnabled = false
            country2.isHidden = true; country2.isEnabled = false
            country3.isHidden = true; country3.isEnabled = false
        } else if arrCount == 1 {
            country1.isHidden = false; country1.isEnabled = true
            country1.setTitle(selectedCountryArr[0], for: .normal)
            makeCircle(target: country1, color: "MintBlue", width: 1)
            country2.isHidden = true; country2.isEnabled = false
            country3.isHidden = true; country3.isEnabled = false
        } else if arrCount == 2 {
            country1.isHidden = false; country1.isEnabled = true
            country2.isHidden = false; country2.isEnabled = true
            country1.setTitle(selectedCountryArr[0], for: .normal)
            country2.setTitle(selectedCountryArr[1], for: .normal)
            makeCircle(target: country1, color: "MintBlue", width: 1)
            makeCircle(target: country2, color: "MintBlue", width: 1)
            country3.isHidden = true; country3.isEnabled = false
        } else if arrCount == 3 {
            country2.isHidden = false; country2.isEnabled = true
            country3.isHidden = false; country3.isEnabled = true
            country1.setTitle(selectedCountryArr[0], for: .normal)
            country2.setTitle(selectedCountryArr[1], for: .normal)
            country3.setTitle(selectedCountryArr[2], for: .normal)
            makeCircle(target: country1, color: "MintBlue", width: 1)
            makeCircle(target: country2, color: "MintBlue", width: 1)
            makeCircle(target: country3, color: "MintBlue", width: 1)
        }
    }
    
    func popUpToast() {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "나라는 최대 3개까지 선택할 수 있습니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func deliverCountry(VC: WrittingViewController?) {
        if selectedCountryArr.count == 1 {
            VC?.countryName1 = selectedCountryArr[0]
            VC?.countryName2 = nil
            VC?.countryName3 = nil
        } else if selectedCountryArr.count == 2 {
            VC?.countryName1 = selectedCountryArr[0]
            VC?.countryName2 = selectedCountryArr[1]
            VC?.countryName3 = nil
        } else if selectedCountryArr.count == 3 {
            VC?.countryName1 = selectedCountryArr[0]
            VC?.countryName2 = selectedCountryArr[1]
            VC?.countryName3 = selectedCountryArr[2]
        } else {
            VC?.countryName1 = nil
            VC?.countryName2 = nil
            VC?.countryName3 = nil
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
        if selectedCountryArr.count <= 2 {
            selectedCountryArr.append(countryNameArr[indexPath.row])
            drawSelectedCountry()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            popUpToast()
        }
        print(selectedCountryArr)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCountryArr = selectedCountryArr.filter{$0 != countryNameArr[indexPath.row]}
        drawSelectedCountry()
        print(selectedCountryArr)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0.0 {
            self.countryPageControl.currentPage = 1
        } else {
            self.countryPageControl.currentPage = 0
        }
    }
}
