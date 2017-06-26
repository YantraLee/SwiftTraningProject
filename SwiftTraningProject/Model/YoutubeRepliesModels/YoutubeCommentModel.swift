//
//  YoutubeCommentModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeCommentModel: Mappable {
    
    var kind:String = ""
    var etag:String = ""
    var id:String = "" //channelID
    var snippet:YoutubeCommentSnipperModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        snippet <- map["snippet"]
    }
}
