//
//  YoutubeViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper
import SwiftSpinner

enum YoutubeMainViewControllerEvent:Int{
    case YoutubeMainViewControllerEvent_ToVideo = 0 //轉到單一視頻畫面
}

protocol YoutubeMainViewControllerDelegate {
    func didYoutubeMainViewController(withObject Dict:[String:AnyObject]?, event eventGet:YoutubeMainViewControllerEvent)
}

class YoutubeMainViewController: BaseViewController,YTPlayerViewDelegate,CustomeHorizontalSelectorViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,URLSessionDownloadDelegate {
    
    //UI宣告
    @IBOutlet weak var horizontalSelectorView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    var horizontalScrollView : UIScrollView?
    var tableViewScrollView : UIScrollView?
    //客製化類別宣告
    let cutomHorizontalSelectorView = CustomeHorizontalSelectorView()
    let customContainerTableViews = CustomContainerTableViews()
    let tabBarHideShow = TabBarHideShow()
    //ViewModel宣告
    var youtubeMainViewModel : YoutubeMainViewModel?
    
    //property宣告
    var previousOffset_Vertical : CGFloat = 0 //記錄垂直滑動的數值
    var previousOffset_Horizontal : CGFloat = 0 //紀錄水平滑動的數值
    
    var alreadyRequestList = 0 //已經請求的API數目
    var requiredAPIListed = 3 //需要請求的API數目
    
    let selectorsArray : [String] = [LocalizationManagerTool.getString(key: "HorizontalSelector_Video_Category", tableSet: nil),LocalizationManagerTool.getString(key: "HorizontalSelector_Video_MostPopular", tableSet: nil),LocalizationManagerTool.getString(key: "HorizontalSelector_Video_MyLiked", tableSet: nil)]
    let nibsNameArray : [String] = ["VideoCategoryViewCell","VideosViewCell","VideosViewCell"]
    let cellIdentifierArray : [String] = [VideoCategoryViewCell.cellIdentifier,VideosViewCell.cellIdentifier,VideosViewCell.cellIdentifier]
    
    var alreadyDone:Bool = false
    
    var mostPopularCellArray = [Int:AnyObject]()
    var myLikedCellArray = [Int:AnyObject]()
    //delegate宣告
    var delegate : YoutubeMainViewControllerDelegate?
    
    //constraint宣告
    @IBOutlet weak var containerView_TopSpace: NSLayoutConstraint!
    
    
// MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        initLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        //diable左上角的返回鍵功能
        self.navigationItem.hidesBackButton = true
        //加上右上角的登出按鈕
        CustomNavigationBarItemTool.returnLogOutBtn { (Button) in
            Button.reactive.controlEvents(.touchUpInside).observeValues({ btn in
                CustomAlertViewControllerTool.callAlertController(title: LocalizationManagerTool.getString(key: "Alert_Title", tableSet: nil), message: LocalizationManagerTool.getString(key: "Alert_Logout_Message", tableSet: nil), completion: { (action) in
                    SwiftSpinner.show(duration: 1.0, title: LocalizationManagerTool.getString(key: "Gooogle_Logouting", tableSet: nil))
                        USERINFO.logout() //登出 清空相關資料
                        GIDSignIn.sharedInstance().signOut()
                        self.navigationController?.popViewController(animated: true)
                })
            })
            
            let barButtonItem = UIBarButtonItem.init(customView: Button)
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
        
        alreadyRequestList = 0
        //先清空原本cache的資料
        self.youtubeMainViewModel?.cleanCache()
        initData() //向API請求相關資料
    }
    
