//
//  ConstantDifinition.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/6.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

// Mark:- custom object singleton
//Model
let USERINFO = USERInfoModel.shareInstance()
//CustomView
let CustomNavigationBarItemTool = CustomNavigationBarItem.shareInstance()
let CustomAlertViewControllerTool = CustomAlertViewController.shareInstance()
//Manager
let APIManagerTool = APIManager.shareInstance()
let NavigationManagerTool = NavigationManager.shareInstance()
let LocalizationManagerTool = LocalizationManager.shareInstance()
//Tools
let DateStringFormatterTool = DateStringFormatter.shareInstance()
let ImageLoadTool = ImageLoad.shareInstance()

// Mark:- Constant Property
//MainScreen bounds
let ScreenWidth = UIScreen.main.bounds.size.width
//google API Key
let APIKey_Google = "AIzaSyAd0HVuVRV8ordT3BqYQ_RYpw-wE3TBbtk"
//google user image dimenstion
let userImageDimension = 40
//alert titile and message fontsize
let alertTitleFontSize = 22
let alertMessageFontSize = 16
let fontNameSet = "Times New Roman"
//horizontal selector title
let horizontalSelectorFontSize = 25
//youtube result max result
let defaultMaxResult = 25
//youtube date formate
let youtubeDateformat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
let localDateformat = "yyyy-MM-dd"
//youtube result part parameter type
let snippetPart = "snippet"
let contentDetailsPart = "contentDetails"
let statisticsPart = "statistics"
let repliesPart = "replies"
//URLSession identifier const  用來判斷為兩組不同的urlSession下載佇列
let urlSessionIdentifierConst = 50000
