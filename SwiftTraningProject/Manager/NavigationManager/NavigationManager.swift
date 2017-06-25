//
//  NavigationManager.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager : NSObject, UIViewControllerTransitioningDelegate ,YoutubeViewLoginControllerDelegate,YoutubeMainViewControllerDelegate{
    
    //SigleTon宣告
    private static var mInstance : NavigationManager?
    
    //畫面VC宣告
    private var tabarVC : MainTabViewController?
    private var marvelViewControllerNav : UINavigationController?
    private var youtubeLoginViewControllerNav: UINavigationController?
    
//TODO: Singleton create
    static func shareInstance() -> NavigationManager{
        if (mInstance == nil) {
            mInstance=NavigationManager()
            mInstance!.createTabBar()
        }
        
        return mInstance!
    }

//TODO: tabarView Create
    func createTabBar(){
        //create tabBar item 
        let marvelViewController = MarvelViewController()
        marvelViewController.tabBarItem = UITabBarItem.init(title: LocalizationManagerTool.getString(key: "Marvel_Tab", tableSet: nil), image: UIImage.init(named: "saber_tab_unclick"), selectedImage:  UIImage.init(named: "saber_tab_click"))
        marvelViewController.tabBarItem.tag = 0
        marvelViewControllerNav = UINavigationController.init(rootViewController: marvelViewController)
        
        
        let youtubeLoginViewController = YoutubeViewLoginController()
        youtubeLoginViewController.tabBarItem = UITabBarItem.init(title: LocalizationManagerTool.getString(key: "Youtube_Tab", tableSet: nil), image: UIImage.init(named: "shiki_tab_unclick"), selectedImage: UIImage.init(named: "shiki_tab_click"))
        youtubeLoginViewController.delegate = self
        youtubeLoginViewController.tabBarItem.tag = 1
        youtubeLoginViewControllerNav = UINavigationController.init(rootViewController: youtubeLoginViewController)
        
        //tabBarViewController initiate
        tabarVC = MainTabViewController()
        tabarVC!.viewControllers=[marvelViewControllerNav!,youtubeLoginViewControllerNav!]
    }

//TODO: 回傳建好的tabBarVC
    func getTabBarVC() -> MainTabViewController{
        return tabarVC!
    }

//TODO: UIViewControllerAnimatedTransitioning delegate
   
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let transitioning = Animations()
        transitioning.transitioningType = FadeTransitioningType.FadeVCTransitioningPresent
        return transitioning
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         let transitioning = Animations()
        transitioning.transitioningType = FadeTransitioningType.FadeVCTransitioningDismiss
        return transitioning
    }

//TODO: pushViewController 自定方法
    func pushViewController(VC viewController:UIViewController, tabType tabTypeSet:TabEnumType, animated animatedSet:Bool){
        var nav : UINavigationController?
        switch tabTypeSet {
        case .MarvelTab:
            nav = marvelViewControllerNav!
            break
        case .YoutubeTab:
            nav = youtubeLoginViewControllerNav!
            break
        }
        
        if(nav != nil){
            tabarVC!.selectedViewController = nav
            //加上客製的轉場動畫
            viewController.modalPresentationStyle = UIModalPresentationStyle.custom
            viewController.transitioningDelegate = self
            nav?.pushViewController(viewController, animated: true)
        }
    }
 
//TODO: YoutubeViewLoginControllerDelegate
    func didYoutubeViewLoginController(withObject Dict:[String:AnyObject]?, event eventGet:YoutubeViewLoginControllerEvent){
        switch eventGet {
            case .YoutubeViewLoginControllerEvent_ToMain:
               let youtubeMainViewController = YoutubeMainViewController()
               youtubeMainViewController.delegate=self
            pushViewController(VC: youtubeMainViewController, tabType: .YoutubeTab, animated: true)
            break
        }
    }
    
    
//TODO:YoutubeMainViewControllerDelegate
    func didYoutubeMainViewController(withObject Dict:[String:AnyObject]?, event eventGet:YoutubeMainViewControllerEvent){
        switch eventGet {
        case .YoutubeMainViewControllerEvent_ToPlayer:
          let youtubePlayerViewController = YoutubePlayerViewController()
          youtubePlayerViewController.videoID = Dict?["VideoID"] as? String
          pushViewController(VC: youtubePlayerViewController, tabType: .YoutubeTab, animated: true)
        break
        case .YoutubeMainViewControllerEvent_ToVideo:
            let youtubeVideoViewController = YoutubeVideoViewController()
            youtubeVideoViewController.youtubeVideoViewModel.youtubeItemModel = Dict?["youtubeItemModel"] as? YoutubeItemModel
            pushViewController(VC: youtubeVideoViewController, tabType: .YoutubeTab, animated: true)
        break
        }
    }

}

