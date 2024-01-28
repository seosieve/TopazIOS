//
//  CountryInfoViewController.swift
//  topaz
//
//  Created by 서충원 on 2023/06/24.
//

import UIKit
import Lottie

class CountryInfoViewController: UIViewController {
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var lottieBackgroundView: UIView!
    @IBOutlet weak var imageLink: UIButton!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryEnglishName: UILabel!
    @IBOutlet weak var countryScript: UILabel!
    
    var restCountryResult: RestCountryResults? = nil
    var unsplashResults: UnsplashResults? = nil
    var link:String? = nil
    
    let lottieView = LottieAnimationView(name: "Loading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    @IBAction func imageLinkPressed(_ sender: Any) {
        if let link = link {
            openUrl(urlStr: link)
        }
    }
}

//MARK: - UI Functions
extension CountryInfoViewController {
    func setViews() {
        countryName.text = restCountryResult?.translations.kor.common
        countryEnglishName.text = restCountryResult?.name.common
//        countryScript.text = "\(restCountryResult?.name.common) is located in \(subregion), it’s exact latitude and longitude is \(latlng). International time is \(timezones) faster or slower than Korea’s time. \(population) of people are living, and capital city is \(capital). They speaks \(languages.ara). \(flag)"
        
        if unsplashResults == nil {
            imageLink.setTitle("", for: .normal)
            countryImageView.image = UIImage(named: "France")
        } else {
            loadingAnimation(lottieBackgroundView, lottieView, view: countryImageView)
            //Set Link Title
            let photographer = unsplashResults!.results[0].user.name
            imageLink.setTitle("Photo by \(photographer) on Unsplash", for: .normal)
            addUnderlinedText(photographer)
            //Send Link html
            link = unsplashResults!.results[0].links.html
            //Set Image
            countryImageView.loadWithHandler(url: unsplashResults!.results[0].urls.fullUrl) {
                DispatchQueue.main.async {
                    self.lottieBackgroundView.isHidden = true
                    self.lottieView.isHidden = true
                }
            }
        }
    }
    
    func addUnderlinedText(_ range: String) {
        guard let title = imageLink.title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (imageLink.currentTitle! as NSString).range(of: range))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (imageLink.currentTitle! as NSString).range(of: "Unsplash"))
        imageLink.setAttributedTitle(attributedString, for: .normal)
    }
}
