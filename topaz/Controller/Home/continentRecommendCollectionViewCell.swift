//
//  ContinentRecommendCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2023/06/16.
//

import UIKit

class ContinentRecommendCollectionViewCell: UICollectionViewCell {
    
    var tapAction: (() -> ())?
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryNameEngLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        setViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countryImageView.image = nil
        countryFlagImageView.image = nil
    }

    static func nib() -> UINib {
        return UINib(nibName: "ContinentRecommendCollectionViewCell", bundle: nil)
    }
    
    @objc func didTapView() {
        tapAction?()
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
    
    func configureCell(_ restCountry: RestCountryResults) {
        ///Shadow
        makeShadow(target: self, radius: 12, width: 5, height: 10, opacity: 0.2, shadowRadius: 5)
        ///Country Names
        countryNameLabel.text = restCountry.translations.kor.common
        countryNameEngLabel.text = restCountry.name.common.count > 10 ? "" : restCountry.name.common
    }
}
