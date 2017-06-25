//
//  BookStoreModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/23.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

struct Book {
    let name : String
    let cardCount : Int
    let progress : Float
}

class BookStoreModel{
    //[]代表陣列的宣告 裡面放入的參數則代表陣列的限制能放入的物件類型
    var books = MutableProperty([Book]())
}
