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

class YoutubeVideoViewController: BaseViewController{
    
    //UI宣告
    @IBOutlet weak var mainContentContainerView: UIView!
    @IBOutlet weak var commentContentContainerView: UIView!
    @IBOutlet weak var videoImgView: UIImageView!
    
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    
    //constraint宣告
    @IBOutlet weak var mainContainer_TopSpace: NSLayoutConstraint!
    
    //ViewModel宣告
    let youtubeVideoViewModel = YoutubeVideoViewModel()
    var likeBtnViewModel : RatingButtonViewModel?
    var dislikeBtnViewModel : RatingButtonViewModel?
    
    //property 
    var alreadyMoveDown : Bool = false
    
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
    }
// Mark: - init
    func initLayout(){
        //reactive binding
        videoImgView.reactive.image <~ youtubeVideoViewModel.videoThumbNail
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
        
        //button layout init
        likeBtn = CustomButton.makeCustomRatingBtn(button: likeBtn, content: LocalizationManagerTool.getString(key: "Youtube_Video_Like_Btn", tableSet: nil), fontSizeSet: 15)
        dislikeBtn = CustomButton.makeCustomRatingBtn(button: dislikeBtn, content: LocalizationManagerTool.getString(key: "Youtube_Video_DisLike_Btn", tableSet: nil), fontSizeSet: 15)
    }
    func initData(){
        requestVideosGetRating()
    }
// MARK: - IBAction
    func likeBtnClicked_Define(){
        likeBtn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
            APIManagerTool.requestVideosRate(id: self.youtubeVideoViewModel.youtubeItemModel.id, rating: self.likeBtnViewModel!.rating, completion: { (success) in
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
            APIManagerTool.requestVideosRate(id: self.youtubeVideoViewModel.youtubeItemModel.id, rating: self.dislikeBtnViewModel!.rating, completion: { (success) in
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
        APIManagerTool.requestVideosGetRating(id: [youtubeVideoViewModel.youtubeItemModel.id]) { (response) in
            if let youtubeItemRatingModel = response.items?[0] {
                //按鈕的viewModel綁定
                self.setRatingBtnStatus(ratingType: youtubeItemRatingModel.rating)
            }
            SwiftSpinner.hide()
        }
    }
    
    func requestVideoByIDList(){
        SwiftSpinner.show(LocalizationManagerTool.getString(key: "Data_Loading", tableSet: nil), animated: true)
        APIManagerTool.requestVideosByIDList(id: [youtubeVideoViewModel.youtubeItemModel.id]) { (response) in
            if let youtubeItemModel = response.items?[0] {
                self.youtubeVideoViewModel.youtubeItemModel = youtubeItemModel
            }
            SwiftSpinner.hide()
        }
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
