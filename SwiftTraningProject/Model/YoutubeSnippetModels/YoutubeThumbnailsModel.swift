//
//  YoutubeThumbnailsModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeThumbnailsModel:Mappable{
    var defaultQuality:YoutubeThumbnailQualityModel? //因為default為保留字 故修改參數名稱
    var medium:YoutubeThumbnailQualityModel?
    var high:YoutubeThumbnailQualityModel?
    var standard:YoutubeThumbnailQualityModel?
    var maxres:YoutubeThumbnailQualityModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        defaultQuality <- map["default"]
        medium <- map["medium"]
        high <- map["high"]
        standard <- map["standard"]
        maxres <- map["maxres"]
    }
}
