//
//  CustomButton.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/7.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class CustomButton {
    
    //寬高基數為40和30
    class func makeCustomBtn(button:UIButton , content:String , fontSizeSet:CGFloat , widthGet:NSLayoutConstraint, heightGet:NSLayoutConstraint ) ->UIButton{
        button.layer.masksToBounds=true
        button.backgroundColor = UIColor.init(red: 0.52, green: 0.78, blue: 1, alpha: 0.8)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.init(name: fontNameSet, size: fontSizeSet)
        
        button.setTitle(content, for: .normal)
        
        button.layer.cornerRadius = widthGet.constant/8
        
        widthGet.constant = widthGet.constant + fontSizeSet*5
        heightGet.constant = heightGet.constant + fontSizeSet
        
        return button
    }
    
    class func makeCustomRatingBtn(button:UIButton , content:String , fontSizeSet:CGFloat) ->UIButton{
        button.layer.masksToBounds=true
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = button.frame.size.width/8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.init(name: fontNameSet, size: fontSizeSet)
        
         button.setTitle(content, for: .normal)
        
        return button
    }
    
}
