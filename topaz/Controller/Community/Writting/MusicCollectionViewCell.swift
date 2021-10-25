//
//  MusicCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var musicBackground: UIView!
    @IBOutlet weak var musicIcon: UIImageView!
    @IBOutlet weak var musicName: UILabel!

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
        musicIcon.image = image
        musicName.text = text
        makeBorder(target: musicBackground, radius: 12, width: 3, color: "Gray6", isFilled: false)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MusicCollectionViewCell", bundle: nil)
    }

}

//MARK: - UI Functions
extension MusicCollectionViewCell {
    func selected() {
        musicBackground.setGradient(viewBelow: musicIcon)
        musicBackground.layer.borderWidth = 0
        musicIcon.tintColor = UIColor(named: "White")
        musicName.textColor = UIColor(named: "Gray2")
        musicName.font = UIFont(name: "NotoSansKR-Medium", size: 12)
    }
    
    func deselected() {
        for layer in musicBackground.layer.sublayers! {
            if layer.name == "gradient" {
                layer.removeFromSuperlayer()
            }
        }
        musicBackground.layer.borderWidth = 3
        musicIcon.tintColor = UIColor(named: "Gray6")
        musicName.textColor = UIColor(named: "Gray3")
        musicName.font = UIFont(name: "NotoSansKR-Regular", size: 12)
    }
}

//MARK: - UIView
extension UIView {
    func setGradient(viewBelow: UIView){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "gradient"
        let topColor = UIColor(red: 0.43, green: 0.93, blue: 0.90, alpha: 1)
        let bottomColor = UIColor(red: 0.19, green: 0.83, blue: 0.83, alpha: 1)
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.cornerRadius = 12
        layer.insertSublayer(gradient, below: viewBelow.layer)
    }
}
