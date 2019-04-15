//
//  ThermometerView.swift
//  Thermometer
//
//  Created by TRINGAPPS on 14/04/19.
//  Copyright © 2019 TRINGAPPS. All rights reserved.
//

import UIKit

class ThermometerView: UIView {

    let thermoLayer = CAShapeLayer()
    let levelLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    var lineWidth: CGFloat {
        return bounds.width/3
    }
    
    var level: CGFloat = 0.5 {
        didSet {
            if level < 0.5
            {
                thermoLayer.fillColor = UIColor.red.cgColor
            } else {
                thermoLayer.fillColor = UIColor.green.cgColor
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        layer.addSublayer(thermoLayer)
        layer.addSublayer(levelLayer)
        let width = bounds.width - lineWidth
        let height = bounds.height - lineWidth / 2
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: height-width, width: width, height: width))
        path.move(to: CGPoint(x: width / 2, y: height-width))
        path.addLine(to: CGPoint(x: width/2, y: 10))
        thermoLayer.path = path.cgPath
        thermoLayer.strokeColor = UIColor.darkGray.cgColor
        thermoLayer.lineWidth = width/3
        thermoLayer.position.x = lineWidth/2
        thermoLayer.lineCap = CAShapeLayerLineCap.round
        maskLayer.path = thermoLayer.path
        maskLayer.lineWidth = thermoLayer.lineWidth - 6
        maskLayer.position = thermoLayer.position
        maskLayer.lineCap = thermoLayer.lineCap
        maskLayer.strokeColor = thermoLayer.strokeColor
        maskLayer.fillColor = nil
        levelLayer.mask = maskLayer
        setUpLevelLayer()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        addGestureRecognizer(pan)
    }

    private func setUpLevelLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.midX, y: 0))
        levelLayer.path = path.cgPath
        levelLayer.lineWidth = bounds.width
        levelLayer.strokeColor = UIColor.white.cgColor
        levelLayer.strokeEnd = level
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: gesture.view)
        let percent = transition.y/bounds.height
        level = max(0, min(1, levelLayer.strokeEnd - percent))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        levelLayer.strokeEnd = level
        CATransaction.commit()
        gesture.setTranslation(.zero, in: gesture.view)
    }
}
