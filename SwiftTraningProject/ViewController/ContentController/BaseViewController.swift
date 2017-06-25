//
//  BaseViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var backGroundContainerView : UIView!
    @IBOutlet weak var backGroundView : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackGroundLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//TODO: 初始化繼承元件外觀
    func initBackGroundLayout() {
        //設定背景元件外觀
        self.backGroundContainerView.backgroundColor = UIColor.clear
        //製造半透明背景
        self.backGroundView.backgroundColor = UIColor.black
        self.backGroundView.alpha = 0.6
        
    }
}
