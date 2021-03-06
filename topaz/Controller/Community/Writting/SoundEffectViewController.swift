//
//  SoundEffectViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

protocol DeliverSoundEffectDelegate {
    func deliverSoundEffect(soundEffect: String, add: Bool)
}

class SoundEffectViewController: UIViewController {
    @IBOutlet weak var soundEffectCollectionView: UICollectionView!
    
    var soundEffectDelegate: DeliverSoundEffectDelegate?
    let soundEffect = SoundEffect()
    var selectedSoundEffectArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundEffectCollectionView.register(MusicCollectionViewCell.nib(), forCellWithReuseIdentifier: "MusicCollectionViewCell")
        soundEffectCollectionView.allowsMultipleSelection = true
        soundEffectCollectionView.dataSource = self
        soundEffectCollectionView.delegate = self
    }
}

//MARK: - UI Functions
extension SoundEffectViewController {
    func addSoundEffect(name: String) {
        let index = soundEffect.soundEffectFileName.firstIndex(of: name)!
        soundEffectCollectionView.selectItem(at: [0,index], animated: true, scrollPosition: .centeredHorizontally)
        selectedSoundEffectArr.append(name)
    }
    
    func deleteSoundEffect(name: String) {
        let index = soundEffect.soundEffectFileName.firstIndex(of: name)!
        soundEffectCollectionView.deselectItem(at: [0,index], animated: true)
        selectedSoundEffectArr = selectedSoundEffectArr.filter{ $0 != name }
    }
    
    func popUpToast() {
        // Make Custom Alert Toast
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "효과음은 최대 3개까지 선택할 수 있습니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor(named: "White")!]), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(alert, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SoundEffectViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundEffect.soundEffectFileName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionViewCell", for: indexPath) as! MusicCollectionViewCell
        let image = soundEffect.soundEffectImage[indexPath.row]!
        let text = soundEffect.soundEffectName[indexPath.row]
        cell.configure(image: image, text: text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSoundEffectArr.count <= 2 {
            let selectedFileName = soundEffect.soundEffectFileName[indexPath.row]
            selectedSoundEffectArr.append(selectedFileName)
            soundEffectDelegate?.deliverSoundEffect(soundEffect: selectedFileName, add: true)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            popUpToast()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedFileName = soundEffect.soundEffectFileName[indexPath.row]
        selectedSoundEffectArr = selectedSoundEffectArr.filter{$0 != deselectedFileName}
        soundEffectDelegate?.deliverSoundEffect(soundEffect: deselectedFileName, add: false)
    }
}
