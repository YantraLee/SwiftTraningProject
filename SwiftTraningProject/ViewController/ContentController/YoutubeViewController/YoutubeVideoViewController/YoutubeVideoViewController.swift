//
//  YoutubeVideoViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/24.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftSpinner

enum YoutubeVideoViewControllerEvent:Int{
    case YoutubeVideoViewControllerEvent_ToPlayer=0 //轉到播放畫面
}

protocol YoutubeVideoViewControllerDelegate {
    func didYoutubeVideoViewController(withObject Dict:[String:AnyObject]?, event eventGet:YoutubeVideoViewControllerEvent)
}

class YoutubeVideoViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,URLSessionDownloadDelegate{
    
    //UI宣告
    @IBOutlet weak var mainContentContainerView: UIView!
    @IBOutlet weak var addCommentContainerView: UIView!
    @IBOutlet weak var commentContentContainerView: UIView!
    
    @IBOutlet weak var videoImgView: UIImageView!
    @IBOutlet weak var videoPlayImagView: UIImageView!
    @IBOutlet weak var videoPlayBtn: UIButton!
    
    @IBOutlet weak var channelImgView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    
    @IBOutlet weak var addCommentBtn: UIButton!
    //constraint宣告
    @IBOutlet weak var mainContainer_TopSpace: NSLayoutConstraint!
    
    //ViewModel宣告
    let youtubeVideoViewModel = YoutubeVideoViewModel()
    var likeBtnViewModel : RatingButtonViewModel?
    var dislikeBtnViewModel : RatingButtonViewModel?
    
    //delegate宣告
    var delegate : YoutubeVideoViewControllerDelegate?
    
    //客製化類別宣告
    let customContainerTableViews = CustomContainerTableViews()
    
    //property 
    var alreadyMoveDown : Bool = false
    var alreadyDone:Bool = false
    let nibsNameArray : [String] = ["CommentThreadsViewCell"]
    let cellIdentifierArray : [String] = [CommentThreadsViewCell.cellIdentifier]
    
    var commentThreadCellArray = [Int:AnyObject]()
    
// Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initData()
    }
    
    override func viewDidLayoutSubviews() {
        //將整個畫面往下挪一個距離 避免navigationBar擋到元件
        if !alreadyMoveDown {
            alreadyMoveDown = !alreadyMoveDown
            mainContainer_TopSpace.constant = mainContainer_TopSpace.constant + (self.navigationController!.navigationBar.bounds.size.height*1.5 )
        }
        
        if(!alreadyDone){
            alreadyDone = true
            //添加客製化tableView
            commentContentContainerView.setNeedsLayout()
            commentContentContainerView.layoutIfNeeded()
            commentContentContainerView.addSubview(customContainerTableViews.createContainerTableViews(viewController: self,view: commentContentContainerView, nibNames: nibsNameArray, cellIdentifiers:cellIdentifierArray))
            for tableView in customContainerTableViews.tableViewsArray {
                    let myIndicator:UIActivityIndicatorView = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                    tableView.tableFooterView = myIndicator
                    myIndicator.startAnimating()
                    tableView.tableFooterView?.isHidden = false
            }
        }
    }
