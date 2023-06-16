//
//  ContinentRecommendCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2023/06/16.
//

import UIKit

class ContinentRecommendCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.backgroundColor = .red
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "ContinentRecommendCollectionViewCell", bundle: nil)
    }
    
}
