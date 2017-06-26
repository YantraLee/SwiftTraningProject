//
//  CommentThreadsViewCell.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class CommentThreadsViewCell: UITableViewCell {
    
    static var cellIdentifier:String = "CommentThreadsViewCell"
    static var VideosViewCell_Hieght:CGFloat = 120
    
    @IBOutlet weak var authorImgView: UIImageView!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var checkAllSubCommentsBtn: UIButton!
    
    var CommentsViewCellModel:CommentThreadsViewCellViewModel!{
        didSet{
            self.authorTitleLabel.text = CommentsViewCellModel.authorTitle
            self.commentDateLabel.text = CommentsViewCellModel.commentDate
            self.commentContentLabel.text = CommentsViewCellModel.commentContent
            
            replyBtn.isEnabled = CommentsViewCellModel.canReply
            if CommentsViewCellModel.canReply{
                replyBtn.setTitleColor(UIColor.white, for: .normal)
                replyBtn.setTitle(LocalizationManagerTool.getString(key: "Youtube_Video_Reply", tableSet: nil), for: .normal)
            }else{
                replyBtn.setTitleColor(UIColor.lightGray, for: .normal)
                replyBtn.setTitle(LocalizationManagerTool.getString(key: "Youtube_Video_Cannot_Reply", tableSet: nil), for: .normal)
            }
            
            checkAllSubCommentsBtn.setTitle(CommentsViewCellModel.totalReplyCount, for: .normal)
            checkAllSubCommentsBtn.isHidden = !CommentsViewCellModel.checkTotalReplyShow
            if CommentsViewCellModel.checkTotalReplyShow{
                checkAllSubCommentsBtn.setTitleColor(UIColor.white, for: .normal)
            }else{
                checkAllSubCommentsBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
            CommentsViewCellModel.progressIndicatorView.removeFromSuperview()
            
            self.authorImgView.image = nil
            if let image = CommentsViewCellModel.authorThumbNailImage{
                self.authorImgView.image = image
            }else{
                self.authorImgView.addSubview(CommentsViewCellModel.progressIndicatorView)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
