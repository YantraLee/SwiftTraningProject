//
//  YoutubeMainViewModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/19.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift

class YoutubeMainViewModel {
// MARK:- videoCatrgoriesModel的處理
    var videoCatrgoriesModel:YoutubeVideoCategoriesModel!{
        didSet{
          //利用filter 把不合格的對象剔除掉
           videoCatrgoriesModel.items = videoCatrgoriesModel?.items?.filter({ (model) -> Bool in
                return (model.snippet?.assignable)!
           })
        }
    }
    func createViewCategoryViewCellModel(forIndex index:Int) -> ViewCategoryViewCellModel{
        return ViewCategoryViewCellModel.init(withViewCatrgorySnippet: (videoCatrgoriesModel?.items![index].snippet)!)
    }
    
// MARK:- mostPopularVideosModel的處理
    var mostPopularVideosItemArray  =  [YoutubeItemModel]()  //儲存videos的item的Array
    var mostPopularVideosNextPageToken:String?  //儲存下一頁的token
    var mostPopularVideosModel:YoutubeVideosModel!{   //儲存整個videos的model
        didSet{
            mostPopularVideosModel.items = mostPopularVideosItemArray
            mostPopularVideosNextPageToken = mostPopularVideosModel.nextPageToken
        }
    }
    var mostPopularProgressViewArray = [Int:AnyObject]()  //如果要放客製化Class 要使用AnyObject代替class對象本身
    var mostPopularVideoImageCacheArray = [Int:AnyObject]()  //儲存圖片的array
    func createMostPopularProgressView(forIndex index:Int, boundsGet: CGRect ) {
      if mostPopularProgressViewArray[index] == nil {
                let progressView = CircularLoaderView.init(frame: CGRect.zero)
                mostPopularProgressViewArray[index] =  progressView
                progressView.frame = boundsGet
                progressView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            }
    }
// MARK: - create MostPupularVideosViewCellModel
    func createMostPupularVideosViewCellModel(forIndex index:Int) -> VideoViewCellModel{
        if let imageGet = mostPopularVideoImageCacheArray[index]{
             return VideoViewCellModel.init(withVideoSnippet: (mostPopularVideosModel?.items![index].snippet)!, withVideoStatistics: (mostPopularVideosModel?.items![index].statistics)!, withImage: imageGet as? UIImage, withProgressView: (mostPopularProgressViewArray[index])! as! CircularLoaderView)
        }else{
             return VideoViewCellModel.init(withVideoSnippet: (mostPopularVideosModel?.items![index].snippet)!, withVideoStatistics: (mostPopularVideosModel?.items![index].statistics)!, withImage: nil, withProgressView: (mostPopularProgressViewArray[index])! as! CircularLoaderView)
        }
    }
// MARK:- mylikedVideosModel的處理
    var myLikedVideosItemArray  =  [YoutubeItemModel]()
    var myLikedVideosNextPageToken:String?
    var myLikedVideosModel:YoutubeVideosModel!{
        didSet{
            myLikedVideosModel.items = myLikedVideosItemArray
            myLikedVideosNextPageToken = myLikedVideosModel.nextPageToken
        }
    }
    var myLikedProgressViewArray = [Int:AnyObject]()  //如果要放客製化Class 要使用AnyObject代替class對象本身
    var myLikedVideoImageCacheArray = [Int:AnyObject]()
    func createMyLikedProgressView(forIndex index:Int, boundsGet: CGRect ) {
        if myLikedProgressViewArray[index] == nil {
            let progressView = CircularLoaderView.init(frame: CGRect.zero)
            myLikedProgressViewArray[index] =  progressView
            progressView.frame = boundsGet
            progressView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        }
    }
// MARK: - create ViewCategoryViewCellModel
    func createMyLikeVideosViewCellModel(forIndex index:Int) -> VideoViewCellModel {
        if let imageGet = myLikedVideoImageCacheArray[index]{
            return VideoViewCellModel.init(withVideoSnippet: (myLikedVideosModel.items![index].snippet)!, withVideoStatistics: (myLikedVideosModel?.items![index].statistics)!, withImage: imageGet as? UIImage, withProgressView: (myLikedProgressViewArray[index])! as! CircularLoaderView)
        }else{
              return VideoViewCellModel.init(withVideoSnippet: (myLikedVideosModel?.items![index].snippet)!, withVideoStatistics: (myLikedVideosModel?.items![index].statistics)!, withImage: nil, withProgressView: (myLikedProgressViewArray[index])! as! CircularLoaderView)
        }
    }
// MARK: - clean cache
    func cleanCache(){
        mostPopularVideosItemArray.removeAll()
        mostPopularProgressViewArray.removeAll()
        mostPopularVideoImageCacheArray.removeAll()
        
        myLikedVideosItemArray.removeAll()
        myLikedProgressViewArray.removeAll()
        myLikedVideoImageCacheArray.removeAll()
    }
}


// MARK:- ViewCategoryViewCellModel for ViewCategoryViewCell
struct ViewCategoryViewCellModel{
    let mainTitle:String
    let subTitle:String
    
    init(withViewCatrgorySnippet model:YoutubeSnippetModel){
        mainTitle = LocalizationManagerTool.getString(key: model.title, tableSet: nil)
        subTitle = model.title
    }
}

// MARK:- VideoViewCellModel for VideoViewCell
struct VideoViewCellModel {
    let mainTitle:String //取localized內的參數
    let publishedAt:String
    let thumbnailsURL:URL
    let progressIndicatorView:CircularLoaderView
    let thumbnailsImage:UIImage?  //default尺寸為 120*90
    let channelTitle:String
    let viewCount:String
    
    init(withVideoSnippet snippetModel:YoutubeSnippetModel, withVideoStatistics statisticsModel:YoutubeStatisticsModel, withImage image:UIImage? = nil, withProgressView progressView:CircularLoaderView){
        mainTitle = (snippetModel.localized?.title)!
        publishedAt = String.init(format: LocalizationManagerTool.getString(key: "publishedDate_Title", tableSet: nil), arguments: [DateStringFormatterTool.stringToString(dateString: snippetModel.publishedAt, format: youtubeDateformat, toFormat: localDateformat)])
        thumbnailsURL = URL.init(string:(snippetModel.thumbnails?.defaultQuality?.url)!)!
        if(image != nil){
            thumbnailsImage = image!
        }else{
            thumbnailsImage = nil
        }
        progressIndicatorView = progressView
        channelTitle = snippetModel.channelTitle
        viewCount = String.init(format: LocalizationManagerTool.getString(key: "viewCount_Title", tableSet: nil), arguments:  [statisticsModel.viewCount])
    }
}
