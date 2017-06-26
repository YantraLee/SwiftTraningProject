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
    
    var channelTitle = MutableProperty("")
    var channelThumbNail = MutableProperty(UIImage())

// Mark: - 取得並處理 YoutubeItemModel的參數
    var  youtubeVideoItemModel : YoutubeItemModel!{
        didSet{
        
            if let videoThumbNailURL = youtubeVideoItemModel.snippet?.thumbnails?.maxres?.url{
                ImageLoadTool.load_image(urlSet: URL.init(string: videoThumbNailURL)!, completion: { (image) in
                    self.videoThumbNail.value = image
                })
            }
            
            if let viewCountGet = youtubeVideoItemModel.statistics?.viewCount{
                viewCount.value = String.init(format: LocalizationManagerTool.getString(key: "viewCount_Title", tableSet: nil), arguments: [viewCountGet])
            }else{
                viewCount.value = String.init(format: LocalizationManagerTool.getString(key: "viewCount_Title", tableSet: nil), arguments: ["0"])
            }
            
            if let likeCountGet = youtubeVideoItemModel.statistics?.likeCount{
                likeCount.value = likeCountGet
            }else{
                likeCount.value = "0"
            }
            
            if let dislikeCountGet = youtubeVideoItemModel.statistics?.dislikeCount{
                dislikeCount.value = dislikeCountGet
            }else{
                dislikeCount.value = "0"
            }
        }
    }
// Model:- 取得並處理YoutubeItemModel的參數
    var youtubeChannelItemModel : YoutubeItemModel!{
        didSet{
            
            if let channelThumbNailUrl = youtubeChannelItemModel.snippet?.thumbnails?.defaultQuality?.url{
                ImageLoadTool.load_image(urlSet:URL.init(string: channelThumbNailUrl)! , completion: { (image) in
                    self.channelThumbNail.value = image
                })
            }
            
            if let channelTitleString = youtubeChannelItemModel.snippet?.title{
                self.channelTitle.value = channelTitleString
            }
        }
    }
// MARK: - create和Button搭配的viewModel
    func createRatingButtonViewModel() -> RatingButtonViewModel{
        return RatingButtonViewModel.init(rating: YoutubeRatingEnumType.none.rawValue, selected: false)
    }

// MARK:- mostPopularVideosModel的處理
    var commentItemArray  =  [YoutubeItemModel]()  //儲存videos的item的Array
    var commentThreadsNextPageToken:String?  //儲存下一頁的token
    var youtubeCommentThreadsModel:YoutubeCommentThreadsModel!{   //儲存整個videos的model
        didSet{
            youtubeCommentThreadsModel.items = commentItemArray
            commentThreadsNextPageToken = youtubeCommentThreadsModel.nextPageToken
        }
    }
    var commentProgressViewArray = [Int:AnyObject]()  //如果要放客製化Class 要使用AnyObject代替class對象本身
    var commentImageCacheArray = [Int:AnyObject]()  //儲存圖片的array
    func createCommentProgressView(forIndex index:Int, boundsGet: CGRect ) {
        if commentProgressViewArray[index] == nil {
            let progressView = CircularLoaderView.init(frame: CGRect.zero)
            commentProgressViewArray[index] =  progressView
            progressView.frame = boundsGet
            progressView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
    
// MARK: - create CommentThreadsViewCellViewModel
    func createCommentThreadsViewCellViewModel(forIndex index:Int) -> CommentThreadsViewCellViewModel{
        if let imageGet = commentImageCacheArray[index]{
            return CommentThreadsViewCellViewModel.init(withSnippet: (youtubeCommentThreadsModel.items![index].snippet)!, withImage:imageGet as? UIImage , withProgressView: commentProgressViewArray[index] as! CircularLoaderView)
        }else{
            return CommentThreadsViewCellViewModel.init(withSnippet: (youtubeCommentThreadsModel.items![index].snippet)!, withImage: nil, withProgressView: commentProgressViewArray[index] as! CircularLoaderView)
        }
    }
}

// MARK:- RatingButton用的 ViewModel
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

// MARK:- CommentThreadsViewCell ViewModel
struct CommentThreadsViewCellViewModel {
    let authorThumbNailURL:URL
    let authorThumbNailImage:UIImage?
    let authorTitle:String
    let commentDate:String
    let commentContent:String
    let totalReplyCount:String
    let checkTotalReplyShow:Bool
    let canReply:Bool
    let progressIndicatorView:CircularLoaderView
    
    init(withSnippet snippetModel:YoutubeSnippetModel, withImage image:UIImage? = nil, withProgressView progressView:CircularLoaderView){
        authorThumbNailURL = URL.init(string: (snippetModel.topLevelComment?.snippet?.authorProfileImageUrl)!)!
        if(image != nil){
            authorThumbNailImage = image!
        }else{
            authorThumbNailImage = nil
        }
        authorTitle = (snippetModel.topLevelComment?.snippet?.authorDisplayName)!
        commentDate = DateStringFormatterTool.stringToString(dateString: (snippetModel.topLevelComment?.snippet?.updatedAt)!, format: youtubeDateformat, toFormat: localDateformat)
        commentContent = (snippetModel.topLevelComment?.snippet?.textOriginal)!
        totalReplyCount = String.init(format: LocalizationManagerTool.getString(key: "Youtube_Video_Check_All_Comments", tableSet: nil), arguments: [snippetModel.totalReplyCount])
        if snippetModel.totalReplyCount<=0 {
            checkTotalReplyShow = false
        }else{
            checkTotalReplyShow = true
        }
        canReply = snippetModel.canReply
        progressIndicatorView = progressView
    }
}
