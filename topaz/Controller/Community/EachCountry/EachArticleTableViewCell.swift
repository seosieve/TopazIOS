//
//  EachArticleTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/20.
//

import UIKit

class EachArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var auther: UILabel!
    @IBOutlet weak var boardingTime: UILabel!
    @IBOutlet weak var likes: UIButton!
    @IBOutlet weak var views: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "EachArticleTableViewCell", bundle: nil)
    }
}
