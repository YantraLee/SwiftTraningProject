//
//  MarvelViewController.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/20.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class MarvelViewController: BaseViewController {
    
    @IBOutlet weak var marvelTestBtn: UIButton!
    @IBOutlet weak var marbelTestTF: UITextField!
    
    private var isValidUsername:Bool {
        return marbelTestTF!.text!.characters.count>3
    }
    
    private let signInService: DummySignInService = DummySignInService()
    
    //import MarviewModel
    var marvelViewModel : MarvelViewModel!
    //import UI
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var deleteProgressBtn: UIButton!
    
//TODO: life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//TODO: 初始化畫面元件
    func initLayout(){
        //初始化按鈕事件
       // marvelTestBtn.addTarget(self, action: #selector(marvelTestBtn_Press(button:)), for: .touchUpInside)
        
        //TextField Signal添加
//        marbelTestTF.reactive.continuousTextValues.map ({ text in
//            return text!.characters.count  //map會先轉變要回傳的value型態
//        }).filter({
//            characterCount in
//            return characterCount>3 //加上能夠回傳value的條件
//        }).observeValues { characterCount in
//            print(characterCount ?? "")
//        }
        
        let validUsernameSignal = marbelTestTF.reactive.continuousTextValues.map({
            text in
            return self.isValidUsername //先把回傳型別改成Bool
        })
        
        validUsernameSignal.map({
            isValidUsername in
            return isValidUsername ? UIColor.white : UIColor.yellow
        }).observeValues {
            backgroundColor in
             self.marbelTestTF.backgroundColor = backgroundColor
        }
        
        //將多個signal結合在一起 至少要兩個sgnal
        //左邊的參數代表要被bond的對象 右邊的參數代表要bond的來源  此符號為reactiveSwift的功能
        self.marvelTestBtn.reactive.isEnabled <~ Signal.combineLatest(validUsernameSignal,validUsernameSignal).map{ isValidUsername,isValidPasswordTwo in
            return isValidUsername && isValidPasswordTwo
        }
        
        //UIButton signal添加
//        marvelTestBtn.reactive.controlEvents(.touchUpInside).flatMap(FlattenStrategy.latest) {
//            (UIButton) -> Signal<Bool, NoError> in
//            self.createSignInSignal()
//        }.observeValues { (success) in
//             print("Sign in result: \(success)")
//        }
        
        //如果只用map 會把整個SignalProducer的物件傳回來
        marvelTestBtn.reactive.controlEvents(.touchUpInside).map {
            (UIButton) ->  SignalProducer<Bool, NoError> in
            self.createSignInSignal()
            }.observeValues {
                 print("Sign in result: \($0)")
            }
        //使用flatMap 會把SignalProducer裡面帶的信號值解析後回傳
        marvelTestBtn.reactive.controlEvents(.touchUpInside).flatMap(FlattenStrategy.latest) {
                (UIButton) -> SignalProducer<Bool, NoError> in
                self.createSignInSignal()
            }.observeValues { (success) in
                 print("Sign in result: \(success)")
            }
        
        var booksArray = [Book]()
        //初始化先將Books的陣列做填充
        //from 代表起始數字 ; to 代表終點數字減1的值
        //from一律以累加的方式達到to 故如果要由大道小 必須把by改成負數
        for _ in stride(from: 1, to: 10, by: 1){
            let book = Book(name: "fuck", cardCount:1 , progress:1.0)
            booksArray.append(book)
        }
        let bookStoreModel = BookStoreModel()
        bookStoreModel.books.value=booksArray
        marvelViewModel = MarvelViewModel(withBookStore: bookStoreModel)
        
        //將MutableProperty綁定到元件的value
        progressLabel.reactive.text <~ marvelViewModel.currentProgress
        deleteProgressBtn.reactive.controlEvents(.touchUpInside).observeValues { (UIButton) in
            booksArray.remove(at: 0)
            bookStoreModel.books.value=booksArray
        }
}

//TODO: 定義按鈕點擊事件
@objc func marvelTestBtn_Press(button:UIButton){
        
}
    
//TODO: 創建自定義的信號
    private func createSignInSignal() -> SignalProducer<Bool, NoError> {
        //使用pipe的方法創建信號  
        //signInSignal是output  observer是input
        //兩者成對存在
        let (signInSignal, observer) = Signal<Bool, NoError>.pipe()
        
        //SignalProducer具有創建信號(傳入signInSignal參數) 和添加副作用的功能
        let signInSignalProducer = SignalProducer<Bool, NoError>(signInSignal)
        
        self.signInService.signIn(withUsername: marbelTestTF.text!) {
            success in
            
            observer.send(value: success)
            observer.sendCompleted() //完整送出訊息後停止
        }
        
        return signInSignalProducer
    }
    
}

class DummySignInService {
    
    func signIn(withUsername username: String, completion: @escaping (Bool) -> Void) {
        let delay = 1.0 //delay一秒後執行
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            let success = (username == "user") //判斷參數是否為"user"
            
            completion(success) //將success的參數傳入
        }
    }
}
