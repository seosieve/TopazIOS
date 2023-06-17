//
//  ContinentRecommendCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2023/06/16.
//

import UIKit

class ContinentRecommendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    static func nib() -> UINib {
        return UINib(nibName: "ContinentRecommendCollectionViewCell", bundle: nil)
    }
    
    func setViews() {
        countryImageView.clipsToBounds = true
        countryImageView.layer.cornerRadius = 12
        countryImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        countryFlagImageView.clipsToBounds = true
        countryFlagImageView.layer.cornerRadius = 4
        countryFlagImageView.layer.borderWidth = 1
        countryFlagImageView.layer.borderColor = UIColor(named: "Gray6")?.cgColor
        
        textContainerView.clipsToBounds = true
        textContainerView.layer.cornerRadius = 12
        textContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}