    override func viewDidLayoutSubviews() {
        if(!alreadyDone){
            alreadyDone = true
            //橫向選擇項的添加
            cutomHorizontalSelectorView.delegate = self //添加cutomHorizontalSelectorView的按鈕點擊的delegate對象
            horizontalSelectorView.setNeedsLayout()
            horizontalSelectorView.layoutIfNeeded()
            horizontalScrollView = cutomHorizontalSelectorView.createSelector(viewController:self, view: horizontalSelectorView, selectors: selectorsArray)
            horizontalSelectorView.addSubview(horizontalScrollView!)
            
            listContainerView.setNeedsLayout()
            listContainerView.layoutIfNeeded()
            tableViewScrollView = customContainerTableViews.createContainerTableViews(viewController: self,view: listContainerView, nibNames: nibsNameArray, cellIdentifiers:cellIdentifierArray)
            listContainerView.addSubview(tableViewScrollView!)
            
            for tableView in customContainerTableViews.tableViewsArray {
                if tableView.tag != 0 {
                    let myIndicator:UIActivityIndicatorView = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                        tableView.tableFooterView = myIndicator
                        myIndicator.startAnimating()
                        tableView.tableFooterView?.isHidden = false
                }
            }
        }
    }
// MARK:- init
    func initLayout(){
        //將整個畫面往下挪一個距離 避免navigationBar擋到元件
        containerView_TopSpace.constant = containerView_TopSpace.constant+self.navigationController!.navigationBar.bounds.size.height
    }
    func initData(){
        SwiftSpinner.show(LocalizationManagerTool.getString(key: "API_Requesting", tableSet: nil), animated: true)
        requestVideoCategories()
        requestMostPopularVideos(videoCategoryId: "", pageToken: "") //在主頁面 取出全部類型的影片
        requestMyLikedVideos(pageToken: "")
    }

// MARK:- API Request
    func requestVideoCategories(){
        APIManagerTool.requestVideoCategories { (response) in
            if self.youtubeMainViewModel == nil {
                self.youtubeMainViewModel = YoutubeMainViewModel()
            }
            //取得分類影片
            self.youtubeMainViewModel!.videoCatrgoriesModel = response
            self.customContainerTableViews.reloadTableViews(index: TableViewsEnumType.videoCategories.rawValue)
            self.alreadyRequestList += 1
            if self.alreadyRequestList >= self.requiredAPIListed{
                SwiftSpinner.hide()
            }
        }
    }
    func requestMostPopularVideos(videoCategoryId videoCategoryIdGet:String, pageToken pageTokenGet:String){
        if self.youtubeMainViewModel == nil {
            self.youtubeMainViewModel = YoutubeMainViewModel()
        }
        //取得熱門影片
        APIManagerTool.requestMostPopularVideos(videoCategoryId: videoCategoryIdGet, pageToken: pageTokenGet) { (response) in
            self.youtubeMainViewModel?.mostPopularVideosItemArray += response.items!
            self.youtubeMainViewModel!.mostPopularVideosModel = response
            self.customContainerTableViews.reloadTableViews(index: TableViewsEnumType.videoMostPopular.rawValue)
            self.alreadyRequestList += 1
            if self.alreadyRequestList >= self.requiredAPIListed{
                SwiftSpinner.hide()
            }
        }
    }
    func requestMyLikedVideos(pageToken pageTokenGet:String){
        if self.youtubeMainViewModel == nil {
            self.youtubeMainViewModel = YoutubeMainViewModel()
        }
        APIManagerTool.requestMyLikeVideos(pageToken: pageTokenGet) { (response) in
            self.youtubeMainViewModel?.myLikedVideosItemArray += response.items!
            self.youtubeMainViewModel?.myLikedVideosModel = response
            self.customContainerTableViews.reloadTableViews(index: TableViewsEnumType.videoMyLiked.rawValue)
            self.alreadyRequestList += 1
            if self.alreadyRequestList >= self.requiredAPIListed{
                SwiftSpinner.hide()
            }
        }
    }

// MARK: - CustomeHorizontalSelectorViewDelegate
    func selectorClicked(index indexClicked: Int) {
        tableViewScrollView!.setContentOffset(CGPoint.init(x: ScreenWidth*CGFloat(indexClicked), y: 0), animated: true) //移動ScrollView的座標
    }
    
// MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch tableView.tag {
        case TableViewsEnumType.videoCategories.rawValue:
             return VideoCategoryViewCell.VideoCategoryViewCell_Hieght
        case TableViewsEnumType.videoMostPopular.rawValue:
            return VideosViewCell.VideosViewCell_Hieght
        case TableViewsEnumType.videoMyLiked.rawValue:
            return VideosViewCell.VideosViewCell_Hieght
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView.tag {
        case TableViewsEnumType.videoCategories.rawValue:
            print("videoCategories")
            break
        case TableViewsEnumType.videoMostPopular.rawValue:
             self.delegate?.didYoutubeMainViewController(withObject: ["youtubeItemModel":(youtubeMainViewModel?.mostPopularVideosModel.items?[indexPath.row])!], event: .YoutubeMainViewControllerEvent_ToVideo)
            break
        case  TableViewsEnumType.videoMyLiked.rawValue:
            self.delegate?.didYoutubeMainViewController(withObject: ["youtubeItemModel":(youtubeMainViewModel?.myLikedVideosModel.items?[indexPath.row])!], event: .YoutubeMainViewControllerEvent_ToVideo)
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor.clear
    }
// MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            switch tableView.tag {
                case TableViewsEnumType.videoCategories.rawValue:
                    if youtubeMainViewModel?.videoCatrgoriesModel != nil {
                    return (youtubeMainViewModel!.videoCatrgoriesModel?.items?.count)!
                    }else{
                        return 0
                    }
                case TableViewsEnumType.videoMostPopular.rawValue:
                    if youtubeMainViewModel?.mostPopularVideosModel != nil {
                        return (youtubeMainViewModel!.mostPopularVideosModel?.items?.count)!
                    }else{
                        return 0
                    }
                case TableViewsEnumType.videoMyLiked.rawValue:
                    if youtubeMainViewModel?.myLikedVideosModel != nil {
                        return (youtubeMainViewModel!.myLikedVideosModel?.items?.count)!
                    }else{
                        return 0
                    }
                default:
                    return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if((youtubeMainViewModel) != nil){
            switch tableView.tag {
                case TableViewsEnumType.videoCategories.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: VideoCategoryViewCell.cellIdentifier) as! VideoCategoryViewCell
                    cell.viewCategoryViewCellModel = youtubeMainViewModel!.createViewCategoryViewCellModel(forIndex: indexPath.row)
                    return cell
                case TableViewsEnumType.videoMostPopular.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: VideosViewCell.cellIdentifier) as! VideosViewCell
                    //store cell object
                    mostPopularCellArray[indexPath.row] = cell
                    //create progressIndicatorView
                    youtubeMainViewModel!.createMostPopularProgressView(forIndex: indexPath.row, boundsGet: cell.thumbsNailImgView.frame)
                    //將Model的值經過處理後 拋給viewCell的viewModel
                    cell.VideosCellModel = youtubeMainViewModel!.createMostPupularVideosViewCellModel(forIndex: indexPath.row)
                    //圖片處理
                    ImageLoadTool.load_image_WithProgress(urlSet: cell.VideosCellModel.thumbnailsURL, viewController: self, index: indexPath.row)
                    if youtubeMainViewModel!.mostPopularVideoImageCacheArray[indexPath.row] != nil{
                        cell.VideosCellModel = youtubeMainViewModel!.createMostPupularVideosViewCellModel(forIndex: indexPath.row)
                    }
                    //判斷是否需要loading後面的資料
                    if ((youtubeMainViewModel?.mostPopularVideosItemArray.count)! - indexPath.row) < 10 {
                        if youtubeMainViewModel?.mostPopularVideosNextPageToken != "" {
                            requestMostPopularVideos(videoCategoryId: "", pageToken: (youtubeMainViewModel?.mostPopularVideosNextPageToken)!)
                        }else{
                            tableView.tableFooterView?.isHidden = true
                        }
                    }
                    return cell
                case TableViewsEnumType.videoMyLiked.rawValue:
                    let cell = tableView.dequeueReusableCell(withIdentifier: VideosViewCell.cellIdentifier) as! VideosViewCell
                    myLikedCellArray[indexPath.row] = cell
                    youtubeMainViewModel?.createMyLikedProgressView(forIndex: indexPath.row, boundsGet: cell.thumbsNailImgView.frame)
                    cell.VideosCellModel = youtubeMainViewModel!.createMyLikeVideosViewCellModel(forIndex: indexPath.row)
                    ImageLoadTool.load_image_WithProgress(urlSet: cell.VideosCellModel.thumbnailsURL, viewController: self, index: urlSessionIdentifierConst+indexPath.row)
                    if youtubeMainViewModel?.myLikedVideoImageCacheArray[indexPath.row] != nil {
                        cell.VideosCellModel = youtubeMainViewModel?.createMyLikeVideosViewCellModel(forIndex: indexPath.row)
                    }
                    if ((youtubeMainViewModel?.myLikedVideosItemArray.count)! - indexPath.row) < 10 {
                        if youtubeMainViewModel?.myLikedVideosNextPageToken != "" {//如果為空白 代表沒有下一頁了
                            requestMyLikedVideos(pageToken: (youtubeMainViewModel?.myLikedVideosNextPageToken)!)
                        }else{
                            tableView.tableFooterView?.isHidden = true
                        }
                    }
                    return cell
                default:
                    return UITableViewCell.init()
            }
        }else{
            return UITableViewCell.init()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //如果是TableView 根據手勢來隱藏和顯示tabBar
        if scrollView is UITableView {
            if (previousOffset_Vertical > scrollView.contentOffset.y) &&
                previousOffset_Vertical < (scrollView.contentSize.height - scrollView.frame.height) {
                 tabBarHideShow.showTabBar()
            }
            else if (previousOffset_Vertical < scrollView.contentOffset.y
                && scrollView.contentOffset.y > 0) {
                 tabBarHideShow.hideTabBar()
            }
         previousOffset_Vertical = scrollView.contentOffset.y
        }else {
            switch scrollView.tag {
            case ScrollViewEnumType.container.rawValue:
                //減2的原因是因為移動到最後一頁的狀況 就不要連動功能選單
                if previousOffset_Horizontal < ScreenWidth * CGFloat((selectorsArray.count-2)) {
                    horizontalScrollView?.setContentOffset(CGPoint.init(x: previousOffset_Horizontal/2 , y: 0), animated: true)
                }
                previousOffset_Horizontal = scrollView.contentOffset.x
                //更換被選到的水平選單按鈕的顏色
                cutomHorizontalSelectorView.refreshBtnState(index: Int(scrollView.contentOffset.x/ScreenWidth))
                break
            default:
                break
            }
        }
    }

