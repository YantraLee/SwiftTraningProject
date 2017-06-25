//
//  ImageLoad.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/11.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import Alamofire

class ImageLoad:NSObject {
    private static var mInstance : ImageLoad?
// MARK:- Singleton create
    static func shareInstance() -> ImageLoad{
        if (mInstance == nil) {
            mInstance = ImageLoad()
        }
        
        return mInstance!
    }
    //直接下載檔案 不需要處理delegate
    func load_image(urlSet imgURL:URL, completion: @escaping (UIImage) -> Void){
//        Alamofire.download(imgURL).downloadProgress(queue:DispatchQueue.global(qos: .utility)) { (progress) in
//            if(progress.fractionCompleted<1){
//                print("Download Progress: \(progress.fractionCompleted)")
//            }
//            }.responseData { (response) in
//                if let data = response.result.value {
//                    DispatchQueue.main.async {
//                        completion(UIImage.init(data: data)!)
//                    }
//                }
//        }

        let urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
       
        let sessionDataTask = urlSession.dataTask(with: imgURL as URL) { (data,urlResponse,error) -> Void in
            if(error == nil){
                completion(UIImage.init(data: data!)!)
            }
        }
        sessionDataTask.resume() //要多加這一行 code才能被正常啟動
      //  print("ImageLoad Error"+sessionDataTask.error.debugDescription)
    }
   //檔案的下載進度和接收會在delegate裡面處理
    func load_image_WithProgress(urlSet imgURL:URL, viewController VC:UIViewController, index indexGet:Int){
        let config = URLSessionConfiguration.default
        let urlSession = URLSession.init(configuration: config, delegate: VC as? URLSessionDownloadDelegate, delegateQueue: OperationQueue.main)
        let sessionDataTask = urlSession.downloadTask(with: imgURL as URL)
        sessionDataTask.setValue(indexGet, forKey: "taskIdentifier") //添加tag辨識數字
        sessionDataTask.resume() //要多加這一行 code才能被正常啟動
    }
    

    
}
