//
//  BlockUserListTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/11/11.
//

import UIKit

protocol BlockUserListDelegate {
    func unblockUser(sender: UIButton)
}

class BlockUserListTableViewCell: UITableViewCell {
    @IBOutlet weak var blockUserImage: UIImageView!
    @IBOutlet weak var blockUserNickname: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    var blockUserListDelegate: BlockUserListDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(nickname: String) {
        makeCircle(target: blockUserImage, color: "Gray6", width: 1)
        makeCircle(target: unblockButton, color: "Gray5", width: 1)
        blockUserNickname.text = nickname
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "BlockUserListTableViewCell", bundle: nil)
    }
    
    @IBAction func unblockButtonPressed(_ sender: UIButton) {
        blockUserListDelegate?.unblockUser(sender: sender)
    }
    
}
