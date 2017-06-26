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
    var title:String = ""  //頻道(主)的名稱
    var assignable:Bool = false
    var description:String = ""
    var customUrl:String = ""
    var thumbnails:YoutubeThumbnailsModel?
    var channelTitle:String = ""
    var type:String = ""  //like or dislike
    var tags:[String] = [""]
    var categoryId:String = ""
    var liveBroadcastContent:String = ""
    var defaultLanguage:String = "" //ja en zh-TW
    var localized:YoutubeLocalizedModel?
    var defaultAudioLanguage:String = ""
    var country:String = ""
    var videoId:String = ""
    var topLevelComment:YoutubeTopLevelCommentModel?
    var canReply:Bool = false //能否再針對此comment做回覆
    var totalReplyCount:Int = 0  //回覆此topLevelComment的下一層comment數目
    var isPublic:Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        publishedAt <- map["publishedAt"]
        channelId <- map["channelId"]
        title <- map["title"]
        assignable <- map["assignable"]
        description <- map["description"]
        customUrl <- map["customUrl"]
        thumbnails <- map["thumbnails"]
        channelTitle <- map["channelTitle"]
        type <- map["type"]
        tags <- map["tags"]
        categoryId <- map["categoryId"]
        liveBroadcastContent <- map["liveBroadcastContent"]
        defaultLanguage <- map["defaultLanguage"]
        localized <- map["localized"]
        defaultAudioLanguage <- map["defaultAudioLanguage"]
        country <- map["country"]
        videoId <- map["videoId"]
        topLevelComment <- map["topLevelComment"]
        canReply <- map["canReply"]
        totalReplyCount <- map["totalReplyCount"]
        isPublic <- map["isPublic"]
    }
}
