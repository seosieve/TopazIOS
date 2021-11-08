//
//  TravelTicketCollectionViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/11/08.
//

import UIKit

class TravelTicketCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ticketBackground: UIView!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var ticketNickname: UILabel!
    @IBOutlet weak var ticketDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(nickname: String, date: String) {
        makeBorder(target: ticketBackground, radius: 12, isFilled: true)
        makeShadow(target: ticketImage, radius: 12, height: 3, opacity: 0.5, shadowRadius: 4)
        makeShadow(target: ticketBackground, radius: 12, height: 3, opacity: 0.2, shadowRadius: 4)
        ticketNickname.text = nickname
        ticketDate.text = date
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TravelTicketCollectionViewCell", bundle: nil)
    }

}
