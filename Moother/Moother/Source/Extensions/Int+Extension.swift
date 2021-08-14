//
//  Int+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/14.
//

import Foundation

extension Int {
    
    func convertToUTCTime() -> Date {
        return NSDate(timeIntervalSince1970: TimeInterval(self)) as Date
    }
    
    func convertToKm() -> Double {
        return Double(self) / Double(1000)
    }
    
}
