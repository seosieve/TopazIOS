//
//  EachDefaultTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/20.
//

import UIKit

class EachDefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var defaultText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "EachDefaultTableViewCell", bundle: nil)
    }
}
