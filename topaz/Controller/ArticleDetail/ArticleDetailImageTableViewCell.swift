//
//  MainDetailImageTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/09/28.
//

import UIKit

class ArticleDetailImageTableViewCell: UITableViewCell {
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var experienceLabelBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ArticleDetailImageTableViewCell", bundle: nil)
    }
}
