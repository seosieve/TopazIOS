//
//  TravelTicketViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/03.
//

import UIKit

class TravelTicketViewController: UIViewController {
    @IBOutlet weak var travelTicketCollectionView: UICollectionView!
    
    @IBOutlet var ticketDetailContainer: UIView!
    @IBOutlet weak var ticketDetailImage: UIImageView!
    @IBOutlet weak var ticketDetailNickname: UILabel!
    @IBOutlet weak var ticketDetailDate: UILabel!
    
    let userdefault = UserDefaults.standard
    let viewModel = TravelNoteViewModel()
    var ticketName: [String]?
    var ticketDate: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserTicket { ticketName, ticketDate in
            self.ticketName = ticketName
            self.ticketDate = ticketDate
            self.travelTicketCollectionView.register(TravelTicketCollectionViewCell.nib(), forCellWithReuseIdentifier: "TicketCollectionViewCell")
            self.travelTicketCollectionView.dataSource = self
            self.travelTicketCollectionView.delegate = self
        }
        
    }
    
    @objc func tabDimView() {
        removeTicketDetail()
    }
    
    @IBAction func ticketDetailCancelButtonPressed(_ sender: UIButton) {
        removeTicketDetail()
    }
}

//MARK: - UI Functions
extension TravelTicketViewController {
    func popUpTicketDetail() {
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
        ticketDetailContainer.frame = CGRect(x: 0, y: 0, width: width-72, height: 633)
        ticketDetailContainer.center = CGPoint(x: width/2, y: height/2)
        self.tabBarController?.view.addSubview(ticketDetailContainer)
        makeBorder(target: ticketDetailContainer, radius: 28, isFilled: true)
        makeShadow(target: ticketDetailImage, radius: 16, shadowRadius: 14)
        ticketDetailContainer.transform = CGAffineTransform(translationX: 0, y: 50)
        ticketDetailContainer.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.ticketDetailContainer.alpha = 1
            self.ticketDetailContainer.transform = CGAffineTransform.identity
        }
    }
    
    func removeTicketDetail() {
        guard let dimView = self.tabBarController?.view.viewWithTag(100) as? UIVisualEffectView else { return }
        UIView.animate(withDuration: 0.3) {
            dimView.effect = UIBlurEffect()
            self.ticketDetailContainer.transform = CGAffineTransform(translationX: 0, y: 50)
            self.ticketDetailContainer.alpha = 0
        } completion: { _ in
            dimView.removeFromSuperview()
            self.ticketDetailContainer.removeFromSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TravelTicketViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ticketName!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nickname = userdefault.string(forKey: "nickname")!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionViewCell", for: indexPath) as! TravelTicketCollectionViewCell
        cell.configure(nickname: nickname, date: ticketDate![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nickname = userdefault.string(forKey: "nickname")!
        ticketDetailNickname.text = nickname
        ticketDetailDate.text = ticketDate![indexPath.row]
        popUpTicketDetail()
    }
    
    
}
