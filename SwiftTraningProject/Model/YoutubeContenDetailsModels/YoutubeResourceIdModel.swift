//
//  YoutubeResourceIdModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeResourceIdModel:Mappable{
    var kind:String = ""
    var videoId:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        videoId <- map["videoId"]
    }
}
