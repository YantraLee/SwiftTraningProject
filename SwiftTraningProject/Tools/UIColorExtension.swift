//
//  UIColorExtension.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/22.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit

class UIColorExtension : UIColor {
    private static var mInstance : UIColorExtension?
    
    //TODO: Singleton create
    static func shareInstance() -> UIColorExtension{
        if (mInstance == nil) {
            mInstance=UIColorExtension()
        }
        
        return mInstance!
    }
}

extension UIColorExtension {
    //回傳填滿顏色的方塊
    func getImageFilledWithColor(size: CGSize , color:UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image( actions:
            { rendererContext in
                color.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        })
}}