// MARK:- URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        let progressGet = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        if( downloadTask.taskIdentifier < urlSessionIdentifierConst){
            let indicator =  youtubeMainViewModel!.mostPopularProgressViewArray[downloadTask.taskIdentifier] as? CircularLoaderView
            indicator?.progress = progressGet
        }else{
            let indicator = youtubeMainViewModel?.myLikedProgressViewArray[downloadTask.taskIdentifier-urlSessionIdentifierConst] as? CircularLoaderView
            indicator?.progress = progressGet
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
        do{//有throws的function 需要放在do blocks內部
            let data = try? Data.init(contentsOf: location)
            let image = UIImage.init(data: data!)
            
            if(downloadTask.taskIdentifier < urlSessionIdentifierConst){
                if youtubeMainViewModel!.mostPopularVideoImageCacheArray[downloadTask.taskIdentifier] == nil {
                        self.youtubeMainViewModel!.mostPopularVideoImageCacheArray[downloadTask.taskIdentifier] = image //暫存圖片
                        DispatchQueue.main.async { //注意 要修改UI的動作 須在main quene裡執行
                            let cell =  self.mostPopularCellArray[downloadTask.taskIdentifier] as? VideosViewCell
                             cell?.VideosCellModel = self.youtubeMainViewModel!.createMostPupularVideosViewCellModel(forIndex: downloadTask.taskIdentifier)
                    }
                }
            }else{
                let trueIndex = downloadTask.taskIdentifier-urlSessionIdentifierConst
                if youtubeMainViewModel?.myLikedVideoImageCacheArray[trueIndex] == nil {
                    self.youtubeMainViewModel?.myLikedVideoImageCacheArray[trueIndex] = image
                    DispatchQueue.main.async {
                        let cell =  self.myLikedCellArray[trueIndex] as? VideosViewCell
                        cell?.VideosCellModel = self.youtubeMainViewModel!.createMyLikeVideosViewCellModel(forIndex: trueIndex)
                    }
                }
            }
        }//如果throws有定義回傳型別 必須要補上catch block 去 hnadle
    }

}
