//
//  ContinentRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/12/29.
//

import UIKit

class ContinentRecommendViewController: UIViewController {
    @IBOutlet weak var continentRecommendViewContainer: UIView!
    @IBOutlet weak var continentTitleLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var continentRecommendCollectionView: UICollectionView!
    @IBOutlet weak var continentRecommendCollectionViewH: NSLayoutConstraint!
    
    
    var bySearchButton = false
    var continent = ""
    var restCountryResults = [RestCountryResults]()
    
    let viewModel = ContinentRecommendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: continentRecommendViewContainer)
        makeTitleLabel(bySearchButton)
        makeCircle(target: searchContainerView)
        searchTextField.borderStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        continentRecommendCollectionView.delegate = self
        continentRecommendCollectionView.dataSource = self
        continentRecommendCollectionView.register(ContinentRecommendCollectionViewCell.nib(), forCellWithReuseIdentifier: "recommendCell")
        //height 나중에 다 구현하고 다시 손보기
//        let height = continentRecommendCollectionView.collectionViewLayout.collectionViewContentSize.height
//        continentRecommendCollectionViewH.constant = height
//        view.layoutIfNeeded()
        
        
        viewModel.getCountry(by: "캐") { results in
            self.restCountryResults = results
            DispatchQueue.main.async {
                self.continentRecommendCollectionView.reloadData()
            }
            print(self.restCountryResults.count)
        }
    }
    
    @IBAction func cancleButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        searchTextField.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let textInput = textField.text ?? ""
        
        let a = ["한국", "하그그브", "하네넨"]
        a.forEach { aa in
            if aa.contains(textInput) {
                print(aa)
            }
        }
    }
}

//MARK: - UI Functions
extension ContinentRecommendViewController {
    func makeTitleLabel(_ bySearchButton: Bool) {
        if bySearchButton {
            continentTitleLabel.text = "어디로 떠나실래요?"
        } else {
            switch continent {
            case "유럽":
                continentTitleLabel.text = "\(continent)으로 떠나실래요?"
            default:
                continentTitleLabel.text = "\(continent)로 떠나실래요?"
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension ContinentRecommendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        viewModel.getCountry(by: text) { results in
            self.restCountryResults = results
            DispatchQueue.main.async {
                self.continentRecommendCollectionView.reloadData()
            }
            print(self.restCountryResults.count)
        }
        print(text)
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UICollectionView
extension ContinentRecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restCountryResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! ContinentRecommendCollectionViewCell
        makeShadow(target: cell, radius: 12, width: 5, height: 10, opacity: 0.2, shadowRadius: 5)
        cell.countryFlagImageView.load(url: URL(string: restCountryResults[indexPath.row].flags.png)!)
        cell.countryNameLabel.text = restCountryResults[indexPath.row].translations.kor.official
        cell.countryNameEngLabel.text = restCountryResults[indexPath.row].name.common
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 56)/2
        return CGSize(width: width, height: 168)
    }
}
