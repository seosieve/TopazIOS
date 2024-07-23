//
//  ContinentRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/12/29.
//

import UIKit
import Lottie

class ContinentRecommendViewController: UIViewController {
    @IBOutlet weak var lottieBackgroundView: UIView!
    @IBOutlet weak var continentRecommendViewContainer: UIView!
    @IBOutlet weak var continentTitleLabel: UILabel!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var continentRecommendCollectionView: UICollectionView!
    
    let lottieView = LottieAnimationView(name: "Loading")
    var bySearchButton = false
    var continent = ""
    var restCountryResults = [RestCountryResults]()
    var unsplashResults = [UnsplashResults?]()
    var clickedRestCountryResult:RestCountryResults? = nil
    var clickedUnsplashResult:UnsplashResults? = nil
    
    let viewModel = ContinentRecommendViewModel()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        makeModalCircular(target: continentRecommendViewContainer)
        makeCircle(target: searchContainerView)
        makeTitleLabel(bySearchButton)
        makeViewByContinent(continent: continent)
        searchTextField.borderStyle = .none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        continentRecommendCollectionView.delegate = self
        continentRecommendCollectionView.dataSource = self
        continentRecommendCollectionView.register(ContinentRecommendCollectionViewCell.nib(), forCellWithReuseIdentifier: "recommendCell")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        searchTextField.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let textInput = textField.text ?? ""
        print(textInput)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCountryDetail" {
            let destinationVC = segue.destination as! CountryDetailViewController
            destinationVC.restCountryResult = clickedRestCountryResult
            destinationVC.unsplashResults = clickedUnsplashResult
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
    
    func makeViewByContinent(continent: String) {
        loadingAnimation(lottieBackgroundView, lottieView, view: self.view)
        if bySearchButton {
            viewModel.getCountry { results in
                self.restCountryResults = results
                self.unsplashResults = Array(repeating: nil, count: results.count)
                DispatchQueue.main.async {
                    self.lottieBackgroundView.isHidden = true
                    self.lottieView.isHidden = true
                    self.continentRecommendCollectionView.reloadData()
                }
            }
        } else {
            guard let continent = Continent(rawValue: continent) else { return }
            let selectedContinent = String(describing: continent)
            
            viewModel.getCountry(byContinent: selectedContinent) { results in
                self.restCountryResults = results
                self.unsplashResults = Array(repeating: nil, count: results.count)
                DispatchQueue.main.async {
                    self.lottieBackgroundView.isHidden = true
                    self.lottieView.isHidden = true
                    self.continentRecommendCollectionView.reloadData()
                }
            }
        }
    }
    
    func popUpToast(_ string: String) {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: string, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate
extension ContinentRecommendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        loadingAnimation(lottieBackgroundView, lottieView, view: self.view)
        restCountryResults.removeAll()
        if text.isEmpty {
            if bySearchButton {
                viewModel.getCountry { results in
                    self.restCountryResults = results
                    self.unsplashResults = Array(repeating: nil, count: results.count)
                    DispatchQueue.main.async {
                        self.lottieBackgroundView.isHidden = true
                        self.lottieView.isHidden = true
                        self.continentRecommendCollectionView.reloadData()
                    }
                }
            } else {
                guard let continent = Continent(rawValue: continent) else { return false }
                let selectedContinent = String(describing: continent)
                
                viewModel.getCountry(byContinent: selectedContinent) { results in
                    self.restCountryResults = results
                    self.unsplashResults = Array(repeating: nil, count: results.count)
                    DispatchQueue.main.async {
                        self.lottieBackgroundView.isHidden = true
                        self.lottieView.isHidden = true
                        self.continentRecommendCollectionView.reloadData()
                    }
                }
            }
        } else {
            viewModel.getCountry(byName: text) { results in
                // 검색한 단어로 이루어진 나라가 없을 때
                if results.isEmpty {
                    self.restCountryResults = results
                    self.unsplashResults = Array(repeating: nil, count: results.count)
                    DispatchQueue.main.async {
                        self.popUpToast("\(text)라는 나라를 찾을 수 없어요. 다시 검색해주세요.")
                        self.lottieBackgroundView.isHidden = true
                        self.lottieView.isHidden = true
                        self.continentRecommendCollectionView.reloadData()
                    }
                } else {
                    self.restCountryResults = results
                    self.unsplashResults = Array(repeating: nil, count: results.count)
                    results.forEach { result in
                        DispatchQueue.main.async {
                            self.lottieBackgroundView.isHidden = true
                            self.lottieView.isHidden = true
                            self.continentRecommendCollectionView.reloadData()
                        }
                    }
                }
            }
        }
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
        ///Configure Reusable Cell
        let identifier = "recommendCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ContinentRecommendCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        ///Configure List
        let restCountry = restCountryResults[indexPath.row]
        cell.configureCell(restCountry)
        ///Flag Image
        let urlString = restCountry.flags.png
        let fileName = restCountry.name.official
        networkManager.getImage(urlString: urlString, fileName: fileName) { image in
            cell.countryFlagImageView.image = image
        }
        ///Unsplash Image
        viewModel.getImage(by: restCountry.name.common) { unsplashResult in
            if unsplashResult == nil {
                DispatchQueue.main.async {
                    cell.countryImageView.image = UIImage(named: "DefaultArticleImage")
                }
                self.unsplashResults[indexPath.row] = nil
            } else {
                cell.countryImageView.load(url: unsplashResult!.results[0].urls.smallUrl)
                self.unsplashResults[indexPath.row] = unsplashResult
            }
        }
        ///Click Action
        cell.tapAction = {
            print(indexPath)
            print(self.restCountryResults[indexPath.row])
            print(self.unsplashResults[indexPath.row])
            print("*********************************")
            self.clickedRestCountryResult = self.restCountryResults[indexPath.row]
            self.clickedUnsplashResult = self.unsplashResults[indexPath.row]
            self.performSegue(withIdentifier: "goToCountryDetail", sender: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 56)/2
        return CGSize(width: width, height: 168)
    }
}
