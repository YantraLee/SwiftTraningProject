//
//  CustomNavigationBarItem.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/11.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBarItem {
    
    private static var mInstance : CustomNavigationBarItem?
// MARK:- Singleton create
    static func shareInstance() -> CustomNavigationBarItem{
        if (mInstance == nil) {
            mInstance = CustomNavigationBarItem()
        }
        
        return mInstance!
    }
// MARK:- 產生對應的navigation按鈕
     func returnLogOutBtn(completion: @escaping (UIButton) -> Void)  {        
        let logOutBtn = UIButton(type: .custom)
        
        if USERINFO.hasImage == true {
            if(USERINFO.image == nil){
                 ImageLoadTool.load_image(urlSet: USERINFO.imageURL!, completion: { (image) in
                    USERINFO.image =  image
                    DispatchQueue.main.async {
                        completion(self.configLogOutBtn(btn: logOutBtn, image: USERINFO.image))
                    }
                 })
            }else{//如果已load過圖片
                completion(self.configLogOutBtn(btn: logOutBtn, image: USERINFO.image))
            }
        }
    }
    
     func configLogOutBtn(btn btnSet:UIButton?, image imageSet:UIImage?) -> UIButton{
        btnSet?.frame = CGRect.init(x: 0, y: 0, width: (imageSet?.size.width)!+80, height: (imageSet?.size.height)!)
        btnSet?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        btnSet?.setTitle(USERINFO.name!+"   ", for: .normal)
        btnSet?.setImage(imageSet, for: .normal) //正常狀態的圖片
        btnSet?.setImage(imageSet, for: .highlighted) //點擊狀態的圖片
        
        //翻轉圖片和文字的位置左右互換
        btnSet?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
        btnSet?.titleLabel?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
        btnSet?.imageView?.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
        
        return btnSet!
    }
// Mark:- class function
   class func customNavigationBarAppearence() {
      let appearence = UINavigationBar.appearance()
        appearence.tintColor = UIColor.white
        appearence.isTranslucent = true
        appearence.barStyle = UIBarStyle.blackOpaque
    }
}