// Mark: - init
    func initLayout(){
        //reactive binding
        videoImgView.reactive.image <~ youtubeVideoViewModel.videoThumbNail
        channelImgView.reactive.image <~ youtubeVideoViewModel.channelThumbNail
        channelTitleLabel.reactive.text <~ youtubeVideoViewModel.channelTitle
        viewCountLabel.reactive.text <~ youtubeVideoViewModel.viewCount
        likeCountLabel.reactive.text <~ youtubeVideoViewModel.likeCount
        dislikeCountLabel.reactive.text <~ youtubeVideoViewModel.dislikeCount
        //按鈕的reacvtive綁定
        likeBtnViewModel = youtubeVideoViewModel.createRatingButtonViewModel()
        likeBtn.reactive.backgroundColor <~ likeBtnViewModel!.backgroundColor
        likeBtnClicked_Define()
        
        dislikeBtnViewModel = youtubeVideoViewModel.createRatingButtonViewModel()
        dislikeBtn.reactive.backgroundColor <~ dislikeBtnViewModel!.backgroundColor
        dislikeBtnClicked_Define()
        
        videpPlayImgViewClicked_Define()
        
        //button layout init
        likeBtn = CustomButton.makeCustomRatingBtn(button: likeBtn, content: LocalizationManagerTool.getString(key: "Youtube_Video_Like_Btn", tableSet: nil), fontSizeSet: 15)
        dislikeBtn = CustomButton.makeCustomRatingBtn(button: dislikeBtn, content: LocalizationManagerTool.getString(key: "Youtube_Video_DisLike_Btn", tableSet: nil), fontSizeSet: 15)
        addCommentBtn = CustomButton.makeViewContainerCustomButton(button: addCommentBtn, content: LocalizationManagerTool.getString(key: "Youtube_Video_Add_Comment", tableSet: nil) , fontSizeSet: 17)
    }
    func initData(){
        requestVideosGetRating()
        requestChannel()
        requesrCommentThread(pageToken: "")
    }
// MARK: - IBAction
    func videpPlayImgViewClicked_Define(){
        videoPlayBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            self.delegate?.didYoutubeVideoViewController(withObject: ["VideoID":self.youtubeVideoViewModel.youtubeVideoItemModel.id as AnyObject], event: .YoutubeVideoViewControllerEvent_ToPlayer)
        }
    }
    func likeBtnClicked_Define(){
        likeBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
            APIManagerTool.requestVideosRate(id: self.youtubeVideoViewModel.youtubeVideoItemModel.id, rating: self.likeBtnViewModel!.rating, completion: { (success) in
                if success {
                    self.setRatingBtnStatus(ratingType: self.likeBtnViewModel!.rating!)
                    self.requestVideoByIDList() //重新去取得視頻的相關資料
                }
            })
        }
    }
    func dislikeBtnClicked_Define(){
        dislikeBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
            APIManagerTool.requestVideosRate(id: self.youtubeVideoViewModel.youtubeVideoItemModel.id, rating: self.dislikeBtnViewModel!.rating, completion: { (success) in
                if success {
                    self.setRatingBtnStatus(ratingType: self.dislikeBtnViewModel!.rating!)
                    self.requestVideoByIDList() //重新去取得視頻的相關資料
                }
            })
        }
    }
