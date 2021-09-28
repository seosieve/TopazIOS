//
//  AddImageTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/09/26.
//

import UIKit

protocol DeleteImageDelegate {
    func deleteImage(index: Int)
}

class AddImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var experienceTextView: UITextView!
    @IBOutlet weak var experienceTextViewBorder: UIView!
    
    var textChanged: ((String) -> Void)?
    var delegate: DeleteImageDelegate?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        containerView.addGestureRecognizer(tapGestureReconizer)
        experienceTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "AddImageTableViewCell", bundle: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.delegate?.deleteImage(index: index!)
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        experienceTextView.endEditing(true)
    }
    
}

extension AddImageTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Gray4") {
            textView.text = nil
            textView.textColor = UIColor(named: "Gray2")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "사진에 대한 여행경험을 적어주세요."
            textView.textColor = UIColor(named: "Gray4")
        }
    }
}
