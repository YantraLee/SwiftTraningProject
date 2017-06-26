//
//  YoutubeTopLevelCommentSnippetModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ObjectMapper

class YoutubeTopLevelCommentSnippetModel:Mappable{
    var authorDisplayName:String = ""
    var authorProfileImageUrl:String = ""
    var authorChannelUrl:String = ""
    var authorChannelId:YoutubeAuthorChannelIdModel?
    var videoId:String = ""
    var textDisplay:String = ""
    var textOriginal:String = ""
    var canRate:Bool = false
    var viewerRating:String = "none" //rating => none, like, dislike
    var likeCount:Int = 0
    var publishedAt:String = ""
    var updatedAt:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        authorDisplayName <- map["authorDisplayName"]
        authorProfileImageUrl <- map["authorProfileImageUrl"]
        authorChannelUrl <- map["authorChannelUrl"]
        authorChannelId <- map["authorChannelId"]
        videoId <- map["videoId"]
        textDisplay <- map["textDisplay"]
        textOriginal <- map["textOriginal"]
        canRate <- map["canRate"]
        viewerRating <- map["viewerRating"]
        likeCount <- map["likeCount"]
        publishedAt <- map["publishedAt"]
        updatedAt <- map["updatedAt"]
    }
}
