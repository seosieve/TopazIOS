//
//  WrittingViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/12.
//

import UIKit

class WrittingViewController: UIViewController {

    @IBOutlet weak var resisterButton: UIButton!
    @IBOutlet weak var countryQuestionButton: UIButton!
    @IBOutlet weak var country1: UIButton!
    @IBOutlet weak var country2: UIButton!
    @IBOutlet weak var country3: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var mainTextView: UITextView!
    
    var countryName1: String!
    var countryName2: String!
    var countryName3: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircle(target: resisterButton, color: "MintBlue", width: 0)
        
        titleTextView.delegate = self
        mainTextView.delegate = self
        textViewDidChange(titleTextView)
        textViewDidChange(mainTextView)
    }
    
    // 다녀온 나라 정보값 받아오기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCountry()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        print(titleTextView.text)
        
    }
    
    @IBAction func addCountryButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddCountry", sender: sender)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "Luggage3")
        mainTextView.text!.append(imageAttachment)
    }
    
}

//MARK: - UI Functions
extension WrittingViewController {
    func setCountry() {
        country1.setTitle(countryName1, for: .normal)
        country2.setTitle(countryName2, for: .normal)
        country3.setTitle(countryName3, for: .normal)
        let width1 = countryName1 != nil ? 1 : 0
        let width2 = countryName2 != nil ? 1 : 0
        let width3 = countryName3 != nil ? 1 : 0
        makeCircle(target: country1, color: "MintBlue", width: width1)
        makeCircle(target: country2, color: "MintBlue", width: width2)
        makeCircle(target: country3, color: "MintBlue", width: width3)
        if countryName1 == nil && countryName2 == nil && countryName3 == nil {
            countryQuestionButton.isHidden = false
        } else {
            countryQuestionButton.isHidden = true
        }
    }
}

//MARK: - UITextViewDelegate
extension WrittingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case titleTextView:
            // 줄바꿈 제한
            if text == "\n" { return false }
            // Title 글자수 제한
            guard let str = titleTextView.text else { return true }
            let length = str.count + text.count - range.length
            print(length)
            return length <= 32
        default:
            // Title 글자수 제한
            guard let str = mainTextView.text else { return true }
            let length = str.count + text.count - range.length
            print(length)
            return length <= 2000
        }
    }
    
    // TextView Line에 따라 동적 height조절
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case titleTextView:
            let size = CGSize(width: view.frame.width-40, height: .infinity)
            let estimatedSize = titleTextView.sizeThatFits(size)
            
            titleTextView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        default:
            let size = CGSize(width: view.frame.width-40, height: .infinity)
            let estimatedSize = mainTextView.sizeThatFits(size)
            
            mainTextView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }

    }
}
