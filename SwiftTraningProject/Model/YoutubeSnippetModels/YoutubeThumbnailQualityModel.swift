//
//  YoutubeThumbnailQualityModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeThumbnailQualityModel:Mappable{
    var url:String = ""
    var width:Int = 0
    var height:Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        width <- map["width"]
        height <- map["height"]
    }
}
