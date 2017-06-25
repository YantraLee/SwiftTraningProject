//
//  YoutubeItemModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeItemModel:Mappable{
    var kind:String = ""
    var etag:String = ""
    var id:String = "" //video id
    var videoId:String = "" //rating video id
    var rating:String = "" //rating Result
    var snippet:YoutubeSnippetModel?
    var contentDetails:YoutubeContentDetailsModel?
    var statistics:YoutubeStatisticsModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        videoId <- map["videoId"]
        rating <- map["rating"]
        snippet <- map["snippet"]
        contentDetails <- map["contentDetails"]
        statistics <- map["statistics"]
    }
}
