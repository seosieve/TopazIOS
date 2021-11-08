//
//  TravelAlbumViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/03.
//

import UIKit
import Kingfisher

class TravelAlbumViewController: UIViewController {
    @IBOutlet weak var travelAlbumCollectionView: UICollectionView!
    
    @IBOutlet var albumDetailContainer: UIView!
    @IBOutlet weak var albumDetailBackground: UIView!
    @IBOutlet weak var albumDetailImage: UIImageView!
    @IBOutlet weak var albumDetailName: UILabel!
    @IBOutlet weak var albumDetailDate: UILabel!
    
    let viewModel = TravelNoteViewModel()
    var albumUrl: [String]?
    var albumName: [String]?
    var albumDate: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserAlbum { albumUrl, albumName, albumDate in
            self.albumUrl = albumUrl
            self.albumName = albumName
            self.albumDate = albumDate
            self.travelAlbumCollectionView.register(TravelAlbumCollectionViewCell.nib(), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
            self.travelAlbumCollectionView.dataSource = self
            self.travelAlbumCollectionView.delegate = self
        }
    }
    
    @objc func tabDimView() {
        removeAlbumDetail()
    }
    
    @IBAction func albumDetailCancelButtonPressed(_ sender: UIButton) {
        removeAlbumDetail()
    }    
}

//MARK: - UI Functions
extension TravelAlbumViewController {
    func popUpAlbumDetail() {
        // Background Dim
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let dimView = UIVisualEffectView()
        dimView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        dimView.tag = 100
        self.tabBarController?.view.addSubview(dimView)
        UIView.animate(withDuration: 0.3) {
            dimView.effect = UIBlurEffect(style: .systemChromeMaterialDark)
        }
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(tabDimView))
        dimView.addGestureRecognizer(tapGestureReconizer)
        // collectiblesView
        albumDetailContainer.frame = CGRect(x: 0, y: 0, width: width-72, height: 490)
        albumDetailContainer.center = CGPoint(x: width/2, y: height/2)
        self.tabBarController?.view.addSubview(albumDetailContainer)
        makeBorder(target: albumDetailContainer, radius: 28, isFilled: true)
        makeBorder(target: albumDetailBackground, radius: 16, isFilled: true)
        makeBorder(target: albumDetailImage, radius: 16, isFilled: true)
        makeShadow(target: albumDetailBackground, radius: 16, shadowRadius: 14)
        albumDetailContainer.transform = CGAffineTransform(translationX: 0, y: 50)
        albumDetailContainer.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.albumDetailContainer.alpha = 1
            self.albumDetailContainer.transform = CGAffineTransform.identity
        }
    }
    
    func removeAlbumDetail() {
        guard let dimView = self.tabBarController?.view.viewWithTag(100) as? UIVisualEffectView else { return }
        UIView.animate(withDuration: 0.3) {
            dimView.effect = UIBlurEffect()
            self.albumDetailContainer.transform = CGAffineTransform(translationX: 0, y: 50)
            self.albumDetailContainer.alpha = 0
        } completion: { _ in
            dimView.removeFromSuperview()
            self.albumDetailContainer.removeFromSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TravelAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumUrl!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! TravelAlbumCollectionViewCell
        if indexPath.row % 5 == 1 || indexPath.row % 5 == 2 || indexPath.row % 5 == 4 {
            cell.albumConstraintY.constant = 10
            cell.albumSticker.layer.transform = CATransform3DMakeScale(1, -1, 1)
        }
        cell.configure(name: albumName![indexPath.row], date: albumDate![indexPath.row])
        let url = URL(string: albumUrl![indexPath.row])!
        cell.albumImage.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: albumUrl![indexPath.row])!
        albumDetailImage.kf.setImage(with: url)
        albumDetailName.text = albumName![indexPath.row]
        albumDetailDate.text = albumDate![indexPath.row]
        popUpAlbumDetail()
    }
    
    
}
