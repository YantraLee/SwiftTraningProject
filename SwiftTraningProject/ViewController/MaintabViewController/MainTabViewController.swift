//
//  MainTabViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/19.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit

class MainTabViewController: UITabBarController {

    var tabBarCGsize : CGSize? //儲存tabBar的尺寸
    var tabBarCGPoint : CGPoint? //儲存tabBar的原始y座標
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initLayout()
       // self.addGesteureDetect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK:- 初始化tabBar的樣式
    func initLayout(){
        tabBarCGsize = CGSize.init(width: self.tabBar.frame.size.width, height: self.tabBar.frame.size.height)
        tabBarCGPoint = CGPoint(x:self.tabBar.frame.origin.x, y:self.tabBar.frame.origin.y)
        
        //修改tabBar的背景樣式
        self.tabBar.backgroundColor = UIColor.clear
        self.tabBar.backgroundImage = UIColorExtension.shareInstance().getImageFilledWithColor(size: tabBarCGsize!, color: UIColor.clear)
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.white
        //將tabBar加上半模糊的背景
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.frame = self.tabBar.bounds
        frost.alpha = 0.6
        self.tabBar.insertSubview(frost, at: 0)
        
        self.selectedIndex=0 //初始化選到的tab index
    }
//    //添加偵測滑動的手勢
//    func addGesteureDetect(){
//        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
//        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
//        upSwipe.direction = .up
//        downSwipe.direction = .down
//        
//        self.view.addGestureRecognizer(upSwipe)
//        self.view.addGestureRecognizer(downSwipe)
//    }

// MARK:- 點擊的事件
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //前兩個subview為bacground和blurView 故要從索引數2開始取
        let firstItemImageView = tabBar.subviews[2].subviews[0]
        let secondItemImageView = tabBar.subviews[3].subviews[0]
        
        switch item.tag {
        case TabEnumType.MarvelTab.rawValue:
            firstItemImageView.transform = CGAffineTransform.identity
            //製作旋轉的動畫
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
                let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                secondItemImageView.transform = rotation
            }, completion: nil)
            
        case TabEnumType.YoutubeTab.rawValue:
            secondItemImageView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
                let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                firstItemImageView.transform = rotation
            }, completion: nil)

        default:
            print("No Tab detected!!")
        }
    }

//// MARK:- 手勢滑動事件偵測
//    func handleSwipes(sender:UISwipeGestureRecognizer){
//        if(sender.direction == .up){//如果是上滑
//            UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseOut, animations: { 
//                () -> Void in
//                self.tabBar.frame = CGRect(x:self.tabBarCGPoint!.x, y:self.tabBarCGPoint!.y+200, width:self.tabBarCGsize!.width, height:self.tabBarCGsize!.height)
//            }, completion: nil)
//        }else if(sender.direction == .down){//如果是下滑
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
//                () -> Void in
//                self.tabBar.frame = CGRect(x:self.tabBarCGPoint!.x, y:self.tabBarCGPoint!.y, width:self.tabBarCGsize!.width, height:self.tabBarCGsize!.height)
//            }, completion: nil)
//        }
//    }
}

