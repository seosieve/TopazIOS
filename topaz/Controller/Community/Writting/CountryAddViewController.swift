//
//  AddCountryViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/13.
//

import UIKit

protocol AddCountryDelegate {
    func addCountry(selectedCountryArr: [String], addCountryHandler: @escaping () -> ())
}

class CountryAddViewController: UIViewController {
    @IBOutlet weak var countryCollectionView: UICollectionView!
    
    @IBOutlet weak var countryPageControl: UIPageControl!
    @IBOutlet var countryButton: [UIButton]! {
        didSet {countryButton.sort {$0.tag < $1.tag}}
    }
    
    var countryDelegate: AddCountryDelegate?
    
    let country = Country()
    var selectedCountryArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCollectionView.register(CountryAddCollectionViewCell.nib(), forCellWithReuseIdentifier: "CountryAddCollectionViewCell")
        countryCollectionView.allowsMultipleSelection = true
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self

        makeCircular(target: countryCollectionView, each: true)
        drawSelectedCountry()
        drawSelectedCell()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        countryDelegate?.addCountry(selectedCountryArr: selectedCountryArr) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func countryButtonPressed(_ sender: UIButton) {
        let countryTitle = sender.currentTitle!
        selectedCountryArr = selectedCountryArr.filter{$0 != countryTitle}
        let countryIndex = country.countryName.firstIndex(of: countryTitle)!
        countryCollectionView.deselectItem(at: [0,countryIndex], animated: true)
        drawSelectedCountry()
    }
}

//MARK: - UI Functions
extension CountryAddViewController {
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
    
    func drawSelectedCell() {
        for selectedCountry in selectedCountryArr {
            let countryIndex = country.countryName.firstIndex(of: selectedCountry)!
            countryCollectionView.selectItem(at: [0,countryIndex], animated: true, scrollPosition: .init())
        }
    }
    
    func drawSelectedCountry() {
        let countryArrCount = selectedCountryArr.count
        // 버튼 모두 초기화
        countryButton.forEach { button in
            button.isHidden = true
            button.isEnabled = false
        }
        // 선택된 버튼들만 그려주기
        if countryArrCount == 0 { return }
        for index in 0...countryArrCount-1 {
            countryButton[index].isHidden = false
            countryButton[index].isEnabled = true
            countryButton[index].setTitle(selectedCountryArr[index], for: .normal)
            makeCircle(target: countryButton[index], width: 1)
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
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CountryAddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return country.countryName.count
    } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryAddCollectionViewCell", for: indexPath) as! CountryAddCollectionViewCell
        cell.configure(image: country.countryImage[indexPath.row]!, text: country.countryName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCountryArr.count <= 2 {
            selectedCountryArr.append(country.countryName[indexPath.row])
            drawSelectedCountry()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            popUpToast()
        }
        print(selectedCountryArr)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCountryArr = selectedCountryArr.filter{$0 != country.countryName[indexPath.row]}
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
