//
//  PlaceRecommendViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/09.
//

import UIKit

class PlaceRecommendViewController: UIViewController {
    @IBOutlet weak var placeRecommendViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: placeRecommendViewContainer)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
