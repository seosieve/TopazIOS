//
//  CountryDetailViewController.swift
//  topaz
//
//  Created by 서충원 on 2023/06/21.
//

import UIKit

class CountryDetailViewController: UIViewController {
    @IBOutlet weak var CountryDetailViewContainer: UIView!
    @IBOutlet weak var label: UILabel!
    
    var countryName = ""
    
    var viewModel = CountryDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: CountryDetailViewContainer)
        print(countryName)
        viewModel.getCountry(byName: countryName) { results in
            print(results)
            DispatchQueue.main.async {
                self.label.text = results[0].capital[0]
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
