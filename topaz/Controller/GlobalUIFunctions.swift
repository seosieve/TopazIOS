//
//  File.swift
//  topaz
//
//  Created by 서충원 on 2021/08/11.
//

import UIKit

//Border 생성 
func makeBorder(target view: UIView, color: String = "Gray5", isFilled Fill: Bool) {
    if Fill == true {
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
    } else {
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: color)?.cgColor
    }
}

//Navigation Bar line과 Background 제거
func removeNavigationBackground(view: UIViewController) {
    view.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    view.navigationController?.navigationBar.shadowImage = UIImage()
}


