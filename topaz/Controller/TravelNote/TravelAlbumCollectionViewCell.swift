//
//  TravelAlbumCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/11/04.
//

import UIKit

class TravelAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumConstraintY: NSLayoutConstraint!
    @IBOutlet weak var albumBackground: UIView!
    @IBOutlet weak var albumSticker: UIImageView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String, date: String) {
        makeBorder(target: albumBackground, radius: 12, isFilled: true)
        makeBorder(target: albumImage, radius: 12, isFilled: true)
        makeShadow(target: albumBackground, radius: 12, height: 3, opacity: 0.2, shadowRadius: 4)
        albumName.text = name
        albumDate.text = date
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TravelAlbumCollectionViewCell", bundle: nil)
    }

}
