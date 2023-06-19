//
//  PlaceRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/09.
//

import UIKit

protocol PlaceRecommendDelegate {
    func goToTicketing()
}

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
    @IBOutlet weak var ticketingButton: UIButton!
    
    let recommendCountry = RecommendCountry()
    let unsplashCountry = UnsplashCountry()
    var placeRecommendDelegate: PlaceRecommendDelegate?
    let viewModel = PlaceRecommendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: placeRecommendViewContainer)
        placeButton.forEach { button in
            makeBorder(target: button, radius: 12, isFilled: true)
        }
        makeBorder(target: ticketingButton, radius: 12, isFilled: true)
        let recommendPlace = recommendCountryEnglishName.text ?? "Airplane"
        viewModel.getImage(by: recommendPlace) { UrlArr in
            self.unsplashCountry.countryImage[0] = UrlArr
            //이미지 그리기
            self.unsplashImageDraw(1)
        }
    }
    
    @IBAction func placeButtonPressed(_ sender: UIButton) {
        makePlaceButtonSelected(selectedButton: sender)
        changeRecommendPlace(selectedButton: sender)
        changeTicketingButton(selectedButton: sender)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ticketingButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
        placeRecommendDelegate?.goToTicketing()
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
        recommendCountryName.text = recommendCountry.countryName[tag-1]
        recommendCountryEnglishName.text = recommendCountry.countryEnglishName[tag-1]
        recommendCountryIntroduce.text = recommendCountry.countryIntroduce[tag-1]
        // 이미지 변경 - Unsplash Image Load
        if unsplashCountry.countryImage[tag-1].isEmpty {
            let recommendPlace = recommendCountryEnglishName.text ?? "Airplane"
            viewModel.getImage(by: recommendPlace) { UrlArr in
                self.unsplashCountry.countryImage[tag-1] = UrlArr
                //이미지 그리기
                self.unsplashImageDraw(tag)
            }
        } else {
            print("Unsplash Image already exist")
            self.unsplashImageDraw(tag)
        }
        // API Call 갯수 한계시에 Default Image로 설정해야하는데 한계점 찍어도 터지지는 않는듯..??
    }
    
    func unsplashImageDraw(_ tag: Int) {
        DispatchQueue.main.async {
            let instantImageView = UIImageView()
            instantImageView.frame = CGRect(x: 0, y: 0, width: self.recommendCountryImage.bounds.width, height: self.recommendCountryImage.bounds.height)
            self.recommendCountryImage.addSubview(instantImageView)
            for i in 0..<self.unsplashCountry.countryImage[tag-1].count {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i*3)) {
                    UIView.transition(with: instantImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        instantImageView.load(url: self.unsplashCountry.countryImage[tag-1][i])
                    }, completion: nil)
                }
            }
        }
    }
    
    func changeTicketingButton(selectedButton: UIButton) {
        let tag = selectedButton.tag
        switch tag {
        case 2,4,5:
            UIView.animate(withDuration: 0.3) {
                self.ticketingButton.backgroundColor = UIColor(named: "MintBlue")
                self.ticketingButton.isEnabled = true
            }
        default:
            UIView.animate(withDuration: 0.3) {
                self.ticketingButton.backgroundColor = UIColor(named: "Gray6")
                self.ticketingButton.isEnabled = false
            }
        }
    }
}
