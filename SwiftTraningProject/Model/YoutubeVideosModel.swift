//
//  YoutubeVideoModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeVideosModel:Mappable{
    var kind:String = ""
    var etag:String = ""
    var nextPageToken:String = "" //video id
    var pageInfo:YoutubePageInfoModel?
    var items:[YoutubeItemModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        nextPageToken <- map["nextPageToken"]
        pageInfo <- map["pageInfo"]
        items <- map["items"]
    }
}
