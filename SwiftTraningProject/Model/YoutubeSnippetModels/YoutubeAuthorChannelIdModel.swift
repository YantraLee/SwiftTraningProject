//
//  YoutubeAuthorChannelIdModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeAuthorChannelIdModel: Mappable {
    var value:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        value <- map["value"]
    }

}
