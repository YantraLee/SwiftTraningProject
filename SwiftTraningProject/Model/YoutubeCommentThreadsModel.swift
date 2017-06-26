//
//  YoutubeCommentThreadsModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeCommentThreadsModel:Mappable{
    
    var kind:String = ""
    var etag:String = ""
    var nextPageToken:String = ""
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
