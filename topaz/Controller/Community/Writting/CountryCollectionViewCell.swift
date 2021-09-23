//
//  CountryCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/09/13.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selected()
            } else {
                deselected()
            }
        }
    }
    
    func configure(image: UIImage, text: String) {
        countryImage.image = image
        makeBorder(target: countryImage, radius: 6, color: "Gray6", isFilled: false)
        countryName.text = text
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CountryCollectionViewCell", bundle: nil)
    }

}

//MARK: - UI Functions
extension CountryCollectionViewCell {
    func selected() {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: "MintBlue")?.withAlphaComponent(0.4)
        selectedView.frame = countryImage.layer.frame
        selectedView.tag = 100
        if countryImage.viewWithTag(100) == nil {
            countryImage.addSubview(selectedView)
        }
        countryImage.layer.borderWidth = 2
        countryImage.layer.borderColor = UIColor(named: "MintBlue")?.cgColor
    }
    
    func deselected() {
        if let viewWithTag = countryImage.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        countryImage.layer.borderWidth = 1
        countryImage.layer.borderColor = UIColor(named: "Gray6")?.cgColor
    }
}
