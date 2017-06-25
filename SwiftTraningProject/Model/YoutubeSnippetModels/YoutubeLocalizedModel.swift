//
//  YoutubeLocalizedModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeLocalizedModel:Mappable{
    var title:String = ""
    var description:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
    }
}
