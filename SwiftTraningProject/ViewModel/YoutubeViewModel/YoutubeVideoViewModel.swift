//
//  YoutubeVideoViewModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/24.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift

class YoutubeVideoViewModel {
    let videoThumbNail = MutableProperty(UIImage())
    let viewCount = MutableProperty("")
    let likeCount  = MutableProperty("")
    let dislikeCount  = MutableProperty("")
    
    var  youtubeItemModel : YoutubeItemModel!{
        didSet{
        
            if let videoThumbNailURL = youtubeItemModel.snippet?.thumbnails?.maxres?.url{
                ImageLoadTool.load_image(urlSet: URL.init(string: videoThumbNailURL)!, completion: { (image) in
                    self.videoThumbNail.value = image
                })
            }
            
            if let viewCountGet = youtubeItemModel.statistics?.viewCount{
                viewCount.value = String.init(format: LocalizationManagerTool.getString(key: "viewCount_Title", tableSet: nil), arguments: [viewCountGet])
            }else{
                viewCount.value = String.init(format: LocalizationManagerTool.getString(key: "viewCount_Title", tableSet: nil), arguments: ["0"])
            }
            
            if let likeCountGet = youtubeItemModel.statistics?.likeCount{
                likeCount.value = likeCountGet
            }else{
                likeCount.value = "0"
            }
            
            if let dislikeCountGet = youtubeItemModel.statistics?.dislikeCount{
                dislikeCount.value = dislikeCountGet
            }else{
                dislikeCount.value = "0"
            }
        }
    }
    
    func createRatingButtonViewModel() -> RatingButtonViewModel{
        return RatingButtonViewModel.init(rating: YoutubeRatingEnumType.none.rawValue, selected: false)
    }
}

struct RatingButtonViewModel {
    let backgroundColor = MutableProperty(UIColor.black)
    let tintColor = MutableProperty(UIColor.white)
    var rating : String?
    var selected : Bool{
        didSet{
            switch selected {
            case true:
                backgroundColor.value = UIColor.clear
                tintColor.value = UIColor.lightGray
                break
            case false:
                backgroundColor.value = UIColor.black
                tintColor.value = UIColor.white
                break
            }
        }
    }
    
    mutating func setSelectedStatus(rating RatingType:String, btnType btnRatingType:String){
        switch RatingType {
        case YoutubeRatingEnumType.none.rawValue,YoutubeRatingEnumType.unspecified.rawValue:
            selected = false
            rating = btnRatingType
            break
        case YoutubeRatingEnumType.like.rawValue,YoutubeRatingEnumType.dislike.rawValue:
            selected = true
            rating = YoutubeRatingEnumType.none.rawValue
            break
        default:
            selected = false
            break
        }
    }
}
