//
//  YoutubeTopLevelCommentModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeTopLevelCommentModel: Mappable {
    
    var kind:String = ""
    var etag:String = ""
    var id:String = "" //channelID
    var snippet:YoutubeTopLevelCommentSnippetModel?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        id <- map["id"]
        snippet <- map["snippet"]
    }

}
