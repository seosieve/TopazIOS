//
//  CountrySelectCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/20.
//

import UIKit

class CountrySelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var CountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CountrySelectCollectionViewCell", bundle: nil)
    }

}
