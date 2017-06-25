//
//  VideosViewCell.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class VideosViewCell: UITableViewCell {
    
    static var cellIdentifier:String = "VideosViewCell"
    static var VideosViewCell_Hieght:CGFloat = 120
    //元件宣告
    @IBOutlet weak var thumbsNailImgView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var publishedDateTitle: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    //物件宣告
    var VideosCellModel : VideoViewCellModel!{
        didSet{
            self.mainTitleLabel.text = VideosCellModel.mainTitle
            self.publishedDateTitle.text = VideosCellModel.publishedAt
            self.channelTitleLabel.text = VideosCellModel.channelTitle
            self.viewCountLabel.text = VideosCellModel.viewCount
            //先移除之前的prgrogress indicator
          //  if mostPopularVideosCellModel.progressIndicatorView.isDescendant(of: self.thunbsNailImgView) {
                VideosCellModel.progressIndicatorView.removeFromSuperview()
          //  }
            //在判斷是否要顯示圖案 或是繼續顯示prgrogress indicatord
            self.thumbsNailImgView.image = nil
            if let image = VideosCellModel.thumbnailsImage{
                 self.thumbsNailImgView.image = image
            }else{
                self.thumbsNailImgView.addSubview(VideosCellModel.progressIndicatorView)
            }
           
        }
    }
    
}
