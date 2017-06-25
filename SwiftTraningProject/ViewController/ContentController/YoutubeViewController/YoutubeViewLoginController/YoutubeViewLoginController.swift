//
//  YoutubeViewLoginController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/6.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import SwiftSpinner

enum YoutubeViewLoginControllerEvent:Int{
    case YoutubeViewLoginControllerEvent_ToMain=0 //轉到主頁面
    
}

protocol YoutubeViewLoginControllerDelegate {
    func didYoutubeViewLoginController(withObject Dict:[String:AnyObject]?, event eventGet:YoutubeViewLoginControllerEvent)
}

class YoutubeViewLoginController: BaseViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    
    //UI宣告
    @IBOutlet weak var loginBtn: UIButton!
    //UI屬性宣告
    @IBOutlet weak var loginBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var loginBtnHeight: NSLayoutConstraint!
    //delegate宣告
    var delegate : YoutubeViewLoginControllerDelegate?
    //物件宣告
    var hideNavigationBar :Bool = true
    let youtubeLoginVM = YoutubeLoginViewModel()

// MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始相關參數資料
        initData()
        //初始畫面元件內容
        initLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(hideNavigationBar, animated: true)
         if(GIDSignIn.sharedInstance().hasAuthInKeychain()){//如果使用者已登入 就背景登入並轉頁
            youtubeLoginVM.clickable.value = false
            SwiftSpinner.show(duration: 1.0, title: LocalizationManagerTool.getString(key: "Gooogle_Loginging", tableSet: nil))
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
// MARK:- initData
    func initData(){
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
// MARK:- initLayout
    func initLayout(){
        loginBtnInit()
    }
    //初始化登入按鈕及其事件
    func loginBtnInit(){
        loginBtn=CustomButton.makeCustomBtn(button: loginBtn, content: LocalizationManagerTool.getString(key: "Youtube_Account_Login", tableSet: nil),fontSizeSet: 20, widthGet: loginBtnWidth, heightGet: loginBtnHeight )
        loginBtn.reactive.isEnabled <~ youtubeLoginVM.clickable; //綁定viewModel Value
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { (UIButton) in
            //重要！！ 必須在scope的參數中 送出要請求的權限內容
            GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/youtube","https://www.googleapis.com/auth/youtube.force-ssl","https://www.googleapis.com/auth/youtube.readonly","https://www.googleapis.com/auth/youtube.upload","https://www.googleapis.com/auth/youtubepartner","https://www.googleapis.com/auth/youtubepartner-channel-audit"];
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
// MARK:- GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error != nil){
            print(error.localizedDescription)
        }
         youtubeLoginVM.clickable.value = true //變化的數值要傳給MutableProperty value的屬性
        if(user != nil){//如果成功登入 就要轉頁
            //取得使用者相關資料
            youtubeLoginVM.getUserInfoData(userSet: user)
            
            SwiftSpinner.show(duration: 1.0, title: LocalizationManagerTool.getString(key: "Gooogle_Loginging", tableSet: nil))
            delegate?.didYoutubeViewLoginController(withObject: nil, event:
                .YoutubeViewLoginControllerEvent_ToMain)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
           print(user.description+" ; "+error.localizedDescription)
    }

// MARK:- GIDSignInUIDelegate    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!){
         youtubeLoginVM.clickable.value = false //變化的數值要傳給MutableProperty value的屬性
         self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
