//
//  YoutubeLoginViewModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/6.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift

class YoutubeLoginViewModel {
    
    var clickable = MutableProperty(true)
    
    func getUserInfoData(userSet userGet:GIDGoogleUser){
        USERINFO.userID = userGet.userID
        USERINFO.name = userGet.profile.name
        USERINFO.email = userGet.profile.email
        USERINFO.hasImage = userGet.profile.hasImage
        USERINFO.imageURL = userGet.profile.imageURL(withDimension: UInt(userImageDimension))
        
        USERINFO.accessToken = userGet.authentication.refreshToken
        USERINFO.accessToken = userGet.authentication.accessToken
    }
}
