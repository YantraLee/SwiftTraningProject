//
//  DateStringFormatter.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/21.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class DateStringFormatter {
    private static var mInstance : DateStringFormatter?
    
    //TODO: Singleton create
    static func shareInstance() -> DateStringFormatter{
        if (mInstance == nil) {
            mInstance=DateStringFormatter()
        }
        
        return mInstance!
    }
    
//Mark: - String To Date
    func stringToDate(dateString dateStr:String, format formatStr:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        return formatter.date(from: dateStr)!
    }
//Mark: - Date To String
    func dateToString(date dateData:Date, format formatStr:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStr
        return dateFormatter.string(from:dateData)
    }
//Mark: - String to String (change formate)
    func stringToString(dateString dateStr:String, format formatStr:String, toFormat toFormatStr:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        let fromDate = formatter.date(from: dateStr)!
        formatter.dateFormat = toFormatStr
        return formatter.string(from: fromDate)
    }
}
