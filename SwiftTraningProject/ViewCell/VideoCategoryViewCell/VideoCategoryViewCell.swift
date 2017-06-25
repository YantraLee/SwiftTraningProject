//
//  VideoCategoryViewCell.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/19.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class VideoCategoryViewCell: UITableViewCell {
    
    static var cellIdentifier:String = "VideoCategoryViewCell"
    static var VideoCategoryViewCell_Hieght:CGFloat = 80
    
    //UI宣告
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    //物件宣告
    var viewCategoryViewCellModel:ViewCategoryViewCellModel!{
        didSet{
            self.mainTitleLabel.text = viewCategoryViewCellModel.mainTitle
            self.subTitleLabel.text = viewCategoryViewCellModel.subTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
