//
//  CustomAlertViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/11.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class CustomAlertViewController {
    
    private static var mInstance : CustomAlertViewController?
    // MARK:- Singleton create
    static func shareInstance() -> CustomAlertViewController{
        if (mInstance == nil) {
            mInstance = CustomAlertViewController()
        }
        
        return mInstance!
    }
    
    func callAlertController(title titleSet:String, message messageSet:String, completion:@escaping(UIAlertAction)->Void ){
        let alert = UIAlertController.init(title: "",
                                      message: "",
                                      preferredStyle: .alert)
        //宣告改變標題和內容的屬性值的陣列
        let titleFont = [NSFontAttributeName: UIFont(name: "ArialHebrew-Bold", size: CGFloat(alertTitleFontSize))!,NSForegroundColorAttributeName:UIColor.white]
        let messageFont = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: CGFloat(alertMessageFontSize))!,NSForegroundColorAttributeName:UIColor.white]
        //把屬性質賦予給NSAttributedString物件
        let titleAttrString = NSMutableAttributedString(string: titleSet, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: messageSet, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        //更換所有子元件的屬性
        let FirstSubview = alert.view.subviews.first
        let AlertContentView = FirstSubview?.subviews.first
        for subview in (AlertContentView?.subviews)! {
            subview.tintColor = UIColor.white
            subview.backgroundColor = UIColor.black
            subview.layer.cornerRadius = 6
            subview.alpha = 1
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.white.cgColor
        }
        
        let submitAction = UIAlertAction(title: LocalizationManagerTool.getString(key: "Alert_Confirm", tableSet: nil), style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            completion(action)
        })
        
        let cancelAction = UIAlertAction(title: LocalizationManagerTool.getString(key: "Alert_Cancel", tableSet: nil), style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: { 
        });
    }
    
}
