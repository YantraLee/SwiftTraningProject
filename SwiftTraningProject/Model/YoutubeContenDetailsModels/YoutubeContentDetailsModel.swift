//
//  YoutubeContentDetailsModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeContentDetailsModel: Mappable {
    var like:YoutubeLikeModel?
    var duration:String = ""
    var dimension:String = ""
    var definition:String = ""
    var caption:String = ""
    var licensedContent:Bool = false
    var projection:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        like <- map["like"]
        duration <- map["duration"]
        dimension <- map["dimension"]
        definition <- map["definition"]
        caption <- map["caption"]
        licensedContent <- map["licensedContent"]
        projection <- map["projection"]
    }
}