// MARK: - API Request
    func requestVideosGetRating(){
        SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
        APIManagerTool.requestVideosGetRating(id: [youtubeVideoViewModel.youtubeVideoItemModel.id]) { (response) in
            if let youtubeItemRatingModel = response.items?[0] {
                //按鈕的viewModel綁定
                self.setRatingBtnStatus(ratingType: youtubeItemRatingModel.rating)
            }
            SwiftSpinner.hide()
        }
    }
    
    func requestVideoByIDList(){
        SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
        APIManagerTool.requestVideosByIDList(id: [youtubeVideoViewModel.youtubeVideoItemModel.id]) { (response) in
            if let youtubeItemModel = response.items?[0] {
                self.youtubeVideoViewModel.youtubeVideoItemModel = youtubeItemModel
            }
            SwiftSpinner.hide()
        }
    }
    
    func requestChannel(){
         SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
        APIManagerTool.requestChannels(id: [(youtubeVideoViewModel.youtubeVideoItemModel.snippet?.channelId)!]) { (response) in
            if let youtubeChannelModel = response.items?[0] {
                self.youtubeVideoViewModel.youtubeChannelItemModel = youtubeChannelModel
            }
        }
    }
    
    func requesrCommentThread(pageToken pageTokenSet:String){
        APIManagerTool.requestCommentsThreads(id: youtubeVideoViewModel.youtubeVideoItemModel.id, pageToken: pageTokenSet) { (response) in
            self.youtubeVideoViewModel.commentItemArray += response.items!
            self.youtubeVideoViewModel.youtubeCommentThreadsModel = response
            self.customContainerTableViews.reloadTableViews(index: 0)
        }
    }
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       return CommentThreadsViewCell.VideosViewCell_Hieght
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor.clear
    }
    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            if youtubeVideoViewModel.youtubeCommentThreadsModel != nil {
                return (youtubeVideoViewModel.youtubeCommentThreadsModel.items?.count)!
            }else{
                return 0
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if((youtubeVideoViewModel.youtubeCommentThreadsModel) != nil){
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentThreadsViewCell.cellIdentifier) as! CommentThreadsViewCell
                //store cell object
                commentThreadCellArray[indexPath.row] = cell
                //create progressIndicatorView
                youtubeVideoViewModel.createCommentProgressView(forIndex: indexPath.row, boundsGet: cell.authorImgView.frame)
                //將Model的值經過處理後 拋給viewCell的viewModel
                cell.CommentsViewCellModel = youtubeVideoViewModel.createCommentThreadsViewCellViewModel(forIndex: indexPath.row)
                //圖片處理
                ImageLoadTool.load_image_WithProgress(urlSet: cell.CommentsViewCellModel.authorThumbNailURL, viewController: self, index: indexPath.row)
                if youtubeVideoViewModel.commentImageCacheArray[indexPath.row] != nil{
                    cell.CommentsViewCellModel = youtubeVideoViewModel.createCommentThreadsViewCellViewModel(forIndex: indexPath.row)
                }
                //判斷是否需要loading後面的資料
                if ( youtubeVideoViewModel.commentItemArray.count - indexPath.row) < 10 {
                    if youtubeVideoViewModel.commentThreadsNextPageToken != "" {
                        requesrCommentThread(pageToken: youtubeVideoViewModel.commentThreadsNextPageToken!)
                    }else{
                        tableView.tableFooterView?.isHidden = true
                    }
                }
                return cell
        }else{
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
// MARK:- URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        let progressGet = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        let indicator = youtubeVideoViewModel.commentProgressViewArray[downloadTask.taskIdentifier] as? CircularLoaderView
        indicator?.progress = progressGet
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
        do{//有throws的function 需要放在do blocks內部
            let data = try? Data.init(contentsOf: location)
            let image = UIImage.init(data: data!)
            if youtubeVideoViewModel.commentImageCacheArray[downloadTask.taskIdentifier] == nil{
                self.youtubeVideoViewModel.commentImageCacheArray[downloadTask.taskIdentifier] = image
                DispatchQueue.main.async {
                    let cell = self.commentThreadCellArray[downloadTask.taskIdentifier] as? CommentThreadsViewCell
                    cell?.CommentsViewCellModel = self.youtubeVideoViewModel.createCommentThreadsViewCellViewModel(forIndex: downloadTask.taskIdentifier)
                }
            }
        }//如果throws有定義回傳型別 必須要補上catch block 去 hnadle
    }
    

// MARK: - private method
    func setRatingBtnStatus(ratingType ratingTypeGet:String){
        switch ratingTypeGet{
        case YoutubeRatingEnumType.like.rawValue:
            self.likeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.like.rawValue, btnType: YoutubeRatingEnumType.none.rawValue)
            self.dislikeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.none.rawValue, btnType: YoutubeRatingEnumType.dislike.rawValue)
            break
        case YoutubeRatingEnumType.dislike.rawValue:
            self.likeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.none.rawValue, btnType: YoutubeRatingEnumType.like.rawValue)
            self.dislikeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.dislike.rawValue, btnType: YoutubeRatingEnumType.none.rawValue)
            break
        case YoutubeRatingEnumType.none.rawValue:
            self.likeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.none.rawValue, btnType: YoutubeRatingEnumType.like.rawValue)
            self.dislikeBtnViewModel?.setSelectedStatus(rating: YoutubeRatingEnumType.none.rawValue, btnType: YoutubeRatingEnumType.dislike.rawValue)
            break
        default:
            break
        }
        //設定字體顏色
        self.likeBtn.setTitleColor(self.likeBtnViewModel!.tintColor.value, for: .normal)
        self.dislikeBtn.setTitleColor(self.dislikeBtnViewModel?.tintColor.value, for: .normal)
    }
}
