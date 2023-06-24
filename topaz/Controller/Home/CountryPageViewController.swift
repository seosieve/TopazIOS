//
//  CountryPageViewController.swift
//  topaz
//
//  Created by 서충원 on 2023/06/24.
//

import UIKit

class CountryPageViewController: UIPageViewController {

    lazy var pageList: [UIViewController] = {
        let firstPageVC = self.viewInstance(identifier: "FirstPageVC")
        let secondPageVC = self.viewInstance(identifier: "SecondPageVC")
        return [firstPageVC, secondPageVC]
    }()
    
    private func viewInstance(identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: identifier)
        return VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = pageList.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
}

extension CountryPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageList.firstIndex(of: viewController) else { return nil }
        let prevIndex = vcIndex-1
        guard prevIndex >= 0 else {
            return nil
        }
        guard pageList.count > prevIndex else { return nil }
        return pageList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageList.firstIndex(of: viewController) else { return nil }
            let nextIndex = vcIndex + 1
            guard nextIndex < pageList.count else {
                return nil
            }
            guard pageList.count > nextIndex else { return nil }
            return pageList[nextIndex]
    }
}
