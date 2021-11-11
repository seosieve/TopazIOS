//
//  BlockUserListViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/11.
//

import UIKit
import Kingfisher

class BlockUserListViewController: UIViewController {
    
    @IBOutlet weak var blockUserListBackgroundView: UIView!
    @IBOutlet weak var blockUserListTableView: UITableView!
    @IBOutlet weak var blockUserListTableViewConstraintH: NSLayoutConstraint!
    
    let viewModel = BlockUserListViewModel()
    let userdefault = UserDefaults.standard
    var imageUrlArr = [String]()
    var nicknameArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getBlockedUsers { imageUrlArr, nicknameArr, emailArr in
            self.imageUrlArr = imageUrlArr
            self.nicknameArr = nicknameArr
            self.userdefault.set(emailArr, forKey: "blockedUsers")
            self.blockUserListTableView.register(EachDefaultTableViewCell.nib(), forCellReuseIdentifier: "EachDefaultTableViewCell")
            self.blockUserListTableView.register(BlockUserListTableViewCell.nib(), forCellReuseIdentifier: "BlockUserListTableViewCell")
            self.blockUserListTableView.dataSource = self
            self.blockUserListTableView.delegate = self
            self.makeTableViewHeight()
            print(imageUrlArr,nicknameArr)
        }
    }
}
//MARK: - UI Functions
extension BlockUserListViewController {
    func makeTableViewHeight() {
        blockUserListTableView.layoutIfNeeded()
        let cellCount = nicknameArr.count
        if cellCount == 0 {
            blockUserListTableViewConstraintH.constant = 300
        } else {
            let cellHeight = 64
            blockUserListTableViewConstraintH.constant = CGFloat(cellCount * cellHeight)
        }
    }
    
    func unblockConfirmAlert(unblockConfirmHandler: @escaping () -> ()) {
        let alert = UIAlertController(title: "선택된 유저의 차단을 해제하시겠어요?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let unblock = UIAlertAction(title: "해제", style: .default) { action in
            unblockConfirmHandler()
        }
        alert.addAction(cancel)
        alert.addAction(unblock)
        unblock.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alert.view.tintColor = UIColor(named: "Gray2")
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension BlockUserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nicknameArr.count == 0 {
            return 1
        } else {
            return nicknameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if nicknameArr.count == 0 {
            return 300
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if nicknameArr.count == 0 {
            self.blockUserListBackgroundView.backgroundColor = .clear
            let cell = tableView.dequeueReusableCell(withIdentifier: "EachDefaultTableViewCell", for: indexPath) as! EachDefaultTableViewCell
            cell.selectionStyle = .none
            cell.defaultImage.image = UIImage(named: "DefaultBlockTableViewImage")
            cell.defaultText.text = "차단한 유저가 없어요."
            return cell
        } else {
            self.blockUserListBackgroundView.backgroundColor = UIColor(named: "White")
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlockUserListTableViewCell", for: indexPath) as! BlockUserListTableViewCell
            cell.blockUserListDelegate = self
            cell.selectionStyle = .none
            viewModel.getImageUrl(imageUrl: imageUrlArr[indexPath.row]) { url in
                let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
                cell.blockUserImage.kf.setImage(with: url, options: [.processor(processor)])
            }
            cell.configure(nickname: nicknameArr[indexPath.row])
            return cell
        }
    }
}

//MARK: - Section Heading
extension BlockUserListViewController: BlockUserListDelegate {
    func unblockUser(sender: UIButton) {
        let index = sender.convert(CGPoint.zero, to: blockUserListTableView)
        if let indexPath = blockUserListTableView.indexPathForRow(at: index) {
            unblockConfirmAlert() {
                self.viewModel.unblockUser(index: indexPath.row) {
                    self.imageUrlArr.remove(at: indexPath.row)
                    self.nicknameArr.remove(at: indexPath.row)
                    self.blockUserListTableView.reloadData()
                    self.makeTableViewHeight()
                    print(UserDefaults.standard.stringArray(forKey: "blockedUsers")!)
                }
            }
        }
    }
}
