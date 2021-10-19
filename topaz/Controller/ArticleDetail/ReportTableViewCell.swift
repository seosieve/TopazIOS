//
//  ReportTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/19.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var reportText: UILabel!
    @IBOutlet weak var reportCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            UIView.transition(with: reportCheck, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.reportCheck.image = UIImage(named: "Check_ON")
            }, completion: nil)
        } else {
            self.reportCheck.image = UIImage(named: "Check_OFF")
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ReportTableViewCell", bundle: nil)
    }
}
