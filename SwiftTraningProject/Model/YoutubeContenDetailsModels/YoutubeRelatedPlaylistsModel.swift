//
//  YoutubeRelatedPlaylistsModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeRelatedPlaylistsModel:Mappable{
    
    var likes:String = ""
    var uploads:String = ""
    var watchHistory:String = ""
    var watchLater:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        likes <- map["likes"]
        uploads <- map["uploads"]
        watchHistory <- map["watchHistory"]
        watchLater <- map["watchLater"]
    }
}
