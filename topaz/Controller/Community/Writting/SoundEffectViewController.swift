//
//  SoundEffectViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

protocol deliverSoundEffectDelegate {
    func deliverSoundEffect(arr: [String])
}

class SoundEffectViewController: UIViewController {
    @IBOutlet weak var soundEffectCollectionView: UICollectionView!
    
    var soundEffectDelegate = deliverSoundEffectDelegate?
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
        return soundEffect.soundEffectName.count
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
            selectedSoundEffectArr.append(soundEffect.soundEffectName[indexPath.row])
            // delegate
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            popUpToast()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedSoundEffectArr = selectedSoundEffectArr.filter{$0 != soundEffect.soundEffectName[indexPath.row]}
        // delegate
    }
    
    
}
