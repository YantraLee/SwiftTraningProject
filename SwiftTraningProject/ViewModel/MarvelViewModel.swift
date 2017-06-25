//
//  MarvelViewModel.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/5/23.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

//重點: 在ViewModel不可以使用UIKit 否則便會干涉ViewController的角色 破壞MVVM的結構

import Foundation
import ReactiveSwift

class MarvelViewModel{
    
     let currentProgress = MutableProperty("2")
    
     init(withBookStore bookStore: BookStoreModel) {
        // Each time 'books' is updated on the store,  'currentProgress' is updated with the computed value
        currentProgress <~ bookStore.books.map { books in
            let progress = self.computeCurrentProgress(fromBooks: books)
            return "\(progress)"
        }
    }
    
    
    private func computeCurrentProgress(fromBooks books:[Book]) -> Float{
        var progress:Float = 0.0
        for book in books{
            progress += book.progress
        }
        return progress
    }
        
}
