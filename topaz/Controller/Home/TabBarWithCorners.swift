//
//  TabbarController.swift
//  topaz
//
//  Created by 서충원 on 2021/09/02.
//

import UIKit

class TabBarWithCorners: UITabBar {
    var radii: CGFloat = 20.0
    
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        addShape()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        let keyWindow = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        let safeAreaBottom = keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero
        return CGSize(width: superSize.width, height: safeAreaBottom + 65)
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor(named: "White")?.cgColor
        shapeLayer.shadowColor = UIColor(named: "Gray4")?.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -6)
        shapeLayer.shadowRadius = 4
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))
        return path.cgPath
    }
}
