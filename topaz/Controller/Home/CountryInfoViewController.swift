//
//  CountryInfoViewController.swift
//  topaz
//
//  Created by 서충원 on 2023/06/24.
//

import UIKit

class CountryInfoViewController: UIViewController {
    
    @IBOutlet weak var countryImageView: UIImageView!
    var countryImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryImageView.image = countryImage
        print(countryImage,"%%%%%%%%%%%%%%%%%%%")
    }
    

}
