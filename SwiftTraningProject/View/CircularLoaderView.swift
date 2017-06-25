//
//  CircularLoaderView.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/21.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class CircularLoaderView:UIView {
    
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    //進度的參數
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
//Mark: - init
     override init(frame frameGet:CGRect){
        super.init(frame: frameGet)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
///Mark: - lifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }
//動畫的圖片樣式
    func configure() {
        alpha = 0.6
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clear.cgColor //填滿的顏色 透明代表中空
        circlePathLayer.strokeColor = UIColor.white.cgColor //畫線的顏色
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.clear //背景顏色
    }
//圓圈的座標
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }
//貝茲曲線的物件
    func circlePath() -> UIBezierPath {
        return UIBezierPath.init(ovalIn: circleFrame())
    }
}
