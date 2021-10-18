//
//  ModifyImageTableViewCell.swift
//  topaz
//
//  Created by 서충원 on 2021/10/13.
//

import UIKit

protocol ModifyImageDelegate {
    func modifyImage(index: Int)
}

class ModifyImageTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var experienceTextView: UITextView!
    @IBOutlet weak var experienceTextViewBorder: UIView!
    
    var textChanged: ((String) -> Void)?
    var delegate: ModifyImageDelegate?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabScrollView))
        containerView.addGestureRecognizer(tapGestureReconizer)
        experienceTextView.delegate = self
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ModifyImageTableViewCell", bundle: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.delegate?.modifyImage(index: index!)
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    //touchesBegan을 대신해서 쓰임
    @objc func tabScrollView() {
        experienceTextView.endEditing(true)
    }
    
}

extension ModifyImageTableViewCell: UITextViewDelegate {
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
