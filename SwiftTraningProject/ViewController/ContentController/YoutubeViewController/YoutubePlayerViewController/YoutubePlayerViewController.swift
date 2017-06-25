//
//  YoutubePlayerViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/10.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import youtube_ios_player_helper
import SwiftSpinner



class YoutubePlayerViewController: UIViewController ,YTPlayerViewDelegate {
    
     //UI宣告
    @IBOutlet weak var playerView: YTPlayerView!

    //變數宣告的區域
    var videoID : String?
    var playerVars:[String:Int]! {
        return ["playsinline" : 1] //playsinline設為true 代表可以非全畫面播放
    }
    
// MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        initPlayer()
    }
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        NavigationManagerTool.getTabBarVC().tabBar.isHidden = true //隱藏tabBar
    }
    override func viewWillDisappear(_ animated: Bool) {
         AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
         NavigationManagerTool.getTabBarVC().tabBar.isHidden = false
    }
// MARK:- init
    func initPlayer() -> Void{
        playerView.delegate=self
        playerView.load(withVideoId: videoID!)
    }


// MARK:- YTPlayerViewDelegate
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
       return SwiftSpinner.show(LocalizationManagerTool.getString(key: "Video_Loading", tableSet: nil))
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        SwiftSpinner.hide()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted://未播放
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            break
        case .playing://播放中
            self.navigationController!.setNavigationBarHidden(true, animated: true)
            break
        case .paused:
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            break
        case .ended:
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            break
        default:
            print("UnKnown")
            break;
        }
    }
    
}
