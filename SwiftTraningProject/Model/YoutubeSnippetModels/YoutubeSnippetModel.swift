//
//  YoutubeSnippetModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeSnippetModel:Mappable{
    var publishedAt:String = ""
    var channelId:String = ""
    var title:String = ""
    var assignable:Bool = false
    var description:String = ""
    var thumbnails:YoutubeThumbnailsModel?
    var channelTitle:String = ""
    var type:String = ""  //like or dislike
    var tags:[String] = [""]
    var categoryId:String = ""
    var liveBroadcastContent:String = ""
    var defaultLanguage:String = "" //ja en zh-TW
    var localized:YoutubeLocalizedModel?
    var defaultAudioLanguage:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        publishedAt <- map["publishedAt"]
        channelId <- map["channelId"]
        title <- map["title"]
        assignable <- map["assignable"]
        description <- map["description"]
        thumbnails <- map["thumbnails"]
        channelTitle <- map["channelTitle"]
        type <- map["type"]
        tags <- map["tags"]
        categoryId <- map["categoryId"]
        liveBroadcastContent <- map["liveBroadcastContent"]
        defaultLanguage <- map["defaultLanguage"]
        localized <- map["localized"]
        defaultAudioLanguage <- map["defaultAudioLanguage"]
    }
}
