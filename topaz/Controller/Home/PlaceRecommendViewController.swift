//
//  PlaceRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/09.
//

import UIKit

class PlaceRecommendViewController: UIViewController {
    @IBOutlet weak var placeRecommendViewContainer: UIView!
    @IBOutlet var placeButton: [UIButton]! {
        didSet {placeButton.sort{$0.tag < $1.tag}}
    }
    @IBOutlet var placeLabel: [UILabel]! {
        didSet {placeLabel.sort{$0.tag < $1.tag}}
    }
    @IBOutlet weak var recommendCountryImage: UIImageView!
    @IBOutlet weak var recommendCountryImageConstraintY: NSLayoutConstraint!
    @IBOutlet weak var recommendCountryName: UILabel!
    @IBOutlet weak var recommendCountryEnglishName: UILabel!
    @IBOutlet weak var recommendCountryIntroduce: UILabel!
    
    let recommendCountry = RecommendCountry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: placeRecommendViewContainer)
        placeButton.forEach { button in
            makeBorder(target: button, radius: 12, isFilled: true)
        }
    }
    
    @IBAction func placeButtonPressed(_ sender: UIButton) {
        makePlaceButtonSelected(selectedButton: sender)
        changeRecommendPlace(selectedButton: sender)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UI Functions
extension PlaceRecommendViewController {
    func makePlaceButtonSelected(selectedButton: UIButton) {
        let tag = selectedButton.tag
        placeButton.forEach { button in
            if button.isSelected == true {
                button.isSelected = false
            }
        }
        placeLabel.forEach { label in
            if label.font == UIFont(name: "NotoSansKR-Bold", size: 12) {
                label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
            }
        }
        UIView.transition(with: selectedButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            selectedButton.isSelected = true }, completion: nil)
        placeLabel[tag-1].font = UIFont(name: "NotoSansKR-Bold", size: 12)
    }
    
    func changeRecommendPlace(selectedButton: UIButton) {
        let tag = selectedButton.tag
        UIView.transition(with: recommendCountryImage, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.recommendCountryImage.image = self.recommendCountry.countryImage[tag-1]
        }, completion: nil)
        recommendCountryName.text = recommendCountry.countryName[tag-1]
        recommendCountryEnglishName.text = recommendCountry.countryEnglishName[tag-1]
        recommendCountryIntroduce.text = recommendCountry.countryIntroduce[tag-1]
    }
}
