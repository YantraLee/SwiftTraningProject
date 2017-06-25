//
//  YoutubeVideoCategoriesModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeVideoCategoriesModel:Mappable{
    var kind:String = ""
    var etag:String = ""
    var items:[YoutubeItemModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        etag <- map["etag"]
        items <- map["items"]
    }
}
