//
//  Date+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

extension Date {
    
    func getDateComponent(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getFormattedHour() -> String {
        let hour = getDateComponent(with: "h")
        let meridiem = Meridiem.init(rawValue: getDateComponent(with: "a"))
    
        switch meridiem {
        case .am:
            return "오전 \(hour)시"
        case .pm:
            return "오후 \(hour)시"
        case .none:
            return ""
        }
    }
    
    func getFormattedHM() -> String {
        let meridiem = Meridiem.init(rawValue: getDateComponent(with: "a"))
        let hm = getDateComponent(with: "h:m")
        
        switch meridiem {
        case .am:
            return "오전 \(hm)"
        case .pm:
            return "오후 \(hm)"
        case .none:
            return ""
        }
    }
    
    func getWeekDay() -> AppWeekday {
        guard let weekday = AppWeekday.init(rawValue: self.getDateComponent(with: "EEEE")) else { return AppWeekday.monday }
        return weekday
    }
    
}
