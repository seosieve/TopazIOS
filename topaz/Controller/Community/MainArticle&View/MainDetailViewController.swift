//
//  MainDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/19.
//

import UIKit

class MainDetailViewController: UIViewController {
    @IBOutlet weak var aaa: UITextView!
    
    var article: Article? {
        didSet{
            print(article)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        aaa.text = "\(article!.auther)\n\(article!.writtenDate)\n \(article!.strWrittenDate)\n \(article!.country)\n \(article!.title) \(article!.mainText)\n \(article!.likes)\n \(article!.views)\n"
    }
}
