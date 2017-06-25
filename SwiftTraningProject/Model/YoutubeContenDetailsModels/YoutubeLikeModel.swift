//
//  YoutubeLikeModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeLikeModel: Mappable {
    var resourceId:YoutubeResourceIdModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resourceId <- map["resourceId"]
    }
}
