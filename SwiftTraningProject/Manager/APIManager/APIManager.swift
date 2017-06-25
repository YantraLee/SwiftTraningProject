//
//  APIManager.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/12.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSpinner
import AlamofireObjectMapper

class APIManager {
    //Sigleton宣告
    private static var mInstance : APIManager?
    //property宣告
    private let baseURL = "https://www.googleapis.com/youtube/v3"
    private let Auth_header = [ "Authorization" : "Bearer"+" "+USERINFO.accessToken! ] //access_token
    
// MARK:- Singleton create
    static func shareInstance() -> APIManager{
        if (mInstance == nil) {
            mInstance=APIManager()
        }
        return mInstance!
    }


// MARK:- API rquest
    func requestMyActivities(completion: @escaping(YoutubeActivitiesModel)->Void){
        let parameters = ["part":snippetPart+","+contentDetailsPart,"maxResults":defaultMaxResult,"mine":"true","regionCode" : USERINFO.regionCode!] as [String : AnyObject]
         let URL = baseURL+APIURLEnumType.activities.rawValue
        
        Alamofire.request(URL, method: .get, parameters: parameters, encoding:  URLEncoding.default, headers: Auth_header).responseObject { (response:DataResponse<YoutubeActivitiesModel>) in
            if(response.error == nil){
                completion(response.result.value!)
            }else{
                 self.showErrorMessage(APIName: "requestMyActivities", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)! )
            }
        }
    }
    
    func requestVideoCategories(completion: @escaping(YoutubeVideoCategoriesModel)->Void){
        let parameters = ["part":snippetPart,"regionCode" : USERINFO.regionCode!] as [String : AnyObject];
        let URL = baseURL+APIURLEnumType.videoCategories.rawValue
        
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default , headers: Auth_header).responseObject { (response:DataResponse<YoutubeVideoCategoriesModel>) in
            if(response.error == nil){
                completion(response.result.value!)
            }else{
                self.showErrorMessage(APIName: "requestVideoCategories", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestMostPopularVideos(videoCategoryId videoCategoryIdGet:String, pageToken:String,completion: @escaping(YoutubeVideosModel)->Void){
        let parameters = ["part":snippetPart+","+contentDetailsPart+","+statisticsPart,"chart":"mostPopular","regionCode" : USERINFO.regionCode!,"videoCategoryId":videoCategoryIdGet,"maxResults":defaultMaxResult,"pageToken":pageToken] as [String : AnyObject];
        let URL = baseURL+APIURLEnumType.videos.rawValue
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: Auth_header).responseObject { (response:DataResponse<YoutubeVideosModel>) in
            if(response.error == nil){
                completion(response.result.value!)
            }else{
                self.showErrorMessage(APIName: "requestMostPopularVideos", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestMyLikeVideos(pageToken:String, completion: @escaping(YoutubeVideosModel)->Void){
        let parameters = ["part":snippetPart+","+contentDetailsPart+","+statisticsPart,"regionCode" : USERINFO.regionCode!,"maxResults":defaultMaxResult,"myRating":"like","pageToken":pageToken] as [String : AnyObject];
        let URL = baseURL+APIURLEnumType.videos.rawValue
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: Auth_header).responseObject { (response:DataResponse<YoutubeVideosModel>) in
            if(response.error == nil){
                completion(response.result.value!)
            }else{
                self.showErrorMessage(APIName: "requestMyLikeVideos", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestVideosByIDList(id idGet:[String]? = [""], completion: @escaping(YoutubeVideosModel)->Void){
        
        let parameters = ["part":snippetPart+","+contentDetailsPart+","+statisticsPart ,"id" : ArrayStringConversion.arrayToString(array: idGet!)] as [String : AnyObject];
        let URL = baseURL+APIURLEnumType.videos.rawValue
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: Auth_header).responseObject { (response:DataResponse<YoutubeVideosModel>) in
            if(response.error == nil){
                completion(response.result.value!)
            }else{
                self.showErrorMessage(APIName: "requestVideosByIDList", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestVideosGetRating(id idGet:[String]? = [""], completion: @escaping(YoutubeVideosModel)->Void){
        let parameters = ["id":ArrayStringConversion.arrayToString(array: idGet!)] as [String : AnyObject]
        let URL = baseURL+APIURLEnumType.videosGetRating.rawValue
        Alamofire.request(URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: Auth_header).responseObject { (response:DataResponse<YoutubeVideosModel>) in
            if response.error == nil {
                completion(response.result.value!)
            }else{
                self.showErrorMessage(APIName: "requestVideosGetRating", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func requestVideosRate(id idGet:String? = "" , rating ratingGet:String? = "" , completion: @escaping(Bool)->Void){
        let parameters = ["id":idGet,"rating":ratingGet] as [String : AnyObject]
        let URL = baseURL+APIURLEnumType.videosRate.rawValue
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: Auth_header).response { (response) in
            if response.error == nil {
                 completion(true)
            }else{
                completion(false)
                self.showErrorMessage(APIName: "requestVideosRate", errorCode: response.response!.statusCode, errorDescription: (response.error?.localizedDescription)!)
            }
        }
    }

// MARK: - show Error Message
    func showErrorMessage(APIName APINameGet:String,errorCode errorCodeGet:Int, errorDescription errorDescriptionGet:String){
        SwiftSpinner.show(duration: 1.0, title: LocalizationManagerTool.getString(key: "API_Requesting_Error", tableSet: nil))
        print("error with "+APINameGet+" status: \(String(describing: errorCodeGet))"+"and response message : \(errorDescriptionGet)")
    }
}
