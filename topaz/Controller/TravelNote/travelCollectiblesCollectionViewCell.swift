//
//  travelCollectiblesCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/11/03.
//

import UIKit

class travelCollectiblesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectiblesIcon: UIImageView!
    @IBOutlet weak var collectiblesName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "travelCollectiblesCollectionViewCell", bundle: nil)
    }
}
