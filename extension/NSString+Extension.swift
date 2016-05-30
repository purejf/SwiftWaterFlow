//
//  NSString+Extension.swift
//  extension
//
//  Created by Charles on 16/5/30.
//  Copyright © 2016年 Charles. All rights reserved.
//

import Foundation


extension NSString {
    
    func Timming() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func deleteString(str: String) -> String {
        
        if self.rangeOfString(str).location != NSNotFound {
            let mutableStr = self.mutableCopy()
            mutableStr.deleteCharactersInRange(self.rangeOfString(str))
            return mutableStr as! String
        }
        return self as String
    }
    
}