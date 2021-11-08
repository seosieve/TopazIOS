//
//  TravelPageViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/11/03.
//

import UIKit

protocol transferTravelDelegate {
    func transferTravel(index: Int)
}

class TravelPageViewController: UIPageViewController {
    var travelDelegate: transferTravelDelegate?
    
    lazy var pageList: [UIViewController] = {
        let travelAlbumVC = self.viewInstance(identifier: "TravelAlbumVC")
        let travelTicketVC = self.viewInstance(identifier: "TravelTicketVC")
        let travelCollectiblesVC = self.viewInstance(identifier: "TravelCollectiblesVC")
        return [travelAlbumVC, travelTicketVC, travelCollectiblesVC]
    }()
    
    private func viewInstance(identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "TravelNote", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: identifier)
        return VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveFromIndex(index: 0)
    }
    
    func moveFromIndex(index: Int, forward: Bool = true) {
        if forward {
            self.setViewControllers([pageList[index]], direction: .forward, animated: true, completion: nil)
        } else {
            self.setViewControllers([pageList[index]], direction: .reverse, animated: true, completion: nil)
        }
    }
}
