//
//  YoutubePageInfoModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubePageInfoModel:Mappable{
    var totalResults:Int = 0
    var resultsPerPage:Int = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalResults <- map["totalResults"]
        resultsPerPage <- map["resultsPerPage"]
    }
}
