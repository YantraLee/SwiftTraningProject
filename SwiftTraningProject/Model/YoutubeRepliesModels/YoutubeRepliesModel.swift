//
//  YoutubeRepliesModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeRepliesModel:Mappable{
    
    var comments:[YoutubeCommentModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
       comments <- map["comments"]
    }
}
