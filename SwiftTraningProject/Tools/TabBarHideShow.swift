//
//  TabBarHideShow.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class TabBarHideShow{
    
    let tabBar : UITabBar = NavigationManagerTool.getTabBarVC().tabBar
    
    //儲存tabBar的尺寸
    var tabBarCGsize : CGSize?    //儲存tabBar的原始y座標
    var tabBarCGPoint : CGPoint?
    
    init() {
        tabBarCGsize = CGSize.init(width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        tabBarCGPoint = CGPoint(x:tabBar.frame.origin.x, y:tabBar.frame.origin.y)
    }
    
    func hideTabBar(){
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseOut, animations: {
            () -> Void in
            self.tabBar.frame = CGRect(x:self.tabBarCGPoint!.x, y:self.tabBarCGPoint!.y+200, width:self.tabBarCGsize!.width, height:self.tabBarCGsize!.height)
        }, completion: nil)
    }
    
    func showTabBar(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            () -> Void in
            self.tabBar.frame = CGRect(x:self.tabBarCGPoint!.x, y:self.tabBarCGPoint!.y, width:self.tabBarCGsize!.width, height:self.tabBarCGsize!.height)
        }, completion: nil)
    }
}
