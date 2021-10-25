//
//  OnboardingPageViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/30.
//

import UIKit

protocol transferPageDelegate {
    func transferPage(currentPage: Int)
}

class PageViewController: UIPageViewController {
    var pageDelegate: transferPageDelegate?
    
    lazy var pageList: [UIViewController] = {
        let VC1 = self.viewInstance(identifier: "FirstPageVC")
        let VC2 = self.viewInstance(identifier: "SecondPageVC")
        let VC3 = self.viewInstance(identifier: "ThirdPageVC")
        let VC4 = self.viewInstance(identifier: "FourthPageVC")
        let VC5 = self.viewInstance(identifier: "FifthPageVC")
        return [VC1, VC2, VC3, VC4, VC5]
    }()
    
    private func viewInstance(identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: identifier)
        return VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstVC = pageList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    

}

//MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return pageList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == pageList.count { return nil }
        return pageList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentVC = pageViewController.viewControllers?.first else { return }
            guard let currentIndex = pageList.firstIndex(of: currentVC) else { return }
            pageDelegate?.transferPage(currentPage: currentIndex)
        }
    }
}
