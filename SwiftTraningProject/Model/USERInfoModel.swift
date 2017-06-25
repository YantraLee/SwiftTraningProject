//
//  USERInfoModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/11.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class USERInfoModel {
    //sigleTon參數宣告
    private static var mInstance : USERInfoModel?
    //參數宣告
    private var _userID:String?
    private var _email:String?
    private var _name:String?
    private var _hasImage:Bool?
    private var _imageURL:URL?
    private var _image:UIImage?
    
    var _accessToken:String?
    
    var _localizationCode:String?
    var _regionCode:String?
    
// MARK:- Singleton create
    static func shareInstance() -> USERInfoModel{
        if (mInstance == nil) {
            mInstance = USERInfoModel()
        }
        
        return mInstance!
    }
// MARK:- set get
    var userID:String?{
        set{
             _userID=newValue
        }
        get{
              return _userID
        }
    }
    var email:String?{
        set{
            _email=newValue
        }
        get{
            return _email
        }
    }
    var name:String?{
        set{
            _name=newValue
        }
        get{
            return _name
        }
    }
    var hasImage:Bool?{
        set{
            _hasImage=newValue
        }
        get{
            return _hasImage
        }
    }
    var imageURL:URL?{
        set{
            _imageURL=newValue
        }
        get{
            return _imageURL
        }
    }
    
    var image:UIImage?{
        set{
            _image = newValue
        }
        get{
            return _image
        }
    }
    
    var accessToken:String?{
        set{
            _accessToken = newValue
        }
        get{
            return _accessToken
        }
    }
    
    var localizationCode:String?{
        get{
            return NSLocale.preferredLanguages[0]
        }
    }
    
    var regionCode:String?{
        get{
            if NSLocale.preferredLanguages[0] == "en"{
                return "US"
            }else{
                return "TW"
            }
        }
    }
// MARK: - logout
    func logout(){
        self.userID = nil
        self.email = nil
        self.name = nil
        self.hasImage = false
        self.imageURL = nil
        self.image = nil
    }
}
