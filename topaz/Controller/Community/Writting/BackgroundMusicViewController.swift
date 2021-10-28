//
//  BackgroundMusicViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

protocol DeliverBackgroundMusicDelegate {
    func deliverBackgroundMusic(backgroundMusic: String)
}

class BackgroundMusicViewController: UIViewController {
    @IBOutlet weak var backgroundMusicCollectionView: UICollectionView!
    
    var backgroundMusicDelegate: DeliverBackgroundMusicDelegate?
    let backgroundMusic = BackgroundMusic()
    var selectedBackgroundMusic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMusicCollectionView.register(MusicCollectionViewCell.nib(), forCellWithReuseIdentifier: "MusicCollectionViewCell")
        backgroundMusicCollectionView.allowsMultipleSelection = true
        backgroundMusicCollectionView.dataSource = self
        backgroundMusicCollectionView.delegate = self
    }
}

//MARK: - UI Functions
extension BackgroundMusicViewController {
    func deleteBackgroundMusic(name: String) {
        let index = backgroundMusic.backgroundMusicFileName.firstIndex(of: name)!
        backgroundMusicCollectionView.deselectItem(at: [0,index], animated: true)
        selectedBackgroundMusic = ""
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension BackgroundMusicViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundMusic.backgroundMusicName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionViewCell", for: indexPath) as! MusicCollectionViewCell
        let image = backgroundMusic.backgroundMusicImage[indexPath.row]!
        let text = backgroundMusic.backgroundMusicName[indexPath.row]
        cell.configure(image: image, text: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedBackgroundMusic == "" {
            let selectedFileName = backgroundMusic.backgroundMusicFileName[indexPath.row]
            selectedBackgroundMusic = selectedFileName
            backgroundMusicDelegate?.deliverBackgroundMusic(backgroundMusic: selectedFileName)
        } else {
            let index = backgroundMusic.backgroundMusicFileName.firstIndex(of: selectedBackgroundMusic)!
            collectionView.deselectItem(at: [0,index], animated: true)
            let selectedFileName = backgroundMusic.backgroundMusicFileName[indexPath.row]
            selectedBackgroundMusic = selectedFileName
            backgroundMusicDelegate?.deliverBackgroundMusic(backgroundMusic: selectedFileName)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedBackgroundMusic = ""
        backgroundMusicDelegate?.deliverBackgroundMusic(backgroundMusic: "")
    }
}
