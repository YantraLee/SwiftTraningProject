//
//  YoutubeStatisticsModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeStatisticsModel: Mappable {
    
    var viewCount:String = ""
    var likeCount:String = ""
    var dislikeCount:String = ""
    var favoriteCount:String = ""
    var commentCount:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        viewCount <- map["viewCount"]
        likeCount <- map["likeCount"]
        dislikeCount <- map["dislikeCount"]
        favoriteCount <- map["favoriteCount"]
        commentCount <- map["commentCount"]
    }
}
