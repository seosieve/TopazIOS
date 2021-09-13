//
//  CommunityViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var upperBackground: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var luggageCollectionView: UICollectionView!
    
    var timer = Timer()
    var counter = 0
    let luggageImgArr = [UIImage(named: "Luggage1"), UIImage(named: "Luggage3"), UIImage(named: "Luggage2"), UIImage(named: "Luggage3"), UIImage(named: "Luggage1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBackground(view: self)
        makeCircular(target: upperBackground, each: true)
        makeCircular(target: writeButton, each: false)
        addMultipleFonts()
        
        luggageCollectionView.dataSource = self
        luggageCollectionView.delegate = self
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.changeLuggage), userInfo: nil, repeats: true)
        }
    }
    
    
    @IBAction func countryDetailPressed(_ sender: UIButton) {
        
    }
    
    @objc func changeLuggage() {
        UIView.animate(withDuration: 4) {
            let index = IndexPath.init(item: self.counter, section: 0)
            self.luggageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.luggageCollectionView.layoutIfNeeded()
            self.counter += 1
        }
    }
    
    @IBAction func writeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWritting", sender: sender)
    }
    
}

//MARK: - UI Functions
extension CommunityViewController {
    // 각각 edge에 맞는 Radius적용
    func makeCircular(target view: UIView, each: Bool) {
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(named: "Gray4")?.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        if each {
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    func addMultipleFonts() {
        let attributedString = NSMutableAttributedString(string: introduceLabel.text!)
        attributedString.addAttribute(.font, value: UIFont(name: "NotoSansKR-Bold", size: 14)!, range: (introduceLabel.text! as NSString).range(of: "여행 캐리어"))
        introduceLabel.attributedText = attributedString
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommunityViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemToShow = luggageImgArr[indexPath.row % luggageImgArr.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "luggageCell", for: indexPath) as! luggageCollectionViewCell
        cell.luggageImage.image = itemToShow
        return cell
    }
    
}

class luggageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var luggageImage: UIImageView!
    
    
}

