//
//  MusicPageViewController.swift
//  topaz
//
//  Created by 서충원 on 2021/10/25.
//

import UIKit

protocol transferMusicDelegate {
    func transferMusic(index: Int)
}

class MusicPageViewController: UIPageViewController {
    var musicDelegate: transferMusicDelegate?
    
    lazy var pageList: [UIViewController] = {
        let backgroundMusicVC = self.viewInstance(identifier: "BackgroundMusicVC")
        let soundEffectVC = self.viewInstance(identifier: "SoundEffectVC")
        return [backgroundMusicVC, soundEffectVC]
    }()
    
    private func viewInstance(identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Community", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: identifier)
        return VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        moveFromIndex(index: 1)
        moveFromIndex(index: 0, forward: false)
    }
    
    func moveFromIndex(index: Int, forward: Bool = true) {
        if forward {
            self.setViewControllers([pageList[index]], direction: .forward, animated: true, completion: nil)
        } else {
            self.setViewControllers([pageList[index]], direction: .reverse, animated: true, completion: nil)
        }
    }
}

//MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension MusicPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            musicDelegate?.transferMusic(index: currentIndex)
        }
    }
}
