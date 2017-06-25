//
//  ArrayStringConversion.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/26.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation

class ArrayStringConversion{
    
    class func arrayToString(array arrayGet:[String]) -> String{
        var idsString = ""
        for videoIds in arrayGet{
            idsString += videoIds
            idsString += ","
        }
        let index = idsString.index(idsString.startIndex, offsetBy: idsString.characters.count-1)
        return idsString.substring(to: index)
    }
}
