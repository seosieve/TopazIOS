//
//  BackgroundMusicViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

class BackgroundMusicViewController: UIViewController {
    @IBOutlet weak var backgroundMusicCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMusicCollectionView.register(MusicCollectionViewCell.nib(), forCellWithReuseIdentifier: "MusicCollectionViewCell")
        backgroundMusicCollectionView.allowsMultipleSelection = true
        backgroundMusicCollectionView.dataSource = self
        backgroundMusicCollectionView.delegate = self
    }

}

extension BackgroundMusicViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionViewCell", for: indexPath) as! MusicCollectionViewCell
        makeBorder(target: cell.musicBackground, radius: 12, width: 3, color: "Gray6", isFilled: false)
        return cell
    }
    
    
}
