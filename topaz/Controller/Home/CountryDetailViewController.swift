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
    
    var countryResult:RestCountryResults? = nil
    var countryImage:UIImage? = nil
    
    var viewModel = CountryDetailViewModel()
    var countryPageViewController: CountryPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeModalCircular(target: CountryDetailViewContainer)
        print(countryResult ?? "aa")
        print(countryImage ?? "bb")
//        viewModel.getCountry(byName: countryName) { results in
//            print(results)
//            DispatchQueue.main.async {
//                self.label.text = results[0].capital[0]
//                self.view.layoutIfNeeded()
//            }
//        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPageVC" {
            let destinationVC = segue.destination as! CountryPageViewController
            countryPageViewController = destinationVC
            destinationVC.transferCountryImage(countryImage)
        }
    }
}
