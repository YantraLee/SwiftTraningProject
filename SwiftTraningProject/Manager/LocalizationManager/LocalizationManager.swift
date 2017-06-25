//
//  LocalizationManager.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class LocalizationManager : NSObject {
    
    
     private static var mInstance : LocalizationManager?
    
     var bundle : Bundle?
    
    //TODO: Singleton create
    static func shareInstance() -> LocalizationManager{
        if (mInstance == nil) {
            mInstance=LocalizationManager()
            //設定語系
            if Locale.preferredLanguages[0].contains("en") {
                mInstance?.setLanguage(language: "en") //設定default語系
            }else{
                mInstance?.setLanguage(language: nil) //設定default語系
            }
        }
        
        return mInstance!
    }
   
//TODO:設定語系
    func setLanguage(language:String?){
        var pathGet : String?
        if(language == nil){
            pathGet = Bundle.main.path(forResource: "Base", ofType: "lproj")
        }else{
            pathGet = Bundle.main.path(forResource: language, ofType: "lproj")
            if(pathGet == nil){
                pathGet = Bundle.main.path(forResource: "Base", ofType: "lproj")
            }
        }
        bundle = Bundle.init(path: pathGet!)
    }
    
    //TODO: 取得多語系字串
    //如果是可能填入nil的參數 則要在參數種類後面加上問號 使其成為optional
    func getString(key:String , tableSet:String?) -> String{
        if(tableSet == nil){//如果沒有指定哪一個語系檔
            //table的參數 可指定要去抓哪一個多語系檔案
            return bundle!.localizedString(forKey: key, value: "default value", table: "LocalizedString")
        }else{
            return bundle!.localizedString(forKey: key, value: "default value", table: tableSet)
        }
    }
    
}
